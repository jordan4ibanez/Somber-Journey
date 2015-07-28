--[[
IMPORTANT NOTES:
everything needs to be set by the scale size
]]--

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
			local texture = tile_images[tile_id_table[terrain[x][y]][1]] -- get the tile image based on the tile id name
			--print(tile_id_table[terrain[x][y]][1])
			--here we center the map around the player
			
			local literalx = (((x * tilesize ) + windowcenter[1]) - ((playerpos[1]) * tilesize)) + movementfloat[1]
			local literaly = (((y * tilesize ) + windowcenter[2]) - ((playerpos[2]) * tilesize)) + movementfloat[2]
			love.graphics.draw(texture, literalx, literaly, 0, tilesize/64, tilesize/64, 32, 32)
		end
	end
end

--draw the enemies on screen
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
		local x,y = enemy_table[i]["pos"][1],enemy_table[i]["pos"][2]
		--draw the enemy if it's onscreen
		if x >= xmin and x <= xmax and y >= ymin and y <= ymax then
			love.graphics.draw(enemy, enemy_table[i]["realpos"][1], enemy_table[i]["realpos"][2], math.rad(enemy_table[i]["rotation"]), tilesize/64, tilesize/64, 32, 32)
			--debug visual
			if enemy_table[i]["steps"] == walkspeed then
				love.graphics.print('WALKING', enemy_table[i]["realpos"][1]-(tilesize/2), enemy_table[i]["realpos"][2]+20)
			elseif enemy_table[i]["steps"] == runspeed then
				love.graphics.print('RUNNING', enemy_table[i]["realpos"][1]-(tilesize/2), enemy_table[i]["realpos"][2]+20)
			elseif enemy_table[i]["steps"] == sneakspeed then
				love.graphics.print('SNEAKING', enemy_table[i]["realpos"][1]-(tilesize/2), enemy_table[i]["realpos"][2]+20)
			end
		end
	end
end

--draw the items on screen
function draw_items()	
	--let's see if we render the object
	local x_render    = math.floor(windowcenter[1]/tilesize + 0.5)+2 --+2 because that makes the radius of the rendered enemies bigger,
	local y_render    = math.floor(windowcenter[2]/tilesize + 0.5)+2 --+2 makes it one tile off screen so it appears that they're moving around all over the map, even though offscreen enemies are "sleeping"
	local xmin,xmax,ymin,ymax = 0,0,0,0
	xmin = literal_pos_x - x_render
	xmax = literal_pos_x + x_render
	ymin = literal_pos_y - y_render
	ymax = literal_pos_y + y_render
	for i = 1,tablelength(item_table) do
		local x,y = item_table[i]["pos"][1],item_table[i]["pos"][2]
		--update the realpos of the enemy
		local xper = (((item_table[i]["pos"][1] * tilesize ) + windowcenter[1]) - ((playerpos[1]) * tilesize)) + movementfloat[1] --KEEP THIS AS PLAYERPOS SO IT FOLLOWS THE CONTINUITY AROUND THE PLAYER 
		local yper = (((item_table[i]["pos"][2] * tilesize ) + windowcenter[2]) - ((playerpos[2]) * tilesize)) + movementfloat[2] --OR IN OTHER WORDS, DO IT SO THE ENEMY IS DRAWN AS PART OF THE MAP
		item_table[i]["realpos"] = {xper,yper}
		--draw the enemy if it's onscreen
		--print_r(item_images)
		if x >= xmin and x <= xmax and y >= ymin and y <= ymax then
			love.graphics.draw(item_images[item_table[i]["item"]["key"]], item_table[i]["realpos"][1], item_table[i]["realpos"][2], 0, tilesize/64, tilesize/64, 32, 32)
		end
	end
end


--draw the player			
function drawplayer()
	--tilesize/64 because that's the origin size of the image
	--32 because that's the center of the image
	love.graphics.draw(player, (windowwidth/2), (windowheight/2), math.rad(rot), tilesize/64, tilesize/64, 32, 32)
end

--camera positioning and such
function camerastuff()

end

--draw the visual of the selected tile
function drawselection()
	if selection == true and guihover == false then
		love.graphics.rectangle("line", selectionx, selectiony, tilesize , tilesize )
	end
end

--show the speed at which the player moves
function showspeed()
	--debug visual
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0, 0, 130 , 90 )
	love.graphics.setColor(255,255,255) -- reset colours
	if moving == true then
		if steps == walkspeed then
			love.graphics.print('WALKING', 10, 10)
		elseif steps == runspeed then
			love.graphics.print('RUNNING', 10, 10)
		elseif steps == sneakspeed then
			love.graphics.print('SNEAKING', 10, 10)
		end
	else
		love.graphics.print('STANDING', 10, 10)
	end
	local posprint = "x:"..tostring(playerpos[1]-(movementfloat[1]/64)).."\ny:"..tostring(playerpos[2]-(movementfloat[2]/64))
	love.graphics.print(posprint, 10, 25)
	love.graphics.print("Mapsize: "..mapsize[1].."x"..mapsize[2], 10, 55)
	love.graphics.print("Enemies: "..enemycounter, 10, 70)
end

--draw the inventory
function drawinventory()
	local guimax,guimin = 128,30
	local mousex,mousey = love.mouse.getPosition( )
	if tablelength(inventory) > 0 then
		local i = 0
		for _,item in pairs(inventory) do
			i = i + 1
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("fill", (guiscale*(i-1)), (windowheight-(guiscale)), guiscale , guiscale )
			love.graphics.setColor(255,255,255) -- reset colours
			love.graphics.draw(item_images[item["key"]], (guiscale*(i-1))+(guiscale/2), (windowheight-(guiscale/2)), 0, guiscale/64, guiscale/64, 32, 32)
			love.graphics.setColor(0,0,0)
			love.graphics.print(tostring(item["value"]), (guiscale*(i-1))+(guiscale/2), (windowheight-(guiscale)))
			love.graphics.setColor(255,255,255) -- reset colours
			love.graphics.print(tostring(item["value"]), (guiscale*(i-1))+(guiscale/2)-2, (windowheight-(guiscale/2)-2))
			if invselection == i then
				love.graphics.setColor(255,255,255)
				love.graphics.rectangle("line", (guiscale*(i-1)), (windowheight-(guiscale)), guiscale , guiscale )
			end
		end
		--make the gui scale up and down based on if the mouse is hovered over it
		if (mousex >= 0 and mousex <= (guiscale*(i))) and (mousey <= windowheight and mousey >= (windowheight-guiscale)) then
				--draw the selection of the inventory
				love.graphics.setColor(255,255,255)
				love.graphics.rectangle("line", (guiscale*(math.floor(mousex/guiscale + 1)-1)), (windowheight-(guiscale)), guiscale , guiscale )
				invselection = math.floor(mousex/guiscale + 1)
				
				guihover = true
				if guiscale < guimax then
					guiscale = guiscale + 3
				end
				if guiscale > guimax then
					guiscale = guimax
				end
		else
			guihover = false
			if guiscale ~= guimin then
				if guiscale > guimin then
					guiscale = guiscale - 3
				end
				if guiscale < guimin then
					guiscale = guimin
				end
			end
		end
	end
end

--windowcenter
function getwindowcenter()
	windowwidth   = love.graphics.getWidth()
	windowheight  = love.graphics.getHeight()
	windowcenter  = {windowwidth/2,windowheight/2}
end
