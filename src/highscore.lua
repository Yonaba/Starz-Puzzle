-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Highscores management
-------------------------------------------------------------------------------

local assert, ipairs = assert, ipairs
local serialize, deserialize = table.serialize, table.deserialize

local Class = require 'src.lib.30log'
local Highscore = Class()

-- Init
function Highscore:__init(base_score, comparison_function)
  self.base_score = base_score or 0
  self.comparison_function = comparison_function or function(a,b) return a > b end
  self.score_file_name = 'scores.lua'
  self:load()
end

-- Loads (or creates) scores savefile
function Highscore:load()
  if not love.filesystem.exists(self.score_file_name) then
    self.best_scores = {}
    return
  else
    local best_scores = deserialize(self.score_file_name)
    assert(best_scores,('Error loading %s/%s.lua'):format(love.filesystem.getSaveDirectory(), self.score_file_name))
    self.best_scores = best_scores 
  end
end

-- Gets the best highscore for a given level
function Highscore:get(level_name)
  assert(love.filesystem.exists(('levels/%s'):format(level_name)),'Not an existing level')
  if not self.best_scores[level_name] then
    self.best_scores[level_name] = self.base_score
  end
  return self.best_scores[level_name]
end

-- Saves highscores
function Highscore:save()
  return serialize(self.best_scores,self.score_file_name)
end

-- Updates highscore
function Highscore:update(level_name, score)
  assert(love.filesystem.exists(('levels/%s'):format(level_name)),'Not an existing level')    
  assert(not self.comparison_function(self.best_scores[level_name] or 0, score) , 'Can only update with a better score')  
  self.best_scores[level_name] = score
  return self:save(self.best_scores)
end

return Highscore()