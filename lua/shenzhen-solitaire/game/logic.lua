

 local function _2_(...) local mod_44_auto = require("shenzhen-solitaire.game.deck") local keys_45_auto = {"dragon-card?", "flower-card?", "valid-sequence?", "new", "special-card?", "suited-card?", "card-type"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.game.deck\"")) end return mod_44_auto end local _local_1_ = _2_(...) local card_type = _local_1_["card-type"] local dragon_card_3f = _local_1_["dragon-card?"] local flower_card_3f = _local_1_["flower-card?"] local new_deck = _local_1_["new"] local special_card_3f = _local_1_["special-card?"] local suited_card_3f = _local_1_["suited-card?"] local valid_sequence_3f = _local_1_["valid-sequence?"] local function _4_(...)






 local mod_44_auto = string local keys_45_auto = {"format"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "string")) end return mod_44_auto end local _local_3_ = _4_(...) local fmt = _local_3_["format"] local function _6_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.iter") local keys_45_auto = {"range"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.iter\"")) end return mod_44_auto end local _local_5_ = _6_(...) local iter_2frange = _local_5_["range"] local enum = require("shenzhen-solitaire.lib.donut.enum") local function _8_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.inspect") local keys_45_auto = {"inspect!", "inspect"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.inspect\"")) end return mod_44_auto end local _local_7_ = _8_(...) local inspect = _local_7_["inspect"] local inspect_21 = _local_7_["inspect!"] local function _10_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.type") local keys_45_auto = {"nil?"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.type\"")) end return mod_44_auto end local _local_9_ = _10_(...) local nil_3f = _local_9_["nil?"] local function _12_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.f") local keys_45_auto = {"tap"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.f\"")) end return mod_44_auto end local _local_11_ = _12_(...) local tap = _local_11_["tap"] local R = require("shenzhen-solitaire.lib.donut.result") local function _14_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.result") local keys_45_auto = {"err?", "unit", "map", "err", "ok", "ok?"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.result\"")) end return mod_44_auto end local _local_13_ = _14_(...) local r_2ferr = _local_13_["err"] local r_2ferr_3f = _local_13_["err?"] local r_2fmap = _local_13_["map"] local r_2fok = _local_13_["ok"] local r_2fok_3f = _local_13_["ok?"] local r_2funit = _local_13_["unit"] do local _ = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil} end










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
 return nil elseif (nil ~= _25_) then local n = _25_ return {slot, _241, n} else return nil end end return enum.map(_23_, _24_) end return enum["flat-map"](opts, _22_) end



 local function generate_putdown_locations(state, opts)


 local function _29_(slot, _27_) local _arg_28_ = _27_ local from = _arg_28_[1] local to = _arg_28_[2]
 local function _30_() return iter_2frange(from, to) end
 local function _31_(_241) local _32_ = #state[slot][_241] if (_32_ == 0) then return {slot, _241, 1} elseif (nil ~= _32_) then local n = _32_ return {slot, _241, (n + 1)} else return nil end end return enum.map(_30_, _31_) end return enum["flat-map"](opts, _29_) end



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
 local _49_ = state _49_["stock"] = deck _49_["game-id"] = id _49_["seed"] = seed return _49_ end




 handlers["shuffled-deck"] = function(state)
 math.randomseed(state.seed)
 enum["shuffle$"](state.stock)
 return state end

 handlers["dealt-cards"] = function(state)

 local cols = enum["chunk-every"](state.stock, 5) local cols__3etableau
 local function _50_(_241, _242) state["tableau"][_241] = _242 return nil end cols__3etableau = _50_
 enum.each(cols, cols__3etableau)
 state.stock = {}
 return state end

 handlers["moved-cards"] = function(state, _51_) local _arg_52_ = _51_ local from = _arg_52_["from"] local to = _arg_52_["to"]



 local _let_53_ = from local from_slot = _let_53_[1] local from_col_n = _let_53_[2] local from_card_n = _let_53_[3]
 local _let_54_ = to local to_slot = _let_54_[1] local to_col_n = _let_54_[2] local to_card_n = _let_54_[3]
 local left_over_from, hand = enum.split(state[from_slot][from_col_n], from_card_n)
 local _55_ = state _55_[from_slot][from_col_n] = left_over_from _55_[to_slot][to_col_n] = enum["concat$"]({}, state[to_slot][to_col_n], hand) return _55_ end



 handlers["locked-dragons"] = function(state, _56_) local _arg_57_ = _56_ local dragon_name = _arg_57_["name"] local dragon_locations = _arg_57_["from"] local cell_location = _arg_57_["to"]
 local dragon_cards local function _58_(_241, _242) return location__3ecard(state, _242) end dragon_cards = enum.map(dragon_locations, _58_)

 local function _59_(_241, _242) local _let_60_ = _242 local slot_name = _let_60_[1] local col_n = _let_60_[2] local card_n = _let_60_[3]
 state[slot_name][col_n][card_n] = nil return nil end enum.map(dragon_locations, _59_)

 do local _let_61_ = cell_location local slot = _let_61_[1] local col = _let_61_[2] local _ = _let_61_[3]
 state[slot][col] = dragon_cards end
 return state end

 local M = {}

 M["collect-from-ok?"] = function(state, _62_) local _arg_63_ = _62_ local slot = _arg_63_[1] local col_n = _arg_63_[2] local card_n = _arg_63_[3]


 local _let_64_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_64_["bind"] local unit_2_auto = _let_64_["unit"] local bind_65_ = bind_1_auto local unit_66_ = unit_2_auto local function _68_() local t_67_ = state if (nil ~= t_67_) then t_67_ = (t_67_)[slot] else end if (nil ~= t_67_) then t_67_ = (t_67_)[col_n] else end return t_67_ end local function _71_(col) local function _72_()
 local _73_ = {slot, col} if ((_G.type(_73_) == "table") and true and ((_73_)[2] == nil)) then local _ = (_73_)[1]

 return error(fmt("invalid location: %s.%d", slot, col_n)) elseif ((_G.type(_73_) == "table") and ((_73_)[1] == "foundation") and true) then local _ = (_73_)[2]

 return nil, "You may never collect from a foundation" elseif ((_G.type(_73_) == "table") and true and ((_G.type((_73_)[2]) == "table") and (((_73_)[2])[1] == nil))) then local _ = (_73_)[1]

 return nil, fmt("unable to collect from %s.%d because it is empty", slot, col_n) else local function _74_() local card = ((_73_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_73_)[2]))} return (card_n == #col) end if (((_G.type(_73_) == "table") and ((_73_)[1] == "tableau") and ((_G.type((_73_)[2]) == "table") and (nil ~= ((_73_)[2])[1]))) and _74_()) then local card = ((_73_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_73_)[2]))} return true else local function _75_() local card = ((_73_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_73_)[2]))} return (function(_76_,_77_,_78_) return (_76_ < _77_) and (_77_ < _78_) end)(0,card_n,#col) end if (((_G.type(_73_) == "table") and ((_73_)[1] == "tableau") and ((_G.type((_73_)[2]) == "table") and (nil ~= ((_73_)[2])[1]))) and _75_()) then local card = ((_73_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_73_)[2]))}




 local rem, hand = enum.split(col, card_n)
 if valid_sequence_3f(hand) then return true else

 return nil, "may only collect alternating suit descending sequences" end else local function _80_() local card = ((_73_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_73_)[2]))} return (#col < card_n) end if (((_G.type(_73_) == "table") and ((_73_)[1] == "tableau") and ((_G.type((_73_)[2]) == "table") and (nil ~= ((_73_)[2])[1]))) and _80_()) then local card = ((_73_)[2])[1] local _ = {select(2, (table.unpack or _G.unpack)((_73_)[2]))}


 return nil, fmt("unable to collect from %s.%d.%d because it over runs length", slot, col_n, card_n) else local function _81_() local card = ((_73_)[2])[1] return (card_n == 1) end if (((_G.type(_73_) == "table") and ((_73_)[1] == "cell") and ((_G.type((_73_)[2]) == "table") and (nil ~= ((_73_)[2])[1]))) and _81_()) then local card = ((_73_)[2])[1]


 local cell = state[slot][col_n]
 local _82_ = cell if ((_G.type(_82_) == "table") and (nil ~= (_82_)[1]) and ((_82_)[2] == nil)) then local any = (_82_)[1] return true elseif ((_G.type(_82_) == "table") and (nil ~= (_82_)[1]) and (nil ~= (_82_)[2]) and (nil ~= (_82_)[3]) and (nil ~= (_82_)[4]) and ((_82_)[5] == nil)) then local a = (_82_)[1] local b = (_82_)[2] local c = (_82_)[3] local d = (_82_)[4]

 return nil, "cant collect from locked cells" elseif true then local _ = _82_
 return error("internal logic error") else return nil end else local function _84_() local card = ((_73_)[2])[1] return (1 < card_n) end if (((_G.type(_73_) == "table") and ((_73_)[1] == "cell") and ((_G.type((_73_)[2]) == "table") and (nil ~= ((_73_)[2])[1]))) and _84_()) then local card = ((_73_)[2])[1]
 return nil, "cant collect over the first card in a cell" elseif true then local _ = _73_

 return error(fmt("unmatched collect request: %s.%d %d", slot, col_n, card_n)) else return nil end end end end end end end return unit_66_(_72_()) end return bind_65_(unit_66_(_68_()), _71_) end

 local function place_on_foundation_ok_3f(foundation, card_n, cards, flower_foundation_3f)
 local _let_86_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_86_["bind"] local unit_2_auto = _let_86_["unit"] local bind_87_ = bind_1_auto local unit_88_ = unit_2_auto local function _89_(_) local function _92_(_90_) local _arg_91_ = _90_
 local card = _arg_91_[1] local function _93_(foundation_card) local function _94_(_0)



 local function _95_() if flower_foundation_3f then
 return (flower_card_3f(card) or r_2ferr("may only place flower card on flower foundation")) else
 return (suited_card_3f(card) or r_2ferr("may only place suited cards on foundation")) end end local function _96_(_1) local function _97_()
 if flower_foundation_3f then
 local _98_ = {foundation_card, card} if ((_G.type(_98_) == "table") and ((_98_)[1] == nil) and ((_G.type((_98_)[2]) == "table") and (((_98_)[2])[1] == "FLOWER") and true)) then local _2 = ((_98_)[2])[2] return true elseif ((_G.type(_98_) == "table") and (nil ~= (_98_)[1]) and ((_G.type((_98_)[2]) == "table") and (((_98_)[2])[1] == "FLOWER") and true)) then local any = (_98_)[1] local _2 = ((_98_)[2])[2]



 return error("attempted to place flower on flower") else return nil end else
 local _100_ = {foundation_card, card} local function _101_() local _2 = ((_100_)[2])[1] local v = ((_100_)[2])[2] return not (1 == v) end if (((_G.type(_100_) == "table") and ((_100_)[1] == nil) and ((_G.type((_100_)[2]) == "table") and true and (nil ~= ((_100_)[2])[2]))) and _101_()) then local _2 = ((_100_)[2])[1] local v = ((_100_)[2])[2]

 return nil, "foundation must start with value 1 card" else local function _102_() local _2 = ((_100_)[2])[1] return true end if (((_G.type(_100_) == "table") and ((_100_)[1] == nil) and ((_G.type((_100_)[2]) == "table") and true and (((_100_)[2])[2] == 1))) and _102_()) then local _2 = ((_100_)[2])[1] return true else local function _103_() local suit = ((_100_)[1])[1] local last_val = ((_100_)[1])[2] local next_val = ((_100_)[2])[2] return (next_val == (last_val + 1)) end if (((_G.type(_100_) == "table") and ((_G.type((_100_)[1]) == "table") and (nil ~= ((_100_)[1])[1]) and (nil ~= ((_100_)[1])[2])) and ((_G.type((_100_)[2]) == "table") and (((_100_)[1])[1] == ((_100_)[2])[1]) and (nil ~= ((_100_)[2])[2]))) and _103_()) then local suit = ((_100_)[1])[1] local last_val = ((_100_)[1])[2] local next_val = ((_100_)[2])[2] return true elseif ((_G.type(_100_) == "table") and true and true) then local _2 = (_100_)[1] local _3 = (_100_)[2]




 return nil, "must place same suit and +1 value on existing foundation" else return nil end end end end end return unit_88_(_97_()) end return unit_88_(bind_87_(unit_88_(_95_()), _96_)) end return unit_88_(bind_87_(unit_88_(((card_n == (1 + #foundation)) or r_2ferr("must place on top of last card in foundation"))), _94_)) end return unit_88_(bind_87_(unit_88_(foundation[#foundation]), _93_)) end return unit_88_(bind_87_(unit_88_(cards), _92_)) end return bind_87_(unit_88_(((1 == #cards) or r_2ferr("may only place one card at a time on a foundation"))), _89_) end

 local function place_on_cell_ok_3f(cell, card_n, cards)



 local _let_106_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_106_["bind"] local unit_2_auto = _let_106_["unit"] local bind_107_ = bind_1_auto local unit_108_ = unit_2_auto local function _109_(_) local function _110_()
 local _111_ = {cell, cards} if ((_G.type(_111_) == "table") and ((_G.type((_111_)[1]) == "table") and (nil ~= ((_111_)[1])[1])) and true) then local not_nil = ((_111_)[1])[1] local _0 = (_111_)[2]

 return nil, "can only place into an empty cell" else local function _112_() local d = (((_111_)[2])[1])[1] local _0 = (((_111_)[2])[1])[2] local _1 = (((_111_)[2])[2])[2] local _2 = (((_111_)[2])[3])[2] local _3 = (((_111_)[2])[4])[2] return string.match(d, "^DRAGON-") end if (((_G.type(_111_) == "table") and ((_G.type((_111_)[1]) == "table") and (((_111_)[1])[1] == nil)) and ((_G.type((_111_)[2]) == "table") and ((_G.type(((_111_)[2])[1]) == "table") and (nil ~= (((_111_)[2])[1])[1]) and true) and ((_G.type(((_111_)[2])[2]) == "table") and ((((_111_)[2])[1])[1] == (((_111_)[2])[2])[1]) and true) and ((_G.type(((_111_)[2])[3]) == "table") and ((((_111_)[2])[1])[1] == (((_111_)[2])[3])[1]) and true) and ((_G.type(((_111_)[2])[4]) == "table") and ((((_111_)[2])[1])[1] == (((_111_)[2])[4])[1]) and true))) and _112_()) then local d = (((_111_)[2])[1])[1] local _0 = (((_111_)[2])[1])[2] local _1 = (((_111_)[2])[2])[2] local _2 = (((_111_)[2])[3])[2] local _3 = (((_111_)[2])[4])[2] return true else local function _113_() local card = ((_111_)[2])[1] return true end if (((_G.type(_111_) == "table") and ((_G.type((_111_)[1]) == "table") and (((_111_)[1])[1] == nil)) and ((_G.type((_111_)[2]) == "table") and (nil ~= ((_111_)[2])[1]) and (((_111_)[2])[2] == nil))) and _113_()) then local card = ((_111_)[2])[1] return true else local function _114_() local _0 = (_111_)[1] local card = ((_111_)[2])[1] local rest = {select(2, (table.unpack or _G.unpack)((_111_)[2]))} return (0 < #rest) end if (((_G.type(_111_) == "table") and true and ((_G.type((_111_)[2]) == "table") and (nil ~= ((_111_)[2])[1]))) and _114_()) then local _0 = (_111_)[1] local card = ((_111_)[2])[1] local rest = {select(2, (table.unpack or _G.unpack)((_111_)[2]))}






 return nil, "can only place one card on a cell" else return nil end end end end end return unit_108_(_110_()) end return bind_107_(unit_108_(((1 == card_n) or nil or "must place on card-n 1 for cells")), _109_) end

 local function place_on_tableau_ok_3f(column, card_n, cards)

 local _let_116_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_116_["bind"] local unit_2_auto = _let_116_["unit"] local bind_117_ = bind_1_auto local unit_118_ = unit_2_auto local function _119_(col_len)

 local function _120_() if not (card_n == (1 + col_len)) then
 return nil, "must place at end of column" else return nil end end local function _121_(_) local function _122_(t_card) local function _123_(new_seq) local function _124_()




 local _125_ = {t_card, valid_sequence_3f(new_seq)} if ((_G.type(_125_) == "table") and ((_125_)[1] == nil) and true) then local _0 = (_125_)[2] return true elseif ((_G.type(_125_) == "table") and true and ((_125_)[2] == true)) then local _0 = (_125_)[1] return true elseif ((_G.type(_125_) == "table") and true and ((_125_)[2] == false)) then local _0 = (_125_)[1]






 return nil, "must create alternating suit descending sequence" else return nil end end return unit_118_(_124_()) end return unit_118_(bind_117_(unit_118_(enum["append$"]({t_card}, unpack(cards))), _123_)) end return unit_118_(bind_117_(unit_118_(column[col_len]), _122_)) end return unit_118_(bind_117_(unit_118_(_120_()), _121_)) end return bind_117_(unit_118_(#column), _119_) end

 M["can-place-ok?"] = function(state, _127_, cards) local _arg_128_ = _127_ local slot = _arg_128_[1] local col_n = _arg_128_[2] local card_n = _arg_128_[3]
 local _129_ = {slot, state[slot][col_n]} if ((_G.type(_129_) == "table") and ((_129_)[1] == "foundation") and (nil ~= (_129_)[2])) then local foundation = (_129_)[2]
 return place_on_foundation_ok_3f(foundation, card_n, cards, (col_n == 4)) elseif ((_G.type(_129_) == "table") and ((_129_)[1] == "cell") and (nil ~= (_129_)[2])) then local cell = (_129_)[2]
 return place_on_cell_ok_3f(cell, card_n, cards) elseif ((_G.type(_129_) == "table") and ((_129_)[1] == "tableau") and (nil ~= (_129_)[2])) then local col = (_129_)[2]
 return place_on_tableau_ok_3f(col, card_n, cards) elseif true then local _ = _129_
 return error(fmt("unmatched can-place-on? %s %s", inspect(slot, col_n))) else return nil end end












 M["move-cards-ok?"] = function(state, from, to)



 assert(state, "requires state argument")
 assert(from, "requires from argument")
 assert(to, "requires to argument")

 local function location_arg_ok_3f(name, _131_) local _arg_132_ = _131_ local slot = _arg_132_[1] local col = _arg_132_[2] local card = _arg_132_[3]

 local _let_133_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_133_["bind"] local unit_2_auto = _let_133_["unit"] local bind_134_ = bind_1_auto local unit_135_ = unit_2_auto local function _136_(slot0) local function _137_(col0) local function _138_(card0) local function _139_() return true end return unit_135_(_139_()) end return unit_135_(bind_134_(unit_135_((card or R.err((name .. " location was missing card")))), _138_)) end return unit_135_(bind_134_(unit_135_((col or R.err((name .. " location was missing col")))), _137_)) end return bind_134_(unit_135_((slot or R.err((name .. " location was mising slot name")))), _136_) end




 local function location_resolves_ok_3f(name, _140_, ignore_card_3f) local _arg_141_ = _140_ local slot = _arg_141_[1] local col = _arg_141_[2] local card = _arg_141_[3]


 local _let_142_ = require("shenzhen-solitaire.lib.donut.result") local ok_3f_5_auto = _let_142_["ok?"] local unwrap_4_auto = _let_142_["unwrap"] local cap_6_auto local function _143_(...) return select("#", ...), {...} end cap_6_auto = _143_ local result_7_auto do local _let_144_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_144_["bind"] local unit_2_auto = _let_144_["unit"] local bind_145_ = bind_1_auto local unit_146_ = unit_2_auto local function _147_(real_slot) local function _148_(real_col) local function _149_(real_card) local function _150_() return true end return unit_146_(_150_()) end return unit_146_(bind_145_(unit_146_(((ignore_card_3f or real_col[card]) or R.err((name .. " " .. slot .. "." .. col .. " card was invalid")))), _149_)) end return unit_146_(bind_145_(unit_146_((real_slot[col] or R.err((name .. " " .. slot .. " col was invalid")))), _148_)) end result_7_auto = bind_145_(unit_146_((state[slot] or R.err((name .. " slot was invalid")))), _147_) end if ok_3f_5_auto(result_7_auto) then return unwrap_4_auto(result_7_auto) else return nil, unwrap_4_auto(result_7_auto) end end
















 local _let_152_ = require("shenzhen-solitaire.lib.donut.result") local bind_1_auto = _let_152_["bind"] local unit_2_auto = _let_152_["unit"] local bind_153_ = bind_1_auto local unit_154_ = unit_2_auto local function _155_(_) local function _156_(_0) local function _157_(_1) local function _158_(_2) local function _161_(_159_) local _arg_160_ = _159_









 local from_slot = _arg_160_[1] local from_col_n = _arg_160_[2] local from_card_n = _arg_160_[3] local function _164_(_162_) local _arg_163_ = _162_
 local to_slot = _arg_163_[1] local to_col_n = _arg_163_[2] local to_card_n = _arg_163_[3] local function _165_(can_collect_3f) local function _166_(rem, hand) local function _167_(can_place_3f) local function _168_()









 if (can_collect_3f and can_place_3f) then
 return R.ok({from = from, to = to}) else
 return R.err("unable proceed, this was unexpected, please log an issue") end end return unit_154_(_168_()) end return unit_154_(bind_153_(unit_154_(M["can-place-ok?"](state, to, hand)), _167_)) end return unit_154_(bind_153_(unit_154_(enum.split(state[from_slot][from_col_n], from_card_n)), _166_)) end return unit_154_(bind_153_(unit_154_(M["collect-from-ok?"](state, from)), _165_)) end return unit_154_(bind_153_(unit_154_(to), _164_)) end return unit_154_(bind_153_(unit_154_(from), _161_)) end return unit_154_(bind_153_(unit_154_(location_resolves_ok_3f("to", to, true)), _158_)) end return unit_154_(bind_153_(unit_154_(location_resolves_ok_3f("from", from)), _157_)) end return unit_154_(bind_153_(unit_154_(location_arg_ok_3f("to", to)), _156_)) end return bind_153_(unit_154_(location_arg_ok_3f("from", from)), _155_) end

 M["start-new-game"] = function(_3fseed)



 local game_id = math.random(1, 9000000000)
 local seed = (_3fseed or math.random(1, 9000000000))
 return S.apply(S.apply(S.apply(S["empty-state"](), {"started-new-game", {id = game_id, seed = seed}}), {"shuffled-deck"}), {"dealt-cards"}) end




 M["move-cards"] = function(state, from, to)










 local function _170_(_241) return S.apply(state, {"moved-cards", _241}) end return R["unwrap!"](R.map(M["move-cards-ok?"](state, from, to), _170_)) end


 M["lock-dragons-ok?"] = function(state, dragon_name)
 local dragon_locations
 local function _171_(_241, _242) local _172_ = location__3ecard(state, _242) if ((_G.type(_172_) == "table") and ((_172_)[1] == dragon_name) and true) then local _ = (_172_)[2] return true else return nil end end dragon_locations = enum.filter(generate_pickup_locations(state, {tableau = {1, 8}, cell = {1, 3}}), _171_) local cell_location


 local function _174_(_241, _242) local _175_ = location__3ecard(state, _242) if ((_G.type(_175_) == "table") and ((_175_)[1] == dragon_name) and true) then local _ = (_175_)[2] return true elseif ((_G.type(_175_) == "table") and (nil ~= (_175_)[1]) and true) then local any = (_175_)[1] local _ = (_175_)[2] return false elseif (_175_ == nil) then return true else return nil end end cell_location = enum.hd(enum.filter(generate_locations(state, {cell = {1, 3}}), _174_))





 local n_locs = #dragon_locations
 local _177_ = {(4 == n_locs), not nil_3f(cell_location)} if ((_G.type(_177_) == "table") and ((_177_)[1] == true) and ((_177_)[2] == true)) then
 return R.ok({name = dragon_name, from = dragon_locations, to = cell_location}) elseif ((_G.type(_177_) == "table") and ((_177_)[1] == false) and true) then local _ = (_177_)[2]
 return R.err(fmt("need 4 dragons to lock, found %d %s", n_locs, dragon_name)) elseif ((_G.type(_177_) == "table") and ((_177_)[1] == true) and ((_177_)[2] == false)) then
 return R.err(fmt("no free cell")) else return nil end end

 M["lock-dragons"] = function(state, dragon_name)

 local function _179_(_241) return S.apply(state, {"locked-dragons", _241}) end return R["unwrap!"](R.map(M["lock-dragons-ok?"](state, dragon_name), _179_)) end


 M["auto-move-ok?"] = function(state)

 local foundations = generate_putdown_locations(state, {foundation = {1, 4}}) local all_cards


 local function _180_() return iter_2frange(1, 8) end
 local function _181_(col_n)
 local function _182_() return iter_2frange(1, 40) end
 local function _183_(_241) return {"tableau", col_n, _241} end return enum.map(_182_, _183_) end
 local function _184_() return iter_2frange(1, 3) end local function _185_(_241) return {"cell", 1, _241} end
 local function _186_(_241, _242) return location__3ecard(state, _242) end all_cards = enum.map(enum["concat$"](enum["flat-map"](_180_, _181_), enum.map(_184_, _185_)), _186_) local no_higher_card_3f
 local function _189_(_187_) local _arg_188_ = _187_ local _ = _arg_188_[1] local min_value = _arg_188_[2]








 local function _190_(_241) return (0 == #_241) end local function _191_(_241, _242) local _192_ = _242 if ((_G.type(_192_) == "table") and ((_192_)[1] == "FLOWER") and true) then local _0 = (_192_)[2] return false elseif ((_G.type(_192_) == "table") and ((_192_)[1] == "DRAGON-GREEN") and true) then local _0 = (_192_)[2] return false elseif ((_G.type(_192_) == "table") and ((_192_)[1] == "DRAGON-RED") and true) then local _0 = (_192_)[2] return false elseif ((_G.type(_192_) == "table") and ((_192_)[1] == "DRAGON-WHITE") and true) then local _0 = (_192_)[2] return false elseif ((_G.type(_192_) == "table") and true and (nil ~= (_192_)[2])) then local _0 = (_192_)[1] local test_value = (_192_)[2] return (test_value < min_value) else return nil end end return _190_(enum.filter(all_cards, _191_)) end no_higher_card_3f = _189_ local posibilities

 local function _194_(_241, _242) return {_242, location__3ecard(state, _242)} end




 local function _195_(_241, _242) local _196_ = {_241, _242} if ((_G.type(_196_) == "table") and ((_G.type((_196_)[1]) == "table") and true and ((_G.type(((_196_)[1])[2]) == "table") and (nil ~= (((_196_)[1])[2])[1]) and (nil ~= (((_196_)[1])[2])[2]))) and ((_G.type((_196_)[2]) == "table") and true and ((_G.type(((_196_)[2])[2]) == "table") and (nil ~= (((_196_)[2])[2])[1]) and (nil ~= (((_196_)[2])[2])[2])))) then local _ = ((_196_)[1])[1] local t_a = (((_196_)[1])[2])[1] local v_a = (((_196_)[1])[2])[2] local _0 = ((_196_)[2])[1] local t_b = (((_196_)[2])[2])[1] local v_b = (((_196_)[2])[2])[2]
 return ((t_a < t_b) and (v_a < v_b)) else return nil end end

 local function _198_(_241, _242) local _let_199_ = _242 local _ = _let_199_[1] local card = _let_199_[2]
 return no_higher_card_3f(card) end
 local function _202_(_, _200_) local _arg_201_ = _200_ local location = _arg_201_[1] local card = _arg_201_[2]
 local function _203_(_241, _242) return {from = location, to = _242, card = card} end return enum.map(foundations, _203_) end posibilities = enum["flat-map"](enum.filter(enum["sort$"](enum.map(generate_pickup_locations(state, {tableau = {1, 8}, cell = {1, 3}}), _194_), _195_), _198_), _202_) local pick


 do local i, found_3f = nil, false for index, test in ipairs(posibilities) do if found_3f then break end
 if R["ok?"](M["move-cards-ok?"](state, test.from, test.to)) then
 i, found_3f = index, true else
 i, found_3f = nil, false end end pick = i, found_3f end
 if pick then
 local _let_205_ = posibilities[pick] local from = _let_205_["from"] local to = _let_205_["to"]
 return R.ok({from = from, to = to}) else
 return R.err("no auto-move found") end end

 M["win-game-ok?"] = function(state)
 local tableau_cards local function _207_() return iter_2frange(1, 8) end
 local function _208_(col_n) local function _209_() return iter_2frange(1, 40) end
 local function _210_(_241) return {"tableau", col_n, _241} end return enum.map(_209_, _210_) end
 local function _211_(_241, _242) return location__3ecard(state, _242) end tableau_cards = enum.map(enum["flat-map"](_207_, _208_), _211_)
 if (0 == #tableau_cards) then

 return R.ok(true) else
 return R.err(false) end end

 M["S"] = S
 return M