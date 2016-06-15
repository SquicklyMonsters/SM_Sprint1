-- Some forward declarations


-- Load external libraries
local json = require("json")

-- Set location for saved data
local needsDataFile = system.pathForFile( "needsData.txt", system.DocumentsDirectory ) -- Default Dir
local inventoryDataFile = system.pathForFile( "inventoryData.txt", system.DocumentsDirectory )
local currencyDataFile = system.pathForFile( "currencyData.txt", system.DocumentsDirectory )

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
    end
    return needsLevels, maxNeedsLevels
end
-- -------------------------------------------------------------------------------

function loadInventoryData()
    local file = io.open( inventoryDataFile, "r" )
    -- local itemList = {"burger", "icecream", "fish", "noodles"}
    -- local itemQuantities = {2, 3, 4, 5}

    if file then
        local inTable = readFile(file)
        itemList = inTable[1]
        itemQuantities = inTable[2]
        gold = inTable[3]
        platinum = inTable[4]
    end

    return itemList, itemQuantities, gold, platinum
end
