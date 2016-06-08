require("homepage.UI")
local json = require("json")
-- -----------------------------------------------------------------------------------------------------------------
-- Some forward declarations
local maxNeedsLevels;
local needsLevels;

-- Set location for saved data
local filePath = system.pathForFile( "data.txt", system.DocumentsDirectory )

-- -------------------------------------------------------------------------------
-- Save functions

function saveData()
	print("saved file")
    maxNeedsLevels = getMaxNeedsLevels()
    needsLevels = getCurrentNeedsLevels()
    local outTable = {maxNeedsLevels, needsLevels}

    file = io.open( filePath, "w" )

    local contents = json.encode(outTable)
    file:write(contents)
    
    io.close(file)
end
