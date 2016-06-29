-------------------------------------------------------------------------------
-- Local variables go HERE

local itemList;
local foodRecentList;
local playRecentList;
local itemQuantities;
local gold;
local platinum;

local needsLevels;
local maxNeedsLevels;

local monster;

local hungerRate = -50;
local happinessRate = -50;
local hygieneRate = -50;
local energyRate = -50;

-- -------------------------------------------------------------------------------


-- -------------------------------------------------------------------------------
-- Need Rates

function getHungerRate()
	return hungerRate
end

function getHappinessRate()
	return happinessRate
end

function getHygieneRate()
	return hygieneRate
end

function getEnergyRate()
	return energyRate
end

-- -------------------------------------------------------------------------------