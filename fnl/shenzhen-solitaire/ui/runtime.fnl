(tset package.loaded :shenzhen-solitaire.ui.frame-buffer nil)
(tset package.loaded :shenzhen-solitaire.ui.card nil)
(tset package.loaded :shenzhen-solitaire.ui.view nil)
(tset package.loaded :shenzhen-solitaire.game.logic nil)
(tset package.loaded :shenzhen-solitaire.game.deck nil)

(import-macros {: use} :shenzhen-solitaire.lib.donut.use)

(use {: range} :shenzhen-solitaire.lib.donut.iter :ns iter
     {: inspect : inspect!} :shenzhen-solitaire.lib.donut.inspect
     {: nil?} :shenzhen-solitaire.lib.donut.type
     {:format fmt} string
     E :shenzhen-solitaire.lib.donut.enum
     R :shenzhen-solitaire.lib.donut.result
     logic :shenzhen-solitaire.game.logic
     ui-view :shenzhen-solitaire.ui.view)

(local path-separator (string.match package.config "(.-)\n"))
(lambda join-path [head ...]
  (accumulate [t head _ part (ipairs [...])]
    (.. t path-separator part)))
(local win-count-path (join-path (vim.fn.stdpath :cache) :shenzhen-solitaire.wins))

(local M {})
(local m {})

