require("homepage.UI")
local json = require("json")
-- -----------------------------------------------------------------------------------------------------------------
-- Some forward declarations
local maxNeedsLevels;
local needsLevels;
local saveRate;

-- Set location for saved data
local filePath = system.pathForFile( "data.txt", system.DocumentsDirectory )

-- -------------------------------------------------------------------------------
-- Set Auto Save rate
function setAutoSaveRate(rate) -- 1000 = 1sec
	if saveRate~= nil then
		timer.cancel(saveRate)
	end
    saveRate = timer.performWithDelay(rate, saveData, -1)
end

-- -------------------------------------------------------------------------------
-- Save functions

function saveData()
	-- print("saved file")
    maxNeedsLevels = getMaxNeedsLevels()
    needsLevels = getCurrentNeedsLevels()
    local outTable = {maxNeedsLevels, needsLevels}

    file = io.open( filePath, "w" )

    local contents = json.encode(outTable)
    file:write(contents)
    
    io.close(file)
end
