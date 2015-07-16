--round function
function round(num, n)
  local mult = 10^(n or 0)
  return math.floor(num * mult + 0.5) / mult
end
--get table size
function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
--enemy's real position on map
function enemyrealpos(i)
	local x = (((xer * tilesize ) + windowcenter[1]) - (playerpos[1] * tilesize)) + movementfloat[1] + enemy_table[i][4][1] --KEEP THIS AS PLAYERPOS SO IT FOLLOWS THE CONTINUITY AROUND THE PLAYER 
	local y = (((yer * tilesize ) + windowcenter[2]) - (playerpos[2] * tilesize)) + movementfloat[2] + enemy_table[i][4][2] --OR IN OTHER WORDS, DO IT SO THE ENEMY IS DRAWN AS PART OF THE MAP
	return({x,y})
end

--pi
pi = math.pi

--this is a test of map scaling - everything is currently broken when it comes to scaling from 64 pixels
tileadd = true
function tilesizetest()
	if tileadd == true then
		tilesize = tilesize + 1
	elseif tileadd == false then
		tilesize = tilesize - 1
	end
	
	if tilesize == 64 then
		tileadd = false
	elseif tilesize == 32 then
		tileadd = true
	end
end
