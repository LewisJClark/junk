Vector = { x = 0, y = 0 }
Vector.__index = Vector

function Vector:new(x, y)
   local v = { x = x or 0, y = y or 0 }
   setmetatable(v, Vector)
   return v
end

function Vector:normalize()
   local len = math.sqrt((self.x* self.x) + (self.y * self.y))
   return Vector:new(self.x / len, self.y / len)
end

function Vector:copy()
   return Vector:new(self.x, self.y)
end

function Vector.__add(a, b)
   if type(a) == "number" then return Vector:new(b.x + a, b.y + a) end
   if type(b) == "number" then return Vector:new(a.x + b, a.y + b) end
   return Vector:new(a.x + b.x, a.y + b.y)
end

function Vector.__sub(a, b)
   if type(a) == "number" then return Vector:new(b.x - a, b.y - a) end
   if type(b) == "number" then return Vector:new(a.x - b, a.y - b) end
   return Vector:new(a.x - b.x, a.y - b.y)
end

function Vector.__mul(a, b)
   if type(a) == "number" then return Vector:new(b.x * a, b.y * a) end
   if type(b) == "number" then return Vector:new(a.x * b, a.y * b) end
   return Vector:new(a.x * b.x, a.y * b.y)
end

function Vector.__div(a, b)
   if type(a) == "number" then return Vector:new(b.x * a, b.y * a) end
   if type(b) == "number" then return Vector:new(a.x * b, a.y * b) end
   return Vector:new(a.x * b.x, a.y * b.y)
end