(tset package.loaded :shenzhen-solitaire.ui.frame-buffer nil)
(tset package.loaded :shenzhen-solitaire.ui.card nil)

(import-macros {: use} :shenzhen-solitaire.lib.donut.use)

(use {: range} :shenzhen-solitaire.lib.donut.iter :ns iter
     {: map : each : flat-map : flatten
      : split : pairs->table : set$ : reduce} :shenzhen-solitaire.lib.donut.enum :ns enum
     e :shenzhen-solitaire.lib.donut.enum
     {: start-new-game} :shenzhen-solitaire.game.logic
     frame-buffer :shenzhen-solitaire.ui.frame-buffer
     ui-card :shenzhen-solitaire.ui.card)

(local api vim.api)
(local M {})

(fn highlight-name-for-card [card]
  (let [[kind _] card]
    (match kind
      :EMPTY :SHZHCardEmpty
      :COIN :SHZHCardCoin
      :STRING :SHZHCardString
      :MYRIAD :SHZHCardMyriad
      :FLOWER :SHZHCardFlower
      :DRAGON-RED :SHZHCardDragonRed
      :DRAGON-GREEN :SHZHCardDragonGreen
      :DRAGON-WHITE :SHZHCardDragonWhite)))

(fn game-location->view-pos [location view]
  "Convert a game location [slot col-n card-n] into {: row : col}."
  (let [{: layout} view]
    (match location
      [:tableau col-n card-n] {:row (+ layout.tableau.pos.row (* (- card-n 1) 2))
                               :col (+ layout.tableau.pos.col
                                       layout.tableau.gap
                                       (* (- col-n 1)
                                          (+ layout.tableau.gap layout.card.size.width)))}
      [:cell col-n card-n] {:row layout.cell.pos.row
                            :col (+ layout.cell.pos.col
                                    layout.cell.gap
                                    (* (- col-n 1)
                                       (+ layout.cell.gap layout.card.size.width)))}
      [:foundation 4 card-n] {:row layout.foundation.pos.row
                              :col (+ layout.foundation.gap
                                      layout.foundation.pos.col
                                      (* (- 1 1)
                                         (+ layout.foundation.gap layout.card.size.width)))}
      [:foundation col-n card-n] {:row layout.foundation.pos.row
                                  :col (+ layout.foundation.gap
                                          layout.foundation.pos.col
                                          ;; shift from flower
                                          layout.card.size.width
                                          layout.foundation.gap
                                          (* (- col-n 1)
                                             (+ layout.foundation.gap layout.card.size.width)))}
      ;; cursor is as-would be but shifted over, locations for held cards are actually one past
      ;; the end of the columns, so we must knock back a card for nicer alignment
      [:hand col-n card-n] (let [[slot cur-col-n cur-card-n] view.cursor
                                 {: row : col} (game-location->view-pos [slot cur-col-n (-> (- cur-card-n 1)
                                                                                             (+ card-n))]
                                                                        view)]
                             {:row row :col (+ col 1)})
      _ (error (vim.inspect location)))))

(fn map-game-state-cards [game-state f]
  (let [fm enum/flat-map
        m enum/map]
    (fm [:cell :foundation :tableau :hand]
        (fn [_ slot]
          (fm (. game-state slot)
              (fn [col-n col]
                (m col
                   (fn [card-n card]
                     (f card [slot col-n card-n])))))))))

