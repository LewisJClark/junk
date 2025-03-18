Timer = {}
Timer.__index = Timer

function Timer:new(type, duration, callback)
   local t = {
      type = type or "once",
      duration = duration,
      remaining = duration,
      running = true,
      callback = callback
   }
   return setmetatable(t, Timer)
end

function Timer:every(interval, callback)
   return Timer:new("repeat", interval, callback)
end

function Timer:once(delay, callback)
   return Timer:new("once", delay, callback)
end

function Timer:runCallback()
   self.callback()
   return self
end

function Timer:update(dt)
   if self.running ~= true then return end
   self.remaining = self.remaining - dt
   if self.remaining <= 0 then
      self.callback()
      if self.type == "repeat" then
         self.remaining = self.duration
      else
         self.running = false
      end
   end
end

function Timer:pause() 
   self.running = false 
   return self
end

function Timer:resume() 
   self.running = true 
   return self
end

function Timer:reset()
   self.remaining = self.duration
   return self
end