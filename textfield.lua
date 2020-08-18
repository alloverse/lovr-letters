local TextField = {
  text = "",
  position = lovr.math.newVec3(0, 0, 0)
}

function TextField:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end
function TextField:draw()
  lovr.graphics.setShader()
  lovr.graphics.setColor(0, 0, 0)
  lovr.graphics.print(self.text, self.position.x, self.position.y, self.position.z, 1)
end
function TextField:update()
end

function TextField:onKeyPressed(code, scancode, repeated)
  if code == "backspace" then
    self.text = self.text:sub(1, -2)
  elseif code == "space" then
    self.text = self.text .. " "
  else
    self.text = self.text .. code
  end
end

function TextField:makeKey()
  self.oldHandler = lovr.handlers["keypressed"]
  lovr.handlers["keypressed"] = function(a, b, c) self:onKeyPressed(a,b,c) end
end
function TextField:resignKey()
  lovr.handlers["keypressed"] = self.oldHandler
  self.oldHandler = nil
end

return TextField