local TextField = {
  text = "",
  position = lovr.math.newVec3(0, 0, 0),
  font = lovr.graphics.getFont(),
  isKey = false
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
  else
    self.text = self.text .. code
  end
end

function TextField:makeKey()
  self.isKey = true
  self.oldHandler = lovr.handlers["keypressed"]
  lovr.handlers["keypressed"] = function(a, b, c) self:onKeyPressed(a,b,c) end
end
function TextField:resignKey()
  self.isKey = false
  lovr.handlers["keypressed"] = self.oldHandler
  self.oldHandler = nil
end

return TextField