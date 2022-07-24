






 local enum = require("shenzhen-solitaire.lib.donut.enum") local function _2_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.iter") local keys_45_auto = {"range"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.iter\"")) end return mod_44_auto end local _local_1_ = _2_(...) local iter_2frange = _local_1_["range"] do local _ = {nil, nil} end


 local M = {}


 M.new = function()

 local suits
 local function _3_(_, s) local function _4_() return iter_2frange(1, 9) end local function _5_(_241) return {s, _241} end return enum.map(_4_, _5_) end suits = enum["flat-map"]({"STRING", "COIN", "MYRIAD"}, _3_)
 local flower = {{"FLOWER", 0}} local specials

 local function _6_(_, s) local function _7_() return iter_2frange(1, 4) end local function _8_() return {s, 0} end return enum.map(_7_, _8_) end specials = enum["flat-map"]({"DRAGON-RED", "DRAGON-GREEN", "DRAGON-WHITE"}, _6_)
 return enum["concat$"](suits, specials, flower) end

 M["special-card?"] = function(card)

 local _9_ = card if ((_G.type(_9_) == "table") and ((_9_)[1] == "DRAGON-RED") and true) then local _ = (_9_)[2] return true elseif ((_G.type(_9_) == "table") and ((_9_)[1] == "DRAGON-GREEN") and true) then local _ = (_9_)[2] return true elseif ((_G.type(_9_) == "table") and ((_9_)[1] == "DRAGON-WHITE") and true) then local _ = (_9_)[2] return true elseif ((_G.type(_9_) == "table") and ((_9_)[1] == "FLOWER") and true) then local _ = (_9_)[2] return true elseif true then local _ = _9_ return false else return nil end end






 M["suited-card?"] = function(card)

 local _11_ = card if ((_G.type(_11_) == "table") and ((_11_)[1] == "COIN") and true) then local _ = (_11_)[2] return true elseif ((_G.type(_11_) == "table") and ((_11_)[1] == "STRING") and true) then local _ = (_11_)[2] return true elseif ((_G.type(_11_) == "table") and ((_11_)[1] == "MYRIAD") and true) then local _ = (_11_)[2] return true elseif true then local _ = _11_ return false else return nil end end





 M["dragon-card?"] = function(card)

 local _13_ = card if ((_G.type(_13_) == "table") and ((_13_)[1] == "DRAGON-RED") and true) then local _ = (_13_)[2] return true elseif ((_G.type(_13_) == "table") and ((_13_)[1] == "DRAGON-GREEN") and true) then local _ = (_13_)[2] return true elseif ((_G.type(_13_) == "table") and ((_13_)[1] == "DRAGON-WHITE") and true) then local _ = (_13_)[2] return true elseif true then local _ = _13_ return false else return nil end end





 M["flower-card?"] = function(card)

 local _15_ = card if ((_G.type(_15_) == "table") and ((_15_)[1] == "FLOWER") and true) then local _ = (_15_)[2] return true elseif true then local _ = _15_ return false else return nil end end



 M["coin-card?"] = function(card)

 local _17_ = card if ((_G.type(_17_) == "table") and ((_17_)[1] == "COIN") and true) then local _ = (_17_)[2] return true elseif true then local _ = _17_ return false else return nil end end



 M["string-card?"] = function(card)

 local _19_ = card if ((_G.type(_19_) == "table") and ((_19_)[1] == "STRING") and true) then local _ = (_19_)[2] return true elseif true then local _ = _19_ return false else return nil end end



 M["myriad-card?"] = function(card)

 local _21_ = card if ((_G.type(_21_) == "table") and ((_21_)[1] == "MYRIAD") and true) then local _ = (_21_)[2] return true elseif true then local _ = _21_ return false else return nil end end



 M["card-type"] = function(card)
 local _23_ = card if ((_G.type(_23_) == "table") and (nil ~= (_23_)[1]) and true) then local t = (_23_)[1] local _ = (_23_)[2]
 return t elseif true then local _ = _23_
 return error("not-a-card") else return nil end end

 M["card-value"] = function(card)
 local _25_ = card if ((_G.type(_25_) == "table") and true and (nil ~= (_25_)[2])) then local _ = (_25_)[1] local v = (_25_)[2]
 return v elseif true then local _ = _25_
 return error("not-a-card") else return nil end end

 M["valid-sequence?"] = function(stack)


 local function alternating_suit_and_dec_value_3f(_27_) local _arg_28_ = _27_ local head = _arg_28_[1] local tail = (function (t, k) local mt = getmetatable(t) if "table" == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) else return {(table.unpack or unpack)(t, k)} end end)(_arg_28_, 2)


 local function _29_(_241, _242, _243) local _30_ = {_241, _243} local function _31_() local ls = ((_30_)[1])[1] local lv = ((_30_)[1])[2] local s = ((_30_)[2])[1] local v = ((_30_)[2])[2] return (not (ls == s) and (v == (lv - 1))) end if (((_G.type(_30_) == "table") and ((_G.type((_30_)[1]) == "table") and (nil ~= ((_30_)[1])[1]) and (nil ~= ((_30_)[1])[2])) and ((_G.type((_30_)[2]) == "table") and (nil ~= ((_30_)[2])[1]) and (nil ~= ((_30_)[2])[2]))) and _31_()) then local ls = ((_30_)[1])[1] local lv = ((_30_)[1])[2] local s = ((_30_)[2])[1] local v = ((_30_)[2])[2]
 return _243 else return nil end end return not (nil == enum.reduce(tail, head, _29_)) end
 local function contains_no_specials_3f(run)
 local function _33_(_241, _242) return M["special-card?"](_242) end return enum["empty?"](enum.filter(run, _33_)) end

 return (alternating_suit_and_dec_value_3f(stack) and contains_no_specials_3f(stack)) end


 return M