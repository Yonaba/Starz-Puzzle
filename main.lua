-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Version : 0.0.2
-------------------------------------------------------------------------------

function love.load()
  require 'src.lib.math'
  require 'src.lib.table'
  require 'src.lib.audio'
  
  -- Config
  if not love.filesystem.exists('config.lua') then
    -- Default config
    Config = {}
    Config.fullscreen = false
    Config.vsync = false 
    Config.music_volume = 0.5
    Config.sound_volume = 0.5
    table.serialize(Config,'config.lua')
  else
    -- Loading saved config
    Config = table.deserialize('config.lua')
  end
  -- Setting up display
  if love.graphics.setMode then
    love.graphics.setMode(
        love.graphics.getWidth(), love.graphics.getHeight(),
        Config.fullscreen, Config.vsync, 0
    )
  else
    local msaa = "msaa"
    if love._version_major == 0 and love._version_minor < 10 then
      msaa = "fsaa"
    end
    love.window.setMode(
      love.graphics.getWidth(), love.graphics.getHeight(),
      {fullscreen=Config.fullscreen, vsync=Config.vsync, [msaa]=0}
    )
  end

  -- Libs
  Asset = require 'src.assets'
  Input = require 'src.lib.input'
  StateManager = require 'src.lib.gamestate'

  -- Gamestates
  StateManager.states = {}
  StateManager.states.menu_state = require 'src.states.menu'
  StateManager.states.game_state = require 'src.states.game'
  StateManager.states.pause_state = require 'src.states.pause'
  StateManager.states.game_over_state = require 'src.states.gameover'
  StateManager.states.options_state = require 'src.states.options'
  
  -- state switching shortcut
  local old_statemanager_switch = StateManager.switch
  function StateManager.switch(state_name,...)
    return old_statemanager_switch(StateManager.states[state_name],...)
  end
  
  -- Override L�ve callbacks with gamestates callbacks
  StateManager.registerEvents()
  
  -- Switch to menu state
  StateManager.switch('menu_state')
end
