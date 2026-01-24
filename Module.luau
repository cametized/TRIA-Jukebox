require(game:GetService("ServerScriptService").Runtime):Init()

local MapLib = game.GetMapLib:Invoke()()
local map = MapLib.map

local LogService = game:GetService("LogService")

local MusicModule = {}

local tracks = {}
local currentTrack = nil
local currentPriority = -math.huge
local connected = false

function MusicModule.Init(_mapLib)
	assert(_mapLib, "MusicModule.Init requires MapLib")
	mapLib = _mapLib

	if connected then return end
	connected = true

	LogService.MessageOut:Connect(function(message, messageType)
		if messageType ~= Enum.MessageType.MessageError then
			return
		end

		if currentTrack and message:find(currentTrack.asset) then
			local fallback = currentTrack.fallback
			if fallback then
				mapLib:ChangeMusic(
					fallback.asset,
					fallback.volume or 1,
					fallback.startPosition or 0
				)
			end
		end
	end)
end

function MusicModule.RegisterTrack(name, config)
	assert(name, "Track name required")
	assert(config.asset, "Track asset required")

	tracks[name] = {
		asset = config.asset,
		priority = config.priority or 0,
		volume = config.volume or 1,
		startPosition = config.startPosition or 0,
		fallback = config.fallback
	}
end

function MusicModule.Play(name)
	local track = tracks[name]
	if not track then
		warn("MusicModule: Unknown track:", name)
		return
	end

	if track.priority < currentPriority then
		return
	end

	currentTrack = track
	currentPriority = track.priority

	mapLib:ChangeMusic(
		track.asset,
		track.volume,
		track.startPosition
	)
end

function MusicModule.ForcePlay(name)
	local track = tracks[name]
	if not track then return end

	currentTrack = track
	currentPriority = track.priority

	mapLib:ChangeMusic(
		track.asset,
		track.volume,
		track.startPosition
	)
end

function MusicModule.Clear()
	currentTrack = nil
	currentPriority = -math.huge
end

return MusicModule