



--CURRENTLY IN A FEATURE FREEZE!!!!!! THERE ARE A LOT OF BUGS THAT I'M FIXING SO IF YOU LOOK AT THIS SOMETHING MIGHT BE BROKEN UNTIL THIS WARNING IS REMOVED!!!!








--[[
PROJECT GOALS:
A tile based, pre, during, and post apocalyptic game.

Genre, rpg, combat, rts, etc... (define core game elements as I'm going)

Make the game beautiful, but at the same time sad and huge.

Real time combat combined with possible rpg style turn based combat in special scenarios

Possible sandbox gameplay combined with a story, so when the story is done you can still have fun

An underlying message that will be revealed in the end

particles for running, walking, and sneaking

weapons

maybe some kind of vehicles

War is a defeat for humanity.

Pope John Paul II

you can't move back to the previous tile until you've finished moving to the other one, that's part of the difficulty

add a minimap

Rewrite most of this code to allow the scaling of the map

]]--

dofile("movement.lua")
dofile("helpers.lua")
dofile("terrain.lua")
dofile("enemy.lua")
dofile("gui.lua")
dofile("weapons.lua")
dofile("graphics.lua")



--have the image be a string, then just replace the string with the data from love.graphics.newImage afterwards

function love.load()
	math.randomseed( os.time() )
	footstep      = love.audio.newSource("footstep.wav", "static")
	fastfootstep  = love.audio.newSource("fastfootstep.wav", "static")
	dig           = love.audio.newSource("dig.wav", "static")
	
	--note here: When drawing stuff, do tilesize/64 to get the scale
	tilesize      = 64 -- for high quality 16 bit graphics 
	
	player        = love.graphics.newImage("player.png")
	enemy         = love.graphics.newImage("enemy.png")
	
	mapsize       = {15,15} --Truely huge maps (break this up into chunks (8000x8000 for now))
	maxenemies    = 1
	scale         = 1
	offset        = {0,0}
	playerpos     = {math.random(1,mapsize[1]-1),math.random(1,mapsize[2]-1)}
	goaltile      = nil
	movementfloat = {0,0}
	
	moving        = false
	
	sneakspeed    = 1
	walkspeed     = 2
	runspeed      = 4
	
	speed         = walkspeed
	windowwidth   = love.graphics.getWidth()
	windowheight  = love.graphics.getHeight()
	windowcenter  = {windowwidth/2,windowheight/2}
	
	selection     = false
	
	--directional vars
	rot = 0
	
	dleft  = 270
	dright = 90
	dup    = 0
	ddown  = 180
	
	terrain_gen()
	add_enemies()
end




--I draw the player as static, and the map and other entities move around them
function love.draw()

	--player actual pos
	literalpos()
	
	draw_map()
	
	drawplayer()
	
	--draw enemies
	draw_enemies()
	
	--draw the selected tile
	drawselection()
	
	--show the speed
	showspeed()
	
end

function love.update(dt,movement)
	literal_pos_x = math.floor(((playerpos[1] * tilesize) - movementfloat[1])/tilesize + 0.5) -- do this position for on the fly render adjust 
	literal_pos_y = math.floor(((playerpos[2] * tilesize) - movementfloat[2])/tilesize + 0.5) -- do this position for on the fly render adjust 
	playercontrols()
	
	enemy_movement()
	
	tileselection()
end
