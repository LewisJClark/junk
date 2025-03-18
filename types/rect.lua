Rect = { x=0, y=0, w=1, h=1 }
Rect.__index = Rect

function Rect:new(x, y, w, h) return setmetatable({ x=x, y=y, w=w, h=h }, Rect) end

function Rect:contains(x, y) return x >= self.x and x < self.x + self.w and y >= self.y and y < self.y + self.h end

return Rect