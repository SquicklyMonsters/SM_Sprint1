require("homepage.interactions")
require("homepage.UI")
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Some forward declarations
local maxNeedsLevels;
local needsLevels;

-- Load external libraries
local str = require("str")

-- Set location for saved data
local filePath = system.pathForFile( "data.txt", system.DocumentsDirectory )

-- -------------------------------------------------------------------------------
-- Get latest Data from Save file
function getSavedLevels()
    loadData()
    return needsLevels, maxNeedsLevels
end

-- -------------------------------------------------------------------------------
-- Save/load functions

function saveData()
    
    --local levelseq = table.concat( levelArray, "-" )

    maxNeedsLevels = getMaxNeedsLevels()
    needsLevels = getCurrentNeedsLevels()

    file = io.open( filePath, "w" )
    
    file:write( "max" .. "=" .. maxNeedsLevels .. "," )
    file:write( "needs" .. "=" .. needsLevels .. "," )
    
    io.close( file )
end

function loadData() 
    local file = io.open( filePath, "r" )
    
    if file then

        -- Read file contents into a string
        local dataStr = file:read( "*a" )
        
        -- Break string into separate variables and construct new table from resulting data
        local datavars = str.split(dataStr, ",")
        
        for i = 1, #datavars do
            -- split each name/value pair
            local curr = str.split(datavars[i], "=")
            if (curr[1] == "max") then
                maxNeedsLevels = curr[2]
            elseif (curr[1] == "needs") then
                needsLevels = curr[2]
            else
                print("error: wrong file format")
            end
        end
    
        io.close( file ) -- important!

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