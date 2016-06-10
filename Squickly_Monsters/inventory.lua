-- local foodList = require("foodList")
local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()

-- -------------------------------------------------------------------------------
-- Local variables go HERE
itemList = {foodList.burger, foodList.icecream, foodList.fish, foodList.noodles};
itemQuantities = {2, 3, 4, 5};
itemText = {};
local maxSize;

-- -------------------------------------------------------------------------------
-- Set all Event listeners HERE

function itemClickedEvent(event)
	-- Just gonna eat it right away for now
	if event.phase == "ended" then
		event.target.item:eat()
		local idx = event.target.idx
		reduceQuantity(idx)
	end
end

function closeEvent(event)
	if event.phase == "ended" then
		-- Go back to the current scene (destroy this scene in process)
		composer.gotoScene(composer.getSceneName("current"))
	end
end

-- -------------------------------------------------------------------------------

function reduceQuantity(idx)
	itemText[idx].text = itemText[idx].text - 1
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

--counts the length of the list, can't use #list because #list stops counting at first nil
function listLength(list)
	count = 0
	for i, items in pairs(list) do
    	count = count + 1
	end
	return count
end

function setUpInventory()
 	local inventory = widget.newPanel {
 		width = 300,
 		height = 300,
 		imageDir = "img/bg/inventory.png"
 	}

 	local startX = -inventory.width*(1/3)
 	local startY = -inventory.height*(1/3)

 	local rows = 3
 	local spacingX = (inventory.width)/4
 	local spacingY = inventory.height/4

 	inventory.items = {}

 	for i = 1, listLength(itemList) do --loops to create each item on inventory
 		local x = startX + (spacingX * ((i-1) - math.floor((i-1)/rows)*rows))
 		local y = startY + (spacingY * (math.floor((i-1) / rows))) 

 		inventory.items[i] = widget.newButton {
 			top = y, -- division of row
	    	left = x, -- modulo of row
	    	width = 50,
	    	height = 50,
	    	defaultFile = itemList[i].image,
	    	onEvent = itemClickedEvent,
 		}

 		inventory.items[i].item = itemList[i]
 		inventory.items[i].idx = i
 		local textOptions = {
			text = itemQuantities[i], 
			x = x + 70, 
			y = y + 65, 
			width = 50, 
			height = 50
 		}

 		local text = display.newText(textOptions)
 		text:setFillColor( 1, 0, 0 )

 		table.insert(itemText, i, text)
 		inventory:insert(inventory.items[i])
 		inventory:insert(text)

 		--another smaller frame for quantity
 	end

 	inventory.close = widget.newButton {
 		top = startY - (spacingY * 0.6),
 		left = startX + (spacingX * 2.7),
 		width = 50,
 		height = 50,
 		defaultFile = "img/icons/close.png",
 		onEvent = closeEvent,
 	}
 	print(inventory.width)
 	inventory:insert(inventory.close)
 	inventory:scale(
 				(display.contentWidth/inventory.width)*0.4, 
 				(display.contentHeight/inventory.height)*0.5
 				)
 	print(inventory.width*(display.contentWidth/inventory.width)*0.4)
 	return inventory
end

-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view
	local inventory = setUpInventory()


	sceneGroup:insert(inventory)

end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
    

	if phase == "will" then
		-- composer.showOverlay("menubar")
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
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene