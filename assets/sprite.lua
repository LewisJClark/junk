require "frengine.assets.assetLib"

Sprite = {}
Sprite.__index = Sprite

function Sprite:instance(spriteName)
   local newSprite = {
      speed = 0,
      frame = 1,
      origin = { x=0, y=0 },
      scale = { x=1, y=1 },
      flipped = false,
      mirrored = false,
      angle = 0,
   }
   local sprite = AssetLib.sprites[spriteName]
   for k,v in pairs(sprite) do
      newSprite[k] = v
   end
   return setmetatable(newSprite, Sprite)
end

function Sprite:update(dt)
   self.frame = self.frame + self.speed * dt
   if self.frame > #self.frames + 1 then self.frame = 1 end
   if self.frame < 1 then self.frame = #self.frames end
end

function Sprite:draw(x, y)
   local scaleX = self.flipped and self.scale.x * -1 or self.scale.x
   local scaleY = self.mirrored and self.scale.y * -1 or self.scale.y
   love.graphics.draw(self.image, self.frames[math.floor(self.frame)], x, y, math.rad(self.angle), scaleX, scaleY, self.origin.x, self.origin.y)
end