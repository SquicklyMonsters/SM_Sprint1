local widget = require("widget")
local composer = require("composer")

-- -------------------------------------------------------------------------------
-- Local variables go HERE
local menuBar;
local chageScenceEffect = "crossFade"
local chageSceneTime = 250
-- -------------------------------------------------------------------------------
-- Set reaction when menu bar buttons press

function slideButtonEvent(event)
  if event.phase == "ended" then
    if menuBar.completeState == "hidden" then
      menuBar:show()
    else
      menuBar:hide()
    end
  end
end

function homeButtonEvent(event)
  if event.phase == "ended" then
    if composer.getSceneName("current") ~= "home" then
      composer.gotoScene("home", chageScenceEffect, chageSceneTime)
    end
  end
end

function shopButtonEven(event)
  if event.phase == "ended" then
    if composer.getSceneName("current") ~= "shop" then
      composer.gotoScene("shop", chageScenceEffect, chageSceneTime)
    end
  end
end

function miniGameButtonEvent(event)
  if event.phase == "ended" then
    if composer.getSceneName("current") ~= "miniGame" then
      composer.gotoScene("miniGame", chageScenceEffect, chageSceneTime)
    end
  end
end

function settingsButtonEvent(event)
  if event.phase == "ended" then
    if composer.getSceneName("current") ~= "settings" then
      composer.gotoScene("settings", chageScenceEffect, chageSceneTime)
    end
  end
end

-- -------------------------------------------------------------------------------
-- Set up contructor for menu bar

function widget.newPanel( options )                                    
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

    function container:show()                                          
        local options = {
            time = opt.speed,
            transition = opt.inEasing
        }
        options.x = display.contentWidth - 30
        self.completeState = "shown"
        transition.to(self, options)
    end

    function container:hide()                                    
        local options = {
            time = opt.speed,
            transition = opt.outEasing
        }
        options.x = display.contentWidth + 30
        self.completeState = "hidden"
        transition.to(self, options)
    end
    return container
end
-- -------------------------------------------------------------------------------
-- Set up menu bar

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
    onEvent = slideButtonEvent,
  }

  menuBar.homeButton = widget.newButton{
    top = startX,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = iconsDir .. "homeIcon.png",
    onEvent = homeButtonEvent,
  }
  menuBar.shopButton = widget.newButton{
    top = startX + spacingX,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = iconsDir .. "shopIcon.png",
    onEvent = shopButtonEven,
  }
  menuBar.miniGameButton = widget.newButton{
    top = startX + spacingX*2,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = iconsDir .. "miniGameIcon.png",
    onEvent = miniGameButtonEvent,
  }

  menuBar.settingsButton = widget.newButton{
    top = startX + spacingX*3,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = iconsDir .. "settingsIcon.png",
    onEvent = settingsButtonEvent,
  }


  menuBar:insert(menuBar.slideButton)
  menuBar:insert(menuBar.homeButton)
  menuBar:insert(menuBar.shopButton)
  menuBar:insert(menuBar.miniGameButton)
  menuBar:insert(menuBar.settingsButton)

end
-- -------------------------------------------------------------------------------

function getMenuBar()
  return menuBar
end
