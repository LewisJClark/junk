local tilemap = require("junk.assets.tilemap")
local entity = require("junk.entity")
local class = require("junk.third_party.middleclass")

local tilemapEntity = class("tilemapEntity", entity)

function tilemapEntity:initialize(room, layer, x, y, config)
   entity.initialize(self, room, layer, x, y, config)
   self.tilemap = tilemap:new(config.width, config.height, config.tileset)
end

function tilemapEntity:draw()
   self.tilemap:draw(self.x, self.y)
end

return tilemapEntity