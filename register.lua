-- REGISTER
for node in pairs(minetest.registered_nodes) do
    adv_core.register_object(node, 0, 0, 1, 1)
end

--Register Adventure_Shop

--Register craft recipe, if desired.




-- ---Register the round rock
-- minetest.register_node("rocks:".. name .."_round", {
	-- description = "Round " .. name .. " Rock",
	-- drawtype = "mesh",
	-- mesh = "round.obj",
	-- sunlight_propagates = true,
	-- paramtype2 = "facedir",
	-- collision_box = {
		-- type = "fixed", --Complicated Collision Boxes:
		-- fixed = {
					-- {-0.18, -0.41, -0.8, 0.62, 0.39, -0.6},
					-- {-0.6, -0.5, -0.6, 0.35, 0.5, 0.7},
					-- {0.02, -0.21, -0.6, 0.77, 1.09, 0.7},
					-- {-0.36, -0.35, 0.70, 0.49, 0.75, 1.02},
					-- {-0.38, 0.5, -0.55, 0.02, 0.85, 0.85},
				-- }
	-- },
	-- selection_box = {
		-- type = "fixed",
		-- fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}, 
	-- },

	-- tiles = {image},
	
	-- groups = { cracky=2 },

-- })

-- minetest.register_craft({
	-- output = "rocks:".. name .."_round 1",
	-- recipe = {
		-- {"",            recipe_cobble,  ""},
		-- {recipe_cobble, recipe_stone,   recipe_cobble},
		-- {"",            recipe_cobble,  ""},
	-- },
-- })