(import-macros {: use} :shenzhen-solitaire.lib.donut.use)

(use {: range} :shenzhen-solitaire.lib.donut.iter :ns iter
     {: map} :shenzhen-solitaire.lib.donut.enum :ns enum)

(local M {})

(fn M.new [card data]
  "Generates ui table with bitmap and highlight data to card. The
  ui sets row and col to 0 as this should be updated each draw."
  ;; cards are unique so we can generate a set of them on open and use those
  ;; representations repeatedly.
  (let [x nil
        ; edges {:ne :╗ :nw :╔ :se :╝ :sw :╚ :n :═ :s :═ :e :║ :w :║}
        ; edges {:ne :┐ :nw :┌ :se :┘ :sw :└ :n :═ :s :═ :e :│ :w :│}
        ; edges {:ne :╗ :nw :╒ :se :╜ :sw :└ :n :═ :s :─ :e :║ :w :│}
        ; edges {:ne :╮ :nw :╭ :se :╯ :sw :╰ :n :─ :s :─ :e :│ :w :│}
        ; edges {:ne "." :nw "." :se " " :sw " " :n :🭻 :s :🭶 :e :│ :w :│}
        ;; edges {:ne " " :nw " " :se " " :sw " " :n "🭶" :s " " :e " " :w " "}
        {: width : height} data.size
        {: borders} data
        rc->sym #(match [$1 $2]
                   [1 1] borders.nw
                   [height 1] borders.sw
                   [1 width] borders.ne
                   [height width] borders.se
                   [1 _] borders.n
                   [height _] borders.s
                   [_ 1] borders.w
                   [_ width] borders.e
                   _ " ")
        bitmap (enum/map #(iter/range 1 height)
                         (fn [row] (enum/map #(iter/range 1 width)
                                             (fn [col] (rc->sym row col)))))
        (symbol val) (match card
                       [:COIN v] (values nil v)
                       [:STRING v] (values nil v)
                       [:MYRIAD v] (values nil v)
                       [:DRAGON-GREEN] (values :Ñ nil)
                       [:DRAGON-WHITE] (values :Õ nil)
                       [:DRAGON-RED] (values :Š nil)
                       [:FLOWER] (values :ƒ nil)
                       _ (values :_ :_))]
    (tset bitmap 2 2 (or symbol (tostring val) "x"))
    {:size data.size
     :pos data.pos
     : bitmap
     :highlight data.highlight}))

; (fn M.set-position [card pos]
;   (doto card
;     (tset :pos pos)))

; (fn M.set-highlight [card hl]
;   (doto card
;     (tset :highlight hl)))

(values M)
