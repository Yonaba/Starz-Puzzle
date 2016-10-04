-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Menu state
-------------------------------------------------------------------------------

local menuState = StateManager.new()
local colors, fade, text, star


function menuState:enter()
	-- display colors
  colors = {}
  colors.base_color = {255, 255, 255}
  colors.highlight_color = {240, 240, 30}
  colors.title_color = {240, 240, 30, 255}

  -- Menu entries
  text = {}
  text.start_text, text.spacing = 320, 50
  text.selected_entry, text.selected_level = 1, 1
  text.max_levels = #love.filesystem.enumerate('levels')
  text.entries = {'Play','','Options','Exit'}
  if love.filesystem.exists('scores.lua') then
    table.insert(text.entries,4,'Reset Scores')
  end
  text.update_entries = function(self)
      local buf = 'Level : %s%d%s'
      local prefix_string, suffix_string = '',''
        if self.selected_level == 1 then prefix_string, suffix_string = '', '>'  
        elseif self.selected_level == self.max_levels then prefix_string, suffix_string = '<', ''  
        else prefix_string, suffix_string = '<', '>'    
        end
      self.entries[2] = buf:format(prefix_string, self.selected_level, suffix_string)
    end
  
  star = {img = Asset.Image.Star_Big}
  star.x, star.y = (love.graphics.getWidth()/2), 230
  star.angle = 0
  star.rotate = function(self, dt)
      star.angle = math.cycle(star.angle + dt*3,0,math.tau)
    end
  
  Input.bindKeys(function()
    local entry = text.entries[text.selected_entry]
    if entry == 'Play' then
      love.audio.play(Asset.Audio.Sound.Menu)
      StateManager.switch('game_state', {selected_level = text.selected_level})
    elseif entry == 'Options' then
      love.audio.play(Asset.Audio.Sound.Menu)
      StateManager.switch('options_state')
    elseif entry == 'Reset Scores' then
      if love.filesystem.exists('scores.lua') then
        assert(love.filesystem.remove('scores.lua'), 
               ('Error removing file: %s'):format(love.filesystem.getSaveDirectory()..'/scores.lua'))
        table.remove(text.entries,4)
        love.audio.play(Asset.Audio.Sound.Menu)
      end
    elseif entry == 'Exit' then
      love.audio.stop()
      love.event.push('quit')    
    end
  end, 'pressed','return')
  
  Input.bindKeys(function()
    local entry = text.entries[text.selected_entry]  
    if (entry:match('^Level')) then
      text.selected_level = math.clamp(text.selected_level-1,1,text.max_levels) 
      love.audio.play(Asset.Audio.Sound.Menu)
    end
  end,'pressed','left')
  
  Input.bindKeys(function()
    local entry = text.entries[text.selected_entry]  
    if (entry:match('^Level')) then 
      text.selected_level = math.clamp(text.selected_level+1,1,text.max_levels)
      love.audio.play(Asset.Audio.Sound.Menu)
    end
  end,'pressed','right')
  
  Input.bindKeys(function()
    text.selected_entry = math.cycle(text.selected_entry-1,1,#text.entries) 
    love.audio.play(Asset.Audio.Sound.Menu)    
  end,'pressed','up')

  Input.bindKeys(function()
    text.selected_entry = math.cycle(text.selected_entry+1,1,#text.entries) 
    love.audio.play(Asset.Audio.Sound.Menu)  
  end,'pressed','down')
  
  
  Asset.Audio.Music.Background:setLooping(true)
  love.audio.play(Asset.Audio.Music.Background)
end

function menuState:update(dt)
  text:update_entries()
  star:rotate(dt)
end

function menuState:draw()
  love.graphics.draw(Asset.Image.Menu_Background)
  love.graphics.draw(star.img, star.x, star.y,star.angle,1,1,48,99)
  
  love.graphics.setFont(Asset.Font[80])
  love.graphics.setColor(colors.title_color)
  love.graphics.printf('Starz Puzzle',0,80,love.graphics.getWidth(),'center')
  
  love.graphics.setFont(Asset.Font[40])
  for i,entry in ipairs(text.entries) do
    love.graphics.setColor(i==text.selected_entry and colors.highlight_color or colors.base_color)
    love.graphics.printf(entry,0, text.start_text+((i-1)*text.spacing),love.graphics.getWidth(),'center')
  end
  
  love.graphics.setFont(Asset.Font[10])
  love.graphics.setColor(colors.base_color)
  love.graphics.print('Game made with LOVE2D',640,590)
end

function menuState:keypressed(key, unicode)
  Input.listenKeysPressed(key)
end

function menuState:leave()
  Input.unbindKeys()
end

return menuState