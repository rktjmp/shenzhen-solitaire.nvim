(vim.api.nvim_create_user_command
  "ShenzhenSolitaireNewGame"
  (fn [{: args}]
    (let [{: start-new-game} (require :shenzhen-solitaire)]
      (match [args (tonumber args)]
        ["" _] (start-new-game 0)
        [any n] (start-new-game 0 nil n)
        [any nil] (error (string.format "Could not convert %q to seed number" args)))))
  {:nargs :?})

(vim.api.nvim_create_user_command
  "ShenzhenSolitaireNextGame"
  (fn [{: args}]
    (let [{: start-next-game} (require :shenzhen-solitaire)]
      (start-next-game 0)))
  {})