(fn M.new [buf-id game-state responder config]
  "Configures given buffer to act as game view and does some preparation busy work.

  Returns table describing view."
  (fn define-highlight-groups [highlight-config]
    (let [set-hl #(api.nvim_set_hl 0 (highlight-name-for-card [$1 0]) $2)]
      (set-hl :EMPTY highlight-config.empty)
      (set-hl :COIN highlight-config.coin)
      (set-hl :STRING highlight-config.string)
      (set-hl :MYRIAD highlight-config.myriad)
      (set-hl :DRAGON-RED highlight-config.dragon-red)
      (set-hl :DRAGON-WHITE highlight-config.dragon-white)
      (set-hl :DRAGON-GREEN highlight-config.dragon-green)
      (set-hl :FLOWER highlight-config.flower)))
  (fn configure-buffer [view]
    (let [{: buf-id : responder} view
          set-km #(api.nvim_buf_set_keymap buf-id
                                           :n
                                           (. config :keys $1)
                                           ""
                                           {:callback (fn [] (responder {:name $1 :view view}))
                                            :noremap false
                                            :nowait true
                                            :desc $2})]
      ;; TODO set no-mod, etc
      (let [opts {:filetype :shenzhen-solitaire}]
        (enum/map opts #(api.nvim_buf_set_option buf-id $1 $2)))
      (api.nvim_buf_call buf-id
                         #(let [win-id (api.nvim_get_current_win)
                                opts {:cursorline false
                                      :number false
                                      :list false
                                      :relativenumber false}]
                            (enum/map opts #(api.nvim_win_set_option win-id $1 $2))))
      (set-km :save-game "Save current game")
      (set-km :load-game "Load last saved game")
      (set-km :next-location "Move to next location")
      (set-km :prev-location "Move to previous location")
      (set-km :move-right "Move right")
      (set-km :move-left "Move left")
      (set-km :pick-up-put-down "Pick up or Put down")))

  (let [real-buf-id buf-id
        ;; This view is strictly a configuration container and should not
        ;; maintain any actual game state.
        view {: buf-id
              : responder
              ;; TODO remove cursor from view, it's derived from the cursor position in the game state
              :cursor game-state.cursor
              :hl-ns (api.nvim_create_namespace :shenzhen-solitaire)
              :layout {:size {:width 80 :height 40}
                       :tableau config.tableau
                       :foundation config.foundation
                       :cell config.cell
                       :buttons config.buttons
                       :card config.card}
              :config config}]
    (fn game-card->ui-card [game-card location]
      "Cards are effectively singletons both in the logic and in the UI, so we can
      stably generate a map of game-cards - really just a type, value and an
      abstract position somewhere - and ui cards - which have a more definite
      position on the screen as well as additional data such as symbols and
      colors."
      (let [pos (game-location->view-pos location view)
            hl (highlight-name-for-card game-card)
            data {:pos pos
                  :size config.card.size
                  :borders config.card.borders
                  :highlight hl}]
        [game-card (ui-card.new game-card data)]))
    ; (tset view :cards (-> (map-game-state-cards game-state game-card->ui-card)
    ;                       (enum/pairs->table)))
    (tset view :placeholders (-> [(enum/map #(iter/range 1 8) #[:tableau $1 1])
                                  (enum/map #(iter/range 1 3) #[:cell $1 1])
                                  (enum/map #(iter/range 1 4) #[:foundation $1 1])]
                                 (enum/flatten)
                                 (enum/map (fn [_ location]
                                             (let [[_ ui-card] (game-card->ui-card [:EMPTY 0] location)]
                                               (values ui-card))))))

    (define-highlight-groups config.highlight)
    (configure-buffer view)
    (values view)))

(fn game-card->ui-card [view game-card location]
  "Cards are effectively singletons both in the logic and in the UI, so we can
  stably generate a map of game-cards - really just a type, value and an
  abstract position somewhere - and ui cards - which have a more definite
  position on the screen as well as additional data such as symbols and
  colors."
  (let [pos (game-location->view-pos location view)
        hl (highlight-name-for-card game-card)
        data {:pos pos
              :size view.layout.card.size
              :borders view.layout.card.borders
              :highlight hl}]
    [game-card (ui-card.new game-card data)]))

(fn M.draw [view game-state tick?]
  "Render out a games state."
  ;; For now we do this super inefficently, because in the end it probably doesn't matter.
  ;; Potential improvements:
  ;; Apply highlights by consecutive run instead of per-position
  ;; Track "damage" diff against last fb and only re-write where we need to
  ;; TODO remove cursor from view, it's derived from the cursor position in the game state
  (tset view :cursor game-state.cursor)
  (fn draw-card [fbo card]
    (let [{: pos : size : bitmap : highlight} card
          edge-hl :Normal
          pos->char (fn [r c] (. bitmap r c))
          pos->hl (fn [r c]
                    (match [r c]
                      _ highlight
                      [1 _] edge-hl
                      [size.height _] edge-hl
                      [_ 1] edge-hl
                      [_ size.width] edge-hl))
          write #(frame-buffer.write fbo $1 pos size $2)]
      (write :draw pos->char)
      (write :color pos->hl)))

  (fn adjust-location-for-pickup-or-putdown [location]
    ;; valid pickup locations are "on card", valid put down locations are "post
    ;; card", so the cursor and markers need adjusting up a step
    (match game-state.hand
      [nil] location
      [cards] (let [[slot col-n card-n] location]
                [slot col-n (math.max 1 (- card-n 1))])))

  (let [fbo (frame-buffer.new view.size)
        for-each-game-card #(map-game-state-cards game-state $1)]
    ;; render out card slot placeholders
    (e.each view.placeholders #(draw-card fbo $2))
    ;; update our ui-card positions to reflect where they are in the game state
    ;; render cards out according to the tableau, so that's left to right top to
    ;; bottom, this gives us the correct z-indexing

    ;; HACK TODO remove this, needed wor when we load a game and the cards
    ;; lookup holds references to older cards
    (tset view :cards (-> (map-game-state-cards game-state #(game-card->ui-card view $...))
                          (enum/pairs->table)))
    (for-each-game-card
      (fn [card location]
        (let [pos (game-location->view-pos location view)]
          (tset view :cards card :highlight (highlight-name-for-card card))
          (tset view :cards card :pos pos))
        (draw-card fbo (. view :cards card))))

    ;; draw lock buttons
    (let [{: row : col} view.layout.buttons.pos
          col (+ col 2)
          red-text [:< " " :Š]
          green-text [:< " " "Ñ"]
          white-text [:< " " "Õ"]
          write #(frame-buffer.write fbo $1 {:row (+ $2 row) : col} {:width 3 :height 1} $3)]
      ;; red
      (write :draw 1 #(. red-text $2))
      (if game-state.lockable-dragons.DRAGON-RED?
        (write :color 1 #(highlight-name-for-card [:DRAGON-RED 0]))
        (write :color 1 #:Comment))
      (write :draw 2 #(. green-text $2))
      (if game-state.lockable-dragons.DRAGON-GREEN?
        (write :color 2 #(highlight-name-for-card [:DRAGON-GREEN 0]))
        (write :color 2 #:Comment))
      (write :draw 3 #(. white-text $2))
      (if game-state.lockable-dragons.DRAGON-WHITE?
        (write :color 3 #(highlight-name-for-card [:DRAGON-WHITE 0]))
        (write :color 3 #:Comment)))

    ;; draw "can move here" markers
    (each [i location (ipairs game-state.valid-locations)]
      (let [{: row : col} (-> (adjust-location-for-pickup-or-putdown location)
                              (game-location->view-pos view))
            pos {:row (+ row 1) :col (- col 2)}]
        (frame-buffer.write fbo :draw pos {:width 1 :height 1} #"▸")
        (frame-buffer.write fbo :color pos {:width 1 :height 1} #:Comment)))

    ;; draw cursor
    (let [{: row : col} (-> (adjust-location-for-pickup-or-putdown game-state.cursor)
                            (game-location->view-pos view))
          pos {:row (+ row 1) :col (- col 2)}]
      (frame-buffer.write fbo :draw pos {:width 3 :height 1} #(match $2 1 "🯁" 2 "🯂" 3 "🯃"))
      (frame-buffer.write fbo :color pos {:width 3 :height 1} #:Normal))

    ;; output frame
    (api.nvim_buf_clear_namespace view.buf-id view.hl-ns 0 -1)
    (vim.api.nvim_buf_set_lines view.buf-id 0 -1 false (enum/map fbo.draw #(table.concat $2 "")))
    ;; colorise frame (one "pixel by pixel" but could be improved into
    ;; sequetial runs and also damage tracking).
    (each [row-n row (ipairs fbo.color)]
      (accumulate [byte-offset 0 col-n hl-value (ipairs row)]
        (let [line (- row-n 1)
              new-offset (+ byte-offset (length (. fbo :draw row-n col-n)))
              col-start (- new-offset 1)
              col-end (+ new-offset 2)
              hl-name (. fbo.color row-n col-n)]
          (if (not (= "" hl-name))
            (api.nvim_buf_add_highlight view.buf-id view.hl-ns hl-name line col-start col-end))
          (values new-offset))))
    fbo.color))

(values M)
