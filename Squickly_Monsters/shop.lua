-- Import dependency
local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()

require("shop.background")
require("shop.interactions")
require("foodList")
require("inventory")
require("savegame")
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

--check if the item exists in inventory
function checkExist(idx)
    return true
end

--adds new item to inventory
function addToInventory(idx)
end

-- increase quantity of the item if it already exists
function increaseQuantity(idx)
    -- itemTexts[idx].text = itemTexts[idx].text + 1
    itemQuantities[idx] = itemQuantities[idx] + 1
    saveInventoryData()
end

function itemClickedEvent(event)
    if event.phase == "ended" then
        itemList = getItemList()
        itemQuantities = getItemQuantities()
        local idx = event.target.idx
        print(idx)
        local exist = checkExist(idx)
        print(itemList[idx])
        if exist then
            increaseQuantity(idx)
        else
            addToInventory(idx)
        end
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

    shopList = getFoodList()
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

	-- Add display objects into group
    -- ============BACK===============
    back:insert(background)
    -- ===========MIDDLE==============
    middle:insert(shop)
    middle:insert(inventoryIcon)
    -- ===========FRONT===============

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