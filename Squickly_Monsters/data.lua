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

local hungerRate = -50;
local happinessRate = -50;
local hygieneRate = -50;
local energyRate = -50;

local dataFile = system.pathForFile( "data.txt", system.DocumentsDirectory )

-- -------------------------------------------------------------------------------

function writeFile(file, contents)
    file = io.open(file, "w")
    file:write(contents)
    io.close(file)    
end

function saveData()
    local outTable = {itemList, foodRecentList, playRecentList, itemQuantities, gold, platinum}
    local contents = json.encode(outTable)
    writeFile(dataFile, contents)
    print("Save by Data Sage")
end

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
        itemList = inTable[1]
        foodRecentList = inTable[2]
        playRecentList = inTable[3]
        itemQuantities = inTable[4]
        gold = inTable[5]
        platinum = inTable[6]
    else
        itemList = {}
        foodRecentList = {}
        playRecentList = {}
        itemQuantities = {}
        gold = 0
        platinum = 0
    end

    print("Load by Data Sage")
end
-- -------------------------------------------------------------------------------
-- Inventory Data
function getInventoryData()
	loadData()
	return itemList, foodRecentList, playRecentList, itemQuantities, gold, platinum
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