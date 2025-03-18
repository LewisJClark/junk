Vector = { 
   x = 0, 
   y = 0,
   left = { x=-1, y=0 },
   right = { x=1, y=0 },
   up = { x=0, y=-1 },
   down = { x=0, y=1 }
}
Vector.__index = Vector

function Vector:new(x, y)
   local v = { x = x or 0, y = y or 0 }
   setmetatable(v, Vector)
   return v
end

function Vector:length()
   return math.sqrt((self.x * self.x) + (self.y * self.y))
end

function Vector:normalize()
   local len = math.sqrt((self.x * self.x) + (self.y * self.y))
   return Vector:new(self.x / len, self.y / len)
end

function Vector:copy()
   return Vector:new(self.x, self.y)
end

function Vector:setTo(other)
   self.x = other.x
   self.y = other.y
end

function Vector:isZero()
   return self.x == 0 and self.y == 0
end

function Vector:limitLength(desired)
   local len = math.sqrt((self.x * self.x) + (self.y * self.y))
   if len > desired then
      self.x = (self.x / len) * desired
      self.y = (self.y / len) * desired
   end
   return self
end

function Vector:lengthDir(dist, angle)
   local radians = math.rad(angle)
   return Vector:new(self.x + (dist * math.cos(radians)), self.y + (dist * math.sin(radians)))
end

function Vector:angleTo(x, y)
   return math.deg(math.atan2(y - self.y, x - self.x))
end

function Vector:distanceTo(other)
   return Vector:new(other.x - self.x, other.y - self.y):length()
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

function Vector.__eq(a, b) return a.x == b.x and a.y == b.y end