

--you were making the gui grow bigger when you mouse over it, then making it grow smaller when not moused over



guiscale     = 30
guihover     = false
invselection = 0

--allow for mouse environment interactions
function tileselection()
	local mousex,mousey = love.mouse.getPosition( )
	--selectionx    = ((math.floor(((mousex-movementfloat[1])+windowcenter[1])/tilesize)*tilesize)-(windowcenter[1]))+(movementfloat[1])
	selectionx    = (((math.floor((mousex-windowcenter[1]-movementfloat[1])/tilesize + 0.5) * tilesize ) + windowcenter[1]) - (tilesize/2))+movementfloat[1]
	selectiony    = (((math.floor((mousey-windowcenter[2]-movementfloat[2])/tilesize + 0.5) * tilesize ) + windowcenter[2]) - (tilesize/2))+movementfloat[2]
	-- add plus one to move it into correct pos, subtract movement float for some reason
	selected_tile = {((math.floor((selectionx-windowcenter[1]-movementfloat[1])/tilesize))+playerpos[1])+1,((math.floor((selectiony-windowcenter[2]-movementfloat[2])/tilesize))+playerpos[2])+1}
	
	
	selection     = true
	--this was an experiment, uncomment to have fun
	
	
	if love.mouse.isDown("l") then
		if selected_tile[1] >= 1 and selected_tile[1] <= mapsize[1] and selected_tile[2] >= 1 and selected_tile[2] <= mapsize[2] and guihover == false then
			
			--terrain modificaton test
			modifyterrain()
			
			dig:stop()
			dig:play()
			for i = 1,tablelength(enemy_table) do
				if enemy_table[i] then
					if enemy_table[i]["pos"][1] == selected_tile[1] and enemy_table[i]["pos"][2] == selected_tile[2] then
						enemycounter = enemycounter - 1
						table.remove(enemy_table, i)
					end
				end
			end
		end
	elseif love.mouse.isDown("m") then
		add_enemies()
	elseif love.mouse.isDown("r") then
		add_enemies_to_table()
	end
	
end

--do this for clicks instead of holding down the mouse
function mouseclick()

end
