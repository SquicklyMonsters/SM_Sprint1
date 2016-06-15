local goldMoney = 300 --default goldMoney


-- These really do what they say they do, pretty self explanatory

--FOR GOLD

function increaseGold(goldAmount)
	goldMoney = goldMoney + goldAmount
end

function decreaseGold(goldAmount)
	goldMoney = goldMoney - goldAmount

end

function checkSufficientGold(goldAmount)
	if (goldMoney - goldAmount) >= 0 then
		return true	
	else
		return false
	end
end

function returnCurrentGold()
	return goldMoney
end

-- -----------------------------------------------------------------------
--FOR PLATINUM

local platinumMoney = 0 --default platinumMoney

function increasePlatinum(platinumAmount)
	platinumMoney = platinumMoney + platinumAmount
end

function decreasePlatinum(platinumAmount)
	platinumMoney = platinumMoney - platinumAmount
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

-- function loadCurrency()
-- 	goldMoney, platinumMoney = loadCurrencyData()
-- end