--[[
IMPORTANT NOTES!

the movement needs to be based upon it's own value, not tile size, but multiplied by the tile size so that maps are scalable, this will require ->
a total rewrite of player and enemy movement, but will greatly benefit the game in the future

]]--

--these are the main controls for the player to move around the map
function playercontrols()
	playerfacedir()
	
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
			goaltile = nil
			movementfloat = {0,0}
			moving = false
			
			--collect the item under you too
			collect_item()
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

--this checks if there's a tile that's not walkable in the direction the player's moving
function collisiondetection()
	if up or down or left or right then
		local xer = goaltile[1]
		local yer = goaltile[2]
		if xer > 0 and xer <= mapsize[1] and yer > 0 and yer <= mapsize[2] then
			if tile_id_table[terrain[xer][yer]][3] == true then
				--stop everything
				goaltile = nil
				movementfloat = {0,0}
				moving = false
			end
		else
			--stop everything (map boundaries)
			goaltile = nil
			movementfloat = {0,0}
			moving = false
		end
	end
end

--this controls the player's face direction
function playerfacedir()
		--get the new rotation - this does a lot of unnecesary calcs so fix this
		if goaltile then
			if goalrot == nil then
				if goaltile[1] ~= nil then
					if goaltile[1] - playerpos[1] > 0 then
						goalrot = dright
					elseif goaltile[1] - playerpos[1] < 0 then
						goalrot = dleft
					end
				end
				if goaltile[2] ~= nil then
					if goaltile[2] - playerpos[2] > 0 then
						goalrot = ddown
					elseif goaltile[2] - playerpos[2] < 0 then
						goalrot = dup
					end
				end
			end
		end
		
		local rottest = 0
		
		if goalrot then
			rottest = rot-goalrot
		end
		
		local rotationadd = 15/(4/speed) -- the speed at which the player turns - max speed divided by max speed because that works well for now
				
		--rotate the player
		if goaltile then
			if goaltile[1] ~= nil or goaltile[2] ~= nil then
				if rot ~= nil and rot ~= goalrot then
					if (rottest >= 0 and rottest <= 180) then
						--print(1)
						rot = rot - rotationadd
					elseif (rottest <= 0 and rottest >= -180) then
						--print(2)
						rot = rot + rotationadd
					elseif (rottest > 180 and rottest <= 360) then
						--print(3)
						rot = rot + rotationadd
					elseif (rottest < -180 and rottest >= -360) then
						--print(4)
						rot = rot - rotationadd
					end
				end

			end
		end

		--smooth 360 rotation 
		if rot > 360 then
			rot = (rot-360)
		end
		if rot < 0 then
			rot = (rot+360)
		end
		
		--reset the goalrot
		if goalrot == rot then
			goalrot = nil
		end
end

--keypress functions
function love.keypressed( key )
	if key == "escape" then
		local salutations = {
			"See ya later!",
			"Thanks for playing!",
			"Try Minetest too!",
			"Sfan5 approved!\n\n\n\n\n\nClaims cannot be proven...", -- use this for the title card instead
			"Try DOOM too!",
			"Have fun in the real world!",
			"Adu!",
			"See you next time!",
			"No wait come back!",
			"You've got quite a nice terminal!",
			"Don't leave for too long! :(",
			}
			
		print(salutations[math.random(1,tablelength(salutations))])
		love.event.quit()
	end
	--if key == " " then
		
	--end
end
