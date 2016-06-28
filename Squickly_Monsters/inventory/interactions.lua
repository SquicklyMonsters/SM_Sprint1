-- -------------------------------------------------------------------------------
-- Local variables go HERE
local itemList;
local itemQuantities;
local itemTexts = {};
local maxSize = 9;

-- -------------------------------------------------------------------------------
--functions for currency
local gold --default goldMoney
local platinum--default platinumMoney

-- Used for changing the amount of Gold and Platinum user has. 
function updateCurrency(goldCost, platinumCost)
	gold = gold + goldCost
	platinum = platinum + platinumCost
end

function sufficientGold(goldCost)
	return (gold - goldCost) >= 0
end

function sufficientPlatinum(platinumCost)
	return (platinum - platinumCost) >= 0
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
	itemList, itemQuantities, gold, platinum = loadInventoryData()
	return itemList, itemQuantities, gold, platinum
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
	return gold
end

function getCurrentPlatinum()
	return platinum
end

-- -------------------------------------------------------------------------------
