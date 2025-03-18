TilemapEntity = Class("TilemapEntity", Entity)

function TilemapEntity:initialize(room, layer, x, y, config)
   Entity.initialize(self, room, layer, x, y, config)
   self.tilemap = tilemap:new(config.width, config.height, config.tileset)
end

function TilemapEntity:draw()
   self.tilemap:draw(self.x, self.y)
end