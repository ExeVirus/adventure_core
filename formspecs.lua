-- FORMSPECS

-- Guidebook formspec (with or without default)
function adv_core.guide_formspec(name)
	--Display Guide (scrollable formspec)


end

-- Pouch Formspec
function adv_core.pouch_formspec(name)
	-- Display Pouch
end


-- Store Formspec, with search functionality
function adv_core.store_formspec(name, page, search, selected)
--how to sort:
--https://stackoverflow.com/questions/17436947/how-to-iterate-through-table-in-lua
	-- Display Pouch, left side panel
	-- Search bar, middle-bottom of right half
	-- Grid of options. right half
	-- Paging arrows <->, bottom of right half
	-- Selected item, and cost, left half
	-- Create Button, bottom of left half.
end

-- 
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "adventure_core:store" then
        return
    end

    if fields.create and fields.selected then
		
    end
end)