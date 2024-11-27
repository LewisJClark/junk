function GetFiles(rootPath, tree)
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
 end

 function Sign(number)
  if number < 0 then return -1 end
  if number > 0 then return 1 end
  return 0
 end

function Create2dArray(w, h)
   local r = {}
   for x=1, w do
      r[x] = {}
      for y=1, h do
         r[x][y] = nil
      end
   end
   return r
end

function Sign(number)
   if number < 0 then return -1 end
   if number > 0 then return 1 end
   return 0
end

-- Attempts to move the object "o" in it's room by a movement amount "m",
-- stopping if it collides with any objects in the collision group "g".
-- Returns the final amount "o" was moved by.
function MoveAndCollide(o, m, g)
   -- Test horizontal collision.
   if o.room:placeMeeting(o, o.position.x + m.x, o.position.y, g) then
      while not o.room:placeMeeting(o, o.position.x + Sign(m.x), o.position.y, g) do
      o.position.x = o.position.x + Sign(m.x)
      end
      m.x = 0
   end
   o.position.x = o.position.x + m.x

   -- Test vertical collision.
   if o.room:placeMeeting(o, o.position.x, o.position.y + m.y, g) then
      while not o.room:placeMeeting(o, o.position.x, o.position.y + Sign(m.y), g) do
         o.position.y = o.position.y + Sign(m.y)
      end
      m.y = 0
   end
   o.position.y = o.position.y + m.y
   return m
end

-- Returns a random entry in a table by picking a random index between
-- 1 and #t.
function PickRandom(t)
   return t[love.math.random(1, #t)]
end

-- Checks if the provided value is in a table.
function TableContains(t, value)
   for _,v in pairs(t) do
      if v == value then return true end
   end
   return false
end

-- Takes a table representing a colour and converts
-- the 1-255 values to 0.0-1.0.
function NormalizeColour(color)
   return {
      r = color.r * (1/255),
      g = color.g * (1/255),
      b = color.b * (1/255),
      a = color.a * (1/255)
   }
end