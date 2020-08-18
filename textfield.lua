local TextField = {
  text = "",
  position = lovr.math.newVec3(0, 0, 0),
  font = lovr.graphics.getFont(),
  isKey = false,
  caps = false
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
  lovr.graphics.setFont(self.font)
  local wrap = 0
  lovr.graphics.print(
    self.text, 
    self.position.x, self.position.y, self.position.z, 
    1, -- scale
    0, 0, 1, 0, -- rotation
    wrap,
    'left',
    'top'
  )
  local totalWidth, lines = self.font:getWidth(self.text, wrap)
  local lastLine = string.match(self.text, "[^%c]*$")
  local lastLineWidth = self.font:getWidth(lastLine)
  local height = self.font:getHeight()
  lovr.graphics.setColor(0, 0, 0, math.sin(lovr.timer.getTime()*5)*0.5 + 0.6)
  if self.isKey then
    lovr.graphics.line(
      self.position.x + lastLineWidth + 0.1, self.position.y - height*(lines-1), self.position.z,
      self.position.x + lastLineWidth + 0.1, self.position.y - height*lines, self.position.z
    )
  end
end
function TextField:update()
end

function TextField:onKeyPressed(code, scancode, repeated)
  if code == "backspace" then
    self.text = self.text:sub(1, -2)
  elseif code == "space" then
    self.text = self.text .. " "
  elseif code == "return" then
    self.text = self.text .. "\n"
  elseif code == "lshift" or code == "rshift" then
    self.caps = true
  elseif #code == 1 then
    if self.caps then
      code = string.upper(code)
    end
    self.text = self.text .. code
  end
end

function TextField:onKeyReleased(code, scancode)
  if code == "lshift" or code == "rshift" then
    self.caps = false
  end
end

function TextField:makeKey()
  self.isKey = true
  self.oldPressedHandler = lovr.handlers["keypressed"]
  self.oldReleasedHandler = lovr.handlers["keyreleased"]
  lovr.handlers["keypressed"] = function(a, b, c) self:onKeyPressed(a,b,c) end
  lovr.handlers["keyreleased"] = function(a, b) self:onKeyReleased(a,b) end
end
function TextField:resignKey()
  self.isKey = false
  lovr.handlers["keypressed"] = self.oldPressedHandler
  lovr.handlers["keyreleased"] = self.oldReleasedHandler
  self.oldPressedHandler = nil
  self.oldReleasedHandler = nil
end

return TextField