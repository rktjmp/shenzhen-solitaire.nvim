(tset package.loaded :shenzhen-solitaire.ui.frame-buffer nil)
(tset package.loaded :shenzhen-solitaire.ui.card nil)

(import-macros {: use} :shenzhen-solitaire.lib.donut.use)

(use {: range} :shenzhen-solitaire.lib.donut.iter :ns iter
     {: inspect!} :shenzhen-solitaire.lib.donut.inspect
     {: map : each : flat-map : flatten
      : split : pairs->table : set$ : reduce} :shenzhen-solitaire.lib.donut.enum :ns enum
     E :shenzhen-solitaire.lib.donut.enum
     {: start-new-game} :shenzhen-solitaire.game.logic
     {:format fmt} string
     frame-buffer :shenzhen-solitaire.ui.frame-buffer
     ui-card :shenzhen-solitaire.ui.card)

(local api vim.api)
(local M {})
(local FRAME-INTERVAL (* 1000 (/ 1 60)))

(fn highlight-group-for-component [card]
  (let [[kind _] card]
    (match kind
      :EMPTY :SHZHEmptyLocation
      :BUTTON :SHZHButton
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
      [:hand col-n card-n] (let [{:locations {: cursor}} view
                                 [slot cur-col-n cur-card-n] cursor
                                 {: row : col} (game-location->view-pos [slot cur-col-n (-> (- cur-card-n 1)
                                                                                            (+ card-n))]
                                                                        view)]
                             {:row row :col (+ col 1)})
      ;; we use this to work out where to put the cursor, but the adjustments here are
      ;; to shift the cursor up rows to align with the buttons which are drawn differently.
      [:BUTTON _ button] (let [{: row : col} layout.buttons.pos]
                           (match button
                             1 {:row (+ row) : col}
                             2 {:row (+ row 1) : col}
                             3 {:row (+ row 2) : col}))

      _ (error (.. :unknown-location (vim.inspect location))))))

(fn map-state-cards [state f]
  "map f over all cards in state"
  (E.flat-map [:cell :foundation :tableau :hand]
              (fn [_ slot]
                (E.flat-map (. state slot)
                            (fn [col-n col]
                              (E.map col
                                     (fn [card-n card]
                                       (f card [slot col-n card-n]))))))))

(fn game-card->ui-card [game-card location view]
  "Cards are effectively singletons both in the logic and in the UI, so we can
  stably generate a map of game-cards - really just a type, value and an
  abstract position somewhere - and ui cards - which have a more definite
  position on the screen as well as additional data such as symbols and
  colors."
  (let [{: layout} view
        pos (game-location->view-pos location view)
        hl (highlight-group-for-component game-card)
        data {:pos pos
              :location location
              :size layout.card.size
              :borders layout.card.borders
              :highlight hl}]
    [game-card (ui-card.new game-card data)]))


