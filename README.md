# adventure_core WIP
A Minetest Core Adventure Mod 

Explainations are better left for the mod:

![In-Game Guidebook](readme_assets/guidebook.jpg)

### Quick description:

- 4 Elements, each are a floating entity in game world, physicaly interact.
- These spawn as player walks throughout world. More spawn on newly generated chunks, especially farther from spawn. 
- They spawn by biome in default. Otherwise, they spawn anywhere. They are right-clicked to capture. 
- They also make sound, this is how you normally find them. They produce a small amount of light. 

Used in a crafting shop kind of block. It lets a player search by name.
The player then is able to "buy" that node using the stacked elements (which are tracked by player).

All players can (setting) start with the guidebook, and pouch. One explains the system, the other displays the current total number of elements a player has.

------Default

In default, the player crafts the adventure_shop via normal crafting. This can also be disabled via setting, and a server owner can decide where to place the shop(s) via creative mode. 
In default, the player can also craft the adventure_guidebook, and adventure_purse. 

--------

Without default, the player can do a command to bring up the formspec for both purse and guidebook:
/adventure_guidebook
/adventure_purse

Without default, the shop can be crafted with the /make_shop command, which requires 10 of each element to create. 

--------
For both, when a player captures one element, the player gets a small text dialog showing them how much of element they have captured.

Adventure core ships with some built-in nodes a player can craft. 

Built-in ones, 6 static mesh nodes:
1. A small bridge
2. Bozai Tree
3. Rune thing from adventure_pack
4. Bonfire
5. Castle Flag
6. Axe Stump

------
Adventure core works by a player registering a node_name and element requirement, The node inventory image from the node_def/item_def is used as the picture, except for nodes with a mesh drawtype, these are displayed with a viewable mesh!





