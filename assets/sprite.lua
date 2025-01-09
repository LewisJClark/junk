local sprite = {}
sprite.__index = sprite

function sprite:new()
   local new_sprite = {
      speed = 0,
      frame = 1,
      origin_x = 0,
      origin_y = 0,
      scale_x = 1,
      scale_y = 1,
      flipped = false,
      mirrored = false,
      angle = 0,
   }
   return setmetatable(new_sprite, sprite)
end

function sprite:update(dt)
   self.frame = self.frame + self.speed * dt
   if self.frame > #self.frames + 1 then self.frame = 1 end
   if self.frame < 1 then self.frame = #self.frames end
end

function sprite:draw(x, y)
   local scaleX = self.flipped and self.scale_x * -1 or self.scale_x
   local scaleY = self.mirrored and self.scale_y * -1 or self.scale_y
   love.graphics.draw(self.image, self.frames[math.floor(self.frame)], x, y, math.rad(self.angle), scaleX, scaleY, self.origin_x, self.origin_y)
end

return sprite