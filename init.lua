--   __  ____  _  _ ____ __ _ ____ _  _ ____ ____     ___ __ ____ ____ 
--  / _\(    \/ )( (  __|  ( (_  _) )( (  _ (  __)   / __)  (  _ (  __)
-- /    \) D (\ \/ /) _)/    / )( ) \/ ()   /) _)   ( (_(  O )   /) _) 
-- \_/\_(____/ \__/(____)_)__)(__)\____(__\_|____)   \___)__(__\_|____)
--
-- Aventure Core Mod by ExeVirus
-- Font used in title: Graceful
--

adv_core={} --contains all functions and global variables
adv_core.mod_storage = minetest.get_mod_storage()

-- Settings   98% DONE
dofile(minetest.get_modpath("adventure_core").."/settings.lua")

-- Register the element entities   DONE
dofile(minetest.get_modpath("adventure_core").."/elements.lua")

-- API for this and other mods  DONE
-- (reward player with elements, pay with elements, **register nodes to purchase in shop**, etc.)
dofile(minetest.get_modpath("adventure_core").."/api.lua")

-- Formspecs (guide,store,pouch)  DONE
dofile(minetest.get_modpath("adventure_core").."/formspecs.lua")

-- Register the Built-in Nodes  DONE
dofile(minetest.get_modpath("adventure_core").."/register.lua")

-- Spawning, including player spawning items  85% DONE
dofile(minetest.get_modpath("adventure_core").."/spawning.lua")

-- Chat Commands  DONE
dofile(minetest.get_modpath("adventure_core").."/chat_commands.lua")



