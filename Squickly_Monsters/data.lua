-- Load external libraries
local json = require("json")
-------------------------------------------------------------------------------
-- Local variables go HERE
-- TODO: Add monster data

local itemList;
local foodRecentList;
local playRecentList;
local itemQuantities;
local gold;
local platinum;

local needsLevels;
local maxNeedsLevels;

local monsterLevel;

local hungerRate = -50;
local happinessRate = -50;
local hygieneRate = -50;
local energyRate = -50;

local saveRate;
local dataFile = system.pathForFile( "data.txt", system.DocumentsDirectory )

-- -------------------------------------------------------------------------------

function writeFile(file, contents)
    file = io.open(file, "w")
    file:write(contents)
    io.close(file)    
end

function saveData()
	print(getHungerLevel(), needsLevels.hunger)
    local outTable = 
    {
    -- UI Data
    foodRecentList, playRecentList, 
    -- Inventory Data
    itemList, itemQuantities, gold, platinum,
    -- Needs Data
    	{
    	maxNeedsLevels.hunger, 
    	maxNeedsLevels.happiness, 
    	maxNeedsLevels.hygiene, 
    	maxNeedsLevels.energy, 
    	maxNeedsLevels.exp
    	},

    	{
    	needsLevels.hunger, 
    	needsLevels.happiness, 
    	needsLevels.hygiene, 
    	needsLevels.energy, 
    	needsLevels.exp    	
    	},
    -- Monster
    monsterLevel,
	}
    local contents = json.encode(outTable)
    writeFile(dataFile, contents)
    print("Save by Data Sage")
    print(getHungerLevel(), needsLevels.hunger)
end

-- function setAutoSaveRate(rate) -- 1000 = 1sec
-- 	if saveRate ~= nil then
-- 		timer.cancel(saveRate)
-- 	end
--     saveRate = timer.performWithDelay(rate, saveData, -1)
-- end
-- -------------------------------------------------------------------------------

function readFile(file)
    -- read all contents of file into a string
    local contents = file:read( "*a" )
    inTable = json.decode(contents);
    io.close( file ) -- important!
    return inTable
end

function loadData()
    local file = io.open( dataFile, "r" )

    if file then
        local inTable = readFile(file)
        local UIIdx = 1
        foodRecentList = inTable[UIIdx]
        playRecentList = inTable[UIIdx + 1]

        local invIdx = 3
        itemList = inTable[invIdx]
        itemQuantities = inTable[invIdx + 1]
        gold = inTable[invIdx + 2]
        platinum = inTable[invIdx + 3]

        local needIdx = 7
        -- maxNeedsLevels = inTable[needIdx]
        maxNeedsLevels = 
        {
        hunger = inTable[needIdx][1],
        happiness = inTable[needIdx][2],
        hygiene = inTable[needIdx][3],
        energy = inTable[needIdx][4],
        exp = inTable[needIdx][5]
    	}
        -- needsLevels = inTable[needIdx + 1]
        needsLevels = 
        {
        hunger = inTable[needIdx + 1][1],
        happiness = inTable[needIdx + 1][2],
        hygiene = inTable[needIdx + 1][3],
        energy = inTable[needIdx + 1][4],
        exp = inTable[needIdx + 1][5]
    	}
        monsterLevel = inTable[needIdx + 2]

    else
    	foodRecentList = {}
        playRecentList = {}

        itemList = {}
        itemQuantities = {}
        gold = 9999999
        platinum = 9999999

        maxNeedsLevels = {
            hunger = 2880,
            happiness = 2880,
            hygiene = 2880,
            energy = 2880,
            exp = 2880,
        }
        needsLevels = {
            hunger = 1440,
            happiness = 1440,
            hygiene = 1440,
            energy = 1440,
            exp = 1440,
        }
        monsterLevel = 1

    end

    print("Load by Data Sage")
    print(getHungerLevel(), needsLevels.hunger, gold, platinum)
end
-- -------------------------------------------------------------------------------
-- Inventory Data
function getInventoryData()
	return itemList, foodRecentList, playRecentList, itemQuantities, gold, platinum
end

function getGold()
	return gold
end

function getPlatinum()
	return platinum
end

-- Need levels

function getNeedsLevels()
    return needsLevels
end

function getMaxNeedsLevels()
    return maxNeedsLevels
end

function getHungerLevel()
    return needsLevels.hunger
end

function getHappinessLevel()
    return needsLevels.happiness
end

function getHygieneLevel()
    return needsLevels.hygiene
end

function getEnergyLevel()
    return needsLevels.energy
end

function getExpLevel()
    return needsLevels.exp
end

-- --------------------------------

function setNeedsLevels(in_needsLevels)
    needsLevels = in_needsLevels
end

-- Monster
function getMonsterLevel()
	return monsterLevel
end

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