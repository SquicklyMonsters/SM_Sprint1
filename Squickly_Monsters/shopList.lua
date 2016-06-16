item = require("itemClass")

local iconsFoodDir = "img/icons/food/"
local iconsToyDir = "img/icons/toys/"

shopList = {"burger", "noodles", "icecream", "fish", "ball", "chucky", "cards", "teddybear"};

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

-- itemname = food.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
local burger = item.new("burger", "food", 100, 0, 500, 0, 0, 200, 100, iconsFoodDir .. "burger.png")
shopList.burger = burger
local noodles = item.new("noodles", "food", 50, 0, 400, 0, 0, 0, 0, iconsFoodDir .. "noodles.png")
shopList.noodles = noodles
local icecream = item.new("icecream", "food", 150, 1, 250, 50, 0, 0, 0, iconsFoodDir .. "icecream.png")
shopList.icecream = icecream
local fish = item.new("fish", "food", 30, 0, 250, 50, 0, 0, 0, iconsFoodDir .. "fish.png")
shopList.fish = fish

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

-- itemname = food.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
local ball = item.new("ball", "toy", 150, 0, 0, 100, 0, 0, 0, iconsToyDir .. "ball.png")
shopList.ball = ball
local chucky = item.new("chucky", "toy", 250, 0, 1, -500, 0, 0, 500, iconsToyDir .. "chucky.png")
shopList.chucky = chucky
local cards = item.new("cards", "toy", 150, 0, 0, 250, 0, 0, 0, iconsToyDir .. "cards.png")
shopList.cards = cards
local teddybear = item.new("teddybear", "toy", 350, 0, 0, 300, 0, 50, 0, iconsToyDir .. "teddybear.png")
shopList.teddybear = teddybear

-- -------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------

function getShopList()
	return shopList
end

-- -------------------------------------------------------------------------------