command! -range=% -nargs=* ShenzhenSolitaireNewGame
      \ :lua require("shenzhen-solitaire")["start-new-game"](0)
