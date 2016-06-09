require("homepage.UI")
-- -------------------------------------------------------------------------------
-- Local variables go HERE

local food = {}
local food_mt = { __index = food } -- metatable

-- -------------------------------------------------------------------------------

-- constructor
function food.new(name, cost, hunger, happiness, hygiene, energy, exp, image)
	local newFood = {
		name = name,
		cost = cost,
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

function food:eat()
	--change needs bar according to food affect
	changeNeedsLevel("hunger", self.hungerAffect)
	changeNeedsLevel("happiness", self.happinessAffect)
	changeNeedsLevel("hygiene", self.hygieneAffect)
	changeNeedsLevel("energy", self.energyAffect)
	changeNeedsLevel("exp", self.expAffect)
end

-------------------------------------------------

return food