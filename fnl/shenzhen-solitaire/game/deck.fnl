;;; Generally contains "deck and card" related functions.
;;;
;;; This implies some amount of game logic, such as checking if a stack is a
;;; valid sequence as well as more generic "is-card-x?" functions.

(import-macros {: use} :shenzhen-solitaire.lib.donut.use)

(use E :shenzhen-solitaire.lib.donut.enum
     {: range} :shenzhen-solitaire.lib.donut.iter :ns iter)

(local M {})

(local D
  (-> [(E.flat-map [:STRING :COIN :MYRIAD]
                   (fn [_ s] (E.map #(iter/range 1 9) #[s $1])))
      [[:FLOWER 0]]
      (E.flat-map [:DRAGON-RED :DRAGON-GREEN :DRAGON-WHITE]
                  (fn [_ s] (E.map #(iter/range 1 4) #[s 0])))]
      (E.flatten)))

;; the deck contents is hard coded
(fn M.new []
 "Generate a new deck of cards"
  D)

(fn M.special-card? [card]
  "Is given card one of the special cards?"
  (match card
    [:DRAGON-RED _] true
    [:DRAGON-GREEN _] true
    [:DRAGON-WHITE _] true
    [:FLOWER _] true
    _ false))

(fn M.suited-card? [card]
  "Is given card one of the suited cards?"
  (match card
    [:COIN _] true
    [:STRING _] true
    [:MYRIAD _] true
    _ false))

(fn M.dragon-card? [card]
  "Is card any of the dragon cards?"
  (match card
    [:DRAGON-RED _] true
    [:DRAGON-GREEN _] true
    [:DRAGON-WHITE _] true
    _ false))

(fn M.flower-card? [card]
  "Is given card one of the flower card?"
  (match card
    [:FLOWER _] true
    _ false))

(fn M.coin-card? [card]
  "Is given card one of the coin cards?"
  (match card
    [:COIN _] true
    _ false))

(fn M.string-card? [card]
  "Is given card one of the string cards?"
  (match card
    [:STRING _] true
    _ false))

(fn M.myriad-card? [card]
  "Is given card one of the myriad cards?"
  (match card
    [:MYRIAD _] true
    _ false))

(fn M.card-type [card]
  (match card
    [t _] t
    _ (error :not-a-card)))

(fn M.card-value [card]
  (match card
    [_ v] v
    _ (error :not-a-card)))

(fn M.valid-sequence? [stack]
  "Does the given stack alternate in suit and decrement in value?"
  ;; check run would be valid
  (fn alternating-suit-and-dec-value? [[head & tail]]
    (not (= nil (E.reduce tail
                             head
                             #(match [$1 $3]
                                (where [[ls lv] [s v]] (and (not (= ls s)) (= v (- lv 1)))) $3)))))
  (fn contains-no-specials? [run]
    (-> (E.filter run #(M.special-card? $2))
        (E.empty?)))
  (and (alternating-suit-and-dec-value? stack)
       (contains-no-specials? stack)))

(values M)
