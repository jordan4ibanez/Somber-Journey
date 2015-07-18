--this file handles the player's inventory
inventory = {}

--have this go when the player stops moving
function collect_item()
	local removaltable = {}
	--check all the items needed to be removed
	for i = 1,tablelength(item_table) do
		if item_table[i]["pos"][1] == playerpos[1] and item_table[i]["pos"][2] == playerpos[2] then
			table.insert(removaltable, i)
		end
	end
	for i = 1,tablelength(removaltable) do
		table.insert(inventory, item_table[i]["item"]["key"])
		table.remove(item_table, removaltable[i])
		--shorten the values of the other objects to compensate
		for x = i,tablelength(removaltable) do
			removaltable[x] = removaltable[x] - 1
		end
	end
end
