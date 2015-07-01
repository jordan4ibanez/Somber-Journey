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
	for x = 1,mapsize[1] do
		for y = 1,mapsize[2] do
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
