

 local runtime = require("shenzhen-solitaire.ui.runtime") local function _2_(...)
 local mod_44_auto = string local keys_45_auto = {"format"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "string")) end return mod_44_auto end local _local_1_ = _2_(...) local fmt = _local_1_["format"] do local _ = {nil, nil} end

 local hl_normal_background do local _let_3_ = vim.api.nvim_get_hl_by_name("Normal", true) local background = _let_3_["background"]
 local hex = fmt("#%x", background)
 hl_normal_background = hex end
 local default_config = {card = {size = {width = 7, height = 5}, borders = {ne = "\226\149\174", nw = "\226\149\173", se = "\226\149\175", sw = "\226\149\176", n = "\226\148\128", s = "\226\148\128", e = "\226\148\130", w = "\226\148\130"}}, buttons = {pos = {row = 1, col = 34}}, tableau = {pos = {row = 7, col = 1}, gap = 3}, cell = {pos = {row = 1, col = 1}, gap = 3}, foundation = {pos = {row = 1, col = 41}, gap = 3}, highlight = {empty = {fg = "grey", bg = hl_normal_background}, button = {fg = "gray", bg = hl_normal_background}, coin = {fg = "#e8df78", bg = hl_normal_background}, string = {fg = "#879ff6", bg = hl_normal_background}, myriad = {fg = "#23b3ac", bg = hl_normal_background}, flower = {fg = "#934188", bg = hl_normal_background}, ["dragon-green"] = {fg = "#52ad56", bg = hl_normal_background}, ["dragon-white"] = {fg = "#cfcfcf", bg = hl_normal_background}, ["dragon-red"] = {fg = "#d34d4d", bg = hl_normal_background}}, info = {pos = {row = 22, col = 3}}, size = {width = 80, height = 40}, cursor = {show = true}, difficulty = {["show-valid-locations"] = true, ["allow-undo"] = false, ["auto-move-obvious"] = true}, keys = {["left-mouse"] = "<LeftMouse>", ["right-mouse"] = "<RightMouse>", interact = "y", ["auto-move"] = "a", ["save-game"] = "szw", ["load-game"] = "szl", ["restart-game"] = "szr", ["undo-last-move"] = "u", ["next-location"] = "<Tab>", ["prev-location"] = "<S-Tab>"}}




































 local M = {}

 M["first-responder"] = function(thread, event)
 local _4_, _5_ = coroutine.resume(thread, "event", event) if ((_4_ == true) and ((_G.type(_5_) == "table") and ((_5_)[1] == "ok") and true)) then local _ = (_5_)[2]
 return nil elseif ((_4_ == true) and ((_G.type(_5_) == "table") and ((_5_)[1] == "err") and (nil ~= (_5_)[2]))) then local e = (_5_)[2]
 return error((e .. debug.traceback(thread))) elseif ((_4_ == false) and (nil ~= _5_)) then local e = _5_
 return error((e .. debug.traceback(thread))) else return nil end end

 M["start-new-game"] = function(buf_id, _3fconfig, _3fseed)
 local config = vim.tbl_deep_extend("force", default_config, (_3fconfig or {}))
 local game_thread = runtime["start-new-game"](buf_id, M["first-responder"], config, _3fseed)
 return assert(coroutine.resume(game_thread, "control", "hello")) end

 return M