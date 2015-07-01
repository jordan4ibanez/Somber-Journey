function collisiondetection()
	if up or down or left or right then
		local xer = goaltile[1] + 1
		local yer = goaltile[2] + 1
		if xer > 0 and xer <= mapsize[1] and yer > 0 and yer <= mapsize[2] then
			if tile_id_table[terrain[xer][yer]][3] == true then
				--stop everything
				goaltile = {0,0}
				movementfloat = {0,0}
				moving = false
			end
		else
			--stop everything (map boundaries)
			goaltile = {0,0}
			movementfloat = {0,0}
			moving = false
		end
	end
end

--these are the main controls for the player to move around the map
function playercontrols()
	if moving then
		if speed == walkspeed then
			footstep:play()
		elseif speed == runspeed then
			fastfootstep:play()
		elseif speed == sneakspeed then
			--don't play a sound
		end
		
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
		collisiondetection()
	end
end

function collisiondetection()
	if up or down or left or right then
		local xer = goaltile[1] + 1
		local yer = goaltile[2] + 1
		if xer > 0 and xer <= mapsize[1] and yer > 0 and yer <= mapsize[2] then
			if tile_id_table[terrain[xer][yer]][3] == true then
				--stop everything
				goaltile = {0,0}
				movementfloat = {0,0}
				moving = false
			end
		else
			--stop everything (map boundaries)
			goaltile = {0,0}
			movementfloat = {0,0}
			moving = false
		end
	end
end
