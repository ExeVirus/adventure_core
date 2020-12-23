-- CHAT COMMANDS
if adv_core.setting("enable_chat_commands",true) then
	
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
	


	--Priv only API commands
	
	--Set player pouch contents
	
	--spawn elements 
	
	--
end

	minetest.register_chatcommand("guidebook", {
		params = "<name> <privilege>",
		
		description = "Read the Adventure_Core Guide",
		
		privs = {interact = true},
		
		func = function (name)
			minetest.show_formspec(name, "adventure_core:guidebook", adv_core.guide_formspec(name))
			return true
		end,
	})
 