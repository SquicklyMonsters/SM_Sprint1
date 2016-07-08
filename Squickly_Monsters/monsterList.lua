local monsterDir = "img/sprites/"

local monsterList =  {"fireball"};

-- -------------------------------------------------------------------------------
-- Monster Img + State Attr

local monsterImageAttr = {
	{ --fireball
		monsterDir.."fireball2.png",3120,4630,8,10,80,
	}, 
}

local monsterStates = {
	{ --fireball
	    {"normal",1,32,200*32,0,"forward"},
	    {"sad",33,16,200*16,0,"forward"},
	    {"sleep",49,16,200*16,0,"forward"},
	    {"eat",65,16,200*16,0,"forward"},
	},
}

-- -------------------------------------------------------------------------------
-- Get Monster Attr Info

function getMonsterInfo(monsterName)
	for i = 1, #monsterList do
		if (monsterName == monsterList[i]) then
			return monsterImageAttr[i], monsterStates[i]
		end
	end
end

-- -------------------------------------------------------------------------------