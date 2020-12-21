-- API

function adv_core.load_pouch(name)
	local pouch = minetest.deserialize(adv_core.mod_storage:get_string(tostring(name) .. "pouch"))
	
	--init if nil
	if pouch == nil then
		pouch = {
			fire  = 0,
			water = 0,
			earth = 0,
			air   = 0,
		}
		--store it back
		adv_core.mod_storage:set_string(name .. "pouch", minetest.serialize(pouch))
	end
	
	return pouch
end

function adv_core.player_can_afford_object(name, object_name)
	local objectTable = adv_core.objectTable or {}
	if objectTable[object_name] == nil then
		return false
	end
	
	--load player pouch
    local player_pouch = adv_core.load_pouch(name)
	
	local fire_ok  = player_pouch.fire  >= objectTable[object_name].fire
	local water_ok = player_pouch.water >= objectTable[object_name].water
	local earth_ok = player_pouch.earth >= objectTable[object_name].earth
	local air_ok = player_pouch.air   >= objectTable[object_name].air
    
	if fire_ok and water_ok and earth_ok and air_ok then
		return true
	else
		return false
	end
end


function adv_core.player_can_afford(name, fire, water, earth, air)
	--load player pouch
    local player_pouch = adv_core.load_pouch(name)
	
	local fire_ok  = player_pouch.fire  >= fire
	local water_ok = player_pouch.water >= water
	local earth_ok = player_pouch.earth >= earth
	local water_ok = player_pouch.air   >= air
	
	if fire_ok and water_ok and earth_ok and air_ok then
		return true
	else
		return false
	end
end
-- (reward player with elements, pay with elements, register nodes to purchase for shop)

function adv_core.reward_player(name, fire, water, earth, air, notify)
	local player_pouch = adv_core.load_pouch(name)
	
	player_pouch.fire  = player_pouch.fire  + fire
	player_pouch.water = player_pouch.water + water
	player_pouch.earth = player_pouch.earth + earth
	player_pouch.air   = player_pouch.air   + air

	if notify then
		--notify player:
		minetest.chat_send_player(player_name, 
			"You've been rewarded elemental essence!"
		)
		
		minetest.chat_send_player(player_name, 
		minetest.get_color_escape_sequence("red") .. "Fire: "    .. player_pouch.fire  ..
		minetest.get_color_escape_sequence("blue") .. "  Water: " .. player_pouch.water ..
		minetest.get_color_escape_sequence("green") .. "  Earth: " .. player_pouch.earth ..
		minetest.get_color_escape_sequence("yellow") .. "  Air: "   .. player_pouch.air
		)
	end
end

function adv_core.take_from_player(name, fire, water, earth, air)
	local player_pouch = adv_core.load_pouch(name)
	
	--Don't reduce below zero, that's silly
	
	player_pouch.fire  = math.max(player_pouch.fire  - fire , 0)
	player_pouch.water = math.max(player_pouch.water - water, 0)
	player_pouch.earth = math.max(player_pouch.earth - earth, 0)
	player_pouch.air   = math.max(player_pouch.air   - air  , 0)

	if notify then
		--notify player:
		minetest.chat_send_player(player_name, 
			"Elemental essence taken!"
		)
		
		minetest.chat_send_player(player_name, 
		minetest.get_color_escape_sequence("red") .. "Fire: "    .. player_pouch.fire  ..
		minetest.get_color_escape_sequence("blue") .. "  Water: " .. player_pouch.water ..
		minetest.get_color_escape_sequence("green") .. "  Earth: " .. player_pouch.earth ..
		minetest.get_color_escape_sequence("yellow") .. "  Air: "   .. player_pouch.air
		)
	end
end

adv_core.num_objects = 0
adv_core.objectTable = {}
function adv_core.register_object(object_name, lfire, lwater, learth, lair)
	--if object name is taken, Error out
	if adv_core.objectTable[object_name] ~= nil then
		minetest.log("error","Unable to add " .. object_name .. " to adventure core object list, name already taken")
		return false
	end
	
	--add to table
	adv_core.objectTable[object_name] = {
		fire = lfire,
		water = lwater,
		earth = learth,
		air = lair,	
	}
	adv_core.num_objects = adv_core.num_objects+1
	return true
end

--"fire","water","earth","air"
function adv_core.spawn_element(element_type, pos)
	if element_type == "fire" then
		minetest.add_entity(pos, "adventure_core:fire_element", nil)
	elseif element_type == "water" then
		minetest.add_entity(pos, "adventure_core:water_element", nil)
	elseif element_type == "earth" then
		minetest.add_entity(pos, "adventure_core:earth_element", nil)
	elseif element_type == "air" then
		minetest.add_entity(pos, "adventure_core:air_element", nil)
	end
end

--Credit to Unified Inventory for how to fix this:
function adv_core.escape_for_formspec(item_name)
	return string.gsub(item_name, "([^A-Za-z0-9])", function (c) return string.format("_%d_", string.byte(c)) end)
end
function adv_core.remove_formspec_escapes(item_name)
	return string.gsub(item_name, "_([0-9]+)_", function (v) return string.char(v) end)
end
