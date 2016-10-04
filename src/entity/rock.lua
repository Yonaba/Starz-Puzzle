-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Rocks management
-------------------------------------------------------------------------------

local MovingEntity = require 'src.entity.base.movingEntity'
local Rock = MovingEntity:extends()

-- Init
function Rock:__init(x,y, tile_width, tile_height, tile_gap_up, tile_gap_down)
  self:setGridPosition(x,y)
  self:setDimensions(tile_width, tile_height)
  self:setImg(Asset.Image.Rock)
  self:setGap(tile_gap_up, tile_gap_down)
  self.grid_x, self.grid_y = self.x, self.y
end

-- pushes a rock
function Rock:push(dir, entities)
  local next_x, next_y = self:getNextGridPosition(dir)
  local tile = self:getTile(entities.tiles,next_x, next_y)
  if tile and not tile.is_wall then
    for _,rock in ipairs(entities.rocks) do
      if self~=rock and rock.grid_x == next_x and rock.grid_y==next_y then 
        return false 
      end
    end
    for _,star in ipairs(entities.stars) do
      if star.x == next_x and star.y==next_y then 
        return false 
      end
    end   
    self.grid_x, self.grid_y = next_x, next_y
    return true
  else  
    return false
  end
end

-- Updates a rock
function Rock:update(dt)
  self.super.update(self,dt)
end

-- Draws a rock
function Rock:draw(relative_x, relative_y)
  self.super.draw(self,relative_x, relative_y)
end

return Rock