-- REGISTER

--Register Adventure_Shop
minetest.register_node("adventure_core:shop", {
	description = "Aventure Shop",
	drawtype = "node",
	sunlight_propagates = false,
	paramtype2 = "facedir",
	tiles = {"shop_tb.png", "shop_tb.png", "shop_side.png", "shop_side.png", "shop_side.png", "shop.png"},
	groups = {oddly_breakable_by_hand=2},
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local name = player:get_player_name()
		minetest.show_formspec(name, "adventure_core:store", adv_core.store_formspec(name, 1, "", ""))
	end,
})

local craftable_shop = adv_core.setting("enable_adventure_shop", true)
local default_present = true 

if(minetest.get_modpath("default")) == nil then
	default_present = false
end

if craftable_shop and default_present then
	minetest.register_craft({
		output = "adventure_core:shop",
		recipe = {
			{"default:wood", "default:sign_wall_wood", "default:wood"},
			{"default:wood", "default:chest", 		   "default:wood"},
			{"default:wood", "default:wood", 		   "default:wood"},
		}
	})
end

--Register Guidebook and Pouch
minetest.register_craftitem("adventure_core:pouch", {
	description = "Aventure Pouch",
	inventory_image = "pouch.png",
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		minetest.show_formspec(name, "adventure_core:pouch", adv_core.pouch_formspec(name))
	end,
})

minetest.register_craftitem("adventure_core:guidebook", {
	description = "Aventure Guide",
	inventory_image = "guidebook.png",
	on_use = function(itemstack, user, pointed_thing)
		local name = user:get_player_name()
		minetest.show_formspec(name, "adventure_core:guidebook", adv_core.guide_formspec(name))
	end,
})



