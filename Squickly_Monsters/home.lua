-- Import dependency
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

require("homepage.background")
require("homepage.monster")
require("homepage.UI")

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local variables go HERE



-- -------------------------------------------------------------------------------

-- Longer written functions go HERE



-- -------------------------------------------------------------------------------

-- Scene functions go HERE

function scene:create( event )
	local sceneGroup = self.view

    -- Setup layer
    local back = display.newGroup()
    local middle = display.newGroup()
    local front = display.newGroup()
	
	-- Set background
    background = setUpBackground("img/bg/main_background.png")
	
    -- Set Up Monster 
    local tama = setUpMonster("img/sprites/egg_sprites_all.png")

    -- Set up Needs Bar
    hunger = setUpNeedBar("img/others/widget-progress-view.png")

    hunger:setProgress( 0.5 )


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

	-- Add display objects into group
    -- ============BACK===============
    back:insert(background)
    back:insert(feedIcon)

    -- ===========MIDDLE==============
    middle:insert(tama)

    -- ===========FRONT===============
    front:insert(hunger)


    -- ===============================

    -- Add hunger loop
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
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene