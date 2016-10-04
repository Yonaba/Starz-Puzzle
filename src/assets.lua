-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Assets loading
-------------------------------------------------------------------------------

local setmetatable = setmetatable
local t_insert = table.insert
local Asset = {}

-- Images
Asset.Image = setmetatable({},{__index = function(self, image_file_name)
    self[image_file_name] = love.graphics.newImage(('assets/img/%s.png'):format(image_file_name))
    self[image_file_name]:setFilter('nearest','nearest')
    return self[image_file_name]
  end})

-- Fonts
Asset.Font = setmetatable({},{__index = function(self, font_size)
    self[font_size] = love.graphics.newFont('assets/fonts/Sniglet_Regular.ttf', font_size)
    return self[font_size]
  end})

-- Mp3 Audio
Asset.Audio = {}
Asset.Audio.Music = setmetatable({},{__index = function(self, audio_file_name)
    self[audio_file_name] = love.audio.newSource(('assets/audio/%s.mp3'):format(audio_file_name),'stream')
    if Config then self[audio_file_name]:setVolume(Config.music_volume) end
    return self[audio_file_name]
  end})

-- Ogg Audio
Asset.Audio.Sound = setmetatable({},{__index = function(self, audio_file_name)
    self[audio_file_name] = love.audio.newSource(('assets/audio/%s.ogg'):format(audio_file_name),'static')
    if Config then self[audio_file_name]:setVolume(Config.sound_volume) end
    return self[audio_file_name]
  end})

-- Audio volume settings for mp3  
function Asset.Audio.updateMusicVolume(vol)
  for _,music in pairs(Asset.Audio.Music) do
    music:setVolume(vol)
  end
end

-- Audio volume settings for ogg  
function Asset.Audio.updateSoundVolume(vol)
  for _,sound in pairs(Asset.Audio.Sound) do
    sound:setVolume(vol)
  end
end

return Asset