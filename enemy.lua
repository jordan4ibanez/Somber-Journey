--[[
NOTES:
Possibly deactivate offscreen enemies?
Draw the enemies on the map



--make the table use strings so it's more user friendly




]]--


--add enemies to global enemy table
function add_enemies()
	enemy_table = {}
	--I BET THIS CAN BE OPTIMIZED EVEN MOAR
	for i = 1,math.random(1,maxenemies) do 
		--ai, pos, goaltile, movementfloat, moving, speed, rotation, goal rotation
		
		--enemy_table[i] = {"ai", {math.random(1,mapsize[1]-1),math.random(1,mapsize[2]-1)}, {0,0},{0,0},false,0,0,0} -- the old style
		table.insert(enemy_table, {
							pos           = {math.random(1,mapsize[1]-1),math.random(1,mapsize[2]-1)},
							goaltile      = {0,0}, --THIS SHOULD BE NIL ----------------------------------------------------
							movementfloat = {0,0},
							moving        = false,
							speed         = 0,
							rotation      = 0,
							goalrotation  = 0,
							realpos       = {0,0}, -- the float pos on the map
						})
	end
end
--this is just a fun testing function
function add_enemies_to_table()
	for i = 1,math.random(1,5) do
		table.insert(enemy_table, {
							pos           = {math.random(1,mapsize[1]-1),math.random(1,mapsize[2]-1)},
							goaltile      = {0,0}, --THIS SHOULD BE NIL ----------------------------------------------------
							movementfloat = {0,0},
							moving        = false,
							speed         = 0,
							rotation      = 0,
							goalrotation  = 0,
							realpos       = {0,0}, -- the float pos on the map
						})
	end
end

--gives the enemies some kind of intelligence (not really)
function enemycollisiondetection(i)
	local xer = enemy_table[i]["goaltile"][1]
	local yer = enemy_table[i]["goaltile"][2] 
	if xer > 0 and xer <= mapsize[1] and yer > 0 and yer <= mapsize[2] then
		if tile_id_table[terrain[xer][yer]][3] == true then
			--stop everything
			enemy_table[i]["goaltile"] = {0,0}
			enemy_table[i]["movementfloat"] = {0,0}
			enemy_table[i]["moving"] = false
		end
	else
		--stop everything (map boundaries)
		enemy_table[i]["goaltile"] = {0,0}
		enemy_table[i]["movementfloat"] = {0,0}
		enemy_table[i]["moving"] = false
	end
end

