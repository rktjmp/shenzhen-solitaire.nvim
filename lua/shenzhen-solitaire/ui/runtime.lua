 package.loaded["shenzhen-solitaire.ui.frame-buffer"] = nil
 package.loaded["shenzhen-solitaire.ui.card"] = nil
 package.loaded["shenzhen-solitaire.ui.view"] = nil
 package.loaded["shenzhen-solitaire.game.logic"] = nil
 package.loaded["shenzhen-solitaire.game.deck"] = nil



 local function _2_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.iter") local keys_45_auto = {"range"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.iter\"")) end return mod_44_auto end local _local_1_ = _2_(...) local iter_2frange = _local_1_["range"] local function _4_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.inspect") local keys_45_auto = {"inspect", "inspect!"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.inspect\"")) end return mod_44_auto end local _local_3_ = _4_(...) local inspect = _local_3_["inspect"] local inspect_21 = _local_3_["inspect!"] local function _6_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.type") local keys_45_auto = {"nil?"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.type\"")) end return mod_44_auto end local _local_5_ = _6_(...) local nil_3f = _local_5_["nil?"] local function _8_(...)


 local mod_44_auto = string local keys_45_auto = {"format"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "string")) end return mod_44_auto end local _local_7_ = _8_(...) local fmt = _local_7_["format"] local E = require("shenzhen-solitaire.lib.donut.enum") local R = require("shenzhen-solitaire.lib.donut.result") local logic = require("shenzhen-solitaire.game.logic") local ui_view = require("shenzhen-solitaire.ui.view") do local _ = {nil, nil, nil, nil, nil, nil, nil, nil} end





 local path_separator = string.match(package.config, "(.-)\n")
 local function join_path(head, ...) _G.assert((nil ~= head), "Missing argument head on /home/soup/.local/share/nvim/site/pack/manual/start/shenzhen-solitaire.nvim/fnl/shenzhen-solitaire/ui/runtime.fnl:19")
 local t = head for _, part in ipairs({...}) do
 t = (t .. path_separator .. part) end return t end
 local win_count_path = join_path(vim.fn.stdpath("cache"), "shenzhen-solitaire.wins")

 local gauntlet_path = join_path(vim.fn.stdpath("cache"), "shenzhen-solitaire.gauntlet")

 local M = {}
 local m = {}

 M["start-new-game"] = function(buf_id, first_responder, config, _3fseed)

 local function setup()



 local game = {}
 do local responder do local t = coroutine.running() local function _9_(...) return first_responder(t, ...) end responder = _9_ end local win_count
 do local _10_, _11_ = pcall(dofile, win_count_path) if ((_10_ == true) and (nil ~= _11_)) then local n = _11_ win_count = n elseif ((_10_ == false) and (nil ~= _11_)) then local e = _11_ win_count = 0 else win_count = nil end end
 local pure = logic["start-new-game"](_3fseed)
 local dirty = m["pure-state->dirty-state"](pure)
 local meta = {["won?"] = false, gauntlet = config.gauntlet, wins = win_count}


 local view = ui_view.new({["buf-id"] = buf_id, responder = responder, meta = meta, state = dirty, config = config})




 local _13_ = game _13_["view"] = view _13_["config"] = config _13_["state"] = {pure = pure, dirty = dirty} _13_["meta"] = meta _13_["locations"] = {cursor = {"tableau", 1, 5}, ["hand-from"] = nil, cards = m["find-interactable-cards"](dirty), buttons = m["find-interactable-buttons"](pure)} end









 local function loop(...)




 local result local function _15_(...) local _14_ = {...} if ((_G.type(_14_) == "table") and ((_14_)[1] == "control") and ((_14_)[2] == "hello")) then
 return true, "hello!" elseif ((_G.type(_14_) == "table") and ((_14_)[1] == "config") and ((_14_)[2] == "goodbye")) then
 return true, "goodbye!" elseif ((_G.type(_14_) == "table") and ((_14_)[1] == "event") and (nil ~= (_14_)[2])) then local event = (_14_)[2] local _let_16_ = event
 local name = _let_16_["name"] local f
 local function _17_() return error(fmt("No handler for %s", name)) end f = (m[name] or _17_)
 local _18_, _19_ = pcall(f, game, event) if ((_18_ == false) and (nil ~= _19_)) then local err = _19_
 return nil, err elseif ((_18_ == true) and (nil ~= _19_)) then local data = _19_
 return data else return nil end elseif (nil ~= _14_) then local any = _14_
 return nil, fmt("runtime did not know how to handle message %s", inspect(any)) else return nil end end result = R.unit(_15_(...)) local and_then

 do local _22_ = result if ((_G.type(_22_) == "table") and ((_22_)[1] == "ok") and ((_22_)[2] == "goodbye")) then

 local function _23_() return vim.notify("Goodbye!") end and_then = _23_ elseif ((_G.type(_22_) == "table") and ((_22_)[1] == "ok")) then

 m.update(game)
 and_then = loop elseif ((_G.type(_22_) == "table") and ((_22_)[1] == "err") and (nil ~= (_22_)[2])) then local e = (_22_)[2]
 and_then = loop else and_then = nil end end
 return and_then(coroutine.yield(result)) end

 return loop("control", "hello") end
 return coroutine.create(setup) end

 m["save-gauntlet"] = function(seed)
 local seed0 = (seed + 1)
 local fout = io.open(gauntlet_path, "w") local function close_handlers_8_auto(ok_9_auto, ...) fout:close() if ok_9_auto then return ... else return error(..., 0) end end local function _26_() return fout:write(fmt("return %d", seed0)) end return close_handlers_8_auto(_G.xpcall(_26_, (package.loaded.fennel or debug).traceback)) end






 m.update = function(game)
 if game.config.difficulty["auto-move-obvious"] then

 while R["ok?"](logic["auto-move-ok?"](game.state.pure)) do
 local _let_27_ = logic["auto-move-ok?"](game.state.pure) local _ = _let_27_[1] local _let_28_ = _let_27_[2] local from = _let_28_["from"] local to = _let_28_["to"]
 local pure = logic["move-cards"](game.state.pure, from, to)
 local dirty = m["pure-state->dirty-state"](pure)
 local _29_ = game.state _29_["pure"] = pure _29_["dirty"] = dirty end else end








 local card_locations = m["find-interactable-cards"](game.state.dirty)
 local button_locations = m["find-interactable-buttons"](game.state.pure)
 local flattened = m["locations->nextable-locations"](card_locations, button_locations, game.locations["hand-from"]) local cursor_location
 local _31_ do local ok_3f = false for _, _32_ in ipairs(flattened) do local _each_33_ = _32_ local cs = _each_33_[1] local cc = _each_33_[2] local cr = _each_33_[3] if ok_3f then break end
 local _34_ = game.locations.cursor if ((_G.type(_34_) == "table") and ((_34_)[1] == cs) and ((_34_)[2] == cc) and ((_34_)[3] == cr)) then ok_3f = true elseif true then local _0 = _34_ ok_3f = false else ok_3f = nil end end _31_ = ok_3f end if _31_ then
 cursor_location = game.locations.cursor else
 cursor_location = E.hd(flattened) end

 if not R["ok?"](logic["win-game-ok?"](game.state.pure)) then

 local _37_ = game.locations _37_["cards"] = card_locations _37_["buttons"] = button_locations _37_["cursor"] = cursor_location _37_["flattened"] = flattened else






 if not game.meta["won?"] then

 do local readable_3f = (1 == vim.fn.filereadable(win_count_path)) local win_count
 if readable_3f then win_count = (dofile(win_count_path) + 1) else win_count = 1 end
 do local fout = io.open(win_count_path, "w") local function close_handlers_8_auto(ok_9_auto, ...) fout:close() if ok_9_auto then return ... else return error(..., 0) end end local function _40_() return fout:write(fmt("return %d", win_count)) end close_handlers_8_auto(_G.xpcall(_40_, (package.loaded.fennel or debug).traceback)) end

 do local _41_ = game.meta _41_["won?"] = true _41_["wins"] = win_count end


 if game.meta.gauntlet then
 m["save-gauntlet"](game.meta.gauntlet) else end end

 local _43_ = game.locations _43_["hand-from"] = nil _43_["card"] = {} _43_["buttons"] = {} _43_["flattened"] = {} else end end






 ui_view.update(game.view, {state = game.state.dirty, locations = game.locations, meta = game.meta})



 if game.meta["won?"] then
 ui_view.draw(game.view) else end
 return game end

 m["find-interactable-cards"] = function(state)

 local function all_possible_pickup_locations()


 local function _47_(_, slot)

 local function _48_(col_n, col)
 local function _49_(card_n)
 return {slot, col_n, card_n} end return E.map(col, _49_) end return E["flat-map"](state[slot], _48_) end return E["flat-map"]({"tableau", "cell", "foundation"}, _47_) end
 local function all_possible_putdown_locations()


 local head_or_tail local function _50_(slot, col_n)
 local _51_ = state[slot][col_n] local function _52_() local col = _51_ return (1 <= #col) end if ((nil ~= _51_) and _52_()) then local col = _51_ return {slot, col_n, (1 + #col)} else local function _53_() local col = _51_ return (0 == #col) end if ((nil ~= _51_) and _53_()) then local col = _51_ return {slot, col_n, 1} else return nil end end end head_or_tail = _50_



 local function _55_() return iter_2frange(1, 8) end local function _56_(_241) return head_or_tail("tableau", _241) end
 local function _57_() return iter_2frange(1, 4) end local function _58_(_241) return head_or_tail("foundation", _241) end
 local function _59_() return iter_2frange(1, 3) end local function _60_(_241) return head_or_tail("cell", _241) end return E["concat$"](E["concat$"](E["concat$"]({}, E.map(_55_, _56_)), E.map(_57_, _58_)), E.map(_59_, _60_)) end


 local _62_ do local _61_ = state.hand if ((_G.type(_61_) == "table") and ((_61_)[1] == nil)) then

 local function _64_(_241, _242) return {logic["collect-from-ok?"](state, _242), _242} end _62_ = E.map(all_possible_pickup_locations(), _64_) elseif ((_G.type(_61_) == "table") and (nil ~= (_61_)[1])) then local cards = (_61_)[1]

 local function _66_(_241, _242) return {logic["can-place-ok?"](state, _242, cards), _242} end _62_ = E.map(all_possible_putdown_locations(), _66_) elseif true then local _ = _61_
 _62_ = error("internal-error: find-interactable-cards state.hand was unmatched") else _62_ = nil end end
 local function _69_(_241, _242) local _70_ = _242 if ((_G.type(_70_) == "table") and ((_G.type((_70_)[1]) == "table") and (((_70_)[1])[1] == "ok")) and true) then local _ = (_70_)[2] return true else return nil end end
 local function _72_(_241, _242) local _73_ = _242 if ((_G.type(_73_) == "table") and true and (nil ~= (_73_)[2])) then local _ = (_73_)[1] local location = (_73_)[2] return location else return nil end end return E.map(E.filter(_62_, _69_), _72_) end

 m["find-interactable-buttons"] = function(state)

 local function _75_(_241, _242) return {R["ok?"](logic["lock-dragons-ok?"](state, _242)), {"BUTTON", 1, _241}} end
 local function _76_(_241, _242) return (_242)[1] end
 local function _77_(_241, _242) local _78_ = _242 if ((_G.type(_78_) == "table") and true and (nil ~= (_78_)[2])) then local _ = (_78_)[1] local loc = (_78_)[2] return loc else return nil end end return E.map(E.filter(E.map({"DRAGON-RED", "DRAGON-GREEN", "DRAGON-WHITE"}, _75_), _76_), _77_) end

 m["pure-state->dirty-state"] = function(logic_state)

 local _80_ = logic.S["clone-state"](logic_state) do end (_80_)["hand"] = {} return _80_ end






 m["locations->nextable-locations"] = function(cards, buttons, hand_from)



 local flat = E["concat$"]({}, cards, buttons) local flat0



 do local _81_ = hand_from if (_81_ == nil) then

 flat0 = flat elseif ((_G.type(_81_) == "table") and (nil ~= (_81_)[1]) and (nil ~= (_81_)[2]) and (nil ~= (_81_)[3])) then local h_slot = (_81_)[1] local h_col = (_81_)[2] local h_card = (_81_)[3]


 local function _82_(_241, _242, _243) local _83_ = _243 if ((_G.type(_83_) == "table") and ((_83_)[1] == h_slot) and ((_83_)[2] == h_col) and ((_83_)[3] == h_card)) then return false elseif true then local _ = _83_ return _241 else return nil end end if E.reduce(cards, true, _82_) then
 flat0 = E["append$"](flat, hand_from) else
 flat0 = flat end else flat0 = nil end end
 local function _91_(_87_, _89_) local _arg_88_ = _87_ local slot_1 = _arg_88_[1] local col_1 = _arg_88_[2] local card_1 = _arg_88_[3] local _arg_90_ = _89_ local slot_2 = _arg_90_[1] local col_2 = _arg_90_[2] local card_2 = _arg_90_[3]
 local slot_val = {tableau = 1000, cell = 2000, foundation = 3000, BUTTON = 10000}
 local a = {slot_val[slot_1], col_1, card_1}
 local b = {slot_val[slot_2], col_2, card_2}
 local _92_ = {a, b} if ((_G.type(_92_) == "table") and ((_G.type((_92_)[1]) == "table") and (nil ~= ((_92_)[1])[1]) and (nil ~= ((_92_)[1])[2]) and (nil ~= ((_92_)[1])[3])) and ((_G.type((_92_)[2]) == "table") and (((_92_)[1])[1] == ((_92_)[2])[1]) and (((_92_)[1])[2] == ((_92_)[2])[2]) and (nil ~= ((_92_)[2])[3]))) then local s = ((_92_)[1])[1] local c = ((_92_)[1])[2] local x = ((_92_)[1])[3] local y = ((_92_)[2])[3]
 return (x < y) elseif ((_G.type(_92_) == "table") and ((_G.type((_92_)[1]) == "table") and (nil ~= ((_92_)[1])[1]) and (nil ~= ((_92_)[1])[2]) and true) and ((_G.type((_92_)[2]) == "table") and (((_92_)[1])[1] == ((_92_)[2])[1]) and (nil ~= ((_92_)[2])[2]) and true)) then local s = ((_92_)[1])[1] local x = ((_92_)[1])[2] local _ = ((_92_)[1])[3] local y = ((_92_)[2])[2] local _0 = ((_92_)[2])[3]
 return (x < y) elseif ((_G.type(_92_) == "table") and ((_G.type((_92_)[1]) == "table") and (nil ~= ((_92_)[1])[1]) and true and true) and ((_G.type((_92_)[2]) == "table") and (nil ~= ((_92_)[2])[1]) and true and true)) then local x = ((_92_)[1])[1] local _ = ((_92_)[1])[2] local _0 = ((_92_)[1])[3] local y = ((_92_)[2])[1] local _1 = ((_92_)[2])[2] local _2 = ((_92_)[2])[3]
 return (x < y) else return nil end end return E["sort$"](flat0, _91_) end





 local function shift_location(game, event, direction)


 local _let_94_ = game local _let_95_ = _let_94_["locations"] local cursor = _let_95_["cursor"] local locations = _let_95_["flattened"]
 local _let_96_ = cursor local cursor_slot = _let_96_[1] local cursor_col_n = _let_96_[2] local cursor_card_n = _let_96_[3] local current_index
 do local f = nil for i, location in ipairs(locations) do if f then break end
 local _97_ = location if ((_G.type(_97_) == "table") and ((_97_)[1] == cursor_slot) and ((_97_)[2] == cursor_col_n) and ((_97_)[3] == cursor_card_n)) then f = i else f = nil end end current_index = f end
 local len_locations = #locations local next_index
 do local _99_ = {direction, current_index} if ((_G.type(_99_) == "table") and ((_99_)[1] == "next") and ((_99_)[2] == nil)) then next_index = 1 else local function _100_() local i = (_99_)[2] return (i == len_locations) end if (((_G.type(_99_) == "table") and ((_99_)[1] == "next") and (nil ~= (_99_)[2])) and _100_()) then local i = (_99_)[2] next_index = 1 elseif ((_G.type(_99_) == "table") and ((_99_)[1] == "next") and (nil ~= (_99_)[2])) then local i = (_99_)[2]


 next_index = (i + 1) elseif ((_G.type(_99_) == "table") and ((_99_)[1] == "prev") and ((_99_)[2] == nil)) then
 next_index = len_locations else local function _101_() local i = (_99_)[2] return (i == 1) end if (((_G.type(_99_) == "table") and ((_99_)[1] == "prev") and (nil ~= (_99_)[2])) and _101_()) then local i = (_99_)[2]
 next_index = len_locations elseif ((_G.type(_99_) == "table") and ((_99_)[1] == "prev") and (nil ~= (_99_)[2])) then local i = (_99_)[2]
 next_index = (i - 1) else next_index = nil end end end end local new_location
 do local _103_ = locations if ((_G.type(_103_) == "table") and ((_103_)[1] == nil)) then
 new_location = cursor elseif (nil ~= _103_) then local list = _103_
 new_location = locations[next_index] else new_location = nil end end
 game["locations"]["cursor"] = new_location
 return game end

 m["next-location"] = function(game, event)
 return shift_location(game, event, "next") end
 m["prev-location"] = function(game, event)
 return shift_location(game, event, "prev") end

 m["left-mouse"] = function(game, event)





 local _let_105_ = event local location = _let_105_["location"]
 local _let_106_ = game.state.dirty local hand = _let_106_["hand"]
 local _let_107_ = location local click_slot = _let_107_[1] local click_col = _let_107_[2] local click_card = _let_107_[3] local holding_3f
 do local _108_ = hand if ((_G.type(_108_) == "table") and ((_108_)[1] == nil)) then holding_3f = false elseif ((_G.type(_108_) == "table") and (nil ~= (_108_)[1])) then local cards = (_108_)[1] holding_3f = true else holding_3f = nil end end local clicked_empty_3f






 local function _111_() local t_110_ = game.state.dirty if (nil ~= t_110_) then t_110_ = (t_110_)[click_slot] else end if (nil ~= t_110_) then t_110_ = (t_110_)[click_col] else end if (nil ~= t_110_) then t_110_ = (t_110_)[click_card] else end return t_110_ end clicked_empty_3f = nil_3f(_111_()) local next_card
 if clicked_empty_3f then next_card = click_card else next_card = (click_card + 1) end local matches_click_location_3f




 do local _116_ = {click_slot, holding_3f} if ((_G.type(_116_) == "table") and ((_116_)[1] == "tableau") and ((_116_)[2] == false)) then




 local function _117_(_241, _242) local _118_ = _242 if ((_G.type(_118_) == "table") and ((_118_)[1] == click_slot) and ((_118_)[2] == click_col) and ((_118_)[3] == click_card)) then return true else return nil end end matches_click_location_3f = _117_ elseif ((_G.type(_116_) == "table") and ((_116_)[1] == "tableau") and ((_116_)[2] == true)) then





 local function _120_(_241, _242) local _121_ = _242 if ((_G.type(_121_) == "table") and ((_121_)[1] == click_slot) and ((_121_)[2] == click_col) and ((_121_)[3] == next_card)) then return true else return nil end end matches_click_location_3f = _120_ elseif ((_G.type(_116_) == "table") and ((_116_)[1] == "foundation") and ((_116_)[2] == true)) then

 local function _123_(_241, _242) local _124_ = _242 if ((_G.type(_124_) == "table") and ((_124_)[1] == click_slot) and ((_124_)[2] == click_col) and ((_124_)[3] == next_card)) then return true else return nil end end matches_click_location_3f = _123_ elseif ((_G.type(_116_) == "table") and true and true) then local _ = (_116_)[1] local _0 = (_116_)[2]

 local function _126_(_241, _242) local _127_ = _242 if ((_G.type(_127_) == "table") and ((_127_)[1] == click_slot) and ((_127_)[2] == click_col) and ((_127_)[3] == click_card)) then return true else return nil end end matches_click_location_3f = _126_ else matches_click_location_3f = nil end end

 local cursor = E.hd(E.filter(game.locations.flattened, matches_click_location_3f))

 if cursor then
 game.locations.cursor = cursor
 return m.interact(game, event) else return nil end end

 m["right-mouse"] = function(game, event)


 local _let_131_ = event local location = _let_131_["location"]
 local _let_132_ = game.locations local hand_from = _let_132_["hand-from"]
 local _let_133_ = game.state.dirty local hand = _let_133_["hand"] local holding_3f
 do local _134_ = hand if ((_G.type(_134_) == "table") and ((_134_)[1] == nil)) then holding_3f = false elseif ((_G.type(_134_) == "table") and (nil ~= (_134_)[1])) then local cards = (_134_)[1] holding_3f = true else holding_3f = nil end end
 if holding_3f then
 game.locations.cursor = hand_from
 return m.interact(game, event) else return nil end end

 m["auto-move"] = function(game, event)
 do local _let_137_ = game.state local pure = _let_137_["pure"] local dirty = _let_137_["dirty"]
 local _138_ = logic["auto-move-ok?"](pure) if ((_G.type(_138_) == "table") and ((_138_)[1] == "ok") and ((_G.type((_138_)[2]) == "table") and (nil ~= ((_138_)[2]).to) and (nil ~= ((_138_)[2]).from))) then local to = ((_138_)[2]).to local from = ((_138_)[2]).from
 local pure0 = logic["move-cards"](pure, from, to)
 local dirty0 = m["pure-state->dirty-state"](pure0)
 local _139_ = game.state _139_["pure"] = pure0 _139_["dirty"] = dirty0 else end end


 return game end

 m.interact = function(game, event)
 local _let_141_ = game.state local pure = _let_141_["pure"] local dirty = _let_141_["dirty"]
 local _let_142_ = game.locations local cursor = _let_142_["cursor"] local hand_from = _let_142_["hand-from"]
 do local _143_ = {dirty.hand, cursor} if ((_G.type(_143_) == "table") and true and ((_G.type((_143_)[2]) == "table") and (((_143_)[2])[1] == "BUTTON") and (((_143_)[2])[2] == 1) and (nil ~= ((_143_)[2])[3]))) then local _ = (_143_)[1] local button = ((_143_)[2])[3]

 local which do local _144_ = button if (_144_ == 1) then which = "DRAGON-RED" elseif (_144_ == 2) then which = "DRAGON-GREEN" elseif (_144_ == 3) then which = "DRAGON-WHITE" else which = nil end end
 local _146_ = logic["lock-dragons-ok?"](pure, which) if ((_G.type(_146_) == "table") and ((_146_)[1] == "ok") and ((_G.type((_146_)[2]) == "table") and (nil ~= ((_146_)[2]).to))) then local to = ((_146_)[2]).to

 local pure0 = logic["lock-dragons"](pure, which)
 local dirty0 = m["pure-state->dirty-state"](pure0)

 local _147_ = game.state _147_["pure"] = pure0 _147_["dirty"] = dirty0 elseif ((_G.type(_146_) == "table") and ((_146_)[1] == "err") and (nil ~= (_146_)[2])) then local e = (_146_)[2]


 error(e) else end elseif ((_G.type(_143_) == "table") and ((_G.type((_143_)[1]) == "table") and (((_143_)[1])[1] == nil)) and true) then local _ = (_143_)[2]


 local _149_ = logic["collect-from-ok?"](pure, cursor) if ((_G.type(_149_) == "table") and ((_149_)[1] == "ok")) then local _let_150_ = cursor
 local slot = _let_150_[1] local col_n = _let_150_[2] local card_n = _let_150_[3]
 local rem, hand = E.split(pure[slot][col_n], card_n)
 do end (dirty)[slot][col_n] = rem
 dirty["hand"] = {hand}
 game.locations["hand-from"] = cursor elseif ((_G.type(_149_) == "table") and ((_149_)[1] == "err") and (nil ~= (_149_)[2])) then local e = (_149_)[2]
 error(e) else end elseif ((_G.type(_143_) == "table") and ((_G.type((_143_)[1]) == "table") and (nil ~= ((_143_)[1])[1])) and true) then local cards = ((_143_)[1])[1] local _ = (_143_)[2]




 local _152_ = {cursor, hand_from, logic["can-place-ok?"](dirty, cursor, cards)} if ((_G.type(_152_) == "table") and ((_G.type((_152_)[1]) == "table") and (nil ~= ((_152_)[1])[1]) and (nil ~= ((_152_)[1])[2]) and (nil ~= ((_152_)[1])[3])) and ((_G.type((_152_)[2]) == "table") and (((_152_)[1])[1] == ((_152_)[2])[1]) and (((_152_)[1])[2] == ((_152_)[2])[2]) and (((_152_)[1])[3] == ((_152_)[2])[3])) and true) then local s = ((_152_)[1])[1] local cl = ((_152_)[1])[2] local cd = ((_152_)[1])[3] local _0 = (_152_)[3]


 local dirty0 = m["pure-state->dirty-state"](pure)
 game.state.dirty = dirty0 elseif ((_G.type(_152_) == "table") and true and true and ((_G.type((_152_)[3]) == "table") and (((_152_)[3])[1] == "ok"))) then local _0 = (_152_)[1] local _1 = (_152_)[2]


 local pure0 = logic["move-cards"](pure, hand_from, cursor)
 local dirty0 = m["pure-state->dirty-state"](pure0)
 do local _153_ = game.locations _153_["hand-from"] = nil end

 local _154_ = game.state _154_["pure"] = pure0 _154_["dirty"] = dirty0 elseif ((_G.type(_152_) == "table") and true and true and ((_G.type((_152_)[3]) == "table") and (((_152_)[3])[1] == "err") and (nil ~= ((_152_)[3])[2]))) then local _0 = (_152_)[1] local _1 = (_152_)[2] local e = ((_152_)[3])[2]



 error(e) else end else end end
 return game end

 m["save-game"] = function(game, event)
 local save_file = join_path(vim.fn.stdpath("cache"), "shenzhen-solitaire.save")
 do local fout = io.open(save_file, "w") local function close_handlers_8_auto(ok_9_auto, ...) fout:close() if ok_9_auto then return ... else return error(..., 0) end end local function _158_() fout:write(vim.mpack.encode(game.state.pure.events))

 return vim.notify("Saved game") end close_handlers_8_auto(_G.xpcall(_158_, (package.loaded.fennel or debug).traceback)) end
 return game end

 m["load-game"] = function(game, event)

 local save_file = join_path(vim.fn.stdpath("cache"), "shenzhen-solitaire.save")
 local readable = (1 == vim.fn.filereadable(save_file))
 if readable then
 local fin = io.open(save_file) local function close_handlers_8_auto(ok_9_auto, ...) fin:close() if ok_9_auto then return ... else return error(..., 0) end end local function _160_() local bytes = fin:read("*a")

 local events = vim.mpack.decode(bytes) local pure
 local function _161_(_241, _242, _243) return logic.S.apply(_241, _243) end pure = E.reduce(events, logic.S["empty-state"](), _161_)
 local dirty = m["pure-state->dirty-state"](pure)
 local _162_ = game.state _162_["pure"] = pure _162_["dirty"] = dirty return _162_ end close_handlers_8_auto(_G.xpcall(_160_, (package.loaded.fennel or debug).traceback)) else


 error("Could not open save file, probably doesn't exist") end
 return game end

 m["restart-game"] = function(game, event)
 local _let_164_ = game.state.pure local events = _let_164_["events"] local events0
 do local initial_events, stop_3f = {}, false for _, event0 in ipairs(events) do if stop_3f then break end

 local _165_ = event0 if ((_G.type(_165_) == "table") and ((_165_)[1] == "moved-cards")) then

 initial_events, stop_3f = initial_events, true elseif true then local _0 = _165_
 initial_events, stop_3f = E["append$"](initial_events, event0), false else initial_events, stop_3f = nil end end events0 = initial_events, stop_3f end local pure
 local function _167_(_241, _242, _243) return logic.S.apply(_241, _243) end pure = E.reduce(events0, logic.S["empty-state"](), _167_)
 local dirty = m["pure-state->dirty-state"](pure)
 do local _168_ = game.state _168_["pure"] = pure _168_["dirty"] = dirty end


 return game end

 m["undo-last-move"] = function(game, event)
 if game.config.difficulty["allow-undo"] then

 local _let_169_ = game.state.pure local events = _let_169_["events"] local events0

 local function _170_() return iter_2frange(1, math.max(3, (#events - 1))) end local function _171_(_241) return events[_241] end events0 = E.map(_170_, _171_) local pure
 local function _172_(_241, _242, _243) return logic.S.apply(_241, _243) end pure = E.reduce(events0, logic.S["empty-state"](), _172_)
 local dirty = m["pure-state->dirty-state"](pure)
 local _173_ = game.state _173_["pure"] = pure _173_["dirty"] = dirty return _173_ else


 return vim.notify("Undo not enabled, see difficulty.allow-undo") end end

 return M