(fn M.new [{: buf-id : responder : state : config}]
  "Configures given buffer to act as game view and does some preparation busy work.

  Returns table describing view."
  ;; Some data we can use directly, but we must inspect the state to
  ;; generate drawable cards for each card in the state. Thes cards are
  ;; effectively constants so we can map between ui and runtime states
  ;; this way.
  (let [view {: buf-id
              :winid (api.nvim_buf_call buf-id api.nvim_get_current_win)
              : responder
              :hl-ns (api.nvim_create_namespace :shenzhen-solitaire)
              :show {:cursor config.cursor.show
                     :valid-locations config.difficulty.show-valid-locations}
              ;; If any cards are in-hand at this point, we'll just fake a location
              ;; for the current cursor. The first update call should correct any of
              ;; this, though we may get animation quirks.
              :locations {:cursor [:tableau 1 5]} ;; TBD in first update call
              :holding? false
              :meta {}
              :layout {:size {:width 80 :height 40}
                       :info config.info
                       :tableau config.tableau
                       :foundation config.foundation
                       :cell config.cell
                       :buttons config.buttons
                       :card config.card}}]
    (tset view :cards (-> (map-state-cards state #(game-card->ui-card $1 [:foundation 4 1] view))
                          (enum/pairs->table)))
    (tset view :placeholders (-> [(enum/map #(iter/range 1 8) #[:tableau $1 1])
                                  (enum/map #(iter/range 1 3) #[:cell $1 1])
                                  (enum/map #(iter/range 1 4) #[:foundation $1 1])]
                                 (enum/flatten)
                                 (enum/map (fn [_ location]
                                             (let [[_ ui-card] (game-card->ui-card [:EMPTY 0] location view)]
                                               (values [ui-card location]))))))
    (let [set-hl #(api.nvim_set_hl 0 (highlight-group-for-component [$1 0]) $2)]
      (set-hl :EMPTY config.highlight.empty)
      (set-hl :BUTTON config.highlight.button)
      (set-hl :COIN config.highlight.coin)
      (set-hl :STRING config.highlight.string)
      (set-hl :MYRIAD config.highlight.myriad)
      (set-hl :DRAGON-RED config.highlight.dragon-red)
      (set-hl :DRAGON-WHITE config.highlight.dragon-white)
      (set-hl :DRAGON-GREEN config.highlight.dragon-green)
      (set-hl :FLOWER config.highlight.flower))

    (let [{: buf-id : responder} view
          set-km #(api.nvim_buf_set_keymap buf-id :n (. config :keys $1) ""
                                           {:callback (fn [] (responder {:name $1 :view view}))
                                            :noremap false
                                            :nowait true
                                            :desc $2})]
      (let [buf-opts {:filetype :shenzhen-solitaire}
            win-opts {:cursorline false
                      :number false
                      :list false
                      :relativenumber false}]
        (enum/map buf-opts #(api.nvim_buf_set_option buf-id $1 $2))
        (api.nvim_buf_call buf-id
                           #(let [win-id (api.nvim_get_current_win)]
                              (enum/map win-opts #(api.nvim_win_set_option win-id $1 $2)))))

      (set-km :save-game "Save current game")
      (set-km :load-game "Load last saved game")
      (set-km :restart-game "Restart current game")
      (set-km :undo-last-move "Undo last move")
      (set-km :next-location "Move to next location")
      (set-km :prev-location "Move to previous location")
      (set-km :interact "Pick up, put down, interact")
      (set-km :auto-move "Automatically move best cards")

      ;; Most events can just be passed though but mouse clicks need to actually translate
      ;; between the view data and runtime data.
      (fn byte-offset->col [row target-byte-offset]
        ;; or here for clicks outside of window/range which shoujd just no-op
        (let [[_ index] (E.reduce (or (. view :fbo :draw row) []) [0 0]
                                  (fn [[byte-count index] i bytes]
                                    (if (<= target-byte-offset byte-count)
                                      [byte-count index]
                                      (let [byte-count (+ byte-count (length bytes))
                                            index i]
                                        [byte-count index]))))]
          (values index)))

      (fn bind-mouse [lhs event-name desc]
        (let [eval-er (fmt "\"\\%s\"" lhs)
              cb (vim.schedule_wrap
                   #(let [{: winid :column byte-offset :line row} (vim.fn.getmousepos)
                          col (byte-offset->col row byte-offset)]
                      ;; map col row to location, this may fail as click can be
                      ;; outside the buffer when switching.
                      (if (= winid view.winid)
                        ;; clicked in same win, send event
                        (match (?. view :fbo :hit row col)
                          (where loc (< 0 (length loc)))
                          (responder {:name event-name :location loc :view view}))
                        ;; different win, pass would-be click
                        (vim.cmd (.. "normal! " (api.nvim_eval eval-er))))))]
          (api.nvim_buf_set_keymap buf-id :n lhs "" {:callback cb :desc desc})))
      (bind-mouse :<LeftMouse> :left-mouse "Inferred action for left mouse")
      (bind-mouse :<RightMouse> :right-mouse "Inferred action for right mouse"))

    (values view)))

(fn location-equal [loc-1 loc-2]
  (match [loc-1 loc-2]
    [[a b c] [a b c]] true
    _ false))

(fn M.update [view {: state : locations : meta}]
  ;; refresh ui cards to match state
  ;; we want to render in-order but the ui-cards are unordered, attach the order seen
  ;; to the card as a z-index.
  (var z 0)
  (var stagger 0)
  (map-state-cards
    state
    (fn [card location]
      (set z (+ z 1))
      (let [pos (game-location->view-pos location view)
            ui-card (. view :cards card)]
        ;; animate if card location changed
        (if (not (location-equal ui-card.location location))
          ;; cart location is the same, so not much to do
          (let [a ui-card.pos
                b pos
                ;; cols are twice as a row is high, so we inflate the row
                ;; count so left-right movements take as long as top-down.
                dist  (-> (+ (math.pow (math.abs (* 2 (- a.row b.row))) 2)
                             (math.pow (math.abs (* 1 (- a.col b.col))) 2))
                          (math.sqrt))
                ms-per-dist 5
                time-to-animate (math.min (* ms-per-dist dist) 200)
                started-at (+ (vim.loop.now) (* stagger 25))]
            (set stagger (+ stagger 1))
            (doto ui-card
              (tset :z-index (+ 100 z))
              (tset :animating {:from ui-card.pos
                                :to pos
                                :started-at started-at
                                :time-to-animate time-to-animate})
              (tset :pos ui-card.pos)))
          (doto ui-card
            (tset :z-index z)
            (tset :animating nil)
            (tset :pos pos)))
        (doto ui-card
          (tset :highlight (highlight-group-for-component card))
          (tset :location location)))))

  ;; just copy meta data over directly I guess
  (tset view :meta {:wins meta.wins
                    :won? meta.won?
                    :gauntlet meta.gauntlet
                    ;; TODO: strip first setup events, but should be real count
                    :moves (- (length state.events) 3)})
  (tset view :holding? (match state.hand [nil] false [cards] true))
  (tset view :locations locations)
  (vim.defer_fn #(M.tick view) FRAME-INTERVAL)
  (values view))

(fn M.tick [view last-time]
  (var redraw false)
  (fn lerp [a b t]
    (math.ceil (+ a (* (- b a) t))))
  (E.map view.cards
         (fn [_ card]
           (match (?. card :animating)
             (where {:from a :to b : time-to-animate : started-at} (<= started-at (vim.loop.now)))
             (let [rem (- (vim.loop.now) started-at)
                   t (math.min 1.0 (/ rem time-to-animate))
                   pos {:row (lerp a.row b.row t)
                        :col (lerp a.col b.col t)}]
               (set redraw true)
               ;; TODO max these vals
               (tset card :pos pos)
               (when (<= 1 t)
                 (tset card :pos b)
                 (tset card :z-index (- card.z-index 100))
                 (tset card :animating nil))))))
  (M.draw view)
  ;; since we draw the un-animated cards, cursor, then the animated cards, we
  ;; need to force a redraw after the last animation is pushed through which
  ;; should just draw the cards, then the cursor.
  (if (or redraw last-time)
    (vim.defer_fn #(M.tick view redraw) FRAME-INTERVAL))
  (values view))

(fn M.draw [view]
  "Render out a games state."
  ;; For now we do this super inefficently, because in the end it probably doesn't matter.
  ;; Potential improvements:
  ;; Apply highlights by consecutive run instead of per-position
  ;; Track "damage" diff against last fb and only re-write where we need to
  (fn draw-card [fbo card location]
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
      (assert location "no location")
      (write :draw pos->char)
      (write :color pos->hl)
      (write :hit #location)))

  (fn adjust-location-for-pickup-or-putdown [location]
    ;; valid pickup locations are "on card", valid put down locations are "post
    ;; card", so the cursor and markers need adjusting up a step
    (if view.holding?
      (let [[slot col-n card-n] location]
        [slot col-n (math.max 1 (- card-n 1))])
      location))

  (let [fbo (frame-buffer.new view.size)
        _ (set view.fbo fbo)]
    ;; render out card slot placeholders
    (E.each view.placeholders
            #(let [[card _] $2] ;; TODO slim out location
               (draw-card fbo card card.location)))

    ;; update our ui-card positions to reflect where they are in the game state
    ;; render cards out according to the tableau, so that's left to right top to
    ;; bottom, this gives us the correct z-indexing

    ;; draw info, this is lower than the cards so stacks can over-write it
    (let [info-string (if view.meta.gauntlet
                        (fmt "level: %d moves: %d " view.meta.gauntlet view.meta.moves)
                        (fmt "wins: %d moves: %d " view.meta.wins view.meta.moves))
          info (icollect [c (string.gmatch info-string ".")] c)]
      (frame-buffer.write fbo :draw view.layout.info.pos {:height 1 :width (length info)} #(. info $2)))

    ;; draw lock buttons
    (let [{: row : col} view.layout.buttons.pos
          col (+ col 2)
          red-text [:< " " :Š]
          green-text [:< " " "Ñ"]
          white-text [:< " " "Õ"]
          write #(frame-buffer.write fbo $1 {:row (+ $2 row) : col} {:width 3 :height 1} $3)
          ;; We *always* draw the lock buttons, but only highlight them
          ;; when they're valid locations.
          ;; TODO values are hard-coded for now
          on-off (E.reduce view.locations.buttons {}
                           #(match $3
                              [:BUTTON 1 1] (E.set$ $1 :RED $3)
                              [:BUTTON 1 2] (E.set$ $1 :GREEN $3)
                              [:BUTTON 1 3] (E.set$ $1 :WHITE $3)
                              _ $1))]
      (write :draw 1 #(. red-text $2))
      (if on-off.RED
        (do
          (write :color 1 #(highlight-group-for-component [:DRAGON-RED 0]))
          (write :hit 1 #on-off.RED))
        (write :color 1 #(highlight-group-for-component [:BUTTON 0])))

      (write :draw 2 #(. green-text $2))
      (if on-off.GREEN
        (do
          (write :color 2 #(highlight-group-for-component [:DRAGON-GREEN 0]))
          (write :hit 2 #on-off.GREEN))
        (write :color 2 #(highlight-group-for-component [:BUTTON 0])))

      (write :draw 3 #(. white-text $2))
      (if on-off.WHITE
        (do
          (write :color 3 #(highlight-group-for-component [:DRAGON-WHITE 0]))
          (write :hit 3 #on-off.WHITE))
        (write :color 3 #(highlight-group-for-component [:BUTTON 0]))))

    ;; draw "can move here" markers
    (if view.show.valid-locations
      (each [i location (ipairs view.locations.cards)]
        (let [{: row : col} (-> (adjust-location-for-pickup-or-putdown location)
                                (game-location->view-pos view))
              pos {:row (+ row 1) :col (- col 2)}]
          (frame-buffer.write fbo :draw pos {:width 1 :height 1} #"▸")
          (frame-buffer.write fbo :color pos {:width 1 :height 1} #(highlight-group-for-component [:BUTTON 0])))))

    ;; draw non animating cards
    (-> (E.map view.cards #$2)
        (E.filter #(match $2 {: animating} false _ true))
        (E.sort$ #(< $1.z-index $2.z-index))
        (E.map #(draw-card fbo $2 $2.location)))

    ;; draw cursor
    (if view.show.cursor
      (let [{: row : col} (-> (adjust-location-for-pickup-or-putdown view.locations.cursor)
                              (game-location->view-pos view))
            pos {:row (+ row 1) :col (- col 2)}]
        (frame-buffer.write fbo :draw pos {:width 3 :height 1} #(match $2 1 "🯁" 2 "🯂" 3 "🯃"))
        (frame-buffer.write fbo :color pos {:width 3 :height 1} #:Normal)))

    ;; draw animating cards on top
    ;; this doesn't quite work because of how draw is only called as needed,
    ;; eg. post-tick-with-animate
    (-> (E.map view.cards #$2)
        (E.filter #(match $2 {: animating} true _ false))
        (E.sort$ #(< $1.z-index $2.z-index))
        (E.map #(draw-card fbo $2 $2.location)))

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
              col-end (+ new-offset 0)
              hl-name (. fbo.color row-n col-n)]
          (if (not (= "" hl-name))
            (api.nvim_buf_add_highlight view.buf-id view.hl-ns hl-name line col-start col-end))
          (values new-offset))))))

(values M)
