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
--player's float position (Actual position)
function playerrealpos()
	local x = playerpos[1]-(movementfloat[1]/64)
	local y = playerpos[2]-(movementfloat[2]/64)
	return({x,y})
end

--pi
pi = math.pi

--this is a test of map scaling - everything is currently broken when it comes to scaling from 64 pixels, so use it if you want to see some chaos
tileadd = false
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

--print tables
function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end
