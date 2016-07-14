-- Import dependency
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

require("custompage.cp_background")
require("custompage.cp_interactions")
require("data")

-- -----------------------------------------------------------------------------------------------------------------

-- Local variables go Here

local resizer = display.contentHeight/320

local back;
local middle;
local front;

local monster;
local monsterName;
local mint;
local strawberry;
local banana;

local evolveIcon;
local name_display;
local HW_display;
local disc_display;

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

    -- Get Latest Monster
    monster = getMonster()

    -- Display Monster Descriptions
    evolveIcon, name_display, HW_display, disc_display = displayAllMonsterDescriptions(getMonsterName())
    enableEvolveTouch()

    addListeners()

    mint = display.newImage("img/others/mint/dialog.png", display.contentCenterX-120*resizer, display.contentCenterY-100*resizer)
    mint:scale(0.3*resizer, 0.3*resizer )

    strawberry = display.newImage("img/others/strawberry/dialog.png", display.contentCenterX-120*resizer, display.contentCenterY-0*resizer)
    strawberry:scale(0.3*resizer, 0.3*resizer )
    
    banana = display.newImage("img/others/banana/dialog.png", display.contentCenterX-120*resizer, display.contentCenterY+100*resizer)
    banana:scale(0.3*resizer, 0.3*resizer )

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
        --Set Monster Loc
        monsterName = getMonsterName()
        setUpMonster(monsterName)
        monster = getMonster()
        setMonsterLocation(100,20)
        
         -- Add display objects into group
        -- ============BACK===============
        back:insert(cp_background)
        -- ===========MIDDLE==============
        middle:insert(monster)
        middle:insert(mint)
        middle:insert(strawberry)
        middle:insert(banana)
        -- ===========FRONT===============
        updateAllMonsterDescriptions(monsterName)
        if evolveIcon~=nil then
            front:insert(evolveIcon)
        end
        front:insert(name_display)
        front:insert(HW_display)
        front:insert(disc_display)
        -- ===============================
        sceneGroup:insert(back)
        sceneGroup:insert(middle)
        sceneGroup:insert(front)

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