--Register Builtins, if enabled
if adv_core.setting("enable_builtin_nodes", true) then
	local bridgeboxes = {{-1.5,-0.45,-0.5,1.5,-0.36,0.5},{-1.5,-0.5,-0.5,1.5,0.5,-0.45},{-1.5,-0.5,0.5,1.5,0.5,0.45}}

	minetest.register_node("adventure_core:bridge", {
		description = "Bridge",
		drawtype = "mesh",
		mesh = "bridge.obj",
		sunlight_propagates = true,
		paramtype2 = "facedir",
		collision_box = {
			type = "fixed", 
			fixed = bridgeboxes,
		},
		selection_box = {
			type = "fixed", 
			fixed = bridgeboxes
		},
		tiles = {"bridge.jpg"},
		groups = {oddly_breakable_by_hand=2},
	})
	
	minetest.register_node("adventure_core:bonzai", {
		description = "Bonzai",
		drawtype = "mesh",
		mesh = "bonzai.obj",
		sunlight_propagates = true,
		paramtype2 = "facedir",
		collision_box = {
			type = "fixed", 
			fixed = {-0.4,-0.4,-0.4,0.4,0.4,0.4},
		},
		selection_box = {
			type = "fixed", 
			fixed = {-0.4,-0.4,-0.4,0.4,0.4,0.4},
		},
		tiles = {"wood.jpg", "leaf.png"},
		inventory_image = "bonzai_inv.png",
		groups = {oddly_breakable_by_hand=2},
	})

	minetest.register_node("adventure_core:rune", {
		description = "Rune",
		drawtype = "mesh",
		mesh = "rune.obj",
		sunlight_propagates = true,
		paramtype2 = "facedir",
		collision_box = {
			type = "fixed", 
			fixed = {{0.895, -0.455, -0.785, -0.865, -0.015, 0.645},{0.235, -0.015, -0.235, -0.205, 1.195, 0.095},},
		},
		selection_box = {
			type = "fixed", 
			fixed = {{0.895, -0.455, -0.785, -0.865, -0.015, 0.645},{0.235, -0.015, -0.235, -0.205, 1.195, 0.095},},
		},
		tiles = {"rune.png"},
		groups = {oddly_breakable_by_hand=2},
	})

	minetest.register_node("adventure_core:campfire", {
		description = "Campfire",
		drawtype = "mesh",
		mesh = "campfire.obj",
		sunlight_propagates = true,
		paramtype2 = "facedir",
		light_source = 11,
		
		collision_box = {
			type = "fixed", 
			fixed = {{0.66, -0.5, -0.66, -0.62, -0.26, 0.62},},
		},
		selection_box = {
			type = "fixed", 
			fixed = {-0.5,-0.5,-0.5,0.5,0.2,0.5},
		},
		tiles = {
			"wood.jpg",
			{name="fire_animated.png", animation={type = "vertical_frames", aspect_w = 16, aspect_h = 16, length = 2.7,},}
		},
		inventory_image = "campfire_inv.png",
			-- Full loop length},
		groups = {oddly_breakable_by_hand=2},
	})

	minetest.register_node("adventure_core:flag", {
		description = "Flag",
		drawtype = "mesh",
		mesh = "flag.obj",
		sunlight_propagates = true,
		paramtype2 = "facedir",
		collision_box = {
			type = "fixed", 
			fixed = {{0.125, -0.475, -0.075, -0.025, 0.325, 0.025},{0.075, -0.475, -0.125, -0.025, -0.425, -0.075},{0.075, 0.325, -0.025, -0.025, 0.575, 0.025},},
		},
		selection_box = {
			type = "fixed", 
			fixed = {-0.035, -0.475, -0.05, 0.075, 0.5, 0.035},
		},
		tiles = {"blue.png","grey.png"},
		inventory_image = "flag_inv.png",
		groups = {oddly_breakable_by_hand=2},
	})

	minetest.register_node("adventure_core:axe_stump", {
		description = "Axe Stump",
		drawtype = "mesh",
		mesh = "axe_stump.obj",
		sunlight_propagates = true,
		paramtype2 = "facedir",
		collision_box = {
			type = "fixed", 
			fixed = {{0.525, -0.475, -0.225, -0.075, -0.025, 0.275},{0.475, -0.475, -0.475, -0.275, -0.125, -0.225},{0.475, -0.475, 0.275, -0.275, 0.025, 0.525},{0.425, -0.025, -0.125, -0.325, 0.075, 0.275},{0.425, 0.075, -0.175, 0.025, 0.375, 0.175},{0.375, 0.075, 0.175, 0.025, 0.325, 0.325},{0.325, -0.125, -0.375, -0.275, 0.025, -0.225},{0.325, 0.025, -0.275, -0.125, 0.375, -0.175},{0.275, 0.025, 0.325, -0.275, 0.375, 0.475},{0.275, 0.325, -0.025, -0.375, 0.375, 0.325},{0.175, 0.025, -0.375, -0.175, 0.275, -0.275},{0.175, 0.375, -0.175, -0.275, 0.425, 0.225},{0.075, -0.175, -0.225, -0.425, 0.025, -0.125},{0.025, 0.125, -0.125, -0.425, 0.325, 0.325},{-0.075, -0.475, -0.225, -0.525, -0.075, 0.275},{-0.075, -0.075, -0.125, -0.475, -0.025, 0.275},{-0.125, 0.075, -0.275, -0.325, 0.575, -0.175},{-0.125, 0.575, -0.225, -0.325, 0.775, -0.025},{-0.275, -0.475, -0.475, -0.425, -0.225, -0.225},{-0.275, -0.475, 0.275, -0.475, -0.175, 0.475},},
		},
		selection_box = {
			type = "fixed", 
			fixed = {-0.4,-0.5,-0.4,0.4,0.42,0.4},
		},
		tiles = {"axe_stump.png"},
		groups = {oddly_breakable_by_hand=2},
	})

	--Register all 6:
	adv_core.register_object("adventure_core:bridge", 0, 0, 2, 1)
	adv_core.register_object("adventure_core:rune", 1, 1, 1, 0)
	adv_core.register_object("adventure_core:bonzai", 1, 2, 1, 0)
	adv_core.register_object("adventure_core:campfire", 2, 0, 1, 0)
	adv_core.register_object("adventure_core:flag", 0, 0, 1, 1)
	adv_core.register_object("adventure_core:axe_stump", 0, 2, 2, 0)
end


