require("homepage.UI")
-- -------------------------------------------------------------------------------
-- Local variables go HERE

local toy = {};
local toy_mt = { __index = toy }; -- metatable

-- -------------------------------------------------------------------------------

-- constructor
function toy.new(name, gold, platinum, happiness, energy, exp, image)
	local newToy = {
		name = name,
		gold = gold,
		platinum = platinum,
		-- hungerAffect = hunger,
		happinessAffect = happiness,
		-- hygieneAffect = hygiene,
		energyAffect = energy,
		expAffect = exp,
		image = image
	}
	return setmetatable(newToy, toy_mt)
end

-------------------------------------------------

function toy:play()
	-- Change to eating animation and wake up monster
	changeToWakeupState()
    playAnimation()

    -- Change needs bar according to food affect
	-- changeNeedsLevel("hunger", self.hungerAffect)
	changeNeedsLevel("happiness", self.happinessAffect)
	-- changeNeedsLevel("hygiene", self.hygieneAffect)
	changeNeedsLevel("energy", self.energyAffect)
	giveExpWhenInteract(getHungerBar(), self.expAffect)

	print("Play with " .. self.name .. "!!")
end

-------------------------------------------------

return toy
