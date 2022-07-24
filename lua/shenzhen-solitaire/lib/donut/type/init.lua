




 local next = _G.next local donut_type_key = "__donut__type"


 local M = {}



 M.of = function(value)

 local _1_ = getmetatable(value) if ((_G.type(_1_) == "table") and (nil ~= (_1_)[donut_type_key])) then local dt = (_1_)[donut_type_key]
 return dt elseif true then local _ = _1_
 return type(value) else return nil end end

 M["is-any?"] = function(value, valid_types)

 local want_type = M.of(value) local _in = false
 for _, type_id in ipairs(valid_types) do if _in then break end
 _in = (type_id == want_type) end return _in end

 M["is?"] = function(value, type_id)

 return M["is-any?"](value, {type_id}) end

 M["set-type"] = function(value, type_id)

 assert(type_id, "type#set-type requires non-nil type-id")
 local mt = (getmetatable(value) or {})
 do end (mt)[donut_type_key] = type_id
 return setmetatable(value, mt) end



 M["seq?"] = function(v)

 return (("table" == type(v)) and (not (nil == v[1]) or (nil == next(v)))) end



 M["assoc?"] = function(v)






 return (("table" == type(v)) and (nil == v[1])) end


 M["table?"] = function(v)
 return ("table" == type(v)) end

 M["number?"] = function(v)
 return ("number" == type(v)) end

 M["boolean?"] = function(v)
 return ("boolean" == type(v)) end

 M["string?"] = function(v)
 return ("string" == type(v)) end

 M["function?"] = function(v)
 return ("function" == type(v)) end

 M["nil?"] = function(v)
 return ("nil" == type(v)) end

 M["userdata?"] = function(v)
 return ("userdata" == type(v)) end

 M["thread?"] = function(v)
 return ("thread" == type(v)) end






 M["type-is?"] = M["is?"]
 M["type-of"] = M.of
 M["type-is-any?"] = M["is-any?"]
 M["bool?"] = M["boolean?"]

 return M