require("inventory.interactions")
local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()
require("itemList")
require("itemClass")
require("data")

-- -------------------------------------------------------------------------------
-- Local variables go HERE
local resizer = display.contentHeight/320

local invenList;
local itemQuantities;

-- local tabList;
-- local tabQuantities;

local itemTexts = {};

local inventory;
local tab;
-- -------------------------------------------------------------------------------
-- Set all Event listeners HERE

function itemClickedEvent(event)
	-- Just gonna eat it right away for now
	if event.phase == "ended" then
		local item = event.target.item
		local invDataIdx = event.target.invDataIdx
		local invSlotIdx = event.target.invSlotIdx
		local quantity = reduceQuantity(invDataIdx)
		if quantity ~= nil then
			-- Update display number
			itemTexts[invSlotIdx].text = quantity
		else
			updateInventory(tab)
		end
		item:use(item.type)
	end
end

function closeClickEvent(event)
	if event.phase == "ended" then
		inventoryClicked(event)
	end
end

function allTabClickEvent(event)
    if event.phase == "ended" then
        if tab ~= "all" then
            updateInventory("all")
        end
    end
end

function foodTabClickEvent(event)
    if event.phase == "ended" then
        if tab ~= "food" then
            updateInventory("food")
        end
    end
end

function toyTabClickEvent(event)
    if event.phase == "ended" then
        if tab ~= "toy" then
            updateInventory("toy")
        end
    end
end
-- -------------------------------------------------------------------------------

function updateInventory(tab)
	-- Pretty much refresh the screen
	saveData()
	inventory:removeSelf()
	local event = {params = {tab = tab}}
	scene:create(event)
end

function allocateItems(list, quantities, startX, startY, spacingX, spacingY)
	-- invSlotIdx is for correctly indexing inventory slots
	-- invDataIdx is for correctly recognize items
	local rows = 3
	local invSlotIdx = 1
	for invDataIdx = 1, #list do --loops to create each item on inventory
		local item = itemList[list[invDataIdx]]
		if tab == "all" or item.type == tab then
	 		local x = startX + (spacingX * ((invSlotIdx-1) - math.floor((invSlotIdx-1)/rows)*rows))
	 		local y = startY + (spacingY * (math.floor((invSlotIdx-1) / rows)))

	 		inventory.items[invSlotIdx] = widget.newButton {
	 			top = y, -- division of row
		    	left = x, -- modulo of row
		    	width = 50,
		    	height = 50,
		    	defaultFile = item.image,
		    	onEvent = itemClickedEvent,
	 		}
	 		
	 		inventory.items[invSlotIdx].item = item
	 		inventory.items[invSlotIdx].invSlotIdx = invSlotIdx
	 		inventory.items[invSlotIdx].invDataIdx = invDataIdx

	 		local textOptions = {
				text = quantities[invSlotIdx],
				x = x + 70,
				y = y + 65,
				width = 50,
				height = 50
	 		}

	 		local text = display.newText(textOptions)
	 		text:setFillColor( 0, 1, 0 )

	 		table.insert(itemTexts, invSlotIdx, text)
	 		inventory:insert(inventory.items[invSlotIdx])
	 		inventory:insert(text)
	 		invSlotIdx = invSlotIdx + 1
	 	end
 		--another smaller frame for quantity
 	end	
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

function setUpInventory()
 	inventory = widget.newPanel {
 		width = 300,
 		height = 300,
 		imageDir = "img/bg/inventory copy.png"
 	}

 	-- Retrieve data from save file
 	-- itemList, foodRecentList, playRecentList, itemQuantities, gold, platinum = setUpInventoryData()
 	invenList, itemQuantities, gold, platinum = getInventoryData()

 	inventory.items = {}

 	local startX = -inventory.width*(1/3)
 	local startY = -inventory.height*(1/3)

 	local spacingX = inventory.width/4
 	local spacingY = inventory.height/4
 	
 	allocateItems(invenList, itemQuantities, startX, startY, spacingX, spacingY)

 	inventory.close = widget.newButton {
 		top = startY - (spacingY * 0.6),
 		left = startX + (spacingX * 2.7),
 		width = 50,
 		height = 50,
 		defaultFile = "img/bg/close.png",
 		onEvent = closeClickEvent,
 	}

 	inventory.allTab = widget.newButton {
 		top = startY,
 		left = startX - (spacingX * 0.65),
 		width = 50,
 		height = 50,
 		defaultFile = "img/icons/UIIcons/allIcon.png",
 		onEvent = allTabClickEvent,
 	}

 	inventory.foodTab = widget.newButton {
 		top = startY + (spacingY),
 		left = startX - (spacingX * 0.65),
 		width = 50,
 		height = 50,
 		defaultFile = "img/icons/UIIcons/feedIcon.png",
 		onEvent = foodTabClickEvent,
 	}

 	 inventory.toyTab = widget.newButton {
 		top = startY + (spacingY * 2),
 		left = startX - (spacingX * 0.65),
 		width = 50,
 		height = 50,
 		defaultFile = "img/icons/UIIcons/playIcon.png",
 		onEvent = toyTabClickEvent,
 	}

 	-- text area to show how much GOLD you have
    local GoldOptions = {
    text = "Gold: " .. getGold(),
    x = startX,
    y = startY - 0.3*spacingY,
    font = native.systemFontBold,
    fontSize = 20,
    }

    -- text area to show how much PlATINUM you have
    local PlatinumOptions = {
    text = "Platinum: " .. getPlatinum(),
    x = startX + 2*spacingX,
    y = startY - 0.3*spacingY,
    font = native.systemFontBold,
    fontSize = 20,
    }

    local goldText = display.newText(GoldOptions)
    local platinumText = display.newText(PlatinumOptions)

    goldText:setFillColor( 255/255, 223/255, 0 )
    platinumText:setFillColor( 229/255, 228/255, 226/255 )

    inventory:insert(goldText)
    inventory:insert(platinumText)

    inventory:insert(inventory.close)
 	inventory:insert(inventory.allTab)
 	inventory:insert(inventory.foodTab)
 	inventory:insert(inventory.toyTab)

 	inventory:scale(
 				(display.contentWidth/inventory.width)*0.4,
 				(display.contentHeight/inventory.height)*0.5
 				)

 	return inventory
end
-- -------------------------------------------------------------------------------
function getItemTexts()
	return itemTexts
end

function setItemTexts(itemTexts)
	itemTexts = itemTexts
end
-- -------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:create( event )
	-- print("i am inv")
	local sceneGroup = self.view
	local params = event.params
	tab = params.tab
	inventory = setUpInventory()	
	sceneGroup:insert(inventory)

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
        --composer.hideOverlay()
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
