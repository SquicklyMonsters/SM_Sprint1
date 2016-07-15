local composer = require("composer")
require("data")
-- -------------------------------------------------------------------------------
-- Local variables go HERE

local background;

local notifications;
-- local inventoryIcon;

local currentGold;
local currentPlatinum;

local goldText;
local platinumText;

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

<<<<<<< HEAD
    local cantBuyNotice = display.newImageRect("img/icons/UIIcons/cannotbuy.png", 150, 150)
    cantBuyNotice.x = display.contentCenterX
    cantBuyNotice.y = display.contentCenterY
    cantBuyNotice.alpha = 0
=======
function toyTabClickEvent(event)
    if event.phase == "ended" then
        if tab ~= "toy" then
            updateShop("toy")
        end
    end
end
-- -------------------------------------------------------------------------------
function updateShop(in_tab)
    -- Pretty much refresh the screen
    -- composer.hideOverlay()
    composer.removeScene("shop",true)
    -- local event = {params = {tab = in_tab}}
    -- scene:create(event)
    -- composer.showOverlay("menubar")
    local options = {
        effect = "fade",
        params = {tab = in_tab},
    }
    composer.gotoScene("shop", options)
end

function allocateItems(startX, startY, spacingX, spacingY)
    local cols = 6
    local shopIdx = 1
    for i = 1, #itemList do --loops to create each item on shop
        local item = itemList[itemList[i]]
        if tab == "all" or item.type == tab then
            local x = startX + (spacingX * ((shopIdx-1) - math.floor((shopIdx-1)/cols)*cols))
            local y = startY + (spacingY * (math.floor((shopIdx-1) / cols)))

            shop.items[shopIdx] = widget.newButton {
                top = y, -- division of row
                left = x, -- modulo of row
                width = 50,
                height = 50,
                defaultFile = item.image,
                onEvent = itemClickedEvent,
            }

            shop.items[shopIdx].item = item

            local textOptions = {
                text = item.gold,
                x = x + 5,
                y = y + 65,
                width = 50,
                height = 50
            }

            local textGold = display.newText(textOptions)
            textGold:setFillColor( 255/255, 223/255, 0 )

            local textOptions = {
                text = item.platinum,
                x = x + 80,
                y = y + 65,
                width = 50,
                height = 50
            }

            local textPlatinum = display.newText(textOptions)
            textPlatinum:setFillColor( 229/255, 228/255, 226/255 )

            shop:insert(shop.items[shopIdx])
            shop:insert(textGold)
            shop:insert(textPlatinum)
            shopIdx = shopIdx + 1
        end
    end
end

-- -------------------------------------------------------------------------------

function widget.newPanel(options)
    local background = display.newImage(options.imageDir)
    local container = display.newContainer(options.width, options.height)
>>>>>>> 544eda97f1bab6f7035c9d7f4c6cffa75e853b89

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
    setUpBackgroundShop()
    backgroundShop = getBackgroundShop()

    -- Set Shop
    shop = setUpShop()

    -- Set up all Icons

<<<<<<< HEAD
    inventoryIcon = getInventoryIcon()
=======
    -- inventoryIcon = getInventoryIcon()
>>>>>>> 544eda97f1bab6f7035c9d7f4c6cffa75e853b89

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
        -- middle:insert(inventoryIcon)
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
