-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Game state
-------------------------------------------------------------------------------

local tonumber, tostring = tonumber, tostring

local gameState = StateManager.new()
local Level, currentLevel

function gameState:init()
   Level = require 'src.level'
end

function gameState:enter(_,args)

  if not currentLevel or currentLevel.was_quitted then
    currentLevel = Level(args.selected_level)
  end
  
  Input.bindKeys(function()
    StateManager.switch('pause_state')
  end,'pressed','p')
  
  Input.bindKeys(function()
    currentLevel:__init(currentLevel.name)
  end,'pressed','r')
  
  Input.bindKeys(function()
    currentLevel.was_quitted = true
    StateManager.switch('menu_state')
  end,'pressed',';')
  
  Input.bindKeys(function()
    if currentLevel.is_clear then
      local current_level_number = tonumber(currentLevel.name)
      if (current_level_number < #(love.filesystem.enumerate or love.filesystem.getDirectoryItems)('levels')) then
        currentLevel:__init(tostring(current_level_number+1))
      else
        StateManager.switch('menu_state')
      end
    end
  end,'pressed','n')
  
  Input.bindKeys(function(key)
    if not currentLevel.is_clear then
      currentLevel.entities.player:stepMove(key,currentLevel.entities)
    end
  end,'pressed','up','down','left','right')
  
end

function gameState:update(dt)
  currentLevel:update(dt)
end

function gameState:draw()
  currentLevel:draw()
end

function gameState:keypressed(key)
  if key and not currentLevel.has_started then
    currentLevel.time:resume()
  end
  Input.listenKeysPressed(key)
end

function gameState:focus(f)
  if not f and not currentLevel.is_clear then
    StateManager.switch('pause_state') 
  end
end

function gameState:leave()
  Input.unbindKeys()
end

return gameState