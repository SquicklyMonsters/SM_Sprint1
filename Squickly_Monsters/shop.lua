-- Import dependency
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

require("shop.background")
require("shop.interactions")
require("inventory.interactions")
require("itemList")
require("data")

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local variables go Here

local back;
local middle;
local front;

-- local inventoryIcon;
-- local itemList;
-- local itemQuantities;
-- local itemTexts = {};

-- local buyHolder;
-- local cannotBuyHolder;
local notifications;

local currentGold;
local currentPlatinum;

local goldText;
local platinumText;
-- -------------------------------------------------------------------------------

-- Non-scene functions go Here

function itemClickedEvent(event)
    -- TODO: Add not enough space case handler
    if event.phase == "ended" then
        local item = event.target.item
        local idx = isInInventory(item.name)
        if sufficientGold(item.gold) and sufficientPlatinum(item.platinum) then
            buyNotice(1)
            if idx then
                increaseQuantity(idx)
            else
                addToInventory(item.name)
            end
            updateCurrency(-item.gold, -item.platinum)
        else
            buyNotice(2)
        end
        saveData()
        refreshDisplayCurrency(goldText, platinumText)
    end
end

function widget.newPanel(options)                                    
    local background = display.newImage(options.imageDir)
    local container = display.newContainer(options.width, options.height)
    
    -- print(background.width, background.height, display.contentWidth, display.contentHeight)
    background:scale(options.width/background.width, options.height/background.height )
    container:insert(background)
    print(display.contentWidth, background.width)
    container.x = display.contentCenterX
    container.y = display.contentCenterY
    return container
end

function setUpShop()
    local shop = widget.newPanel {
        width = 749,
        height = 374,
        imageDir = "img/bg/shoplist.png"
    }

    local startX = -shop.width*(1/2.5)
    local startY = -shop.height*(1/3)

    local cols = 6
    local spacingX = (shop.width)/6.8
    local spacingY = (shop.height)/3.75

    local itemList = getItemList()

    shop.items = {}

    for i = 1, #itemList do --loops to create each item on shop
        local x = startX + (spacingX * ((i-1) - math.floor((i-1)/cols)*cols))
        local y = startY + (spacingY * (math.floor((i-1) / cols)))
        local item = itemList[itemList[i]]

        shop.items[i] = widget.newButton {
            top = y, -- division of row
            left = x, -- modulo of row
            width = 50,
            height = 50,
            defaultFile = item.image,
            onEvent = itemClickedEvent,
        }

        shop.items[i].item = item
        shop.items[i].idx = i

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

        shop:insert(shop.items[i])
        shop:insert(textGold)
        shop:insert(textPlatinum)
    end

    shop:scale(
                (display.contentWidth/shop.width)*0.8, 
                (display.contentHeight/shop.height)*0.8
                )

    -- text area to show how much GOLD you have
    local GoldOptions = {
    text = "Gold: " .. getGold(),
    x = startX + 0.3*spacingX,
    y = startY - 0.3*spacingY,
    font = native.systemFontBold,
    fontSize = 25
    }

    -- text area to show how much PlATINUM you have
    local PlatinumOptions = {
    text = "Platinum: " .. getPlatinum(),
    x = startX + 5*spacingX,
    y = startY - 0.3*spacingY,
    font = native.systemFontBold,
    fontSize = 25
    }
 
    goldText = display.newText(GoldOptions)
    goldText:setFillColor( 255/255, 223/255, 0 )
    shop:insert(goldText)

    platinumText = display.newText(PlatinumOptions)
    platinumText:setFillColor( 229/255, 228/255, 226/255 )
    shop:insert(platinumText)

    return shop
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

    backgroundShop = getBackground()

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