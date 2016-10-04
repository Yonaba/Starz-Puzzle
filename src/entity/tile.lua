-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Tiles management
-------------------------------------------------------------------------------

local StaticEntity = require 'src.entity.base.staticEntity'
local Tile = StaticEntity:extends()

-- Init
function Tile:__init(x,y, tile_width, tile_height, tile_gap_up, tile_gap_down, char_tile)
  self:setGridPosition(x,y)
  self:setDimensions(tile_width, tile_height)
  self.is_wall = (char_tile:match('[#x]') and true or false)
  self:setImg(self.is_wall and Asset.Image.Dirt_Block or Asset.Image.Grass_Block)
  self:setGap(tile_gap_up, tile_gap_down)
  self.is_hidden = (char_tile == 'x')
end

-- Draws a tile
function Tile:draw(relative_x, relative_y)
  if not self.is_hidden then 
    self.super.draw(self,relative_x, relative_y)
  end
end

return Tile