-- CHAT COMMANDS
if adv_core.setting("enable_chat_commands",true) then
	
	minetest.register_chatcommand("make_shop", {
		params = "<name> <privilege>",
		
		description = "Generate an Adventure Shop Node",
		
		privs = {interact = true},
		
		func = function(name)
			return true, "You said"
		end,
	})
	
	
	
	
	--Priv Specific API commands
end