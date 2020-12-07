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
		"style[label;font=mono]",
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
	-- Display Pouch, left side panel
	-- Search bar, middle-bottom of right half
    -- Reset Search, bottom right corner
	-- Grid of options. right half
	-- Paging arrows <->, middle left and right of right half
	-- Selected item, and cost, left half
	-- Create Button, bottom middle of left half.
    
    
    -- Number of pages is always the same, search function will separate them into
    -- a group of matched and the rest in unmatched.
    -- Then it will display *both* sets in alphabetical order, matching first.
    -- Matching are displayed with a light-blue background box around them.
    
    -- if stinrg.find("search") == nil then
            --place in unmatched
    -- else
            --place in matched
    -- end

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