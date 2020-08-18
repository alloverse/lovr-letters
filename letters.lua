local letters = {
  HoverKeyboard = require('hoverkeyboard'),
  Button = require('button'),
  TextField = require('textfield'),
  Hand = require("hand")
}
-- Tie the module's classes together
for k, class in pairs(letters) do
  class.letters = letters
end

-- global state for the module
letters.hands = {}
letters.world = lovr.physics.newWorld()

-- Set this from your code to make that kind of keyboard
-- appear automatically when you focus a text field
letters.defaultKeyboard = nil

-- The keyboard currently being displayed automatically.
-- Don't touch this, it's private.
letters.currentKeyboard = nil

function letters.load()
  for i, device in ipairs(lovr.headset.getHands()) do
    local hand = letters.Hand:new{device=device}
    table.insert(letters.hands, hand)
  end
end

function letters.update()
  for i, hand in ipairs(letters.hands) do
    hand:update()
  end
  if letters.currentKeyboard then
    letters.currentKeyboard:update()
  end
end

function letters.draw()
  if letters.currentKeyboard then
    letters.currentKeyboard:draw()
  end
end

function letters.displayKeyboard()
  if not letters.currentKeyboard and letters.defaultKeyboard then
    -- todo: maybe save keyboard between invocations to save state
    letters.currentKeyboard = letters.defaultKeyboard:new()
  end
end

function letters.hideKeyboard()
  if letters.currentKeyboard then
    letters.currentKeyboard:remove()
  end
  letters.currentKeyboard = nil
end

return letters
