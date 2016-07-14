local backgroundDir = "img/bg/"

local backgroundList =  {"fireball","pikachu","cat","egg","voltorb","electrode"};

-- -------------------------------------------------------------------------------
-- Background Img + Dimensions

local backgroundImageAttr = {
	{ --grassland
		backgroundDir.."grassland.png",1136,640,
	}, 
	{ --fantasy
		backgroundDir.."fantasy.jpg",600,450,
	}, 
	{ --hotday
		backgroundDir.."hotday.png",850,511,
	}, 
	{ --ice
		backgroundDir.."ice.png",1280,960,
	}, 
	{ --jungle
		backgroundDir.."jungle.png",1280,960,
	}, 
	{ --mystery
		backgroundDir.."mystery.jpg",1000,375,
	}, 
}

-- -------------------------------------------------------------------------------

function getBackgroundList()
	return backgroundList
end

-- Get Background Attr Info

function getBackgroundInfo(backgroundName)
	for i = 1, #backgroundList do
		if (backgroundName == backgroundList[i]) then
			return backgroundImageAttr[i]
		end
	end
end

-- -------------------------------------------------------------------------------