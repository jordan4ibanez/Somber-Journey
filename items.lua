--items are stored here


--search through the gun type to change the action of left clicking - holding a pistol shoot, holding a shovel dig

--the items in the world
function generate_items()
	item_table  = {}
	itemcounter = 0
	generate_item_things()

	for i = 1,100 do
		itemcounter = itemcounter + 1
		print(item_key_table[math.random(1,tablelength(item_key_table))])
		table.insert(item_table, {
							pos     = {math.random(1,mapsize[1]-1),math.random(1,mapsize[2]-1)},
							realpos = nil,
							item    = item_def[item_key_table[math.random(1,tablelength(item_key_table))]]
						})
	end
end

--this generates the keys to get items from the item_def table
--this also generates the images for items
--it also generates keys for the item tables
function generate_item_things()
	item_key_table = {}
	item_images    = {}
	local count = 0
	for key,value in pairs(item_def) do
		count = count + 1
		item_key_table[count] = key
		item_images[key] = love.graphics.newImage(item_def[key]["image"])
		--insert the name value into it's table for ease of use
		item_def[key]["key"] = key
	end
end

--these are a bunch of non corrolating stock images for now - please excuse

--the item definitions
item_def = {
	--weapons
	M2111  = {
		image = "M2111.png",
		name  = "M2111",
		type  = "pistol",
		},
	SW2500 = {
		image = "SW2500.png",
		name  = "SW2500",
		type  = "pistol",
		},
	humidor_gridiron = {
		image = "humidor_gridiron.png",
		name  = "Humidor GridIron",
		type  = "pistol",
		},
	AP354precision = {
		image = "AP354precision.png",
		name  = "AP 354 Precision",
		type  = "pistol",
		},
	--weapon addons
	--food
	--health
	--garbage
	--clothing/armor
	
}
