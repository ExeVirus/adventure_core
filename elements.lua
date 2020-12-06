-- ELEMENTS

local function create_particles(pos, element_type)
	local particle_spawn_def = {
		amount = adv_core.setting("element_lifetime", 60) * 4,
		time = adv_core.setting("element_lifetime", 60),
		minpos = pos,
		maxpos = pos,
		minvel = {x=-0.15,y=-0.15 ,  z=-0.15},
		maxvel = {x=0.15, y=0.15 ,  z=0.15 },
		minacc = {x=0, y=0,  z=0 },
		maxacc = {x=0, y=0,z=0 },
		minexptime = 1.8,
		maxexptime = 1.8,
		minsize = 0.2,
		maxsize = 0.5,
		texture = "fire.png",
		glow = 2,
	}
	
	if element_type == "fire" then
		particle_spawn_def.texture = "fire.png"
		return minetest.add_particlespawner(particle_spawn_def)
	elseif element_type == "water" then
		particle_spawn_def.texture = "water.png"
		return minetest.add_particlespawner(particle_spawn_def)
	elseif element_type == "earth" then
		particle_spawn_def.texture = "earth.png"
		return minetest.add_particlespawner(particle_spawn_def)
	elseif element_type == "air" then
		particle_spawn_def.texture = "air.png"
		return minetest.add_particlespawner(particle_spawn_def)
	end
end

local function reward_player(player_name, element_type)
	if player_name ~= "" then
		--load player pouch
		local player_pouch = minetest.deserialize(adv_core.mod_storage:get_string(player_name))
		
		--init, if nil
		if player_pouch == nil then
			player_pouch = {
				fire  = 0,
				water = 0,
				earth = 0,
				air   = 0,
			}
		end
		
		--increment element value
		if element_type == "fire" then
			player_pouch.fire = player_pouch.fire + 1
			minetest.chat_send_player(player_name, 
				minetest.get_color_escape_sequence("red") .. "Fire: "    .. player_pouch.fire)
		elseif element_type == "water" then
			player_pouch.water = player_pouch.water + 1
			minetest.chat_send_player(player_name, 
				minetest.get_color_escape_sequence("blue") .. "  Water: " .. player_pouch.water)
		elseif element_type == "earth" then
			player_pouch.earth = player_pouch.earth + 1
			minetest.chat_send_player(player_name, 
				minetest.get_color_escape_sequence("green") .. "  Earth: " .. player_pouch.earth)
		elseif element_type == "air" then
			player_pouch.air = player_pouch.air + 1
			minetest.chat_send_player(player_name, 
				minetest.get_color_escape_sequence("yellow") .. "  Air: "   .. player_pouch.air)
		end
		
		if adv_core.setting("enable_element_sounds", true) then
			minetest.sound_play("adv_core_capture", {to_player = player_name, gain=0.5})
		end
		
		--store it back
		adv_core.mod_storage:set_string(player_name, minetest.serialize(player_pouch))
	end
end

-- Register fire
local fire_element_def = {
	initial_properties = {
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.2,-0.2,-0.2,0.2,0.2,0.2},
		visual = "sprite",
		visual_size = {x = 0.4, y = 0.4, z = 0.4},
		textures = { "fire.png"},
		use_texture_alpa = false,
		glow = 5,
		infotext = "fire",
		static_save = false,
	},
	--custom property
	lifetime = nil,
	sound = nil,
	particles = nil,
	
	on_activate = function(self,staticdata, dtime_s)
		if adv_core.setting("enable_element_particles", true) then
			self.particles = create_particles(self.object:get_pos(), "fire")
		end
		if adv_core.setting("enable_element_sounds", true) then
			self.sound = minetest.sound_play("adv_core_spawn_sound", {object = self.object, gain=0.5, max_hear_distance=80, loop = false})
		end
		self.lifetime = minetest.get_us_time() + adv_core.setting("element_lifetime", 60)*1000000
	end,
	
	on_step = function(self,dtime,moveresult)
		if minetest.get_us_time() > self.lifetime then
			self.object:remove()
			if adv_core.setting("enable_element_particles", true) then
				minetest.delete_particlespawner(self.particles)
			end
			if adv_core.setting("enable_element_sounds", true) then
				minetest.sound_stop(self.sound)
			end
		end
	end,
	
	on_rightclick = function(self, clicker)
		reward_player(clicker:get_player_name(), "fire")
		self.object:remove()
		if adv_core.setting("enable_element_particles", true) then
			minetest.delete_particlespawner(self.particles)
		end
		if adv_core.setting("enable_element_sounds", true) then
			minetest.sound_stop(self.sound)
		end
	end,
	
	on_punch = function(self, puncher)
		reward_player(puncher:get_player_name(), "fire")
		self.object:remove()
		if adv_core.setting("enable_element_particles", true) then
			minetest.delete_particlespawner(self.particles)
		end
		if adv_core.setting("enable_element_sounds", true) then
			minetest.sound_stop(self.sound)
		end
	end,
}
minetest.register_entity("adventure_core:fire_element", fire_element_def)

