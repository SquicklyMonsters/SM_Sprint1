local monsterDir = "img/sprites/"

local monsterList =  {"fireball","pikachu","cat","egg"};

-- -------------------------------------------------------------------------------
-- Monster Img + State Attr

local monsterImageAttr = {
	{ --fireball
		monsterDir.."fireball.png",3104,4600,8,10,80,0.3,
	}, 
	{ --pikachu
		monsterDir.."pikachu.png",780,255,6,2,12,1,
	}, 
	{ --cat
		monsterDir.."cat.png",500,300,10,6,60,3,
	}, 
	{ --egg
		monsterDir.."egg.png",2400,600,8,2,16,0.5,
	}, 
}

local monsterStates = {
	{ --fireball
	    {"normal",1,32,150*32,0,"forward"},
	    {"sad",33,16,150*16,0,"forward"},
	    {"sleep",49,16,150*16,0,"forward"},
	    {"eat",65,16,150*16,0,"forward"},
	},
	{ --pikachu
	    {"normal",1,6,200*6,0,"forward"},
	    {"sleep",7,6,200*6,0,"forward"},
	},
	{ --cat
	    {"normal",4,28,200*14,0,"forward"},
	    -- {"sad",32,18,200*9,0,"forward"},
	    {"sleep",32,18,200*9,0,"forward"},
	    {"eat",41,40,200*20,0,"forward"},
	},
	{ --egg
	    {"normal",1,8,200*8,0,"forward"},
	    {"sleep",9,8,200*8,0,"forward"},
	    {"eat",9,8,200*8,0,"forward"},
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