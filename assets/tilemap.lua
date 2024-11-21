require "frengine.assets.assetLib"
require "frengine.utils"

Tilemap = {}
Tilemap.__index = Tilemap

function Tilemap:new(w, h, tileset)
   local newTilemap = {
      width = w,
      height = h,
      tiles = Create2dArray(w, h),
      tileset = tileset
   }
   return setmetatable(newTilemap, Tilemap)
end

function Tilemap:set(x, y, tile)
   if x < 1 or x > self.width then return end
   if y < 1 or y > self.height then return end
   self.tiles[x][y] = tile
end

function Tilemap:draw(x, y)
   for xx=1,self.width do
      for yy=1,self.height do
         local tileIndex = self.tiles[xx][yy] or 0
         if tileIndex ~= 0 then
            local drawX = x + (xx - 1) * self.tileset.tileWidth
            local drawY = y + (yy - 1) * self.tileset.tileHeight
            love.graphics.draw(self.tileset.image, self.tileset.tiles[tileIndex], drawX, drawY, 0, 1, 1, 0, 0)
         end
      end
   end
end