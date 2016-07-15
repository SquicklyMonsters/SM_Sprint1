
local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()
require("itemList")
require("itemClass")
require("data")

-- -------------------------------------------------------------------------------
-- Local variables go HERE
local invenList;
local foodRecentList;
local playRecentList;
local itemQuantities;
local itemTexts = {};

local inventory;
local dailyRewardPanel;
local itemList = getItemList()

local stackLogInCount = getDailyLoginCount()
local clockText;
local tickLoop;

-- If you want to change reward in daily reward, you just need to change
-- itemsOfReward. The item that can be changed depend on the itemList file.
-- Therefore, you have to add item in itemList file first.
local itemsOfReward = {
			"burger", "burger", "icecream", "fish",
			"ball", "chucky", "cards"
			}

-- ----------------------------------------------------------------

function isItRewardTime() -- calculates how much time is left for reward, returns false if done
													-- lastTime = loadLastRewardDate()
		local receiveDate = getReceiveDate()
		local currentDate = os.date( '*t' )
		if receiveDate == nil then -- receiveDate is false if user has never gotten daily reward before
				return false, currentDate, nil
		end

		setTime = os.time{  year = receiveDate.year, month = receiveDate.month, day = receiveDate.day,
			              	hour = receiveDate.hour, min = receiveDate.min, sec = receiveDate.sec }
		endTime = os.time{  year = currentDate.year, month = currentDate.month, day = currentDate.day,
			                hour = currentDate.hour, min = currentDate.min, sec = currentDate.sec }

		local rewardTimer = ( endTime - setTime ) -- difference in seconds
		limit = 24*60*60											-- 24 hours in sec
		-- limit = 1				-- this is for test, which can claim item in 1 sec
		if rewardTimer >= limit then
				return true, currentDate, rewardTimer
		end

		return false, currentDate, rewardTimer
end

-- ----------------------------------------------------------------

function tickTick()  -- Count down the clock function
		timeleft, currentDate, rewardTimer = isItRewardTime()
		tmp = 24*60*60 - rewardTimer
		if (tmp <= 0) or (rewardTimer == nil) then  -- This handle the case where the timer with go negative
				hours = 0
				minutes = 0
				seconds = 0
		else
				hours = math.floor(tmp/(60*60))
				minutes = math.floor((tmp - (hours*60*60)) / 60)
				seconds = tmp - (minutes*60) - (hours*60*60)
		end
		timeDisplay = string.format( "%02d:%02d:%02d", hours, minutes, seconds )
		clockText.text = timeDisplay
end

-- ----------------------------------------------------------------

function setUpRewardTime()
		timeleft, currentDate, rewardTimer = isItRewardTime()
		if rewardTimer == nil then
				rewardTimer = 24*60*60
		end
		tmp = 24*60*60 - rewardTimer
		hours = math.floor(tmp/(60*60))
		minutes = math.floor((tmp - (hours*60*60)) / 60)
		seconds = tmp - (minutes*60) - (hours*60*60)
		timeDisplay = string.format( "%02d:%02d:%02d", hours, minutes, seconds )
		clockText = display.newText(timeDisplay, -(dailyRewardPanel.width)/20 + 25, -dailyRewardPanel.height/7 -20, native.systemFontBold, 80)
		clockText:setFillColor( 0.7, 0.7, 1 )
		if tmp > 0 then
				tickLoop = timer.performWithDelay(1000, tickTick, -1)
		end
end

-- ----------------------------------------------------------------

function closeEvent(event)
		if event.phase == "ended" then
    		dailyRewardClicked(event)
				if tickLoop == nil then
						emergencyClose()
				else
						timer.cancel(tickLoop)
				end
  	end
end

-- ----------------------------------------------------------------

function widget.newPanel(options)
		local myRoundedRect = display.newRoundedRect( 0, 0, 380, 280, 12 )
		myRoundedRect.strokeWidth = 3
		myRoundedRect:setFillColor( 0.5 )
		myRoundedRect:setStrokeColor( 1, 0, 0 )
	  -- local background = display.newImage(options.imageDir)
	  local container = display.newContainer(options.width, options.height)
	  container:insert(myRoundedRect, true)
	  container.x = display.contentCenterX
	  container.y = display.contentCenterY
	  return container
end

-- ----------------------------------------------------------------

