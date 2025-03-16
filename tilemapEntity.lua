local tilemapEntity = Class("tilemapEntity", Entity)

function tilemapEntity:initialize(room, layer, x, y, config)
   Entity.initialize(self, room, layer, x, y, config)
   self.tilemap = tilemap:new(config.width, config.height, config.tileset)
end

function tilemapEntity:draw()
   self.tilemap:draw(self.x, self.y)
end

return tilemapEntity