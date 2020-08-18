local TextField = {
  text = "",
  placeholder = "",
  position = lovr.math.newVec3(0, 0, 0),
  width = 6,
  font = lovr.graphics.getFont(),
  isKey = false,
  caps = false,
  isHighlighted = false,
  onReturn = function(field, text) return true end -- whether to insert the return or not 
}

function TextField:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  -- TODO: Update collider to match size when text changes
  o.collider = TextField.letters.world:newBoxCollider(o.position.x, o.position.y, o.position.z, o.width, o.font:getHeight(), 0.1)
  o.collider:setUserData(o)
  return o
end
function TextField:remove()
  self.collider:destroy()
end
function TextField:draw()
  -- todo: figure out why this doesn't stick
  self.font:setPixelDensity(64)

  local totalWidth, lines = self.font:getWidth(self.text, wrap)
  local lastLine = string.match(self.text, "[^%c]*$")
  local lastLineWidth = self.font:getWidth(lastLine)
  local height = self.font:getHeight()

  lovr.graphics.setShader()
  lovr.graphics.setColor(1, 1, 1, self.isKey and 1.0 or (self.isHighlighted and 0.9 or 0.7))
  lovr.graphics.plane(
    'fill',
    self.position.x + self.width/2, self.position.y - (height*lines)/2, self.position.z - 0.01,
    self.width, height * lines
  )

  if self.text == "" then
    -- grayed out placeholder text
    lovr.graphics.setColor(0.7, 0.7, 0.7)
  else
    lovr.graphics.setColor(0, 0, 0)
  end
  lovr.graphics.setFont(self.font)
  local wrap = self.width
  lovr.graphics.print(
    self.text ~= "" and self.text or self.placeholder, 
    self.position.x, self.position.y, self.position.z, 
    1, -- scale
    0, 0, 1, 0, -- rotation
    wrap,
    'left',
    'top'
  )

  lovr.graphics.setColor(0, 0, 0, math.sin(lovr.timer.getTime()*5)*0.5 + 0.6)
  if self.isKey then
    lovr.graphics.line(
      self.position.x + lastLineWidth + 0.03, self.position.y - height*(lines-1), self.position.z,
      self.position.x + lastLineWidth + 0.03, self.position.y - height*lines, self.position.z
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
    if self.onReturn(self, self.text) then
      self.text = self.text .. "\n"
    end
  elseif code == "lshift" or code == "rshift" then
    self.caps = true
  elseif code == "escape" then
    self:resignKey()
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


function TextField:select()
end
function TextField:deselect()

end
function TextField:actuate()
  self:makeKey()
end
function TextField:highlight()
  self.isHighlighted = true
end
function TextField:dehighlight()
  self.isHighlighted = false
end

function TextField:makeKey()
  if TextField.letters.currentEditor then
    TextField.letters.currentEditor:resignKey()
  end
  TextField.letters.currentEditor = self

  self.isKey = true
  self.oldPressedHandler = lovr.handlers["keypressed"]
  self.oldReleasedHandler = lovr.handlers["keyreleased"]
  lovr.handlers["keypressed"] = function(a, b, c) self:onKeyPressed(a,b,c) end
  lovr.handlers["keyreleased"] = function(a, b) self:onKeyReleased(a,b) end
  TextField.letters.displayKeyboard()
end
function TextField:resignKey()
  TextField.letters.currentEditor = nil
  self.isKey = false
  lovr.handlers["keypressed"] = self.oldPressedHandler
  lovr.handlers["keyreleased"] = self.oldReleasedHandler
  self.oldPressedHandler = nil
  self.oldReleasedHandler = nil
  TextField.letters.hideKeyboard()
end

return TextField