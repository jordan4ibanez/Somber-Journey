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

dig https://www.freesound.org/people/Dymewiz/sounds/111119/


make the player top down view like [o] with the rotation turning towards the direction they're going


]]--

dofile("movement.lua")
dofile("helpers.lua")
dofile("terrain.lua")
dofile("enemy.lua")
dofile("gui.lua")



--have the image be a string, then just replace the string with the data from love.graphics.newImage afterwards

function love.load()
	math.randomseed( os.time() )
	footstep      = love.audio.newSource("footstep.wav", "static")
	fastfootstep  = love.audio.newSource("fastfootstep.wav", "static")
	dig           = love.audio.newSource("dig.wav", "static")
	player        = love.graphics.newImage("player.png")
	enemy         = love.graphics.newImage("enemy.png")
	tilesize      = 64 -- for high quality 16 bit graphics
	mapsize       = {20,20} --Truely huge maps (break this up into chunks (8000x8000 for now))
	maxenemies    = 50
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
	literal_pos_x = math.floor(((playerpos[1] * tilesize) - movementfloat[1])/tilesize + 0.5) -- do this position for on the fly render adjust 
	literal_pos_y = math.floor(((playerpos[2] * tilesize) - movementfloat[2])/tilesize + 0.5) -- do this position for on the fly render adjust 
	
	draw_map()
	--draw player
	love.graphics.draw(player, (windowwidth/2), (windowheight/2), math.rad(rot), 1, 1, tilesize / 2, tilesize / 2)
	
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
