local monsterDir = "img/sprites/"

local monsterList =  {"fireball","pikachu","cat"};

-- -------------------------------------------------------------------------------
-- Monster Img + State Attr

local monsterImageAttr = {
	{ --fireball
		monsterDir.."fireball2.png",3120,4630,8,10,80,0.3,
	}, 
	{ --pikachu
		monsterDir.."pikachu.png",780,255,6,2,12,1,
	}, 
	{ --cat
		monsterDir.."cat.png",500,300,10,6,60,3,
	}, 
}

local monsterStates = {
	{ --fireball
	    {"normal",1,32,200*32,0,"forward"},
	    {"sad",33,16,200*16,0,"forward"},
	    {"sleep",49,16,200*16,0,"forward"},
	    {"eat",65,16,200*16,0,"forward"},
	},
	{ --pikachu
	    {"normal",1,6,200*6,0,"forward"},
	    {"sleep",7,6,200*6,0,"forward"},
	},
	{ --cat
	    {"normal",4,28,200*14,0,"forward"},
	    {"sad",32,18,200*9,0,"forward"},
	    {"sleep",32,18,200*9,0,"forward"},
	    {"eat",41,40,200*20,0,"forward"},
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