--these is the logic for the enemies to move around the map
function enemy_movement()
	-- see if the enemy is awake before doing this
	
	
	--ai, pos, goaltile, movementfloat, moving, speed, rotation, goal rotation
	
	local x_render    = math.floor(windowcenter[1]/tilesize + 0.5)+2
	local y_render    = math.floor(windowcenter[2]/tilesize + 0.5)+2
	local xmin,xmax,ymin,ymax = 0,0,0,0
	xmin = literal_pos_x - x_render
	xmax = literal_pos_x + x_render
	ymin = literal_pos_y - y_render
	ymax = literal_pos_y + y_render
	for i = 1,tablelength(enemy_table) do
	
		-- Change enemy face dir
		enemyfacedir(i)
		
		--update the realpos of the enemy
		local xper = (((enemy_table[i]["pos"][1] * tilesize ) + windowcenter[1]) - ((playerpos[1]) * tilesize)) + movementfloat[1] + enemy_table[i]["movementfloat"][1] --KEEP THIS AS PLAYERPOS SO IT FOLLOWS THE CONTINUITY AROUND THE PLAYER 
		local yper = (((enemy_table[i]["pos"][2] * tilesize ) + windowcenter[2]) - ((playerpos[2]) * tilesize)) + movementfloat[2] + enemy_table[i]["movementfloat"][2] --OR IN OTHER WORDS, DO IT SO THE ENEMY IS DRAWN AS PART OF THE MAP
		enemy_table[i]["realpos"] = {xper,yper}
		
		if enemy_table[i]["moving"] then
		
			
			
			if enemy_table[i]["goaltile"][1] ~= nil then
				if enemy_table[i]["goaltile"][1] - enemy_table[i]["pos"][1] > 0 then
					enemy_table[i]["movementfloat"][1] = enemy_table[i]["movementfloat"][1] + enemy_table[i]["speed"]
				elseif enemy_table[i]["goaltile"][1] - enemy_table[i]["pos"][1] < 0 then
					enemy_table[i]["movementfloat"][1] = enemy_table[i]["movementfloat"][1] - enemy_table[i]["speed"]
				end
			end
			if enemy_table[i]["goaltile"][2] ~= nil then
				if enemy_table[i]["goaltile"][2] - enemy_table[i]["pos"][2] > 0 then
					enemy_table[i]["movementfloat"][2] = enemy_table[i]["movementfloat"][2] + enemy_table[i]["speed"]
				elseif enemy_table[i]["goaltile"][2] - enemy_table[i]["pos"][2] < 0 then
					enemy_table[i]["movementfloat"][2] = enemy_table[i]["movementfloat"][2] - enemy_table[i]["speed"]
				end
			end
			
			--ai, pos, goaltile, movementfloat, moving, speed, rotation, goal rotation
			
			--reset the variables so you can move at the end of the walk cycle
			if math.abs(round(enemy_table[i]["movementfloat"][1], 1)) == tilesize or math.abs(round(enemy_table[i]["movementfloat"][2], 1)) == tilesize then
				enemy_table[i]["pos"][1] = enemy_table[i]["goaltile"][1]
				enemy_table[i]["pos"][2] = enemy_table[i]["goaltile"][2]
				enemy_table[i]["goaltile"] = nil
				enemy_table[i]["movementfloat"] = {0,0}
				enemy_table[i]["moving"] = false
			end
			
		end
		
		local x,y = enemy_table[i]["pos"][1],enemy_table[i]["pos"][2]
		xer = x - 1
		yer = y - 1
		
		--do enemy ai if the enemy if it's onscreen
		if xer >= xmin and xer <= xmax and yer >= ymin and yer <= ymax then
			--random direction
			if not enemy_table[i]["moving"] then
				local direction = math.random(1,4)
				
				--do this so the smooth movement function works perfectly
				if not enemy_table[i]["goaltile"] then
					enemy_table[i]["goaltile"] = {}
				end
				--
				
				--give enemies random speed
				local speedtable = {1,2,4}
				enemy_table[i]["speed"] = 4--speedtable[math.random(1,3)]

				if direction == 1 then
					--offset[2] = offset[2] + 1
					enemy_table[i]["goaltile"][1] = enemy_table[i]["pos"][1]
					enemy_table[i]["goaltile"][2] = enemy_table[i]["pos"][2] - 1
					enemy_table[i]["moving"] = true
				end
				if direction == 2 then
					--offset[2] = offset[2] - 1
					enemy_table[i]["goaltile"][1] = enemy_table[i]["pos"][1]
					enemy_table[i]["goaltile"][2] = enemy_table[i]["pos"][2] + 1
					enemy_table[i]["moving"] = true
				end
				if direction == 3 then
					--offset[1] = offset[1] + 1
					enemy_table[i]["goaltile"][1] = enemy_table[i]["pos"][1] - 1
					enemy_table[i]["goaltile"][2] = enemy_table[i]["pos"][2]
					enemy_table[i]["moving"] = true
				end
				
				if direction == 4 then
					--offset[1] = offset[1] - 1
					enemy_table[i]["goaltile"][1] = enemy_table[i]["pos"][1] + 1
					enemy_table[i]["goaltile"][2] = enemy_table[i]["pos"][2]
					enemy_table[i]["moving"] = true
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
		if enemy_table[i]["goaltile"] then
			if enemy_table[i]["goalrotation"] == "nil" then
				if enemy_table[i]["goaltile"][1] ~= nil then
					if enemy_table[i]["goaltile"][1] - enemy_table[i]["pos"][1] > 0 then
						enemy_table[i]["goalrotation"] = dright
					elseif enemy_table[i]["goaltile"][1] - enemy_table[i]["pos"][1] < 0 then
						enemy_table[i]["goalrotation"] = dleft
					end
				end
				if enemy_table[i]["goaltile"][2] ~= nil then
					if enemy_table[i]["goaltile"][2] - enemy_table[i]["pos"][2] > 0 then
						enemy_table[i]["goalrotation"] = ddown
					elseif enemy_table[i]["goaltile"][2] - enemy_table[i]["pos"][2] < 0 then
						enemy_table[i]["goalrotation"] = dup
					end
				end
			end
		end
		
		local rottest = 0
		
		if enemy_table[i]["goalrotation"] then
			rottest = enemy_table[i]["rotation"]-enemy_table[i]["goalrotation"]
		end
		
		local rotationadd = 15--/(4/enemy_table[i][speed]) -- the speed at which the enemy turns
				
		--rotate the enemy
		if enemy_table[i]["goaltile"] then
			--print("rotate")
			if enemy_table[i]["goaltile"][1] ~= nil or enemy_table[i]["goaltile"][2] ~= nil then
				if enemy_table[i]["rotation"] ~= nil and enemy_table[i]["rotation"] ~= enemy_table[i]["goalrotation"] then
					if (rottest >= 0 and rottest <= 180) then
						--print(1)
						enemy_table[i]["rotation"] = enemy_table[i]["rotation"] - rotationadd
					elseif (rottest <= 0 and rottest >= -180) then
						--print(2)
						enemy_table[i]["rotation"] = enemy_table[i]["rotation"] + rotationadd
					elseif (rottest > 180 and rottest <= 360) then
						--print(3)
						enemy_table[i]["rotation"] = enemy_table[i]["rotation"] + rotationadd
					elseif (rottest < -180 and rottest >= -360) then
						--print(4)
						enemy_table[i]["rotation"] = enemy_table[i]["rotation"] - rotationadd
					end
				end

			end
		end
		enemy_table[i]["rotation"] = enemy_table[i]["rotation"] + 1
		--smooth 360 rotation 
		--[[
		if enemy_table[i]["rotation"] > 360 then
			enemy_table[i]["rotation"] = (enemy_table[i]["rotation"]-360)
		end
		if enemy_table[i]["rotation"] < 0 then
			enemy_table[i]["rotation"] = (enemy_table[i]["rotation"]+360)
		end
		
		--reset the goalrot
		if enemy_table[i]["goalrotation"] == enemy_table[i]["rotation"] then
			enemy_table[i]["goalrotation"] = nil--enemy_table[i]["rotation"]
		end
		]]--
end
