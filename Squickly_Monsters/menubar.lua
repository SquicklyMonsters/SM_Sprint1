local widget = require("widget")
local composser = require("composer")

local menuBar;

--=====================================================================================================================================================
-- This is sliding panel function. Have 2 command show, hide,
function widget.newPanel( options )                                     -- Setting Panel : have default value and can be customize
    local opt = {}
    opt.width = options.width
    opt.height = options.height
    opt.speed = options.speed
    opt.inEasing = options.inEasing
    opt.outEasing = options.outEasing

    local background = display.newImage(options.imageDir)

    local container = display.newContainer(opt.width, display.contentHeight)
    container.x = display.contentWidth
    container.y = display.contentCenterY
    container:insert(background, true)

    function container:show()                                             -- show function
        local options = {
            time = opt.speed,
            transition = opt.inEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
        end
        options.x = display.contentWidth - 30
        self.completeState = "shown"
        transition.to( self, options )
    end

    function container:hide()                                           -- hide function
        local options = {
            time = opt.speed,
            transition = opt.outEasing
        }
        if ( opt.listener ) then
            options.onComplete = opt.listener
        end
        options.x = display.contentWidth + 30
        self.completeState = "hidden"
        transition.to( self, options )
    end
    return container
end
-- ==========================================================================================================================


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
    imageDir = "img/bg/menuBar.png"
  }
  
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
