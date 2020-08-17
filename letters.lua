local letters = {}

local VirtualKeyboard = {}
function VirtualKeyboard:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end
function VirtualKeyboard:draw()

end

-- 
local HoverKeyboard = VirtualKeyboard:new()



letters.HoverKeyboard = HoverKeyboard
return letters
