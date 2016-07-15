item = require("itemClass")

local iconsFoodDir = "img/icons/food/"
local iconsToyDir = "img/icons/toys/"

itemList =  {
			-- Foods
			"burger", "noodles", "icecream", "fish", 
			-- Toys
			"ball", "chucky", "cards", "teddybear"
			};
-- itemList = {}

-- -------------------------------------------------------------------------------
-- Food List

-- Item Format
-- itemname = item.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
local burger = item.new("burger", "food", 100, 0, 500, 0, 0, 200, 100, iconsFoodDir .. "burger.png")
local noodles = item.new("noodles", "food", 50, 0, 400, 0, 0, 0, 0, iconsFoodDir .. "noodles.png")
local icecream = item.new("icecream", "food", 150, 1, 250, 50, 0, 0, 0, iconsFoodDir .. "icecream.png")
local fish = item.new("fish", "food", 30, 0, 250, 50, 0, 0, 0, iconsFoodDir .. "fish.png")

itemList.burger = burger
itemList.noodles = noodles
itemList.icecream = icecream
itemList.fish = fish


-- -------------------------------------------------------------------------------
-- Toy List

-- Item Format
-- itemname = item.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
local ball = item.new("ball", "toy", 150, 0, 0, 100, 0, 0, 0, iconsToyDir .. "ball.png")
local chucky = item.new("chucky", "toy", 250, 0, 1, -500, 0, 0, 10000, iconsToyDir .. "chucky.png")
local cards = item.new("cards", "toy", 150, 0, 0, 250, 0, 0, 0, iconsToyDir .. "cards.png")
local teddybear = item.new("teddybear", "toy", 350, 0, 0, 300, 0, 50, 0, iconsToyDir .. "teddybear.png")

itemList.ball = ball
itemList.chucky = chucky
itemList.cards = cards
itemList.teddybear = teddybear
-- -------------------------------------------------------------------------------

function getItemList()
	return itemList
end

-- -------------------------------------------------------------------------------