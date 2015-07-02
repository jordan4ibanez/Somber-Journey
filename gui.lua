function mousecontrol()
	mousex,mousey = love.mouse.getPosition( )
end

--allow for mouse environment interactions
function drawselection()
	selectionx = ((math.floor(((mousex)+windowcenter[1])/tilesize)*tilesize)-(windowcenter[1])) 
	selectiony = (((math.floor((mousey-windowcenter[2])/tilesize + 0.5) * tilesize ) + windowcenter[2]) - (tilesize/2))

	love.graphics.rectangle("line", selectionx, selectiony, tilesize , tilesize )
end
