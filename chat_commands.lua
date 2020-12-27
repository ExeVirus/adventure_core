-- CHAT COMMANDS

local red = minetest.get_color_escape_sequence("red")

if adv_core.setting("enable_chat_commands",true) then

	-- for give command
	local function give(player_name, item)
		local itemstack = ItemStack(item)
		if itemstack:is_empty() then
			return false
		elseif (not itemstack:is_known()) or (itemstack:get_name() == "unknown") then
			return false -- "Cannot give an unknown item"
		-- Forbid giving 'ignore' due to unwanted side effects
		elseif itemstack:get_name() == "ignore" then
			return false -- "Giving 'ignore' is not allowed"
		end
		local playerref = minetest.get_player_by_name(player_name)
		--Give to Player
		local leftover = playerref:get_inventory():add_item("main", itemstack)
		if not leftover:is_empty() then
			return false
		end
		
		return true
	end
	
	if adv_core.setting("enable_adventure_shop_chat",true) then
		minetest.register_chatcommand("shop", {
			params = "<name> <privilege>",
			
			description = "Browse the Adventure Shop",
			
			privs = {interact = true},
			
			func = function(name)
				minetest.show_formspec(name, "adventure_core:store", adv_core.store_formspec(name, 1, "", ""))
				return true
			end,
		})
	end
	
	if adv_core.setting("enable_adventure_shop_chat_build",true) then
		minetest.register_chatcommand("make_shop", {
			params = "<name> <privilege>",
			
			description = "Generate the Adventure Shop",
			
			privs = {interact = true},
			
			func = function(name)
				if adv_core.player_can_afford(name, 5, 5, 5, 5) then 
					if give(name, "adventure_core:shop") then
						adv_core.take_from_player(name, 5, 5, 5, 5, false)
					else
						minetest.chat_send_player(name, red .."Adventure_Core: No room in inventory!")
					end
				else
					minetest.chat_send_player(name, red .. "Sorry, need more elemental essence!")
				end
				return true
			end,
		})
	end
	
	minetest.register_chatcommand("pouch", {
		params = "<name> <privilege>",
		
		description = "Check your element pouch",
		
		privs = {interact = true},
		
		func = function (name)
			minetest.show_formspec(name, "adventure_core:pouch", adv_core.pouch_formspec(name))
			return true
		end,
	})
	
	minetest.register_chatcommand("guidebook", {
		params = "<name> <privilege>",
		
		description = "Read the Adventure_Core Guide",
		
		privs = {interact = true},
		
		func = function (name)
			minetest.show_formspec(name, "adventure_core:guidebook", adv_core.guide_formspec(name))
			return true
		end,
	})
	
	
	--register admin priv
	minetest.register_privilege("adv_core_admin", { description = "Adventure_Core Admin Commands", give_to_singleplayer = false,	give_to_admin = true, }
	)

	--Priv only API commands
	
	--Get player pouch contents
	minetest.register_chatcommand("get_pouch", {
		params = "<player_to_check>",
		
		description = "Check the element pouch of any player on the server",
		
		privs = {interact = true, adv_core_admin = true},
		
		func = function (name, player_to_check)
			if adv_core.check_pouch(player_to_check) then
				minetest.show_formspec(name, "adventure_core:pouch", adv_core.pouch_formspec(player_to_check))
			else 
				minetest.chat_send_player(name, red .. "That player doesn't exist yet")
			end
			return true
		end,
	})
	
	--Set Player Pouch
	minetest.register_chatcommand("set_pouch", {
		params = "<player_to_set> <fire> <water> <earth> <air>",
		
		description = "Check the element pouch of any player on the server",
		
		privs = {interact = true, adv_core_admin = true},
		
		func = function (name, params)
			local pouch
			local player_to_set, fire, water, earth, air =  params:match(
				"^([^ ]+) +([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
			if adv_core.check_pouch(player_to_set) then
				pouch = adv_core.load_pouch(player_to_set)
			else 
				minetest.chat_send_player(name, red .. "Command entered incorrectly")
				return true
			end
			pouch.fire = tonumber(fire) or pouch.fire
			pouch.water = tonumber(water) or pouch.water
			pouch.earth = tonumber(earth) or pouch.earth
			pouch.air = tonumber(air) or pouch.air
			adv_core.mod_storage:set_string(player_to_set .. "pouch", minetest.serialize(pouch))
			return true
		end,
	})
	
	--Reward Player
	minetest.register_chatcommand("adv_reward", {
		params = "<player_to_reward> <fire> <water> <earth> <air>",
		
		description = "Check the element pouch of any player on the server",
		
		privs = {interact = true, adv_core_admin = true},
		
		func = function (name, params)
			local player_to_reward, fire, water, earth, air =  params:match(
				"^([^ ]+) +([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
			if adv_core.check_pouch(player_to_reward) then
				if adv_core.reward_player(player_to_reward, tonumber(fire), tonumber(water), tonumber(earth), tonumber(air), true) == false then
					minetest.chat_send_player(name, minetest.get_color_escape_sequence("red") .. "Invalid name entered")
				end
			else 
				minetest.chat_send_player(name, red .. "That player doesn't exist yet")
			end
			return true
		end,
	})
	
	--spawn Element
	minetest.register_chatcommand("spawn_element", {
		params = "<element_type> <x> <y> <z>",
		
		description = "Spawn element (fire, water, earth, air) at position specified",
		
		privs = {interact = true, adv_core_admin = true},
		
		func = function (name, params)
			local element_type, x, y, z =  params:match(
				"^([^ ]+) +([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
			x = tonumber(x) or 0
			y = tonumber(y) or 0
			z = tonumber(z) or 0
			if element_type == "fire" then
				adv_core.spawn_element(element_type, {x=x,y=y,z=z})
			elseif element_type == "water" then
				adv_core.spawn_element(element_type, {x=x,y=y,z=z})
			elseif element_type == "water" then
				adv_core.spawn_element(element_type, {x=x,y=y,z=z})
			elseif element_type == "water" then
				adv_core.spawn_element(element_type, {x=x,y=y,z=z})
			else
				minetest.chat_send_player(name,"'" .. element_type "' is not a valid element")
			end
			return true
		end,
	})
end


 