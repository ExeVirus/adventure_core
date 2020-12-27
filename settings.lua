-- SETTINGS
function adv_core.setting(setting, default)
	if type(default) == "boolean" then
		local read = minetest.settings:get_bool("adventure_core."..setting)
		if read == nil then
			return default
		else
			return read
		end
	elseif type(default) == "string" then
		return tostring(minetest.settings:get("adventure_core."..setting)) or default
	elseif type(default) == "number" then
		return tonumber(minetest.settings:get("adventure_core."..setting) or default)
	elseif type(default) == "table" then
		return minetest.settings:get("adventure_core."..setting) or default
	end
end
