item = require("itemClass")

local iconsFoodDir = "img/icons/food/"
local iconsToyDir = "img/icons/toys/"

itemList = {"burger", "noodles", "icecream", "fish", "ball", "chucky", "cards", "teddybear"};
-- itemList = {}

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

-- itemname = food.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
local burger = item.new("burger", "food", 100, 0, 500, 0, 0, 200, 100, iconsFoodDir .. "burger.png")
itemList.burger = burger
-- itemList[burger.name] = burger
local noodles = item.new("noodles", "food", 50, 0, 400, 0, 0, 0, 0, iconsFoodDir .. "noodles.png")
itemList.noodles = noodles
-- itemList[noodles.name] = noodles
local icecream = item.new("icecream", "food", 150, 1, 250, 50, 0, 0, 0, iconsFoodDir .. "icecream.png")
itemList.icecream = icecream
-- itemList[icecream.name] = icecream
local fish = item.new("fish", "food", 30, 0, 250, 50, 0, 0, 0, iconsFoodDir .. "fish.png")
itemList.fish = fish
-- itemList[fish.name] = fish

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

-- itemname = food.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
local ball = item.new("ball", "toy", 150, 0, 0, 100, 0, 0, 0, iconsToyDir .. "ball.png")
itemList.ball = ball
-- itemList[ball.name] = ball
local chucky = item.new("chucky", "toy", 250, 0, 1, -500, 0, 0, 500, iconsToyDir .. "chucky.png")
itemList.chucky = chucky
-- itemList[chucky.name] = chucky
local cards = item.new("cards", "toy", 150, 0, 0, 250, 0, 0, 0, iconsToyDir .. "cards.png")
itemList.cards = cards
-- itemList[cards.name] = cards
local teddybear = item.new("teddybear", "toy", 350, 0, 0, 300, 0, 50, 0, iconsToyDir .. "teddybear.png")
itemList.teddybear = teddybear
-- print(teddybear.name)
-- itemList[teddybear.name] = teddybear
-- print(itemList[teddybear.name])

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

function getItemList()
	print(itemList[teddybear.name].name)
	return itemList
end

-- -------------------------------------------------------------------------------