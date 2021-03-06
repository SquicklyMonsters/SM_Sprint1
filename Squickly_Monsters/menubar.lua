local widget = require("widget")
local composer = require("composer")
local scene = composer.newScene()

-- -------------------------------------------------------------------------------
-- Local variables go HERE
local resizer = display.contentHeight/320

local menuBar;
local chageScenceEffect = "crossFade";
local chageSceneTime = 250;

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

function changeSceneButtonEvent(event)
  local scene = event.target.scene
  if event.phase == "ended" then
    local currentScene = composer.getSceneName("current")
    if currentScene ~= scene then
      if currentScene ~= "home" then
        composer.removeScene(currentScene)
      end

      if scene == "shop" then
        local options = 
        {
          effect = chageScenceEffect, 
          time = chageSceneTime, 
          params = {tab = "all"}
        }
        composer.gotoScene(scene, options)
      else
        composer.gotoScene(scene, chageScenceEffect, chageSceneTime)
      end
    end
  end
end

-- -------------------------------------------------------------------------------
-- Set up contructor for menu bar

function widget.newPanel( options )                                    
    local background = display.newImage(options.imageDir)

    local container = display.newContainer(background.width, background.height)
    container:scale(resizer, resizer )
    -- Start as a hide bar state
    container.completeState = "hidden"
    container.x = display.contentWidth + 30*resizer
    container.y = display.contentCenterY
    container:insert(background, true)

    function container:show()                                          
        local options = {
            time = options.speed,
            transition = options.inEasing
        }
        options.x = display.contentWidth - 30*resizer
        self.completeState = "shown"
        transition.to(self, options)
    end

    function container:hide()                                    
        local options = {
            time = options.speed,
            transition = options.outEasing
        }
        options.x = display.contentWidth + 30*resizer
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
    inEasing = easing.outBack,
    outEasing = easing.outCubic,
    imageDir = "img/bg/menuBar.png"
  }

  local startX = -130
  local spacingX = 70
  local middleY = -25
  local iconsDir = "img/icons/menubarIcons/"

  menuBar.slideButton = widget.newButton{
    top = startX + (spacingX*3)/2,
    left = middleY - 29,
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
    onEvent = changeSceneButtonEvent,
  }
  menuBar.shopButton = widget.newButton{
    top = startX + spacingX,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = iconsDir .. "shopIcon.png",
    onEvent = changeSceneButtonEvent,
  }
  menuBar.miniGameButton = widget.newButton{
    top = startX + spacingX*2,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = iconsDir .. "miniGameIcon.png",
    onEvent = changeSceneButtonEvent,
  }

  menuBar.customizeButton = widget.newButton{
    top = startX + spacingX*3,
    left = middleY,
    width = 50,
    height = 50,
    defaultFile = iconsDir .. "customizeIcon.png",
    onEvent = changeSceneButtonEvent,
  }

  menuBar.settingButton = widget.newButton{
    top = startX + spacingX*3.75,
    left = middleY + spacingX*0.4,
    width = 25,
    height = 25,
    defaultFile = iconsDir .. "settingIcon.png",
    onEvent = changeSceneButtonEvent,
}

  -- Set scene file for each buttons to be use in changeSceneButtonEvent
  menuBar.homeButton.scene = "home"
  menuBar.shopButton.scene = "shop"
  menuBar.miniGameButton.scene = "miniGame"
  menuBar.customizeButton.scene = "customize"
  menuBar.settingButton.scene = "customizebackground"

  menuBar:insert(menuBar.slideButton)
  menuBar:insert(menuBar.homeButton)
  menuBar:insert(menuBar.shopButton)
  menuBar:insert(menuBar.miniGameButton)
  menuBar:insert(menuBar.customizeButton)
  menuBar:insert(menuBar.settingButton)

end
-- -------------------------------------------------------------------------------

function getMenuBar()
  return menuBar
end

-- -------------------------------------------------------------------------------

function scene:create( event )
  local sceneGroup = self.view
  setUpMenuBar()
  sceneGroup:insert(menuBar)
end

function scene:show( event )
end

function scene:hide( event )
end

function scene:destroy( event )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene