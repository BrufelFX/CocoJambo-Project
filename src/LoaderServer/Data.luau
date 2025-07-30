local DataPlayer = {}

local players = game.Players

local GameManager = require(script.Parent.GameManager)

players.PlayerAdded:Connect(function(player)
	local Data = Instance.new("Folder", player)
	Data.Name = "Data"

	local Team = Instance.new("StringValue", Data)
	Team.Name = "Team"
	Team.Value = "None"

	local Cash = Instance.new("NumberValue",Data)
	Cash.Name = "Cash"
	Cash.Value = 100

	local Level = Instance.new("NumberValue",Data)
	Level.Name = "Level"
	Level.Value = 1

	local Exp = Instance.new("NumberValue",Data)
	Exp.Name = "Exp"
	Exp.Value = 0

	local ExpNextLevel = Instance.new("NumberValue",Data)
	ExpNextLevel.Name = "ExpNextLevel"
	ExpNextLevel.Value = 100

	Exp.Changed:Connect(function(value)
		if Exp.Value >= ExpNextLevel.Value then
			DataPlayer.NextLevel(player)
		end
	end)
end)

function DataPlayer.NextLevel(player)
	local data : Folder = player.Data
	local Exp : NumberValue = data.Exp
	local ExpNextLevel : NumberValue = data.ExpNextLevel
	local Level : NumberValue = data.Level

	Exp.Value = 0
	ExpNextLevel.Value *= 2
	Level.Value += 1
end

GameManager.Countdown(30,"Start")

return DataPlayer
