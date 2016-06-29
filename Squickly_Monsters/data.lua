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

local hungerRate = -10;
local happinessRate = -10;
local hygieneRate = -10;
local energyRate = -10;

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