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

--Handling modification of the terrain - possibly have pickaxes and drills, and make a table for cracking blocks and such
function modifyterrain()
	
end

--test function (detonation)
function blow_up()
	for x = playerpos[1],playerpos[1] do
		for y = playerpos[2],playerpos[2] do
			--if x > 0 and x <= mapsize[1] and y > 0 and y <= mapsize[2] then
				terrain[x][y] = 1
			--end
		end
	end
end


-- do this position for on the fly render adjust 
function literalpos()
	literal_pos_x = math.floor(((playerpos[1] * tilesize) - movementfloat[1])/tilesize + 0.5) 
	literal_pos_y = math.floor(((playerpos[2] * tilesize) - movementfloat[2])/tilesize + 0.5)
end
