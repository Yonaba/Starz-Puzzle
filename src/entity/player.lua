-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Payer management
-------------------------------------------------------------------------------

local MovingEntity = require 'src.entity.base.movingEntity'
local Player = MovingEntity:extends()

-- Init
function Player:__init(x,y, tile_width, tile_height, tile_gap_up, tile_gap_down)
  self:setGridPosition(x,y)
  self:setDimensions(tile_width, tile_height)
  self:setImg(Asset.Image.Character_Boy)
  self:setGap(tile_gap_up, tile_gap_down)
  self.grid_x, self.grid_y = self.x, self.y
  self.anim_counter = 0
  self.score = 0
end

-- Moves a block
function Player:moveRock(at_x, at_y, dir, entities)
  for _,rock in ipairs(entities.rocks) do
    if rock.grid_x == at_x and rock.grid_y == at_y then
      return not rock:push(dir, entities)
    end
  end
  return false
end

-- Collects a star
function Player:takeStar(at_x, at_y, entities)
  for _,star in ipairs(entities.stars) do
    if star.x == at_x and star.y == at_y then
      star:destroy()
      self.score = self.score + star:getValue()
      love.audio.play(Asset.Audio.Sound.Star)
      break
    end
  end
end

-- Takes a step
function Player:stepMove(dir, entities)
  local next_x, next_y = self:getNextGridPosition(dir)
  local tile = self:getTile(entities.tiles, next_x, next_y)
  if tile and not tile.is_wall then
    if not self:moveRock(next_x, next_y, dir, entities) then
      self:takeStar(next_x, next_y, entities)
      self.grid_x, self.grid_y = next_x, next_y
    end
  end
end

-- Animates player
function Player:animate(dt)
  self.anim_counter = self.anim_counter+dt
  if self.anim_counter > 0.6 then
    self.y = self.y + 0.1
    self.anim_counter = 0    
  end
end

-- Updates player
function Player:update(dt)
  self.super.update(self,dt)
  self:animate(dt)
end

-- Draws player
function Player:draw(relative_x, relative_y)
  self.super.draw(self,relative_x, relative_y)
end

return Player