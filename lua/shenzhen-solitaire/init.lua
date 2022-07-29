

 local runtime = require("shenzhen-solitaire.ui.runtime") local function _2_(...)
 local mod_44_auto = string local keys_45_auto = {"format"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "string")) end return mod_44_auto end local _local_1_ = _2_(...) local fmt = _local_1_["format"] do local _ = {nil, nil} end


 local path_separator = string.match(package.config, "(.-)\n")
 local function join_path(head, ...) _G.assert((nil ~= head), "Missing argument head on /home/soup/.local/share/nvim/site/pack/manual/start/shenzhen-solitaire.nvim/fnl/shenzhen-solitaire/init.fnl:8")
 local t = head for _, part in ipairs({...}) do
 t = (t .. path_separator .. part) end return t end
 local gauntlet_path = join_path(vim.fn.stdpath("cache"), "shenzhen-solitaire.gauntlet")
 local function read_gauntlet()
 local readable_3f = (1 == vim.fn.filereadable(gauntlet_path)) local seed
 if readable_3f then seed = dofile(gauntlet_path) else seed = 1 end
 return seed end

 local M = {}

 M["first-responder"] = function(thread, event)
 local _4_, _5_ = coroutine.resume(thread, "event", event) if ((_4_ == true) and ((_G.type(_5_) == "table") and ((_5_)[1] == "ok") and true)) then local _ = (_5_)[2]
 return nil elseif ((_4_ == true) and ((_G.type(_5_) == "table") and ((_5_)[1] == "err") and (nil ~= (_5_)[2]))) then local e = (_5_)[2]
 return error((e .. debug.traceback(thread))) elseif ((_4_ == false) and (nil ~= _5_)) then local e = _5_
 return error((e .. debug.traceback(thread))) else return nil end end

 M["start-next-game"] = function(buf_id, _3fconfig)
 local seed = read_gauntlet()
 local config = (_3fconfig or {})
 do end (config)["gauntlet"] = seed
 return M["start-new-game"](buf_id, config, seed) end

 M["start-new-game"] = function(buf_id, _3fconfig, _3fseed)


 local hl_normal_background do local _let_7_ = vim.api.nvim_get_hl_by_name("Normal", true) local background = _let_7_["background"]
 local hex = fmt("#%x", background)
 hl_normal_background = hex end

 local default_config = {card = {size = {width = 7, height = 5}, borders = {ne = "\226\149\174", nw = "\226\149\173", se = "\226\149\175", sw = "\226\149\176", n = "\226\148\128", s = "\226\148\128", e = "\226\148\130", w = "\226\148\130"}}, buttons = {pos = {row = 1, col = 34}}, tableau = {pos = {row = 7, col = 1}, gap = 3}, cell = {pos = {row = 1, col = 1}, gap = 3}, foundation = {pos = {row = 1, col = 41}, gap = 3}, highlight = {empty = {fg = "#495159", bg = hl_normal_background}, button = {fg = "#495159", bg = hl_normal_background}, coin = {fg = "#e8df78", bg = hl_normal_background}, string = {fg = "#879ff6", bg = hl_normal_background}, myriad = {fg = "#23b3ac", bg = hl_normal_background}, flower = {fg = "#934188", bg = hl_normal_background}, ["dragon-green"] = {fg = "#52ad56", bg = hl_normal_background}, ["dragon-white"] = {fg = "#cfcfcf", bg = hl_normal_background}, ["dragon-red"] = {fg = "#d34d4d", bg = hl_normal_background}}, info = {pos = {row = 22, col = 3}}, size = {width = 80, height = 40}, cursor = {show = false}, difficulty = {["show-valid-locations"] = false, ["allow-undo"] = false, ["auto-move-obvious"] = true}, gauntlet = false, keys = {["left-mouse"] = "<LeftMouse>", ["right-mouse"] = "<RightMouse>", interact = "y", ["auto-move"] = "a", ["save-game"] = "ww", ["load-game"] = "ll", ["restart-game"] = "rr", ["undo-last-move"] = "u", ["next-location"] = "<Tab>", ["prev-location"] = "<S-Tab>"}}



































 local config = vim.tbl_deep_extend("force", default_config, (_3fconfig or {}))
 local thread = runtime["start-new-game"](buf_id, M["first-responder"], config, _3fseed)
 local _8_, _9_ = coroutine.resume(thread, "control", "hello") if ((_8_ == true) and ((_G.type(_9_) == "table") and ((_9_)[1] == "ok") and true)) then local _ = (_9_)[2]
 return nil elseif ((_8_ == true) and ((_G.type(_9_) == "table") and ((_9_)[1] == "err") and (nil ~= (_9_)[2]))) then local e = (_9_)[2]
 return error((e .. "\n" .. debug.traceback(thread))) elseif ((_8_ == false) and (nil ~= _9_)) then local e = _9_
 return error((e .. "\n" .. debug.traceback(thread))) else return nil end end

 return M