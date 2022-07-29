

 local function _2_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.iter") local keys_45_auto = {"range"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.iter\"")) end return mod_44_auto end local _local_1_ = _2_(...) local iter_2frange = _local_1_["range"] local function _4_(...) local mod_44_auto = require("shenzhen-solitaire.lib.donut.enum") local keys_45_auto = {"map"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"shenzhen-solitaire.lib.donut.enum\"")) end return mod_44_auto end local _local_3_ = _4_(...) local enum_2fmap = _local_3_["map"] do local _ = {nil, nil} end


 local M = {}

 M.new = function(config)


 local config0 = {size = {width = 80, height = 40}}
 local _let_5_ = config0.size local width = _let_5_["width"] local height = _let_5_["height"] local map_positions
 local function _6_(val)
 local function _7_() return iter_2frange(1, height) end
 local function _8_() local function _9_() return iter_2frange(1, width) end
 local function _10_() return val end return enum_2fmap(_9_, _10_) end return enum_2fmap(_7_, _8_) end map_positions = _6_
 local draw = map_positions(" ")
 local color = map_positions("")
 local hit = map_positions({})
 return {size = {width = width, height = height}, draw = draw, hit = hit, color = color} end




 M.write = function(fbo, buffer_name, pos, size, f)



 do local _let_11_ = pos local row = _let_11_["row"] local col = _let_11_["col"]
 local _let_12_ = size local width = _let_12_["width"] local height = _let_12_["height"]
 for r = 1, height do
 for c = 1, width do
 fbo[buffer_name][((r - 1) + row)][((c - 1) + col)] = f(r, c) end end end
 return fbo end

 return M