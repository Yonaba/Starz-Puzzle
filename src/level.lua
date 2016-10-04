-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Game levels management
-------------------------------------------------------------------------------

local assert, ipairs, tostring = assert, ipairs, tostring
local t_insert,t_remove = table.insert, table.remove

local Class = require 'src.lib.30log'
local LevelParser = require 'src.levelParser'
local Highscore = require 'src.highscore'
local Timer = require 'src.time'
local Tile = require 'src.entity.tile'
local Rock = require 'src.entity.rock'
local Star = require 'src.entity.star'
local Player = require 'src.entity.player'

local Level = Class()

-- Display colors
local colors = {
  highlight_color = {240, 240, 30},
  base_color = {255, 255, 255},
  warn_color_1 = {255, 10,10, 255},
  warn_color_2 = {255, 120,0, 255},
}

-- Init
function Level:__init(level)
  -- Loading level file
  local level = LevelParser:load(level)                                                              
  self.width = level.width
  self.height = level.height
  self.name = tostring(level.name)
  self.data = level.data
  
  -- Setting display constants
  self.tile_width, self.tile_height = 25, 43
  self.tile_gap_up, self.tile_gap_down = 13, 10
  self.tile_total_gap = self.tile_gap_up+self.tile_gap_down
  self.tile_drawn_height = self.tile_height - self.tile_total_gap
  self.object_layer_gap = 10
  self.origin_x = (love.graphics.getWidth()/2) -
                      (level.width*self.tile_width)/2
  self.origin_y = (love.graphics.getHeight()/2) - 
                    ((((level.height-1)*self.tile_drawn_height)+self.tile_total_gap)/2)
  
  -- Generating game objects entities
  self.entities = {tiles = {}, rocks = {}, stars = {}}
  for y,row in ipairs(self.data) do
    for x,char_tile in ipairs(row) do
      t_insert(self.entities.tiles, 
        Tile(x,y, self.tile_width, self.tile_height, self.tile_gap_up, self.tile_gap_down, char_tile))
      if char_tile == '.' then
        t_insert(self.entities.rocks, 
          Rock(x,y, self.tile_width, self.tile_height, self.tile_gap_up, self.tile_gap_down))
      elseif char_tile == '*' then
        t_insert(self.entities.stars, 
          Star(x,y, self.tile_width, self.tile_height, self.tile_gap_up, self.tile_gap_down))
      elseif char_tile == '$' then
        self.entities.player = 
          Player(x,y,self.tile_width, self.tile_height, self.tile_gap_up, self.tile_gap_down)
      end
    end
  end
  
  self.was_quitted = false
  self.is_clear = false
  self.new_best_score = false
  self.best_score = Highscore:get(self.name)
  self.time = Timer(level.max_time, true, 'decrease', 0, level.max_time)
  self.has_started = false
end

-- Update loop
function Level:updateEntities(dt)
  for _,rock in ipairs(self.entities.rocks) do 
    rock:update(dt) 
  end
  
  -- Reverse looping, as values can be removed safely
  for i = #self.entities.stars,1,-1 do
    local star = self.entities.stars[i]
    star:update(dt,self.time)
    if star:isDead() then 
      t_remove(self.entities.stars,i)
    end
  end  
  
  -- Updates player
  self.entities.player:update(dt)
end

-- Draw loop
function Level:drawEntities()
  for _,tile in ipairs(self.entities.tiles) do 
    tile:draw(self.origin_x,self.origin_y) 
  end
  
  for _,rock in ipairs(self.entities.rocks) do
    rock:draw(self.origin_x,self.origin_y-self.object_layer_gap)
  end
   
  self.entities.player:draw(self.origin_x, self.origin_y-self.object_layer_gap)
  
  for _,star in ipairs(self.entities.stars) do 
    star:draw(self.origin_x,self.origin_y-self.object_layer_gap) 
  end
end

-- Checks if level was completed
function Level:isFinished()
  if #self.entities.stars == 0 then
    self.time:pause()
    if not self.is_clear then
      if (self.entities.player.score > self.best_score) then        
        assert(Highscore:update(self.name, self.entities.player.score),
                'Error encountered when saving the current best score')
        self.best_score = self.entities.player.score
        self.new_best_score = true 
      end
    self.is_clear = true
    love.audio.play(Asset.Audio.Sound.Level_Complete)
    end
    return true
  end
  return false
end

-- Updates level
function Level:update(dt)
  if not self:isFinished() then
    if self.time:isDead() then
      self.was_quitted = true
      StateManager.switch('game_over_state', {current_level = self.name})
    end
    self.time:update(dt)
    self:updateEntities(dt)
  end
end

-- Draws level
function Level:draw()
  self:drawEntities()
  if not self.has_started then
    love.graphics.setColor(colors.highlight_color)
    love.graphics.setFont(Asset.Font[20]) 
    love.graphics.printf('Press any key to start!', 0, 50, love.graphics.getWidth(),'center')
  end
  
  if self.new_best_score then
    love.graphics.setFont(Asset.Font[40])
    love.graphics.setColor(colors.highlight_color)
    love.graphics.printf('Record!',0,470,love.graphics.getWidth(),'center')
  end
  
  if self.time:getValue() < 10 then
    if self.time:getValue()%2==0 then
      love.graphics.setColor(colors.warn_color_1)
    else
      love.graphics.setColor(colors.warn_color_2)
    end
  else
    love.graphics.setColor(colors.base_color)
  end
  love.graphics.setFont(Asset.Font[20]) 
  love.graphics.print('Remaining time : ' ..  self.time:getString(),5,540)
  
  if self.new_best_score then
    love.graphics.setColor(colors.highlight_color)
  else
    love.graphics.setColor(colors.base_color)
  end
  love.graphics.print('Score : ' ..  self.entities.player.score,5,560)
  love.graphics.print('Best score : ' ..  self.best_score,5,580)
  
  if self.is_clear then
    love.graphics.setFont(Asset.Font[20])
    love.graphics.setColor(colors.base_color)
    love.graphics.print(self.is_clear and '[N]ext level' or '[P]ause',580,540) 
    love.graphics.setFont(Asset.Font[40]) 
    love.graphics.setColor(colors.highlight_color)    
    love.graphics.printf('Level finished!',0,430,love.graphics.getWidth(),'center')      
  end
  love.graphics.setFont(Asset.Font[20])
  love.graphics.setColor(colors.base_color) 
  love.graphics.print('[R]estart',580,560)
  love.graphics.print('[M]enu',580,580)    
end


return Level