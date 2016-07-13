-- Import dependency
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

require("custompage.cp_background")
require("data")

-- -----------------------------------------------------------------------------------------------------------------

-- Local variables go Here

local resizer = display.contentHeight/320

local back;
local middle;
local front;

local monster;

local cp_background;

-- -----------------------------------------------------------------------------------------------------------------

function scene:create( event )
	local sceneGroup = self.view

    -- Setup layer
    back = display.newGroup()
    middle = display.newGroup()
    front = display.newGroup()

	-- Set background
    setUpBackground()
    cp_background = getBackground()

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

    -- Get Latest Monster
    monster = getMonster()
    setMonsterLocation(100,20)
    
	 -- Add display objects into group
    -- ============BACK===============
    back:insert(cp_background)
    -- ===========MIDDLE==============
    middle:insert(monster)
    -- ===========FRONT===============
    -- ===============================
    sceneGroup:insert(back)
    sceneGroup:insert(middle)
    sceneGroup:insert(front)

	if phase == "will" then
        composer.showOverlay("menubar")
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