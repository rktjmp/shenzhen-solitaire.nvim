






 local rel_require local function _1_(ddd_2_auto, rawrequire_3_auto) local full_mod_path_4_auto = (ddd_2_auto or "") local prefix_5_auto = (string.match(full_mod_path_4_auto, "(.+)%.result$") or "") local function _2_(_241) return rawrequire_3_auto((prefix_5_auto .. "." .. _241)) end return _2_ end rel_require = _1_(..., require)
 local function _4_(...) local mod_36_auto = rel_require("type") local keys_37_auto = {"type-of"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"type\"")) end return mod_36_auto end local _local_3_ = _4_(...) local type_of = _local_3_["type-of"] local enum = rel_require("enum") do local _ = {nil, nil} end
















 local M do local _local_5_ = require("shenzhen-solitaire.lib.donut..type") local set_type = _local_5_["set-type"] local type_is_any_3f = _local_5_["type-is-any?"] local type_is_3f = _local_5_["type-is?"] local type_of0 = _local_5_["type-of"] local _local_6_ = require("shenzhen-solitaire.lib.donut..enum") local unpack = _local_6_["unpack"] local __protect_call = {"password"} local M0 = {} local __M = {} M0["result?"] = function(v) return type_is_any_3f(v, {"donut.result.ERR_TYPE", "donut.result.OK_TYPE"}) end M0["err?"] = function(v) return type_is_3f(v, "donut.result.ERR_TYPE") end M0["ok?"] = function(v) return type_is_3f(v, "donut.result.OK_TYPE") end __M["enforce-type!"] = function(v) if M0["result?"](v) then return v else return error(string.format(("Expected " .. "result" .. " but was given %s<%s>"), type_of0(v), tostring(v))) end end __M["gen-type"] = function(type_name, ...) local val_24_auto = {...} local n_26_auto = select("#", ...) local tos_25_auto local function _8_() return (type_name .. "<" .. table.concat(val_24_auto, ",") .. ">") end tos_25_auto = _8_ local type_t_28_auto do local _9_ = type_name if (_9_ == "err") then type_t_28_auto = "donut.result.ERR_TYPE" elseif (_9_ == "ok") then type_t_28_auto = "donut.result.OK_TYPE" elseif true then local __27_auto = _9_ type_t_28_auto = error(("result" .. " construction: invalid type name " .. type_name)) else type_t_28_auto = nil end end local mt_29_auto local function _11_(_241, _242) local _12_ = _242 if (_12_ == __protect_call) then return unpack(val_24_auto, 1, n_26_auto) elseif true then local __27_auto = _12_ return error("nedry.gif") else return nil end end mt_29_auto = {__call = _11_, __tostring = tos_25_auto} local _14_ = {type_name, unpack(val_24_auto, 1, n_26_auto)} _14_["n"] = n_26_auto setmetatable(_14_, mt_29_auto) set_type(_14_, type_t_28_auto) return _14_ end M0.unit = function(...) local argc = select("#", ...) local _15_ = ... local function _16_(...) local either_1_auto = _15_ return ((1 == argc) and M0["result?"](either_1_auto)) end if ((nil ~= _15_) and _16_(...)) then local either_1_auto = _15_ return either_1_auto else local function _17_(...) return (2 <= argc) end if ((_15_ == nil) and _17_(...)) then return M0.err(select(2, ...)) elseif true then local _ = _15_ return M0.ok(...) else return nil end end end M0["result"] = M0.unit M0.unwrap = function(result) if __M["enforce-type!"](result) then return result(__protect_call) else return nil end end M0.bind = function(x, f) if M0["ok?"](x) then return __M["enforce-type!"](f(M0.unwrap(x))) else return x end end M0.err = function(...) local argc = select("#", ...) local _21_ = ... if true then local _ = _21_ return __M["gen-type"]("err", ...) elseif true then local _ = _21_ return error(string.format("attempted to create %s but value matched %s", "err", "ok")) elseif true then local __12_auto = _21_ return error(string.format("attempted to create %s but did not match spec", "err")) else return nil end end M0.ok = function(...) local argc = select("#", ...) local _23_ = ... if true then local _ = _23_ return __M["gen-type"]("ok", ...) elseif true then local _ = _23_ return error(string.format("attempted to create %s but value matched %s", "ok", "err")) elseif true then local __23_auto = _23_ return error(string.format("attempted to create %s but did not match spec", "ok")) else return nil end end M0.map = function(result, ok_f, _3ferr_f) if M0["ok?"](result) then return M0["map-ok"](result, ok_f) else if _3ferr_f then return M0["map-err"](result, _3ferr_f) else return result end end end M0["map-err"] = function(result, f) if M0["err?"](result) then return M0.unit(f(M0.unwrap(result))) else return result end end M0["map-ok"] = function(result, f) if M0["ok?"](result) then return M0.unit(f(M0.unwrap(result))) else return result end end M = M0 end











 M.join = function(r1, r2)
 assert((M["result?"](r1) and M["result?"](r2)), ("result#join argument was not a result type" .. type_of(r1) .. type_of(r2)))

 local function package(how, a, b)

 local a0 = enum.pack(M.unwrap(a))
 local b0 = enum.pack(M.unwrap(b))


 local function _29_(_241) return how(enum.unpack(_241, 1, (a0.n + b0.n))) end return _29_(enum["append$"]({enum.unpack(a0, 1, a0.n)}, enum.unpack(b0, 1, b0.n))) end
 local _30_ = {M["ok?"](r1), M["ok?"](r2)} if ((_G.type(_30_) == "table") and ((_30_)[1] == true) and ((_30_)[2] == true)) then

 return package(M.ok, r1, r2) elseif ((_G.type(_30_) == "table") and ((_30_)[1] == true) and ((_30_)[2] == false)) then

 return r2 elseif ((_G.type(_30_) == "table") and ((_30_)[1] == false) and ((_30_)[2] == true)) then

 return r1 elseif ((_G.type(_30_) == "table") and ((_30_)[1] == false) and ((_30_)[2] == false)) then

 return package(M.err, r1, r2) else return nil end end

 M["unwrap-or-raise"] = function(result)

 if M["err?"](result) then
 return error(M.unwrap(result)) else
 return M.unwrap(result) end end
 M["unwrap!"] = M["unwrap-or-raise"]



















































 return M