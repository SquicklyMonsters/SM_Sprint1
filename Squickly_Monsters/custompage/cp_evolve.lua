require("custompage.cp_interactions")
local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()
require("monsterList")
require("data")

-- -------------------------------------------------------------------------------
-- Local variables go HERE
local resizer = display.contentHeight/320

local currMonsterName;
local nextMonsterName;
local currMonsterDesc;
local nextMonsterDesc;

local curr_monster;
local evo_animation;
local evolveBackgroud;
local evolveDescription;

local evo1;
local evo2;
local evo3;

-- -------------------------------------------------------------------------------
-- Caching Monster Desc

function cacheMonsterInfo()
	currMonsterName = getMonsterName()
	currMonsterDesc = getMonsterDescription(currMonsterName)
	nextMonsterName = currMonsterDesc[6]
	nextMonsterDesc = getMonsterDescription(nextMonsterName)

	curr_monster = getMonster()
	curr_monster.alpha = 0
    setMonsterLocation(0,-30)
end

-- -------------------------------------------------------------------------------
-- Set all Event listeners HERE

function closeClickEvent(event)
	if event.phase == "ended" then
		evolveButtonClicked(event)
	end
end

function evolveSeq1(event)
	evo1.alpha = 1
	evo1:play()
	transition.fadeOut( curr_monster, { time=4000 } )
end

function evolveSeq2(event)
	evo1.alpha = 0
	evo2.alpha = 1
	evo2:play()

	-- Set New Monster
	setMonsterName(nextMonsterName)
	setUpMonster(nextMonsterName)
	saveData()

	--Update to Latest Data
	cacheMonsterInfo()
end

function evolveSeq3(event)
	evo2.alpha = 0
	evo3.alpha = 1
	evo3:play()

	transition.fadeIn( curr_monster, { time=4000 } )
end

function evolveSeq4(event)
	evo3.alpha = 0
	evolveDescription.text = doneEvolutionMsg()
	timer.performWithDelay( 1000, closeClickEvent ) -- auto close after evolve
    timer.performWithDelay( 5000, enableEvolveTouch )
end

function evolveNow(event)
	if isTouchAbleFunc() then
		if isEvolable() then
			if event.phase == "ended" then
				disableEvolveTouch()
				disableEvolution()
				evolveBackgroud.evolve.alpha = 0
				evolveBackgroud.clickhere.alpha = 0
				evolveDescription.text = evolvingMsg()

				timer.performWithDelay( 2000, evolveSeq1 )
				timer.performWithDelay( 6000, evolveSeq2 )
				timer.performWithDelay( 10000, evolveSeq3 )
				timer.performWithDelay( 15000, evolveSeq4 )
			end
		end
	end
end

-- -------------------------------------------------------------------------------
-- Update Text Here

function askEvolveConfirmation()
	local toEvolveTo
	if string.starts(currMonsterName, "egg") then
        toEvolveTo = "<MYSTERY>"
    else
        toEvolveTo = nextMonsterDesc[1]
    end
	return "Are you sure you want to evolve\n"..currMonsterDesc[1].." to "..toEvolveTo.."?"
end

function evolvingMsg()
	return "Evolving..."
end

function doneEvolutionMsg()
	return "Congratulations on your new\n"..currMonsterDesc[1].."!!!"
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

function setUpEvolveAnimation()
    local options = {
        width = 192,
        height = 192,
        numFrames = 50,
    }
    local imageSheet = graphics.newImageSheet("img/others/effects/water.png", options)
    local sequenceData = {
	    name="normal",
	    start=1,
	    count=50,
	    time=75*50,
	    loopCount = 1,  
	    loopDirection = "forward",
	}
    evo1 = display.newSprite(imageSheet, sequenceData)
    evo1:scale(1*resizer,1*resizer)
    evo1.x,evo1.y = display.contentCenterX,display.contentCenterY-35*resizer
    evo1.alpha = 0

    local options = {
        width = 192,
        height = 192,
        numFrames = 25,
    }
    local imageSheet2 = graphics.newImageSheet("img/others/effects/light.png", options)
    local sequenceData = {
	    name="normal",
	    start=1,
	    count=25,
	    time=75*30,
	    loopCount = 2,  
	    loopDirection = "forward",
	}
    evo2 = display.newSprite(imageSheet2, sequenceData)
    evo2:scale(1.5*resizer,1.5*resizer)
    evo2.x,evo2.y = display.contentCenterX,display.contentCenterY-35*resizer
    evo2.alpha = 0
    
    local options = {
        width = 192,
        height = 192,
        numFrames = 20,
    }
    local imageSheet3 = graphics.newImageSheet("img/others/effects/heal.png", options)
    local sequenceData = {
	    name="normal",
	    start=1,
	    count=20,
	    time=75*30,
	    loopCount = 2,  
	    loopDirection = "forward",
	}
    evo3 = display.newSprite(imageSheet3, sequenceData)
    evo3:scale(1.5*resizer,1.5*resizer)
    evo3.x,evo3.y = display.contentCenterX,display.contentCenterY-65*resizer
    evo3.alpha = 0

    return evo1,evo2,evo3
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

 	evolveBackgroud.evolve = widget.newButton {
 		x = 170,
 		y = 80,
 		defaultFile = "img/icons/UIIcons/megaevolve.png",
 		onEvent = evolveNow,
 	}

 	evolveBackgroud.clickhere = widget.newButton {
 		x = 170,
 		y = 10,
 		defaultFile = "img/others/clickHere.png",
 	}

 	evolveBackgroud:insert(evolveBackgroud.close)
 	evolveBackgroud:insert(evolveBackgroud.evolve)
 	evolveBackgroud:insert(evolveBackgroud.clickhere)

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

    evolveDescription = display.newText(evolveDescriptionOptions)

    evolveDescription:setFillColor( 229/255, 228/255, 226/255 )
    evolveBackgroud:insert(evolveDescription)

 	return evolveBackgroud
end
-- -------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view
	cacheMonsterInfo()

	evolveBackgroud = setUpEvolveBackground()	
	sceneGroup:insert(evolveBackgroud)

 	evo1,evo2,evo3 = setUpEvolveAnimation()
 	sceneGroup:insert(evo1)
 	sceneGroup:insert(evo2)
 	sceneGroup:insert(evo3)

	curr_monster.alpha = 1
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
		sceneGroup:insert(curr_monster)
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
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
