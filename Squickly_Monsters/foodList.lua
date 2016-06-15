food = require("foodClass")

-- -------------------------------------------------------------------------------

local iconsDir = "img/icons/food/"
foodList = {"burger", "icecream", "fish", "noodles"};

-- -------------------------------------------------------------------------------

local burger = food.new("burger", 100, 0, 500, 0, 0, 200, 100, iconsDir .. "burger.png")
foodList.burger = burger
local noodles = food.new("noodles", 50, 0, 400, 0, 0, 0, 0, iconsDir .. "noodles.png")
foodList.noodles = noodles
local icecream = food.new("icecream", 150, 1, 250, 50, 0, 0, 0, iconsDir .. "icecream.png")
foodList.icecream = icecream
local fish = food.new("fish", 30, 0, 250, 50, 0, 0, 0, iconsDir .. "fish.png")
foodList.fish = fish

-- -------------------------------------------------------------------------------

function getFoodList()
	return foodList
end