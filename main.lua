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
function love.load()
   tile          = love.graphics.newImage("tile.png")
   player        = love.graphics.newImage("player.png")
   tilesize      = 64 -- for high quality 16 bit graphics
   mapsize       = {20,20}
   scale         = 1
   offset        = {0,0}
   playerpos     = {0,0}
   goaltile      = {0,0}
   movementfloat = {0,0}
   moving        = false
   speed         = 1
end

local function round(num, n)
  local mult = 10^(n or 0)
  return math.floor(num * mult + 0.5) / mult
end

--I draw the player as static, and the map and other entities move around them
function love.draw()
	local windowwidth  = love.graphics.getWidth()
	local windowheight = love.graphics.getHeight()
	local windowcenter = {windowwidth/2,windowheight/2}


	--draw map
	for x = 1,mapsize[1] do
		for y = 1,mapsize[2] do
			--here we center the map around the player
			
			--sub to center it
			xer = x - 1
			yer = y - 1
			local literalx = (((xer * tilesize ) + windowcenter[1]) - (playerpos[1] * tilesize)) + movementfloat[1]
			local literaly = (((yer * tilesize ) + windowcenter[2]) - (playerpos[2] * tilesize)) + movementfloat[2]
			love.graphics.draw(tile, literalx, literaly, 0, 1, 1, tilesize / 2, tilesize / 2)
		end
	end
	--draw player
	love.graphics.draw(player, (windowwidth/2), (windowheight/2), 0, 1, 1, tilesize / 2, tilesize / 2)

end


function love.update(dt,movement)
	--local up,down,left,right = false,false,false,false
	if moving then
		if goaltile[1] ~= 0 then
			if goaltile[1] - playerpos[1] > 0 then
				movementfloat[1] = movementfloat[1] - speed
			elseif goaltile[1] - playerpos[1] < 0 then
				movementfloat[1] = movementfloat[1] + speed
			end
		end
		if goaltile[2] ~= 0 then
			if goaltile[2] - playerpos[2] > 0 then
				movementfloat[2] = movementfloat[2] - speed
			elseif goaltile[2] - playerpos[2] < 0 then
				movementfloat[2] = movementfloat[2] + speed
			end
		end
		
		if math.abs(round(movementfloat[1], 1)) == tilesize or math.abs(round(movementfloat[2], 1)) == tilesize then
			--print("reset")
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
	if not moving then
		if shift then
			speed = 10
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
		return({goaltile,moving}) --this is cool that this automatically returns to the main value
	end
end
