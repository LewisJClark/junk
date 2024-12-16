local vector = { 
   x = 0, 
   y = 0,
   left = { x=-1, y=0 },
   right = { x=1, y=0 },
   up = { x=0, y=-1 },
   down = { x=0, y=1 }
}
vector.__index = vector

function vector:new(x, y)
   local v = { x = x or 0, y = y or 0 }
   setmetatable(v, vector)
   return v
end

function vector:length()
   return math.sqrt((self.x * self.x) + (self.y * self.y))
end

function vector:normalize()
   local len = math.sqrt((self.x * self.x) + (self.y * self.y))
   return vector:new(self.x / len, self.y / len)
end

function vector:copy()
   return vector:new(self.x, self.y)
end

function vector:setTo(other)
   self.x = other.x
   self.y = other.y
end

function vector:isZero()
   return self.x == 0 and self.y == 0
end

function vector:limitLength(desired)
   local len = math.sqrt((self.x * self.x) + (self.y * self.y))
   if len > desired then
      self.x = (self.x / len) * desired
      self.y = (self.y / len) * desired
   end
   return self
end

function vector:lengthDir(dist, angle)
   local radians = math.rad(angle)
   return vector:new(self.x + (dist * math.cos(radians)), self.y + (dist * math.sin(radians)))
end

function vector:angleTo(x, y)
   return math.deg(math.atan2(y - self.y, x - self.x))
end

function vector.__add(a, b)
   if type(a) == "number" then return vector:new(b.x + a, b.y + a) end
   if type(b) == "number" then return vector:new(a.x + b, a.y + b) end
   return vector:new(a.x + b.x, a.y + b.y)
end

function vector.__sub(a, b)
   if type(a) == "number" then return vector:new(b.x - a, b.y - a) end
   if type(b) == "number" then return vector:new(a.x - b, a.y - b) end
   return vector:new(a.x - b.x, a.y - b.y)
end

function vector.__mul(a, b)
   if type(a) == "number" then return vector:new(b.x * a, b.y * a) end
   if type(b) == "number" then return vector:new(a.x * b, a.y * b) end
   return vector:new(a.x * b.x, a.y * b.y)
end

function vector.__div(a, b)
   if type(a) == "number" then return vector:new(b.x * a, b.y * a) end
   if type(b) == "number" then return vector:new(a.x * b, a.y * b) end
   return vector:new(a.x * b.x, a.y * b.y)
end

function vector.__eq(a, b)
   return a.x == b.x and a.y == b.y
end

return vector