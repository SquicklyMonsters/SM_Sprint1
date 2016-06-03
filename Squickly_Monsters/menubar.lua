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
    width = 150,
    height = 300,
    inEasing = easing.outBack,
    outEasing = easing.outCubic,
  }
  menuBar:show()
  menuBar.background = display.newRect(0, 0, menuBar.width, menuBar.height)
  menuBar.background:setFillColor(1, 1, 1, 120/255)
  menuBar:insert(menuBar.background)

  local startX = -130
  local spacingX = 70
  local middleY = -20

  menuBar.slideButton = widget.newButton{
    top = startX + (spacingX*3)/2,
    left = middleY - 55,
    width = 50,
    height = 50,
    defaultFile = "img/others/slideButton.png",
    --overFile = "angry.png",
    onEvent = handleButtonEvent,
  }

  menuBar.homeButton = widget.newButton{
    top = startX,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = "happy.png",
    overFile = "angry.png",
  }
  menuBar.shopButton = widget.newButton{
    top = startX + spacingX,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = "happy.png",
    overFile = "angry.png",
  }
  menuBar.miniGameButton = widget.newButton{
    top = startX + spacingX*2,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = "happy.png",
    overFile = "angry.png",
  }

  menuBar.settingButton = widget.newButton{
    top = startX + spacingX*3,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = "happy.png",
    overFile = "angry.png",
  }


  menuBar:insert(menuBar.slideButton)
  menuBar:insert(menuBar.homeButton)
  menuBar:insert(menuBar.shopButton)
  menuBar:insert(menuBar.miniGameButton)
  menuBar:insert(menuBar.settingButton)

end

function getMenuBar()
  return menuBar
end
