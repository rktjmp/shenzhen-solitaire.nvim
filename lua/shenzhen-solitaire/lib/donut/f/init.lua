 local relrequire local function _1_(ddd) local function _2_(_241) return require(((string.match(ddd, "(.+%.)donut%.") or "") .. _241)) end return _2_ end relrequire = _1_(...)

 local function tap(x, f) f(x) return x end
 local function _then(x, f) return f(x) end

 return {tap = tap, ["then"] = _then}