(import-macros {: view : must : describe : it : rerequire} :shenzhen-solitaire.lib.donut.test)

(local deck (require :shenzhen-solitaire.game.deck))

(describe "deck generation"
  (it "doesn't generate total garbage"
      [d (deck.new)]
      (must equal :table (type d))
      ;; 3 decks of 9, 3 dragons, one flower
      (must equal (+ (* 3 9) 3 1) (length d))))

