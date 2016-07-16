local backgroundDir = "img/bg/"

local backgroundList =  {"hotday","grassland","mountains","ice","jungle","mystery", "castle", "dragon", "opera", "underwater", "underwater2","dark-castle"};

-- -------------------------------------------------------------------------------
-- Background Img + Dimensions

local backgroundImageAttr = {
	{ --hotday
		backgroundDir.."hotday.png",850,511,
	},
	{ --grassland
		backgroundDir.."grassland.png",1136,640,
	}, 
	{ --fantasy
		backgroundDir.."mountains.jpg",736,437,
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
	{ --castle
		backgroundDir.."castle.jpg",1191,670,
	},
	{ --dragon
		backgroundDir.."dragon.jpg",2917,1839,
	},
	{ --opera
		backgroundDir.."opera.png",1136,640,
	},
	{ --underwater
		backgroundDir.."underwater.jpg",1656,931,
	},
	{ --underwater2
		backgroundDir.."underwater2.jpg",800,544,
	},
	{ --dark-castle.png
		backgroundDir.."dark-castle.png",960,644,
	},
}

-- -------------------------------------------------------------------------------

function getBackgroundList()
	return backgroundList
end

-- Get Background Attr Info

function getBackgroundInfo(idx)
	return backgroundImageAttr[idx]
end

-- -------------------------------------------------------------------------------