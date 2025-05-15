TilemapEntity = {}
TilemapEntity.__index = TilemapEntity

function TilemapEntity:new(room, layer, x, y, config)
   local e = Entity:new(room, layer, x, y, config)
   e:extend({
      tilemap = tilemap:new(config.width, config.height, config.tileset)
   })
   return setmetatable(e, TilemapEntity)
end

function TilemapEntity:draw()
   self.tilemap:draw(self.x, self.y)
end