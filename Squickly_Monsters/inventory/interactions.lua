-- -------------------------------------------------------------------------------
-- Local variables go HERE
local itemList;
local itemQuantities;
local itemTexts = {};
local maxSize = 9;

-- -------------------------------------------------------------------------------
local goldMoney = 300 --default goldMoney


-- These really do what they say they do, pretty self explanatory

--FOR GOLD

function increaseGold(goldAmount)
	goldMoney = goldMoney + goldAmount
end

function decreaseGold(goldAmount)
	goldMoney = goldMoney - goldAmount
end

function sufficientGold(goldAmount)
	return (goldMoney - goldAmount) >= 0
end

-- -----------------------------------------------------------------------
--FOR PLATINUM

local platinumMoney = 0 --default platinumMoney

function increasePlatinum(platinumAmount)
	platinumMoney = platinumMoney + platinumAmount
end

function decreasePlatinum(platinumAmount)
	platinumMoney = platinumMoney - platinumAmount
end

function sufficientPlatinum(platinumAmount)
	if (platinumMoney - platinumAmount) >= 0 then
		return true	
	else
		return false
	end
end

-- -------------------------------------------------------------------------------

--adds new item to inventory
function addToInventory(itemName)
	-- If number of item will not exceed limit size: add item
	if #itemList < maxSize then
		table.insert(itemList, itemName)
		table.insert(itemQuantities, 1)
	end
end

-- increase quantity of the item if it already exists
function increaseQuantity(idx)
	itemQuantities[idx] = itemQuantities[idx] + 1
end

-- Reduce quantity of the item when use
function reduceQuantity(idx)
	itemQuantities[idx] = itemQuantities[idx] - 1
	if itemQuantities[idx] > 0 then
		return itemQuantities[idx]
	else
		removeItem(idx)
		return 0
	end
	
end


function removeItem(idx)
	local new_itemList = {}
	local new_itemQuantities = {}
	for i = 1, #itemList do
		-- Add all the items into new list except the one that ran out
		if i ~= idx then
			table.insert(new_itemList, itemList[i])
			table.insert(new_itemQuantities, itemQuantities[i])
		end
	end
	itemList = new_itemList
	itemQuantities = new_itemQuantities
end

function isInInventory(name)
	for i, itemName in ipairs(itemList) do
		-- If item exists in inventory: return its index
		if itemName == name then
	  		return i
	  	end
	end
	return false
end

function setUpInventoryData()
	itemList, itemQuantities = loadInventoryData()
	return itemList, itemQuantities
end

-- -------------------------------------------------------------------------------
-- Get functions HERE
function getItemList()
	return itemList
end

function getItemQuantities()
	return itemQuantities
end

function getCurrentGold()
	return goldMoney
end

function getCurrentPlatinum()
	return platinumMoney
end

-- -------------------------------------------------------------------------------