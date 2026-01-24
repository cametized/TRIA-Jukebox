local LocalFile = "rbxasset://sounds/MapMusic/ThunderStyle.mp3"

MapLib:ChangeMusic(mashup)

game:GetService("LogService").MessageOut:Connect(function(message, messageType)
	if messageType == Enum.MessageType.MessageError and message:find(LocalFile) then
		MapLib:ChangeMusic("rbxassetid://9818458459",1,5) -- Regular Song
	end
end)