-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Level file parsing
-------------------------------------------------------------------------------

local assert, tonumber, ipairs = assert, tonumber, ipairs

local Class = require 'src.lib.30log'
local LevelParser = Class()

-- loads and parse a level file
function LevelParser:load(level_file)
  assert(level_file, 'Argument (string/number) expected, got nil.')
  local level_data = love.filesystem.read(('levels/%s'):format(level_file))  
  assert(level_data, ('Error loading level %s.'):format(level_file))  
  return self:parseData(level_data, level_file)
end

-- Parses a level file data
function LevelParser:parseData(level_data, level_file)
  -- Gets maximum time per level
  local max_time = tonumber(level_data:match('^([%d]+)[\n\r]+'))
  assert(max_time, ('Maximum time not found in level %s header'):format(level_file))
  level_data = level_data:gsub('^([%d]+)[\n\r]+','')
  
  -- Gets data row by row
  local data = {}
  local rowCount = 0
  for buffer in level_data:gmatch('[^\n\r]+') do
    rowCount = rowCount + 1
    local row = self:parseRow(buffer,rowCount, level_file)    
    data[#data+1] = row
  end
  
  -- Checking
  local rowLen = #data[1]
  for _,row in ipairs(data) do
    assert(#row == rowLen, ('Data parsing errors. Lines do not have the same sizes in level %s.txt'):format(level_file))
  end
  
  return {  
            width = #data[1] , height = #data, 
            data = data, 
            name = level_file, 
            max_time = max_time }
  
end

-- Parse a level row
function LevelParser:parseRow(str, row, level_file)
  assert(str, 'Argument string expected, got nil.')
  assert(not str:match('[^#%.%$%*%sx]'), 
    ('Unknown character found at line %d in level file %s.txt'):format(row, level_file))
  local t_row = {}
  for char in str:gmatch('(.)') do
    t_row[#t_row+1] = char
  end
  return t_row  
end

return LevelParser