require("homepage.UI")
-- -------------------------------------------------------------------------------
-- Local variables go HERE

local item = {};
local item_mt = { __index = item }; -- metatable

-- -------------------------------------------------------------------------------

-- constructor
function item.new(name, type, gold, platinum, hunger, happiness, hygiene, energy, exp, image)
	local newItem = {
		name = name,
		type = type,
		gold = gold,
		platinum = platinum,
		hungerAffect = hunger,
		happinessAffect = happiness,
		hygieneAffect = hygiene,
		energyAffect = energy,
		expAffect = exp,
		image = image
	}
	return setmetatable(newItem, item_mt)
end

-------------------------------------------------

function item:use(type)
	-- Change to eating animation and wake up monster
	print(type)
	changeToWakeupState()

	if type == "food" then
		-- Set animation to eating
		feedAnimation()
		giveTakeCareEXP(self.expAffect, getHungerBar())
		-- Check if Thought Clouds still need to be shown
		checkHunger(1)
	elseif type == "toy" then
		-- Set animation to playing
		playAnimation()
		giveTakeCareEXP(self.expAffect, getHappinessBar())
	end

    -- Change needs bar according to food affect
	changeNeedsLevel("hunger", self.hungerAffect)
	changeNeedsLevel("happiness", self.happinessAffect)
	changeNeedsLevel("hygiene", self.hygieneAffect)
	changeNeedsLevel("energy", self.energyAffect)

	print("Use " .. self.name .. "!!")
end

-------------------------------------------------

return item
