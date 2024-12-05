local ease_funcs = {
   linear = function(p) return p end
}

local ease_formulae = {
   quad    = "p * p",
   cubic   = "p * p * p",
   quart   = "p * p * p * p",
   quint   = "p * p * p * p * p",
   expo    = "2 ^ (10 * (p - 1))",
   sine    = "-math.cos(p * (math.pi * .5)) + 1",
   circ    = "-(math.sqrt(1 - (p * p)) - 1)",
   back    = "p * p * (2.7 * p - 1.7)",
   elastic = "-(2^(10 * (p - 1)) * math.sin((p - 1.075) * (math.pi * 2) / .3))"
 }
 
 local makefunc = function(str, expr)
   local load = loadstring or load
   return load("return function(p) " .. str:gsub("%$e", expr) .. " end")()
 end
 
 for k, v in pairs(ease_formulae) do
   ease_funcs[k .. "in"] = makefunc("return $e", v)
   ease_funcs[k .. "out"] = makefunc([[
     p = 1 - p
     return 1 - ($e)
   ]], v)
   ease_funcs[k .. "inout"] = makefunc([[
     p = p * 2
     if p < 1 then
       return .5 * ($e)
     else
       p = 2 - p
       return .5 * (1 - ($e)) + .5
     end
   ]], v)
 end

-- Tween.
Tween = {}
Tween.__index = Tween

function Tween:new(target, duration, params)
   local t = {
      controller = nil, -- Instance of tweener that tween belongs to.
      progress = 0,
      delay = 0,
      paused = false,
      target = target,
      duration = duration,
      params = {},
      progress = 0,
      rate = 1 / duration,
      _ease = ease_funcs.quadout,
      _on_update = nil,
      _on_complete = nil
   }
   for k,v in pairs(params) do
      t.params[k] = {
         start = target[k],
         diff = v - target[k],
      }
   end
   return setmetatable(t, Tween)
end

function Tween:after(amount)
   self.delay = amount
   return self
end

function Tween:ease(ease)
   self._ease = ease_funcs[ease]
   return self
end

function Tween:onUpdate(fn)
   self._update = fn
   return self
end

function Tween:onComplete(fn)
   self._complete = fn
   return self
end

function Tween:stop()
   controller:remove(self)
end

-- tweener.
local tweener = {}
tweener.__index = tweener

function tweener:new()
   local t = { tweens = {} }
   return setmetatable(t, tweener)
end

function tweener:to(target, duration, params)
   local new_tween = Tween:new(target, duration, params)
   new_tween.controller = self
   self.tweens[target] = new_tween
   return new_tween
end

function tweener:update(dt)
   for k,tween in pairs(self.tweens) do
      if not tween.paused then
         if tween.delay > 0 then
            tween.delay = tween.delay - dt
         else
            tween.progress = tween.progress + (tween.rate * dt)
            local eased_progress = tween.progress >= 1 and 1 or tween._ease(tween.progress)
            for k,param in pairs(tween.params) do
               tween.target[k] = param.start + (param.diff * eased_progress)
            end
            if tween.progress >= 1 then 
               self.tweens[k] = nil
               if tween._complete then tween._complete() end
            end
            if tween._update then tween._update() end
         end
      end
   end
end

function tweener:remove(tween)
   self.tweens[tween] = nil
end

return tweener