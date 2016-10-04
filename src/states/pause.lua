-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Pause state
-------------------------------------------------------------------------------

local pauseState = StateManager.new()

function pauseState:enter()
  Input.bindKeys(function()
    StateManager.switch('game_state')
  end,'pressed','escape')
end

function pauseState:draw()
  love.graphics.setFont(Asset.Font[80])
  love.graphics.printf('Pause',0,love.graphics.getHeight()/2-100,love.graphics.getWidth(),'center')
  love.graphics.setFont(Asset.Font[40])
  love.graphics.printf('Press Esc. to resume',0,(love.graphics.getHeight()/2),love.graphics.getWidth(),'center')
end

function pauseState:keypressed(key)
  Input.listenKeysPressed(key)   
end

function pauseState:leave()
  Input.unbindKeys()
end

return pauseState