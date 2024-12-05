 return {

   create2dArray = function(w, h)
      local r = {}
      for x=1, w do
         r[x] = {}
         for y=1, h do
            r[x][y] = nil
         end
      end
      return r
   end,

   getFiles = function(rootPath, tree)
      tree = tree or {}
      local filesTable = love.filesystem.getDirectoryItems(rootPath)
      for _,v in ipairs(filesTable) do
         local path = rootPath.."/"..v
         local info = love.filesystem.getInfo(path)
         if info.type == "file" then
            tree[#tree+1] = path
         elseif info.type == "directory" then
            tree = GetFiles(path, tree)
         end
      end
      return tree
   end,

   normalizeColour = function(color)
      return {
         r = color.r * (1/255),
         g = color.g * (1/255),
         b = color.b * (1/255),
         a = color.a * (1/255)
      }
   end,

   pickRandom = function(t)
      return t[love.math.random(1, #t)]
   end,

   -- Splits str around separator, returning a table of the parts.
   -- @param str string: The string to split.
   -- @param separator string: The string to split around.
   -- @return table: A table containing the string parts.
   splitStr = function(str, separator)
      if separator == nil then separator = "%s" end
      local parts = {}
      for sub in string.gmatch(str, "([^"..separator.."]+)") do
         table.insert(parts, sub)
      end
      return parts
   end,

   sign =  function(number)
      if number < 0 then return -1 end
      if number > 0 then return 1 end
      return 0
   end,

   tableContains = function(t, value)
      for _,v in pairs(t) do
         if v == value then return true end
      end
      return false
   end,
 }