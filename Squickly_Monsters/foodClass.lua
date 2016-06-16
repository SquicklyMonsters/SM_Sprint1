require("homepage.UI")
-- -------------------------------------------------------------------------------
-- Local variables go HERE

local food = {};
local food_mt = { __index = food }; -- metatable

-- -------------------------------------------------------------------------------

-- constructor
function food.new(name, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
	local newFood = {
		name = name,
		gold = gold,
		platinum = platinum,
		hungerAffect = hunger,
		happinessAffect = happiness,
		hygieneAffect = hygiene,
		energyAffect = energy,
		expAffect = exp,
		image = image
	}
	return setmetatable(newFood, food_mt)
end

-------------------------------------------------

function food:use()
	-- Change to eating animation and wake up monster
	changeToWakeupState()
    feedAnimation()

    -- Change needs bar according to food affect
	changeNeedsLevel("hunger", self.hungerAffect)
	changeNeedsLevel("happiness", self.happinessAffect)
	changeNeedsLevel("hygiene", self.hygieneAffect)
	changeNeedsLevel("energy", self.energyAffect)
	giveTakeCareEXP(self.expAffect, getHungerBar())

	-- Check if Thought Clouds still need to be shown
	checkHunger(1)

	print("Eat " .. self.name .. "!!")
end

-------------------------------------------------

return food
