-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Game over state
-------------------------------------------------------------------------------

local gameOverState = StateManager.new()
local from_level, background, highlight_color

function gameOverState:enter(_,args)
  highlight_color = {240, 240, 30}
  from_level = args.current_level
  
  Input.bindKeys(function()
    StateManager.switch('game_state', {selected_level = from_level})
  end,'pressed','r')

  Input.bindKeys(function()
    StateManager.switch('menu_state')
  end,'pressed',';')
  
end

function gameOverState:draw()
  love.graphics.setColor(highlight_color)
  love.graphics.setFont(Asset.Font[80])
  love.graphics.printf('Game over!',0,love.graphics.getHeight()/2-80,love.graphics.getWidth(),'center')
  
  love.graphics.setFont(Asset.Font[20])
  love.graphics.print('[R]estart',580,560)
  love.graphics.print('[M]enu',580,580)    
end

function gameOverState:keypressed(key)
  Input.listenKeysPressed(key)
end

function gameOverState:leave()
  Input.unbindKeys()
end

return gameOverState