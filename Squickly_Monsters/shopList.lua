item = require("itemClass")

local iconsFoodDir = "img/icons/food/"
local iconsToyDir = "img/icons/toys/"

shopList = {"burger", "noodles", "icecream", "fish", "ball", "chucky", "cards", "teddybear"};
-- shopList = {}

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

-- itemname = food.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
local burger = item.new("burger", "food", 100, 0, 500, 0, 0, 200, 100, iconsFoodDir .. "burger.png")
shopList.burger = burger
-- shopList[burger.name] = burger
local noodles = item.new("noodles", "food", 50, 0, 400, 0, 0, 0, 0, iconsFoodDir .. "noodles.png")
shopList.noodles = noodles
-- shopList[noodles.name] = noodles
local icecream = item.new("icecream", "food", 150, 1, 250, 50, 0, 0, 0, iconsFoodDir .. "icecream.png")
shopList.icecream = icecream
-- shopList[icecream.name] = icecream
local fish = item.new("fish", "food", 30, 0, 250, 50, 0, 0, 0, iconsFoodDir .. "fish.png")
shopList.fish = fish
-- shopList[fish.name] = fish

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

-- itemname = food.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
local ball = item.new("ball", "toy", 150, 0, 0, 100, 0, 0, 0, iconsToyDir .. "ball.png")
shopList.ball = ball
-- shopList[ball.name] = ball
local chucky = item.new("chucky", "toy", 250, 0, 1, -500, 0, 0, 500, iconsToyDir .. "chucky.png")
shopList.chucky = chucky
-- shopList[chucky.name] = chucky
local cards = item.new("cards", "toy", 150, 0, 0, 250, 0, 0, 0, iconsToyDir .. "cards.png")
shopList.cards = cards
-- shopList[cards.name] = cards
local teddybear = item.new("teddybear", "toy", 350, 0, 0, 300, 0, 50, 0, iconsToyDir .. "teddybear.png")
shopList.teddybear = teddybear
-- print(teddybear.name)
-- shopList[teddybear.name] = teddybear
-- print(shopList[teddybear.name])

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

function getShopList()
	print(shopList[teddybear.name].name)
	return shopList
end

-- -------------------------------------------------------------------------------