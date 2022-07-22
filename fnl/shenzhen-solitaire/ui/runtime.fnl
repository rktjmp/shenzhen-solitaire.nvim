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

(import-macros {: use} :shenzhen-solitaire.lib.donut.use)

(use {: range} :shenzhen-solitaire.lib.donut.iter :ns iter
     {: map : each : flat-map : pairs->table} :shenzhen-solitaire.lib.donut.enum :ns enum
     {: inspect!} :shenzhen-solitaire.lib.donut.inspect
     E :shenzhen-solitaire.lib.donut.enum
     R :shenzhen-solitaire.lib.donut.result
     logic :shenzhen-solitaire.game.logic
     ui-view :shenzhen-solitaire.ui.view)

(local M {})
(local m {:games []})

(fn m.update-valid-locations [game]
  ;; if we have nothing in hand, search all positions in the layout for
  ;; locations that can be picked up.
  ;; TODO sort this so the first valid move is directly after the current
  ;; cursor.
  ;; TODO 'hard' mode where this isn't validated?
  (fn all-locations [f]
    (E.flat-map [:tableau :cell :foundation]
                (fn [_ slot]
                  (E.flat-map (. game :game-state slot)
                              (fn [col-n col]
                                (E.map col
                                       (fn [card-n] (f [slot col-n card-n]))))))))
  (let [{: game-state} game
        {: hand} game-state]
    (match hand
      [nil] (-> (all-locations #[(logic.collect-from-ok? game-state $1) $1])
                (E.filter #(match $2 [[:ok] location] true))
                (inspect!)))))

(fn m.draw-game [game]
  (m.update-valid-locations game)
  (let [{: view : game-state} game]
    (ui-view.draw view game-state)))

(fn m.next-location [current-location])
(fn m.prev-location [current-location])

(fn m.pick-up-put-down [game event]
  ;; just pick up for now
  (let [{: game-state } game
        {: logic-state} game
        {: cursor} game-state]
    (match (logic.collect-from-ok? logic-state cursor)
      [:ok] (let [[slot col-n card-n] cursor
                  (rem hand) (E.split (. game-state slot col-n) card-n)]
              (print :collect slot col-n card-n)
              (tset game-state slot col-n rem)
              (tset game-state :hand [hand])
              (tset game :game-state game-state)
              (m.draw-game game)))))

;       responder (fn [event]
;                   (let [[cursor-slot cursor-col-n cursor-card-n] game-state.cursor]
;                     (match event
;                       {:name :move-right} (do
;                                             (tset game-state :cursor [cursor-slot
;                                                                       (+ cursor-col-n 1)
;                                                                       cursor-card-n])
;                                             (M.draw view game-state))
;                       {:name :move-left} (do
;                                             (tset game-state :cursor [cursor-slot
;                                                                       (- cursor-col-n 1)
;                                                                       cursor-card-n])
;                                             (M.draw view game-state)))))

(fn m.handle-event [game event]
  (let [{: name} event]
    (match (. m name)
      f (f game event)
      nil (error (string.format "no handler for %s" name)))))


(local default-config {:card {:size {:width 7 :height 5}
                              :borders {:ne :╮ :nw :╭ :se :╯ :sw :╰ :n :─ :s :─ :e :│ :w :│}}
                       :tableau {:pos {:row 7 :col 1}
                                 :gap 3}
                       :cell {:pos {:row 1
                                    :col 1}
                              :gap 3}
                       :foundation {:pos {:row 1 :col 40}
                                    :gap 3}
                       :highlight {:empty {:fg :grey}
                                   :coin {:fg :#e8df78 :bg :#292929}
                                   :string {:fg :#879ff6 :bg :#292929}
                                   :myriad {:fg :#23b3ac :bg :#292929}
                                   :flower {:fg :#934188 :bg :#292929}
                                   :dragon-green {:fg :#52ad56 :bg :#292929}
                                   :dragon-white {:fg :#ffffff :bg :#292929}
                                   :dragon-red {:fg :#b34d4d :bg :#292929}}
                       :size {:width 80 :height 40}
                       :keys {:move-right :o
                              :move-left :m
                              :move-up :i
                              :move-down :n
                              :pick-up-put-down :y
                              :cancel :q
                              :next-position :<Tab>
                              :prev-position :<S-Tab>}})

(fn logic-state->new-game-state [logic-state]
  "game-state is a mutation on the logic state with some parital changes
  applied for picking up cards, as well as tracking additional information such
  as cursor position, valid moves, cards-in-hand-or-not etc."
  (let [game-state (logic.S.clone-state logic-state)]
    (doto game-state
      (tset :cursor [:tableau 1 5])
      (tset :hand [])
      (tset :hand-from [])
      (tset :valid-moves []))))

(fn M.start-new-game [buf-id seed]
  (var current-game nil)
  (let [logic-state (logic.start-new-game seed)
        game-state (logic-state->new-game-state logic-state)
        responder (fn [event] (m.handle-event current-game event))
        view (ui-view.new buf-id game-state responder default-config)]
    (set current-game {:logic-state logic-state
                       :game-state game-state
                       :view view}))
    (m.draw-game current-game)
    (values current-game))

(values M)

(M.start-new-game 133 1)
(values nil)

; (var view nil)
; (let [logic (require :shenzhen-solitaire.game.logic)
;       buf-id 17
;       logic-state (logic.start-new-game)
;       game-state (logic.S.clone-state logic-state)
;       _ (doto game-state
;           (tset :cursor [:tableau 1 5])
;           (tset :hand [])
;           (tset :hand-from []))
;       ; _ (tset game-state :cursor [:tableau 1 2])
;       ;; generate some test layout
;       ; _ (let [(rem hand) (enum/split (. game-state.tableau 1) 3)]
;       ;     (tset game-state :tableau 1 rem)
;       ;     (tset game-state :hand [hand]))
;       ; _ (let [(rem cell) (enum/split (. game-state.tableau 8) 5)]
;       ;     (tset game-state :tableau 8 rem)
;       ;     (tset game-state :cell 1 cell))
;       ; _ (let [(rem flower) (enum/split (. game-state.tableau 8) 4)]
;       ;     (tset game-state :tableau 8 rem)
;       ;     (tset game-state :foundation 4 flower))
;       ; _ (let [(rem foundation) (enum/split (. game-state.tableau 4) 5)]
;       ;     (tset game-state :tableau 4 rem)
;       ;     (tset game-state :foundation 1 foundation))
;       ; _ (let [(rem other) (enum/split (. game-state.tableau 2) 2)]
;       ;     (tset game-state :tableau 2 rem)
;       ;     (tset game-state :tableau 5 (e.concat$ (. game-state.tableau 5) other)))
;       hand-hover [:tableau 1 2]
;       config {:card {:size {:width 7 :height 5}
;                      :borders {:ne :╮ :nw :╭ :se :╯ :sw :╰
;                                :n :─ :s :─ :e :│ :w :│}}
;               :tableau {:pos {:row 7 :col 1}
;                         :gap 3}
;               :cell {:pos {:row 1 :col 1}
;                      :gap 3}
;               :foundation {:pos {:row 1 :col 40}
;                            :gap 3}
;               :hand-hover hand-hover
;               :highlight {:empty {:fg :grey}
;                           :coin {:fg :#e8df78 :bg :#292929}
;                           :string {:fg :#879ff6 :bg :#292929}
;                           :myriad {:fg :#23b3ac :bg :#292929}
;                           :flower {:fg :#934188 :bg :#292929}
;                           :dragon-green {:fg :#52ad56 :bg :#292929}
;                           :dragon-white {:fg :#ffffff :bg :#292929}
;                           :dragon-red {:fg :#b34d4d :bg :#292929}}
;               :size {:width 80 :height 40}}
;       responder (fn [event]
;                   (let [[cursor-slot cursor-col-n cursor-card-n] game-state.cursor]
;                     (match event
;                       {:name :move-right} (do
;                                             (tset game-state :cursor [cursor-slot
;                                                                       (+ cursor-col-n 1)
;                                                                       cursor-card-n])
;                                             (M.draw view game-state))
;                       {:name :move-left} (do
;                                             (tset game-state :cursor [cursor-slot
;                                                                       (- cursor-col-n 1)
;                                                                       cursor-card-n])
;                                             (M.draw view game-state)))))
;       a-view (M.new buf-id game-state responder config)]
;   (set view a-view)
;   (M.draw view game-state)
;   nil)
