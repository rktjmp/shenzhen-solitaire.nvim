

 local rel_require local function _1_(ddd_2_auto, rawrequire_3_auto) local full_mod_path_4_auto = (ddd_2_auto or "") local prefix_5_auto = (string.match(full_mod_path_4_auto, "(.+)%.iter$") or "") local function _2_(_241) return rawrequire_3_auto((prefix_5_auto .. "." .. _241)) end return _2_ end rel_require = _1_(..., require)



 local _local_3_ = rel_require("type") local seq_3f = _local_3_["seq?"] local number_3f = _local_3_["number?"]

 local M = {}

 M.range = function(start, stop, _3fstep)


 local step = (_3fstep or 1)
 assert(number_3f(start), string.format("enum#%s argument error, %s must be %s (was %s)", "range", "start", "number", type(start)))
 assert(number_3f(stop), string.format("enum#%s argument error, %s must be %s (was %s)", "range", "stop", "number", type(stop)))
 assert(number_3f(step), string.format("enum#%s argument error, %s must be %s (was %s)", "range", "step", "number", type(step)))
 assert((0 < step), "step must be positive, use (range top bot) for backwards ranges")
 local function _11_() if (start <= stop) then
 local function _5_(_241, _242) return (_241 + _242) end local function _6_(_241, _242) return (_241 - _242) end local function _7_(_241, _242) return (_241 <= _242) end return {_5_, _6_, _7_} else
 local function _8_(_241, _242) return (_241 - _242) end local function _9_(_241, _242) return (_241 + _242) end local function _10_(_241, _242) return (_241 >= _242) end return {_8_, _9_, _10_} end end local _local_4_ = _11_() local op = _local_4_[1] local inv_op = _local_4_[2] local check = _local_4_[3]
 local function gen(_12_, last) local _arg_13_ = _12_ local start0 = _arg_13_[1] local stop0 = _arg_13_[2] local step0 = _arg_13_[3]
 local maybe = op(last, step0)
 if check(maybe, stop0) then
 return maybe else
 return nil end end
 return gen, {start, stop, step}, inv_op(start, step) end

 local function xward(name, seq, step, step_flip, initial_state)


 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", name, "seq", "seq", type(seq)))
 assert(number_3f(step), string.format("enum#%s argument error, %s must be %s (was %s)", name, "step", "number", type(step)))
 assert((0 < step), ("gen#" .. name .. " step must be positive"))
 local step0 = (step_flip * step)
 local function gen(seq0, last)
 local next_i = (last + step0)
 local _15_ = (seq0)[next_i] if (nil ~= _15_) then local val = _15_
 return next_i, val else return nil end end
 return gen, seq, initial_state end

 M.fwd = function(seq, _3fstep) _G.assert((nil ~= seq), "Missing argument seq on ./fnl/shenzhen-solitaire/lib/donut/iter/init.fnl:42")

 local step = (_3fstep or 1)
 return xward("fward", seq, step, 1, (1 - step)) end
 M["ipairs"] = M.fward

 M.bwd = function(seq, _3fstep) _G.assert((nil ~= seq), "Missing argument seq on ./fnl/shenzhen-solitaire/lib/donut/iter/init.fnl:48")

 local step = (_3fstep or 1)
 return xward("bward", seq, step, -1, (#seq + step)) end
 M["ripairs"] = M.rward

 return M