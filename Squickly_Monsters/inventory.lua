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
local foodRecentList;
local playRecentList;
local itemQuantities;
local itemTexts = {};

local inventory;
-- -------------------------------------------------------------------------------
-- Set all Event listeners HERE

function itemClickedEvent(event)
	-- Just gonna eat it right away for now
	if event.phase == "ended" then
		local item = event.target.item
		local idx = event.target.idx
		local quantity = reduceQuantity(idx)
		if quantity ~= nil then
			-- Update display number
			itemTexts[idx].text = quantity
		else
			updateInventory()
		end
		item:use(item.type)
	end
end

function closeClickEvent(event)
	if event.phase == "ended" then
		inventoryClicked(event)
	end
end

function foodTabClickEvent(event)
	if event.phase == "ended" then
		print("ft clicked")
	end
end

-- -------------------------------------------------------------------------------

function updateInventory()
	-- Pretty much refresh the screen
	saveData()
	inventory:removeSelf()
	scene:create()
end

function allocateItems(obj, startX, spacingX, startY, spacingY, rows, list)
	for i = 1, #list do --loops to create each item on inventory
 		local x = startX + (spacingX * ((i-1) - math.floor((i-1)/rows)*rows))
 		local y = startY + (spacingY * (math.floor((i-1) / rows)))
 		local item = itemList[list[i]]
 		obj.items[i] = widget.newButton {
 			top = y, -- division of row
	    	left = x, -- modulo of row
	    	width = 50,
	    	height = 50,
	    	defaultFile = item.image,
	    	onEvent = itemClickedEvent,
 		}

 		obj.items[i].item = item
 		obj.items[i].idx = i
 		local textOptions = {
			text = itemQuantities[i],
			x = x + 70,
			y = y + 65,
			width = 50,
			height = 50
 		}

 		local text = display.newText(textOptions)
 		text:setFillColor( 0, 1, 0 )

 		table.insert(itemTexts, i, text)
 		obj:insert(obj.items[i])
 		obj:insert(text)

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
 	local inventory = widget.newPanel {
 		width = 300,
 		height = 300,
 		imageDir = "img/bg/inventory copy.png"
 	}

 	-- Retrieve data from save file
 	-- itemList, foodRecentList, playRecentList, itemQuantities, gold, platinum = setUpInventoryData()
 	invenList, foodRecentList, playRecentList, itemQuantities, gold, platinum = getInventoryData()

 	inventory.items = {}

 	local startX = -inventory.width*(1/3)
 	local startY = -inventory.height*(1/3)

 	local spacingX = inventory.width/4
 	local spacingY = inventory.height/4

 	local rows = 3
 	
 	allocateItems(inventory, startX, spacingX, startY, spacingY, rows, invenList)

 	inventory.close = widget.newButton {
 		top = startY - (spacingY * 0.6),
 		left = startX + (spacingX * 2.7),
 		width = 50,
 		height = 50,
 		defaultFile = "img/bg/close.png",
 		onEvent = closeClickEvent,
 	}

 	inventory.foodTab = widget.newButton {
 		top = startY - (spacingY * 0.6),
 		left = startX,
 		width = 50,
 		height = 50,
 		defaultFile = "img/icons/UIIcons/feedIcon.png",
 		onEvent = foodTabClickEvent,
 	}

 	inventory:insert(inventory.close)
 	inventory:insert(inventory.foodTab)
 	inventory:scale(
 				(display.contentWidth/inventory.width)*0.4,
 				(display.contentHeight/inventory.height)*0.5
 				)

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
    goldText:setFillColor( 255/255, 223/255, 0 )
    inventory:insert(goldText)

    local platinumText = display.newText(PlatinumOptions)
    platinumText:setFillColor( 229/255, 228/255, 226/255 )
    inventory:insert(platinumText)

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
	local sceneGroup = self.view
	inventory = setUpInventory()	
	sceneGroup:insert(inventory)
	print(composer.getSceneName("current"))

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
