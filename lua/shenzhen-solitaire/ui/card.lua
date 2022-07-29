

 local function _2_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.iter") local keys_45_auto = {"range"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.iter\"")) end return mod_44_auto end local _local_1_ = _2_(...) local iter_2frange = _local_1_["range"] local function _4_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.enum") local keys_45_auto = {"map"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.enum\"")) end return mod_44_auto end local _local_3_ = _4_(...) local enum_2fmap = _local_3_["map"] do local _ = {nil, nil} end


 local M = {}

 M.new = function(card, data)










 local _let_5_ = data.size local width = _let_5_["width"] local height = _let_5_["height"]
 local _let_6_ = data local borders = _let_6_["borders"] local rc__3esym
 local function _7_(_241, _242) local _8_ = {_241, _242} if ((_G.type(_8_) == "table") and ((_8_)[1] == 1) and ((_8_)[2] == 1)) then
 return borders.nw elseif ((_G.type(_8_) == "table") and ((_8_)[1] == height) and ((_8_)[2] == 1)) then
 return borders.sw elseif ((_G.type(_8_) == "table") and ((_8_)[1] == 1) and ((_8_)[2] == width)) then
 return borders.ne elseif ((_G.type(_8_) == "table") and ((_8_)[1] == height) and ((_8_)[2] == width)) then
 return borders.se elseif ((_G.type(_8_) == "table") and ((_8_)[1] == 1) and true) then local _ = (_8_)[2]
 return borders.n elseif ((_G.type(_8_) == "table") and ((_8_)[1] == height) and true) then local _ = (_8_)[2]
 return borders.s elseif ((_G.type(_8_) == "table") and true and ((_8_)[2] == 1)) then local _ = (_8_)[1]
 return borders.w elseif ((_G.type(_8_) == "table") and true and ((_8_)[2] == width)) then local _ = (_8_)[1]
 return borders.e elseif true then local _ = _8_ return " " else return nil end end rc__3esym = _7_ local bitmap

 local function _10_() return iter_2frange(1, height) end
 local function _11_(row) local function _12_() return iter_2frange(1, width) end
 local function _13_(col) return rc__3esym(row, col) end return enum_2fmap(_12_, _13_) end bitmap = enum_2fmap(_10_, _11_) local symbol, val = nil, nil
 do local _14_ = card if ((_G.type(_14_) == "table") and ((_14_)[1] == "COIN") and (nil ~= (_14_)[2])) then local v = (_14_)[2]
 symbol, val = nil, v elseif ((_G.type(_14_) == "table") and ((_14_)[1] == "STRING") and (nil ~= (_14_)[2])) then local v = (_14_)[2]
 symbol, val = nil, v elseif ((_G.type(_14_) == "table") and ((_14_)[1] == "MYRIAD") and (nil ~= (_14_)[2])) then local v = (_14_)[2]
 symbol, val = nil, v elseif ((_G.type(_14_) == "table") and ((_14_)[1] == "DRAGON-GREEN")) then
 symbol, val = "\195\145", nil elseif ((_G.type(_14_) == "table") and ((_14_)[1] == "DRAGON-WHITE")) then
 symbol, val = "\195\149", nil elseif ((_G.type(_14_) == "table") and ((_14_)[1] == "DRAGON-RED")) then
 symbol, val = "\197\160", nil elseif ((_G.type(_14_) == "table") and ((_14_)[1] == "FLOWER")) then
 symbol, val = "\198\146", nil elseif true then local _ = _14_
 symbol, val = "_", "_" else symbol, val = nil end end
 bitmap[2][2] = (symbol or tostring(val) or "x")
 return {size = data.size, pos = data.pos, location = data.location, bitmap = bitmap, highlight = data.highlight} end













 return M