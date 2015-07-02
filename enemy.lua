--[[
NOTES:
Possibly deactivate offscreen enemies?
]]--

--draw the enemies on the map
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
			local literalx = (((xer * tilesize ) + windowcenter[1]) - (playerpos[1] * tilesize)) + movementfloat[1] + enemy_table[i][4][1] --KEEP THIS AS PLAYERPOS SO IT FOLLOWS THE CONTINUITY AROUND THE PLAYER 
			local literaly = (((yer * tilesize ) + windowcenter[2]) - (playerpos[2] * tilesize)) + movementfloat[2] + enemy_table[i][4][2] --OR IN OTHER WORDS, DO IT SO THE ENEMY IS DRAWN AS PART OF THE MAP
			love.graphics.draw(enemy, literalx, literaly, 0, 1, 1, tilesize / 2, tilesize / 2)
		end
	end
end

--add enemies to global enemy table
function add_enemies()
	enemy_table = {}
	--I BET THIS CAN BE OPTIMIZED EVEN MOAR
	for i = 1,math.random(500,1000) do 
		--ai, pos, goaltile, movementfloat,moving
		enemy_table[i] = {"ai", {math.random(1,mapsize[1]-1),math.random(1,mapsize[2]-1)}, {0,0},{0,0},false}
		print(i)
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

--these are the main controls for the player to move around the map
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
		if enemy_table[i][5] then
			
			if enemy_table[i][3][1] ~= nil then
				if enemy_table[i][3][1] - enemy_table[i][2][1] > 0 then
					enemy_table[i][4][1] = enemy_table[i][4][1] + 1
				elseif enemy_table[i][3][1] - enemy_table[i][2][1] < 0 then
					enemy_table[i][4][1] = enemy_table[i][4][1] - 1
				end
			end
			if enemy_table[i][3][2] ~= nil then
				if enemy_table[i][3][2] - enemy_table[i][2][2] > 0 then
					enemy_table[i][4][2] = enemy_table[i][4][2] + 1
				elseif enemy_table[i][3][2] - enemy_table[i][2][2] < 0 then
					enemy_table[i][4][2] = enemy_table[i][4][2] - 1
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
