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


]]--

local function terrain_gen()
	terrain = {}
	math.randomseed( os.time() )
	
	for  x = 1,mapsize[1] do
		terrain[x] = {}
		for  y = 1,mapsize[2] do
			terrain[x][y] = math.random(1,2)
		end
	end
end
local function round(num, n)
  local mult = 10^(n or 0)
  return math.floor(num * mult + 0.5) / mult
end

tile_id_table = {
--{"name","texture","wall","hurtplayer"} --table example
{"dirt"  ,love.graphics.newImage("dirt.png")   ,false ,false}, --dirt
{"wall"  ,love.graphics.newImage("wall.png")   ,true ,false}, --wall
}
--have the image be a string, then just replace the string with the data from love.graphics.newImage afterwards

function love.load()
	math.randomseed( os.time() )
	
	tile          = love.graphics.newImage("tile.png")
	--wall          = love.graphics.newImage("wall.png")
	--dirt          = 
	player        = love.graphics.newImage("player.png")
	tilesize      = 64 -- for high quality 16 bit graphics
	mapsize       = {20,20}
	scale         = 1
	offset        = {0,0}
	playerpos     = {math.random(1,mapsize[1]),math.random(1,mapsize[2])}
	goaltile      = nil
	movementfloat = {0,0}
	moving        = false
	sneakspeed    = 0.5
	walkspeed     = 1
	runspeed      = 2
	speed         = walkspeed
   
	terrain_gen()
end





--I draw the player as static, and the map and other entities move around them
function love.draw()
	local windowwidth  = love.graphics.getWidth()
	local windowheight = love.graphics.getHeight()
	local windowcenter = {windowwidth/2,windowheight/2}


	--draw map
	for x = 1,mapsize[1] do
		for y = 1,mapsize[2] do
			--let's get the texture id from the id table
			local texture = tile_id_table[terrain[x][y]][2]

			--here we center the map around the player
			--sub to center it
			xer = x - 1
			yer = y - 1
			
			local literalx = (((xer * tilesize ) + windowcenter[1]) - (playerpos[1] * tilesize)) + movementfloat[1]
			local literaly = (((yer * tilesize ) + windowcenter[2]) - (playerpos[2] * tilesize)) + movementfloat[2]
			love.graphics.draw(texture, literalx, literaly, 0, 1, 1, tilesize / 2, tilesize / 2)
		end
	end
	--draw player
	love.graphics.draw(player, (windowwidth/2), (windowheight/2), 0, 1, 1, tilesize / 2, tilesize / 2)
	
	--recording visual
	
	if speed == walkspeed then
		love.graphics.print('WALKING', 10, 10)
	elseif speed == runspeed then
		love.graphics.print('RUNNING', 10, 10)
	elseif speed == sneakspeed then
		love.graphics.print('SNEAKING', 10, 10)
	end

end

function love.update(dt,movement)
	--local up,down,left,right = false,false,false,false
	if moving then

		if goaltile[1] ~= nil then
			if goaltile[1] - playerpos[1] > 0 then
				movementfloat[1] = movementfloat[1] - speed
			elseif goaltile[1] - playerpos[1] < 0 then
				movementfloat[1] = movementfloat[1] + speed
			end
		end
		if goaltile[2] ~= nil then
			if goaltile[2] - playerpos[2] > 0 then
				movementfloat[2] = movementfloat[2] - speed
			elseif goaltile[2] - playerpos[2] < 0 then
				movementfloat[2] = movementfloat[2] + speed
			end
		end
		--reset the variables so you can move at the end of the walk cycle
		if math.abs(round(movementfloat[1], 1)) == tilesize or math.abs(round(movementfloat[2], 1)) == tilesize then
			playerpos = goaltile
			goaltile = {0,0}
			movementfloat = {0,0}
			moving = false
		end
	end
	--key input - only allow if not moving
	up    = love.keyboard.isDown( "w" )
	down  = love.keyboard.isDown( "s" )
	left  = love.keyboard.isDown( "a" )
	right = love.keyboard.isDown( "d" )
	shift = love.keyboard.isDown( "lshift" )
	ctrl  = love.keyboard.isDown( "lctrl" )
	if not moving then
		--do this so the smooth movement function works perfectly
		if not goaltile then
			goaltile = {}
		end
		--
		if shift then
			speed = sneakspeed
		elseif ctrl then
			speed = runspeed
		else
			speed = walkspeed
		end
		if up then
			--offset[2] = offset[2] + 1
			goaltile[1] = playerpos[1]
			goaltile[2] =  playerpos[2] - 1
			moving = true
		end
		if down then
			--offset[2] = offset[2] - 1
			goaltile[1] = playerpos[1]
			goaltile[2] =  playerpos[2] + 1
			moving = true
		end
		if left then
			--offset[1] = offset[1] + 1
			goaltile[1] =  playerpos[1] - 1
			goaltile[2] = playerpos[2]
			moving = true
		end
		
		if right then
			--offset[1] = offset[1] - 1
			goaltile[1] =  playerpos[1] + 1
			goaltile[2] = playerpos[2]
			moving = true
		end
		--collision detection
		if up or down or left or right then
			local xer = goaltile[1] + 1
			local yer = goaltile[2] + 1
			if xer > 0 and xer <= mapsize[1] and yer > 0 and yer <= mapsize[2] then
				if tile_id_table[terrain[xer][yer]][3] == true then
					--stop everything
					print("running into a wall")
					goaltile = {0,0}
					movementfloat = {0,0}
					moving = false
				end
			else
				--stop everything (map boundaries)
				print("hitting boundaries")
				goaltile = {0,0}
				movementfloat = {0,0}
				moving = false
			end
		end
		--if tile_id_table[terrain[goaltile[1]][goaltile[2]]][3] == true then

		--end
		--return({goaltile,moving}) --this is cool that this automatically returns to the main value
	end
end
