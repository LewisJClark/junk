Timer = {}
Timer.__index = Timer

function Timer:new(type, duration, action)
   local t = {
      type = type or "once",
      duration = duration,
      remaining = duration,
      action = action,
      running = true
   }
   return setmetatable(t, Timer)
end

function Timer:update(dt)
   if self.running ~= true then return end
   self.remaining = self.remaining - dt
   if self.remaining <= 0 then
      self.action()
      if self.type == "repeat" then
         self.remaining = self.duration
      end
   end
end

function Timer:pause() self.running = false end

function Timer:resume() self.running = true end

function Timer:reset()
   self.remaining = self.duration
end