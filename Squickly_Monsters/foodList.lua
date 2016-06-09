food = require("foodClass")

local iconsDir = "img/icons/food/"

foodList = {}

local burger = food.new("burger", 5, 500, 0, 0, 0, 0, iconsDir .. "burger.png")
foodList.burger = burger
local noodles = food.new("noodles", 5, 400, 0, 0, 0, 0, iconsDir .. "noodles.png")
foodList.noodles = noodles
local icecream = food.new("icecream", 5, 250, 50, 0, 0, 0, iconsDir .. "icecream.png")
foodList.noodles = icecream

function getFood(food)
	return foodList[food]
end