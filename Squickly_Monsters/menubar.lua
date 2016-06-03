local widget = require("widget")
local composser = require("composer")
require("Npanel")

local menuBar;

function handleButtonEvent(event)
  local phase = event.phase
  if phase == "ended" then
    if menuBar.completeState == "hidden" then
      menuBar:show()
      menuBar.completeState = "shown"
    else
      menuBar:hide()
      menuBar.completeState = "hidden"
    end
  end
end

function setUpMenuBar()
  menuBar = widget.newPanel{
    speed = 1000,
    inEasing = easing.outBack,
    outEasing = easing.outCubic,
  }
  menuBar:show()
  menuBar.background = display.newRect(0, 0, menuBar.width, menuBar.height)
  menuBar.background:setFillColor(0, 0, 0, 120/255)
  menuBar:insert(menuBar.background)

  menuBar.sildeButton = widget.newButton{
    top = 135,
    left = 378,
    width = 50,
    height = 50,
    defaultFile = "happy.png",
    overFile = "angry.png",
    onEvent = handleButtonEvent,
  }

  menuBar.homeButton = widget.newButton{
    top = -140,
    left = -60,
    width = 50,
    height = 50,
    defaultFile = "happy.png",
    overFile = "angry.png",
  }
  menuBar.shopButton = widget.newButton{
    top = -70,
    left = -60,
    width = 50,
    height = 50,
    defaultFile = "happy.png",
    overFile = "angry.png",
  }
  menuBar.miniGameButton = widget.newButton{
    top = -10,
    left = -60,
    width = 50,
    height = 50,
    defaultFile = "happy.png",
    overFile = "angry.png",
  }

  menuBar.settingButton = widget.newButton{
    top = 10,
    left = -60,
    width = 50,
    height = 50,
    defaultFile = "happy.png",
    overFile = "angry.png",
  }


  menuBar:insert(menuBar.slideButton)
  -- menuBar:insert(menuBar.homeButton)
  -- menuBar:insert(menuBar.miniGameButton)
  -- menuBar:insert(menuBar.settingButton)

end

function getMenuBar()
  return menuBar
end
