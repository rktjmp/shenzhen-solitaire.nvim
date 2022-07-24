


















 package.loaded["shenzhen-solitaire.ui.frame-buffer"] = nil
 package.loaded["shenzhen-solitaire.ui.card"] = nil
 package.loaded["shenzhen-solitaire.ui.view"] = nil
 package.loaded["shenzhen-solitaire.game.logic"] = nil
 package.loaded["shenzhen-solitaire.game.deck"] = nil



 local function _2_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.iter") local keys_45_auto = {"range"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.iter\"")) end return mod_44_auto end local _local_1_ = _2_(...) local iter_2frange = _local_1_["range"] local function _4_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.inspect") local keys_45_auto = {"inspect", "inspect!"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.inspect\"")) end return mod_44_auto end local _local_3_ = _4_(...) local inspect = _local_3_["inspect"] local inspect_21 = _local_3_["inspect!"] local function _6_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.type") local keys_45_auto = {"nil?"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.type\"")) end return mod_44_auto end local _local_5_ = _6_(...) local nil_3f = _local_5_["nil?"] local function _8_(...)


 local mod_44_auto = string local keys_45_auto = {"format"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "string")) end return mod_44_auto end local _local_7_ = _8_(...) local fmt = _local_7_["format"] local E = require("shenzhen-solitaire.lib.donut.enum") local R = require("shenzhen-solitaire.lib.donut.result") local logic = require("shenzhen-solitaire.game.logic") local ui_view = require("shenzhen-solitaire.ui.view") do local _ = {nil, nil, nil, nil, nil, nil, nil, nil} end





 local path_separator = string.match(package.config, "(.-)\n")
 local function join_path(head, ...) _G.assert((nil ~= head), "Missing argument head on /home/soup/.local/share/nvim/site/pack/manual/start/shenzhen-solitaire.nvim/fnl/shenzhen-solitaire/ui/runtime.fnl:38")
 local t = head for _, part in ipairs({...}) do
 t = (t .. path_separator .. part) end return t end
 local win_count_path = join_path(vim.fn.stdpath("cache"), "shenzhen-solitaire.wins")

 local M = {}
 local m = {}

 m["generate-valid-locations"] = function(game_state)



 local function all_possible_pickup_locations(game_state0)

 local fm = E["flat-map"]
 local map = E.map

 local function _9_(_, slot)

 local function _10_(col_n, col)
 local function _11_(card_n)
 return {slot, col_n, card_n} end return map(col, _11_) end return fm((game_state0)[slot], _10_) end return fm({"tableau", "cell", "foundation"}, _9_) end
 local function all_possible_putdown_locations(game_state0)


 local head_or_tail local function _12_(slot, col_n)
 local _13_ = (game_state0)[slot][col_n] local function _14_() local col = _13_ return (1 <= #col) end if ((nil ~= _13_) and _14_()) then local col = _13_ return {slot, col_n, (1 + #col)} else local function _15_() local col = _13_ return (0 == #col) end if ((nil ~= _13_) and _15_()) then local col = _13_ return {slot, col_n, 1} else return nil end end end head_or_tail = _12_



 local function _17_() return iter_2frange(1, 8) end local function _18_(_241) return head_or_tail("tableau", _241) end
 local function _19_() return iter_2frange(1, 4) end local function _20_(_241) return head_or_tail("foundation", _241) end
 local function _21_() return iter_2frange(1, 3) end local function _22_(_241) return head_or_tail("cell", _241) end return E["concat$"](E["concat$"](E["concat$"]({}, E.map(_17_, _18_)), E.map(_19_, _20_)), E.map(_21_, _22_)) end

 local _let_23_ = game_state local hand = _let_23_["hand"] local hand_from = _let_23_["hand-from"] local holding_3f
 do local _24_ = hand if ((_G.type(_24_) == "table") and ((_24_)[1] == nil)) then holding_3f = false elseif ((_G.type(_24_) == "table") and (nil ~= (_24_)[1])) then local cards = (_24_)[1] holding_3f = true else holding_3f = nil end end local checked_locations
 do local _26_ = hand if ((_G.type(_26_) == "table") and ((_26_)[1] == nil)) then

 local function _27_(_241, _242) return {logic["collect-from-ok?"](game_state, _242), _242} end checked_locations = E.map(all_possible_pickup_locations(game_state), _27_) elseif ((_G.type(_26_) == "table") and (nil ~= (_26_)[1])) then local cards = (_26_)[1]

 local function _28_(_241, _242) return {logic["can-place-ok?"](game_state, _242, cards), _242} end checked_locations = E.map(all_possible_putdown_locations(game_state), _28_) else checked_locations = nil end end local ugly





 do local _30_ = hand_from if ((_G.type(_30_) == "table") and (nil ~= (_30_)[1]) and (nil ~= (_30_)[2]) and (nil ~= (_30_)[3])) then local h_slot = (_30_)[1] local h_col = (_30_)[2] local h_card = (_30_)[3]

 local function _31_(_241) local _32_ do local f = true for _, _33_ in ipairs(_241) do local _each_34_ = _33_ local _0 = _each_34_[1] local _each_35_ = _each_34_[2] local slot = _each_35_[1] local col = _each_35_[2] local card = _each_35_[3] if not f then break end
 local _36_ = {h_slot, h_col, h_card} if ((_G.type(_36_) == "table") and ((_36_)[1] == slot) and ((_36_)[2] == col) and ((_36_)[3] == card)) then f = false elseif true then local _1 = _36_ f = true else f = nil end end _32_ = f end if _32_ then

 return E["append$"](_241, {{"ok", true}, hand_from}) else

 return _241 end end ugly = _31_ elseif true then local _ = _30_

 local function _39_(_241) return _241 end ugly = _39_ else ugly = nil end end local locations

 local function _41_(_241, _242) local _42_ = _242 if ((_G.type(_42_) == "table") and ((_G.type((_42_)[1]) == "table") and (((_42_)[1])[1] == "ok")) and (nil ~= (_42_)[2])) then local location = (_42_)[2] return true else return nil end end

 local function _44_(_241, _242) local _45_ = _242 if ((_G.type(_45_) == "table") and true and (nil ~= (_45_)[2])) then local _ = (_45_)[1] local location = (_45_)[2] return location else return nil end end
 local function _51_(_47_, _49_) local _arg_48_ = _47_ local slot_1 = _arg_48_[1] local col_1 = _arg_48_[2] local card_1 = _arg_48_[3] local _arg_50_ = _49_ local slot_2 = _arg_50_[1] local col_2 = _arg_50_[2] local card_2 = _arg_50_[3] local slot_val = {tableau = 1000, cell = 2000, foundation = 3000} local a = {slot_val[slot_1], col_1, card_1} local b = {slot_val[slot_2], col_2, card_2}



 local _52_ = {a, b} if ((_G.type(_52_) == "table") and ((_G.type((_52_)[1]) == "table") and (nil ~= ((_52_)[1])[1]) and (nil ~= ((_52_)[1])[2]) and (nil ~= ((_52_)[1])[3])) and ((_G.type((_52_)[2]) == "table") and (((_52_)[1])[1] == ((_52_)[2])[1]) and (((_52_)[1])[2] == ((_52_)[2])[2]) and (nil ~= ((_52_)[2])[3]))) then local s = ((_52_)[1])[1] local c = ((_52_)[1])[2] local x = ((_52_)[1])[3] local y = ((_52_)[2])[3]
 return (x < y) elseif ((_G.type(_52_) == "table") and ((_G.type((_52_)[1]) == "table") and (nil ~= ((_52_)[1])[1]) and (nil ~= ((_52_)[1])[2]) and true) and ((_G.type((_52_)[2]) == "table") and (((_52_)[1])[1] == ((_52_)[2])[1]) and (nil ~= ((_52_)[2])[2]) and true)) then local s = ((_52_)[1])[1] local x = ((_52_)[1])[2] local _ = ((_52_)[1])[3] local y = ((_52_)[2])[2] local _0 = ((_52_)[2])[3]
 return (x < y) elseif ((_G.type(_52_) == "table") and ((_G.type((_52_)[1]) == "table") and (nil ~= ((_52_)[1])[1]) and true and true) and ((_G.type((_52_)[2]) == "table") and (nil ~= ((_52_)[2])[1]) and true and true)) then local x = ((_52_)[1])[1] local _ = ((_52_)[1])[2] local _0 = ((_52_)[1])[3] local y = ((_52_)[2])[1] local _1 = ((_52_)[2])[2] local _2 = ((_52_)[2])[3]
 return (x < y) else return nil end end

 local _54_ if not holding_3f then _54_ = {"DRAGON-RED", "DRAGON-GREEN", "DRAGON-WHITE"} else _54_ = {} end
 local function _56_(_241, _242) if game_state["lockable-dragons"][(_242 .. "?")] then return {"LOCK-DRAGON", 1, _241} else return nil end end locations = E["concat$"](E["sort$"](E.map(ugly(E.filter(checked_locations, _41_)), _44_), _51_), E.map(_54_, _56_))

 return locations end

 m.update = function(game)
 if game.config.difficulty["auto-move-obvious"] then
 while R["ok?"](logic["auto-move-ok?"](game["logic-state"])) do
 local _let_58_ = logic["auto-move-ok?"](game["logic-state"]) local _ = _let_58_[1] local _let_59_ = _let_58_[2] local from = _let_59_["from"] local to = _let_59_["to"]
 local logic_state = logic["move-cards"](game["logic-state"], from, to)
 local game_state = m["update-game-state-with-logic-state"](game["game-state"], logic_state)
 local _60_ = game _60_["logic-state"] = logic_state _60_["game-state"] = game_state end else end



 local _let_62_ = game local game_state = _let_62_["game-state"] local lockable_3f
 local function _63_(_241) return R["ok?"](logic["lock-dragons-ok?"](game["logic-state"], _241)) end lockable_3f = _63_
 local won_3f = R["ok?"](logic["win-game-ok?"](game["logic-state"]))
 do local _64_ = game_state _64_["lockable-dragons"] = {["DRAGON-GREEN?"] = lockable_3f("DRAGON-GREEN"), ["DRAGON-RED?"] = lockable_3f("DRAGON-RED"), ["DRAGON-WHITE?"] = lockable_3f("DRAGON-WHITE")} _64_["valid-locations"] = m["generate-valid-locations"](game_state) do end (_64_)["won?"] = won_3f end







 ui_view.update(game.view, game["game-state"])
 if won_3f then
 game_state["wins"] = (1 + game_state.wins)
 local readable_3f = (1 == vim.fn.filereadable(win_count_path)) local count
 if readable_3f then count = (dofile(win_count_path) + 1) else count = 1 end
 local fout = io.open(win_count_path, "w") local function close_handlers_8_auto(ok_9_auto, ...) fout:close() if ok_9_auto then return ... else return error(..., 0) end end local function _67_() return fout:write(fmt("return %d", count)) end close_handlers_8_auto(_G.xpcall(_67_, (package.loaded.fennel or debug).traceback)) else end

 return game end

 m.draw = function(game)
 local _let_69_ = game local view = _let_69_["view"] local game_state = _let_69_["game-state"]
 return ui_view.draw(view, game_state) end

 local function shift_location(game, event, direction)


 local _let_70_ = game local _let_71_ = _let_70_["game-state"] local cursor = _let_71_["cursor"] local valid_locations = _let_71_["valid-locations"]
 local _let_72_ = cursor local cursor_slot = _let_72_[1] local cursor_col_n = _let_72_[2] local cursor_card_n = _let_72_[3] local current_index
 do local f = nil for i, location in ipairs(valid_locations) do if f then break end
 local _73_ = location if ((_G.type(_73_) == "table") and ((_73_)[1] == cursor_slot) and ((_73_)[2] == cursor_col_n) and ((_73_)[3] == cursor_card_n)) then f = i else f = nil end end current_index = f end
 local len_locations = #valid_locations local next_index
 do local _75_ = {direction, current_index} if ((_G.type(_75_) == "table") and ((_75_)[1] == "next") and ((_75_)[2] == nil)) then next_index = 1 else local function _76_() local i = (_75_)[2] return (i == len_locations) end if (((_G.type(_75_) == "table") and ((_75_)[1] == "next") and (nil ~= (_75_)[2])) and _76_()) then local i = (_75_)[2] next_index = 1 elseif ((_G.type(_75_) == "table") and ((_75_)[1] == "next") and (nil ~= (_75_)[2])) then local i = (_75_)[2]


 next_index = (i + 1) elseif ((_G.type(_75_) == "table") and ((_75_)[1] == "prev") and ((_75_)[2] == nil)) then
 next_index = len_locations else local function _77_() local i = (_75_)[2] return (i == 1) end if (((_G.type(_75_) == "table") and ((_75_)[1] == "prev") and (nil ~= (_75_)[2])) and _77_()) then local i = (_75_)[2]
 next_index = len_locations elseif ((_G.type(_75_) == "table") and ((_75_)[1] == "prev") and (nil ~= (_75_)[2])) then local i = (_75_)[2]
 next_index = (i - 1) else next_index = nil end end end end local next_location
 do local _79_ = valid_locations if ((_G.type(_79_) == "table") and ((_79_)[1] == nil)) then
 next_location = cursor elseif (nil ~= _79_) then local list = _79_
 next_location = valid_locations[next_index] else next_location = nil end end
 game["game-state"]["cursor"] = next_location
 return game end

 m["next-location"] = function(game, event)
 return shift_location(game, event, "next") end
 m["prev-location"] = function(game, event)
 return shift_location(game, event, "prev") end

 m["left-mouse"] = function(game, event)





 local _let_81_ = event local location = _let_81_["location"]
 local _let_82_ = game["game-state"] local hand = _let_82_["hand"]
 local _let_83_ = location local click_slot = _let_83_[1] local click_col = _let_83_[2] local click_card = _let_83_[3] local holding_3f
 do local _84_ = hand if ((_G.type(_84_) == "table") and ((_84_)[1] == nil)) then holding_3f = false elseif ((_G.type(_84_) == "table") and (nil ~= (_84_)[1])) then local cards = (_84_)[1] holding_3f = true else holding_3f = nil end end local clicked_empty_3f






 local function _87_() local t_86_ = game["game-state"] if (nil ~= t_86_) then t_86_ = (t_86_)[click_slot] else end if (nil ~= t_86_) then t_86_ = (t_86_)[click_col] else end if (nil ~= t_86_) then t_86_ = (t_86_)[click_card] else end return t_86_ end clicked_empty_3f = nil_3f(_87_()) local next_card
 if clicked_empty_3f then next_card = click_card else next_card = (click_card + 1) end local matches_click_location_3f




 do local _92_ = {click_slot, holding_3f} if ((_G.type(_92_) == "table") and ((_92_)[1] == "tableau") and ((_92_)[2] == false)) then




 local function _93_(_241, _242) local _94_ = _242 if ((_G.type(_94_) == "table") and ((_94_)[1] == click_slot) and ((_94_)[2] == click_col) and ((_94_)[3] == click_card)) then return true else return nil end end matches_click_location_3f = _93_ elseif ((_G.type(_92_) == "table") and ((_92_)[1] == "tableau") and ((_92_)[2] == true)) then





 local function _96_(_241, _242) local _97_ = _242 if ((_G.type(_97_) == "table") and ((_97_)[1] == click_slot) and ((_97_)[2] == click_col) and ((_97_)[3] == next_card)) then return true else return nil end end matches_click_location_3f = _96_ elseif ((_G.type(_92_) == "table") and ((_92_)[1] == "foundation") and ((_92_)[2] == true)) then

 local function _99_(_241, _242) local _100_ = _242 if ((_G.type(_100_) == "table") and ((_100_)[1] == click_slot) and ((_100_)[2] == click_col) and ((_100_)[3] == next_card)) then return true else return nil end end matches_click_location_3f = _99_ elseif ((_G.type(_92_) == "table") and true and true) then local _ = (_92_)[1] local _0 = (_92_)[2]

 local function _102_(_241, _242) local _103_ = _242 if ((_G.type(_103_) == "table") and ((_103_)[1] == click_slot) and ((_103_)[2] == click_col) and ((_103_)[3] == click_card)) then return true else return nil end end matches_click_location_3f = _102_ else matches_click_location_3f = nil end end

 local cursor = E.hd(E.filter(game["game-state"]["valid-locations"], matches_click_location_3f))

 if cursor then
 game["game-state"].cursor = cursor
 return m.interact(game, event) else return nil end end

 m["right-mouse"] = function(game, event)

 local _let_107_ = event local location = _let_107_["location"]
 local _let_108_ = game["game-state"] local hand = _let_108_["hand"] local hand_from = _let_108_["hand-from"] local holding_3f
 do local _109_ = hand if ((_G.type(_109_) == "table") and ((_109_)[1] == nil)) then holding_3f = false elseif ((_G.type(_109_) == "table") and (nil ~= (_109_)[1])) then local cards = (_109_)[1] holding_3f = true else holding_3f = nil end end
 if holding_3f then
 game["game-state"].cursor = hand_from
 return m.interact(game, event) else return nil end end

 m["auto-move"] = function(game, event)
 do local _let_112_ = game local game_state = _let_112_["game-state"] local logic_state = _let_112_["logic-state"]
 local _113_ = logic["auto-move-ok?"](logic_state) if ((_G.type(_113_) == "table") and ((_113_)[1] == "ok") and ((_G.type((_113_)[2]) == "table") and (nil ~= ((_113_)[2]).to) and (nil ~= ((_113_)[2]).from))) then local to = ((_113_)[2]).to local from = ((_113_)[2]).from
 local logic_state0 = logic["move-cards"](logic_state, from, to)
 local game_state0 = m["update-game-state-with-logic-state"](game_state, logic_state0)
 local _114_ = game _114_["game-state"] = game_state0 _114_["logic-state"] = logic_state0 else end end


 return game end

 m.interact = function(game, event)
 local _let_116_ = game local game_state = _let_116_["game-state"] local logic_state = _let_116_["logic-state"]
 local _let_117_ = game_state local cursor = _let_117_["cursor"] local hand = _let_117_["hand"] local hand_from = _let_117_["hand-from"]

 do local _118_ = {hand, cursor} if ((_G.type(_118_) == "table") and true and ((_G.type((_118_)[2]) == "table") and (((_118_)[2])[1] == "LOCK-DRAGON") and (((_118_)[2])[2] == 1) and (nil ~= ((_118_)[2])[3]))) then local _ = (_118_)[1] local button = ((_118_)[2])[3]
 local which do local _119_ = button if (_119_ == 1) then which = "DRAGON-RED" elseif (_119_ == 2) then which = "DRAGON-GREEN" elseif (_119_ == 3) then which = "DRAGON-WHITE" else which = nil end end
 local _121_ = logic["lock-dragons-ok?"](logic_state, which) if ((_G.type(_121_) == "table") and ((_121_)[1] == "ok") and ((_G.type((_121_)[2]) == "table") and (nil ~= ((_121_)[2]).to))) then local to = ((_121_)[2]).to

 local new_logic_state = logic["lock-dragons"](logic_state, which)
 local new_game_state = m["update-game-state-with-logic-state"](game_state, new_logic_state)
 do end (new_game_state)["cursor"] = to
 local _122_ = game _122_["game-state"] = new_game_state _122_["logic-state"] = new_logic_state elseif ((_G.type(_121_) == "table") and ((_121_)[1] == "err") and (nil ~= (_121_)[2])) then local e = (_121_)[2]


 error(e) else end elseif ((_G.type(_118_) == "table") and ((_G.type((_118_)[1]) == "table") and (((_118_)[1])[1] == nil)) and true) then local _ = (_118_)[2]

 local _124_ = logic["collect-from-ok?"](logic_state, cursor) if ((_G.type(_124_) == "table") and ((_124_)[1] == "ok")) then local _let_125_ = cursor
 local slot = _let_125_[1] local col_n = _let_125_[2] local card_n = _let_125_[3]
 local rem, hand0 = E.split(game_state[slot][col_n], card_n)
 do end (game_state)[slot][col_n] = rem
 game_state["hand"] = {hand0}
 game_state["hand-from"] = cursor
 game["game-state"] = game_state elseif ((_G.type(_124_) == "table") and ((_124_)[1] == "err") and (nil ~= (_124_)[2])) then local e = (_124_)[2]
 error(e) else end elseif ((_G.type(_118_) == "table") and ((_G.type((_118_)[1]) == "table") and (nil ~= ((_118_)[1])[1])) and true) then local cards = ((_118_)[1])[1] local _ = (_118_)[2]



 local _127_ = {cursor, hand_from, logic["can-place-ok?"](game_state, cursor, cards)} if ((_G.type(_127_) == "table") and ((_G.type((_127_)[1]) == "table") and (nil ~= ((_127_)[1])[1]) and (nil ~= ((_127_)[1])[2]) and (nil ~= ((_127_)[1])[3])) and ((_G.type((_127_)[2]) == "table") and (((_127_)[1])[1] == ((_127_)[2])[1]) and (((_127_)[1])[2] == ((_127_)[2])[2]) and (((_127_)[1])[3] == ((_127_)[2])[3])) and true) then local s = ((_127_)[1])[1] local cl = ((_127_)[1])[2] local cd = ((_127_)[1])[3] local _0 = (_127_)[3]


 local game_state0 do local _128_ = game_state _128_["hand"] = {} _128_["hand-from"] = {} game_state0 = _128_ end


 local new_game_state = m["update-game-state-with-logic-state"](game_state0, logic_state)
 do end (game)["game-state"] = new_game_state elseif ((_G.type(_127_) == "table") and true and true and ((_G.type((_127_)[3]) == "table") and (((_127_)[3])[1] == "ok"))) then local _0 = (_127_)[1] local _1 = (_127_)[2] local _let_129_ = game_state


 local hand_from0 = _let_129_["hand-from"]
 local new_logic_state = logic["move-cards"](logic_state, hand_from0, cursor)
 local new_game_state = m["update-game-state-with-logic-state"](game_state, new_logic_state)
 do end (new_game_state)["hand"] = {}
 new_game_state["hand-from"] = {}
 local _130_ = game _130_["game-state"] = new_game_state _130_["logic-state"] = new_logic_state elseif ((_G.type(_127_) == "table") and true and true and ((_G.type((_127_)[3]) == "table") and (((_127_)[3])[1] == "err") and (nil ~= ((_127_)[3])[2]))) then local _0 = (_127_)[1] local _1 = (_127_)[2] local e = ((_127_)[3])[2]



 error(e) else end else end end
 return game end

 m["save-game"] = function(game, event)
 local save_file = join_path(vim.fn.stdpath("cache"), "shenzhen-solitaire.save")
 local fout = io.open(save_file, "w") local function close_handlers_8_auto(ok_9_auto, ...) fout:close() if ok_9_auto then return ... else return error(..., 0) end end local function _134_() fout:write(vim.mpack.encode(game["logic-state"].events))

 return vim.notify("Saved game") end return close_handlers_8_auto(_G.xpcall(_134_, (package.loaded.fennel or debug).traceback)) end

 m["load-game"] = function(game, event)
 local save_file = join_path(vim.fn.stdpath("cache"), "shenzhen-solitaire.save")
 local readable = (1 == vim.fn.filereadable(save_file))
 if readable then
 local fin = io.open(save_file) local function close_handlers_8_auto(ok_9_auto, ...) fin:close() if ok_9_auto then return ... else return error(..., 0) end end local function _136_() local bytes = fin:read("*a")

 local events = vim.mpack.decode(bytes) local new_logic_state
 local function _137_(_241, _242, _243) return logic.S.apply(_241, _243) end new_logic_state = E.reduce(events, logic.S["empty-state"](), _137_)
 local new_game_state = m["update-game-state-with-logic-state"]({}, new_logic_state)
 do end (game)["logic-state"] = new_logic_state
 game["game-state"] = new_game_state
 m.update(game)
 return m.draw(game) end return close_handlers_8_auto(_G.xpcall(_136_, (package.loaded.fennel or debug).traceback)) else
 return error("Could not open save file, probably doesn't exist") end end

 m["restart-game"] = function(game, event)

 local _let_139_ = game["logic-state"] local events = _let_139_["events"] local events0
 do local initial_events, stop_3f = {}, false for _, event0 in ipairs(events) do if stop_3f then break end
 local _140_ = event0 if ((_G.type(_140_) == "table") and ((_140_)[1] == "moved-cards")) then
 initial_events, stop_3f = initial_events, true elseif true then local _0 = _140_
 initial_events, stop_3f = E["append$"](initial_events, event0), false else initial_events, stop_3f = nil end end events0 = initial_events, stop_3f end local new_logic_state
 local function _142_(_241, _242, _243) return logic.S.apply(_241, _243) end new_logic_state = E.reduce(events0, logic.S["empty-state"](), _142_)
 local new_game_state = m["update-game-state-with-logic-state"]({}, new_logic_state)
 do end (game)["logic-state"] = new_logic_state
 game["game-state"] = new_game_state
 m.update(game)
 return m.draw(game) end

 m["undo-last-move"] = function(game, event)
 if game.config.difficulty["allow-undo"] then

 local _let_143_ = game["logic-state"] local events = _let_143_["events"] local events0

 local function _144_() return iter_2frange(1, math.max(3, (#events - 1))) end local function _145_(_241) return events[_241] end events0 = E.map(_144_, _145_) local new_logic_state
 local function _146_(_241, _242, _243) return logic.S.apply(_241, _243) end new_logic_state = E.reduce(events0, logic.S["empty-state"](), _146_)
 local new_game_state = m["update-game-state-with-logic-state"]({}, new_logic_state)
 do end (game)["logic-state"] = new_logic_state
 game["game-state"] = new_game_state
 m.update(game)
 return m.draw(game) else
 return vim.notify("Undo not enabled, see difficulty.allow-undo") end end

 m["update-game-state-with-logic-state"] = function(game_state, logic_state)



 local new_game_state = logic.S["clone-state"](logic_state)
 local _148_ = new_game_state _148_["wins"] = (game_state.wins or 0) do end (_148_)["won?"] = (game_state["won?"] or false) do end (_148_)["cursor"] = (game_state.cursor or {"tableau", 1, 5}) do end (_148_)["hand"] = (game_state.hand or {}) do end (_148_)["hand-from"] = (game_state["hand-from"] or {}) do end (_148_)["lockable-dragons"] = (game_state["lockable-dragons"] or {}) do end (_148_)["valid-locations"] = (game_state["valid-locations"] or {}) return _148_ end








 M["start-new-game"] = function(buf_id, first_responder, config, _3fseed)

 local function setup()


 local game = {["logic-state"] = nil, ["game-state"] = nil, view = nil, config = config}



 do local thread = coroutine.running() local responder
 local function _149_(...) return first_responder(thread, ...) end responder = _149_
 local readable_3f = (1 == vim.fn.filereadable(win_count_path)) local count
 if readable_3f then count = dofile(win_count_path) else count = 0 end

 game["logic-state"] = logic["start-new-game"](_3fseed)
 game["game-state"] = m["update-game-state-with-logic-state"]({wins = count}, game["logic-state"])
 game.view = ui_view.update(ui_view.new(buf_id, responder, game.config), game["game-state"])

 m.update(game)
 m.draw(game) end
 local function loop(...)




 local result local function _152_(...) local _151_ = {...} if ((_G.type(_151_) == "table") and ((_151_)[1] == "control") and ((_151_)[2] == "hello")) then
 return true, "hello!" elseif ((_G.type(_151_) == "table") and ((_151_)[1] == "config") and ((_151_)[2] == "goodbye")) then
 return true, "goodbye!" elseif ((_G.type(_151_) == "table") and ((_151_)[1] == "event") and (nil ~= (_151_)[2])) then local event = (_151_)[2] local _let_153_ = event
 local name = _let_153_["name"] local f
 local function _154_() return error(fmt("No handler for %s", name)) end f = (m[name] or _154_)
 local _155_, _156_ = pcall(f, game, event) if ((_155_ == false) and (nil ~= _156_)) then local err = _156_
 return nil, err elseif ((_155_ == true) and (nil ~= _156_)) then local data = _156_
 return data else return nil end elseif (nil ~= _151_) then local any = _151_
 return nil, fmt("runtime did not know how to handle message %s", inspect(any)) else return nil end end result = R.unit(_152_(...)) local and_then

 do local _159_ = result if ((_G.type(_159_) == "table") and ((_159_)[1] == "ok") and ((_159_)[2] == "goodbye")) then

 local function _160_() return vim.notify("Goodbye!") end and_then = _160_ elseif ((_G.type(_159_) == "table") and ((_159_)[1] == "ok")) then

 m.update(game)
 m.draw(game)
 and_then = loop elseif ((_G.type(_159_) == "table") and ((_159_)[1] == "err") and (nil ~= (_159_)[2])) then local e = (_159_)[2]
 and_then = loop else and_then = nil end end
 return and_then(coroutine.yield(result)) end

 return loop("control", "hello") end
 return coroutine.create(setup) end

 return M