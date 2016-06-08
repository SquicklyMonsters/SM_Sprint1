-- Some forward declarations
local maxNeedsLevels;
local needsLevels;

-- Load external libraries
local json = require("json")

-- Set location for saved data
local filePath = system.pathForFile( "data.txt", system.DocumentsDirectory )

-- -------------------------------------------------------------------------------
-- Get latest Data from Save file
function getSavedLevels()
    loadData()
    return needsLevels, maxNeedsLevels
end

-- -------------------------------------------------------------------------------
-- Load functions

function loadData() 
    print(filePath)
    local file = io.open( filePath, "r" )
    needsLevels = {}
    maxNeedsLevels = {}
    
    if file then
        local inTable = {}

        -- read all contents of file into a string
        local contents = file:read( "*a" )
        inTable = json.decode(contents);
        io.close( file ) -- important!

        print(inTable)
        maxNeedsLevels = inTable[1]
        needsLevels = inTable[2]
    else
        print ("no file found")
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
end
-- -------------------------------------------------------------------------------