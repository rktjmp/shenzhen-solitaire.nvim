 package.loaded["shenzhen-solitaire.ui.frame-buffer"] = nil
 package.loaded["shenzhen-solitaire.ui.card"] = nil



 local function _2_(...) local mod_36_auto = require("shenzhen-solitaire.lib.donut.iter") local keys_37_auto = {"range"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.lib.donut.iter\"")) end return mod_36_auto end local _local_1_ = _2_(...) local iter_2frange = _local_1_["range"] local function _4_(...) local mod_36_auto = require("shenzhen-solitaire.lib.donut.inspect") local keys_37_auto = {"inspect!"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.lib.donut.inspect\"")) end return mod_36_auto end local _local_3_ = _4_(...) local inspect_21 = _local_3_["inspect!"] local function _6_(...) local mod_36_auto = require("shenzhen-solitaire.lib.donut.enum") local keys_37_auto = {"split", "map", "flat-map", "flatten", "pairs->table", "set$", "reduce", "each"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.lib.donut.enum\"")) end return mod_36_auto end local _local_5_ = _6_(...) local enum_2feach = _local_5_["each"] local enum_2fflat_map = _local_5_["flat-map"] local enum_2fflatten = _local_5_["flatten"] local enum_2fmap = _local_5_["map"] local enum_2fpairs__3etable = _local_5_["pairs->table"] local enum_2freduce = _local_5_["reduce"] local enum_2fset_24 = _local_5_["set$"] local enum_2fsplit = _local_5_["split"] local E = require("shenzhen-solitaire.lib.donut.enum") local function _8_(...) local mod_36_auto = require("shenzhen-solitaire.game.logic") local keys_37_auto = {"start-new-game"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.game.logic\"")) end return mod_36_auto end local _local_7_ = _8_(...) local start_new_game = _local_7_["start-new-game"] local function _10_(...)





 local mod_36_auto = string local keys_37_auto = {"format"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "string")) end return mod_36_auto end local _local_9_ = _10_(...) local fmt = _local_9_["format"] local frame_buffer = require("shenzhen-solitaire.ui.frame-buffer") local ui_card = require("shenzhen-solitaire.ui.card") do local _ = {nil, nil, nil, nil, nil, nil, nil, nil} end



 local api = vim.api
 local M = {}
 local FRAME_INTERVAL = (1000 * (1 / 60))

 local function highlight_group_for_component(card)
 local _let_11_ = card local kind = _let_11_[1] local _ = _let_11_[2]
 local _12_ = kind if (_12_ == "EMPTY") then return "SHZHEmptyLocation" elseif (_12_ == "BUTTON") then return "SHZHButton" elseif (_12_ == "COIN") then return "SHZHCardCoin" elseif (_12_ == "STRING") then return "SHZHCardString" elseif (_12_ == "MYRIAD") then return "SHZHCardMyriad" elseif (_12_ == "FLOWER") then return "SHZHCardFlower" elseif (_12_ == "DRAGON-RED") then return "SHZHCardDragonRed" elseif (_12_ == "DRAGON-GREEN") then return "SHZHCardDragonGreen" elseif (_12_ == "DRAGON-WHITE") then return "SHZHCardDragonWhite" else return nil end end










 local function game_location__3eview_pos(location, view)

 local _let_14_ = view local layout = _let_14_["layout"]
 local _15_ = location if ((_G.type(_15_) == "table") and ((_15_)[1] == "tableau") and (nil ~= (_15_)[2]) and (nil ~= (_15_)[3])) then local col_n = (_15_)[2] local card_n = (_15_)[3]
 return {row = (layout.tableau.pos.row + ((card_n - 1) * 2)), col = (layout.tableau.pos.col + layout.tableau.gap + ((col_n - 1) * (layout.tableau.gap + layout.card.size.width)))} elseif ((_G.type(_15_) == "table") and ((_15_)[1] == "cell") and (nil ~= (_15_)[2]) and (nil ~= (_15_)[3])) then local col_n = (_15_)[2] local card_n = (_15_)[3]




 return {row = layout.cell.pos.row, col = (layout.cell.pos.col + layout.cell.gap + ((col_n - 1) * (layout.cell.gap + layout.card.size.width)))} elseif ((_G.type(_15_) == "table") and ((_15_)[1] == "foundation") and ((_15_)[2] == 4) and (nil ~= (_15_)[3])) then local card_n = (_15_)[3]




 return {row = layout.foundation.pos.row, col = (layout.foundation.gap + layout.foundation.pos.col + ((1 - 1) * (layout.foundation.gap + layout.card.size.width)))} elseif ((_G.type(_15_) == "table") and ((_15_)[1] == "foundation") and (nil ~= (_15_)[2]) and (nil ~= (_15_)[3])) then local col_n = (_15_)[2] local card_n = (_15_)[3]




 return {row = layout.foundation.pos.row, col = (layout.foundation.gap + layout.foundation.pos.col + layout.card.size.width + layout.foundation.gap + ((col_n - 1) * (layout.foundation.gap + layout.card.size.width)))} elseif ((_G.type(_15_) == "table") and ((_15_)[1] == "hand") and (nil ~= (_15_)[2]) and (nil ~= (_15_)[3])) then local col_n = (_15_)[2] local card_n = (_15_)[3]









 local _let_16_ = view local _let_17_ = _let_16_["locations"] local cursor = _let_17_["cursor"]
 local _let_18_ = cursor local slot = _let_18_[1] local cur_col_n = _let_18_[2] local cur_card_n = _let_18_[3]
 local _let_19_ = game_location__3eview_pos({slot, cur_col_n, ((cur_card_n - 1) + card_n)}, view) local row = _let_19_["row"] local col = _let_19_["col"]


 return {row = row, col = (col + 1)} elseif ((_G.type(_15_) == "table") and ((_15_)[1] == "BUTTON") and true and (nil ~= (_15_)[3])) then local _ = (_15_)[2] local button = (_15_)[3]


 local _let_20_ = layout.buttons.pos local row = _let_20_["row"] local col = _let_20_["col"]
 local _21_ = button if (_21_ == 1) then
 return {row = row, col = col} elseif (_21_ == 2) then
 return {row = (row + 1), col = col} elseif (_21_ == 3) then
 return {row = (row + 2), col = col} else return nil end elseif true then local _ = _15_

 return error(("unknown-location" .. vim.inspect(location))) else return nil end end

 local function map_state_cards(state, f)


 local function _24_(_, slot)

 local function _25_(col_n, col)

 local function _26_(card_n, card)
 return f(card, {slot, col_n, card_n}) end return E.map(col, _26_) end return E["flat-map"](state[slot], _25_) end return E["flat-map"]({"cell", "foundation", "tableau", "hand"}, _24_) end

 local function game_card__3eui_card(game_card, location, view)





 local _let_27_ = view local layout = _let_27_["layout"]
 local pos = game_location__3eview_pos(location, view)
 local hl = highlight_group_for_component(game_card)
 local data = {pos = pos, location = location, size = layout.card.size, borders = layout.card.borders, highlight = hl}




 return {game_card, ui_card.new(game_card, data)} end


 M.new = function(_28_) local _arg_29_ = _28_ local buf_id = _arg_29_["buf-id"] local responder = _arg_29_["responder"] local state = _arg_29_["state"] local config = _arg_29_["config"]







 local view = {["buf-id"] = buf_id, winid = api.nvim_buf_call(buf_id, api.nvim_get_current_win), responder = responder, ["hl-ns"] = api.nvim_create_namespace("shenzhen-solitaire"), show = {cursor = config.cursor.show, ["valid-locations"] = config.difficulty["show-valid-locations"]}, locations = {cursor = {"tableau", 1, 5}}, meta = {}, layout = {size = {width = 80, height = 40}, info = config.info, tableau = config.tableau, foundation = config.foundation, cell = config.cell, buttons = config.buttons, card = config.card}, ["holding?"] = false}


















 local function _30_(_241) return game_card__3eui_card(_241, {"foundation", 4, 1}, view) end view["cards"] = enum_2fpairs__3etable(map_state_cards(state, _30_))

 local function _31_() return iter_2frange(1, 8) end local function _32_(_241) return {"tableau", _241, 1} end
 local function _33_() return iter_2frange(1, 3) end local function _34_(_241) return {"cell", _241, 1} end
 local function _35_() return iter_2frange(1, 4) end local function _36_(_241) return {"foundation", _241, 1} end

 local function _37_(_, location)
 local _let_38_ = game_card__3eui_card({"EMPTY", 0}, location, view) local _0 = _let_38_[1] local ui_card0 = _let_38_[2]
 return {ui_card0, location} end view["placeholders"] = enum_2fmap(enum_2fflatten({enum_2fmap(_31_, _32_), enum_2fmap(_33_, _34_), enum_2fmap(_35_, _36_)}), _37_)
 do local set_hl local function _39_(_241, _242) return api.nvim_set_hl(0, highlight_group_for_component({_241, 0}), _242) end set_hl = _39_
 set_hl("EMPTY", config.highlight.empty)
 set_hl("BUTTON", config.highlight.button)
 set_hl("COIN", config.highlight.coin)
 set_hl("STRING", config.highlight.string)
 set_hl("MYRIAD", config.highlight.myriad)
 set_hl("DRAGON-RED", config.highlight["dragon-red"])
 set_hl("DRAGON-WHITE", config.highlight["dragon-white"])
 set_hl("DRAGON-GREEN", config.highlight["dragon-green"])
 set_hl("FLOWER", config.highlight.flower) end

 do local _let_40_ = view local buf_id0 = _let_40_["buf-id"] local responder0 = _let_40_["responder"] local set_km
 local function _41_(_241, _242)
 local function _42_() return responder0({name = _241, view = view}) end return api.nvim_buf_set_keymap(buf_id0, "n", config.keys[_241], "", {callback = _42_, nowait = true, desc = _242, noremap = false}) end set_km = _41_



 do local buf_opts = {filetype = "shenzhen-solitaire"}
 local win_opts = {relativenumber = false, list = false, cursorline = false, number = false}



 local function _43_(_241, _242) return api.nvim_buf_set_option(buf_id0, _241, _242) end enum_2fmap(buf_opts, _43_)

 local function _44_() local win_id = api.nvim_get_current_win()
 local function _45_(_2410, _2420) return api.nvim_win_set_option(win_id, _2410, _2420) end return enum_2fmap(win_opts, _45_) end api.nvim_buf_call(buf_id0, _44_) end

 set_km("save-game", "Save current game")
 set_km("load-game", "Load last saved game")
 set_km("restart-game", "Restart current game")
 set_km("undo-last-move", "Undo last move")
 set_km("next-location", "Move to next location")
 set_km("prev-location", "Move to previous location")
 set_km("interact", "Pick up, put down, interact")
 set_km("auto-move", "Automatically move best cards")



 local function byte_offset__3ecol(row, target_byte_offset)


 local function _49_(_47_, i, bytes) local _arg_48_ = _47_ local byte_count = _arg_48_[1] local index = _arg_48_[2]
 if (target_byte_offset <= byte_count) then
 return {byte_count, index} else
 local byte_count0 = (byte_count + #bytes)
 local index0 = i
 return {byte_count0, index0} end end local _let_46_ = E.reduce((view.fbo.draw[row] or {}), {0, 0}, _49_) local _ = _let_46_[1] local index = _let_46_[2]
 return index end

 local function bind_mouse(lhs, event_name, desc)
 local eval_er = fmt("\"\\%s\"", lhs) local cb

 local function _51_() local _let_52_ = vim.fn.getmousepos() local winid = _let_52_["winid"] local byte_offset = _let_52_["column"] local row = _let_52_["line"]
 local col = byte_offset__3ecol(row, byte_offset)


 if (winid == view.winid) then

 local _53_ do local t_54_ = view if (nil ~= t_54_) then t_54_ = (t_54_).fbo else end if (nil ~= t_54_) then t_54_ = (t_54_).hit else end if (nil ~= t_54_) then t_54_ = (t_54_)[row] else end if (nil ~= t_54_) then t_54_ = (t_54_)[col] else end _53_ = t_54_ end local function _59_() local loc = _53_ return (0 < #loc) end if ((nil ~= _53_) and _59_()) then local loc = _53_

 return responder0({name = event_name, location = loc, view = view}) else return nil end else

 return vim.cmd(("normal! " .. api.nvim_eval(eval_er))) end end cb = vim.schedule_wrap(_51_)
 return api.nvim_buf_set_keymap(buf_id0, "n", lhs, "", {callback = cb, desc = desc}) end
 bind_mouse("<LeftMouse>", "left-mouse", "Inferred action for left mouse")
 bind_mouse("<RightMouse>", "right-mouse", "Inferred action for right mouse") end

 return view end

 local function location_equal(loc_1, loc_2)
 local _62_ = {loc_1, loc_2} if ((_G.type(_62_) == "table") and ((_G.type((_62_)[1]) == "table") and (nil ~= ((_62_)[1])[1]) and (nil ~= ((_62_)[1])[2]) and (nil ~= ((_62_)[1])[3])) and ((_G.type((_62_)[2]) == "table") and (((_62_)[1])[1] == ((_62_)[2])[1]) and (((_62_)[1])[2] == ((_62_)[2])[2]) and (((_62_)[1])[3] == ((_62_)[2])[3]))) then local a = ((_62_)[1])[1] local b = ((_62_)[1])[2] local c = ((_62_)[1])[3] return true elseif true then local _ = _62_ return false else return nil end end



 M.update = function(view, _64_) local _arg_65_ = _64_ local state = _arg_65_["state"] local locations = _arg_65_["locations"] local meta = _arg_65_["meta"] local z = 0 local stagger = 0







 local function _66_(card, location)
 z = (z + 1)
 local pos = game_location__3eview_pos(location, view)
 local ui_card0 = view.cards[card]

 if not location_equal(ui_card0.location, location) then

 local a = ui_card0.pos
 local b = pos


 local dist = math.sqrt((math.pow(math.abs((2 * (a.row - b.row))), 2) + math.pow(math.abs((1 * (a.col - b.col))), 2))) local ms_per_dist = 5



 local time_to_animate = math.min((ms_per_dist * dist), 200)
 local started_at = (vim.loop.now() + (stagger * 25))
 stagger = (stagger + 1)
 ui_card0["z-index"] = (100 + z) do end (ui_card0)["animating"] = {from = ui_card0.pos, to = pos, ["started-at"] = started_at, ["time-to-animate"] = time_to_animate} ui_card0["pos"] = ui_card0.pos else






 ui_card0["z-index"] = z ui_card0["animating"] = nil ui_card0["pos"] = pos end



 ui_card0["highlight"] = highlight_group_for_component(card) do end (ui_card0)["location"] = location return ui_card0 end map_state_cards(state, _66_)




 do end (view)["meta"] = {wins = meta.wins, ["won?"] = meta["won?"], gauntlet = meta.gauntlet, moves = (#state.events - 3)}




 local _69_ do local _68_ = state.hand if ((_G.type(_68_) == "table") and ((_68_)[1] == nil)) then _69_ = false elseif ((_G.type(_68_) == "table") and (nil ~= (_68_)[1])) then local cards = (_68_)[1] _69_ = true else _69_ = nil end end view["holding?"] = _69_
 view["locations"] = locations
 local function _73_() return M.tick(view) end vim.defer_fn(_73_, FRAME_INTERVAL)
 return view end

 M.tick = function(view, last_time) local redraw = false

 local function lerp(a, b, t)
 return math.ceil((a + ((b - a) * t))) end

 local function _74_(_, card)
 local _75_ do local t_76_ = card if (nil ~= t_76_) then t_76_ = (t_76_).animating else end _75_ = t_76_ end local function _78_() local a = (_75_).from local b = (_75_).to local time_to_animate = (_75_)["time-to-animate"] local started_at = (_75_)["started-at"] return (started_at <= vim.loop.now()) end if (((_G.type(_75_) == "table") and (nil ~= (_75_).from) and (nil ~= (_75_).to) and (nil ~= (_75_)["time-to-animate"]) and (nil ~= (_75_)["started-at"])) and _78_()) then local a = (_75_).from local b = (_75_).to local time_to_animate = (_75_)["time-to-animate"] local started_at = (_75_)["started-at"]

 local rem = (vim.loop.now() - started_at)
 local t = math.min(1, (rem / time_to_animate))
 local pos = {row = lerp(a.row, b.row, t), col = lerp(a.col, b.col, t)} redraw = true



 card["pos"] = pos
 if (1 <= t) then
 card["pos"] = b
 card["z-index"] = (card["z-index"] - 100)
 do end (card)["animating"] = nil return nil else return nil end else return nil end end E.map(view.cards, _74_)
 M.draw(view)



 if (redraw or last_time) then
 local function _81_() return M.tick(view, redraw) end vim.defer_fn(_81_, FRAME_INTERVAL) else end
 return view end

 M.draw = function(view)





 local function draw_card(fbo, card, location)
 local _let_83_ = card local pos = _let_83_["pos"] local size = _let_83_["size"] local bitmap = _let_83_["bitmap"] local highlight = _let_83_["highlight"] local edge_hl = "Normal" local pos__3echar

 local function _84_(r, c) return bitmap[r][c] end pos__3echar = _84_ local pos__3ehl
 local function _85_(r, c)
 local _86_ = {r, c} if true then local _ = _86_
 return highlight elseif ((_G.type(_86_) == "table") and ((_86_)[1] == 1) and true) then local _ = (_86_)[2]
 return edge_hl elseif ((_G.type(_86_) == "table") and ((_86_)[1] == size.height) and true) then local _ = (_86_)[2]
 return edge_hl elseif ((_G.type(_86_) == "table") and true and ((_86_)[2] == 1)) then local _ = (_86_)[1]
 return edge_hl elseif ((_G.type(_86_) == "table") and true and ((_86_)[2] == size.width)) then local _ = (_86_)[1]
 return edge_hl else return nil end end pos__3ehl = _85_ local write
 local function _88_(_241, _242) return frame_buffer.write(fbo, _241, pos, size, _242) end write = _88_
 assert(location, "no location")
 write("draw", pos__3echar)
 write("color", pos__3ehl)
 local function _89_() return location end return write("hit", _89_) end

 local function adjust_location_for_pickup_or_putdown(location)


 if view["holding?"] then
 local _let_90_ = location local slot = _let_90_[1] local col_n = _let_90_[2] local card_n = _let_90_[3]
 return {slot, col_n, math.max(1, (card_n - 1))} else
 return location end end

 local fbo = frame_buffer.new(view.size) local _
 view.fbo = fbo _ = nil


 local function _92_(_241, _242) local _let_93_ = _242 local card = _let_93_[1] local _0 = _let_93_[2]
 return draw_card(fbo, card, card.location) end E.each(view.placeholders, _92_)






 do local info_string if view.meta.gauntlet then
 info_string = fmt("level: %d moves: %d ", view.meta.gauntlet, view.meta.moves) else
 info_string = fmt("wins: %d moves: %d ", view.meta.wins, view.meta.moves) end local info
 do local tbl_17_auto = {} local i_18_auto = #tbl_17_auto for c in string.gmatch(info_string, ".") do local val_19_auto = c if (nil ~= val_19_auto) then i_18_auto = (i_18_auto + 1) do end (tbl_17_auto)[i_18_auto] = val_19_auto else end end info = tbl_17_auto end
 local function _96_(_241, _242) return info[_242] end frame_buffer.write(fbo, "draw", view.layout.info.pos, {height = 1, width = #info}, _96_) end


 do local _let_97_ = view.layout.buttons.pos local row = _let_97_["row"] local col = _let_97_["col"]
 local col0 = (col + 2)
 local red_text = {"<", " ", "\197\160"}
 local green_text = {"<", " ", "\195\145"}
 local white_text = {"<", " ", "\195\149"} local write
 local function _98_(_241, _242, _243) return frame_buffer.write(fbo, _241, {row = (_242 + row), col = col0}, {width = 3, height = 1}, _243) end write = _98_ local on_off




 local function _99_(_241, _242, _243) local _100_ = _243 if ((_G.type(_100_) == "table") and ((_100_)[1] == "BUTTON") and ((_100_)[2] == 1) and ((_100_)[3] == 1)) then
 return E["set$"](_241, "RED", _243) elseif ((_G.type(_100_) == "table") and ((_100_)[1] == "BUTTON") and ((_100_)[2] == 1) and ((_100_)[3] == 2)) then
 return E["set$"](_241, "GREEN", _243) elseif ((_G.type(_100_) == "table") and ((_100_)[1] == "BUTTON") and ((_100_)[2] == 1) and ((_100_)[3] == 3)) then
 return E["set$"](_241, "WHITE", _243) elseif true then local _0 = _100_
 return _241 else return nil end end on_off = E.reduce(view.locations.buttons, {}, _99_)
 local function _102_(_241, _242) return red_text[_242] end write("draw", 1, _102_)
 if on_off.RED then

 local function _103_() return highlight_group_for_component({"DRAGON-RED", 0}) end write("color", 1, _103_)
 local function _104_() return on_off.RED end write("hit", 1, _104_) else
 local function _105_() return highlight_group_for_component({"BUTTON", 0}) end write("color", 1, _105_) end

 local function _107_(_241, _242) return green_text[_242] end write("draw", 2, _107_)
 if on_off.GREEN then

 local function _108_() return highlight_group_for_component({"DRAGON-GREEN", 0}) end write("color", 2, _108_)
 local function _109_() return on_off.GREEN end write("hit", 2, _109_) else
 local function _110_() return highlight_group_for_component({"BUTTON", 0}) end write("color", 2, _110_) end

 local function _112_(_241, _242) return white_text[_242] end write("draw", 3, _112_)
 if on_off.WHITE then

 local function _113_() return highlight_group_for_component({"DRAGON-WHITE", 0}) end write("color", 3, _113_)
 local function _114_() return on_off.WHITE end write("hit", 3, _114_) else
 local function _115_() return highlight_group_for_component({"BUTTON", 0}) end write("color", 3, _115_) end end


 if view.show["valid-locations"] then
 for i, location in ipairs(view.locations.cards) do
 local _let_117_ = game_location__3eview_pos(adjust_location_for_pickup_or_putdown(location), view) local row = _let_117_["row"] local col = _let_117_["col"]

 local pos = {row = (row + 1), col = (col - 2)}
 local function _118_() return "\226\150\184" end frame_buffer.write(fbo, "draw", pos, {width = 1, height = 1}, _118_)
 local function _119_() return highlight_group_for_component({"BUTTON", 0}) end frame_buffer.write(fbo, "color", pos, {width = 1, height = 1}, _119_) end else end


 local function _121_(_241, _242) return _242 end
 local function _122_(_241, _242) local _123_ = _242 if ((_G.type(_123_) == "table") and (nil ~= (_123_).animating)) then local animating = (_123_).animating return false elseif true then local _0 = _123_ return true else return nil end end
 local function _125_(_241, _242) return (_241["z-index"] < _242["z-index"]) end
 local function _126_(_241, _242) return draw_card(fbo, _242, _242.location) end E.map(E["sort$"](E.filter(E.map(view.cards, _121_), _122_), _125_), _126_)


 if view.show.cursor then
 local _let_127_ = game_location__3eview_pos(adjust_location_for_pickup_or_putdown(view.locations.cursor), view) local row = _let_127_["row"] local col = _let_127_["col"]

 local pos = {row = (row + 1), col = (col - 2)}
 local function _128_(_241, _242) local _129_ = _242 if (_129_ == 1) then return "\240\159\175\129" elseif (_129_ == 2) then return "\240\159\175\130" elseif (_129_ == 3) then return "\240\159\175\131" else return nil end end frame_buffer.write(fbo, "draw", pos, {width = 3, height = 1}, _128_)
 local function _131_() return "Normal" end frame_buffer.write(fbo, "color", pos, {width = 3, height = 1}, _131_) else end




 local function _133_(_241, _242) return _242 end
 local function _134_(_241, _242) local _135_ = _242 if ((_G.type(_135_) == "table") and (nil ~= (_135_).animating)) then local animating = (_135_).animating return true elseif true then local _0 = _135_ return false else return nil end end
 local function _137_(_241, _242) return (_241["z-index"] < _242["z-index"]) end
 local function _138_(_241, _242) return draw_card(fbo, _242, _242.location) end E.map(E["sort$"](E.filter(E.map(view.cards, _133_), _134_), _137_), _138_)


 api.nvim_buf_clear_namespace(view["buf-id"], view["hl-ns"], 0, -1)
 local function _139_(_241, _242) return table.concat(_242, "") end vim.api.nvim_buf_set_lines(view["buf-id"], 0, -1, false, enum_2fmap(fbo.draw, _139_))


 for row_n, row in ipairs(fbo.color) do local byte_offset = 0
 for col_n, hl_value in ipairs(row) do
 local line = (row_n - 1)
 local new_offset = (byte_offset + #fbo.draw[row_n][col_n])
 local col_start = (new_offset - 1)
 local col_end = (new_offset + 0)
 local hl_name = fbo.color[row_n][col_n]
 if not ("" == hl_name) then
 api.nvim_buf_add_highlight(view["buf-id"], view["hl-ns"], hl_name, line, col_start, col_end) else end
 byte_offset = new_offset end end return nil end

 return M