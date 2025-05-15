RoomLayer = {}
RoomLayer.__index = RoomLayer

function RoomLayer:new(name)
   local rl = {
      name = name,
      entities = {},
      visible = true,
   }
   return setmetatable(rl, RoomLayer)
end

function RoomLayer:addEntity(entity)
   table.insert(self.entities, entity)
end

function RoomLayer:removeEntity(entity)
   for i=#self.entities,1,-1 do
      if self.entities[i] == entity then 
         table.remove(self.entities, i)
      end
   end   
end

function RoomLayer:update(dt)
   for i=#self.entities,1,-1 do
      self.entities[i]:update(dt)
   end
end

function RoomLayer:draw()
   if not self.visible then return end
   for i=1,#self.entities do
      self.entities[i]:draw()
   end
end