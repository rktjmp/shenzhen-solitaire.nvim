(import-macros {: use} :shenzhen-solitaire.lib.donut.use)

(use {:new new-deck
      : special-card?
      : suited-card?
      : dragon-card?
      : flower-card?
      : card-type
      : valid-sequence?} :shenzhen-solitaire.game.deck
     {:format fmt} string
     {: range} :shenzhen-solitaire.lib.donut.iter :ns iter
     enum :shenzhen-solitaire.lib.donut.enum
     {: inspect! : inspect} :shenzhen-solitaire.lib.donut.inspect
     {: nil?} :shenzhen-solitaire.lib.donut.type
     {: tap} :shenzhen-solitaire.lib.donut.f
     R :shenzhen-solitaire.lib.donut.result
     {: unit : ok? : err? : err : ok : map
      : 'let : 'let*} :shenzhen-solitaire.lib.donut.result :ns r)

;; S is an internal state-alteration modlue
(local S {})

;; for now the handlers will live on this table but probably could go in S
(local handlers {})

(fn generate-locations [state opts]
  "Return list of locations of either 1 1 blanks or n n last cards"
  (enum.flat-map opts
                 (fn [slot [from to]]
                   (enum.map #(iter/range from to)
                             #[slot $1 (math.max 1 (length (. state slot $1)))]))))

(fn generate-pickup-locations [state opts]
  "Return list of locations for each card in given opt ranges"
  (enum.flat-map opts
                 (fn [slot [from to]]
                   (enum.map #(iter/range from to)
                             #(match (length (. state slot $1))
                                0 nil
                                n [slot $1 n])))))


(fn generate-putdown-locations [state opts]
  "Return a list of all locations after last card in slot or 1 1"
  (enum.flat-map opts
                 (fn [slot [from to]]
                   (enum.map #(iter/range from to)
                             #(match (length (. state slot $1))
                                0 [slot $1 1]
                                n [slot $1 (+ n 1)])))))

(fn location->card [state location]
  ;; TODO: worth exposing this? check location valid?
  (let [[slot col-n card-n] location]
    (?. state slot col-n card-n)))

(fn S.empty-state [id seed]
  {:game-id id
   ;; game stuff
   :seed seed
   :events []
   :last-event 0
   ;; solitaire stuff
   ;; NOTE: foundation 4 is the flower foundation
   ;; we collate it for simpler location referencing
   :foundation [[] [] [] []]
   :tableau [[] [] [] [] [] [] [] []]
   :cell [[] [] []]
   :stock []})

(fn S.clone-state [old-state]
  "Clone an existing state, mostly."
  (let [new-state (-> (S.empty-state old-state.id old-state.seed)
                      (enum.set$ :last-event old-state.last-event)
                      (enum.set$ :events (enum.copy old-state.events)))]
    ;; other values need fresh tables so we dont break other states.
    ;; the values are just cards which are effectively constants so a shallow copy is fine.
    (enum.each [:foundation :tableau :cell]
               (fn [_ key]
                 (let [from (. old-state key)
                       copied (enum.map from #(enum.copy $2))]
                   (enum.set$ new-state key copied))))
    ;; these are just tables
    (enum.each [:stock] #(enum.set$ new-state $2 (enum.copy (. old-state $2))))
    (values new-state)))

(fn S.push-event [state event]
  "Append event to state event log."
  (table.insert state.events event)
  (tset state :last-event (length state.events))
  (values state))

(fn S.apply [state [name data]]
  "Apply event to state, looks for function that matches event name. Returns a
  cloned state."
  (let [f (. handlers name)
        _ (assert f (.. "Could not find applicative for " name))
        cloned-state (S.clone-state state)]
    (match (f cloned-state data)
      a-state (-> (S.push-event a-state [name data]))
      (nil err) (error err))))

;;; Event Apply-ers

(fn handlers.started-new-game [state {: id : seed}]
  (let [deck (new-deck)]
    (doto state
        (tset :stock deck)
        (tset :game-id id)
        (tset :seed seed))))

(fn handlers.shuffled-deck [state]
  (math.randomseed state.seed)
  (enum.shuffle$ state.stock)
  (values state))

(fn handlers.dealt-cards [state]
  ;; run through deck placing each card in columns
  (let [cols (enum.chunk-every state.stock 5)
        cols->tableau #(tset state :tableau $1 $2)]
    (enum.each cols cols->tableau)
    (set state.stock [])
    (values state)))

(fn handlers.moved-cards [state {: from : to}]
  ;; TODO? currently this is always just concatting from-cards onto to-col,
  ;; which is actually all we ever need, but to *does* have (and requires!) the
  ;; card-n field.
  (let [[from-slot from-col-n from-card-n] from
        [to-slot to-col-n to-card-n] to
        (left-over-from hand) (enum.split (. state from-slot from-col-n) from-card-n)]
    (doto state
      (tset from-slot from-col-n left-over-from)
      (tset to-slot to-col-n (enum.concat$ [] (. state to-slot to-col-n) hand)))))

(fn handlers.locked-dragons [state {:name dragon-name :from dragon-locations :to cell-location}]
  (let [dragon-cards (enum.map dragon-locations #(location->card state $2))]
    ;; clear dragon locations
    (enum.map dragon-locations #(let [[slot-name col-n card-n] $2]
                                  (tset state slot-name col-n card-n nil)))
    ;; collect cards
    (let [[slot col _] cell-location]
      (tset state slot col dragon-cards))
    (values state)))

(local M {})

(fn M.collect-from-ok? [state [slot col-n card-n]]
  "Validate whether its an ok move to pick cards up from a location.
  Assumes location is valid!"
  (r/let [col (?. state slot col-n)]
    (match [slot col]
      ;; hard fail because the location was bogus
      [_ nil] (error (fmt "invalid location: %s.%d" slot col-n))
      ;; ERR foundations are always un-collectable
      [:foundation _] (values nil "You may never collect from a foundation")
      ;; ERR cant collect from an empty stack
      [_ [nil]] (values nil (fmt "unable to collect from %s.%d because it is empty" slot col-n))
      ;; OK you can always pick up one card
      (where [:tableau [card & _]] (= card-n (length col))) true
      ;; OK/ERR but more than one card must be a valid sequence
      (where [:tableau [card & _]] (< 0 card-n (length col)))
      (let [(rem hand) (enum.split col card-n)]
        (if (valid-sequence? hand)
          true
          (values nil "may only collect alternating suit descending sequences")))
      ;; ERR out of bounds
      (where [:tableau [card & _]] (< (length col) card-n))
      (values nil (fmt "unable to collect from %s.%d.%d because it over runs length" slot col-n card-n))
      ;; OK you can always pick up one card from a cell
      (where [:cell [card]] (= card-n 1))
      (let [cell (. state slot col-n)]
       (match cell
        [any nil] true
        [a b c d nil] (values nil "cant collect from locked cells")
        _ (error "internal logic error")))
      (where [:cell [card]] (< 1 card-n)) (values nil "cant collect over the first card in a cell")
      ;; ERR catch all else
      _ (error (fmt "unmatched collect request: %s.%d %d" slot col-n card-n)))))

(fn place-on-foundation-ok? [foundation card-n cards flower-foundation?]
  (r/let [_ (or (= 1 (length cards)) (r/err "may only place one card at a time on a foundation"))
          [card] cards
          ;; we always place on the last foundation card
          foundation-card (. foundation (length foundation))
          _ (or (= card-n (+ 1 (length foundation))) (r/err "must place on top of last card in foundation"))
          _ (if flower-foundation?
             (or (flower-card? card) (r/err "may only place flower card on flower foundation"))
             (or (suited-card? card) (r/err "may only place suited cards on foundation")))]
   (if flower-foundation?
     (match [foundation-card card]
       ;; OK nothing in the foundation and the card is one flower, thats ok
       [nil [:FLOWER _]] true
       ;; ERR this is an illegal state and should crash intentionally
       [any [:FLOWER _]] (error "attempted to place flower on flower"))
     (match [foundation-card card]
       ;; ERR nothing on the foundation and the held card is not 1
       (where [nil [_ v]] (not (= 1 v))) (values nil "foundation must start with value 1 card")
       ;; OK foundation is empty and the value is one
       (where [nil [_ 1]]) true
       ;; OK foundation exists but suit is same and value is one less
       (where [[suit last-val] [suit next-val]] (= next-val (+ last-val 1))) true
       [_ _] (values nil "must place same suit and +1 value on existing foundation")))))

(fn place-on-cell-ok? [cell card-n cards]
  ;; for the most part we can only put one card on a cell at a time, except for locking dragons
  ;; which should accept an empty cell and exactly 4 cards of the same type
  ;; cells always must be empty to place a card(s).
  (r/let [_ (or (= 1 card-n) (values nil "must place on card-n 1 for cells"))]
         (match [cell cards]
           ;; ERR cell occupied
           [[not-nil] _] (values nil "can only place into an empty cell")
           ;; OK empty cell and all the same dragon
           (where [[nil] [[d _] [d _] [d _] [d _]]] (string.match d "^DRAGON-")) true
           ;; OK empty cell and only one card
           (where [[nil] [card nil]]) true
           ;; ERR more than one card
           (where [_ [card & rest]] (< 0 (length rest)))
           (values nil "can only place one card on a cell"))))

(fn place-on-tableau-ok? [column card-n cards]
  ;; we can place on the tableau at the end the col only
  (r/let [col-len (length column)
          ;; can only drop after the last card
          _ (if (not (= card-n (+ 1 col-len)))
              (values nil "must place at end of column"))
          ;; now check that top-card + cards is a valid sequence
          t-card (. column col-len)
          ;; may be [nil] -> [] + cards
          new-seq (enum.append$ [t-card] (unpack cards))]
    (match [t-card (valid-sequence? new-seq)]
      ;; you can always put cards down in vacant columns
      ;; note: we skip the seq check here so dragon placements work even though
      ;; they don't create a sequence
      [nil _] true
      ;; otherwise we must be making a valid sequence
      [_ true] true
      [_ false] (values nil "must create alternating suit descending sequence"))))

(fn M.can-place-ok? [state [slot col-n card-n] cards]
  (match [slot (. state slot col-n)]
    [:foundation foundation] (place-on-foundation-ok? foundation card-n cards (= col-n 4))
    [:cell cell] (place-on-cell-ok? cell card-n cards)
    [:tableau col] (place-on-tableau-ok? col card-n cards)
    _ (error (fmt "unmatched can-place-on? %s %s" (inspect slot col-n)))))

;;; External Commands

;;; These are effectively the API to operating on the game logic.
;;;
;;; The primary function will be move-cards (generate event or error), or
;;; move-cards-ok? (check validity of move and return result<>). Every move in
;;; the game can be described by this except for the dragon collection which
;;; requires picking up 4 separate cards and placing them in a
;;; normally-only-one-card cell - and so that particular task is done by
;;; lock-dragons.

(fn M.move-cards-ok? [state from to]
  "Proofcheck a proposed move, returns `ok<true>` or `err<reason>`. See
  `move-cards' for argument documentation. "

  (assert state "requires state argument")
  (assert from "requires from argument")
  (assert to "requires to argument")

  (fn location-arg-ok? [name [slot col card]]
    ;; is the location arg fully formed?
    (r/let [slot (or slot (R.err (.. name " location was mising slot name")))
            col (or col (R.err (.. name " location was missing col")))
            card (or card (R.err (.. name " location was missing card")))]
      true))

  (fn location-resolves-ok? [name [slot col card] ignore-card?]
    ;; does the location actually point somewhere real?
    ;; note: we dont care if the TO card doesn't exist at this point
    (r/let* [real-slot (or (. state slot)
                           (R.err (.. name " slot was invalid")))
             real-col (or (. real-slot col)
                          (R.err (.. name " " slot " col was invalid")))
             real-card (or (or ignore-card? (. real-col card))
                           (R.err (.. name " " slot "." col " card was invalid")))]
      true))

  ; (fn move-logical-ok? [[from-slot from-col from-card] [to-slot to-col to-card]]
  ;   ;; a move must pass some basic logical checks
  ;   ;; you cant move from slot+col to the same slot+col
  ;   (let [slot-same (= from-slot to-slot)
  ;         col-same (= from-col to-col)]
  ;     (if (not (and slot-same col-same))
  ;       (R.ok true)
  ;       (R.err "cant move from and to the same slot.col"))))

  (-> (r/let [_ (location-arg-ok? :from from)
              _ (location-arg-ok? :to to)
              ;; we will allow moving from -> to the same location, this is not
              ;; illegal, more of a no-op and allowing it lets us pickup a card
              ;; in and put it back down in the same place if it has no valid
              ;; moves.
              ;; TODO: I would like to re-enable this check probably
              ; _ (move-logical-ok? from to)
              _ (location-resolves-ok? :from from)
              _ (location-resolves-ok? :to to true)
              [from-slot from-col-n from-card-n] from
              [to-slot to-col-n to-card-n] to
              ;; check if we're actually allowed to get the cards
              can-collect? (M.collect-from-ok? state from)
              ;; split out the hand we want to move
              (rem hand) (enum.split (. state from-slot from-col-n) from-card-n)
              ;; check if we are allowed to place the cards down
              can-place? (M.can-place-ok? state to hand)]
        ;; technically any failures above will already shortcircut before we
        ;; get here but we will exercise the check anyway
        ; (inspect! :can-collect? can-collect? :can-place? can-place?)
        (if (and can-collect? can-place?)
          (R.ok {: from : to}) ;; TODO this value does not match args for move-cards
          (R.err "unable proceed, this was unexpected, please log an issue")))))

(fn M.start-new-game [?seed]
  "Command, start a new game.

  Accepts an optional seed value."
  (let [game-id (math.random 1 9_000_000_000) ;; uniqueness not *really* a big deal
        seed (or ?seed (math.random 1 9_000_000_000))]
    (-> (S.empty-state)
        (S.apply [:started-new-game {:id game-id :seed seed}])
        (S.apply [:shuffled-deck])
        (S.apply [:dealt-cards]))))

(fn M.move-cards [state from to]
  "Move cards `from` location `to` location.

  Locations are described by a sequence of `[:slot-name col-n card-n]`.
  Slot name may be `:tableau`, `:foundation` and `:cell`.

  Columns are numbered left to right, cards are numbered 1 to n, where
  1 is the top most card and n is the last card.

  Giving a number (x) between 1 and n moves all cards from x to n."
  (-> (M.move-cards-ok? state from to)
      (R.map #(S.apply state [:moved-cards $1]))
      (R.unwrap!)))

(fn M.lock-dragons-ok? [state dragon-name]
  (let [dragon-locations (-> (generate-pickup-locations state {:tableau [1 8] :cell [1 3]})
                             (enum.filter #(match (location->card state $2)
                                             [dragon-name _] true)))
        cell-location (-> (generate-locations state {:cell [1 3]})
                          (enum.filter #(match (location->card state $2)
                                          ;; can stack on same dragon, or empty
                                          [dragon-name _] true
                                          [any _] false
                                          nil true))
                          (enum.hd))
        n-locs (length dragon-locations)]
    (match [(= 4 n-locs) (not (nil? cell-location))]
      [true true]  (R.ok {:name dragon-name :from dragon-locations :to cell-location})
      [false _] (R.err (fmt "need 4 dragons to lock, found %d %s" n-locs dragon-name))
      [true false] (R.err (fmt "no free cell")))))

(fn M.lock-dragons [state dragon-name]
  (-> (M.lock-dragons-ok? state dragon-name)
      (R.map #(S.apply state [:locked-dragons $1]))
      (R.unwrap!)))

(fn M.auto-move-ok? [state]
  ;; get front cards from cells and tableau
  (let [foundations (generate-putdown-locations state {:foundation [1 4]})
        ;; we only want to auto-move if the card found is the lowest value on the board,
        ;; grab all the cards to check against
        all-cards (-> (enum.flat-map #(iter/range 1 8)
                                     (fn [col-n]
                                       (enum.map #(iter/range 1 40)
                                                 #[:tableau col-n $1])))
                      (enum.concat$ (enum.map #(iter/range 1 3) #[:cell 1 $1]))
                      (enum.map #(location->card state $2)))
        no-higher-card? (fn [[_ min-value]]
                          ;; we can only auto-move if there are no cards anywhere in on the board that
                          ;; are less than us. Equal values are ok.
                          (-> (enum.filter all-cards #(match $2
                                                        [:FLOWER _] false
                                                        [:DRAGON-GREEN _] false
                                                        [:DRAGON-RED _] false
                                                        [:DRAGON-WHITE _] false
                                                        [_ test-value] (< test-value min-value)))
                              (#(= 0 (length $1)))))
        posibilities (-> (generate-pickup-locations state {:tableau [1 8] :cell [1 3]})
                         (enum.map #[$2 (location->card state $2)])
                         ;; TODO this sort is a bit vague, ideally we want to go
                         ;; flower, then left->right of cell and foundation
                         ;; but realistically it's not that important if we
                         ;; pick out of order beyond aesthetics.
                         (enum.sort$ #(match [$1 $2]
                                        [[_ [t-a v-a]] [_ [t-b v-b]]] (and (< t-a t-b)
                                                                           (< v-a v-b))))
                         (enum.filter #(let [[_ card] $2]
                                         (no-higher-card? card)))
                         (enum.flat-map (fn [_ [location card]]
                                          (enum.map foundations #{:from location
                                                                  :to $2
                                                                  : card}))))
        pick (accumulate [(i found?) (values nil false) index test (ipairs posibilities) :until found?]
               (if (R.ok? (M.move-cards-ok? state test.from test.to))
                 (values index true)
                 (values nil false)))]
    (if pick
      (let [{: from : to} (. posibilities pick)]
        (R.ok {: from : to}))
      (R.err "no auto-move found"))))

(fn M.win-game-ok? [state]
  (let [tableau-cards (-> (enum.flat-map #(iter/range 1 8)
                                         (fn [col-n] (enum.map #(iter/range 1 40)
                                                               #[:tableau col-n $1])))
                          (enum.map #(location->card state $2)))]
    (if (= 0 (length tableau-cards))
      ;; doesn't really need to be wrapped but we will for consistency.
      (R.ok true)
      (R.err false))))

(tset M :S S)
(values M)
