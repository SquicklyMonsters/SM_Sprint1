local goldMoney = 300 --default goldMoney
local goldAmount


-- These really do what they say they do, pretty self explanatory

--FOR GOLD

function increaseGold(goldAmount)
	goldMoney = goldMoney + goldAmount
	print("goldMoney" .. goldMoney)
end

function decreaseGold(goldAmount)
	-- if (goldMoney - goldAmount) >= 0 then
		goldMoney = goldMoney - goldAmount
		print("goldMoney" .. goldMoney)	
	-- end

end

function checkSufficientGold(goldAmount)
	if (goldMoney - goldAmount) >= 0 then
		return true	
	else
		return false
	end
end

function returnCurrentGold()
	return 300--goldMoney
end

-- -----------------------------------------------------------------------
--FOR PLATINUM

local platinumMoney = 0 --default platinumMoney
local platinumAmount

function increasePlatinum(platinumAmount)
	platinumMoney = platinumMoney + platinumAmount
	print("platinumMoney" .. goldMoney)
end

function decreasePlatinum(platinumAmount)
	if (platinumMoney - platinumAmount) >= 0 then
		platinumMoney = platinumMoney - platinumAmount
		print("platinumMoney" .. goldMoney)
	end
end

function checkSufficientPlatinum(platinumAmount)
	if (platinumMoney - platinumAmount) >= 0 then
		return true	
	else
		return false
	end
end

function returnCurrentPlatinum()
	return platinumMoney
end