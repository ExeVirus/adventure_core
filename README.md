# adventure_core
A Minetest Core Adventure Modpack


### Quick description:

- 4 Elements, each are a floating entity in game world, physicaly interact.
- These spawn as player walks thourghout world. More spawn on newly generated chunks, especially farther from spawn. 
- They spawn by biome in default. Otherwise, they spawn anywhere. They are right-clicked to capture. 
- They also make sound, this is how you normally find them. They produce a small amount of light. 

Used in a crafting shop kind of block. It lets a player search by mod-pack the node (mesh) came from, by name, or all packages.
The player then is able to "buy" that node using the stacked elements (which are tracked by player).

All players start with the adventure_guidebook, and adventure_purse. One explains the system, the other displays the current total number of elements you have.

------Default

In default, the player crafts the adventure_shop via normal crafting. This can also be disabled via setting, and a server owner can decide where to place the shop(s) via creative mode. 
In default, the player can also craft the adventure_guidebook, and adventure_purse. 

--------

Without default, the player can do a command to bring up the formspec for both purse and guidebook:
/adventure_guidebook
/adventure_purse

Without default, the shop can be crafted with the /make_shop command, which requires 10 of each element to create. 

--------

For both, when a player captures one element, the player gets a small text dialog showing them how much of element they have captured. Without default, they are told to type /adv_guide to learn more. 

Adventure core ships with some built-in nodes a player can craft. 

If default is enabled:
They can craft the different food and tree seeds.

Built-in ones, 6 static mesh nodes:
1. A small bridge
2. Bozai Tree
3. Rune thing from adventure_pack
4. Bonfire
5. Lampost
6. Axe Stump

------

Adventure core works by a player registering a node_name and recipe requirement, The node inventory image from the node_def is used as the picture.





