


 local rel_require local function _1_(ddd_2_auto, rawrequire_3_auto) local full_mod_path_4_auto = (ddd_2_auto or "") local prefix_5_auto = (string.match(full_mod_path_4_auto, "(.+)%.inspect$") or "") local function _2_(_241) return rawrequire_3_auto((prefix_5_auto .. "." .. _241)) end return _2_ end rel_require = _1_(..., require)

 local M = {}

 M.inspect = function(...)

 local function _4_(...) local mod_44_auto = rel_require("enum") local keys_45_auto = {"pack", "unpack"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"enum\"")) end return mod_44_auto end local _local_3_ = _4_(...) local e_2fpack = _local_3_["pack"] local e_2funpack = _local_3_["unpack"] do local _ = {nil} end
 local _let_5_ = require("fennel") local view = _let_5_["view"]
 local args = e_2fpack(...)
 local viewed = {}
 for n = 1, args.n do table.insert(viewed, view(args[n])) end
 return e_2funpack(viewed) end

 M["inspect!"] = function(...)
 print(M.inspect(...))
 return ... end

 return M