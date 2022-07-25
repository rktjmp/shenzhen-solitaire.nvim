 package.loaded["shenzhen-solitaire.ui.frame-buffer"] = nil
 package.loaded["shenzhen-solitaire.ui.card"] = nil



 local function _2_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.iter") local keys_45_auto = {"range"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.iter\"")) end return mod_44_auto end local _local_1_ = _2_(...) local iter_2frange = _local_1_["range"] local function _4_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.inspect") local keys_45_auto = {"inspect!"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.inspect\"")) end return mod_44_auto end local _local_3_ = _4_(...) local inspect_21 = _local_3_["inspect!"] local function _6_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.enum") local keys_45_auto = {"map", "flat-map", "set$", "flatten", "split", "pairs->table", "reduce", "each"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.enum\"")) end return mod_44_auto end local _local_5_ = _6_(...) local enum_2feach = _local_5_["each"] local enum_2fflat_map = _local_5_["flat-map"] local enum_2fflatten = _local_5_["flatten"] local enum_2fmap = _local_5_["map"] local enum_2fpairs__3etable = _local_5_["pairs->table"] local enum_2freduce = _local_5_["reduce"] local enum_2fset_24 = _local_5_["set$"] local enum_2fsplit = _local_5_["split"] local e = require("shenzhen-solitaire.lib.donut.enum") local function _8_(...) local mod_44_auto = require("shenzhen-solitaire.game.logic") local keys_45_auto = {"start-new-game"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.game.logic\"")) end return mod_44_auto end local _local_7_ = _8_(...) local start_new_game = _local_7_["start-new-game"] local function _10_(...)





 local mod_44_auto = string local keys_45_auto = {"format"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "string")) end return mod_44_auto end local _local_9_ = _10_(...) local fmt = _local_9_["format"] local frame_buffer = require("shenzhen-solitaire.ui.frame-buffer") local ui_card = require("shenzhen-solitaire.ui.card") do local _ = {nil, nil, nil, nil, nil, nil, nil, nil} end



 local FBO_HIT_HACK = nil
 local CURSOR_HACK = nil
 local api = vim.api
 local M = {}

 local function highlight_name_for_card(card)
 local _let_11_ = card local kind = _let_11_[1] local _ = _let_11_[2]
 local _12_ = kind if (_12_ == "EMPTY") then return "SHZHCardEmpty" elseif (_12_ == "BUTTON") then return "SHZHButton" elseif (_12_ == "COIN") then return "SHZHCardCoin" elseif (_12_ == "STRING") then return "SHZHCardString" elseif (_12_ == "MYRIAD") then return "SHZHCardMyriad" elseif (_12_ == "FLOWER") then return "SHZHCardFlower" elseif (_12_ == "DRAGON-RED") then return "SHZHCardDragonRed" elseif (_12_ == "DRAGON-GREEN") then return "SHZHCardDragonGreen" elseif (_12_ == "DRAGON-WHITE") then return "SHZHCardDragonWhite" else return nil end end










 local function game_location__3eview_pos(location, view)

 local _let_14_ = view local layout = _let_14_["layout"]
 local _15_ = location if ((_G.type(_15_) == "table") and ((_15_)[1] == "tableau") and (nil ~= (_15_)[2]) and (nil ~= (_15_)[3])) then local col_n = (_15_)[2] local card_n = (_15_)[3] return {row = (layout.tableau.pos.row + ((card_n - 1) * 2)), col = (layout.tableau.pos.col + layout.tableau.gap + ((col_n - 1) * (layout.tableau.gap + layout.card.size.width)))} elseif ((_G.type(_15_) == "table") and ((_15_)[1] == "cell") and (nil ~= (_15_)[2]) and (nil ~= (_15_)[3])) then local col_n = (_15_)[2] local card_n = (_15_)[3] return {row = layout.cell.pos.row, col = (layout.cell.pos.col + layout.cell.gap + ((col_n - 1) * (layout.cell.gap + layout.card.size.width)))} elseif ((_G.type(_15_) == "table") and ((_15_)[1] == "foundation") and ((_15_)[2] == 4) and (nil ~= (_15_)[3])) then local card_n = (_15_)[3] return {row = layout.foundation.pos.row, col = (layout.foundation.gap + layout.foundation.pos.col + ((1 - 1) * (layout.foundation.gap + layout.card.size.width)))} elseif ((_G.type(_15_) == "table") and ((_15_)[1] == "foundation") and (nil ~= (_15_)[2]) and (nil ~= (_15_)[3])) then local col_n = (_15_)[2] local card_n = (_15_)[3] return {row = layout.foundation.pos.row, col = (layout.foundation.gap + layout.foundation.pos.col + layout.card.size.width + layout.foundation.gap + ((col_n - 1) * (layout.foundation.gap + layout.card.size.width)))} elseif ((_G.type(_15_) == "table") and ((_15_)[1] == "hand") and (nil ~= (_15_)[2]) and (nil ~= (_15_)[3])) then local col_n = (_15_)[2] local card_n = (_15_)[3] local _let_16_ = CURSOR_HACK

























 local slot = _let_16_[1] local cur_col_n = _let_16_[2] local cur_card_n = _let_16_[3] local _let_17_ = game_location__3eview_pos({slot, cur_col_n, ((cur_card_n - 1) + card_n)}, view)
 local row = _let_17_["row"] local col = _let_17_["col"] return {row = row, col = (col + 1)} elseif ((_G.type(_15_) == "table") and ((_15_)[1] == "LOCK-DRAGON") and true and (nil ~= (_15_)[3])) then local _ = (_15_)[2] local button = (_15_)[3] local _let_18_ = view.layout.buttons.pos






 local row = _let_18_["row"] local col = _let_18_["col"]
 local _19_ = button if (_19_ == 1) then return {row = row, col = col} elseif (_19_ == 2) then return {row = (row + 1), col = col} elseif (_19_ == 3) then return {row = (row + 2), col = col} else return nil end elseif true then local _ = _15_




 return error(vim.inspect(location)) else return nil end end

 local function map_game_state_cards(game_state, f)
 local fm = enum_2fflat_map
 local m = enum_2fmap

 local function _22_(_, slot)

 local function _23_(col_n, col)

 local function _24_(card_n, card)
 return f(card, {slot, col_n, card_n}) end return m(col, _24_) end return fm(game_state[slot], _23_) end return fm({"cell", "foundation", "tableau", "hand"}, _22_) end

 M.new = function(buf_id, responder, config)



 local function define_highlight_groups(highlight_config)
 local set_hl local function _25_(_241, _242) return api.nvim_set_hl(0, highlight_name_for_card({_241, 0}), _242) end set_hl = _25_
 set_hl("EMPTY", highlight_config.empty)
 set_hl("BUTTON", highlight_config.button)
 set_hl("COIN", highlight_config.coin)
 set_hl("STRING", highlight_config.string)
 set_hl("MYRIAD", highlight_config.myriad)
 set_hl("DRAGON-RED", highlight_config["dragon-red"])
 set_hl("DRAGON-WHITE", highlight_config["dragon-white"])
 set_hl("DRAGON-GREEN", highlight_config["dragon-green"])
 return set_hl("FLOWER", highlight_config.flower) end

 local function configure_buffer(view)
 local _let_26_ = view local buf_id0 = _let_26_["buf-id"] local responder0 = _let_26_["responder"] local set_km
 local function _27_(_241, _242)



 local function _28_() return responder0({name = _241, view = view}) end return api.nvim_buf_set_keymap(buf_id0, "n", config.keys[_241], "", {callback = _28_, noremap = false, nowait = true, desc = _242}) end set_km = _27_




 do local buf_opts = {filetype = "shenzhen-solitaire"}
 local win_opts = {cursorline = false, number = false, list = false, relativenumber = false}
 local function _29_(_241, _242) return api.nvim_buf_set_option(buf_id0, _241, _242) end enum_2fmap(buf_opts, _29_)

 local function _30_() local win_id = api.nvim_get_current_win()
 local function _31_(_2410, _2420) return api.nvim_win_set_option(win_id, _2410, _2420) end return enum_2fmap(win_opts, _31_) end api.nvim_buf_call(buf_id0, _30_) end

 set_km("save-game", "Save current game")
 set_km("load-game", "Load last saved game")
 set_km("restart-game", "Restart current game")
 set_km("undo-last-move", "Undo last move")
 set_km("next-location", "Move to next location")
 set_km("prev-location", "Move to previous location")


 set_km("interact", "Pick up, put down, interact")
 set_km("auto-move", "Automatically move best cards")



 local function byte_offset__3ecol(row, target_byte_offset)


 local function _35_(_33_, i, bytes) local _arg_34_ = _33_ local byte_count = _arg_34_[1] local index = _arg_34_[2]
 if (target_byte_offset <= byte_count) then
 return {byte_count, index} else
 local byte_count0 = (byte_count + #bytes)
 local index0 = i
 return {byte_count0, index0} end end local _let_32_ = e.reduce((FBO_HIT_HACK.draw[row] or {}), {0, 0}, _35_) local _ = _let_32_[1] local index = _let_32_[2]
 return index end

 local function bind_mouse(lhs, event_name, desc)
 local eval_er = fmt("\"\\%s\"", lhs)


 local function _37_() local _let_38_ = vim.fn.getmousepos() local winid = _let_38_["winid"] local byte_offset = _let_38_["column"] local row = _let_38_["line"]
 local x = vim.api.nvim_eval(eval_er)
 local col = byte_offset__3ecol(row, byte_offset)




 if (winid == view.winid) then

 local _39_ do local t_40_ = FBO_HIT_HACK if (nil ~= t_40_) then t_40_ = (t_40_).hit else end if (nil ~= t_40_) then t_40_ = (t_40_)[row] else end if (nil ~= t_40_) then t_40_ = (t_40_)[col] else end _39_ = t_40_ end local function _44_() local loc = _39_ return (0 < #loc) end if ((nil ~= _39_) and _44_()) then local loc = _39_

 return responder0({name = event_name, location = loc, view = view}) else return nil end else

 return vim.cmd(("normal! " .. x)) end end return api.nvim_buf_set_keymap(buf_id0, "n", lhs, "", {callback = vim.schedule_wrap(_37_), desc = desc}) end

 bind_mouse("<LeftMouse>", "left-mouse", "Inferred action for left mouse")
 return bind_mouse("<RightMouse>", "right-mouse", "Inferred action for right mouse") end

 local real_buf_id = buf_id


 local view = {["buf-id"] = buf_id, winid = api.nvim_buf_call(buf_id, api.nvim_get_current_win), responder = responder, ["hl-ns"] = api.nvim_create_namespace("shenzhen-solitaire"), difficulty = config.difficulty, cursor = config.cursor, layout = {size = {width = 80, height = 40}, info = config.info, tableau = config.tableau, foundation = config.foundation, cell = config.cell, buttons = config.buttons, card = config.card}, config = config}













 local function game_card__3eui_card(game_card, location)





 local pos = game_location__3eview_pos(location, view)
 local hl = highlight_name_for_card(game_card)
 local data = {pos = pos, size = config.card.size, borders = config.card.borders, highlight = hl}



 return {game_card, ui_card.new(game_card, data)} end


 local function _47_() return iter_2frange(1, 8) end local function _48_(_241) return {"tableau", _241, 1} end
 local function _49_() return iter_2frange(1, 3) end local function _50_(_241) return {"cell", _241, 1} end
 local function _51_() return iter_2frange(1, 4) end local function _52_(_241) return {"foundation", _241, 1} end

 local function _53_(_, location) local _let_54_ = game_card__3eui_card({"EMPTY", 0}, location)
 local _0 = _let_54_[1] local ui_card0 = _let_54_[2]
 return {ui_card0, location} end view["placeholders"] = enum_2fmap(enum_2fflatten({enum_2fmap(_47_, _48_), enum_2fmap(_49_, _50_), enum_2fmap(_51_, _52_)}), _53_)

 define_highlight_groups(config.highlight)
 configure_buffer(view)
 return view end

 M.update = function(view, game_state)

 CURSOR_HACK = game_state.cursor
 return view end

 local function game_card__3eui_card(view, game_card, location)





 local pos = game_location__3eview_pos(location, view)
 local hl = highlight_name_for_card(game_card)
 local data = {pos = pos, size = view.layout.card.size, borders = view.layout.card.borders, highlight = hl}



 return {game_card, ui_card.new(game_card, data)} end

 M.draw = function(view, game_state, tick_3f)






 local function draw_card(fbo, card, location)
 local _let_55_ = card local pos = _let_55_["pos"] local size = _let_55_["size"] local bitmap = _let_55_["bitmap"] local highlight = _let_55_["highlight"] local edge_hl = "Normal" local pos__3echar

 local function _56_(r, c) return bitmap[r][c] end pos__3echar = _56_ local pos__3ehl
 local function _57_(r, c)
 local _58_ = {r, c} if true then local _ = _58_
 return highlight elseif ((_G.type(_58_) == "table") and ((_58_)[1] == 1) and true) then local _ = (_58_)[2]
 return edge_hl elseif ((_G.type(_58_) == "table") and ((_58_)[1] == size.height) and true) then local _ = (_58_)[2]
 return edge_hl elseif ((_G.type(_58_) == "table") and true and ((_58_)[2] == 1)) then local _ = (_58_)[1]
 return edge_hl elseif ((_G.type(_58_) == "table") and true and ((_58_)[2] == size.width)) then local _ = (_58_)[1]
 return edge_hl else return nil end end pos__3ehl = _57_ local write
 local function _60_(_241, _242) return frame_buffer.write(fbo, _241, pos, size, _242) end write = _60_
 assert(location, "no location")
 write("draw", pos__3echar)
 write("color", pos__3ehl)
 local function _61_() return location end return write("hit", _61_) end

 local function adjust_location_for_pickup_or_putdown(location)


 local _62_ = game_state.hand if ((_G.type(_62_) == "table") and ((_62_)[1] == nil)) then
 return location elseif ((_G.type(_62_) == "table") and (nil ~= (_62_)[1])) then local cards = (_62_)[1] local _let_63_ = location
 local slot = _let_63_[1] local col_n = _let_63_[2] local card_n = _let_63_[3] return {slot, col_n, math.max(1, (card_n - 1))} else return nil end end


 local fbo = frame_buffer.new(view.size) local _
 FBO_HIT_HACK = fbo _ = nil local for_each_game_card
 local function _65_(_241) return map_game_state_cards(game_state, _241) end for_each_game_card = _65_

 local function _66_(_241, _242) local _let_67_ = _242 local card = _let_67_[1] local location = _let_67_[2]
 return draw_card(fbo, card, location) end e.each(view.placeholders, _66_)





 do local info_string = fmt("wins: %d moves: %d", game_state.wins, (#game_state.events - 3)) local info
 do local tbl_15_auto = {} local i_16_auto = #tbl_15_auto for c in string.gmatch(info_string, ".") do local val_17_auto = c if (nil ~= val_17_auto) then i_16_auto = (i_16_auto + 1) do end (tbl_15_auto)[i_16_auto] = val_17_auto else end end info = tbl_15_auto end
 local function _69_(_241, _242) return info[_242] end frame_buffer.write(fbo, "draw", view.layout.info.pos, {height = 1, width = #info}, _69_) end



 local function _70_(...) return game_card__3eui_card(view, ...) end view["cards"] = enum_2fpairs__3etable(map_game_state_cards(game_state, _70_))


 local function _71_(card, location)
 do local pos = game_location__3eview_pos(location, view, game_state.cursor)
 do end (view)["cards"][card]["highlight"] = highlight_name_for_card(card)
 do end (view)["cards"][card]["pos"] = pos end
 return draw_card(fbo, view.cards[card], location) end for_each_game_card(_71_)


 do local _let_72_ = view.layout.buttons.pos local row = _let_72_["row"] local col = _let_72_["col"]
 local col0 = (col + 2)
 local red_text = {"<", " ", "\197\160"}
 local green_text = {"<", " ", "\195\145"}
 local white_text = {"<", " ", "\195\149"} local write
 local function _73_(_241, _242, _243) return frame_buffer.write(fbo, _241, {row = (_242 + row), col = col0}, {width = 3, height = 1}, _243) end write = _73_

 local function _74_(_241, _242) return red_text[_242] end write("draw", 1, _74_)
 if game_state["lockable-dragons"]["DRAGON-RED?"] then

 local function _75_() return highlight_name_for_card({"DRAGON-RED", 0}) end write("color", 1, _75_)
 local function _76_() return {"LOCK-DRAGON", 1, 1} end write("hit", 1, _76_) else
 local function _77_() return highlight_name_for_card({"BUTTON", 0}) end write("color", 1, _77_) end
 local function _79_(_241, _242) return green_text[_242] end write("draw", 2, _79_)
 if game_state["lockable-dragons"]["DRAGON-GREEN?"] then

 local function _80_() return highlight_name_for_card({"DRAGON-GREEN", 0}) end write("color", 2, _80_)
 local function _81_() return {"LOCK-DRAGON", 1, 2} end write("hit", 2, _81_) else
 local function _82_() return highlight_name_for_card({"BUTTON", 0}) end write("color", 2, _82_) end
 local function _84_(_241, _242) return white_text[_242] end write("draw", 3, _84_)
 if game_state["lockable-dragons"]["DRAGON-WHITE?"] then

 local function _85_() return highlight_name_for_card({"DRAGON-WHITE", 0}) end write("color", 3, _85_)
 local function _86_() return {"LOCK-DRAGON", 1, 3} end write("hit", 3, _86_) else
 local function _87_() return highlight_name_for_card({"BUTTON", 0}) end write("color", 3, _87_) end end


 if view.difficulty["show-valid-locations"] then
 for i, location in ipairs(game_state["valid-locations"]) do
 local _let_89_ = game_location__3eview_pos(adjust_location_for_pickup_or_putdown(location), view) local row = _let_89_["row"] local col = _let_89_["col"]

 local pos = {row = (row + 1), col = (col - 2)}
 local function _90_() return "\226\150\184" end frame_buffer.write(fbo, "draw", pos, {width = 1, height = 1}, _90_)
 local function _91_() return highlight_name_for_card({"BUTTON", 0}) end frame_buffer.write(fbo, "color", pos, {width = 1, height = 1}, _91_) end else end


 if view.cursor.show then
 local _let_93_ = game_location__3eview_pos(adjust_location_for_pickup_or_putdown(game_state.cursor), view) local row = _let_93_["row"] local col = _let_93_["col"]

 local pos = {row = (row + 1), col = (col - 2)}
 local function _94_(_241, _242) local _95_ = _242 if (_95_ == 1) then return "\240\159\175\129" elseif (_95_ == 2) then return "\240\159\175\130" elseif (_95_ == 3) then return "\240\159\175\131" else return nil end end frame_buffer.write(fbo, "draw", pos, {width = 3, height = 1}, _94_)
 local function _97_() return "Normal" end frame_buffer.write(fbo, "color", pos, {width = 3, height = 1}, _97_) else end


 api.nvim_buf_clear_namespace(view["buf-id"], view["hl-ns"], 0, -1)
 local function _99_(_241, _242) return table.concat(_242, "") end vim.api.nvim_buf_set_lines(view["buf-id"], 0, -1, false, enum_2fmap(fbo.draw, _99_))


 for row_n, row in ipairs(fbo.color) do local byte_offset = 0
 for col_n, hl_value in ipairs(row) do
 local line = (row_n - 1)
 local new_offset = (byte_offset + #fbo.draw[row_n][col_n])
 local col_start = (new_offset - 1)
 local col_end = (new_offset + 2)
 local hl_name = fbo.color[row_n][col_n]
 if not ("" == hl_name) then
 api.nvim_buf_add_highlight(view["buf-id"], view["hl-ns"], hl_name, line, col_start, col_end) else end
 byte_offset = new_offset end end
 return fbo.color end

 return M