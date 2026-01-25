require(game:GetService("ServerScriptService").Runtime):Init()

--^^Must be at the top of every script

local MapLib = game.GetMapLib:Invoke()()
local map = MapLib.map

local Jukebox = require(script:FindFirstChild("JukeboxMod"))

Jukebox.Add(
	"Music", -- name
	"rbxasset://sounds/MapMusic/ThunderStyle.mp3", -- local file
	10, -- priority, higher the better
	1, -- volume
	0, -- startpos
{
id = 122954797407214, -- fallback asset id
volume = 1
}
)

Jukebox.Init(MapLib)
Jukebox.Play("Music")
