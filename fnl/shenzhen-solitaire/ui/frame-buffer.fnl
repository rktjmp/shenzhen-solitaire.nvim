(import-macros {: use} :shenzhen-solitaire.lib.donut.use)

(use {: range} :shenzhen-solitaire.lib.donut.iter :ns iter
     {: map} :shenzhen-solitaire.lib.donut.enum :ns enum)

(local M {})

(fn M.new [config]
  "Create a new FBO containing a draw and color buffer."
  ;; TODO accpet config size
  (local config {:size {:width 80 :height 40}})
  (let [{: width : height} config.size
        map-positions (fn [val]
                        (enum/map #(iter/range 1 height)
                                  #(enum/map #(iter/range 1 width)
                                             #val)))
        draw (map-positions " ")
        color (map-positions "")]
    {:size {:width width :height height}
     :draw draw
     :color color}))

(fn M.write [fbo buffer-name pos size f]
  "Accepts fbo and buffer name, position and size tables and function. Calls
  (f r c) for every position between row -> row+width and col -> col+height.
  Returns fbo."
  (let [{: row : col} pos
        {: width : height} size]
    (for [r 1 height]
      (for [c 1 width]
        (tset fbo buffer-name (+ (- r 1) row) (+ (- c 1) col) (f r c)))))
  (values fbo))

(values M)
