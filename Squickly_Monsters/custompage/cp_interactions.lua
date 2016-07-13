local composer = require("composer")
-- -------------------------------------------------------------------------------
-- Local variables go HERE
local resizer = display.contentHeight/320

local monster;
local background;

local hatchIcon;
local evolveIcon;

local isTouchAble;
-- -------------------------------------------------------------------------------

function cacheVariables()
    monster = getMonster()
    background = getBackground()

    -- Cache Icons
    hatchIcon = getHatchIcon()
    evolveIcon = getEvolveIcon()

    -- Create lists
    -- nextIcon = hatchIcon

    -- Instantiate hide/show icons lock
    isTouchAble = true
end

-- -------------------------------------------------------------------------------
-- Hide / Show Icons with Lock

-- function enableHomeTouch()
--     isTouchAble = true
-- end

-- function disableHomeTouch()
--     isTouchAble = false
-- end

function hideShowAllIcons(iconsTable)
    xAxis = {-110*resizer,-45*resizer,45*resizer,110*resizer} -- idx 1=play, 2=clean, 3=sleep/wakeup, 4=feed
    yAxis = {70*resizer,120*resizer,120*resizer,70*resizer}
    monster = getMonster()

    isTouchAble = false
    if (iconsTable[1].alpha) == 0 then -- Show Icons
        for i = 1, #iconsTable do
            transition.to(iconsTable[i],
                {x = monster.x + xAxis[i], y = monster.y - yAxis[i],
                alpha = 1, time = 250})
        end
        currentVisibleList = iconsTable
    else -- Hide Icons
        for i = 1, #iconsTable do
            transition.to(iconsTable[i],
                {x = monster.x, y = monster.y,
                alpha = 0, time = 250})

        end
        currentVisibleList = nil
    end
    -- Release lock after icons transition is finish
    timer.performWithDelay(250, enableHomeTouch)
end
-- -------------------------------------------------------------------------------
-- Set reaction when press button

-- function monsterClicked(event)
--     if isTouchAble then
--         if event.phase == "ended" then
--             if (currentVisibleList == nil) then
--                 hideShowAllIcons(iconsList)
--             else
--                 hideShowAllIcons(currentVisibleList)
--             end
--         end
--     end
-- end

-- function backgroundClicked(event)
--     if isTouchAble then
--         if event.phase == "ended" then
--             if (currentVisibleList ~= nil) then
--                 hideShowAllIcons(currentVisibleList)
--             end
--             getMenuBar():hide()
--         end
--     end
-- end

function hatchButtonClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(iconsList)
            changeToSleepState()
        end
    end
end

function evolveButtonClicked(event)
    if isTouchAble then
        if event.phase == "ended" then
            hideShowAllIcons(iconsList)
            changeToWakeupState()
        end
    end
end

-- -------------------------------------------------------------------------------
-- Add All Event Listeners Here

function addListeners()
    -- cacheVariables()

    -- monster:addEventListener("touch", monsterClicked)
    -- background:addEventListener("touch", backgroundClicked)
    hatchIcon:addEventListener("touch", hatchButtonClicked)
    evolveIcon:addEventListener("touch", evolveButtonClicked)
end
