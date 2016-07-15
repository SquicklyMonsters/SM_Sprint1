-- Import dependency
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

require( 'squicklyfarm.sf_background' )

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------
-- Local variables go Here

local screen;
local player;

local resizer = display.contentHeight/320

-- -------------------------------------------------------------------------------

function widget.newPanel(options)                                    
    local background = display.newImage(options.imageDir)
    container = display.newContainer(options.width, options.height)
    
    if options.type == "preview" then
        background:scale(display.contentWidth/background.width, display.contentHeight/background.height )
    end

    container:insert(background)
    container.x = display.contentCenterX + options.x
    container.y = display.contentCenterY + options.y
    container.name = options.name
    return container
end

-- -------------------------------------------------------------------------------
-- Scene functions go Here

function scene:create( event )
	local sceneGroup = self.view

    -- Setup layer
    back = display.newGroup()
    middle = display.newGroup()
    front = display.newGroup()

    -- Set background
	setupBackground()
	backbackground = getBackbackground()
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
		--tmp
		comingsoon = widget.newPanel {
            name = "bug",
            x = 0*resizer,
            y = 0*resizer,
            width = display.contentWidth,
            height = display.contentHeight,
            imageDir = "img/icons/UIIcons/comingsoon.png"
            }
            comingsoon.x = display.contentCenterX
            comingsoon.y = display.contentCenterY
            comingsoon:scale(0.5*resizer, 0.5*resizer)

        composer.showOverlay("menubar")
        -- Background
        back:insert(backbackground)
        -- ===========MIDDLE==============

        -- ===========FRONT===============

        -- ===============================
        sceneGroup:insert(back)
        sceneGroup:insert(middle)
        sceneGroup:insert(front)

--        restartGame()

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
	comingsoon:removeSelf()
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