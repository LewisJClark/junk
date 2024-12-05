-- Small wrapper for the love2d particle system.
-- Inspired in part by the GameMaker particle API.

local particleEmitter = {}
particleEmitter.__index = particleEmitter

-- Create a new particle emitter at the given position,
-- capable of emitting maxParticles at once.
function particleEmitter:new(x, y, type, maxParticles)
   local pe = {
      base = love.graphics.newParticleSystem(type.image, maxParticles or 1000),
      x = x,
      y = y,
      width = 0,
      height = 0,
      distribution="normal",
      particle_type = nil
   }
   particleEmitter.setParticleType(pe, type)
   return setmetatable(pe, particleEmitter)
end

function particleEmitter:setParticleType(type)
   if type == self.particle_type then return end
   self.particle_type = type
   if type.image then self.base:setTexture(type.image) end
   if type.origin then self.base:setOffset(type.origin[1], type.origin[2]) end
   if type.direction then self.base:setDirection(math.rad(type.direction)) end
   if type.lifetime then self.base:setParticleLifetime(type.lifetime[1], type.lifetime[2]) end
   if type.size then self.base:setSizes(type.size[1], type.size[2]) end
   if type.gravity then self.base:setLinearAcceleration(type.gravity[1], type.gravity[2], type.gravity[3], type.gravity[4]) end
   if type.rotation then self.base:setRotation(math.rad(type.rotation)) end
   if type.speed then self.base:setSpeed(type.speed[1], type.speed[2]) end
end

function particleEmitter:setArea(x, y, w, h)
   self.x = x
   self.y = y
   self.width = w
   self.height = h
   self.base:setPosition(x, y)
   self.base:setEmissionArea(self.distribution, w, h)
   return self
end

function particleEmitter:setDistribution(distribution)
   self.distribution = distribution
   self.base:setEmissionArea(distribution, self.width, self.height)
   return self
end

function particleEmitter:setDuration(duration)
   self.base:setEmitterLifetime(duration)
   return self
end

function particleEmitter:setRate(rate)
   self.base:setEmissionRate(rate)
   return self
end

function particleEmitter:setPosition(x, y)
   self.x = x
   self.y = y
   self.base:setPosition(x, y)
   return self
end

function particleEmitter:start() self.base:start() end

function particleEmitter:update(dt) self.base:update(dt) end

function particleEmitter:draw() love.graphics.draw(self.base, 0, 0) end

function particleEmitter:stop() self.base:stop() end

function particleEmitter:reset() self.base:reset() end

function particleEmitter:stream(type)
   self:setParticleType(type)
   self.base:reset()
   self.base:start()
end

function particleEmitter:burst(amount, type)
   if type then self:setParticleType(type) end
   self.base:emit(amount)
end

return particleEmitter