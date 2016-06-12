require("savegame") -- For Testing
local composer = require("composer")
-- -------------------------------------------------------------------------------
-- Local variables go HERE

local background;

local sleepWakeID;

local inventoryIcon;

-- -------------------------------------------------------------------------------

function cacheVariables()
    background = getBackground()

    -- Cache Icons
    inventoryIcon = getInventoryIcon()
end
-- -------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------
-- Hide / Show Icons with Lock

function inventoryClicked(event)
    if event.phase == "ended" then
        if inventoryIsShow then
            composer.gotoScene(composer.getSceneName("current"))
            inventoryIsShow = false
        else
            composer.showOverlay("inventory")
            inventoryIsShow = true
        end
    end
end

-- -------------------------------------------------------------------------------
-- Add All Event Listeners Here

