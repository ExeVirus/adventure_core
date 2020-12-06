--  __  ____  _  _ ____ __ _ ____ _  _ ____ ____     ___ __ ____ ____ 
-- / _\(    \/ )( (  __|  ( (_  _) )( (  _ (  __)   / __)  (  _ (  __)
--/    \) D (\ \/ /) _)/    / )( ) \/ ()   /) _)   ( (_(  O )   /) _) 
--\_/\_(____/ \__/(____)_)__)(__)\____(__\_|____)   \___)__(__\_|____)
--
-- Core Mod by ExeVirus
-- Font used in title: Graceful
--
-- See https://github.com/ExeVirus/adventure_core/wiki for more information

adv_core={} --contains all functions and global variables

-- Settings
dofile(minetest.get_modpath("adventure_core").."/settings.lua")

-- API for this and other mods
-- (reward player with elements, pay with elements, register nodes to purchase for shop, etc.)
dofile(minetest.get_modpath("adventure_core").."/api.lua")

-- Formspecs (guide,store,pouch)
dofile(minetest.get_modpath("adventure_core").."/formspecs.lua")

-- Register the 4 Elements, Built-in Nodes
dofile(minetest.get_modpath("adventure_core").."/register.lua")

-- Spawning, including player spawning items
dofile(minetest.get_modpath("adventure_core").."/spawning.lua")

-- Chat Commands
dofile(minetest.get_modpath("adventure_core").."/chat_commands.lua")



