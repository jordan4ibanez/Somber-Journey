--[[
Goals:

do a completely modular system - have a bunch of parts that mesh together, layer together images and just go crazy basically - goal: 100,000 types of weapons

over 400 types of weapons -
each with their base set of things
-accuracy, fire rate, semi-full-single action etc, make every part of the gun modular, make every part of it customizable, aka let's have a scoped chain gun magnum with a silencer and hand grip

Go insane with this

--play different songs based on the country of origin, for example, picking up an ak47 http://incompetech.com/music/royalty-free/index.html?isrc=USUAN1100606

http://www.macmillandictionary.com/us/thesaurus-category/american/types-of-gun-and-general-words-for-gun

]]--

--if accuracy is above 100 then add a point to damage for every 10 points over it is when attached
--make addons like chain fed, scopes, silencers, bayonets, etc

gun_table = {
	pistol = {
		M2111 = { --gun like the 1911
			--base stats
			damage   = 3,     --damage per shot hit
			accuracy = 30,    --chance of hitting the target out of 100
			firerate = 1,     --cooldown period in seconds
			ammo     = 0.45,  --need to make corrisponding ammo items
			--feed mods
			auto     = false, --if true then you can hold down the mouse to shoot it, otherwise you have to click
			chain    = false, --if true then subtract 0.7 from the fire rate when attached and make auto true
			--accuracy mods
			gripped  = false, --if true then add on 10 points to the accuracy when attached
			sight    = false, --if true then add on 10 points to the accuracy when attached --this conflicts with scope - unless decided that you should be able to combine them (probably)
			scope    = false, --if true then add on 20 points to the accuracy when attached --this conflicts with sight - unless decided that you should be able to combine them (probably)
			--etc mods
			bayonet  = false, --if true then make it usable as a melee weapon
			
		},
		SW2500 = { --gun like the s&w 500
			--base stats
			damage   = 4,     --damage per shot hit
			accuracy = 25,    --chance of hitting the target out of 100
			firerate = 2,     --cooldown period in seconds
			ammo     = 0.50,  --need to make corrisponding ammo items
			--feed mods
			auto     = false, --if true then you can hold down the mouse to shoot it, otherwise you have to click
			chain    = false, --if true then subtract 0.7 from the fire rate when attached and make auto true
			--accuracy mods
			gripped  = false, --if true then add on 10 points to the accuracy when attached
			sight    = false, --if true then add on 10 points to the accuracy when attached --this conflicts with scope - unless decided that you should be able to combine them (probably)
			scope    = false, --if true then add on 20 points to the accuracy when attached --this conflicts with sight - unless decided that you should be able to combine them (probably)
			--etc mods
			bayonet  = false, --if true then make it usable as a melee weapon
			
		},
		humidor_gridiron = { --gun like the Colt "357" Magnum
			--base stats
			damage   = 3,     --damage per shot hit
			accuracy = 15,    --chance of hitting the target out of 100
			firerate = 2.5,   --cooldown period in seconds
			ammo     = 0.357, --need to make corrisponding ammo items
			--feed mods
			auto     = false, --if true then you can hold down the mouse to shoot it, otherwise you have to click
			chain    = false, --if true then subtract 0.7 from the fire rate when attached and make auto true
			--accuracy mods
			gripped  = false, --if true then add on 10 points to the accuracy when attached
			sight    = true,  --if true then add on 10 points to the accuracy when attached --this conflicts with scope - unless decided that you should be able to combine them (probably)
			scope    = false, --if true then add on 20 points to the accuracy when attached --this conflicts with sight - unless decided that you should be able to combine them (probably)
			--etc mods
			bayonet  = false, --if true then make it usable as a melee weapon
		},
		AP354precision = { --gun like the Browning HP 9 mm (Canada)
			--base stats
			damage   = 2.5,     --damage per shot hit
			accuracy = 40,    --chance of hitting the target out of 100
			firerate = 1,   --cooldown period in seconds
			ammo     = 0.354, --need to make corrisponding ammo items
			--feed mods
			auto     = false, --if true then you can hold down the mouse to shoot it, otherwise you have to click
			chain    = false, --if true then subtract 0.7 from the fire rate when attached and make auto true
			--accuracy mods
			gripped  = false, --if true then add on 10 points to the accuracy when attached
			sight    = true,  --if true then add on 10 points to the accuracy when attached --this conflicts with scope - unless decided that you should be able to combine them (probably)
			scope    = false, --if true then add on 20 points to the accuracy when attached --this conflicts with sight - unless decided that you should be able to combine them (probably)
			--etc mods
			bayonet  = false, --if true then make it usable as a melee weapon
		},
	},
	},
}
