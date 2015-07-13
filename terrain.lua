--generate random terrain (This is a debug function [ maps will be created using the map creator in future updates ] )
function terrain_gen()
	terrain = {}
	math.randomseed( os.time() )
	for  x = 1,mapsize[1] do
		terrain[x] = {}
		for  y = 1,mapsize[2] do
			terrain[x][y] = math.random(1,tablelength(tile_id_table))
		end
	end
end


tile_id_table = {
--{"name","texture","wall","hurtplayer"} --table example
{"dirt"  ,love.graphics.newImage("dirt.png")   ,false ,false}, --dirt
{"wall"  ,love.graphics.newImage("wall.png")   ,true  ,false}, --wall
{"dead grass"  ,love.graphics.newImage("dead_grass.png")   ,false ,false}, --wall
}

function draw_map()
	--draw map
	
	--save gpu by only rendering things on screen
	local x_render    = math.floor(windowcenter[1]/tilesize + 0.5)+2 --figure out why you have to add + 2 later
	local y_render    = math.floor(windowcenter[2]/tilesize + 0.5)+2
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
			--sub to center it
			xer = x - 1
			yer = y - 1
			
			local literalx = (((xer * tilesize ) + windowcenter[1]) - (playerpos[1] * tilesize)) + movementfloat[1]
			local literaly = (((yer * tilesize ) + windowcenter[2]) - (playerpos[2] * tilesize)) + movementfloat[2]
			love.graphics.draw(texture, literalx, literaly, 0, 1, 1, tilesize / 2, tilesize / 2)
		end
	end
end

--Handling modification of the terrain - possibly have pickaxes and drills, and make a table for cracking blocks and such
function modifyterrain()
	
end
