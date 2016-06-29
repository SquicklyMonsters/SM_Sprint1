-- Some forward declarations


-- Load external libraries
local json = require("json")

-- Set location for saved data
local needsDataFile = system.pathForFile( "needsData.txt", system.DocumentsDirectory ) -- Default Dir
local inventoryDataFile = system.pathForFile( "inventoryData.txt", system.DocumentsDirectory )
local rewardDateDataFile = system.pathForFile( "rewardsData.txt", system.DocumentsDirectory )

-- -------------------------------------------------------------------------------
-- Get latest Data from Save file
function getSavedLevels()
    return loadNeedsData()
end

-- -------------------------------------------------------------------------------
function readFile(file)
    -- read all contents of file into a string
    -- local contents = file:read( "*a" )
    -- inTable = json.decode(contents);
    -- io.close( file ) -- important!
    local contents = file:read( "*a" )
    inTable = json.decode(contents);
    io.close( file ) -- important!
    return inTable
end
-- -------------------------------------------------------------------------------
-- Load functions
function loadNeedsData()
    local file = io.open( needsDataFile, "r" )
    local needsLevels = {}
    local maxNeedsLevels = {}

    if file then
        local inTable = readFile(file)
        maxNeedsLevels = inTable[1]
        needsLevels = inTable[2]
        monsterLevel = inTable[3]
        -- print("load")
    else
        -- print ("no file found")
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
    return needsLevels, maxNeedsLevels, monsterLevel
end
-- -------------------------------------------------------------------------------

function loadInventoryData()
    local file = io.open( inventoryDataFile, "r" )

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
    
    return itemList, foodRecentList, playRecentList, itemQuantities, gold, platinum
end
-- -------------------------------------------------------------------------------

function loadLastRewardDate()
    local file = io.open( rewardDateDataFile, "r" )

    if file then
        local inTable = readFile(file)
        lastRewardDate = inTable[1]
    else
        lastRewardDate = false
    end

    return lastRewardDate
end