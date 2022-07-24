;;; UI Runtime should
;;;
;;; - handle user input events
;;; - start new games
;;; - manage the inter-mux between the logic state and the ui state
;;;
;;; Maybe also
;;; - load games
;;;
;;;
;;; Re muxing, the logic state is a pure view of the game, it exists and can
;;; move cards between places, but has no concept of "picking up" cards or
;;; "hovering cards in a column for selection" or "moving cards temporarily".
;;;
;;; Because of this, we have a ui-game-state which should start with a clone of
;;; the logic state and then apply any ui-only related changes. This might mean
;;; having a :hand {} table and removing those cards from a column or cell so the
;;; renderer reflects the correct state.

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

(local M {})
(local m {})

(fn m.generate-valid-locations [game-state]
  "Given a game state, find all board locations that the user may interact with.
  This is dictated by some game-state such as whether cards are in-hand or not
  and includes buttons."
  (fn all-possible-pickup-locations [game-state]
    ;; for pickup we want to check every card on the table
    (let [fm E.flat-map
          map E.map]
      (fm [:tableau :cell :foundation]
          (fn [_ slot]
            (fm (. game-state slot)
                (fn [col-n col]
                  (map col (fn [card-n]
                             [slot col-n card-n]))))))))
  (fn all-possible-putdown-locations [game-state]
    ;; for put down we need to check the card positions *after* the last card
    ;; in every slotxcol, as well as any 1 1 of empty columns.
    (let [head-or-tail (fn [slot col-n]
                         (match (. game-state slot col-n)
                           (where col (<= 1 (length col))) [slot col-n (+ 1 (length col))]
                           (where col (= 0 (length col))) [slot col-n 1]))]
      (-> []
          (E.concat$ (E.map #(iter/range 1 8) #(head-or-tail :tableau $1)))
          (E.concat$ (E.map #(iter/range 1 4) #(head-or-tail :foundation $1)))
          (E.concat$ (E.map #(iter/range 1 3) #(head-or-tail :cell $1))))))

  (let [{: hand : hand-from} game-state
        holding? (match hand [nil] false [cards] true)
        checked-locations (match hand
                            [nil] (E.map (all-possible-pickup-locations game-state)
                                         #[(logic.collect-from-ok? game-state $2) $2])
                            [cards] (E.map (all-possible-putdown-locations game-state)
                                           #[(logic.can-place-ok? game-state $2 cards) $2]))
        ;; we also want to insert the place we picked up our cards from, so we
        ;; can return to that location and put the cards back. This might not
        ;; always be a valid location unless we picked up mid-sequence or from
        ;; the head of a slot, which is why we manually insert it, but also
        ;; don't want to insert it if it already exists (if we picked up mid seq).
        ugly (match hand-from
               [h-slot h-col h-card]
               #(if (accumulate [f true _ [_ [slot col card]] (ipairs $1) :until (not f)]
                        (match [h-slot h-col h-card] [slot col card] false _ true))
                  ;; did not find hand in given possitions, so add it
                  (E.append$ $1 [[:ok true] hand-from])
                  ;; did find hand, dont need to add
                  (values $1))
               ;; empty hand, pass value on as is
               _ #$1)
        locations (-> checked-locations
                      (E.filter #(match $2 [[:ok] location] true))
                      (ugly)
                      (E.map #(match $2 [_ location] location))
                      (E.sort$ (fn [[slot-1 col-1 card-1] [slot-2 col-2 card-2]]
                                 (let [slot-val {:tableau 1000 :cell 2000 :foundation 3000}
                                       a [(. slot-val slot-1) col-1 card-1]
                                       b [(. slot-val slot-2) col-2 card-2]]
                                   (match [a b]
                                     [[s c x] [s c y]] (< x y)
                                     [[s x _] [s y _]] (< x y)
                                     [[x _ _] [y _ _]] (< x y)))))
                      ;; TODO Questionable decision to smush buttons here as "positions"
                      (E.concat$ (-> (if (not holding?) [:DRAGON-RED :DRAGON-GREEN :DRAGON-WHITE] [])
                                     (E.map #(if (. game-state :lockable-dragons (.. $2 :?))
                                               [:LOCK-DRAGON 1 $1])))))]
    (values locations)))

(fn m.update [game]
  (if game.config.difficulty.auto-move-obvious
    (while (R.ok? (logic.auto-move-ok? game.logic-state))
      (let [[_ {: from : to}] (logic.auto-move-ok? game.logic-state)
             logic-state (logic.move-cards game.logic-state from to)
             game-state (m.update-game-state-with-logic-state game.game-state logic-state)]
        (doto game
          (tset :logic-state logic-state)
          (tset :game-state game-state)))))

  (let [{: game-state} game
        lockable? #(R.ok? (logic.lock-dragons-ok? game.logic-state $1))]
    (doto game-state
      ;; valid locations is influenced by lockable dragons as we consider the
      ;; "buttons" valid locations, so this must be updated first.
      (tset :lockable-dragons {:DRAGON-GREEN? (lockable? :DRAGON-GREEN)
                               :DRAGON-RED? (lockable? :DRAGON-RED)
                               :DRAGON-WHITE? (lockable? :DRAGON-WHITE)})
      (tset :valid-locations (m.generate-valid-locations game-state)))
  (ui-view.update game.view game.game-state)
  (values game)))

(fn m.draw [game]
  (let [{: view : game-state} game]
    (ui-view.draw view game-state)))

(fn shift-location [game event direction]
  ;; see if cursor is curently on valid location, if so, go to next (or loop)
  ;; if not, go to first.
  (let [{:game-state {: cursor : valid-locations}} game
        [cursor-slot cursor-col-n cursor-card-n] cursor
        current-index (accumulate [f nil i location (ipairs valid-locations) :until f]
                        (match location [cursor-slot cursor-col-n cursor-card-n] i))
        len-locations (length valid-locations)
        next-index (match [direction current-index]
                     [:next nil] 1
                     (where [:next i] (= i len-locations)) 1
                     [:next i] (+ i 1)
                     [:prev nil] len-locations
                     (where [:prev i] (= i 1)) len-locations
                     [:prev i] (- i 1))
        next-location (match valid-locations
                        [nil] cursor
                        list (. valid-locations next-index))]
    (tset game :game-state :cursor next-location)
    (values game)))

(fn m.next-location [game event]
  (shift-location game event :next))
(fn m.prev-location [game event]
  (shift-location game event :prev))

(fn m.left-mouse [game event]
  ;; When we write out to the hit buffer, we currently don't do any special
  ;; processing, so while a valid put down location might be [t 1 2], with a
  ;; card at [t 1 1], the hit buffer can only detect a click on [t 1 1].
  ;; This means we have to do some special checks around whether the position
  ;; after or before the click location are valid locations to interact with.
  (let [{: location} event
        {: hand} game.game-state
        [click-slot click-col click-card] location
        holding? (match hand [nil] false [cards] true)
        ;; as above, hit locations are "as rendered" but we want to check the
        ;; card after that, with the exception of empty positions which, as a
        ;; shortcut in the view, report the same location as the first would-be
        ;; card in the slot. We check if there is actually any cards where we
        ;; clicked - if there is, check the next location, if none, we actually
        ;; want the directly clicked location.
        clicked-empty? (nil? (?. game.game-state click-slot click-col click-card))
        next-card (if clicked-empty? click-card (+ click-card 1))
        ;; check every valid location against this function, which should
        ;; filter the valid locations to either one location or zero. If we
        ;; have one we can move the cursor there and act as if we got a normal
        ;; interact event.
        matches-click-location? (match [click-slot holding?]
                                  ;; we clicked the tableau but have no hand,
                                  ;; so we want to check if the click location
                                  ;; is directly vald, which means we can pick
                                  ;; up from there.
                                  [:tableau false] #(match $2 [click-slot click-col click-card] true)
                                  ;; We clicked the tableau with cards in hand,
                                  ;; this means we want to put down cards and must
                                  ;; actually check the position *after* what we clicked
                                  ;; the position after was never draw and is un-clickable,
                                  ;; while also being an invalid put-down location.
                                  [:tableau true] #(match $2 [click-slot click-col next-card] true)
                                  ;; foundation shows last card but place after it
                                  [:foundation true] #(match $2 [click-slot click-col next-card] true)
                                  ;; cells only one card so dont adjust
                                  [_ _] #(match $2 [click-slot click-col click-card] true))
        ;; of all the valid locations, does the click location match one?
        cursor (-> (E.filter game.game-state.valid-locations matches-click-location?)
                   (E.hd))]
    (when cursor
      (set game.game-state.cursor cursor)
      (m.interact game event))))

(fn m.right-mouse [game event]
  ;; just try to put down cards if we have any
  (let [{: location} event
        {: hand : hand-from} game.game-state
        holding? (match hand [nil] false [cards] true)]
    (inspect! hand-from)
    (when holding?
      (set game.game-state.cursor hand-from)
      (m.interact game event))))

(fn m.auto-move [game event]
  (let [{: game-state : logic-state} game]
    (match (logic.auto-move-ok? logic-state)
      [:ok {: from : to}] (let [logic-state (logic.move-cards logic-state from to)
                                game-state (m.update-game-state-with-logic-state game-state logic-state)]
                            (doto game
                              (tset :game-state game-state)
                              (tset :logic-state logic-state)))))
  (values game))

(fn m.interact [game event]
  (let [{: game-state : logic-state} game
        {: cursor : hand : hand-from} game-state]
    ;; TODO HACK button hack ...
    (match [hand cursor]
      [_ [:LOCK-DRAGON 1 button]] (let [which (match button 1 :DRAGON-RED 2 :DRAGON-GREEN 3 :DRAGON-WHITE)]
                                    (match (logic.lock-dragons-ok? logic-state which)
                                      [:ok {: to}]
                                      (let [new-logic-state (logic.lock-dragons logic-state which)
                                            new-game-state (m.update-game-state-with-logic-state game-state new-logic-state)]
                                        (tset new-game-state :cursor to)
                                        (doto game
                                          (tset :game-state new-game-state)
                                          (tset :logic-state new-logic-state)))
                                      [:err e] (error e)))
      ;; pick up is checked against logic state as we have had no effect yet
      [[nil] _] (match (logic.collect-from-ok? logic-state cursor)
                  [:ok] (let [[slot col-n card-n] cursor
                              (rem hand) (E.split (. game-state slot col-n) card-n)]
                          (tset game-state slot col-n rem)
                          (tset game-state :hand [hand])
                          (tset game-state :hand-from cursor)
                          (tset game :game-state game-state))
                  [:err e] (error e))
      ;; place is checked against game state as we have technically altered it
      ;; kinda ugly hack so we can place back where we picked up even if it
      ;; makes an invalid sequence
      [[cards] _] (match [cursor hand-from (logic.can-place-ok? game-state cursor cards)]
                    ;; trying to put down where we picked up, don't do any checks, just revert the state
                    [[s cl cd] [s cl cd] _]
                    (let [game-state (doto game-state
                                       (tset :hand [])
                                       (tset :hand-from []))
                          new-game-state (m.update-game-state-with-logic-state game-state logic-state)]
                      (tset game :game-state new-game-state))
                    ;; otherwise can we move?
                    [_ _ [:ok]]
                    (let [{: hand-from} game-state
                          new-logic-state (logic.move-cards logic-state hand-from cursor)
                          new-game-state (m.update-game-state-with-logic-state game-state new-logic-state)]
                      (tset new-game-state :hand [])
                      (tset new-game-state :hand-from [])
                      (doto game
                        (tset :game-state new-game-state)
                        (tset :logic-state new-logic-state)))
                    ;; hard error here, ui shouldn't request bad things
                    [_ _ [:err e]] (error e)))
    (values game)))

(local path-separator (string.match package.config "(.-)\n"))
(lambda join-path [head ...]
  (accumulate [t head _ part (ipairs [...])]
              (.. t path-separator part)))

(fn m.save-game [game event]
  (let [save-file (join-path (vim.fn.stdpath :cache) :shenzhen-solitaire.save)]
    (with-open [fout (io.open save-file :w)]
      (fout:write (vim.mpack.encode game.logic-state.events))
      (vim.notify "Saved game"))))

(fn m.load-game [game event]
  (let [save-file (join-path (vim.fn.stdpath :cache) :shenzhen-solitaire.save)
        readable (= 1 (vim.fn.filereadable save-file))]
    (if readable
      (with-open [fin (io.open (.. save-file))]
        (let [bytes (fin:read :*a)
              events (vim.mpack.decode bytes)
              new-logic-state (E.reduce events (logic.S.empty-state) #(logic.S.apply $1 $3))
              new-game-state (m.update-game-state-with-logic-state {} new-logic-state)]
          (tset game :logic-state new-logic-state)
          (tset game :game-state new-game-state)
          (m.update game)
          (m.draw game)))
      (error "Could not open save file, probably doesn't exist"))))

(local hl-normal-background (let [{: background} (vim.api.nvim_get_hl_by_name :Normal true)
                                  hex (fmt "#%x" background)]
                              hex))

(local default-config {:card {:size {:width 7 :height 5}
                              :borders {:ne :╮ :nw :╭ :se :╯ :sw :╰ :n :─ :s :─ :e :│ :w :│}}
                              ;:borders {:ne :🭌 :nw :🭈 :se :🭘 :sw :🭢 :n :🮒 :s :🮃 :e :🮋 :w :🮋}}
                       :buttons {:pos {:row 1 :col 34}}
                       :tableau {:pos {:row 7 :col 1}
                                 :gap 3}
                       :cell {:pos {:row 1
                                    :col 1}
                              :gap 3}
                       :foundation {:pos {:row 1 :col 41}
                                    :gap 3}
                       :highlight {:empty {:fg :grey :bg hl-normal-background}
                                   :coin {:fg :#e8df78 :bg hl-normal-background}
                                   :string {:fg :#879ff6 :bg hl-normal-background}
                                   :myriad {:fg :#23b3ac :bg hl-normal-background}
                                   :flower {:fg :#934188 :bg hl-normal-background}
                                   :dragon-green {:fg :#52ad56 :bg hl-normal-background}
                                   :dragon-white {:fg :#cfcfcf :bg hl-normal-background}
                                   :dragon-red {:fg :#d34d4d :bg hl-normal-background}}
                       :info {:pos {:row 20 :col 3}}
                       :size {:width 80 :height 40}
                       :cursor {:show true} ;; show cursor, strongly recommended without a mouse
                       :difficulty {:show-valid-locations true ;; show possible interactive locations, useful without a mouse.
                                    :allow-undo false ;; TODO
                                    :auto-move-obvious true}
                       :keys {:left-mouse :<LeftMouse>
                              :right-mouse :<RightMouse>
                              :interact :y
                              :auto-move :a
                              :save-game :szw
                              :load-game :szl
                              ; :restart-game :szr ;; TODO
                              :next-location :<Tab>
                              :prev-location :<S-Tab>}})

(fn m.update-game-state-with-logic-state [game-state logic-state]
  "game-state is a mutation on the logic state with some parital changes
  applied for picking up cards, as well as tracking additional information such
  as cursor position, valid moves, cards-in-hand-or-not etc."
  (let [new-game-state (logic.S.clone-state logic-state)]
    (doto new-game-state
      (tset :cursor (or game-state.cursor [:tableau 1 5]))
      (tset :hand (or game-state.hand []))
      (tset :hand-from (or game-state.hand-from []))
      (tset :lockable-dragons (or game-state.lockable-dragons []))
      (tset :valid-locations (or game-state.valid-locations [])))))

(fn M.start-new-game [buf-id first-responder ?config ?seed]
  "Generate a fresh game and return a coroutine which will handle events when resumed"
  (fn setup []
    ;; we want access to the coroutine thread for passing between responders,
    ;; so we encapsulate the setup too.
    (local game {:logic-state nil
                 :game-state nil
                 :view nil
                 :config (or ?config default-config)})
    (let [thread (coroutine.running)
          responder #(first-responder thread $...)]
      ;; setup the inital game state and bang
      (set game.logic-state (logic.start-new-game ?seed))
      (set game.game-state (m.update-game-state-with-logic-state {} game.logic-state))
      (set game.view (-> (ui-view.new buf-id responder game.config)
                         (ui-view.update game.game-state)))
      (m.update game)
      (m.draw game))
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

(let [thread (M.start-new-game 2 (fn [thread event]
                                   (match (coroutine.resume thread :event event)
                                     (true [:ok _]) nil
                                     (true [:err e]) (error (.. e (debug.traceback thread)))
                                     (false e) (error (.. e (debug.traceback thread))))))]
  (assert (coroutine.resume thread :control :hello)))

(values nil)
