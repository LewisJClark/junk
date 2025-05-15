Class = {}

function Class:inherit(base, parent)
   local t = setmetatable({}, { __index = parent })
   t.__index = base
   return t
end
