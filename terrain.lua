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




--[[



!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	THIS ID TABLE NEEDS TO BE REWRITTEN SO THAT IT'S NOT COMPLETE SHIT!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

--rewrite it so it's modular like the enemy table


]]--

--make this load up an image if it's not already loaded up instead of doing this
tile_id_table = {
--{"name","texture","wall","hurtplayer"} --table example
{"dirt"      ,"dirt.png"   ,false ,false}, --dirt
{"dead grass","dead_grass.png"   ,false ,false}, --dirt
{"wall"      ,"wall.png"   ,true  ,false}, --wall
}

function generate_tile_images()
	tile_images    = {}
	for i = 1,tablelength(tile_id_table) do
		tile_images[tile_id_table[i][1]] = love.graphics.newImage(tile_id_table[i][2]) -- set the name of the tile as the key
	end
end


--Handling modification of the terrain - possibly have pickaxes and drills, and make a table for cracking tiles and such
function modifyterrain()
	local tile = terrain[selected_tile[1]][selected_tile[2]]
	if tile == 1 or tile == 2 then
		terrain[selected_tile[1]][selected_tile[2]] = 3--math.random(1,tablelength(tile_id_table))
	else
		terrain[selected_tile[1]][selected_tile[2]] = math.random(1,2)
	end
end

-- do this position for on the fly render adjust 
function literalpos()
	literal_pos_x = math.floor(((playerpos[1] * tilesize) - movementfloat[1])/tilesize + 0.5) 
	literal_pos_y = math.floor(((playerpos[2] * tilesize) - movementfloat[2])/tilesize + 0.5)
end
