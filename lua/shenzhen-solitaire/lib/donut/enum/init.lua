





 local rel_require local function _1_(ddd_2_auto, rawrequire_3_auto) local full_mod_path_4_auto = (ddd_2_auto or "") local prefix_5_auto = (string.match(full_mod_path_4_auto, "(.+)%.enum$") or "") local function _2_(_241) return rawrequire_3_auto((prefix_5_auto .. "." .. _241)) end return _2_ end rel_require = _1_(..., require)
 local function _4_(...) local mod_44_auto = rel_require("type") local keys_45_auto = {"assoc?", "number?", "nil?", "seq?", "table?", "function?"} for __48_auto, key_49_auto in ipairs(keys_45_auto) do assert(not (nil == (mod_44_auto)[key_49_auto]), string.format("mod did not have key %s %s", key_49_auto, "\"type\"")) end return mod_44_auto end local _local_3_ = _4_(...) local assoc_3f = _local_3_["assoc?"] local function_3f = _local_3_["function?"] local nil_3f = _local_3_["nil?"] local number_3f = _local_3_["number?"] local seq_3f = _local_3_["seq?"] local table_3f = _local_3_["table?"] do local _ = {nil} end



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




 return acc elseif true then local _ = _9_ local _let_10_ = vals

 local ctrl0 = _let_10_[1] local _0 = (function (t, k) local mt = getmetatable(t) if "table" == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) else return {(table.unpack or unpack)(t, k)} end end)(_let_10_, 2)
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
 local tbl_15_auto = acc local i_16_auto = #tbl_15_auto for _, vv in ipairs(v) do local val_17_auto = vv if (nil ~= val_17_auto) then i_16_auto = (i_16_auto + 1) do end (tbl_15_auto)[i_16_auto] = val_17_auto else end end return tbl_15_auto else
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
 local function _21_(_241, _242, _243) local _22_ = _241 table.insert(_22_, _243) return _22_ end insert = _21_ else
 local function _23_(_241, _242, _243) local _24_ = _241 _24_[_242] = _243 return _24_ end insert = _23_ end local insert_3f
 local function _26_(acc, k, v)
 if pred(k, v) then
 return insert(acc, k, v) else
 return acc end end insert_3f = _26_
 return M.reduce(t, {}, insert_3f) end



 local function negable_seq_index(seq, i, ctx)







 assert(ctx, "ind-mod requires :insert or :remove ctx")
 local _28_ = {i, #seq, ctx} local function _29_() local n = (_28_)[2] return (function(_30_,_31_,_32_) return (_30_ < _31_) and (_31_ < _32_) end)(0,i,(n + 1)) end if (((_G.type(_28_) == "table") and ((_28_)[1] == i) and (nil ~= (_28_)[2])) and _29_()) then local n = (_28_)[2]
 return i elseif ((_G.type(_28_) == "table") and ((_28_)[1] == -1) and ((_28_)[2] == 0)) then
 return 1 else local function _33_() local n = (_28_)[2] return (function(_34_,_35_,_36_) return (_34_ <= _35_) and (_35_ <= _36_) end)(((-1 * n) - 1),i,-1) end if (((_G.type(_28_) == "table") and ((_28_)[1] == i) and (nil ~= (_28_)[2]) and ((_28_)[3] == "insert")) and _33_()) then local n = (_28_)[2]

 return (n + 2 + i) else local function _37_() local n = (_28_)[2] return (function(_38_,_39_,_40_) return (_38_ <= _39_) and (_39_ <= _40_) end)((-1 * n),i,-1) end if (((_G.type(_28_) == "table") and ((_28_)[1] == i) and (nil ~= (_28_)[2]) and ((_28_)[3] == "remove")) and _37_()) then local n = (_28_)[2]
 return (n + 1 + i) else local function _41_() local n = (_28_)[2] return (n < i) end if (((_G.type(_28_) == "table") and ((_28_)[1] == i) and (nil ~= (_28_)[2])) and _41_()) then local n = (_28_)[2]
 return error(string.format("index %d overbounds", i, n)) else local function _42_() local n = (_28_)[2] return (i < 0) end if (((_G.type(_28_) == "table") and ((_28_)[1] == i) and (nil ~= (_28_)[2])) and _42_()) then local n = (_28_)[2]
 return error(string.format("index %d underbounds", i, n)) elseif ((_G.type(_28_) == "table") and ((_28_)[1] == 0) and (nil ~= (_28_)[2])) then local n = (_28_)[2]
 return error(string.format("index 0 invalid, use 1 or %d", ((-1 * n) - 1))) else return nil end end end end end end

 M["insert$"] = function(seq, i, v)


 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "insert$", "seq", "seq", type(seq)))
 assert(not nil_3f(v), "enum#insert$ value must not be nil")
 assert(("number" == type(i)), "enum#insert index must be a number")
 local _44_ = seq table.insert(_44_, negable_seq_index(seq, i, "insert"), v) return _44_ end


 M["remove$"] = function(seq, i)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "remove$", "seq", "seq", type(seq)))
 assert(number_3f(i), string.format("enum#%s argument error, %s must be %s (was %s)", "remove$", "i", "number", type(i)))

 local _45_ = seq table.remove(_45_, negable_seq_index(seq, i, "remove")) return _45_ end


 M["append$"] = function(seq, ...)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "append$", "seq", "seq", type(seq)))
 local _let_46_ = M.pack(...) local n = _let_46_["n"] local vals = _let_46_
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
 local tbl_15_auto = seq local i_16_auto = #tbl_15_auto for _, v in ipairs(from_seq) do
 local val_17_auto = v if (nil ~= val_17_auto) then i_16_auto = (i_16_auto + 1) do end (tbl_15_auto)[i_16_auto] = val_17_auto else end end end end
 return seq end

 M["chunk-every"] = function(seq, n, _3ffill)










 local l = #seq
 if (0 < l) then
 local out_3_auto = {} for i = 1, #seq, n do local function _48_()
 local out_3_auto0 = {} for ii = 0, (n - 1) do
 local function _50_() local _49_ = seq[(i + ii)] if (_49_ == nil) then
 return _3ffill elseif (nil ~= _49_) then local any = _49_
 return any else return nil end end table.insert(out_3_auto0, _50_()) end return out_3_auto0 end table.insert(out_3_auto, _48_()) end return out_3_auto else
 return {} end end

 M.hd = function(seq)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "hd", "seq", "seq", type(seq)))
 local _let_53_ = seq local h = _let_53_[1]
 return h end

 M.tl = function(seq)

 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "tl", "seq", "seq", type(seq)))
 local _let_54_ = seq local _ = _let_54_[1] local tail = (function (t, k) local mt = getmetatable(t) if "table" == type(mt) and mt.__fennelrest then return mt.__fennelrest(t, k) else return {(table.unpack or unpack)(t, k)} end end)(_let_54_, 2)
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

 M.copy = function(t) local tbl_12_auto = {}

 for k, v in pairs(t) do local _56_, _57_ = k, v if ((nil ~= _56_) and (nil ~= _57_)) then local k_13_auto = _56_ local v_14_auto = _57_ tbl_12_auto[k_13_auto] = v_14_auto else end end return tbl_12_auto end



 M["set$"] = function(t, k, v)


 assert(table_3f(t), string.format("enum#%s argument error, %s must be %s (was %s)", "set$", "t", "table", type(t)))
 local k0 if function_3f(k) then k0 = k else local function _59_() return k end k0 = _59_ end local v0
 if function_3f(v) then v0 = v else local function _61_() return v end v0 = _61_ end
 local _63_ = t _63_[k0()] = v0() return _63_ end




 M["sort$"] = function(seq, f)


 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "sort$", "seq", "seq", type(seq)))
 local _64_ = seq table.sort(_64_, f) return _64_ end

 M.sort = function(seq, f)


 assert(seq_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "sort", "seq", "seq", type(seq)))



 local sorted_keys
 local function _65_(_241) local _66_ = _241
 local function _71_(_67_, _69_) local _arg_68_ = _67_ local _ = _arg_68_[1] local a = _arg_68_[2] local _arg_70_ = _69_ local _0 = _arg_70_[1] local b = _arg_70_[2] return f(a, b) end table.sort(_66_, _71_) return _66_ end
 local function _74_(acc, i, _72_) local _arg_73_ = _72_ local oi = _arg_73_[1] local v = _arg_73_[2]
 return M["set$"](acc, oi, i) end sorted_keys = M.reduce(_65_(M["table->pairs"](seq)), {}, _74_)

 local function _75_(acc, i, v)
 return M["set$"](acc, sorted_keys[i], v) end return M.reduce(seq, {}, _75_) end




 M["table->pairs"] = function(t)


 assert(table_3f(t), string.format("enum#%s argument error, %s must be %s (was %s)", "table->pairs", "t", "table", type(t)))
 local function _76_(_241, _242) return {_241, _242} end return M.map(t, _76_) end

 M["pairs->table"] = function(seq)


 assert(table_3f(seq), string.format("enum#%s argument error, %s must be %s (was %s)", "tuples->assocs", "seq", "table", type(seq)))
 local function _79_(acc, i, _77_) local _arg_78_ = _77_ local k = _arg_78_[1] local v = _arg_78_[2]
 return M["set$"](acc, k, v) end return M.reduce(seq, {}, _79_) end

 M.keys = function(t)
 assert(table_3f(t), string.format("enum#%s argument error, %s must be %s (was %s)", "keys", "t", "table", type(t)))

 local _80_ do local tbl_15_auto = {} local i_16_auto = #tbl_15_auto for k, _ in pairs(t) do local val_17_auto = k if (nil ~= val_17_auto) then i_16_auto = (i_16_auto + 1) do end (tbl_15_auto)[i_16_auto] = val_17_auto else end end _80_ = tbl_15_auto end
 local function _82_(_241, _242) return (_241 <= _242) end return M.sort(_80_, _82_) end

 M.vals = function(t)
 assert(table_3f(t), string.format("enum#%s argument error, %s must be %s (was %s)", "vals", "t", "table", type(t))) local tbl_15_auto = {}
 local i_16_auto = #tbl_15_auto for _, v in pairs(t) do local val_17_auto = v if (nil ~= val_17_auto) then i_16_auto = (i_16_auto + 1) do end (tbl_15_auto)[i_16_auto] = val_17_auto else end end return tbl_15_auto end

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