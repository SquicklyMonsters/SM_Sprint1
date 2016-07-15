local composer = require("composer")
require("data")
-- -------------------------------------------------------------------------------
-- Local variables go HERE

local background;

local notifications;

-- -------------------------------------------------------------------------------

function cacheVariables()
    background = getBackground()
end

function buyNotice(i)
    notifications[i].alpha = 1
    transition.fadeOut( notifications[i], { time=500 } )
end

function setUpNotifications()
    local boughtNotice = display.newImageRect("img/icons/UIIcons/buy.png", 150, 150)
    boughtNotice.x = display.contentCenterX
    boughtNotice.y = display.contentCenterY
    boughtNotice.alpha = 0

    local cantBuyNotice = display.newImageRect("img/icons/UIIcons/cannotbuy.png", 150, 150)
    cantBuyNotice.x = display.contentCenterX
    cantBuyNotice.y = display.contentCenterY
    cantBuyNotice.alpha = 0

    notifications = {boughtNotice, cantBuyNotice}
    return notifications
end

function refreshDisplayCurrency(goldText, platinumText)
    goldText.text = "Gold: " .. getGold()
    platinumText.text = "Platinum: " .. getPlatinum()
end

-- -------------------------------------------------------------------------------

-- Scene functions go Here

function scene:create( event )
	local sceneGroup = self.view
    local params = event.params
    tab = params.tab
    print('t',tab)

    -- Setup layer
    back = display.newGroup()
    middle = display.newGroup()
    front = display.newGroup()

	-- Set background
    setUpShopBackground()

    backgroundShop = getShopBackground()

    -- Set Shop
    shop = setUpShop()

    -- Set up all Icons

    inventoryIcon = getInventoryIcon()

    notifications = setUpNotifications()


    -- Set up all Event Listeners
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase


	if phase == "will" then
        -- Add display objects into group
        -- ============BACK===============
        back:insert(backgroundShop)
        -- ===========MIDDLE==============
        middle:insert(shop)
        middle:insert(inventoryIcon)
        -- ===========FRONT===============
        front:insert(notifications[1])
        front:insert(notifications[2])
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
    print("oh no i die")
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

-- -------------------------------------------------------------------------------
-- Add All Event Listeners Here
