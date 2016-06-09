local composer = require( "composer" )
local scene = composer.newScene()

-- -------------------------------------------------------------------------------
-- Local variables go HERE
local maxSize;
local 

-- -------------------------------------------------------------------------------

function widget.newPanel( options )                                    

    local background = display.newImage(options.imageDir)

    local container = display.newContainer(opt.width, display.contentHeight)
    -- Start as a hide bar state
    container:insert(background, true)

    -- function container:show()                                          
    --     local options = {
    --         time = opt.speed,
    --         transition = opt.inEasing
    --     }
    --     options.x = display.contentWidth - 30
    --     self.completeState = "shown"
    --     transition.to(self, options)
    -- end

    -- function container:hide()                                    
    --     local options = {
    --         time = opt.speed,
    --         transition = opt.outEasing
    --     }
    --     options.x = display.contentWidth + 30
    --     self.completeState = "hidden"
    --     transition.to(self, options)
    -- end
    return container
end

-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view
	local options = {
		width = 300,
		height = 280,
	}
	local inventory = display.newImage("img/bg/inventory.png", options)
	inventory.x = display.contentCenterX
	inventory.y = display.contentCenterY

	menuBar = widget.newPanel{
    width = 50,
    height = 50,
    imageDir = "img/icons/fish.png"
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