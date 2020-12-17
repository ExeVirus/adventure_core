-- FORMSPECS

local red    = minetest.get_color_escape_sequence("red")
local blue   = minetest.get_color_escape_sequence("blue")
local green  = minetest.get_color_escape_sequence("green")	
local yellow = minetest.get_color_escape_sequence("yellow")
local black = minetest.get_color_escape_sequence("#111111")

-- Guidebook formspec (with or without default)
function adv_core.guide_formspec(name)
	--Display Guide (scrollable formspec)
	local formspec = {
        "formspec_version[3]",
        "size[8,12]",
		"position[0.5,0.5]",
		"anchor[0.5,0.5]",
		"no_prepend[]",
		"bgcolor[#EAD994FF;both;#00000080]",
		"box[0.6,0.4;6.8,1.2;#00000030]",
		"image[0.7,0.5;6.6,1;title.png]",
		"box[2.73,2.77;0.55,0.4;#00000030]", --fire
		"box[3.35,2.77;0.75,0.4;#00000030]", --water
		"box[4.15,2.77;0.7,0.4;#00000030]", --earth
		"box[4.87,2.77;0.41,0.4;#00000030]", --air
		"image[2.8,5.2;0.5,0.5;fire.png]",
		"button[6.12,4.24;1.5,0.5;play;This Sound]",
		"style_type[label;noclip=true]",
		"label[1,2;",black,
		"-----------   Adventure Core is a discovery mod!   -----------\n", black,
		"]",
		"label[0.3,2.5;",black,
		"You are encourged to search far and wide in search of the\n", black,
		"          Four Elements: ",red,"   Fire   ", blue, "Water   ", green, "Earth   ", yellow, "Air\n\n",black,
		"These elements are found more commonly the further you wander,\n",black,
		"dig, and climb from spawn, and you must be ready for:\n",black, --This sound
		"When you hear it, an element has just spawned near you!\n",black,
		"Look for something like          glowing and floating above the terrain.\n",black,
		"Click/Punch to capture it, and you have collected a piece of element!\n",black,
		
		"To view how much element you have collected ",
	}
	--optional display based on settings, very handy
	if adv_core.setting("enable_chat_commands",true) then
		table.insert(formspec, "type '/pouch' in chat, or\n")
		table.insert(formspec, black)
	end
	table.insert(formspec, "craft a 'guidebook'.\n\n")
	table.insert(formspec, black)
	table.insert(formspec, "          There is also a Adventure shop!\n")
	table.insert(formspec, black)
	if adv_core.setting("enable_adventure_shop",true) then
		if adv_core.setting("enable_chat_commands",true) then
			table.insert(formspec, "You can craft this shop, or use the '/shop' command.\n")
			table.insert(formspec, black)
		else
			table.insert(formspec, "You can craft this shop and place it in the world.\n")
			table.insert(formspec, black)
		end
	else
		if adv_core.setting("enable_chat_commands",true) then
			table.insert(formspec, "You can use the '/shop' command to access it.\n")
			table.insert(formspec, black)
		else
			table.insert(formspec, "You will have to search the map for these special places.\n")
			table.insert(formspec, black)			
		end
	end
	table.insert(formspec, "     There, you can buy unique objects and items.\n\n")
	table.insert(formspec, black)
	
	if(minetest.get_modpath("default")) ~= nil and adv_core.setting("enable_spawn_biome", true) then
		table.insert(formspec, "Hint: Elements will spawn according to what biome you are in.\n\n")
		table.insert(formspec, black)
	end
	--table.insert(formspec, ""
	table.insert(formspec, "                 -------------   Happy Adventuring!   -------------")
	table.insert(formspec, "]")
    
	
	return table.concat(formspec, "")
end

-- Pouch Formspec
function adv_core.pouch_formspec(name)
	-- Display Pouch
	local pouch = adv_core.load_pouch(name)
	
	local formspec = {
        "formspec_version[3]",
        "size[6,6]",
		"position[0.5,0.6]",
		"anchor[0.5,0.5]",
		"no_prepend[]",
		"bgcolor[#00000000;both;#00000080]",
		"background[0,0;6,6;pouch.png]",
		"image[0.8,0.4;2,2;fire.png]",
        "label[1.4,2.5;", red,   "Fire: " , pouch.fire , "]",
		"image[3.14,0.4;2,2;water.png]",
		"label[3.67,2.5;", blue,  "Water: ", pouch.water, "]",
		"image[0.8,2.9;2,2;earth.png]",
		"label[1.3,5;", green, "Earth: ", pouch.earth, "]",
		"image[3.11,2.9;2,2;air.png]",
		"label[3.82,5;", yellow,"Air: "  , pouch.air  , "]",
    }
	
	return table.concat(formspec, "")
end


-- Store Formspec, with search functionality
function adv_core.store_formspec(name, page, search, selected)
--how to sort:
--https://stackoverflow.com/questions/17436947/how-to-iterate-through-table-in-lua
	local objectTable = minetest.deserialize(adv_core.mod_storage:get_string("objectTable")) or {}
	local num_pages = adv_core.get_num_pages()
	local num_objects = adv_core.get_num_objects()
	
	minetest.chat_send_all("Objects: " .. num_objects)
	
	local formspec = {
        "formspec_version[3]",
        "size[16,12]",
		"position[0.5,0.5]",
		"anchor[0.5,0.5]",
		"no_prepend[]",
		--background
		"bgcolor[#866f4c;both;#00000080]",
		"box[0.2,0.2;15.6,11.6;#dec29cFF]",
		--pouch
		"box[0.3,2.4;0.6,6.6;#564222FF]",
		"image[0.4,2.6;0.4,0.4;pouch.png]",
		"image[0.35,3.2;0.5,0.5;fire.png]",
		"image[0.35,4.6;0.5,0.5;water.png]",
		"image[0.35,6.0;0.5,0.5;earth.png]",
		"image[0.35,7.4;0.5,0.5;air.png]",
		--Search Bar
		"field[9.0,10;6,0.6;search;;]",
		"image_button[14.1,10;0.6,0.6;search.png;do_search;]",
		"image_button[14.8,10;0.6,0.6;clear.png;reset_search;]",
		--Paging
		"label[11,1;Page ", page , " of " , num_pages , "]",
		"image_button[11.3,0.2;0.6,0.6;prev.png;next_page;]",
		"image_button[12.3,0.2;0.6,0.6;next.png;previous_page;]",
		}
		
		if num_objects > 0 then			
			local matched = {}
			local unmatched = {}
			if search ~= nil and search ~= "" then
				--Separate
				for object in pairs(objectTable) do
					if string.find(object, search) == nil then
						unmatched[#unmatched+1] = object
					else
						matched[#matched+1] = object
					end
				end
				--Sort A-Z
				table.sort(unmatched);
				table.sort(matched);
				
				local num_matched = #matched
				--Add unmatched to matched
				for i = 1, #unmatched do
					matched[#matched+1] = unmatched[i]
				end
				
				local defs = minetest.registered_nodes
				for i = (page-1)*72+1, math.min(page*72+1,#matched) do
					local index = i - (page-1)*72-1 --index is for finding row-column
					local row = math.floor(index / 6)
					local column = index - row*6
					if i < (num_matched+2) then
						--Display Blue
						formspec[#formspec+1] = "item_image_button[column*0.6+9,row*0.6+2;0.5,0.5;"
						formspec[#formspec+1] = matched[i] 
						formspec[#formspec+1] = ";select;"
						formspec[#formspec+1] = matched[i]
						formspec[#formspec+1] = ";],"
						
					else
						--Display Normal
						formspec[#formspec+1] = "item_image_button[column*0.6+9,row*0.6+2;0.5,0.5;"
						formspec[#formspec+1] = matched[i] 
						formspec[#formspec+1] = ";select;"
						formspec[#formspec+1] = matched[i]
						formspec[#formspec+1] = ";],"
					end
					--table.concat(formspec, "image_button[row*0.6,column*0.6;0.5,0.5;" .. node_def[object].inv_img .. ";select;".. object .."],")
					--table.concat(formspec, "tooltip[blah;blah],")
				end
			else --Display Normally
				minetest.chat_send_all("Normal List")
				for object in pairs(objectTable) do
					minetest.chat_send_all(object)
					unmatched[#unmatched+1] = object
				end
				table.sort(unmatched);
				minetest.chat_send_all(#unmatched)
				
				for i = (page-1)*72+1, math.min(page*72+1,#unmatched) do
					local index = i - (page-1)*72-1 --index is for finding row-column
					minetest.chat_send_all(index)
					local row = math.floor(index / 6)
					local column = index - row*6
					--Display Normal
					formspec[#formspec+1] = "item_image_button[column*0.6+9,row*0.6+2;0.5,0.5;"
					formspec[#formspec+1] = matched[i] 
					formspec[#formspec+1] = ";select;"
					formspec[#formspec+1] = matched[i]
					formspec[#formspec+1] = ";],"
				end
			end
		end
		
		
		
		
		--Columns and Rows of objects
			--Get object list
			--Perform Search, if applicable.
			--Recombine the matched and unmatched object groups after sorting a-z.
			--Display current page of objects as from starting page value to either end of array or end of page value
			
		--Selected Item Display
	    if objectTable.selected ~= nil then
			--Show item
			--Show Cost
			--Show "Create" button
		end
    
    -- Number of pages is always the same, search function will separate them into
    -- a group of matched and the rest in unmatched.
    -- Then it will display *both* sets in alphabetical order, matching first.
    -- Matching are displayed with a light-blue background box around them.
	return table.concat(formspec, "")
end

-- formspec callbacks
minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
    if formname ~= "adventure_core:store" and formname ~= "adventure_core:guidebook" then
        return
    end
	if formname == "adventure_core:guidebook" then
		if fields.play then
			minetest.sound_play("adv_core_spawn_sound", {to_player = name, gain=0.8})
		end
	else -- must be store
		if fields.create and fields.selected then
			
		end
	end
end)