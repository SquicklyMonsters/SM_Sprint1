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

local notifications;

local currentGold;
local currentPlatinum;

local goldText;
local platinumText;

local shop;

local tab;
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

-- function allTabClickEvent(event)
--     if event.phase == "ended" then
--         if tab ~= "all" then
--             tab = "all"
--             updateShop("all")
--         end
--     end
-- end

-- function foodTabClickEvent(event)
--     if event.phase == "ended" then
--         if tab ~= "food" then
--             -- tab = "food"
--             updateShop("food")
--         end
--     end
-- end

-- function toyTabClickEvent(event)
--     if event.phase == "ended" then
--         if tab ~= "toy" then
--             -- tab = "toy"
--             updateShop("toy")
--         end
--     end
-- end
-- -------------------------------------------------------------------------------
-- function updateShop(tab)
--     -- Pretty much refresh the screen
--     composer.hideOverlay()
--     composer.removeScene("shop")
--     local event = {params = {tab = tab}}
--     scene:create(event)
-- end

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
    
    -- print(background.width, background.height, display.contentWidth, display.contentHeight)
    background:scale(options.width/background.width, options.height/background.height )
    container:insert(background)
    container.x = display.contentCenterX
    container.y = display.contentCenterY
    return container
end

function setUpShop()
    shop = widget.newPanel {
        width = 749,
        height = 374,
        imageDir = "img/bg/shoplist.png"
    }

    local startX = -shop.width*(1/2.5)
    local startY = -shop.height*(1/3)

    local spacingX = (shop.width)/6.8
    local spacingY = (shop.height)/3.75

    local itemList = getItemList()

    shop.items = {}
    
    allocateItems(startX, startY, spacingX, spacingY)

    -- shop.allTab = widget.newButton {
    --     top = startY,
    --     left = startX - (spacingX * 0.65),
    --     width = 50,
    --     height = 50,
    --     defaultFile = "img/icons/UIIcons/allIcon.png",
    --     onEvent = allTabClickEvent,
    -- }

    -- shop.foodTab = widget.newButton {
    --     top = startY + (spacingY),
    --     left = startX - (spacingX * 0.65),
    --     width = 50,
    --     height = 50,
    --     defaultFile = "img/icons/UIIcons/feedIcon.png",
    --     onEvent = foodTabClickEvent,
    -- }

    --  shop.toyTab = widget.newButton {
    --     top = startY + (spacingY * 2),
    --     left = startX - (spacingX * 0.65),
    --     width = 50,
    --     height = 50,
    --     defaultFile = "img/icons/UIIcons/playIcon.png",
    --     onEvent = toyTabClickEvent,
    -- }


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
    platinumText = display.newText(PlatinumOptions)

    goldText:setFillColor( 255/255, 223/255, 0 )
    platinumText:setFillColor( 229/255, 228/255, 226/255 )

    shop:insert(goldText)
    shop:insert(platinumText)

    -- shop:insert(shop.allTab)
    -- shop:insert(shop.foodTab)
    -- shop:insert(shop.toyTab)

    shop:scale(
            (display.contentWidth/shop.width)*0.8, 
            (display.contentHeight/shop.height)*0.8
            )

    return shop
end

-- -------------------------------------------------------------------------------

-- Scene functions go Here

function scene:create( event )
	local sceneGroup = self.view
    print('e',event)
    print('o',event.options)
    local params = event.params
    print('p',params)
    tab = params.tab
    print('t',tab)
    -- tab = "toy"

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