require("custompage.cp_interactions")
local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()
require("monsterList")
require("data")

-- -------------------------------------------------------------------------------
-- Local variables go HERE
local resizer = display.contentHeight/320

local evolveBackgroud;
-- -------------------------------------------------------------------------------
-- Set all Event listeners HERE

function closeClickEvent(event)
	if event.phase == "ended" then
		evolveButtonClicked(event)
	end
end

-- -------------------------------------------------------------------------------

function askEvolveConfirmation()
	local currMonsterDesc = getMonsterDescription(getMonsterName())
	local nextMonsterDesc = getMonsterDescription(currMonsterDesc[6])
	return "Are you sure you want to evolve\n"..currMonsterDesc[1].." to "..nextMonsterDesc[1].."?"
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

function setUpEvolveBackground()
 	evolveBackgroud = widget.newPanel {
 		width = 800,
 		height = 480,
 		imageDir = "img/bg/evolve.jpg"
 	}

 	evolveBackgroud.close = widget.newButton {
 		x = 200,
 		y = -120,
 		defaultFile = "img/bg/close.png",
 		onEvent = closeClickEvent,
 	}

 	evolveBackgroud:insert(evolveBackgroud.close)

 	evolveBackgroud:scale(resizer,resizer)

    -- text to show evolve desc
    local evolveDescriptionOptions = {
	    text = askEvolveConfirmation(),
	    x = 0,
	    y = 80,
	    width = 300,
	    height = 0,
	    font = "Helvetica",
	    fontSize = 20,
	    align = "left",
    }

    local evolveDescription = display.newText(evolveDescriptionOptions)

    evolveDescription:setFillColor( 229/255, 228/255, 226/255 )
    evolveBackgroud:insert(evolveDescription)

 	return evolveBackgroud
end
-- -------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view
	evolveBackgroud = setUpEvolveBackground()	
	sceneGroup:insert(evolveBackgroud)

	local curr_monster = getMonster()
    setMonsterLocation(0,-30)	
 	sceneGroup:insert(curr_monster)
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
        -- composer.hideOverlay()
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
