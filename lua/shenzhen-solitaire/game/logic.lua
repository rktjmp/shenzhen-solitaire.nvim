

 local function _2_(...) local mod_36_auto = require("shenzhen-solitaire.game.deck") local keys_37_auto = {"valid-sequence?", "new", "dragon-card?", "flower-card?", "card-type", "special-card?", "suited-card?"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.game.deck\"")) end return mod_36_auto end local _local_1_ = _2_(...) local card_type = _local_1_["card-type"] local dragon_card_3f = _local_1_["dragon-card?"] local flower_card_3f = _local_1_["flower-card?"] local new_deck = _local_1_["new"] local special_card_3f = _local_1_["special-card?"] local suited_card_3f = _local_1_["suited-card?"] local valid_sequence_3f = _local_1_["valid-sequence?"] local function _4_(...)






 local mod_36_auto = string local keys_37_auto = {"format"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "string")) end return mod_36_auto end local _local_3_ = _4_(...) local fmt = _local_3_["format"] local function _6_(...) local mod_36_auto = require("shenzhen-solitaire.lib.donut.iter") local keys_37_auto = {"range"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.lib.donut.iter\"")) end return mod_36_auto end local _local_5_ = _6_(...) local iter_2frange = _local_5_["range"] local enum = require("shenzhen-solitaire.lib.donut.enum") local function _8_(...) local mod_36_auto = require("shenzhen-solitaire.lib.donut.inspect") local keys_37_auto = {"inspect!", "inspect"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.lib.donut.inspect\"")) end return mod_36_auto end local _local_7_ = _8_(...) local inspect = _local_7_["inspect"] local inspect_21 = _local_7_["inspect!"] local function _10_(...) local mod_36_auto = require("shenzhen-solitaire.lib.donut.type") local keys_37_auto = {"nil?"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.lib.donut.type\"")) end return mod_36_auto end local _local_9_ = _10_(...) local nil_3f = _local_9_["nil?"] local function _12_(...) local mod_36_auto = require("shenzhen-solitaire.lib.donut.f") local keys_37_auto = {"tap"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.lib.donut.f\"")) end return mod_36_auto end local _local_11_ = _12_(...) local tap = _local_11_["tap"] local R = require("shenzhen-solitaire.lib.donut.result") local function _14_(...) local mod_36_auto = require("shenzhen-solitaire.lib.donut.result") local keys_37_auto = {"err", "ok?", "err?", "map", "ok", "unit"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"shenzhen-solitaire.lib.donut.result\"")) end return mod_36_auto end local _local_13_ = _14_(...) local r_2ferr = _local_13_["err"] local r_2ferr_3f = _local_13_["err?"] local r_2fmap = _local_13_["map"] local r_2fok = _local_13_["ok"] local r_2fok_3f = _local_13_["ok?"] local r_2funit = _local_13_["unit"] do local _ = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil} end










 local S = {}


 local handlers = {}

 local function generate_locations(state, opts)


 local function _17_(slot, _15_) local _arg_16_ = _15_ local from = _arg_16_[1] local to = _arg_16_[2]
 local function _18_() return iter_2frange(from, to) end
 local function _19_(_241) return {slot, _241, math.max(1, #state[slot][_241])} end return enum.map(_18_, _19_) end return enum["flat-map"](opts, _17_) end

 local function generate_pickup_locations(state, opts)


 local function _22_(slot, _20_) local _arg_21_ = _20_ local from = _arg_21_[1] local to = _arg_21_[2]
 local function _23_() return iter_2frange(from, to) end
 local function _24_(_241) local _25_ = #state[slot][_241] if (_25_ == 0) then
 return nil elseif (nil ~= _25_) then local n = _25_
 return {slot, _241, n} else return nil end end return enum.map(_23_, _24_) end return enum["flat-map"](opts, _22_) end


 local function generate_putdown_locations(state, opts)


 local function _29_(slot, _27_) local _arg_28_ = _27_ local from = _arg_28_[1] local to = _arg_28_[2]
 local function _30_() return iter_2frange(from, to) end
 local function _31_(_241) local _32_ = #state[slot][_241] if (_32_ == 0) then
 return {slot, _241, 1} elseif (nil ~= _32_) then local n = _32_
 return {slot, _241, (n + 1)} else return nil end end return enum.map(_30_, _31_) end return enum["flat-map"](opts, _29_) end

 local function location__3ecard(state, location)

 local _let_34_ = location local slot = _let_34_[1] local col_n = _let_34_[2] local card_n = _let_34_[3]
 local t_35_ = state if (nil ~= t_35_) then t_35_ = (t_35_)[slot] else end if (nil ~= t_35_) then t_35_ = (t_35_)[col_n] else end if (nil ~= t_35_) then t_35_ = (t_35_)[card_n] else end return t_35_ end

 S["empty-state"] = function(id, seed)
 return {["game-id"] = id, seed = seed, events = {}, ["last-event"] = 0, foundation = {{}, {}, {}, {}}, tableau = {{}, {}, {}, {}, {}, {}, {}, {}}, cell = {{}, {}, {}}, stock = {}} end












 S["clone-state"] = function(old_state)

 local new_state = enum["set$"](enum["set$"](S["empty-state"](old_state.id, old_state.seed), "last-event", old_state["last-event"]), "events", enum.copy(old_state.events))





 local function _39_(_, key)
 local from = old_state[key] local copied
 local function _40_(_241, _242) return enum.copy(_242) end copied = enum.map(from, _40_)
 return enum["set$"](new_state, key, copied) end enum.each({"foundation", "tableau", "cell"}, _39_)

 local function _41_(_241, _242) return enum["set$"](new_state, _242, enum.copy(old_state[_242])) end enum.each({"stock"}, _41_)
 return new_state end

 S["push-event"] = function(state, event)

 table.insert(state.events, event)
 do end (state)["last-event"] = #state.events
 return state end

 S.apply = function(state, _42_) local _arg_43_ = _42_ local name = _arg_43_[1] local data = _arg_43_[2]


 local f = handlers[name]
 local _ = assert(f, ("Could not find applicative for " .. name))
 local cloned_state = S["clone-state"](state)
 local _44_, _45_ = f(cloned_state, data) if (nil ~= _44_) then local a_state = _44_
 return S["push-event"](a_state, {name, data}) elseif ((_44_ == nil) and (nil ~= _45_)) then local err = _45_
 return error(err) else return nil end end



 handlers["started-new-game"] = function(state, _47_) local _arg_48_ = _47_ local id = _arg_48_["id"] local seed = _arg_48_["seed"]
 local deck = new_deck()
 state["stock"] = deck state["game-id"] = id state["seed"] = seed return state end




 handlers["shuffled-deck"] = function(state)
 math.randomseed(state.seed)
 enum["shuffle$"](state.stock)
 return state end

 handlers["dealt-cards"] = function(state)

 local cols = enum["chunk-every"](state.stock, 5) local cols__3etableau
 local function _49_(_241, _242) state["tableau"][_241] = _242 return nil end cols__3etableau = _49_
 enum.each(cols, cols__3etableau)
 state.stock = {}
 return state end

 handlers["moved-cards"] = function(state, _50_) local _arg_51_ = _50_ local from = _arg_51_["from"] local to = _arg_51_["to"]



 local _let_52_ = from local from_slot = _let_52_[1] local from_col_n = _let_52_[2] local from_card_n = _let_52_[3]
 local _let_53_ = to local to_slot = _let_53_[1] local to_col_n = _let_53_[2] local to_card_n = _let_53_[3]
 local left_over_from, hand = enum.split(state[from_slot][from_col_n], from_card_n)
 state[from_slot][from_col_n] = left_over_from state[to_slot][to_col_n] = enum["concat$"]({}, state[to_slot][to_col_n], hand) return state end



 handlers["locked-dragons"] = function(state, _54_) local _arg_55_ = _54_ local dragon_name = _arg_55_["name"] local dragon_locations = _arg_55_["from"] local cell_location = _arg_55_["to"]
 local dragon_cards local function _56_(_241, _242) return location__3ecard(state, _242) end dragon_cards = enum.map(dragon_locations, _56_)

 local function _57_(_241, _242) local _let_58_ = _242 local slot_name = _let_58_[1] local col_n = _let_58_[2] local card_n = _let_58_[3]
 state[slot_name][col_n][card_n] = nil return nil end enum.map(dragon_locations, _57_)

 do local _let_59_ = cell_location local slot = _let_59_[1] local col = _let_59_[2] local _ = _let_59_[3]
 state[slot][col] = dragon_cards end
 return state end

 local M = {}

 M["collect-from-ok?"] = function(state, _60_) local _arg_61_ = _60_ local slot = _arg_61_[1] local col_n = _arg_61_[2] local card_n = _arg_61_[3]


 local _let_62_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_62_["bind"] local unit_2_auto = _let_62_["unit"] local bind_63_ = bind_1_auto local unit_64_ = unit_2_auto local function _66_() local t_65_ = state if (nil ~= t_65_) then t_65_ = (t_65_)[slot] else end if (nil ~= t_65_) then t_65_ = (t_65_)[col_n] else end return t_65_ end local function _69_(col) local function _70_()
 local _71_ = {slot, col} if ((_G.type(_71_) == "table") and true and ((_71_)[2] == nil)) then local _ = (_71_)[1]

 return error(fmt("invalid location: %s.%d", slot, col_n)) elseif ((_G.type(_71_) == "table") and ((_71_)[1] == "foundation") and true) then local _ = (_71_)[2]

 return nil, "You may never collect from a foundation" elseif ((_G.type(_71_) == "table") and true and ((_G.type((_71_)[2]) == "table") and (((_71_)[2])[1] == nil))) then local _ = (_71_)[1]

 return nil, fmt("unable to collect from %s.%d because it is empty", slot, col_n) else local function _72_() local card = ((_71_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_71_)[2]))} return (card_n == #col) end if (((_G.type(_71_) == "table") and ((_71_)[1] == "tableau") and ((_G.type((_71_)[2]) == "table") and (nil ~= ((_71_)[2])[1]))) and _72_()) then local card = ((_71_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_71_)[2]))} return true else local function _73_() local card = ((_71_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_71_)[2]))} return (function(_74_,_75_,_76_) return (_74_ < _75_) and (_75_ < _76_) end)(0,card_n,#col) end if (((_G.type(_71_) == "table") and ((_71_)[1] == "tableau") and ((_G.type((_71_)[2]) == "table") and (nil ~= ((_71_)[2])[1]))) and _73_()) then local card = ((_71_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_71_)[2]))}




 local rem, hand = enum.split(col, card_n)
 if valid_sequence_3f(hand) then return true else

 return nil, "may only collect alternating suit descending sequences" end else local function _78_() local card = ((_71_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_71_)[2]))} return (#col < card_n) end if (((_G.type(_71_) == "table") and ((_71_)[1] == "tableau") and ((_G.type((_71_)[2]) == "table") and (nil ~= ((_71_)[2])[1]))) and _78_()) then local card = ((_71_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_71_)[2]))}


 return nil, fmt("unable to collect from %s.%d.%d because it over runs length", slot, col_n, card_n) else local function _79_() local card = ((_71_)[2])[1] return (card_n == 1) end if (((_G.type(_71_) == "table") and ((_71_)[1] == "cell") and ((_G.type((_71_)[2]) == "table") and (nil ~= ((_71_)[2])[1]))) and _79_()) then local card = ((_71_)[2])[1]


 local cell = state[slot][col_n]
 local _80_ = cell if ((_G.type(_80_) == "table") and (nil ~= (_80_)[1]) and ((_80_)[2] == nil)) then local any = (_80_)[1] return true elseif ((_G.type(_80_) == "table") and (nil ~= (_80_)[1]) and (nil ~= (_80_)[2]) and (nil ~= (_80_)[3]) and (nil ~= (_80_)[4]) and ((_80_)[5] == nil)) then local a = (_80_)[1] local b = (_80_)[2] local c = (_80_)[3] local d = (_80_)[4]

 return nil, "cant collect from locked cells" elseif true then local _ = _80_
 return error("internal logic error") else return nil end else local function _82_() local card = ((_71_)[2])[1] return (1 < card_n) end if (((_G.type(_71_) == "table") and ((_71_)[1] == "cell") and ((_G.type((_71_)[2]) == "table") and (nil ~= ((_71_)[2])[1]))) and _82_()) then local card = ((_71_)[2])[1]
 return nil, "cant collect over the first card in a cell" elseif true then local _ = _71_

 return error(fmt("unmatched collect request: %s.%d %d", slot, col_n, card_n)) else return nil end end end end end end end return unit_64_(_70_()) end return bind_63_(unit_64_(_66_()), _69_) end

 local function place_on_foundation_ok_3f(foundation, card_n, cards, flower_foundation_3f)
 local _let_84_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_84_["bind"] local unit_2_auto = _let_84_["unit"] local bind_85_ = bind_1_auto local unit_86_ = unit_2_auto local function _87_(_) local function _90_(_88_)
 local _arg_89_ = _88_ local card = _arg_89_[1] local function _91_(foundation_card) local function _92_(_0)



 local function _93_() if flower_foundation_3f then
 return (flower_card_3f(card) or r_2ferr("may only place flower card on flower foundation")) else
 return (suited_card_3f(card) or r_2ferr("may only place suited cards on foundation")) end end local function _94_(_1) local function _95_()
 if flower_foundation_3f then
 local _96_ = {foundation_card, card} if ((_G.type(_96_) == "table") and ((_96_)[1] == nil) and ((_G.type((_96_)[2]) == "table") and (((_96_)[2])[1] == "FLOWER") and true)) then local _2 = ((_96_)[2])[2] return true elseif ((_G.type(_96_) == "table") and (nil ~= (_96_)[1]) and ((_G.type((_96_)[2]) == "table") and (((_96_)[2])[1] == "FLOWER") and true)) then local any = (_96_)[1] local _2 = ((_96_)[2])[2]



 return error("attempted to place flower on flower") else return nil end else
 local _98_ = {foundation_card, card} local function _99_() local _2 = ((_98_)[2])[1] local v = ((_98_)[2])[2] return not (1 == v) end if (((_G.type(_98_) == "table") and ((_98_)[1] == nil) and ((_G.type((_98_)[2]) == "table") and true and (nil ~= ((_98_)[2])[2]))) and _99_()) then local _2 = ((_98_)[2])[1] local v = ((_98_)[2])[2]

 return nil, "foundation must start with value 1 card" elseif ((_G.type(_98_) == "table") and ((_98_)[1] == nil) and ((_G.type((_98_)[2]) == "table") and true and (((_98_)[2])[2] == 1))) then local _2 = ((_98_)[2])[1] return true else local function _100_() local suit = ((_98_)[1])[1] local last_val = ((_98_)[1])[2] local next_val = ((_98_)[2])[2] return (next_val == (last_val + 1)) end if (((_G.type(_98_) == "table") and ((_G.type((_98_)[1]) == "table") and (nil ~= ((_98_)[1])[1]) and (nil ~= ((_98_)[1])[2])) and ((_G.type((_98_)[2]) == "table") and (((_98_)[1])[1] == ((_98_)[2])[1]) and (nil ~= ((_98_)[2])[2]))) and _100_()) then local suit = ((_98_)[1])[1] local last_val = ((_98_)[1])[2] local next_val = ((_98_)[2])[2] return true elseif ((_G.type(_98_) == "table") and true and true) then local _2 = (_98_)[1] local _3 = (_98_)[2]




 return nil, "must place same suit and +1 value on existing foundation" else return nil end end end end return unit_86_(_95_()) end return unit_86_(bind_85_(unit_86_(_93_()), _94_)) end return unit_86_(bind_85_(unit_86_(((card_n == (1 + #foundation)) or r_2ferr("must place on top of last card in foundation"))), _92_)) end return unit_86_(bind_85_(unit_86_(foundation[#foundation]), _91_)) end return unit_86_(bind_85_(unit_86_(cards), _90_)) end return bind_85_(unit_86_(((1 == #cards) or r_2ferr("may only place one card at a time on a foundation"))), _87_) end

 local function place_on_cell_ok_3f(cell, card_n, cards)



 local _let_103_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_103_["bind"] local unit_2_auto = _let_103_["unit"] local bind_104_ = bind_1_auto local unit_105_ = unit_2_auto local function _106_(_) local function _107_()
 local _108_ = {cell, cards} if ((_G.type(_108_) == "table") and ((_G.type((_108_)[1]) == "table") and (nil ~= ((_108_)[1])[1])) and true) then local not_nil = ((_108_)[1])[1] local _0 = (_108_)[2]

 return nil, "can only place into an empty cell" else local function _109_() local d = (((_108_)[2])[1])[1] local _0 = (((_108_)[2])[1])[2] local _1 = (((_108_)[2])[2])[2] local _2 = (((_108_)[2])[3])[2] local _3 = (((_108_)[2])[4])[2] return string.match(d, "^DRAGON-") end if (((_G.type(_108_) == "table") and ((_G.type((_108_)[1]) == "table") and (((_108_)[1])[1] == nil)) and ((_G.type((_108_)[2]) == "table") and ((_G.type(((_108_)[2])[1]) == "table") and (nil ~= (((_108_)[2])[1])[1]) and true) and ((_G.type(((_108_)[2])[2]) == "table") and ((((_108_)[2])[1])[1] == (((_108_)[2])[2])[1]) and true) and ((_G.type(((_108_)[2])[3]) == "table") and ((((_108_)[2])[1])[1] == (((_108_)[2])[3])[1]) and true) and ((_G.type(((_108_)[2])[4]) == "table") and ((((_108_)[2])[1])[1] == (((_108_)[2])[4])[1]) and true))) and _109_()) then local d = (((_108_)[2])[1])[1] local _0 = (((_108_)[2])[1])[2] local _1 = (((_108_)[2])[2])[2] local _2 = (((_108_)[2])[3])[2] local _3 = (((_108_)[2])[4])[2] return true elseif ((_G.type(_108_) == "table") and ((_G.type((_108_)[1]) == "table") and (((_108_)[1])[1] == nil)) and ((_G.type((_108_)[2]) == "table") and (nil ~= ((_108_)[2])[1]) and (((_108_)[2])[2] == nil))) then local card = ((_108_)[2])[1] return true else local function _110_() local _0 = (_108_)[1] local card = ((_108_)[2])[1] local rest = {select(2, (table.unpack or _G.unpack)((_108_)[2]))} return (0 < #rest) end if (((_G.type(_108_) == "table") and true and ((_G.type((_108_)[2]) == "table") and (nil ~= ((_108_)[2])[1]))) and _110_()) then local _0 = (_108_)[1] local card = ((_108_)[2])[1] local rest = {select(2, (table.unpack or _G.unpack)((_108_)[2]))}






 return nil, "can only place one card on a cell" else return nil end end end end return unit_105_(_107_()) end return bind_104_(unit_105_(((1 == card_n) or nil or "must place on card-n 1 for cells")), _106_) end

 local function place_on_tableau_ok_3f(column, card_n, cards)

 local _let_112_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_112_["bind"] local unit_2_auto = _let_112_["unit"] local bind_113_ = bind_1_auto local unit_114_ = unit_2_auto local function _115_(col_len)

 local function _116_() if not (card_n == (1 + col_len)) then
 return nil, "must place at end of column" else return nil end end local function _117_(_) local function _118_(t_card) local function _119_(new_seq) local function _120_()




 local _121_ = {t_card, valid_sequence_3f(new_seq)} if ((_G.type(_121_) == "table") and ((_121_)[1] == nil) and true) then local _0 = (_121_)[2] return true elseif ((_G.type(_121_) == "table") and true and ((_121_)[2] == true)) then local _0 = (_121_)[1] return true elseif ((_G.type(_121_) == "table") and true and ((_121_)[2] == false)) then local _0 = (_121_)[1]






 return nil, "must create alternating suit descending sequence" else return nil end end return unit_114_(_120_()) end return unit_114_(bind_113_(unit_114_(enum["append$"]({t_card}, unpack(cards))), _119_)) end return unit_114_(bind_113_(unit_114_(column[col_len]), _118_)) end return unit_114_(bind_113_(unit_114_(_116_()), _117_)) end return bind_113_(unit_114_(#column), _115_) end

 M["can-place-ok?"] = function(state, _123_, cards) local _arg_124_ = _123_ local slot = _arg_124_[1] local col_n = _arg_124_[2] local card_n = _arg_124_[3]
 local _125_ = {slot, state[slot][col_n]} if ((_G.type(_125_) == "table") and ((_125_)[1] == "foundation") and (nil ~= (_125_)[2])) then local foundation = (_125_)[2]
 return place_on_foundation_ok_3f(foundation, card_n, cards, (col_n == 4)) elseif ((_G.type(_125_) == "table") and ((_125_)[1] == "cell") and (nil ~= (_125_)[2])) then local cell = (_125_)[2]
 return place_on_cell_ok_3f(cell, card_n, cards) elseif ((_G.type(_125_) == "table") and ((_125_)[1] == "tableau") and (nil ~= (_125_)[2])) then local col = (_125_)[2]
 return place_on_tableau_ok_3f(col, card_n, cards) elseif true then local _ = _125_
 return error(fmt("unmatched can-place-on? %s %s", inspect(slot, col_n))) else return nil end end












 M["move-cards-ok?"] = function(state, from, to)



 assert(state, "requires state argument")
 assert(from, "requires from argument")
 assert(to, "requires to argument")

 local function location_arg_ok_3f(name, _127_) local _arg_128_ = _127_ local slot = _arg_128_[1] local col = _arg_128_[2] local card = _arg_128_[3]

 local _let_129_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_129_["bind"] local unit_2_auto = _let_129_["unit"] local bind_130_ = bind_1_auto local unit_131_ = unit_2_auto local function _132_(slot0) local function _133_(col0) local function _134_(card0) local function _135_() return true end return unit_131_(_135_()) end return unit_131_(bind_130_(unit_131_((card or R.err((name .. " location was missing card")))), _134_)) end return unit_131_(bind_130_(unit_131_((col or R.err((name .. " location was missing col")))), _133_)) end return bind_130_(unit_131_((slot or R.err((name .. " location was mising slot name")))), _132_) end




 local function location_resolves_ok_3f(name, _136_, ignore_card_3f) local _arg_137_ = _136_ local slot = _arg_137_[1] local col = _arg_137_[2] local card = _arg_137_[3]


 local _let_138_ = require("shenzhen-solitaire.lib.donut.result") local ok_3f_5_auto = _let_138_["ok?"] local unwrap_4_auto = _let_138_["unwrap"] local cap_6_auto local function _139_(...) return select("#", ...), {...} end cap_6_auto = _139_ local result_7_auto do local _let_140_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_140_["bind"] local unit_2_auto = _let_140_["unit"] local bind_141_ = bind_1_auto local unit_142_ = unit_2_auto local function _143_(real_slot) local function _144_(real_col) local function _145_(real_card) local function _146_() return true end return unit_142_(_146_()) end return unit_142_(bind_141_(unit_142_(((ignore_card_3f or real_col[card]) or R.err((name .. " " .. slot .. "." .. col .. " card was invalid")))), _145_)) end return unit_142_(bind_141_(unit_142_((real_slot[col] or R.err((name .. " " .. slot .. " col was invalid")))), _144_)) end result_7_auto = bind_141_(unit_142_((state[slot] or R.err((name .. " slot was invalid")))), _143_) end if ok_3f_5_auto(result_7_auto) then return unwrap_4_auto(result_7_auto) else return nil, unwrap_4_auto(result_7_auto) end end
















 local _let_148_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_148_["bind"] local unit_2_auto = _let_148_["unit"] local bind_149_ = bind_1_auto local unit_150_ = unit_2_auto local function _151_(_) local function _152_(_0) local function _153_(_1) local function _154_(_2) local function _157_(_155_)









 local _arg_156_ = _155_ local from_slot = _arg_156_[1] local from_col_n = _arg_156_[2] local from_card_n = _arg_156_[3] local function _160_(_158_)
 local _arg_159_ = _158_ local to_slot = _arg_159_[1] local to_col_n = _arg_159_[2] local to_card_n = _arg_159_[3] local function _161_(can_collect_3f) local function _162_(rem, hand) local function _163_(can_place_3f) local function _164_()









 if (can_collect_3f and can_place_3f) then
 return R.ok({from = from, to = to}) else
 return R.err("unable proceed, this was unexpected, please log an issue") end end return unit_150_(_164_()) end return unit_150_(bind_149_(unit_150_(M["can-place-ok?"](state, to, hand)), _163_)) end return unit_150_(bind_149_(unit_150_(enum.split(state[from_slot][from_col_n], from_card_n)), _162_)) end return unit_150_(bind_149_(unit_150_(M["collect-from-ok?"](state, from)), _161_)) end return unit_150_(bind_149_(unit_150_(to), _160_)) end return unit_150_(bind_149_(unit_150_(from), _157_)) end return unit_150_(bind_149_(unit_150_(location_resolves_ok_3f("to", to, true)), _154_)) end return unit_150_(bind_149_(unit_150_(location_resolves_ok_3f("from", from)), _153_)) end return unit_150_(bind_149_(unit_150_(location_arg_ok_3f("to", to)), _152_)) end return bind_149_(unit_150_(location_arg_ok_3f("from", from)), _151_) end

 M["start-new-game"] = function(_3fseed)



 local game_id = math.random(1, 9000000000)
 local seed = (_3fseed or math.random(1, 9000000000))
 return S.apply(S.apply(S.apply(S["empty-state"](), {"started-new-game", {id = game_id, seed = seed}}), {"shuffled-deck"}), {"dealt-cards"}) end




 M["move-cards"] = function(state, from, to)










 local function _166_(_241) return S.apply(state, {"moved-cards", _241}) end return R["unwrap!"](R.map(M["move-cards-ok?"](state, from, to), _166_)) end


 M["lock-dragons-ok?"] = function(state, dragon_name)
 local dragon_locations
 local function _167_(_241, _242) local _168_ = location__3ecard(state, _242) if ((_G.type(_168_) == "table") and ((_168_)[1] == dragon_name) and true) then local _ = (_168_)[2] return true else return nil end end dragon_locations = enum.filter(generate_pickup_locations(state, {tableau = {1, 8}, cell = {1, 3}}), _167_) local cell_location


 local function _170_(_241, _242) local _171_ = location__3ecard(state, _242) if ((_G.type(_171_) == "table") and ((_171_)[1] == dragon_name) and true) then local _ = (_171_)[2] return true elseif ((_G.type(_171_) == "table") and (nil ~= (_171_)[1]) and true) then local any = (_171_)[1] local _ = (_171_)[2] return false elseif (_171_ == nil) then return true else return nil end end cell_location = enum.hd(enum.filter(generate_locations(state, {cell = {1, 3}}), _170_))





 local n_locs = #dragon_locations
 local _173_ = {(4 == n_locs), not nil_3f(cell_location)} if ((_G.type(_173_) == "table") and ((_173_)[1] == true) and ((_173_)[2] == true)) then
 return R.ok({name = dragon_name, from = dragon_locations, to = cell_location}) elseif ((_G.type(_173_) == "table") and ((_173_)[1] == false) and true) then local _ = (_173_)[2]
 return R.err(fmt("need 4 dragons to lock, found %d %s", n_locs, dragon_name)) elseif ((_G.type(_173_) == "table") and ((_173_)[1] == true) and ((_173_)[2] == false)) then
 return R.err(fmt("no free cell")) else return nil end end

 M["lock-dragons"] = function(state, dragon_name)

 local function _175_(_241) return S.apply(state, {"locked-dragons", _241}) end return R["unwrap!"](R.map(M["lock-dragons-ok?"](state, dragon_name), _175_)) end


 M["auto-move-ok?"] = function(state)

 local foundations = generate_putdown_locations(state, {foundation = {1, 4}}) local all_cards


 local function _176_() return iter_2frange(1, 8) end
 local function _177_(col_n)
 local function _178_() return iter_2frange(1, 40) end
 local function _179_(_241) return {"tableau", col_n, _241} end return enum.map(_178_, _179_) end
 local function _180_() return iter_2frange(1, 3) end local function _181_(_241) return {"cell", 1, _241} end
 local function _182_(_241, _242) return location__3ecard(state, _242) end all_cards = enum.map(enum["concat$"](enum["flat-map"](_176_, _177_), enum.map(_180_, _181_)), _182_) local no_higher_card_3f
 local function _185_(_183_) local _arg_184_ = _183_ local _ = _arg_184_[1] local min_value = _arg_184_[2]








 local function _186_(_241) return (0 == #_241) end local function _187_(_241, _242) local _188_ = _242 if ((_G.type(_188_) == "table") and ((_188_)[1] == "FLOWER") and true) then local _0 = (_188_)[2] return false elseif ((_G.type(_188_) == "table") and ((_188_)[1] == "DRAGON-GREEN") and true) then local _0 = (_188_)[2] return false elseif ((_G.type(_188_) == "table") and ((_188_)[1] == "DRAGON-RED") and true) then local _0 = (_188_)[2] return false elseif ((_G.type(_188_) == "table") and ((_188_)[1] == "DRAGON-WHITE") and true) then local _0 = (_188_)[2] return false elseif ((_G.type(_188_) == "table") and true and (nil ~= (_188_)[2])) then local _0 = (_188_)[1] local test_value = (_188_)[2] return (test_value < min_value) else return nil end end return _186_(enum.filter(all_cards, _187_)) end no_higher_card_3f = _185_ local posibilities

 local function _190_(_241, _242) return {_242, location__3ecard(state, _242)} end




 local function _191_(_241, _242) local _192_ = {_241, _242} if ((_G.type(_192_) == "table") and ((_G.type((_192_)[1]) == "table") and true and ((_G.type(((_192_)[1])[2]) == "table") and (nil ~= (((_192_)[1])[2])[1]) and (nil ~= (((_192_)[1])[2])[2]))) and ((_G.type((_192_)[2]) == "table") and true and ((_G.type(((_192_)[2])[2]) == "table") and (nil ~= (((_192_)[2])[2])[1]) and (nil ~= (((_192_)[2])[2])[2])))) then local _ = ((_192_)[1])[1] local t_a = (((_192_)[1])[2])[1] local v_a = (((_192_)[1])[2])[2] local _0 = ((_192_)[2])[1] local t_b = (((_192_)[2])[2])[1] local v_b = (((_192_)[2])[2])[2]
 return ((t_a < t_b) and (v_a < v_b)) else return nil end end

 local function _194_(_241, _242) local _let_195_ = _242 local _ = _let_195_[1] local card = _let_195_[2]
 return no_higher_card_3f(card) end
 local function _198_(_, _196_) local _arg_197_ = _196_ local location = _arg_197_[1] local card = _arg_197_[2]
 local function _199_(_241, _242) return {from = location, to = _242, card = card} end return enum.map(foundations, _199_) end posibilities = enum["flat-map"](enum.filter(enum["sort$"](enum.map(generate_pickup_locations(state, {tableau = {1, 8}, cell = {1, 3}}), _190_), _191_), _194_), _198_) local pick


 do local i, found_3f = nil, false for index, test in ipairs(posibilities) do if found_3f then break end
 if R["ok?"](M["move-cards-ok?"](state, test.from, test.to)) then
 i, found_3f = index, true else
 i, found_3f = nil, false end end pick = i, found_3f end
 if pick then
 local _let_201_ = posibilities[pick] local from = _let_201_["from"] local to = _let_201_["to"]
 return R.ok({from = from, to = to}) else
 return R.err("no auto-move found") end end

 M["win-game-ok?"] = function(state)
 local tableau_cards local function _203_() return iter_2frange(1, 8) end
 local function _204_(col_n) local function _205_() return iter_2frange(1, 40) end
 local function _206_(_241) return {"tableau", col_n, _241} end return enum.map(_205_, _206_) end
 local function _207_(_241, _242) return location__3ecard(state, _242) end tableau_cards = enum.map(enum["flat-map"](_203_, _204_), _207_)
 if (0 == #tableau_cards) then

 return R.ok(true) else
 return R.err(false) end end

 M["S"] = S
 return M