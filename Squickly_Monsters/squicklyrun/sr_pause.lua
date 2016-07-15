local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()

-- -------------------------------------------------------------------------------
-- Local variables go HERE
local resizer = display.contentHeight/320

-- -------------------------------------------------------------------------------
-- Set all Event listeners HERE

function resumeClickEvent(event)
	if event.phase == "ended" then
		composer.gotoScene(composer.getSceneName("current"))
		resume()
	end
end

function quitClickEvent(event)
	if event.phase == "ended" then
		-- restartGame()
		composer.removeScene("squicklyrun.sr_mainpage")
		composer.gotoScene("miniGame", "crossFade", 250)
		
	end
end

-- -------------------------------------------------------------------------------

function widget.newPanel(options)
    local background = display.newImage(options.imageDir)
    local container = display.newContainer(options.width, options.height)
    container:insert(background, true)
    container.x = display.contentCenterX
    container.y = display.contentCenterY
    return container
end

function setUpPause()
 	pause = widget.newPanel {
 		width = 900,
 		height = 563,
 		imageDir = "img/bg/pausebg.png"
 	}

 	pause.resume = widget.newButton {
 		top = 0,
 		left = -400,
 		width = 400,
 		height = 200,
 		defaultFile = "img/bg/resume.png",
 		onEvent = resumeClickEvent,
 	}

 	pause.exit = widget.newButton {
 		top = 70,
 		left = 50,
 		width = 380,
 		height = 120,
 		defaultFile = "img/bg/exit.png",
 		onEvent = quitClickEvent,
 	}

 	pause:insert(pause.resume)
 	pause:insert(pause.exit)
 	pause:scale(
 				(display.contentWidth/pause.width)*0.4,
 				(display.contentHeight/pause.height)*0.5
 				)
 	return pause
end

-- -------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view
	pause = setUpPause()	
	sceneGroup:insert(pause)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase


	if phase == "will" then
		-- composer.hideOverlay()
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
        --composer.hideOverlay()
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	-- Save data before exit
	saveData()
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
