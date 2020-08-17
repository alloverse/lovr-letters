# lovr-letters
A [lovr.org](https://lovr.org) extension library that adds virtual keyboards for text input in VR.

## Usage

`letters` needs to be initialized from load(). Then you can create your keyboard of choice.
The `letters` module needs to be `update()`d each frame, and the keyboard(s) you are using
needs to be `update()`d and `draw()`n as well.

```
local letters = require('letters')
function lovr.load()
  letters.load()
  myKeyboard = letters.HoverKeyboard:new{world=letters.world}
end

function lovr.update()
  letters.update()
  myKeyboard:update()
end

function lovr.draw()
  myKeyboard:draw()
end
```

The keyboard events are delivered as if it was a physical keyboard. Use the keyboard
events to read input:

```
function lovr.load()
  lovr.handlers["keypressed"] = function(code, scancode, repetition)
    print(code)
  end
end
```