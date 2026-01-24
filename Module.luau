require(game:GetService("ServerScriptService").Runtime):Init()
-- ^^ Must be at the top of every script

local ContentProvider = game:GetService("ContentProvider")
local LogService = game:GetService("LogService")

local Jukebox = {}

local tracks = {}
local current
local currentPriority = -math.huge
local MapLib
local hooked = false
local preloaded = false
local fallback = false

local function resolveSoundId(id)
	if typeof(id) == "string" then
		return id
	end
	return "rbxassetid://" .. id
end

function Jukebox.Preload()
	if preloaded then return end
	preloaded = true

	local assets = {}

	for _, t in pairs(tracks) do
		if typeof(t.id) == "number" then
			table.insert(assets, "rbxassetid://" .. t.id)
		end

		if t.fallback and typeof(t.fallback.id) == "number" then
			table.insert(assets, "rbxassetid://" .. t.fallback.id)
		end
	end

	if #assets > 0 then
		task.spawn(function()
			pcall(function()
				ContentProvider:PreloadAsync(assets)
			end)
		end)
	end
end

function Jukebox.Init(mapLib)
	MapLib = mapLib
	if hooked then return end
	hooked = true

	Jukebox.Preload()

	LogService.MessageOut:Connect(function(msg, msgType)
		if msgType ~= Enum.MessageType.MessageError then return end
		if not current or not current.fallback then return end
		if fallback then return end

		if typeof(current.id) ~= "string" then return end

		if not string.find(msg, current.id, 1, true) then return end

		fallback = true

		local f = current.fallback
		MapLib:ChangeMusic(
			resolveSoundId(f.id),
			f.volume or 1,
			f.start or 0
		)
	end)

end

function Jukebox.Add(name, id, priority, volume, start, fallback)
	tracks[name] = {
		id = id,
		priority = priority or 0,
		volume = volume or 1,
		start = start or 0,
		fallback = fallback
	}
end

function Jukebox.Play(name)
	local t = tracks[name]
	if not t or t.priority < currentPriority then return end

	current = t
	currentPriority = t.priority
	fallback = false

	MapLib:ChangeMusic(
		resolveSoundId(t.id),
		t.volume,
		t.start
	)
end

function Jukebox.Force(name)
	local t = tracks[name]
	if not t then return end

	current = t
	currentPriority = t.priority
	fallback = false

	MapLib:ChangeMusic(
		resolveSoundId(t.id),
		t.volume,
		t.start
	)
end

return Jukebox
