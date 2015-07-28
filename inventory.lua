--this file handles the player's inventory
inventory = {}

--have this go when the player stops moving
function collect_item()
	local collection   = false
	local removaltable = {}
	--check all the items needed to be removed
	for i = 1,tablelength(item_table) do
		if item_table[i]["pos"][1] == playerpos[1] and item_table[i]["pos"][2] == playerpos[2] then
			table.insert(removaltable, i)
			collection = true
		end
	end
	--play the pickup sound
	if collection == true then
		pickup:play()
	end
	for i = 1,tablelength(removaltable) do
		inventory_add(item_table[removaltable[i]]["item"]["key"])
		table.remove(item_table, removaltable[i])
		--shorten the values of the other objects to compensate 1,2,3,4 (remove 2) 1,2,3
		for x = i,tablelength(removaltable) do
			removaltable[x] = removaltable[x] - 1
		end
	end
end

--add items to the inventory
function inventory_add(item)
	--if there's items in the invetory add
	print(inventory[item])
	if inventory[item] ~= nil then
		print("-----------\nADDING ITEM IN INVENTORY\n--------------")
		inventory[item]["value"] = inventory[item]["value"] + 1
	else --if not, create one
		print("-----------\nCREATING ITEM IN INVENTORY\n--------------")
		inventory[item] = {}
		inventory[item]["value"] = 1
		inventory[item]["key"] = item
	end
	print_r(inventory)
end
