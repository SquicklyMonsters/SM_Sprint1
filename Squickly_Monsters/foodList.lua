food = require("foodClass")

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

local iconsFoodDir = "img/icons/food/"
foodList = {"burger", "noodles", "icecream", "fish", "ball", "chucky", "cards", "teddybear"};

-- -------------------------------------------------------------------------------

-- itemname = food.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
local burger = food.new("burger", "food", 100, 0, 500, 0, 0, 200, 100, iconsFoodDir .. "burger.png")
foodList.burger = burger
local noodles = food.new("noodles", "food", 50, 0, 400, 0, 0, 0, 0, iconsFoodDir .. "noodles.png")
foodList.noodles = noodles
local icecream = food.new("icecream", "food", 150, 1, 250, 50, 0, 0, 0, iconsFoodDir .. "icecream.png")
foodList.icecream = icecream
local fish = food.new("fish", "food", 30, 0, 250, 50, 0, 0, 0, iconsFoodDir .. "fish.png")
foodList.fish = fish

-- -------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

toy = require("foodClass")

-- -------------------------------------------------------------------------------

local iconsToyDir = "img/icons/toys/"
-- toyList = {"ball", "chucky", "cards", "teddybear"}; --made it empty for now, so it doesnt show in shop
														--bc its incompatible with inventory functions atm, will fix

-- -------------------------------------------------------------------------------

-- itemname = food.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
local ball = toy.new("ball", "toy", 150, 0, 0, 100, 0, 0, 0, iconsToyDir .. "ball.png")
foodList.ball = ball
local chucky = toy.new("chucky", "toy", 250, 0, 1, -500, 0, 0, 500, iconsToyDir .. "chucky.png")
foodList.chucky = chucky
local cards = toy.new("cards", "toy", 150, 0, 0, 250, 0, 0, 0, iconsToyDir .. "cards.png")
foodList.cards = cards
local teddybear = toy.new("teddybear", "toy", 350, 0, 0, 300, 0, 50, 0, iconsToyDir .. "teddybear.png")
foodList.teddybear = teddybear

function getFoodList()
	return foodList
end

-- -------------------------------------------------------------------------------

-- function getToyList()
-- 	return toyList
-- end

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

-- allList = {foodList["burger"], foodList["noodles"], foodList["icecream"], foodList["fish"],
-- 			toyList["ball"], toyList["chucky"], toyList["cards"], toyList["teddybear"]}

-- -- -------------------------------------------------------------------------------

-- function getAllList()
-- 	return allList
-- end

