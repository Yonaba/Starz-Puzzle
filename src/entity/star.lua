-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Stars management
-------------------------------------------------------------------------------

local StaticEntity = require 'src.entity.base.staticEntity'
local Star = StaticEntity:extends()

-- Init
function Star:__init(x,y, tile_width, tile_height, tile_gap_up, tile_gap_down)
  self:setGridPosition(x,y)
  self:setDimensions(tile_width, tile_height)
  self:setGap(tile_gap_up, tile_gap_down)
  
  -- Particle effect
  local particleSystem = love.graphics.newParticleSystem(Asset.Image.Star, 8)
  particleSystem:setEmissionRate(3)
  if particleSystem.setParticleLife then
    particleSystem:setParticleLife(2)
  else
    particleSystem:setParticleLifetime(2)
  end
  if particleSystem.setGravity then
    particleSystem:setGravity(-20)
  else
    particleSystem:setLinearAcceleration(0, -20)
  end
  if particleSystem.setSizes then
    particleSystem:setSizes(1.0, 0.8, 0.4, 0.1)
  else
    particleSystem:setSize(1.0, 0.2)
  end
  self:setImg(particleSystem)
  
  self.min_value, self.max_value = 100, 1000
  self.value = self.max_value                                               
  self.is_living = true
  self.start_reducing = false
end

-- Updates a star
function Star:updateState(dt)
  if self.start_reducing then
    self.scale_x = math.clamp(self.scale_x - 3*dt, 0, 1)
    self.scale_y = math.clamp(self.scale_y - 3*dt, 0, 1)
  end
  if self.scale_x == 0 or self.scale_y == 0 then
    self.img:stop()
    self.is_living = false
  end
end

-- Kills a star
function Star:destroy()
  self.start_reducing = true
end

-- Checks if a star is dead
function Star:isDead()
  return not self.is_living
end

-- Gets the value of a collected star
function Star:getValue()
  return self.value
end

-- Updates a star value
function Star:updateValue(timeObj)
  self.value = math.floor(math.interpolate(self.min_value, self.max_value, timeObj:getValue(), timeObj:getBounds()))
  self.value = math.clamp(self.value,self.min_value, self.max_value)
end

-- Updates a star
function Star:update(dt, timeObj)
  self:updateValue(timeObj)
  self.img:update(dt)
  if not self:isDead() then 
    self:updateState(dt)
  end
end

-- Draws a star
function Star:draw(relative_x, relative_y)
  self.super.draw(self,relative_x+self.width/2, relative_y+self.height/2)
end

return Star