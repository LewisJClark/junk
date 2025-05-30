Assets = {
   root_dir = "game/assets/",
   fonts = {},
   images = {},
   sprites = {},
   sounds = {},
   shaders = {},
   tilesets = {}
}

function Assets:load()
   -- Load fonts.
   if love.filesystem.getInfo(Assets.root_dir .. "fonts.lua") ~= nil then
      self.fonts = require(Assets.root_dir .. "fonts")
      for k,v in pairs(self.fonts) do
         self.fonts[k] = love.graphics.newFont(v.file, v.size)
      end
   end

   -- Load the raw image files.
   local sprite_files = Utils.getFiles(Assets.root_dir .. "images")
   for _,v in ipairs(sprite_files) do
      local filename, _ = v:match("^.+/(.+)%.(.+)$")
      self.images[filename] = love.graphics.newImage(v)
   end

   self:loadParticles()

   -- Create any sprites.
   if love.filesystem.getInfo(Assets.root_dir .. "sprites.lua") ~= nil then
      self.sprites = require(Assets.root_dir .. "sprites")
      for k,sprite in pairs(self.sprites) do
         local image = self.images[sprite.image_name]
         if not sprite.frames then sprite.frames = {{0,0,image:getWidth(),image:getHeight()}} end
         if sprite.frames.count then
            -- TODO: Allow defining the rect of the first frame and then the number
            -- of sequential frames after it.
         end
         local first_frame = sprite.frames[1]
         if sprite.origin == "top_left" then
            sprite.origin_x = 0
            sprite.origin_y = 0
         elseif sprite.origin == "top_center" then
            sprite.origin_x = math.floor(first_frame[3] / 2)
            sprite.origin_y = 0
         elseif sprite.origin == "top_right" then
            sprite.origin_x = math.floor(first_frame[3]-1)
            sprite.origin_y = 0
         elseif sprite.origin == "center_left" then
            sprite.origin_x = 0
            sprite.origin_y = math.floor(first_frame[4] / 2)
         elseif sprite.origin == "centered" then 
            sprite.origin_x = math.floor(first_frame[3] / 2)
            sprite.origin_y = math.floor(first_frame[4] / 2)
         elseif sprite.origin == "center_right" then
            sprite.origin_x = math.floor(first_frame[3]-1)
            sprite.origin_y = math.floor(first_frame[4] / 2)
         elseif sprite.origin == "bottom_left" then
            sprite.origin_x = 0
            sprite.origin_y = math.floor(first_frame[4]-1)
         elseif sprite.origin == "bottom_center" then 
            sprite.origin_x = math.floor(first_frame[3] / 2)
            sprite.origin_y = math.floor(first_frame[4]-1)
         elseif sprite.origin == "bottom_right" then
            sprite.origin_x = math.floor(first_frame[3]-1)
            sprite.origin_y = math.floor(first_frame[4]-1)
         end
         for i,frame in ipairs(sprite.frames) do
            sprite.frames[i] = love.graphics.newQuad(frame[1], frame[2], frame[3], frame[4], image:getWidth(), image:getHeight())
         end
         self.sprites[k].image = image
      end
   end

   -- Create any tilesets.
   if love.filesystem.getInfo(Assets.root_dir .. "tilesets.lua") ~= nil then
      self.tilesets = require(Assets.root_dir .. "tilesets")
      for _,tileset in pairs(self.tilesets) do
         local image = self.images[tileset.imageName]
         local tilesAcross = image:getWidth() / tileset.tileWidth
         local tilesDown = image:getHeight() / tileset.tileHeight
         local tileCount = 1;
         tileset.tiles = {}
         for y=0,tilesDown-1 do
            for x=0,tilesAcross-1 do
               tileset.tiles[tileCount] = love.graphics.newQuad(x * tileset.tileWidth, y * tileset.tileHeight, tileset.tileWidth, tileset.tileHeight, image:getWidth(), image:getHeight())
               tileCount = tileCount + 1
            end
         end
         tileset.image = image
         tileset.tileCount = tileCount - 1
      end
   end

   -- Create any shaders.
   if love.filesystem.getInfo(Assets.root_dir .. "shaders.lua") ~= nil then
      self.shaders = require(Assets.root_dir .. "shaders")
      for key,config in pairs(self.shaders) do
         self.shaders[key] = love.graphics.newShader(Assets.root_dir .. config.fragment or "", Assets.root_dir .. config.vertex)
      end
   end
end

function Assets:createSprite(sprite_name)
   local sprite_to_instance = self.sprites[sprite_name]
   local new_sprite = Sprite:new()
   for k,v in pairs(sprite_to_instance) do
      new_sprite[k] = v
   end
   return new_sprite
end

function Assets:loadParticles()
   if love.filesystem.getInfo(Assets.root_dir .. "particles.lua") ~= nil then
      self.particles = love.filesystem.load(Assets.root_dir .. "particles.lua")()
      for _,v in pairs(self.particles) do
         v.image = self.images[v.image]
      end
   end
end