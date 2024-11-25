require "frengine.utils"

AssetLib = {
   images = {},
   sprites = {},
   sounds = {},
   shaders = {}
}

function AssetLib:load()
   -- Load the raw image files.
   local spriteFiles = GetFiles("assets/images")
   for _,v in ipairs(spriteFiles) do
      local filename, _ = v:match("^.+/(.+)%.(.+)$")
      self.images[filename] = love.graphics.newImage(v)
   end

   -- Create any sprites.
   if love.filesystem.getInfo("assets/sprites.lua") ~= nil then
      self.sprites = require("assets/sprites")
      for k,sprite in pairs(self.sprites) do
         local image = self.images[sprite.imageName]
         for i,frame in ipairs(sprite.frames) do
            sprite.frames[i] = love.graphics.newQuad(frame[1], frame[2], frame[3], frame[4], image:getWidth(), image:getHeight())
         end
         self.sprites[k].image = image
      end
   end

   -- Create any tilesets.
   if love.filesystem.getInfo("assets/tilesets.lua") ~= nil then
      self.tilesets = require("assets/tilesets")
      for _,tileset in pairs(self.tilesets) do
         local image = self.images[tileset.imageName]
         local tilesAcross = image:getWidth() / tileset.tileWidth
         local tilesDown = image:getHeight() / tileset.tileHeight
         local tileCount = 1;
         tileset.tiles = {}
         for y=0,tilesDown do
            for x=0,tilesAcross do
               tileset.tiles[tileCount] = love.graphics.newQuad(x * tileset.tileWidth, y * tileset.tileHeight, tileset.tileWidth, tileset.tileHeight, image:getWidth(), image:getHeight())
               tileCount = tileCount + 1
            end
         end
         tileset.image = image
         tileset.tileCount = tileCount - 1
      end
   end

   -- Create any shaders.
   if love.filesystem.getInfo("assets/shaders.lua") ~= nil then
      self.shaders = require("assets/shaders")
      for key,config in pairs(self.shaders) do
         self.shaders[key] = love.graphics.newShader(config.fragment or "", config.vertex or "")
      end
   end
end
