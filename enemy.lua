--[[
NOTES:
Possibly deactivate offscreen enemies?
Draw the enemies on the map
Show the speed at which the player moves
]]--


function draw_enemies()	
	--let's see if we render the object
	local x_render    = math.floor(windowcenter[1]/tilesize + 0.5)+2 --figure out why you have to add + 2 later
	local y_render    = math.floor(windowcenter[2]/tilesize + 0.5)+2
	local xmin,xmax,ymin,ymax = 0,0,0,0
	xmin = literal_pos_x - x_render
	xmax = literal_pos_x + x_render
	ymin = literal_pos_y - y_render
	ymax = literal_pos_y + y_render
	
	for i = 1,tablelength(enemy_table) do
		local x,y = enemy_table[i][2][1],enemy_table[i][2][2]
		xer = x - 1
		yer = y - 1
		--draw the enemy if it's onscreen
		if xer >= xmin and xer <= xmax and yer >= ymin and yer <= ymax then
			--local literalx = (((xer * tilesize ) + windowcenter[1]) - (playerpos[1] * tilesize)) + movementfloat[1] + enemy_table[i][4][1] --KEEP THIS AS PLAYERPOS SO IT FOLLOWS THE CONTINUITY AROUND THE PLAYER 
			--local literaly = (((yer * tilesize ) + windowcenter[2]) - (playerpos[2] * tilesize)) + movementfloat[2] + enemy_table[i][4][2] --OR IN OTHER WORDS, DO IT SO THE ENEMY IS DRAWN AS PART OF THE MAP
			
			love.graphics.draw(enemy, enemyrealpos(i)[1], enemyrealpos(i)[2], math.rad(enemy_table[i][7]), 1, 1, tilesize / 2, tilesize / 2)
			--debug visual
			if enemy_table[i][6] == walkspeed then
				love.graphics.print('WALKING', enemyrealpos(i)[1]-(tilesize/2), enemyrealpos(i)[2]+20)
			elseif enemy_table[i][6] == runspeed then
				love.graphics.print('RUNNING', enemyrealpos(i)[1]-(tilesize/2), enemyrealpos(i)[2]+20)
			elseif enemy_table[i][6] == sneakspeed then
				love.graphics.print('SNEAKING', enemyrealpos(i)[1]-(tilesize/2), enemyrealpos(i)[2]+20)
			end
		end
	end
end

--add enemies to global enemy table
function add_enemies()
	enemy_table = {}
	--I BET THIS CAN BE OPTIMIZED EVEN MOAR
	for i = 1,math.random(1,maxenemies) do 
		--ai, pos, goaltile, movementfloat,moving,speed,rotation,goal rotation
		enemy_table[i] = {"ai", {math.random(1,mapsize[1]-1),math.random(1,mapsize[2]-1)}, {0,0},{0,0},false,0,0,0}
	end
end
--this is just a fun testing function
function add_enemies_to_table()
	for i = 1,math.random(1,5) do
		table.insert(enemy_table, {"ai", {math.random(1,mapsize[1]-1),math.random(1,mapsize[2]-1)}, {0,0},{0,0},false,0,0,0,0})
	end
end

--gives the enemies some kind of intelligence (not really)
function enemycollisiondetection(i)
	local xer = enemy_table[i][3][1]
	local yer = enemy_table[i][3][2] 
	if xer > 0 and xer <= mapsize[1] and yer > 0 and yer <= mapsize[2] then
		if tile_id_table[terrain[xer][yer]][3] == true then
			--stop everything
			enemy_table[i][3] = {0,0}
			enemy_table[i][4] = {0,0}
			enemy_table[i][5] = false
		end
	else
		--stop everything (map boundaries)
		enemy_table[i][3] = {0,0}
		enemy_table[i][4] = {0,0}
		enemy_table[i][5] = false
	end
end

