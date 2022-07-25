command! -nargs=? ShenzhenSolitaireNewGame
      \ :lua require("shenzhen-solitaire")["start-new-game"](0, nil, <args>)
