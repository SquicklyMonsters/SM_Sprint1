require("homepage.UI")
local json = require("json")
-- -----------------------------------------------------------------------------------------------------------------
-- Some forward declarations
-- local maxNeedsLevels;
-- local needsLevels;
local saveRate;

-- Set location for saved data
local needsDataFile = system.pathForFile( "needsData.txt", system.DocumentsDirectory )
local inventoryDataFile = system.pathForFile( "inventoryData.txt", system.DocumentsDirectory )

-- -------------------------------------------------------------------------------
-- Set Auto Save rate
function setAutoSaveRate(rate) -- 1000 = 1sec
	if saveRate~= nil then
		timer.cancel(saveRate)
	end
    saveRate = timer.performWithDelay(rate, saveAllData, -1)
end

-- -------------------------------------------------------------------------------
function writeFile(file, contents)
    file = io.open(file, "w")
    file:write(contents)
    io.close(file)    
end
-- -------------------------------------------------------------------------------
-- Save functions
function saveAllData()
    saveNeedsData()
    saveInventoryData()
end

function saveNeedsData()
	-- print("saved file")
    local maxNeedsLevels = getMaxNeedsLevels()
    local needsLevels = getCurrentNeedsLevels()
    
    local outTable = {maxNeedsLevels, needsLevels}
    local contents = json.encode(outTable)
        
    writeFile(needsDataFile, contents)
    print("save")
end

function saveInventoryData()
    local itemList = getItemList()
    local foodRecentList = getFoodRecentList()
    local playRecentList = getPlayRecentList()
    local itemQuantities = getItemQuantities()
    local gold = getCurrentGold()
    local platinum = getCurrentPlatinum()

    local outTable = {itemList, foodRecentList, playRecentList, itemQuantities, gold, platinum}
    local contents = json.encode(outTable)


    writeFile(inventoryDataFile, contents)
    print("save inv")
end