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
        "size[9,11.5]",
		"position[0.5,0.5]",
		"anchor[0.5,0.5]",
		"no_prepend[]",
		"bgcolor[#EAD994FF;both;#00000080]",
		"box[1.12,0.2;6.8,1.2;#00000030]",
		"image[1.2,0.3;6.6,1;title.png]",
		"box[2.22,2.49;0.55,0.4;#00000030]", --fire
		"box[2.82,2.49;0.75,0.4;#00000030]", --water
		"box[3.63,2.49;0.7,0.4;#00000030]", --earth
		"box[4.35,2.49;0.41,0.4;#00000030]", --air
		"image[3.06,4.57;0.5,0.5;fire.png]",
		"hypertext[0.3,1.5;8.4,9.5;;",
        "<global halign=center color=#000 size=12 font=Regular>",
        "  -----------   Adventure Core is a discovery mod!   ----------- \n",
        "<global halign=left>",
        "You are encourged to search far and wide in search of the\n",
        "Four Elements: <style color=#F00> Fire  </style><style color=#00F>Water  </style>",
                        "<style color=#0F0>Earth  </style><style color=#FF0>Air   </style>\n",
        "These elements are found more commonly the futher you wander,\n",
        "dig, and climb from spawn, and you must be ready for:\n", --This sound
        "When you hear it, an element has just spawned near you!\n",
        "Look for something like        glowing and floating above the terrain.\n",
        "Click/Punch to capture it, and you have collected a piece of element!\n",
        "To view how much you have collected ", 
    }
    --optional display based on settings, very handy
    if adv_core.setting("enable_chat_commands",true) then
     table.insert(formspec, "type '/pouch' in chat, or\n")
    end
    table.insert(formspec, "craft a 'guidebook'.\n")
    table.insert(formspec, "<global halign=center>\n There is also a Adventure shop!\n")
    if adv_core.setting("enable_adventure_shop",true) then
     if adv_core.setting("enable_chat_commands",true) then
         table.insert(formspec, "You can craft this shop, or use the '/shop' command.\n")
     else
         table.insert(formspec, "You can craft this shop and place it in the world.\n")
     end
    else
     if adv_core.setting("enable_chat_commands",true) then
         table.insert(formspec, "You can use the '/shop' command to access it.\n")
     else
         table.insert(formspec, "You will have to search the map for these special places.\n")
     end
    end
    table.insert(formspec, "There, you can buy unique objects and items.\n\n")

    if(minetest.get_modpath("default")) ~= nil and adv_core.setting("enable_spawn_biome", true) then
     table.insert(formspec, "Hint: Elements will spawn according to what biome you are in.\n\n")
    end
    table.insert(formspec, "-------------   Happy Adventuring!   -------------")
    table.insert(formspec, "]")
    table.insert(formspec, "button[6.8,3.5;1.5,0.5;play;TryMe]")
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
    page = tonumber(page)
    search = tostring(search)
    selected = tostring(selected)
    local objectTable = adv_core.objectTable
    local num_objects = adv_core.num_objects
    local num_pages = math.floor(num_objects / 64)+1
    local pouch = adv_core.load_pouch(name)
    minetest.chat_send_all(minetest.serialize(pouch))
    if page > num_pages then page = num_pages end
    
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
        "hypertext[0.3,3.9;1.5,1;;<global halign=left size=16 font=regular color=#F00> ", pouch.fire, "]",
        "hypertext[0.3,5.3;1.5,1;;<global halign=left size=16 font=regular color=#00F> ", pouch.water, "]",
        "hypertext[0.3,6.8;1.5,1;;<global halign=left size=16 font=regular color=#0F0> ", pouch.earth, "]",
        "hypertext[0.3,8.1;1.5,1;;<global halign=left size=16 font=regular color=#FF0> ", pouch.air, "]",
		--Search Bar
		"field[9.0,10;5,0.6;search;;",search,"]",
        "field_close_on_enter[search;false]",
		"image_button[14.1,10;0.6,0.6;search.png;do_search;]",
		"image_button[14.8,10;0.6,0.6;clear.png;reset_search;]",
		--Paging
		--hypertext element is set based on if search is used
        "field[0,0;0,0;page;;",page,"]",
		"image_button[11.3,0.5;0.6,0.6;prev.png;previous_page;]",
		"image_button[12.3,0.5;0.6,0.6;next.png;next_page;]",
		}
        
        --Rows and Columns of Items
		if num_objects > 0 then
			local matched = {}
			local unmatched = {}
			if search ~= nil and search ~= "" then
				--Separate
				for object in pairs(objectTable) do
					if string.find(object, search) ~= nil then
						matched[#matched+1] = object
					end
				end
				--Sort A-Z
				table.sort(matched);
                num_pages = math.floor(#matched/64+1)
                if page > num_pages then page = num_pages end
                --add hypertext element:
                formspec[#formspec+1] = "hypertext[8,1.1;8,1;;<global halign=center size=20 font=normal color=#000> Page "
                formspec[#formspec+1] = page 
                formspec[#formspec+1] = " of "
                formspec[#formspec+1] = num_pages
                formspec[#formspec+1] = "]"
                
				for i = (page-1)*64+1, math.min(page*64,#matched) do
					local index = i - (page-1)*64-1 --index is for finding row-column
					local row = math.floor(index / 8)
					local column = index - row*8
                    
                    formspec[#formspec+1] = "item_image_button["
                    formspec[#formspec+1] = column*0.95+8.1
                    formspec[#formspec+1] = ","
                    formspec[#formspec+1] = row*0.95+2
                    formspec[#formspec+1] = ";0.9,0.9;"
                    formspec[#formspec+1] = matched[i]
                    formspec[#formspec+1] = ";"
                    formspec[#formspec+1] = adv_core.escape_for_formspec(matched[i])
                    formspec[#formspec+1] = ";]"
                    formspec[#formspec+1] = "tooltip["
                    formspec[#formspec+1] = adv_core.escape_for_formspec(matched[i])
                    formspec[#formspec+1] = ";"
                    formspec[#formspec+1] = matched[i]
                    formspec[#formspec+1] = ";#000;#FFF]"				
				end
			else --Display Normally
				
                --Show number of pages
                formspec[#formspec+1] = "hypertext[8,1.1;8,1;;<global halign=center size=20 font=normal color=#000> Page "
                formspec[#formspec+1] = page 
                formspec[#formspec+1] = " of "
                formspec[#formspec+1] = num_pages
                formspec[#formspec+1] = "]"
                
                --sort A-Z
				for object in pairs(objectTable) do
					unmatched[#unmatched+1] = object
				end
				table.sort(unmatched);
				for i=1,#unmatched do
                    minetest.chat_send_all(unmatched[i])
                end
                
                --Display current page
				for i = (page-1)*64+1, math.min(page*64,#unmatched) do
					local index = i - (page-1)*64-1 --index is for finding row-column
					--minetest.chat_send_all(index)
					local row = math.floor(index / 8)
					local column = index - row*8
					--Display Normal
					formspec[#formspec+1] = "item_image_button["
                    formspec[#formspec+1] = column*0.95+8.1
                    formspec[#formspec+1] = ","
                    formspec[#formspec+1] = row*0.95+2
                    formspec[#formspec+1] = ";0.9,0.9;"
					formspec[#formspec+1] = unmatched[i]
					formspec[#formspec+1] = ";"
					formspec[#formspec+1] = adv_core.escape_for_formspec(unmatched[i])
					formspec[#formspec+1] = ";]"
                    formspec[#formspec+1] = "tooltip["
                    formspec[#formspec+1] = adv_core.escape_for_formspec(unmatched[i])
                    formspec[#formspec+1] = ";"
                    formspec[#formspec+1] = unmatched[i]
                    formspec[#formspec+1] = ";#000;#FFF]"
				end
            end
		end
        	
		--Selected Item Display
	    if selected ~= nil and selected ~= "" then
            --show item
            formspec[#formspec+1] = "item_image_button[2,2;4,4;"
            formspec[#formspec+1] = selected
            formspec[#formspec+1] = ";;]"
			--Show Costs
            formspec[#formspec+1] = "hypertext[1.7,6;7,1;;<global halign=left size=16 font=regular color=#000> Fire: "
            formspec[#formspec+1] = objectTable[selected].fire
            formspec[#formspec+1] = "   Water: "
            formspec[#formspec+1] = objectTable[selected].water
            formspec[#formspec+1] = "   Earth: "
            formspec[#formspec+1] = objectTable[selected].earth
            formspec[#formspec+1] = "   Air: "
            formspec[#formspec+1] = objectTable[selected].air
            formspec[#formspec+1] = "]"
			--Show "Create" button
            if adv_core.player_can_afford_object(name, selected) then
                formspec[#formspec+1] = "button[3,7;2,1.5;create;Create]"
            else
                formspec[#formspec+1] = "button[2,7;4,1.5;;Can't Afford]"
                formspec[#formspec+1] = "box[2,7;4,1.5;#8008]"
            end
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
    local page = fields.page or 1
    if formname ~= "adventure_core:store" and formname ~= "adventure_core:guidebook" then
        return
    end
	if formname == "adventure_core:guidebook" then
		if fields.play then
			minetest.sound_play("adv_core_spawn_sound", {to_player = name, gain=0.8})
		end
	elseif formname == "adventure_core:store" then
   		if fields.quit then
            return
        end
        local search = fields.search or ""
        if fields.reset_search then
            search = ""
        elseif fields.next_page then
            page = page+1
        elseif fields.previous_page then
            page = page-1
            page = math.max(1, page)
        end
        if fields.key_enter_field == "search" then
            minetest.show_formspec(name, "adventure_core:store", adv_core.store_formspec(name, page, search, "default:apple"))
        end
        minetest.show_formspec(name, "adventure_core:store", adv_core.store_formspec(name, page, search, "default:apple"))
	end
end)