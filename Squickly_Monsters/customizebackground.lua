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

local preview;
local backgroundList;
local counter;
local bgPreview;

-- -------------------------------------------------------------------------------

-- Non-scene functions go Here

function buttonClicked(event)
    if event.phase == "ended" then
        if event.target.name == "right" then
            counter = counter%#backgroundList+1
        else
            if counter == 1 then
                counter = #backgroundList
            else
                counter = counter-1
            end
        end
        updatePreview()
    end
end

function updatePreview()
    bgPreview = getBackgroundInfo(backgroundList[counter])

    preview = widget.newPanel {
        name = "preview",
        x = 0,
        y = 0,
        width = bgPreview[2],
        height = bgPreview[3],
        imageDir = bgPreview[1]
    }

    preview:scale(
                (display.contentWidth/preview.width)*0.8, 
                (display.contentHeight/preview.height)*0.8
                )
end

-- -------------------------------------------------------------------------------

function widget.newPanel(options)                                    
    local background = display.newImage(options.imageDir)
    local container = display.newContainer(options.width, options.height)
    
    -- print(background.width, background.height, display.contentWidth, display.contentHeight)
    background:scale(options.width/background.width, options.height/background.height )
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

    preview = widget.newPanel {
        name = "preview",
        x = 0,
        y = 0,
        width = bgPreview[2],
        height = bgPreview[3],
        imageDir = bgPreview[1]
    }

    preview:scale(
                (display.contentWidth/preview.width)*0.8, 
                (display.contentHeight/preview.height)*0.8
                )

    return preview
end

function setUpButton()
    local rightButton = widget.newPanel {
        name = "right",
        width = 200,
        height = 200,
        imageDir = "img/icons/UIIcons/rightbutton.png",
        x = 300,
        y = 0
    }

    rightButton:scale(
                (display.contentWidth/rightButton.width)*0.15,
                (display.contentHeight/rightButton.height)*0.15
                )

    -- rightbutton.x = display.contentCenterX - 100

    local leftButton = widget.newPanel {
        name = "left",
        width = 200,
        height = 200,
        imageDir = "img/icons/UIIcons/leftbutton.png",
        x = -300,
        y = 0
    }

    leftButton:scale(
                (display.contentWidth/leftButton.width)*0.15,
                (display.contentHeight/leftButton.height)*0.15
                )

    -- print(leftButton.options.image)

    return rightButton, leftButton
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
    setUpBackground()

    background = getBackground()

    -- Set preview
    preview = setUpPreview()
    rightButton, leftButton = setUpButton()

    -- Set monster
    monster = getMonster()
    -- setMonsterLocation(0,70)

    -- Set up all Event Listeners
    rightButton:addEventListener("touch", buttonClicked)
    leftButton:addEventListener("touch", buttonClicked)
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