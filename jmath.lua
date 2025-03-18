Jmath = {}

function Jmath:lengthDirX(dist, angle) return dist * math.cos(math.rad(angle)) end

function Jmath:lengthDirY(dist, angle) return dist * math.sin(math.rad(angle)) end

function Jmath:pointDir(x1, y1, x2, y2) return math.deg(math.atan2(y2 - y1, x2 - x1)) end

function Jmath:dotProduct(x1, y1, x2, y2) return (x1 * x2) + (y1 * y2) end

function Jmath:pointDist(x1, y1, x2, y2)
   local x = x2 - x1
   local y = y2 - y1
   return math.sqrt((x * x) + (y * y))
end

function Jmath:length(x, y) return math.sqrt((x * x) + (y * y)) end

function Jmath:normalize(x, y)
   local len = math.sqrt((x * x) + (y * y))
   return x / len, y / len
end

function Jmath:reflect(x, y, nx, ny)
   local dot = (x * nx) + (y * ny)
   local rx = x - (2 * dot * nx)
   local ry = y - (2 * dot * ny)
   return rx, ry
end

function Jmath:limitLength(x, y)
   local len = math.sqrt((x * x) + (y * y))
   return x ~= 0 and (x / len) or 0, y ~= 0 and (y / len) or 0
end

function Jmath:pointInCircle(x, y, cx, cy, r) return self:pointDist(x, y, cx, cy) < r end

function Jmath:closestPointOnLine(x1, y1, x2, y2, px, py)
   local dx = x2 - x1
   local dy = y2 - y1
   local len = math.sqrt((dx * dx) + (dy * dy))
   local dot = (((px - x1) * (x2 - x1)) + ((py - y1) * (y2 - y1))) / len^2
   local closest_x = x1 + (dot * (x2 - x1))
   local closest_y = y1 + (dot * (y2 - y1))
   return closest_x, closest_y
end

function Jmath:isPointOnLine(x1, y1, x2, y2, px, py, tolerance)
   local t = tolerance or 1
   local dist1 = self:pointDist(x1, y1, px, py)
   local dist2 = self:pointDist(x2, y2, px, py)
   local len = self:pointDist(x1, y1, x2, y2)
   return dist1 + dist2 > len - t and dist1 + dist2 < len + t
end

function Jmath:lineInCircle(x1, y1, x2, y2, cx, cy, r)
   if self:pointInCircle(x1, y1, cx, cy, r) then return true end
   if self:pointInCircle(x2, y2, cx, cy, r) then return true end
   local px, py = self:closestPointOnLine(x1, y1, x2, y2, cx, cy)
   if not self:isPointOnLine(x1, y1, x2, y2, px, py) then
      return false
   end
   return self:pointDist(px, py, cx, cy) < r
end