local ContentProvider = game:GetService("ContentProvider")

local callback = function(assetId, assetFetchStatus)
    print("PreloadAsync() resolved asset ID:", assetId) 
    print("PreloadAsync() final AssetFetchStatus:", assetFetchStatus)
end

ContentProvider:PreloadAsync({ "rbxasset://sounds/MapMusic/Song.mp3" },function()
    warn("Song loaded")
    MapLib:ChangeMusic("rbxasset://sounds/MapMusic/Song.mp3", 1, 0)
end)