function setUpDailyReward()
  	dailyRewardPanel = widget.newPanel {
    height = 390,
    width = 390,
  }
		local slot = display.newImage("img/others/NEW2.png")
		dailyRewardPanel:insert(slot)
		-- local myRoundedRect = display.newRoundedRect( 0, 0, 380, 280, 12 )
		-- myRoundedRect.strokeWidth = 3
		-- myRoundedRect:setFillColor( 0.5 )
		-- myRoundedRect:setStrokeColor( 1, 0, 0 )
		-- dailyRewardPanel:insert(myRoundedRect)
-- Add 7 item in the reward slot panel
  	local startX = -dailyRewardPanel.width*(1/2)
  	local startY = -dailyRewardPanel.height*(1/20)
  	local spacingX = (dailyRewardPanel.width)/9
  	local spacingY = dailyRewardPanel.height/9

  	for t = 1, 7 do
    		local x = startX
    		local y = startY
				local item = itemList[itemsOfReward[t]] -- get all item in the itemsOfReward
				local itemIcon = display.newImage(item.image, ((x+5) + spacingX*(t))+20, y+20)
				itemIcon:scale(0.8, 0.8)
    		dailyRewardPanel:insert(itemIcon)

		for i = 1, stackLogInCount do
				local x = startX
				local y = startY
				local cross = display.newImage("img/others/cross.png", ((x+5) + spacingX*(i))+20, y+20)
				cross:scale(0.1, 0.1)
				dailyRewardPanel:insert(cross)

		end
end

-- ----------------------------------------------------------------

function emergencyClose()
		dailyRewardPanel:removeSelf()
end

-- ----------------------------------------------------------------

function getDailyReward(event)
		if event.phase == "ended" then
				timeleft, currentDate, rewardTimer = isItRewardTime()
				if timeleft == true or rewardTimer == nil then -- if the timer is done
						-- reward animation
						-- add to inventory
						stackLogInCount = stackLogInCount + 1
						local getItem = itemList[itemsOfReward[stackLogInCount]]
						local idx = isInInventory(getItem.name)
						if idx then
								increaseQuantity(idx)
						else
								addToInventory(item.name)
						end
						print("GET REWARD!")

						-- reset timer and save date
						-- saveRewardTimerData()
						setReceiveDate(currentDate)
						for i = 1, stackLogInCount do
								local x = startX
			  				local y = startY
								cross = display.newImage("img/others/cross.png", ((x+5) + spacingX*(i))+20, y+20)
								cross:scale(0.1, 0.1)
			    			dailyRewardPanel:insert(cross)
			  		end
						print (tmp)
						if tmp == 0 then
								tickLoop = timer.performWithDelay(1000, tickTick, -1)
						end
						if stackLogInCount == 7 then
								timer.performWithDelay(5000, emergencyClose)
								stackLogInCount = 0
						end
						setDailyLoginReward(stackLogInCount)
						saveData()
				end
		end
end
-- ------------------------------------------------------------
-- Create close button and create claim reward button
  dailyRewardPanel.close = widget.newButton {
    -- top = startY - (spacingY),
    -- left = startX + (spacingX*7.5),
		top = startY - (spacingY * 3),
		left = startX +(spacingX * 8) ,
    width = 50,
    height = 50,
    defaultFile = "img/bg/close.png",
    onEvent = closeEvent,
  }

  dailyRewardPanel.claim = widget.newButton {
    top = startY - (spacingY*-1.1),
    left = startX + (spacingX),
    width = 300,
    height = 50,
    defaultFile = "img/others/claim-reward2.png",
		onEvent = getDailyReward,
  }
-- ---------------------------------------------------------------
-- insert all the button
	setUpRewardTime()
	dailyRewardPanel:insert(dailyRewardPanel.close)
  dailyRewardPanel:insert(dailyRewardPanel.claim)
	dailyRewardPanel:insert(clockText)

  -- dailyRewardPanel:scale(
  --       (display.contentWidth/dailyRewardPanel.width)*0.4,
  --       (display.contentHeight/dailyRewardPanel.height)*0.5
  --       )
  return dailyRewardPanel
end

-- --------------------------------------------------------------------------------------------------------------------

function scene:create( event )
  local sceneGroup = self.view
  -- local myRectangle = display.newRect( 0, 0, 150, 50 )
  dailyRewardPanel = setUpDailyReward()
  sceneGroup:insert(dailyRewardPanel)
	print(composer.getSceneName("current"))
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase


	if phase == "will" then
		-- composer.hideOverlay()
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		--
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
        --composer.hideOverlay()
		-- Called when the scene is now off screen
	end
end

function scene:destroy( event )
	-- Save data before exit
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
