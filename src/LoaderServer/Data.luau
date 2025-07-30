local DataPlayer = {}

local players = game.Players

local GameManager = require(script.Parent.GameManager)

players.PlayerAdded:Connect(function(player)
	local Data = Instance.new("Folder", player)
	Data.Name = "Data"

	local Team = Instance.new("StringValue", Data)
	Team.Name = "Team"
	Team.Value = "None"
end)


wait(10)
GameManager.Start()

return DataPlayer
