





 local rel_require local function _1_(ddd_2_auto, rawrequire_3_auto) local full_mod_path_4_auto = (ddd_2_auto or "") local prefix_5_auto = (string.match(full_mod_path_4_auto, "(.+)%.enum$") or "") local function _2_(_241) return rawrequire_3_auto((prefix_5_auto .. "." .. _241)) end return _2_ end rel_require = _1_(..., require)
 local function _4_(...) local mod_36_auto = rel_require("type") local keys_37_auto = {"nil?", "assoc?", "seq?", "function?", "number?", "table?"} for __40_auto, key_41_auto in ipairs(keys_37_auto) do assert(not (nil == (mod_36_auto)[key_41_auto]), string.format("mod did not have key %s %s", key_41_auto, "\"type\"")) end return mod_36_auto end local _local_3_ = _4_(...) local assoc_3f = _local_3_["assoc?"] local function_3f = _local_3_["function?"] local nil_3f = _local_3_["nil?"] local number_3f = _local_3_["number?"] local seq_3f = _local_3_["seq?"] local table_3f = _local_3_["table?"] do local _ = {nil} end



 local M = {}

 local function enumerable_3f(v)
 return (table_3f(v) or function_3f(v)) end



 M.pack = function(...)

 local _5_ = {...} _5_["n"] = select("#", ...) return _5_ end

 M.unpack = function(t, i, j)



 assert(table_3f(t), string.format("enum#%s argument error, %s must be %s (was %s)", "unpack", "t", "table", type(t)))
 local rawunpack = (_G.unpack or table.unpack)
 return rawunpack(t, (i or 1), (j or t.n)) end



 local function do_reduce(_6_, acc, f) local _arg_7_ = _6_ local gen = _arg_7_[1] local invariant = _arg_7_[2] local ctrl = _arg_7_[3]
 local _let_8_ = M.pack(gen(invariant, ctrl)) local n = _let_8_["n"] local vals = _let_8_
 local _9_ = {n, vals} if ((_G.type(_9_) == "table") and ((_9_)[1] == 1) and ((_G.type((_9_)[2]) == "table") and (((_9_)[2])[1] == nil))) then


 return acc elseif ((_G.type(_9_) == "table") and ((_9_)[1] == 0) and true) then local _ = (_9_)[2]




 return acc elseif true then local _ = _9_

 local _let_10_ = vals local ctrl0 = _let_10_[1] local _0 = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_10_, 2)
 local next_val = f(acc, M.unpack(vals, 1, n))
 return do_reduce({gen, invariant, ctrl0}, next_val, f) else return nil end end

 M.reduce = function(enumerable, acc, f)





 assert(enumerable_3f(enumerable), string.format("enum#%s argument error, %s must be %s (was %s)", "reduce", "enumerable", "enumerable", type(enumerable)))
 local _12_ = {enumerable, acc, f} local function _13_() local seq = (_12_)[1] return seq_3f(seq) end if (((_G.type(_12_) == "table") and (nil ~= (_12_)[1]) and ((_12_)[2] == acc) and ((_12_)[3] == f)) and _13_()) then local seq = (_12_)[1]
 return do_reduce({ipairs(seq)}, acc, f) else local function _14_() local assoc = (_12_)[1] return assoc_3f(assoc) end if (((_G.type(_12_) == "table") and (nil ~= (_12_)[1]) and ((_12_)[2] == acc) and ((_12_)[3] == f)) and _14_()) then local assoc = (_12_)[1]
 return do_reduce({pairs(assoc)}, acc, f) else local function _15_() local iter = (_12_)[1] return ("function" == type(iter)) end if (((_G.type(_12_) == "table") and (nil ~= (_12_)[1]) and ((_12_)[2] == acc) and ((_12_)[3] == f)) and _15_()) then local iter = (_12_)[1]




 return do_reduce({iter()}, acc, f) elseif true then local _ = _12_
 return error("unmatched-reduce-args") else return nil end end end end



 M.map = function(enumerable, f)





 local function xf(acc, ...)
 local _17_ = f(...) if (nil ~= _17_) then local val = _17_
 return M["insert$"](acc, -1, val) elseif (_17_ == nil) then
 return acc else return nil end end
 return M.reduce(enumerable, {}, xf) end

 M.each = function(enumerable, f)


 local function xf(acc, ...) f(...) return nil end
 return M.reduce(enumerable, {}, xf) end

 local function do_flatten(acc, i, v)
 if seq_3f(v) then
 local tbl_17_auto = acc local i_18_auto = #tbl_17_auto for _, vv in ipairs(v) do local val_19_auto = vv if (nil ~= val_19_auto) then i_18_auto = (i_18_auto + 1) do end (tbl_17_auto)[i_18_auto] = val_19_auto else end end return tbl_17_auto else
 return M["append$"](acc, v) end end

 M.flatten = function(seq)
 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "flatten", "seq", "seq", type(seq)))
 return M.reduce(seq, {}, do_flatten) end


 M["flat-map"] = function(enumerable, f)
 return M.flatten(M.map(enumerable, f)) end


 M.filter = function(t, pred)






 assert(table_3f(t), "enum#filter only supports seqs and assocs, filter a custom iter-fn via map")

 assert(function_3f(pred), string.format("enum#%s argument error, %s must be %s (was %s)", "filter", "pred", "function", type(pred)))
 local insert if seq_3f(t) then
 local function _21_(_241, _242, _243) table.insert(_241, _243) return _241 end insert = _21_ else
 local function _22_(_241, _242, _243) _241[_242] = _243 return _241 end insert = _22_ end local insert_3f
 local function _24_(acc, k, v)
 if pred(k, v) then
 return insert(acc, k, v) else
 return acc end end insert_3f = _24_
 return M.reduce(t, {}, insert_3f) end



 local function negable_seq_index(seq, i, ctx)







 assert(ctx, "ind-mod requires :insert or :remove ctx")
 local _26_ = {i, #seq, ctx} local function _27_() local n = (_26_)[2] return (function(_28_,_29_,_30_) return (_28_ < _29_) and (_29_ < _30_) end)(0,i,(n + 1)) end if (((_G.type(_26_) == "table") and ((_26_)[1] == i) and (nil ~= (_26_)[2])) and _27_()) then local n = (_26_)[2]
 return i elseif ((_G.type(_26_) == "table") and ((_26_)[1] == -1) and ((_26_)[2] == 0)) then
 return 1 else local function _31_() local n = (_26_)[2] return (function(_32_,_33_,_34_) return (_32_ <= _33_) and (_33_ <= _34_) end)(((-1 * n) - 1),i,-1) end if (((_G.type(_26_) == "table") and ((_26_)[1] == i) and (nil ~= (_26_)[2]) and ((_26_)[3] == "insert")) and _31_()) then local n = (_26_)[2]

 return (n + 2 + i) else local function _35_() local n = (_26_)[2] return (function(_36_,_37_,_38_) return (_36_ <= _37_) and (_37_ <= _38_) end)((-1 * n),i,-1) end if (((_G.type(_26_) == "table") and ((_26_)[1] == i) and (nil ~= (_26_)[2]) and ((_26_)[3] == "remove")) and _35_()) then local n = (_26_)[2]
 return (n + 1 + i) else local function _39_() local n = (_26_)[2] return (n < i) end if (((_G.type(_26_) == "table") and ((_26_)[1] == i) and (nil ~= (_26_)[2])) and _39_()) then local n = (_26_)[2]
 return error(string.format("index %d overbounds", i, n)) else local function _40_() local n = (_26_)[2] return (i < 0) end if (((_G.type(_26_) == "table") and ((_26_)[1] == i) and (nil ~= (_26_)[2])) and _40_()) then local n = (_26_)[2]
 return error(string.format("index %d underbounds", i, n)) elseif ((_G.type(_26_) == "table") and ((_26_)[1] == 0) and (nil ~= (_26_)[2])) then local n = (_26_)[2]
 return error(string.format("index 0 invalid, use 1 or %d", ((-1 * n) - 1))) else return nil end end end end end end

 M["insert$"] = function(seq, i, v)


 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "insert$", "seq", "seq", type(seq)))
 assert(not nil_3f(v), "enum#insert$ value must not be nil")
 assert(("number" == type(i)), "enum#insert index must be a number")
 table.insert(seq, negable_seq_index(seq, i, "insert"), v) return seq end


 M["remove$"] = function(seq, i)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "remove$", "seq", "seq", type(seq)))
 assert(number_3f(i), string.format("enum#%s argument error, %s must be %s (was %s)", "remove$", "i", "number", type(i)))

 table.remove(seq, negable_seq_index(seq, i, "remove")) return seq end


 M["append$"] = function(seq, ...)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "append$", "seq", "seq", type(seq)))
 local _let_42_ = M.pack(...) local n = _let_42_["n"] local vals = _let_42_
 assert((0 < n), "enum#append$ must receive at least one value")
 for i = 1, n do
 M["insert$"](seq, -1, vals[i]) end
 return seq end

 M["concat$"] = function(seq, seq_1, ...)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "concat", "seq", "seq", type(seq)))
 assert(seq_3f(seq_1), string.format("enum#%s argument error, %s must be %s (was %s)", "concat", "seq-1", "seq", type(seq_1)))
 do local froms = {seq_1, ...}
 for i, from_seq in ipairs(froms) do
 assert(seq_3f(from_seq), string.format("enum#%s argument error, %s must be %s (was %s)", ("concat-arg-seq-" .. i), "from-seq", "seq", type(from_seq)))
 local tbl_17_auto = seq local i_18_auto = #tbl_17_auto for _, v in ipairs(from_seq) do
 local val_19_auto = v if (nil ~= val_19_auto) then i_18_auto = (i_18_auto + 1) do end (tbl_17_auto)[i_18_auto] = val_19_auto else end end end end
 return seq end

 M["chunk-every"] = function(seq, n, _3ffill)










 local l = #seq
 if (0 < l) then local out_3_auto = {} for i = 1, #seq, n do local function _44_() local out_3_auto0 = {} for ii = 0, (n - 1) do


 local function _46_() local _45_ = seq[(i + ii)] if (_45_ == nil) then
 return _3ffill elseif (nil ~= _45_) then local any = _45_
 return any else return nil end end table.insert(out_3_auto0, _46_()) end return out_3_auto0 end table.insert(out_3_auto, _44_()) end return out_3_auto else
 return {} end end

 M.hd = function(seq)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "hd", "seq", "seq", type(seq)))
 local _let_49_ = seq local h = _let_49_[1]
 return h end

 M.tl = function(seq)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "tl", "seq", "seq", type(seq)))
 local _let_50_ = seq local _ = _let_50_[1] local tail = (function (t, k, e) local mt = getmetatable(t) if 'table' == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) elseif e then local rest = {} for k, v in pairs(t) do if not e[k] then rest[k] = v end end return rest else return {(table.unpack or unpack)(t, k)} end end)(_let_50_, 2)
 return tail end

 M.first = function(seq)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "first", "seq", "seq", type(seq)))
 return M.hd(seq) end

 M.last = function(seq)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "last", "seq", "seq", type(seq)))
 return seq[#seq] end

 M.split = function(seq, index)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "split", "seq", "seq", type(seq)))

 assert((1 <= index), "enum#split index must be 1 or more")
 local left, right = {}, {} for i, v in ipairs(seq) do
 if (i < index) then
 left, right = M["insert$"](left, -1, v), right else
 left, right = left, M["insert$"](right, -1, v) end end return left, right end

 M.copy = function(t) local tbl_14_auto = {}

 for k, v in pairs(t) do local k_15_auto, v_16_auto = k, v if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then tbl_14_auto[k_15_auto] = v_16_auto else end end return tbl_14_auto end



 M["set$"] = function(t, k, v)


 assert(table_3f(t), string.format("enum#%s argument error, %s must be %s (was %s)", "set$", "t", "table", type(t)))
 local k0 if function_3f(k) then k0 = k else local function _53_() return k end k0 = _53_ end local v0
 if function_3f(v) then v0 = v else local function _55_() return v end v0 = _55_ end
 t[k0()] = v0() return t end




 M["sort$"] = function(seq, f)


 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "sort$", "seq", "seq", type(seq)))
 table.sort(seq, f) return seq end

 M.sort = function(seq, f)


 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "sort", "seq", "seq", type(seq)))



 local sorted_keys
 local function _57_(_241)
 local function _62_(_58_, _60_) local _arg_59_ = _58_ local _ = _arg_59_[1] local a = _arg_59_[2] local _arg_61_ = _60_ local _0 = _arg_61_[1] local b = _arg_61_[2] return f(a, b) end table.sort(_241, _62_) return _241 end
 local function _65_(acc, i, _63_) local _arg_64_ = _63_ local oi = _arg_64_[1] local v = _arg_64_[2]
 return M["set$"](acc, oi, i) end sorted_keys = M.reduce(_57_(M["table->pairs"](seq)), {}, _65_)

 local function _66_(acc, i, v)
 return M["set$"](acc, sorted_keys[i], v) end return M.reduce(seq, {}, _66_) end




 M["table->pairs"] = function(t)


 assert(table_3f(t), string.format("enum#%s argument error, %s must be %s (was %s)", "table->pairs", "t", "table", type(t)))
 local function _67_(_241, _242) return {_241, _242} end return M.map(t, _67_) end

 M["pairs->table"] = function(seq)


 assert(table_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "tuples->assocs", "seq", "table", type(seq)))
 local function _70_(acc, i, _68_) local _arg_69_ = _68_ local k = _arg_69_[1] local v = _arg_69_[2]
 return M["set$"](acc, k, v) end return M.reduce(seq, {}, _70_) end

 M.keys = function(t)
 assert(table_3f(t), string.format("enum#%s argument error, %s must be %s (was %s)", "keys", "t", "table", type(t)))

 local _71_ do local tbl_17_auto = {} local i_18_auto = #tbl_17_auto for k, _ in pairs(t) do local val_19_auto = k if (nil ~= val_19_auto) then i_18_auto = (i_18_auto + 1) do end (tbl_17_auto)[i_18_auto] = val_19_auto else end end _71_ = tbl_17_auto end
 local function _73_(_241, _242) return (_241 <= _242) end return M.sort(_71_, _73_) end

 M.vals = function(t)
 assert(table_3f(t), string.format("enum#%s argument error, %s must be %s (was %s)", "vals", "t", "table", type(t))) local tbl_17_auto = {}
 local i_18_auto = #tbl_17_auto for _, v in pairs(t) do local val_19_auto = v if (nil ~= val_19_auto) then i_18_auto = (i_18_auto + 1) do end (tbl_17_auto)[i_18_auto] = val_19_auto else end end return tbl_17_auto end

 M["shuffle$"] = function(t)
 assert(seq_3f(t), string.format("enum#%s argument error, %s must be %s (was %s)", "shuffle$", "t", "seq", type(t)))
 for i = #t, 1, -1 do
 local j = math.random(1, i)
 local hold = t[j]
 t[j] = t[i]
 t[i] = hold end
 return t end

 M["empty?"] = function(t)
 assert(seq_3f(t), string.format("enum#%s argument error, %s must be %s (was %s)", "empty?", "t", "seq", type(t)))
 return (0 == #t) end

 return M