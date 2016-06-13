-- Import dependency
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

require("savegame")
require("shop.background")
require("shop.interactions")
require("inventory.interactions")
require("currency")

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local variables go Here

local back;
local middle;
local front;

local inventoryIcon;
local itemList;
local itemQuantities;
local itemTexts = {};

local buyHolder;
local cannotbuyHolder;


-- -------------------------------------------------------------------------------

-- Non-scene functions go Here


function widget.newPanel(options)                                    
    local background = display.newImage(options.imageDir)
    local container = display.newContainer(options.width, options.height)
    container:insert(background, true)
    container.x = display.contentCenterX
    container.y = display.contentCenterY
    container:scale(2.,1.5)


    return container
end



function buyClicked(event)
    buyHolder.alpha = 0
end

function cannotbuyClicked(event)
    cannotbuyHolder.alpha = 0
end

function buyNotice()
    buyHolder.alpha = 1
    background:addEventListener("touch", buyClicked)
end

function cannotbuyNotice()
    cannotbuyHolder.alpha = 1
    background:addEventListener("touch",buyClicked)
end

function itemClickedEvent(event)
    if event.phase == "ended" then
        local item = event.target.item
        local idx = isInInventory(item.name)
        if checkSufficientGold(item.cost) then
            buyNotice()     
            if idx then
                increaseQuantity(idx)
            else
                addToInventory(item.name)
            end
            decreaseGold(item.cost)
            
        else
            cannotbuyNotice()
           
        end
        
        goldText.text = "Gold: " .. returnCurrentGold()
        print("87 " .. returnCurrentGold())
        saveInventoryData()
    end
end

function setUpShop()
    local inventory = widget.newPanel {
        width = 820,
        height = 400,
        imageDir = "img/bg/shoplist.png"
    }
    inventory.x = display.contentCenterX + (display.contentWidth/30)

    local startX = -inventory.width*(1/2.45)
    local startY = -inventory.height*(1/3)

    local cols = 6
    local spacingX = (inventory.width)/7.5
    local spacingY = (inventory.height)/3.75

    local shopList = getFoodList()

    inventory.items = {}

    for i = 1, #shopList do --loops to create each item on inventory
        local x = startX + (spacingX * ((i-1) - math.floor((i-1)/cols)*cols))
        local y = startY + (spacingY * (math.floor((i-1) / cols))) 
        local food = foodList[shopList[i]]

        inventory.items[i] = widget.newButton {
            top = y, -- division of row
            left = x, -- modulo of row
            width = 50,
            height = 50,
            defaultFile = food.image,
            onEvent = itemClickedEvent,
        }

        inventory.items[i].item = food
        inventory.items[i].idx = i

        local textOptions = {
            text = food.cost, 
            x = x + 70, 
            y = y + 65, 
            width = 50, 
            height = 50
        }
        print(textOptions.text)

        local text = display.newText(textOptions)
        text:setFillColor( 1, 1, 0 )

        table.insert(itemTexts, i, text)
        inventory:insert(inventory.items[i])
        inventory:insert(text)
        inventory:insert(inventory.items[i])
    end

    inventory:scale(
                (display.contentWidth/inventory.width)*0.4, 
                (display.contentHeight/inventory.height)*0.5
                )

    return inventory
end

-- -------------------------------------------------------------------------------

-- Scene functions go Here

function scene:create( event )
	local sceneGroup = self.view

    -- Retrieve inventory data from save file
    setUpInventoryData()

    -- Setup layer
    back = display.newGroup()
    middle = display.newGroup()
    front = display.newGroup()

	-- Set background
    setUpBackground()
    background = getBackground()

    -- Set Shop
    shop = setUpShop()

    -- Set up all Icons
    setUpAllIcons()
    inventoryIcon = getInventoryIcon()
    buyHolder = display.newImageRect("img/icons/UIIcons/buy.png", 150, 150)
    buyHolder.x = display.contentCenterX
    buyHolder.y = display.contentCenterY
    buyHolder.alpha = 0

    cannotbuyHolder = display.newImageRect("img/icons/UIIcons/cannotbuy.png", 150, 150)
    cannotbuyHolder.x = display.contentCenterX
    cannotbuyHolder.y = display.contentCenterY
    cannotbuyHolder.alpha = 0
    
    -- Overlay Text

        -- text area to show how much GOLD you have
    local options =
    {
    text = "Gold: " .. returnCurrentGold(),
    x = 505,
    y = 30,
    font = native.systemFontBold,
    fontSize = 12

}

    goldText = display.newText(options)

    -- text area to show how much PlATINUM you have

    local options =
    {
    text = "Platinum: " .. returnCurrentPlatinum(),
    x = 510,
    y = 40,
    font = native.systemFontBold,
    fontSize = 12

}

    platinumText = display.newText(options)
    



	-- Add display objects into group
    -- ============BACK===============
    back:insert(background)
    -- ===========MIDDLE==============
    middle:insert(shop)
    middle:insert(inventoryIcon)
    -- ===========FRONT===============
    front:insert(buyHolder)
    front:insert(cannotbuyHolder)
    -- money 
    front:insert(goldText)
    front:insert(platinumText)
    -- ===============================
    sceneGroup:insert(back)
    sceneGroup:insert(middle)
    sceneGroup:insert(front)

    -- Set up all Event Listeners
    addListeners()
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
    

	if phase == "will" then
        composer.showOverlay("menubar")
        -- composer.showOverlay("inventory")
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