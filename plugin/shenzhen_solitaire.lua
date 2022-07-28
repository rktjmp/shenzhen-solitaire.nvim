

 local function _3_(_1_) local _arg_2_ = _1_ local args = _arg_2_["args"]
 local _let_4_ = require("shenzhen-solitaire") local start_new_game = _let_4_["start-new-game"]
 local _5_ = {args, tonumber(args)} if ((_G.type(_5_) == "table") and ((_5_)[1] == "") and true) then local _ = (_5_)[2]
 return start_new_game(0) elseif ((_G.type(_5_) == "table") and (nil ~= (_5_)[1]) and (nil ~= (_5_)[2])) then local any = (_5_)[1] local n = (_5_)[2]
 return start_new_game(0, nil, n) elseif ((_G.type(_5_) == "table") and (nil ~= (_5_)[1]) and ((_5_)[2] == nil)) then local any = (_5_)[1]
 return error(string.format("Could not convert %q to seed number", args)) else return nil end end vim.api.nvim_create_user_command("ShenzhenSolitaireNewGame", _3_, {nargs = "?"})




 local function _9_(_7_) local _arg_8_ = _7_ local args = _arg_8_["args"]
 local _let_10_ = require("shenzhen-solitaire") local start_next_game = _let_10_["start-next-game"]
 return start_next_game(0) end return vim.api.nvim_create_user_command("ShenzhenSolitaireNextGame", _9_, {})