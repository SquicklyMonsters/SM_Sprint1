-- Import dependency
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

require("custompage.cp_background")
require("backgroundList")
require("data")

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local variables go Here

local back;
local middle;
local front;

local resizer = display.contentHeight/320

-- local preview;
local backgroundList;
local bgPreview;
local chosenBG;
local counter;
local container;

local firstTime = true;

-- -------------------------------------------------------------------------------

-- Non-scene functions go Here

function getChosenBG()
    return chosenBG
end

function buttonClicked(event)
    if event.phase == "ended" then
        if event.target.name == "right" then
            counter = counter%#backgroundList+1
            updatePreview()
            print(getBackgroundInfo(backgroundList[counter])[1])
        elseif event.target.name == "left" then
            if counter == 1 then
                counter = #backgroundList
            else
                counter = counter-1
            end
            print(getBackgroundInfo(backgroundList[counter])[1])
            updatePreview()
        else
            chosenBG = getBackgroundInfo(backgroundList[counter])[1]
            saveBackground()
        end
    end
end

function updatePreview()
    bgPreview = getBackgroundInfo(backgroundList[counter])
    
    width = bgPreview[2]*resizer
    height = bgPreview[3]*resizer
    imageDir = bgPreview[1]

    container:remove(background)
    local background = display.newImage(imageDir)
    background:scale(display.contentWidth/background.width, display.contentHeight/background.height )
    container:insert(background)
end

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

function setUpPreview()
    backgroundList = getBackgroundList()
    counter = 1

    bgPreview = getBackgroundInfo(backgroundList[counter])

    local preview = widget.newPanel {
        name = "preview",
        x = 0*resizer,
        y = 0*resizer,
        width = 400*resizer,
        height = 200*resizer,
        imageDir = bgPreview[1]
    }

    preview.x, preview.y = display.contentCenterX, display.contentCenterY

    preview:scale(
                (display.contentWidth/preview.width)*0.8*resizer, 
                (display.contentHeight/preview.height)*0.8*resizer
                )

    return preview
end

function setUpButtons()
    local rightButton = widget.newPanel {
        name = "right",
        width = 800*resizer,
        height = 718*resizer,
        imageDir = "img/icons/UIIcons/rightbutton.png",
        x = 225*resizer,
        y = 0*resizer
    }

    rightButton.x, rightButton.y = display.contentCenterX + (225*resizer), display.contentCenterY

    rightButton:scale(
                (display.contentWidth/rightButton.width)*0.2,
                (display.contentHeight/rightButton.height)*0.2
                )

    local leftButton = widget.newPanel {
        name = "left",
        width = 800*resizer,
        height = 700*resizer,
        imageDir = "img/icons/UIIcons/leftbutton.png",
        x = -225*resizer,
        y = 0*resizer
    }

    leftButton.x, leftButton.y = display.contentCenterX - (225*resizer), display.contentCenterY

    leftButton:scale(
                (display.contentWidth/leftButton.width)*0.2,
                (display.contentHeight/leftButton.height)*0.2
                )

    local selectButton = widget.newPanel {
        name = "select",
        width = 300*resizer,
        height = 72*resizer,
        imageDir = "img/icons/UIIcons/select.png",
        x = 0*resizer,
        y = 125*resizer
    }

    selectButton.x, selectButton.y = display.contentCenterX, display.contentCenterY + (125*resizer)

    selectButton:scale(
                (display.contentWidth/selectButton.width)*0.30,
                (display.contentHeight/selectButton.height)*0.15
                )

    return rightButton, leftButton, selectButton
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
    setUpEvolveBackground()

    background = getEvolveBackground()

    -- Set preview
    rightButton, leftButton, selectButton = setUpButtons()
    preview = setUpPreview()

    -- Set monster
    monster = getMonster()
    setMonsterLocation(0,50)

    -- Set up all Event Listeners
    rightButton:addEventListener("touch", buttonClicked)
    leftButton:addEventListener("touch", buttonClicked)
    selectButton:addEventListener("touch", buttonClicked)
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
        -- Add display objects into group
        -- ============BACK===============
        back:insert(background)
        -- ===========MIDDLE==============
        middle:insert(preview)
        middle:insert(rightButton)
        middle:insert(leftButton)
        middle:insert(selectButton)
        -- ===========FRONT===============
        front:insert(monster)
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