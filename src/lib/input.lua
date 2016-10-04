-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Input management
-------------------------------------------------------------------------------

local assert, type = assert, type
local pairs, ipairs = pairs, ipairs

-- Validating args
local function checkCallback(callback)
    assert(type(callback) == 'function', 
    ('Wrong Argument #1. Expected function, got %s'):format(type(callback)))
end

local function checkEventType(self,input_type,event_type)
  assert(self._bindings[input_type][event_type], 
    'Wrong event type, should either be "pressed", "released" or "down"')
end

local function checkBindings(self,input_type, event_type,...)
  for _,key in ipairs({...}) do
    assert(self._bindings[input_type][event_type][key], 
      ('Cannot unbind a non-existing binding: %s.%s.%s'):format(input_type,event_type,key))
  end
end


local Input = {
  _bindings = {
    key = {pressed = {}, released = {}, down = {}},
    mouse = {pressed = {}, released = {}, down = {}},
  } 
}

-- Binds a callback to a key
function Input.bindKeys(callback,event_type,...)
  checkCallback(callback)
  checkEventType(Input,'key', event_type)
  for _,key in ipairs({...}) do
    Input._bindings.key[event_type][key] = callback
  end
end

-- Binds a callback to a mouse button
function Input.bindButtons(callback,event_type,...)
  checkCallback(callback)
  checkEventType(Input,'mouse', event_type)
  for _,button in ipairs({...}) do
    Input._bindings.mouse[event_type][button] = callback
  end
end

-- unbinds a callback to a key
function Input.unbindKeys(event_type,...)
  if event_type then
    checkEventType(Input,'key', event_type)  
    local keys = {...}
    if #keys>0 then 
      checkBindings(Input,'key', event_type,...)
      for _,key in ipairs(keys) do
        Input._bindings.key[event_type][key] = nil
      end
    else 
      Input._bindings.key[event_type] = {}
    end
  else
    Input._bindings.key = { pressed = {}, released = {}, down = {} }
  end
end

-- Unbinds a callback to a mouse button
function Input.unbindButtons(event_type,...)
  if event_type then
    checkEventType(Input,'mouse',event_type)
    local buttons = {...}
    if #buttons>0 then 
      checkBindings(Input,'mouse', event_type,...)
      for _,button in ipairs(buttons) do
        Input._bindings.mouse[event_type][button] = nil
      end
    else
      Input._bindings.mouse[event_type] = {}  
    end
  else
    Input._bindings.mouse = { pressed = {}, released = {}, down = {} }  
  end
end

-- Returns a reference to callback bound to a key
function Input.getKeyCallback(key,event_type)
  checkEventType(Input,'key',event_type)
  return Input._bindings.key[event_type][key]
end

-- Returns a reference to callback bound to a mouse button
function Input.getButtonCallback(button,event_type)
  checkEventType(Input,'mouse',event_type)
  return Input._bindings.mouse[event_type][button]
end

-- Resolves events on key presses
function Input.listenKeysPressed(key,...)
  local callback = Input._bindings.key.pressed[key]
  if callback then callback(key,...) end
end

-- Resolves events on key releases
function Input.listenKeysReleased(key,...)
  local callback = Input._bindings.key.released[key]
  if callback then callback(key,...) end
end

-- Resolves events on key down
function Input.listenKeysDown(...)
  for key,callback in pairs(Input._bindings.key.down) do
    if love.keyboard.isDown(key) then callback(key,...) end
  end
end

-- Resolves events on mouse button presses
function Input.listenButtonsPressed(button,...)
  local callback = Input._bindings.mouse.pressed[button] 
  if callback then callback(button,...) end
end

-- Resolves events on mouse button releases
function Input.listenButtonsReleased(button,...)
  local callback = Input._bindings.mouse.released[button] 
  if callback then callback(button,...) end
end

-- Resolves events on mouse button 'down'
function Input.listenButtonsDown(...)
  for button,callback in pairs(Input._bindings.mouse.down) do
    if love.mouse.isDown(button) then callback(button,...) end
  end
end

-- button down wrapper
function Input.listenInputsDown(...)
  Input.listenKeysDown(...)
  Input.listenButtonsDown(...)  
end

return Input