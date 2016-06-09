local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()

-- -------------------------------------------------------------------------------
-- Local variables go HERE
local maxSize;

-- -------------------------------------------------------------------------------

function widget.newPanel( options )                                    
    local background = display.newImage(options.imageDir)
    local container = display.newContainer(options.width, options.height)
    container:insert(background, true)
    container.x = display.contentCenterX
    container.y = display.contentCenterY

    return container
end

-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view

	-- fish = widget.newPanel{
 --    width = 50,
 --    height = 50,
 --    imageDir = "img/icons/fish.png"
 --  	}

 	local inventory = widget.newPanel {
 		width = 300,
 		height = 280,
 		imageDir = "img/bg/inventory.png"
 	}

 	local startX = display.contentCenterX - inventory.width/2 + 50
 	local startY = display.contentCenterY - inventory.height/2 + 40
 	print(startX, startY)

 	inventory.item1 = widget.newButton {
 		top = startY,
	    left = startX,
	    width = 50,
	    height = 50,
	    defaultFile = "img/icons/fish.png",
	    -- onEvent = slideButtonEvent,
 	}

	sceneGroup:insert(inventory)
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
        --composer.hideOverlay()
		-- Called when the scene is now off screen
	end
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