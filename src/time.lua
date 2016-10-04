-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Time management
-------------------------------------------------------------------------------

local assert, ceil, floor  = assert, math.ceil, math.floor

local Class = require 'src.lib.30log'
local Time = Class({
  time = 0, static = false, flow = 1,
  valid_flows = {increase = 1, decrease = -1}
})

-- Init
function Time:__init(init_time, static, flow, min_time, max_time)
  self.time = init_time or 0
  self.static = static or false
  self.min_time, self.max_time = 0, math.huge
  self:setBounds(min_time or 0, max_time or math.huge)
  self:setFlow(flow or 'increase')
end

-- Defines time counter direction
function Time:setFlow(flow_direction)
  assert(self.valid_flows[flow_direction],'Invalid flow direction')
  self.flow = self.valid_flows[flow_direction]
end

-- Sets time counter bounds
function Time:setBounds(min,max)
  self:setMin(min)
  self:setMax(max)
end

-- Gets time counter bounds
function Time:getBounds()
  return self.min_time, self.max_time
end

-- Sets time counter upper bound
function Time:setMax(value)
  assert(value > 0, 'Cannot set 0 as a maximum time value')
  assert(self.min_time < value , 'Cannot set a maximum value lower than the minimum value')
  self.max_time = value  
end

-- Sets time counter lower bound
function Time:setMin(value)
  assert(value >= 0, 'Cannot set 0 as a minimum time value')
  assert(self.max_time > value , 'Cannot set a minimum value higher than the maximum value')    
  self.min_time = value  
end

-- Checks if time counter is dead
function Time:isDead()
    return (self.flow == 1) and (self:getValue() == self.max_time) or (self:getValue() == self.min_time)
end

-- pauses time counter
function Time:pause()
  self.static = true
end

-- Resumes time counter
function Time:resume()
  self.static = false
end

-- Gets time counter value
function Time:getValue()
  return self.flow == 1 and ceil(self.time) or floor(self.time)
end

-- Updates time counter
function Time:update(dt)
  if not self.static then
    local new_tick_time = self.time + (dt*self.flow)
    self.time = math.clamp(new_tick_time,self.min_time, self.max_time)
    if self.time ~= new_tick_time then 
      self.static = false
    end
  end
end

-- Converts time counter value to hh:mm
function Time:getString()
  local count_seconds = self:getValue()
  if (count_seconds > 0) then
    local minutes, seconds = floor(count_seconds/60), count_seconds%60
    return ('%02d:%02d'):format(minutes, seconds)
  end
  return ('--:--')
end

return Time