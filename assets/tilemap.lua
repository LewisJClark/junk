local tilemap = {}
tilemap.__index = tilemap

function tilemap:new(w, h, tileset)
   local new_tilemap = {
      width = w,
      height = h,
      tiles = Utils.create2dArray(w, h),
      tileset = tileset
   }
   return setmetatable(new_tilemap, tilemap)
end

function tilemap:set(x, y, tile)
   if x < 1 or x > self.width then return end
   if y < 1 or y > self.height then return end
   self.tiles[x][y] = tile
end

function tilemap:setNamed(x, y, tile_name)
   if x < 1 or x > self.width then return end
   if y < 1 or y > self.height then return end
   local tile = self.tileset.namedTiles[tile_name]
   if tile == nil then return end
   self.tiles[x][y] = tile
end

function tilemap:setNamedRandom(x, y, tile_name)
   if x < 1 or x > self.width then return end
   if y < 1 or y > self.height then return end
   local named_tile = self.tileset.namedTiles[tile_name]
   local tile = named_tile[math.random(1, #named_tile)]
   if tile == nil then return end
   self.tiles[x][y] = tile
end

function tilemap:draw(x, y)
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

return tilemap