(fn m.find-interactable-cards [state]
  "Find any locations we can pick up or put down, if we have cards in hand."
  (fn all-possible-pickup-locations []
    ;; for pickup we want to check every card on the table
    (E.flat-map [:tableau :cell :foundation]
                (fn [_ slot]
                  (E.flat-map (. state slot)
                              (fn [col-n col]
                                (E.map col (fn [card-n]
                                             [slot col-n card-n])))))))
  (fn all-possible-putdown-locations []
    ;; for put down we need to check the card positions *after* the last card
    ;; in every slotxcol, as well as any 1 1 of empty columns.
    (let [head-or-tail (fn [slot col-n]
                         (match (. state slot col-n)
                           (where col (<= 1 (length col))) [slot col-n (+ 1 (length col))]
                           (where col (= 0 (length col))) [slot col-n 1]))]
      (-> []
          (E.concat$ (E.map #(iter/range 1 8) #(head-or-tail :tableau $1)))
          (E.concat$ (E.map #(iter/range 1 4) #(head-or-tail :foundation $1)))
          (E.concat$ (E.map #(iter/range 1 3) #(head-or-tail :cell $1))))))
  ;; get possible locations, try and interact and drop any that aren't
  ;; good then unpack to just the location
  (-> (match state.hand
        [nil] (E.map (all-possible-pickup-locations)
                     #[(logic.collect-from-ok? state $2) $2])
        cards (E.map (all-possible-putdown-locations)
                     #[(logic.can-place-ok? state $2 cards) $2])
        _ (error "internal-error: find-interactable-cards state.hand was unmatched"))
      (E.filter #(match $2 [[:ok] _] true))
      (E.map #(match $2 [_ location] location))))

(fn m.find-interactable-buttons [state]
  (-> (E.map [:DRAGON-RED :DRAGON-GREEN :DRAGON-WHITE]
             #[(R.ok? (logic.lock-dragons-ok? state $2)) [:BUTTON 1 $1]])
      (E.filter #(. $2 1))
      (E.map #(match $2 [_ loc] loc))))

(fn m.update [game]
  (if game.config.difficulty.auto-move-obvious
    ;; make every auto-move we can in one go for mow
    (while (R.ok? (logic.auto-move-ok? game.state.pure))
      (let [[_ {: from : to}] (logic.auto-move-ok? game.state.pure)
            pure (logic.move-cards game.state.pure from to)
            dirty (m.pure-state->dirty-state pure)]
        (doto game.state
          (tset :pure pure)
          (tset :dirty dirty)))))

  (if (not (R.ok? (logic.win-game-ok? game.state.pure)))
    (doto game.locations
      ;; TODO sort all into one list for prev/next tabbing
      ;; Check card interactions against dirty, as it depends on what is in
      ;; hand, but check buttons against pure as picking up a card in dirty
      ;; may falsely imply that a button is interactable.
      (tset :cards (m.find-interactable-cards game.state.dirty))
      (tset :buttons (m.find-interactable-buttons game.state.pure)))
    (let [readable? (= 1 (vim.fn.filereadable win-count-path))
          win-count (if readable? (+ (dofile win-count-path) 1) 1)]
      (with-open [fout (io.open win-count-path :w)]
        (fout:write (fmt "return %d" win-count)))
      (doto game.meta
        (tset :won? true)
        (tset :wins win-count))
      ;; dont allow interactions if we're finished, except the new game button
      (doto game.locations
        (tset :card [])
        (tset :buttons [])))) ;; TODO new-game button

  ;; needed for consistent next-location interaction
  (set game.locations.flattened (m.locations->nextable-locations game.locations))

  (let []
    ;; TODO sort & ins-filter hand-from
    (ui-view.update game.view {:state game.state.dirty
                               :locations game.locations
                               :meta game.meta}))
  (values game))

(fn m.draw [game]
  (let [{: view :state {: dirty}} game]
    (ui-view.draw view dirty))
  nil)

(fn shift-location [game event direction]
  ;; see if cursor is curently on valid location, if so, go to next (or loop)
  ;; if not, go to first.
  (let [{:locations {: cursor :flattened locations}} game
        [cursor-slot cursor-col-n cursor-card-n] cursor
        current-index (accumulate [f nil i location (ipairs locations) :until f]
                        (match location [cursor-slot cursor-col-n cursor-card-n] i))
        len-locations (length locations)
        next-index (match [direction current-index]
                     [:next nil] 1
                     (where [:next i] (= i len-locations)) 1
                     [:next i] (+ i 1)
                     [:prev nil] len-locations
                     (where [:prev i] (= i 1)) len-locations
                     [:prev i] (- i 1))
        new-location (match locations
                       [nil] cursor
                       list (. locations next-index))]
    (tset game :locations :cursor new-location)
    (values game)))

(fn m.next-location [game event]
  (shift-location game event :next))
(fn m.prev-location [game event]
  (shift-location game event :prev))

; (fn m.left-mouse [game event]
;   ;; When we write out to the hit buffer, we currently don't do any special
;   ;; processing, so while a valid put down location might be [t 1 2], with a
;   ;; card at [t 1 1], the hit buffer can only detect a click on [t 1 1].
;   ;; This means we have to do some special checks around whether the position
;   ;; after or before the click location are valid locations to interact with.
;   (let [{: location} event
;         {: hand} game.game-state
;         [click-slot click-col click-card] location
;         holding? (match hand [nil] false [cards] true)
;         ;; as above, hit locations are "as rendered" but we want to check the
;         ;; card after that, with the exception of empty positions which, as a
;         ;; shortcut in the view, report the same location as the first would-be
;         ;; card in the slot. We check if there is actually any cards where we
;         ;; clicked - if there is, check the next location, if none, we actually
;         ;; want the directly clicked location.
;         clicked-empty? (nil? (?. game.game-state click-slot click-col click-card))
;         next-card (if clicked-empty? click-card (+ click-card 1))
;         ;; check every valid location against this function, which should
;         ;; filter the valid locations to either one location or zero. If we
;         ;; have one we can move the cursor there and act as if we got a normal
;         ;; interact event.
;         matches-click-location? (match [click-slot holding?]
;                                   ;; we clicked the tableau but have no hand,
;                                   ;; so we want to check if the click location
;                                   ;; is directly vald, which means we can pick
;                                   ;; up from there.
;                                   [:tableau false] #(match $2 [click-slot click-col click-card] true)
;                                   ;; We clicked the tableau with cards in hand,
;                                   ;; this means we want to put down cards and must
;                                   ;; actually check the position *after* what we clicked
;                                   ;; the position after was never draw and is un-clickable,
;                                   ;; while also being an invalid put-down location.
;                                   [:tableau true] #(match $2 [click-slot click-col next-card] true)
;                                   ;; foundation shows last card but place after it
;                                   [:foundation true] #(match $2 [click-slot click-col next-card] true)
;                                   ;; cells only one card so dont adjust
;                                   [_ _] #(match $2 [click-slot click-col click-card] true))
;         ;; of all the valid locations, does the click location match one?
;         cursor (-> (E.filter game.game-state.valid-locations matches-click-location?)
;                    (E.hd))]
;     (when cursor
;       (set game.game-state.cursor cursor)
;       (m.interact game event))))

; (fn m.holding? [game-state]
;   (match game-state.hand
;     [nil] (values false)
;     [cards] (values true cards)))

; (fn m.right-mouse [game event]
;   ;; if we have cards in hand, move the cursor back to where they came
;   ;; from and trigger the place-cards handlers
;   (when (m.holding? game.game-state)
;     (set game.meta-state :cursor 
;     (set game.game-state (m.pure-state->dirty-state game.logic-state))))

    
;   (let [{: location} event
;         {: hand : hand-from} game.game-state
;         holding? (match hand [nil] false [cards] true)]
;     (when holding?
;       (set game.game-state.cursor hand-from)
;       (m.interact game event))))

; (fn m.auto-move [game event]
;   (let [{: game-state : logic-state} game]
;     (match (logic.auto-move-ok? logic-state)
;       [:ok {: from : to}] (let [logic-state (logic.move-cards logic-state from to)
;                                 game-state (m.update-game-state-with-logic-state game-state logic-state)]
;                             (doto game
;                               (tset :game-state game-state)
;                               (tset :logic-state logic-state)))))
;   (values game))

; (fn m.interact [game event]
;   (let [{: game-state : logic-state} game
;         {: cursor : hand : hand-from} game-state]
;     ;; TODO HACK button hack ...
;     (match [hand cursor]
;       [_ [:LOCK-DRAGON 1 button]] (let [which (match button 1 :DRAGON-RED 2 :DRAGON-GREEN 3 :DRAGON-WHITE)]
;                                     (match (logic.lock-dragons-ok? logic-state which)
;                                       [:ok {: to}]
;                                       (let [new-logic-state (logic.lock-dragons logic-state which)
;                                             new-game-state (m.update-game-state-with-logic-state game-state new-logic-state)]
;                                         (tset new-game-state :cursor to)
;                                         (doto game
;                                           (tset :game-state new-game-state)
;                                           (tset :logic-state new-logic-state)))
;                                       [:err e] (error e)))
;       ;; pick up is checked against logic state as we have had no effect yet
;       [[nil] _] (match (logic.collect-from-ok? logic-state cursor)
;                   [:ok] (let [[slot col-n card-n] cursor
;                               (rem hand) (E.split (. game-state slot col-n) card-n)]
;                           (tset game-state slot col-n rem)
;                           (tset game-state :hand [hand])
;                           (tset game-state :hand-from cursor)
;                           (tset game :game-state game-state))
;                   [:err e] (error e))
;       ;; place is checked against game state as we have technically altered it
;       ;; kinda ugly hack so we can place back where we picked up even if it
;       ;; makes an invalid sequence
;       [[cards] _] (match [cursor hand-from (logic.can-place-ok? game-state cursor cards)]
;                     ;; trying to put down where we picked up, don't do any checks, just revert the state
;                     [[s cl cd] [s cl cd] _]
;                     (let [game-state (doto game-state
;                                        (tset :hand [])
;                                        (tset :hand-from []))
;                           new-game-state (m.update-game-state-with-logic-state game-state logic-state)]
;                       (tset game :game-state new-game-state))
;                     ;; otherwise can we move?
;                     [_ _ [:ok]]
;                     (let [{: hand-from} game-state
;                           new-logic-state (logic.move-cards logic-state hand-from cursor)
;                           new-game-state (m.update-game-state-with-logic-state game-state new-logic-state)]
;                       (tset new-game-state :hand [])
;                       (tset new-game-state :hand-from [])
;                       (doto game
;                         (tset :game-state new-game-state)
;                         (tset :logic-state new-logic-state)))
;                     ;; hard error here, ui shouldn't request bad things
;                     [_ _ [:err e]] (error e)))
;     (values game)))

; (fn m.save-game [game event]
;   (let [save-file (join-path (vim.fn.stdpath :cache) :shenzhen-solitaire.save)]
;     (with-open [fout (io.open save-file :w)]
;       (fout:write (vim.mpack.encode game.logic-state.events))
;       (vim.notify "Saved game"))))

; (fn m.load-game [game event]
;   (let [save-file (join-path (vim.fn.stdpath :cache) :shenzhen-solitaire.save)
;         readable (= 1 (vim.fn.filereadable save-file))]
;     (if readable
;       (with-open [fin (io.open (.. save-file))]
;         (let [bytes (fin:read :*a)
;               events (vim.mpack.decode bytes)
;               new-logic-state (E.reduce events (logic.S.empty-state) #(logic.S.apply $1 $3))
;               new-game-state (m.update-game-state-with-logic-state {:wins game.game-state.wins}
;                                                                    new-logic-state)]
;           (tset game :logic-state new-logic-state)
;           (tset game :game-state new-game-state)))
;       (error "Could not open save file, probably doesn't exist"))))

; (fn m.restart-game [game event]
;   ;; roll back to first move
;   (let [{: events} game.logic-state
;         events (accumulate [(initial-events stop?) (values [] false)
;                             _ event (ipairs events) :until stop?]
;                  (match event
;                    [:moved-cards] (values initial-events true)
;                    _ (values (E.append$ initial-events event) false)))
;         new-logic-state (E.reduce events (logic.S.empty-state) #(logic.S.apply $1 $3))
;         new-game-state (m.update-game-state-with-logic-state {:wins game.game-state.wins}
;                                                              new-logic-state)]
;        (tset game :logic-state new-logic-state)
;        (tset game :game-state new-game-state)))

(fn m.undo-last-move [game event]
  (if game.config.difficulty.allow-undo
    ;; roll back to first move
    (let [{: events} game.state.pure
          ;; HACK hardcoded limit of 3 for new, shuffle, deal events
          events (E.map #(iter/range 1 (math.max 3 (- (length events) 1))) #(. events $1))
          pure (E.reduce events (logic.S.empty-state) #(logic.S.apply $1 $3))
          dirty (m.pure-state->dirty-state pure)]
      (doto game.state
        (tset :pure pure)
        (tset :dirty dirty))
     (vim.notify "Undo not enabled, see difficulty.allow-undo"))))

;; TODO: have this be ...
;; game-state which is logic-state + hand modification (maybe hand from?)
;; additionally have meta-data meta-state with wins, won? valid-locations? (interaction-locations?)
;; also add setformat opts for fennel ft

;; The goal: allow gs<-logic-state to be slimmer, not have to pass wins all the time, etc

; (fn m.update-game-state-with-logic-state [game-state logic-state]
;   "game-state is a mutation on the logic state with some parital changes
;   applied for picking up cards, as well as tracking additional information such
;   as cursor position, valid moves, cards-in-hand-or-not etc."
;   (let [new-game-state (logic.S.clone-state logic-state)]
;     (doto new-game-state
;       (tset :wins (or game-state.wins 0))
;       (tset :won? (or game-state.won? false))
;       (tset :cursor (or game-state.cursor [:tableau 1 5]))
;       (tset :hand (or game-state.hand []))
;       (tset :hand-from (or game-state.hand-from []))
;       (tset :lockable-dragons (or game-state.lockable-dragons []))
;       (tset :valid-locations (or game-state.valid-locations [])))))

(fn m.pure-state->dirty-state [logic-state]
  "Accept a logic state and attach new play related data to it"
  (doto (logic.S.clone-state logic-state)
    ;; hand acts as another slot, so it is empty or has cards in it
    (tset :hand [])))

(fn m.locations->nextable-locations [locations]
  "Given the map of all location data, parse the useful ones and sort into a
  flat list so we can tab through the locations in a consistent order"
  (let [;; we know these are good locations, cards and buttons
        flat (E.concat$ [] locations.cards locations.buttons)
        ;; we also want to insert the hand-from location as a valid tabbable
        ;; but only if it's not already in the list which may occur if we
        ;; picked up mid sequence.
        flat (match locations.hand-from
               ;; no hand from, so nothing done
               nil flat
               ;; have hand, so check if it's in the list and insert or not
               [h-slot h-col h-card]
               (if (E.reduce locations.cards true #(match $3 [h-slot h-col h-card] false _ $1))
                 (E.append$ flat locations.hand-from)
                 (values flat)))]
    (E.sort$ flat (fn [[slot-1 col-1 card-1] [slot-2 col-2 card-2]]
                    (let [slot-val {:tableau 1000 :cell 2000 :foundation 3000 :BUTTON 10000}
                          a [(. slot-val slot-1) col-1 card-1]
                          b [(. slot-val slot-2) col-2 card-2]]
                      (match [a b]
                        [[s c x] [s c y]] (< x y)
                        [[s x _] [s y _]] (< x y)
                        [[x _ _] [y _ _]] (< x y)))))))

(fn M.start-new-game [buf-id first-responder config ?seed]
  "Generate a fresh game and return a coroutine which will handle events when resumed"
  (fn setup []
    ;; The first-responder requires a coroutine thread as its first
    ;; argument, so we encapsulate the actual setup work inside a
    ;; function so we can access our own thread.
    (local game {})
    (let [responder (let [t (coroutine.running)] #(first-responder t $...))
          win-count (match (pcall dofile win-count-path) (true n) n (false e) 0)
          pure (logic.start-new-game ?seed)
          dirty (m.pure-state->dirty-state pure)
          meta {:won? false
                :wins win-count}
          view (ui-view.new {: buf-id
                             : responder
                             : meta
                             :state dirty
                             : config})]
      (doto game
        (tset :view view)
        (tset :config config)
        (tset :state {: pure : dirty})
        (tset :meta {:won? false
                     :wins win-count})
        (tset :locations {:cursor [:tableau 1 5] ;; TODO actually infer a "best start" this from data
                          :hand-from nil
                          :cards (m.find-interactable-cards dirty)
                          :buttons (m.find-interactable-buttons pure)})
        (m.update)
        (m.draw)))

    (fn loop [...]
      ;; we dont want errors in the game code to totally kill the game coroutine
      ;; because that means the game cant be continued or saved, etc, so
      ;; we'll pcall the event handers and do some fiddle work to make it look like
      ;; an error to the caller if required.
      (let [result (-> (match [...]
                         [:control :hello] (values true :hello!)
                         [:config :goodbye] (values true :goodbye!)
                         [:event event] (let [{: name} event
                                              f (or (. m name) #(error (fmt "No handler for %s" name)))]
                                          (match (pcall f game event)
                                            (false err) (values nil err)
                                            (true data) (values data)))
                         any (values nil (fmt "runtime did not know how to handle message %s" (inspect any))))
                       (R.unit))
            and-then (match result
                       ;; dont recurse
                       [:ok :goodbye] #(vim.notify :Goodbye!)
                       [:ok] (do
                               (m.update game)
                               (m.draw game)
                               (values loop))
                       [:err e] (values loop))]
        (and-then (coroutine.yield result))))
    ;; start the loop which will do noting and yield
    (loop :control :hello))
  (coroutine.create setup))

(values M)
