-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Config file
-------------------------------------------------------------------------------

function love.conf(config)
  
  -- General config
  config.title = "Starz Puzzle"
  config.author = "Roland_Yonaba"
  config.url = "https://yonaba.github.io/Starz-Puzzle"
	--	config.version = "0.8.0"
	config.release = false
	config.identity = "starz puzzle"

  -- Window setting
  config.console = false
  config.screen = config.screen or config.window
  config.screen.width = 800
  config.screen.height = 600
  config.screen.fullscreen = false
  config.screen.vsync = false
  config.screen.fsaa = 0
	
	-- Audio setup
  config.modules.audio = true
  config.modules.sound = true

	-- Input
  config.modules.keyboard = true                           
  config.modules.mouse = true
  config.modules.joystick = false
  config.modules.touch = false
	
	-- Modules
  config.modules.image = true 
  config.modules.graphics = true
  config.modules.timer = true
  config.modules.event = true
  config.modules.physics = false
  config.modules.video = false
  config.modules.math = false
  config.modules.thread = false
end