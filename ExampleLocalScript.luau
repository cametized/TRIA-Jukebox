require(game:GetService("ServerScriptService").Runtime):Init()

local MapLib = game.GetMapLib:Invoke()()
local map = MapLib.map

local MusicModule = require(script:FindFirstChild("JukeboxMod"))
MusicModule.Init(MapLib)

MusicModule.RegisterTrack("ThunderStyle",{ -- Register local file
    asset = "rbxasset://sounds/MapMusic/ThunderStyle.mp3",
    priority = 10,
    volume = 1,
    startPosition = 0,
    
    fallback = { -- If local file doesn't work, falls back to this audio id.
        asset = "rbxassetid://9818458459",
        volume = 1,
        startPosition = 5
    }
})

MusicModule.RegisterTrack("Testy",{ -- Test
    asset = "rbxassetid://122954797407214", -- "Steampianist - Through the Looking Glass"
    priority = 1,
    volume = 1
})

MusicModule.Play("Testy")
task.wait(.25)
MusicModule.Play("ThunderStyle") -- Override the "Testy" Track