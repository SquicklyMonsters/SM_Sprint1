food = require("foodClass")

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

local iconsFoodDir = "img/icons/food/"
foodList = {"burger", "noodles", "icecream", "fish"};

-- -------------------------------------------------------------------------------

-- itemname = food.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
local burger = food.new("burger", 100, 0, 500, 0, 0, 200, 100, iconsFoodDir .. "burger.png")
foodList.burger = burger
local noodles = food.new("noodles", 50, 0, 400, 0, 0, 0, 0, iconsFoodDir .. "noodles.png")
foodList.noodles = noodles
local icecream = food.new("icecream", 150, 1, 250, 50, 0, 0, 0, iconsFoodDir .. "icecream.png")
foodList.icecream = icecream
local fish = food.new("fish", 30, 0, 250, 50, 0, 0, 0, iconsFoodDir .. "fish.png")
foodList.fish = fish

-- -------------------------------------------------------------------------------

function getFoodList()
	return foodList
end

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

toy = require("toyClass")

-- -------------------------------------------------------------------------------

local iconsToyDir = "img/icons/toys/"
toyList = {}--{"ball", "chucky", "cards", "teddybear"}; --made it empty for now, so it doesnt show in shop
														--bc its incompatible with inventory functions atm, will fix

-- -------------------------------------------------------------------------------

-- itemname = food.new(name, gold, platinum, happiness, energy, exp, image)
local ball = toy.new("ball", 150, 0, 100, 0, 0, iconsToyDir .. "ball.png")
toyList.ball = ball
local chucky = toy.new("chucky", 250, 1, -500, 0, 500, iconsToyDir .. "chucky.png")
toyList.chucky = chucky
local cards = toy.new("cards", 150, 0, 250, 0, 0, iconsToyDir .. "cards.png")
toyList.cards = cards
local teddybear = toy.new("teddybear", 350, 0, 300, 50, 0, iconsToyDir .. "teddybear.png")
toyList.teddybear = teddybear

-- -------------------------------------------------------------------------------

function getToyList()
	return toyList
end
