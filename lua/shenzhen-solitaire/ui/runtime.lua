 package.loaded["shenzhen-solitaire.ui.frame-buffer"] = nil
 package.loaded["shenzhen-solitaire.ui.card"] = nil
 package.loaded["shenzhen-solitaire.ui.view"] = nil
 package.loaded["shenzhen-solitaire.game.logic"] = nil
 package.loaded["shenzhen-solitaire.game.deck"] = nil



 local function _2_(...) local mod_36_auto = require("shenzhen-solitaire.lib.donut.iter") local keys_37_auto = {"range"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.lib.donut.iter\"")) end return mod_36_auto end local _local_1_ = _2_(...) local iter_2frange = _local_1_["range"] local function _4_(...) local mod_36_auto = require("shenzhen-solitaire.lib.donut.inspect") local keys_37_auto = {"inspect", "inspect!"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.lib.donut.inspect\"")) end return mod_36_auto end local _local_3_ = _4_(...) local inspect = _local_3_["inspect"] local inspect_21 = _local_3_["inspect!"] local function _6_(...) local mod_36_auto = require("shenzhen-solitaire.lib.donut.type") local keys_37_auto = {"nil?"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.lib.donut.type\"")) end return mod_36_auto end local _local_5_ = _6_(...) local nil_3f = _local_5_["nil?"] local function _8_(...)


 local mod_36_auto = string local keys_37_auto = {"format"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "string")) end return mod_36_auto end local _local_7_ = _8_(...) local fmt = _local_7_["format"] local E = require("shenzhen-solitaire.lib.donut.enum") local R = require("shenzhen-solitaire.lib.donut.result") local logic = require("shenzhen-solitaire.game.logic") local ui_view = require("shenzhen-solitaire.ui.view") do local _ = {nil, nil, nil, nil, nil, nil, nil, nil} end





 local path_separator = string.match(package.config, "(.-)\n")
 local function join_path(head, ...) _G.assert((nil ~= head), "Missing argument head on ./fnl/shenzhen-solitaire/ui/runtime.fnl:19")
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
 local meta = {gauntlet = config.gauntlet, wins = win_count, ["won?"] = false}


 local view = ui_view.new({["buf-id"] = buf_id, responder = responder, meta = meta, state = dirty, config = config})




 game["view"] = view game["config"] = config game["state"] = {pure = pure, dirty = dirty} game["meta"] = meta game["locations"] = {cursor = {"tableau", 1, 5}, ["hand-from"] = nil, cards = m["find-interactable-cards"](dirty), buttons = m["find-interactable-buttons"](pure)} end









 local function loop(...)




 local result local function _14_(...) local _13_ = {...} if ((_G.type(_13_) == "table") and ((_13_)[1] == "control") and ((_13_)[2] == "hello")) then
 return true, "hello!" elseif ((_G.type(_13_) == "table") and ((_13_)[1] == "config") and ((_13_)[2] == "goodbye")) then
 return true, "goodbye!" elseif ((_G.type(_13_) == "table") and ((_13_)[1] == "event") and (nil ~= (_13_)[2])) then local event = (_13_)[2]
 local _let_15_ = event local name = _let_15_["name"] local f
 local function _16_() return error(fmt("No handler for %s", name)) end f = (m[name] or _16_)
 local _17_, _18_ = pcall(f, game, event) if ((_17_ == false) and (nil ~= _18_)) then local err = _18_
 return nil, err elseif ((_17_ == true) and (nil ~= _18_)) then local data = _18_
 return data else return nil end elseif (nil ~= _13_) then local any = _13_
 return nil, fmt("runtime did not know how to handle message %s", inspect(any)) else return nil end end result = R.unit(_14_(...)) local and_then

 do local _21_ = result if ((_G.type(_21_) == "table") and ((_21_)[1] == "ok") and ((_21_)[2] == "goodbye")) then

 local function _22_() return vim.notify("Goodbye!") end and_then = _22_ elseif ((_G.type(_21_) == "table") and ((_21_)[1] == "ok")) then

 m.update(game)
 and_then = loop elseif ((_G.type(_21_) == "table") and ((_21_)[1] == "err") and (nil ~= (_21_)[2])) then local e = (_21_)[2]
 and_then = loop else and_then = nil end end
 return and_then(coroutine.yield(result)) end

 return loop("control", "hello") end
 return coroutine.create(setup) end

 m["save-gauntlet"] = function(seed)
 local seed0 = (seed + 1)
 local fout = io.open(gauntlet_path, "w") local function close_handlers_10_auto(ok_11_auto, ...) fout:close() if ok_11_auto then return ... else return error(..., 0) end end local function _25_() return fout:write(fmt("return %d", seed0)) end return close_handlers_10_auto(_G.xpcall(_25_, (package.loaded.fennel or debug).traceback)) end






 m.update = function(game)
 if game.config.difficulty["auto-move-obvious"] then

 while R["ok?"](logic["auto-move-ok?"](game.state.pure)) do
 local _let_26_ = logic["auto-move-ok?"](game.state.pure) local _ = _let_26_[1] local _let_27_ = _let_26_[2] local from = _let_27_["from"] local to = _let_27_["to"]
 local pure = logic["move-cards"](game.state.pure, from, to)
 local dirty = m["pure-state->dirty-state"](pure)
 local _28_ = game.state _28_["pure"] = pure _28_["dirty"] = dirty end else end








 local card_locations = m["find-interactable-cards"](game.state.dirty)
 local button_locations = m["find-interactable-buttons"](game.state.pure)
 local flattened = m["locations->nextable-locations"](card_locations, button_locations, game.locations["hand-from"]) local cursor_location
 local _30_ do local ok_3f = false for _, _31_ in ipairs(flattened) do local _each_32_ = _31_ local cs = _each_32_[1] local cc = _each_32_[2] local cr = _each_32_[3] if ok_3f then break end
 local _33_ = game.locations.cursor if ((_G.type(_33_) == "table") and ((_33_)[1] == cs) and ((_33_)[2] == cc) and ((_33_)[3] == cr)) then ok_3f = true elseif true then local _0 = _33_ ok_3f = false else ok_3f = nil end end _30_ = ok_3f end if _30_ then
 cursor_location = game.locations.cursor else
 cursor_location = E.hd(flattened) end

 if not R["ok?"](logic["win-game-ok?"](game.state.pure)) then

 local _36_ = game.locations _36_["cards"] = card_locations _36_["buttons"] = button_locations _36_["cursor"] = cursor_location _36_["flattened"] = flattened else






 if not game.meta["won?"] then

 do local readable_3f = (1 == vim.fn.filereadable(win_count_path)) local win_count
 if readable_3f then win_count = (dofile(win_count_path) + 1) else win_count = 1 end
 do local fout = io.open(win_count_path, "w") local function close_handlers_10_auto(ok_11_auto, ...) fout:close() if ok_11_auto then return ... else return error(..., 0) end end local function _39_() return fout:write(fmt("return %d", win_count)) end close_handlers_10_auto(_G.xpcall(_39_, (package.loaded.fennel or debug).traceback)) end

 do local _40_ = game.meta _40_["won?"] = true _40_["wins"] = win_count end


 if game.meta.gauntlet then
 m["save-gauntlet"](game.meta.gauntlet) else end end

 local _42_ = game.locations _42_["hand-from"] = nil _42_["card"] = {} _42_["buttons"] = {} _42_["flattened"] = {} else end end






 ui_view.update(game.view, {state = game.state.dirty, locations = game.locations, meta = game.meta})



 if game.meta["won?"] then
 ui_view.draw(game.view) else end
 return game end

 m["find-interactable-cards"] = function(state)

 local function all_possible_pickup_locations()


 local function _46_(_, slot)

 local function _47_(col_n, col)
 local function _48_(card_n)
 return {slot, col_n, card_n} end return E.map(col, _48_) end return E["flat-map"](state[slot], _47_) end return E["flat-map"]({"tableau", "cell", "foundation"}, _46_) end
 local function all_possible_putdown_locations()


 local head_or_tail local function _49_(slot, col_n)
 local _50_ = state[slot][col_n] local function _51_() local col = _50_ return (1 <= #col) end if ((nil ~= _50_) and _51_()) then local col = _50_
 return {slot, col_n, (1 + #col)} else local function _52_() local col = _50_ return (0 == #col) end if ((nil ~= _50_) and _52_()) then local col = _50_
 return {slot, col_n, 1} else return nil end end end head_or_tail = _49_

 local function _54_() return iter_2frange(1, 8) end local function _55_(_241) return head_or_tail("tableau", _241) end
 local function _56_() return iter_2frange(1, 4) end local function _57_(_241) return head_or_tail("foundation", _241) end
 local function _58_() return iter_2frange(1, 3) end local function _59_(_241) return head_or_tail("cell", _241) end return E["concat$"](E["concat$"](E["concat$"]({}, E.map(_54_, _55_)), E.map(_56_, _57_)), E.map(_58_, _59_)) end


 local _61_ do local _60_ = state.hand if ((_G.type(_60_) == "table") and ((_60_)[1] == nil)) then

 local function _63_(_241, _242) return {logic["collect-from-ok?"](state, _242), _242} end _61_ = E.map(all_possible_pickup_locations(), _63_) elseif ((_G.type(_60_) == "table") and (nil ~= (_60_)[1])) then local cards = (_60_)[1]

 local function _65_(_241, _242) return {logic["can-place-ok?"](state, _242, cards), _242} end _61_ = E.map(all_possible_putdown_locations(), _65_) elseif true then local _ = _60_
 _61_ = error("internal-error: find-interactable-cards state.hand was unmatched") else _61_ = nil end end
 local function _68_(_241, _242) local _69_ = _242 if ((_G.type(_69_) == "table") and ((_G.type((_69_)[1]) == "table") and (((_69_)[1])[1] == "ok")) and true) then local _ = (_69_)[2] return true else return nil end end
 local function _71_(_241, _242) local _72_ = _242 if ((_G.type(_72_) == "table") and true and (nil ~= (_72_)[2])) then local _ = (_72_)[1] local location = (_72_)[2] return location else return nil end end return E.map(E.filter(_61_, _68_), _71_) end

 m["find-interactable-buttons"] = function(state)

 local function _74_(_241, _242) return {R["ok?"](logic["lock-dragons-ok?"](state, _242)), {"BUTTON", 1, _241}} end
 local function _75_(_241, _242) return (_242)[1] end
 local function _76_(_241, _242) local _77_ = _242 if ((_G.type(_77_) == "table") and true and (nil ~= (_77_)[2])) then local _ = (_77_)[1] local loc = (_77_)[2] return loc else return nil end end return E.map(E.filter(E.map({"DRAGON-RED", "DRAGON-GREEN", "DRAGON-WHITE"}, _74_), _75_), _76_) end

 m["pure-state->dirty-state"] = function(logic_state)

 local _79_ = logic.S["clone-state"](logic_state) do end (_79_)["hand"] = {} return _79_ end






 m["locations->nextable-locations"] = function(cards, buttons, hand_from)



 local flat = E["concat$"]({}, cards, buttons) local flat0



 do local _80_ = hand_from if (_80_ == nil) then

 flat0 = flat elseif ((_G.type(_80_) == "table") and (nil ~= (_80_)[1]) and (nil ~= (_80_)[2]) and (nil ~= (_80_)[3])) then local h_slot = (_80_)[1] local h_col = (_80_)[2] local h_card = (_80_)[3]


 local function _81_(_241, _242, _243) local _82_ = _243 if ((_G.type(_82_) == "table") and ((_82_)[1] == h_slot) and ((_82_)[2] == h_col) and ((_82_)[3] == h_card)) then return false elseif true then local _ = _82_ return _241 else return nil end end if E.reduce(cards, true, _81_) then
 flat0 = E["append$"](flat, hand_from) else
 flat0 = flat end else flat0 = nil end end
 local function _90_(_86_, _88_) local _arg_87_ = _86_ local slot_1 = _arg_87_[1] local col_1 = _arg_87_[2] local card_1 = _arg_87_[3] local _arg_89_ = _88_ local slot_2 = _arg_89_[1] local col_2 = _arg_89_[2] local card_2 = _arg_89_[3]
 local slot_val = {tableau = 1000, cell = 2000, foundation = 3000, BUTTON = 10000}
 local a = {slot_val[slot_1], col_1, card_1}
 local b = {slot_val[slot_2], col_2, card_2}
 local _91_ = {a, b} if ((_G.type(_91_) == "table") and ((_G.type((_91_)[1]) == "table") and (nil ~= ((_91_)[1])[1]) and (nil ~= ((_91_)[1])[2]) and (nil ~= ((_91_)[1])[3])) and ((_G.type((_91_)[2]) == "table") and (((_91_)[1])[1] == ((_91_)[2])[1]) and (((_91_)[1])[2] == ((_91_)[2])[2]) and (nil ~= ((_91_)[2])[3]))) then local s = ((_91_)[1])[1] local c = ((_91_)[1])[2] local x = ((_91_)[1])[3] local y = ((_91_)[2])[3]
 return (x < y) elseif ((_G.type(_91_) == "table") and ((_G.type((_91_)[1]) == "table") and (nil ~= ((_91_)[1])[1]) and (nil ~= ((_91_)[1])[2]) and true) and ((_G.type((_91_)[2]) == "table") and (((_91_)[1])[1] == ((_91_)[2])[1]) and (nil ~= ((_91_)[2])[2]) and true)) then local s = ((_91_)[1])[1] local x = ((_91_)[1])[2] local _ = ((_91_)[1])[3] local y = ((_91_)[2])[2] local _0 = ((_91_)[2])[3]
 return (x < y) elseif ((_G.type(_91_) == "table") and ((_G.type((_91_)[1]) == "table") and (nil ~= ((_91_)[1])[1]) and true and true) and ((_G.type((_91_)[2]) == "table") and (nil ~= ((_91_)[2])[1]) and true and true)) then local x = ((_91_)[1])[1] local _ = ((_91_)[1])[2] local _0 = ((_91_)[1])[3] local y = ((_91_)[2])[1] local _1 = ((_91_)[2])[2] local _2 = ((_91_)[2])[3]
 return (x < y) else return nil end end return E["sort$"](flat0, _90_) end





 local function shift_location(game, event, direction)


 local _let_93_ = game local _let_94_ = _let_93_["locations"] local cursor = _let_94_["cursor"] local locations = _let_94_["flattened"]
 local _let_95_ = cursor local cursor_slot = _let_95_[1] local cursor_col_n = _let_95_[2] local cursor_card_n = _let_95_[3] local current_index
 do local f = nil for i, location in ipairs(locations) do if f then break end
 local _96_ = location if ((_G.type(_96_) == "table") and ((_96_)[1] == cursor_slot) and ((_96_)[2] == cursor_col_n) and ((_96_)[3] == cursor_card_n)) then f = i else f = nil end end current_index = f end
 local len_locations = #locations local next_index
 do local _98_ = {direction, current_index} if ((_G.type(_98_) == "table") and ((_98_)[1] == "next") and ((_98_)[2] == nil)) then next_index = 1 else local function _99_() local i = (_98_)[2] return (i == len_locations) end if (((_G.type(_98_) == "table") and ((_98_)[1] == "next") and (nil ~= (_98_)[2])) and _99_()) then local i = (_98_)[2] next_index = 1 elseif ((_G.type(_98_) == "table") and ((_98_)[1] == "next") and (nil ~= (_98_)[2])) then local i = (_98_)[2]


 next_index = (i + 1) elseif ((_G.type(_98_) == "table") and ((_98_)[1] == "prev") and ((_98_)[2] == nil)) then
 next_index = len_locations else local function _100_() local i = (_98_)[2] return (i == 1) end if (((_G.type(_98_) == "table") and ((_98_)[1] == "prev") and (nil ~= (_98_)[2])) and _100_()) then local i = (_98_)[2]
 next_index = len_locations elseif ((_G.type(_98_) == "table") and ((_98_)[1] == "prev") and (nil ~= (_98_)[2])) then local i = (_98_)[2]
 next_index = (i - 1) else next_index = nil end end end end local new_location
 do local _102_ = locations if ((_G.type(_102_) == "table") and ((_102_)[1] == nil)) then
 new_location = cursor elseif (nil ~= _102_) then local list = _102_
 new_location = locations[next_index] else new_location = nil end end
 game["locations"]["cursor"] = new_location
 return game end

 m["next-location"] = function(game, event)
 return shift_location(game, event, "next") end
 m["prev-location"] = function(game, event)
 return shift_location(game, event, "prev") end

 m["left-mouse"] = function(game, event)





 local _let_104_ = event local location = _let_104_["location"]
 local _let_105_ = game.state.dirty local hand = _let_105_["hand"]
 local _let_106_ = location local click_slot = _let_106_[1] local click_col = _let_106_[2] local click_card = _let_106_[3] local holding_3f
 do local _107_ = hand if ((_G.type(_107_) == "table") and ((_107_)[1] == nil)) then holding_3f = false elseif ((_G.type(_107_) == "table") and (nil ~= (_107_)[1])) then local cards = (_107_)[1] holding_3f = true else holding_3f = nil end end local clicked_empty_3f






 local function _110_() local t_109_ = game.state.dirty if (nil ~= t_109_) then t_109_ = (t_109_)[click_slot] else end if (nil ~= t_109_) then t_109_ = (t_109_)[click_col] else end if (nil ~= t_109_) then t_109_ = (t_109_)[click_card] else end return t_109_ end clicked_empty_3f = nil_3f(_110_()) local next_card
 if clicked_empty_3f then next_card = click_card else next_card = (click_card + 1) end local matches_click_location_3f




 do local _115_ = {click_slot, holding_3f} if ((_G.type(_115_) == "table") and ((_115_)[1] == "tableau") and ((_115_)[2] == false)) then




 local function _116_(_241, _242) local _117_ = _242 if ((_G.type(_117_) == "table") and ((_117_)[1] == click_slot) and ((_117_)[2] == click_col) and ((_117_)[3] == click_card)) then return true else return nil end end matches_click_location_3f = _116_ elseif ((_G.type(_115_) == "table") and ((_115_)[1] == "tableau") and ((_115_)[2] == true)) then





 local function _119_(_241, _242) local _120_ = _242 if ((_G.type(_120_) == "table") and ((_120_)[1] == click_slot) and ((_120_)[2] == click_col) and ((_120_)[3] == next_card)) then return true else return nil end end matches_click_location_3f = _119_ elseif ((_G.type(_115_) == "table") and ((_115_)[1] == "foundation") and ((_115_)[2] == true)) then

 local function _122_(_241, _242) local _123_ = _242 if ((_G.type(_123_) == "table") and ((_123_)[1] == click_slot) and ((_123_)[2] == click_col) and ((_123_)[3] == next_card)) then return true else return nil end end matches_click_location_3f = _122_ elseif ((_G.type(_115_) == "table") and true and true) then local _ = (_115_)[1] local _0 = (_115_)[2]

 local function _125_(_241, _242) local _126_ = _242 if ((_G.type(_126_) == "table") and ((_126_)[1] == click_slot) and ((_126_)[2] == click_col) and ((_126_)[3] == click_card)) then return true else return nil end end matches_click_location_3f = _125_ else matches_click_location_3f = nil end end

 local cursor = E.hd(E.filter(game.locations.flattened, matches_click_location_3f))

 if cursor then
 game.locations.cursor = cursor
 return m.interact(game, event) else return nil end end

 m["right-mouse"] = function(game, event)


 local _let_130_ = event local location = _let_130_["location"]
 local _let_131_ = game.locations local hand_from = _let_131_["hand-from"]
 local _let_132_ = game.state.dirty local hand = _let_132_["hand"] local holding_3f
 do local _133_ = hand if ((_G.type(_133_) == "table") and ((_133_)[1] == nil)) then holding_3f = false elseif ((_G.type(_133_) == "table") and (nil ~= (_133_)[1])) then local cards = (_133_)[1] holding_3f = true else holding_3f = nil end end
 if holding_3f then
 game.locations.cursor = hand_from
 return m.interact(game, event) else return nil end end

 m["auto-move"] = function(game, event)
 do local _let_136_ = game.state local pure = _let_136_["pure"] local dirty = _let_136_["dirty"]
 local _137_ = logic["auto-move-ok?"](pure) if ((_G.type(_137_) == "table") and ((_137_)[1] == "ok") and ((_G.type((_137_)[2]) == "table") and (nil ~= ((_137_)[2]).from) and (nil ~= ((_137_)[2]).to))) then local from = ((_137_)[2]).from local to = ((_137_)[2]).to
 local pure0 = logic["move-cards"](pure, from, to)
 local dirty0 = m["pure-state->dirty-state"](pure0)
 local _138_ = game.state _138_["pure"] = pure0 _138_["dirty"] = dirty0 else end end


 return game end

 m.interact = function(game, event)
 local _let_140_ = game.state local pure = _let_140_["pure"] local dirty = _let_140_["dirty"]
 local _let_141_ = game.locations local cursor = _let_141_["cursor"] local hand_from = _let_141_["hand-from"]
 do local _142_ = {dirty.hand, cursor} if ((_G.type(_142_) == "table") and true and ((_G.type((_142_)[2]) == "table") and (((_142_)[2])[1] == "BUTTON") and (((_142_)[2])[2] == 1) and (nil ~= ((_142_)[2])[3]))) then local _ = (_142_)[1] local button = ((_142_)[2])[3]

 local which do local _143_ = button if (_143_ == 1) then which = "DRAGON-RED" elseif (_143_ == 2) then which = "DRAGON-GREEN" elseif (_143_ == 3) then which = "DRAGON-WHITE" else which = nil end end
 local _145_ = logic["lock-dragons-ok?"](pure, which) if ((_G.type(_145_) == "table") and ((_145_)[1] == "ok") and ((_G.type((_145_)[2]) == "table") and (nil ~= ((_145_)[2]).to))) then local to = ((_145_)[2]).to

 local pure0 = logic["lock-dragons"](pure, which)
 local dirty0 = m["pure-state->dirty-state"](pure0)

 local _146_ = game.state _146_["pure"] = pure0 _146_["dirty"] = dirty0 elseif ((_G.type(_145_) == "table") and ((_145_)[1] == "err") and (nil ~= (_145_)[2])) then local e = (_145_)[2]


 error(e) else end elseif ((_G.type(_142_) == "table") and ((_G.type((_142_)[1]) == "table") and (((_142_)[1])[1] == nil)) and true) then local _ = (_142_)[2]


 local _148_ = logic["collect-from-ok?"](pure, cursor) if ((_G.type(_148_) == "table") and ((_148_)[1] == "ok")) then
 local _let_149_ = cursor local slot = _let_149_[1] local col_n = _let_149_[2] local card_n = _let_149_[3]
 local rem, hand = E.split(pure[slot][col_n], card_n)
 do end (dirty)[slot][col_n] = rem
 dirty["hand"] = {hand}
 game.locations["hand-from"] = cursor elseif ((_G.type(_148_) == "table") and ((_148_)[1] == "err") and (nil ~= (_148_)[2])) then local e = (_148_)[2]
 error(e) else end elseif ((_G.type(_142_) == "table") and ((_G.type((_142_)[1]) == "table") and (nil ~= ((_142_)[1])[1])) and true) then local cards = ((_142_)[1])[1] local _ = (_142_)[2]




 local _151_ = {cursor, hand_from, logic["can-place-ok?"](dirty, cursor, cards)} if ((_G.type(_151_) == "table") and ((_G.type((_151_)[1]) == "table") and (nil ~= ((_151_)[1])[1]) and (nil ~= ((_151_)[1])[2]) and (nil ~= ((_151_)[1])[3])) and ((_G.type((_151_)[2]) == "table") and (((_151_)[1])[1] == ((_151_)[2])[1]) and (((_151_)[1])[2] == ((_151_)[2])[2]) and (((_151_)[1])[3] == ((_151_)[2])[3])) and true) then local s = ((_151_)[1])[1] local cl = ((_151_)[1])[2] local cd = ((_151_)[1])[3] local _0 = (_151_)[3]


 local dirty0 = m["pure-state->dirty-state"](pure)
 game.state.dirty = dirty0 elseif ((_G.type(_151_) == "table") and true and true and ((_G.type((_151_)[3]) == "table") and (((_151_)[3])[1] == "ok"))) then local _0 = (_151_)[1] local _1 = (_151_)[2]


 local pure0 = logic["move-cards"](pure, hand_from, cursor)
 local dirty0 = m["pure-state->dirty-state"](pure0)
 do local _152_ = game.locations _152_["hand-from"] = nil end

 local _153_ = game.state _153_["pure"] = pure0 _153_["dirty"] = dirty0 elseif ((_G.type(_151_) == "table") and true and true and ((_G.type((_151_)[3]) == "table") and (((_151_)[3])[1] == "err") and (nil ~= ((_151_)[3])[2]))) then local _0 = (_151_)[1] local _1 = (_151_)[2] local e = ((_151_)[3])[2]



 error(e) else end else end end
 return game end

 m["save-game"] = function(game, event)
 local save_file = join_path(vim.fn.stdpath("cache"), "shenzhen-solitaire.save")
 do local fout = io.open(save_file, "w") local function close_handlers_10_auto(ok_11_auto, ...) fout:close() if ok_11_auto then return ... else return error(..., 0) end end local function _157_() fout:write(vim.mpack.encode(game.state.pure.events))

 return vim.notify("Saved game") end close_handlers_10_auto(_G.xpcall(_157_, (package.loaded.fennel or debug).traceback)) end
 return game end

 m["load-game"] = function(game, event)

 local save_file = join_path(vim.fn.stdpath("cache"), "shenzhen-solitaire.save")
 local readable = (1 == vim.fn.filereadable(save_file))
 if readable then
 local fin = io.open(save_file) local function close_handlers_10_auto(ok_11_auto, ...) fin:close() if ok_11_auto then return ... else return error(..., 0) end end local function _159_() local bytes = fin:read("*a")

 local events = vim.mpack.decode(bytes) local pure
 local function _160_(_241, _242, _243) return logic.S.apply(_241, _243) end pure = E.reduce(events, logic.S["empty-state"](), _160_)
 local dirty = m["pure-state->dirty-state"](pure)
 local _161_ = game.state _161_["pure"] = pure _161_["dirty"] = dirty return _161_ end close_handlers_10_auto(_G.xpcall(_159_, (package.loaded.fennel or debug).traceback)) else


 error("Could not open save file, probably doesn't exist") end
 return game end

 m["restart-game"] = function(game, event)
 local _let_163_ = game.state.pure local events = _let_163_["events"] local events0
 do local initial_events, stop_3f = {}, false for _, event0 in ipairs(events) do if stop_3f then break end

 local _164_ = event0 if ((_G.type(_164_) == "table") and ((_164_)[1] == "moved-cards")) then

 initial_events, stop_3f = initial_events, true elseif true then local _0 = _164_
 initial_events, stop_3f = E["append$"](initial_events, event0), false else initial_events, stop_3f = nil end end events0 = initial_events, stop_3f end local pure
 local function _166_(_241, _242, _243) return logic.S.apply(_241, _243) end pure = E.reduce(events0, logic.S["empty-state"](), _166_)
 local dirty = m["pure-state->dirty-state"](pure)
 do local _167_ = game.state _167_["pure"] = pure _167_["dirty"] = dirty end


 return game end

 m["undo-last-move"] = function(game, event)
 if game.config.difficulty["allow-undo"] then

 local _let_168_ = game.state.pure local events = _let_168_["events"] local events0

 local function _169_() return iter_2frange(1, math.max(3, (#events - 1))) end local function _170_(_241) return events[_241] end events0 = E.map(_169_, _170_) local pure
 local function _171_(_241, _242, _243) return logic.S.apply(_241, _243) end pure = E.reduce(events0, logic.S["empty-state"](), _171_)
 local dirty = m["pure-state->dirty-state"](pure)
 local _172_ = game.state _172_["pure"] = pure _172_["dirty"] = dirty return _172_ else


 return vim.notify("Undo not enabled, see difficulty.allow-undo") end end

 return M