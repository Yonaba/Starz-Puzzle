-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Table extensions
-------------------------------------------------------------------------------

local tostring = tostring

-- Serialises an array table
function table.serialize(t, file_path)
	local string_buffer = 'return {\n%s\n }'
	local temp_pattern = '\t["%s"] = %s,\n'
  local temp_buffer = ''
	for key,value in pairs(t) do
		temp_buffer = temp_buffer .. temp_pattern:format(tostring(key),tostring(value))
	end
	return love.filesystem.write(file_path,string_buffer:format(temp_buffer))
end

-- Deserializes
function table.deserialize(file_path)
  local chunk = love.filesystem.load(file_path)
  if chunk then return chunk() end
end

-- CLones a table
function table.copy(t)
  local new_t = {}
  for key,value in pairs(t) do
    new_t[key] = value
  end
  return new_t
end