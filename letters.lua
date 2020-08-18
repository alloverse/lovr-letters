local letters = {
  HoverKeyboard = require('hoverkeyboard'),
  Button = require('button'),
  TextField = require('textfield'),
  Hand = require("hand")
}

for k, class in pairs(letters) do
  class.letters = letters
end

letters.hands = {}
letters.world = lovr.physics.newWorld()


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
end

return letters
