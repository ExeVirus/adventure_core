-- SPAWNING

--If default, and with biomes, spawn with biomes, otherwise randomly chosen.
--Here are the four combos:
--					|   High Heat   |   Low Heat   |
					--------------------------------
--High Humidity     |     Earth     |     Water    |
--Low Humidity		|     Fire      |      Air     |
--					--------------------------------

--Returns true on success, false on failure
local time_between = adv_core.setting("base_time_between_spawns", 80) * 1000000
local spread	   = adv_core.setting("spawn_time_spread", 15) * 1000000
local base_dist    = adv_core.setting("base_distance", 500)
local spawn_adjust = adv_core.setting("spawn_adjustment_time", 180) * 1000000
local dist_adjust  = adv_core.setting("distance_adjustment_time", 2) * 1000000
local min_time     = adv_core.setting("minimum_spawn_time", 30) * 1000000
local spawn_point  = adv_core.setting("spawn_location",{x=0,y=0,z=0})
local biome_spawns = adv_core.setting("enable_spawn_biome", true)
local spawn_dist   = adv_core.setting("distance_from_player", 12)
local default_en   = (minetest.get_modpath("default")) ~= nil
local air_id       = minetest.get_content_id("air")
local ignore_id    = minetest.get_content_id("ignore")
local init_time    = (time_between + spawn_adjust)

--Used to randomly spawn element near a player
local function spawn_element(player, with_biomes)
	
	local function biome_spawn(environment, position)
		if environment.heat > 50 then
			if environment.humidity > 50 then --Earth
				adv_core.spawn_element("earth", position)
			else --Fire
				adv_core.spawn_element("fire", position)
			end
		else
			if environment.humidity > 50 then --Water
				adv_core.spawn_element("water", position)
			else --Air
				adv_core.spawn_element("air", position)
			end
		end
	end
	
	local function random_spawn(position)
		local rand = math.random(0,3)
		if rand == 0 then
			adv_core.spawn_element("fire", position)
		elseif rand == 1 then
			adv_core.spawn_element("water", position)
		elseif rand == 2 then
			adv_core.spawn_element("earth", position)
		else 
			adv_core.spawn_element("air", position)
		end
	end

	local position = player:get_pos()
	position.x = math.floor(position.x + math.random(-spawn_dist,spawn_dist))
	position.z = math.floor(position.z + math.random(-spawn_dist,spawn_dist))
	position.y = math.floor(position.y + math.random(0 , 10))
	
	if (minetest.get_node(position).name == "air") then
		--find lowest node that's not air
		local vm         = minetest.get_voxel_manip()
		local position2 = position
		position2.y = position2.y - 2
		local emin, emax = vm:read_from_map(position, position2)
		local a = VoxelArea:new{
			MinEdge = emin,
			MaxEdge = emax, 
		}
		local data = vm:get_data()
		local stop = position.y-10
		for y = position.y, stop, -1 do
			local idx = a:index(position.x, y, position.z)
			if data[idx] ~= air_id or data[idx] == ignore_id then
				position.y = y+3
				if with_biomes then
					biome_spawn(minetest.get_biome_data(position), position)
				else
					random_spawn(position)
				end
				return true
			end				
		end
		--Didn't find the ground, spawn at low position
		position.y = position.y - 7
		if with_biomes then
			biome_spawn(minetest.get_biome_data(position), position)
		else
			random_spawn(position)
		end
		return true
	else
		return false
	end
end

local total_time = 0
minetest.register_globalstep(function(dtime)
	total_time = total_time + dtime
	if total_time > 1 then -- every second
		total_time = 0
		local new_time = minetest.get_us_time()
		for _,player in ipairs(minetest.get_connected_players()) do
			local name = player:get_player_name()
			local player_old_time = tonumber(adv_core.mod_storage:get_string(name .. "old_time")) 
			if player_old_time == nil then
				adv_core.mod_storage:set_string(name .. "old_time", new_time)
				player_old_time = new_time
			end
			local player_countdown = tonumber(adv_core.mod_storage:get_string(name .. "countdown")) or init_time
			
			if player_old_time + player_countdown < new_time then
				local spawned = nil
				if biome_spawns and default_en then
					spawned = spawn_element(player, true)
				else
					spawned = spawn_element(player, false)
				end
				if spawned then
					local countdown = time_between + math.random(-spread,spread)
					local dist = vector.distance(player:get_pos(), spawn_point)
					if dist > base_dist then
						countdown = countdown - math.floor(base_dist / 1000) * dist_adjust
					else
						countdown = countdown + spawn_adjust
					end
					adv_core.mod_storage:set_string(name .. "countdown", math.max(min_time, countdown)) --math.max(countdown, min_time) * 1000000)
				else
					minetest.chat_send_all("spawn_unsuccessful")
					adv_core.mod_storage:set_string(name .. "countdown", 2000000) -- try again in 2 seconds...
				end
				adv_core.mod_storage:set_string(name .. "old_time", new_time)
			end
		end
	end
end)

minetest.register_on_joinplayer(function(ObjectRef, last_login)
    local name = ObjectRef:get_player_name()
    if name == nil then
        return
    end
    adv_core.mod_storage:set_string(name .. "countdown", init_time)
    adv_core.mod_storage:set_string(name .. "old_time", minetest.get_us_time())  
end
)

--Do players start with a guidebook and pouch?
if adv_core.setting("enable_starting_items", true) then
	
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
	
	minetest.register_on_newplayer(
		function(player)
			give(player:get_player_name(), "adventure_core:guidebook")
			give(player:get_player_name(), "adventure_core:pouch")
		end
	)
end