--these is the logic for the enemies to move around the map
function enemy_movement()
	--let's see if the enemy is awake
	local x_render    = math.floor(windowcenter[1]/tilesize + 0.5)+2
	local y_render    = math.floor(windowcenter[2]/tilesize + 0.5)+2
	local xmin,xmax,ymin,ymax = 0,0,0,0
	xmin = literal_pos_x - x_render
	xmax = literal_pos_x + x_render
	ymin = literal_pos_y - y_render
	ymax = literal_pos_y + y_render
	for i = 1,tablelength(enemy_table) do
	
		-- a test
		enemyfacedir(i)
		
		if enemy_table[i][5] then
			
			if enemy_table[i][3][1] ~= nil then
				if enemy_table[i][3][1] - enemy_table[i][2][1] > 0 then
					enemy_table[i][4][1] = enemy_table[i][4][1] + enemy_table[i][6]
				elseif enemy_table[i][3][1] - enemy_table[i][2][1] < 0 then
					enemy_table[i][4][1] = enemy_table[i][4][1] - enemy_table[i][6]
				end
			end
			if enemy_table[i][3][2] ~= nil then
				if enemy_table[i][3][2] - enemy_table[i][2][2] > 0 then
					enemy_table[i][4][2] = enemy_table[i][4][2] + enemy_table[i][6]
				elseif enemy_table[i][3][2] - enemy_table[i][2][2] < 0 then
					enemy_table[i][4][2] = enemy_table[i][4][2] - enemy_table[i][6]
				end
			end
			--reset the variables so you can move at the end of the walk cycle
			if math.abs(round(enemy_table[i][4][1], 1)) == tilesize or math.abs(round(enemy_table[i][4][2], 1)) == tilesize then
				enemy_table[i][2][1] = enemy_table[i][3][1]
				enemy_table[i][2][2] = enemy_table[i][3][2]
				enemy_table[i][3] = {0,0}
				enemy_table[i][4] = {0,0}
				enemy_table[i][5] = false
			end
			
		end
		
		local x,y = enemy_table[i][2][1],enemy_table[i][2][2]
		xer = x - 1
		yer = y - 1
		--do enemy ai if the enemy if it's onscreen
		if xer >= xmin and xer <= xmax and yer >= ymin and yer <= ymax then	
			--random direction
			local direction = math.random(1,4)			
			
			if not enemy_table[i][5] then

				--do this so the smooth movement function works perfectly
				if not enemy_table[i][3] then
					enemy_table[i][3] = {}
				end
				--
				
				--give enemies random speed
				local speedtable = {1,2,4}
				enemy_table[i][6] = 1--speedtable[math.random(1,3)]

				if direction == 1 then
					--offset[2] = offset[2] + 1
					enemy_table[i][3][1] = enemy_table[i][2][1]
					enemy_table[i][3][2] =  enemy_table[i][2][2] - 1
					enemy_table[i][5] = true
				end
				if direction == 2 then
					--offset[2] = offset[2] - 1
					enemy_table[i][3][1] = enemy_table[i][2][1]
					enemy_table[i][3][2] =  enemy_table[i][2][2] + 1
					enemy_table[i][5] = true
				end
				if direction == 3 then
					--offset[1] = offset[1] + 1
					enemy_table[i][3][1] =  enemy_table[i][2][1] - 1
					enemy_table[i][3][2] = enemy_table[i][2][2]
					enemy_table[i][5] = true
				end
				
				if direction == 4 then
					--offset[1] = offset[1] - 1
					enemy_table[i][3][1] =  enemy_table[i][2][1] + 1
					enemy_table[i][3][2] = enemy_table[i][2][2]
					enemy_table[i][5] = true
				end
				--collision detection
				enemycollisiondetection(i)
			end
		end
	end
end
--this controls the enemies' face direction
function enemyfacedir(i)
		--get the new rotation - this does a lot of unnecesary calcs so fix this
		if enemy_table[i][3] then
			if enemy_table[i][8] == "nil" then
				if enemy_table[i][3][1] ~= nil then
					if enemy_table[i][3][1] - enemy_table[i][2][1] > 0 then
						enemy_table[i][8] = dright
					elseif enemy_table[i][3][1] - enemy_table[i][2][1] < 0 then
						enemy_table[i][8] = dleft
					end
				end
				if enemy_table[i][3][2] ~= nil then
					if enemy_table[i][3][2] - enemy_table[i][2][2] > 0 then
						enemy_table[i][8] = ddown
					elseif enemy_table[i][3][2] - enemy_table[i][2][2] < 0 then
						enemy_table[i][8] = dup
					end
				end
			end
		end
		
		local rottest = 0
		
		if enemy_table[i][8] then
			rottest = enemy_table[i][7]-enemy_table[i][8]
		end
		
		local rotationadd = 15/(4/enemy_table[i][6]) -- the speed at which the enemy turns
				
		--rotate the enemy
		if goaltile then
			if enemy_table[i][3][1] ~= nil or enemy_table[i][3][2] ~= nil then
				if enemy_table[i][7] ~= nil and enemy_table[i][7] ~= enemy_table[i][8] then
					if (rottest >= 0 and rottest <= 180) then
						--print(1)
						enemy_table[i][7] = enemy_table[i][7] - rotationadd
					elseif (rottest <= 0 and rottest >= -180) then
						--print(2)
						enemy_table[i][7] = enemy_table[i][7] + rotationadd
					elseif (rottest > 180 and rottest <= 360) then
						--print(3)
						enemy_table[i][7] = enemy_table[i][7] + rotationadd
					elseif (rottest < -180 and rottest >= -360) then
						--print(4)
						enemy_table[i][7] = enemy_table[i][7] - rotationadd
					end
				end

			end
		end

		--smooth 360 rotation 
		if enemy_table[i][7] > 360 then
			enemy_table[i][7] = (enemy_table[i][7]-360)
		end
		if enemy_table[i][7] < 0 then
			enemy_table[i][7] = (enemy_table[i][7]+360)
		end
		
		--reset the goalrot
		if enemy_table[i][8] == enemy_table[i][7] then
			enemy_table[i][8] = "nil"
		end
end
