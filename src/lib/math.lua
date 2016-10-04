-------------------------------------------------------------------------------
-- Copyright (c) 2012 - Roland Yonaba
-- Math extensions
-------------------------------------------------------------------------------

-- Clamp value
function math.clamp(value, min, max)
  return value < min and min or math.min(value,max)
end

-- Clamp and loop within bounds
function math.cycle(value, min, max)
  return ((value > max) and min or ((value < min and max) or value))
end

-- Interpolate
function math.interpolate(min_var, max_var, other_var, other_min, other_max)
  return (((other_var - other_min)*(max_var - min_var))/(other_max - other_min))+ min_var
end

-- Pi's double
math.tau = math.pi*2
