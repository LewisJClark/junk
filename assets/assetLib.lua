require "frengine.utils"

AssetLib = {
   images = {},
   sprites = {},
   sounds = {}
}

function AssetLib:load()
   -- Load the raw image files.
   local spriteFiles = GetFiles("assets/images")
   for _,v in ipairs(spriteFiles) do
      local filename, _ = v:match("^.+/(.+)%.(.+)$")
      self.images[filename] = love.graphics.newImage(v)
   end
   -- Then load the sprites that use them.
   self.sprites = require("assets/sprites")
   for k,v in pairs(self.sprites) do
      local image = self.images[v.imageName]
      for i,frame in pairs(v.frames) do
         v.frames[i] = love.graphics.newQuad(frame[1], frame[2], frame[3], frame[4], image:getWidth(), image:getHeight())
      end
      self.sprites[k].image = image
   end
end
