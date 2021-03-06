local monsterDir = "img/sprites/"

local monsterList =  {"fireball","pikachu","cat","egg_electric","voltorb","electrode"};

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
	{ --egg_electric
		monsterDir.."egg_electric.png",2400,600,8,2,16,0.5,
	}, 
	{ --voltorb
		monsterDir.."voltorb.png",255,187,7,5,30,1.5,
	}, 
	{ --electrode
		monsterDir.."electrode.png",496,276,9,5,38,1.5,
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
	{ --egg_electric
	    {"normal",1,8,200*8,0,"forward"},
	    {"sleep",9,8,200*8,0,"forward"},
	    {"eat",9,8,200*8,0,"forward"},
	},
	{ --voltorb
	    {"normal",1,5,150*5,0,"forward"},
	    {"sad",6,1,50*1,0,"forward"},
	    {"sleep",8,14,50*14,0,"forward"},
	    {"eat",22,9,50*9,0,"forward"},
	},
	{ --electrode
	    {"normal",1,8,150*8,0,"forward"},
	    {"sad",9,1,50*1,0,"forward"},
	    {"sleep",10,17,50*17,0,"forward"},
	    {"eat",27,12,50*12,0,"forward"},
	},
}

-- -------------------------------------------------------------------------------
-- Monster Description
-- In order: DisplayName, Height, Weight, Description, levelToEvolve, nextEvolution

local monsterDescription = {
	{ --fireball
	    "Fireball", 61, 15.2, "Heat Up Your Life With this Adorable Creature", nil, nil,
	},
	{ --pikachu
	    "Pikachu", 87, 18.0, "Pika-Pika-Pikachuuuuu", nil, nil,
	},
	{ --cat
	    "Ninja Cat", 101, 9.6, "Wax On, Wax Off, repeat", 1, "pikachu",
	},
	{ --egg_electric
	    "Egg", 55, 8.8, "I wonder who's inside?", 2, "voltorb",
	},
	{ --voltorb
	    "Voltorb", 42, 11.3, "Beware of elctrocution", 5, "electrode",
	},
	{ --electrode
	    "Electrode", 85, 22.2, "Danger: High Voltage", nil, nil,
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

function getMonsterDescription(monsterName)
	for i = 1, #monsterList do
		if (monsterName == monsterList[i]) then
			return monsterDescription[i]
		end
	end
end

-- -------------------------------------------------------------------------------