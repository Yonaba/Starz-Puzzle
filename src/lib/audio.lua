-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Audio wrapper to rewind Sources when being stopped
-------------------------------------------------------------------------------

local old_love_audio_play = love.audio.play
function love.audio.play(source)
  if not source:isStopped() then
    source:rewind()
  else
    old_love_audio_play(source)
  end
end