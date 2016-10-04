-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Options state
-------------------------------------------------------------------------------

local serialize, copy = table.serialize, table.copy

local optionState = StateManager.new()
local colors,text,new_config

function optionState:enter()
  
  new_config = copy(Config)
    
  colors = {
    highlight_color = {255,255,0,255},
    base_color = {255,255,255,255},
    deactivated_color = {255,255,255,150},
  }
  
  -- Audio levels
  local volumes = {0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0}
  local selected_music_volume = (new_config.music_volume*10)+1
  local selected_sound_volume = (new_config.sound_volume*10)+1
  
  -- Menu entries
  text = {}
  text.entries = { '', '', '', '' }
  text.entries_supported = {
    love.graphics.checkMode(love.graphics.getWidth(), love.graphics.getHeight(),true),
    true,
    true,
    true,
  }
  text.start_text = 250
  text.spacing = 50
  text.selected_entry = 1
  text.update_entries = function(self)
    local prefix,suffix = '',''    
    prefix, suffix = '<','>'
    self.entries[1] = ('Fullscreen: %s%s%s'):format(prefix,new_config.fullscreen and 'On' or 'Off', suffix)
    
    prefix,suffix = '<','>'
    self.entries[2] = ('V-Sync: %s%s%s'):format(prefix, new_config.vsync and 'On' or 'Off',suffix)
    
    prefix = new_config.music_volume <= 0.0 and '' or '<'
    suffix = new_config.music_volume >= 1.0 and '' or '>'
    self.entries[3] = ('Music volume: %s%s%%%s'):format(prefix,new_config.music_volume*100,suffix)
    
    prefix = new_config.sound_volume <= 0.0 and '' or '<'
    suffix = new_config.sound_volume >= 1.0 and '' or '>'    
    self.entries[4] = ('Sounds volume: %s%s%%%s'):format(prefix,new_config.sound_volume*100,suffix)    
  end
  
  Input.bindKeys(function()
    love.audio.play(Asset.Audio.Sound.Menu)
    StateManager.switch('menu_state')
  end,'pressed','escape')
  
  Input.bindKeys(function()
    text.selected_entry = math.cycle(text.selected_entry+1,1,#text.entries)
    love.audio.play(Asset.Audio.Sound.Menu)    
  end,'pressed','down')

  Input.bindKeys(function()
    text.selected_entry = math.cycle(text.selected_entry-1,1,#text.entries)
    love.audio.play(Asset.Audio.Sound.Menu)    
  end,'pressed','up')
  
  Input.bindKeys(function(key)
    if text.selected_entry == 1 then
      if text.entries_supported[1] then
        new_config.fullscreen = not new_config.fullscreen
      end
    elseif text.selected_entry == 2 then
      new_config.vsync = not new_config.vsync
    elseif text.selected_entry == 3 then
      selected_music_volume = math.clamp(selected_music_volume+(key=='right' and 1 or -1),1,11)
      new_config.music_volume = volumes[selected_music_volume]
      Asset.Audio.updateMusicVolume(new_config.music_volume)
    elseif text.selected_entry == 4 then
      selected_sound_volume = math.clamp(selected_sound_volume+(key=='right' and 1 or -1),1,11)
      new_config.sound_volume = volumes[selected_sound_volume]
      Asset.Audio.updateSoundVolume(new_config.sound_volume)
    end
    love.audio.play(Asset.Audio.Sound.Menu)   
  end,'pressed','right','left')
  
  Input.bindKeys(function(key)
    assert(love.graphics.setMode(love.graphics.getWidth(), love.graphics.getHeight(), new_config.fullscreen, new_config.vsync,0),
            ('Error encountered when changing the display mode!'))
    for name,setting in pairs(new_config) do 
      Config[name] = setting 
    end
    love.audio.play(Asset.Audio.Sound.Menu)
    StateManager.switch('menu_state')
  end,'pressed','return')
  
end

function optionState:update(dt)
  text:update_entries()
end

function optionState:draw()
  love.graphics.setFont(Asset.Font[80])
  love.graphics.setColor(colors.highlight_color)
  love.graphics.printf('Options',0,80,love.graphics.getWidth(),'center')
  
  love.graphics.setFont(Asset.Font[40])
  for i,entry in ipairs(text.entries) do
    if not text.entries_supported[i] then 
      love.graphics.setColor(colors.deactivated_color)
      love.graphics.printf(entry,0, text.start_text+((i-1)*text.spacing),love.graphics.getWidth(),'center')   
    else
      love.graphics.setColor(i==text.selected_entry and colors.highlight_color or colors.base_color)
      love.graphics.printf(entry,0, text.start_text+((i-1)*text.spacing),love.graphics.getWidth(),'center')   
    end    
  end

  love.graphics.setFont(Asset.Font[10])
  love.graphics.setColor(colors.base_color)
  love.graphics.print('[Enter] : OK',650,580)
  love.graphics.print('[Esc] : Back to menu',650,590)
end

function optionState:keypressed(key)
  Input.listenKeysPressed(key)   
end

function optionState:leave()
  Asset.Audio.updateMusicVolume(Config.music_volume)
  Asset.Audio.updateSoundVolume(Config.sound_volume)
  serialize(Config,'config.lua')
  Input.unbindKeys()
end

return optionState