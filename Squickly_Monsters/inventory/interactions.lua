-- -------------------------------------------------------------------------------
-- Local variables go HERE
local itemList;
local itemQuantities;
local itemTexts = {};
local maxSize = 9;

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
	-- itemTexts[idx].text = itemTexts[idx].text - 1
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

-- -------------------------------------------------------------------------------