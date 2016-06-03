-----------------------------------------------------------------------------------------
local widget = require("widget")
local composer = require("composer")
display.setStatusBar(display.HiddenStatusBar)
local scene = composer.newScene()
--------------------------------------------
require("home.tama")
require("home.background")
require("home.UI")
require("Bossy.Npanel")
local myButton
local panel
-- ==========================================================================================================================

function handleButtonEvent( event )       -- Menu Button Action for sliding menu
    local phase = event.phase
    if "ended" == phase then
      print(panel.completeState)
        if panel.completeState == "hidden" then
          panel:show()
          panel.completeState = "shown"
          transition.to(myButton, {time = 380, x=425, y = 160})
        else
          panel:hide()
          panel.completeState = "hidden"
          transition.to(myButton, {time = 315, x=525, y = 160})
        end
    end
end

--===================================================================================================
-- create scene HERE
function scene:create( event )
  local sceneGroup = self.view
  local title = setUpTitle("Tamagotchi v0.15")

  -- Set background
  background = setUpBackground("bg.png")

  -- Set Tama
  local tama = setUpTama("egg.png")

  -- Set up needs
  hunger = setUpNeedBar("widget-progress-view.png")


  -- Set up needs level
  -- TODO: Load from save file
  hunger:setProgress( 1 )


  setUpIcons()
  local feedIcon = getFeedIcon()

  -- Set reaction when touch
  function tama:touch(event)
      if event.phase == "ended" then
          hideShowIcons(tama)
      end
  end
  function feedIcon:touch(event)
      if event.phase == "ended" then
          feed()
          hunger:setProgress(hunger:getProgress() + 0.1)
          return true
      end
  end

  -- Trigger needs
  function needs()
      hunger:setProgress(hunger:getProgress() - 0.1)
  end

  panel = widget.newPanel{                  -- create panel
  	    speed = 1000,
  	    inEasing = easing.outBack,
  	    outEasing = easing.outCubic,
  	}
	panel:show()                                -- set to show

	panel.background = display.newRect( 0, 0, panel.width, panel.height )   -- create background for panel
	-- panel.background:setFillColor( 0, 0.25, 0.5 )
	panel.background:setFillColor( 0, 0, 0, 120/255 )     -- change to see through
	panel:insert( panel.background )

	panel.title = display.newText( "Menu", 0, 0, native.systemFontBold, 18 )
	panel.title:setFillColor( 1, 1, 1 )
	panel:insert( panel.title )


-- =====================================================================================================
-- Add 5 more button HERE
  myButton = widget.newButton{
    left = 378,
    top = 135,
    width = 50,
    height = 50,
    defaultFile = "happy.png",
    overFile = "angry.png",
    label = "Menu button",

    onEvent = handleButtonEvent,
  }
	panel.button = widget.newButton{
	  top = -140,
	  left = -60,
	  width = 50,
	  height = 50,
	  defaultFile = "happy.png",
	  overFile = "angry.png",
	  label = "First button",
	  onEvent = function() composer.gotoScene( "menu" ); end,
	}

	panel.button2 = widget.newButton{
	  top = -70,
	  left = -60,
	  width = 50,
	  height = 50,
	  defaultFile = "happy.png",
	  overFile = "angry.png",
	  label = "Second button",
	}

	panel.button3 = widget.newButton{
	  top = 10,
	  left = -60,
	  width = 50,
	  height = 50,
	  defaultFile = "happy.png",
	  overFile = "angry.png",
	  label = "Three button",

	}

	panel.button4 = widget.newButton{
	  top = 80,
	  left = -60,
	  width = 50,
	  height = 50,
	  defaultFile = "happy.png",
	  overFile = "angry.png",
	  label = "Fourth button",
	  onEvent = function() background = display.newImage("background3.png")	; end,
	}


-- =============================================================
--insert all button
	panel:insert(panel.button)
	panel:insert(panel.button2)
	panel:insert(panel.button3)
	panel:insert(panel.button4)
	-- all display objects must be inserted into group
    sceneGroup:insert(background)
	sceneGroup:insert( panel )
	sceneGroup:insert( title )
	sceneGroup:insert( myButton )
  sceneGroup:insert( tama )
  sceneGroup:insert( feedIcon )
  sceneGroup:insert( hunger )

  timer.performWithDelay(20000, needs, -1)
  -- Add even listener for touch event on tama
  tama:addEventListener("touch", tama)
  feedIcon:addEventListener("touch", feedIcon)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
