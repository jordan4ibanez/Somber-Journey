--draw the terrain
function draw_map()
	--draw map
	
	--save gpu by only rendering things on screen
	local x_render    = math.floor(windowcenter[1]/tilesize + 0.5) + 1 --add one to make the radius one tile bigger than the screen width
	local y_render    = math.floor(windowcenter[2]/tilesize + 0.5) + 1
	local xmin,xmax,ymin,ymax = 0,0,0,0
	
	xmin = literal_pos_x - x_render
	if xmin < 1 then
		xmin = 1 
	end
	xmax = literal_pos_x + x_render
	if xmax > mapsize[1] then
		xmax = mapsize[1]
	end
	
	ymin = literal_pos_y - y_render
	if ymin < 1 then
		ymin = 1
	end
	ymax = literal_pos_y + y_render
	if ymax > mapsize[2] then
		ymax = mapsize[2]
	end
		
	for x = xmin,xmax do
		for y = ymin,ymax do
			--let's get the texture id from the id table
			local texture = tile_id_table[terrain[x][y]][2]

			--here we center the map around the player
			
			local literalx = (((x * tilesize ) + windowcenter[1]) - ((playerpos[1]) * tilesize)) + movementfloat[1]
			local literaly = (((y * tilesize ) + windowcenter[2]) - ((playerpos[2]) * tilesize)) + movementfloat[2]
			love.graphics.draw(texture, literalx, literaly, 0, 1, 1, tilesize / 2, tilesize / 2)
		end
	end
end

--ai, pos, goaltile, movementfloat, moving, speed, rotation, goal rotation

function draw_enemies()	
	--let's see if we render the object
	local x_render    = math.floor(windowcenter[1]/tilesize + 0.5)+2 --+2 because that makes the radius of the rendered enemies bigger,
	local y_render    = math.floor(windowcenter[2]/tilesize + 0.5)+2 --+2 makes it one tile off screen so it appears that they're moving around all over the map, even though offscreen enemies are "sleeping"
	local xmin,xmax,ymin,ymax = 0,0,0,0
	xmin = literal_pos_x - x_render
	xmax = literal_pos_x + x_render
	ymin = literal_pos_y - y_render
	ymax = literal_pos_y + y_render
	
	for i = 1,tablelength(enemy_table) do
		local x,y = enemy_table[i][2][1],enemy_table[i][2][2]
		--draw the enemy if it's onscreen
		if x >= xmin and x <= xmax and y >= ymin and y <= ymax then
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

function drawplayer()
	love.graphics.draw(player, (windowwidth/2), (windowheight/2), math.rad(rot), tilesize/64, tilesize/64, tilesize / 2, tilesize / 2)
end

--draw the visual of the selected tile
function drawselection()
	if selection == true then
		love.graphics.rectangle("line", selectionx, selectiony, tilesize , tilesize )
	end
end

--show the speed at which the player moves
function showspeed()
	--debug visual
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0, 0, 90 , 60 )
	love.graphics.setColor(255,255,255) -- reset colours
	if moving == true then
		if speed == walkspeed then
			love.graphics.print('WALKING', 10, 10)
		elseif speed == runspeed then
			love.graphics.print('RUNNING', 10, 10)
		elseif speed == sneakspeed then
			love.graphics.print('SNEAKING', 10, 10)
		end
	else
		love.graphics.print('STANDING', 10, 10)
	end
	local posprint = "x:"..tostring(playerpos[1]-(movementfloat[1]/64)).."\ny:"..tostring(playerpos[2]-(movementfloat[2]/64))
	love.graphics.print(posprint, 10, 25)
end
