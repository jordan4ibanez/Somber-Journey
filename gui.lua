--allow for mouse environment interactions
function tileselection()
	mousex,mousey = love.mouse.getPosition( )
	selectionx = ((math.floor(((mousex-movementfloat[1])+windowcenter[1])/tilesize)*tilesize)-(windowcenter[1]))+(movementfloat[1])
	selectiony = (((math.floor((mousey-windowcenter[2]-movementfloat[2])/tilesize + 0.5) * tilesize ) + windowcenter[2]) - (tilesize/2))+movementfloat[2]
	selected_tile = {(math.floor((selectionx-windowcenter[1])/tilesize))+playerpos[1]+2,(math.floor((selectiony-windowcenter[2])/tilesize))+playerpos[2]+2}
	
	if love.mouse.isDown("r") then
		if selected_tile[1] >= 1 and selected_tile[1] <= mapsize[1] and selected_tile[2] >= 1 and selected_tile[2] <= mapsize[2] then
			terrain[selected_tile[1]][selected_tile[2]] = math.random(1,tablelength(tile_id_table))
			dig:stop()
			dig:play()
		end
	end
end

--draw the visual of the selected tile
function drawselection()
	love.graphics.rectangle("line", selectionx, selectiony, tilesize , tilesize )
end
