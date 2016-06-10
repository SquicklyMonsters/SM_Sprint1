require("savegame") -- For Testing
local composer = require("composer")
-- -------------------------------------------------------------------------------
-- Local variables go HERE

local background;

local sleepWakeID;

local inventoryIcon;
local isTouchAble;
local inventoryIsShow = false;
-- -------------------------------------------------------------------------------

function cacheVariables()
    background = getBackground()

    -- Cache Icons
    inventoryIcon = getInventoryIcon()

    -- Instantiate hide/show icons lock
    isTouchAble = true

end
-- -------------------------------------------------------------------------------

-- -------------------------------------------------------------------------------
-- Hide / Show Icons with Lock

function inventoryClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            if inventoryIsShow then
                composer.gotoScene(composer.getSceneName("current"))
                saveInventoryData()
                inventoryIsShow = false
            else
                composer.showOverlay("inventory")
                inventoryIsShow = true
            end
        end
    end
end

-- -------------------------------------------------------------------------------
-- Add All Event Listeners Here

function addListeners()
    ---- Tag along ----
    cacheVariables()
    setDecrementRate()
    -------------------

    background:addEventListener("touch", backgroundClicked)

    inventoryIcon:addEventListener("touch", inventoryClicked)
end
