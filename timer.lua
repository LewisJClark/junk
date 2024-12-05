local timer = {}
timer.__index = timer

function timer:new(type, duration, callback)
   local t = {
      type = type or "once",
      duration = duration,
      remaining = duration,
      running = true,
      callback = callback
   }
   return setmetatable(t, timer)
end

function timer:every(interval, callback)
   return timer:new("repeat", interval, callback)
end

function timer:once(delay, callback)
   return timer:new("once", delay, callback)
end

function timer:update(dt)
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

function timer:pause() self.running = false end

function timer:resume() self.running = true end

function timer:reset()
   self.remaining = self.duration
end

return timer