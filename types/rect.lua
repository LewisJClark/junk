local rect = { x=0, y=0, w=1, h=1 }
rect.__index = rect

function rect:new(x, y, w, h)
   return setmetatable({ x=x, y=y, w=w, h=h }, rect)
end

function rect:contains(x, y)
   return x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h
end

return rect