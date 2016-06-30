require("data")
-- -------------------------------------------------------------------------------
-- Local variables go HERE
local invenList = getInvenList();
local foodRecentList;
local playRecentList;
local itemQuantities = getItemQuantities();
local itemTexts = {};

-- -------------------------------------------------------------------------------
-- Functions for currency
local gold = getGold()
local platinum = getPlatinum()

-- Used for changing the amount of Gold and Platinum user has. 
function updateCurrency(goldCost, platinumCost)
	gold = gold + goldCost
	platinum = platinum + platinumCost
	setGold(gold)
	setPlatinum(platinum)
end

function sufficientGold(goldCost)
	return (gold - goldCost) >= 0
end

function sufficientPlatinum(platinumCost)
	return (platinum - platinumCost) >= 0
end

-- -------------------------------------------------------------------------------

-- --adds new item to inventory
-- function addToInventory(itemName)
-- 	-- If number of item will not exceed limit size: add item
-- 	if #invenList < maxSize then
-- 		table.insert(invenList, itemName)
-- 		table.insert(itemQuantities, 1)
-- 	end
-- end

-- -- increase quantity of the item if it already exists
-- function increaseQuantity(idx)
-- 	itemQuantities[idx] = itemQuantities[idx] + 1
-- end

-- -- Reduce quantity of the item when use
-- function reduceQuantity(idx)
-- 	itemQuantities[idx] = itemQuantities[idx] - 1
-- 	if itemQuantities[idx] > 0 then
-- 		return itemQuantities[idx]
-- 	else
-- 		removeItem(idx)
-- 	end
-- end

-- function removeItem(idx)
-- 	table.remove(invenList,idx)
-- 	table.remove(itemQuantities,idx)
-- end

-- function isInInventory(name)
-- 	for i, itemName in ipairs(invenList) do
-- 		-- If item exists in inventory: return its index
-- 		if itemName == name then
-- 	  		return i
-- 	  	end
-- 	end
-- 	return false
-- end

-- function setUpInventoryData()
-- 	itemList, foodRecentList, playRecentList, itemQuantities, gold, platinum = loadInventoryData()
-- 	return itemList, foodRecentList, playRecentList, itemQuantities, gold, platinum
-- end

-- -------------------------------------------------------------------------------
-- Get functions HERE
-- function getItemList()
-- 	return itemList
-- end

function getItemQuantities()
	return itemQuantities
end

-- function getCurrentGold()
-- 	return gold or 0
-- end

-- function getCurrentPlatinum()
-- 	return platinum or 0
-- end

-- -------------------------------------------------------------------------------
