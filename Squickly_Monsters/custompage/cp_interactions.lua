local composer = require("composer")
require("monsterList")

-- -------------------------------------------------------------------------------
-- Local variables go HERE
local resizer = display.contentHeight/320

local evolveIcon;
local HW_display;
local disc_display;

local DisplayName;
local Height;
local Weight;
local Description;
local levelToEvolve;
local nextEvolution;

-- -------------------------------------------------------------------------------

function displayAllMonsterDescriptions(monsterName)
    local displayTable = getMonsterDescription(monsterName)
    DisplayName, Height, Weight, Description, levelToEvolve, nextEvolution = displayTable[1],displayTable[2],displayTable[3],displayTable[4],displayTable[5],displayTable[6]
    evolveIcon = displayEvolveIcon(levelToEvolve, nextEvolution)
    HW_display = setUpText("H: "..Height.."cm, W: "..Weight.."kg", 20, display.contentCenterX-150*resizer, display.contentCenterY-50*resizer, 1)
    disc_display = setUpText(Description,  20, display.contentCenterX-150*resizer, display.contentCenterY-100*resizer, 1)
    return evolveIcon, HW_display, disc_display
end

-- -------------------------------------------------------------------------------
-- Hide / Show Display Stuff

function setUpIcon(img, scale, x, y, alpha)
    icon = display.newImage(img, x, y)
    icon:scale(scale, scale)
    icon.alpha = alpha
    return icon
end

function setUpText(text, size, x, y, alpha)
    displayText = display.newText(text, x, y, native.systemFontBold, size)
    displayText:setFillColor( 1.0, 1.0, 1.0 )
    displayText.alpha = alpha
    return displayText
end

function displayEvolveIcon(levelToEvolve, nextEvolution)
    if nextEvolution ~= nil then
        if getMonsterLevel() >= levelToEvolve then
            local iconFile
            if string.starts(nextEvolution, "egg") then
                iconFile = "img/icons/UIIcons/hatchEggIcon.png"
            else
                iconFile = "img/icons/UIIcons/evolveNow.png"
            end
            return setUpIcon(iconFile, 0.7*resizer, display.contentCenterX+100*resizer, display.contentCenterY-100*resizer, 1)
        end
    end
end
-- -------------------------------------------------------------------------------
-- Set reaction when press button

function evolveButtonClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            
        end
    end
end

-- -------------------------------------------------------------------------------
-- Add All Event Listeners Here

function addListeners()
    evolveIcon:addEventListener("touch", evolveButtonClicked)
end
