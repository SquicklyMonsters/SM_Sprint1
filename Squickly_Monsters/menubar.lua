local widget = require("widget")
local composser = require("composer")
require("Npanel")

local menuBar;

function handleButtonEvent(event)
  local phase = event.phase
  if phase == "ended" then
    if menuBar.completeState == "hidden" then
      menuBar:show()
    else
      menuBar:hide()
    end
  end
end

function setUpMenuBar()
  menuBar = widget.newPanel{
    speed = 1000,
    width = 110,
    height = 480,
    inEasing = easing.outBack,
    outEasing = easing.outCubic,
  }
  menuBar.background = display.newImage("img/bg/menuBar.png")
  menuBar.background:scale(1, 1.1)
  menuBar:insert(menuBar.background)

  menuBar:show()
  menuBar:hide()

  local startX = -130
  local spacingX = 70
  local middleY = -25
  local iconsDir = "img/icons/"
  menuBar.slideButton = widget.newButton{
    top = startX + (spacingX*3)/2,
    left = middleY - 30,
    width = 25,
    height = 50,
    defaultFile = iconsDir .. "slideIcon.png",
    onEvent = handleButtonEvent,
  }

  menuBar.homeButton = widget.newButton{
    top = startX,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = iconsDir .. "homeIcon.png",
  }
  menuBar.shopButton = widget.newButton{
    top = startX + spacingX,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = iconsDir .. "shopIcon.png",
  }
  menuBar.miniGameButton = widget.newButton{
    top = startX + spacingX*2,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = iconsDir .. "miniGameIcon.png",
  }

  menuBar.settingButton = widget.newButton{
    top = startX + spacingX*3,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = iconsDir .. "settingsIcon.png",
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