--Register water
local water_element_def = {
	initial_properties = {
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.2,-0.2,-0.2,0.2,0.2,0.2},
		visual = "sprite",
		visual_size = {x = 0.4, y = 0.4, z = 0.4},
		textures = { "water.png"},
		use_texture_alpa = false,
		glow = 5,
		infotext = "water",
		static_save = false,
	},
	--custom property
	lifetime = nil,
	sound = nil,
	particles = nil,
	
	on_activate = function(self,staticdata, dtime_s)
		if adv_core.setting("enable_element_particles", true) then
			self.particles = create_particles(self.object:get_pos(), "water")
		end
		if adv_core.setting("enable_element_sounds", true) then
			self.sound = minetest.sound_play("adv_core_spawn_sound", {object = self.object, gain=0.5, max_hear_distance=80, loop = false})
		end
		self.lifetime = minetest.get_us_time() + adv_core.setting("element_lifetime", 60)*1000000
	end,
	
	on_step = function(self,dtime,moveresult)
		if minetest.get_us_time() > self.lifetime then
			self.object:remove()
			if adv_core.setting("enable_element_particles", true) then
				minetest.delete_particlespawner(self.particles)
			end
			if adv_core.setting("enable_element_sounds", true) then
				minetest.sound_stop(self.sound)
			end
		end
	end,
	
	on_rightclick = function(self, clicker)
		reward_player(clicker:get_player_name(), "water")
		self.object:remove()
		if adv_core.setting("enable_element_particles", true) then
			minetest.delete_particlespawner(self.particles)
		end
		if adv_core.setting("enable_element_sounds", true) then
			minetest.sound_stop(self.sound)
		end
	end,
	
	on_punch = function(self, puncher)
		reward_player(puncher:get_player_name(), "water")
		self.object:remove()
		if adv_core.setting("enable_element_particles", true) then
			minetest.delete_particlespawner(self.particles)
		end
		if adv_core.setting("enable_element_sounds", true) then
			minetest.sound_stop(self.sound)
		end
	end,
}
minetest.register_entity("adventure_core:water_element", water_element_def)

--Register earth
local earth_element_def = {
	initial_properties = {
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.2,-0.2,-0.2,0.2,0.2,0.2},
		visual = "sprite",
		visual_size = {x = 0.4, y = 0.4, z = 0.4},
		textures = { "earth.png"},
		use_texture_alpa = false,
		glow = 5,
		infotext = "earth",
		static_save = false,
	},
	--custom property
	lifetime = nil,
	sound = nil,
	particles = nil,
	
	on_activate = function(self,staticdata, dtime_s)
		if adv_core.setting("enable_element_particles", true) then
			self.particles = create_particles(self.object:get_pos(), "earth")
		end
		if adv_core.setting("enable_element_sounds", true) then
			self.sound = minetest.sound_play("adv_core_spawn_sound", {object = self.object, gain=0.5, max_hear_distance=80, loop = false})
		end
		self.lifetime = minetest.get_us_time() + adv_core.setting("element_lifetime", 60)*1000000
	end,
	
	on_step = function(self,dtime,moveresult)
		if minetest.get_us_time() > self.lifetime then
			self.object:remove()
			if adv_core.setting("enable_element_particles", true) then
				minetest.delete_particlespawner(self.particles)
			end
			if adv_core.setting("enable_element_sounds", true) then
				minetest.sound_stop(self.sound)
			end
		end
	end,
	
	on_rightclick = function(self, clicker)
		reward_player(clicker:get_player_name(), "earth")
		self.object:remove()
		if adv_core.setting("enable_element_particles", true) then
			minetest.delete_particlespawner(self.particles)
		end
		if adv_core.setting("enable_element_sounds", true) then
			minetest.sound_stop(self.sound)
		end
	end,
	
	on_punch = function(self, puncher)
		reward_player(puncher:get_player_name(), "earth")
		self.object:remove()
		if adv_core.setting("enable_element_particles", true) then
			minetest.delete_particlespawner(self.particles)
		end
		if adv_core.setting("enable_element_sounds", true) then
			minetest.sound_stop(self.sound)
		end
		return true
	end,
}
minetest.register_entity("adventure_core:earth_element", earth_element_def)

--Register air
local air_element_def = {
	initial_properties = {
		physical = true,
		collide_with_objects = false,
		collisionbox = {-0.2,-0.2,-0.2,0.2,0.2,0.2},
		visual = "sprite",
		visual_size = {x = 0.4, y = 0.4, z = 0.4},
		textures = { "air.png"},
		use_texture_alpa = false,
		glow = 5,
		infotext = "air",
		static_save = false,
	},
	--custom property
	lifetime = nil,
	sound = nil,
	particles = nil,
	
	on_activate = function(self,staticdata, dtime_s)
		if adv_core.setting("enable_element_particles", true) then
			self.particles = create_particles(self.object:get_pos(), "air")
		end
		if adv_core.setting("enable_element_sounds", true) then
			self.sound = minetest.sound_play("adv_core_spawn_sound", {object = self.object, gain=0.5, max_hear_distance=80, loop = false})
		end
		self.lifetime = minetest.get_us_time() + adv_core.setting("element_lifetime", 60)*1000000
	end,
	
	on_step = function(self,dtime,moveresult)
		if minetest.get_us_time() > self.lifetime then
			self.object:remove()
			if adv_core.setting("enable_element_particles", true) then
				minetest.delete_particlespawner(self.particles)
			end
			if adv_core.setting("enable_element_sounds", true) then
				minetest.sound_stop(self.sound)
			end
		end
	end,
	
	on_rightclick = function(self, clicker)
		reward_player(clicker:get_player_name(), "air")
		self.object:remove()
		if adv_core.setting("enable_element_particles", true) then
			minetest.delete_particlespawner(self.particles)
		end
		if adv_core.setting("enable_element_sounds", true) then
			minetest.sound_stop(self.sound)
		end
	end,
	
	on_punch = function(self, puncher)
		reward_player(puncher:get_player_name(), "air")
		self.object:remove()
		if adv_core.setting("enable_element_particles", true) then
			minetest.delete_particlespawner(self.particles)
		end
		if adv_core.setting("enable_element_sounds", true) then
			minetest.sound_stop(self.sound)
		end
	end,
}
minetest.register_entity("adventure_core:air_element", air_element_def)
	
	