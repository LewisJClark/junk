local gmath = {
   lengthDirX = function(dist, angle) return dist * math.cos(math.rad(angle)) end,

   lengthDirY = function(dist, angle) return dist * math.sin(math.rad(angle)) end,

   pointDir = function(x1, y1, x2, y2) return math.deg(math.atan2(y2 - y1, x2 - x1)) end,

   pointDist = function(x1, y1, x2, y2) 
      local x = x2 - x1
      local y = y2 - y1
      return math.sqrt((x * x) + (y * y))
   end,

   limitLength = function(x, y) 
      local len = math.sqrt((x * x) + (y * y))
      return x ~= 0 and (x / len) or 0, y ~= 0 and (y / len) or 0
   end,

}
return gmath