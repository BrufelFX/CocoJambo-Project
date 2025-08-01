local DataPlayer = {
	LevelColor = {
		[5] = Color3.fromRGB(35, 171, 224),
		[15] = Color3.fromRGB(174, 69, 235),
		[25] = Color3.fromRGB(160, 34, 34),
		[40] = Color3.fromRGB(255, 224, 51)
	},
}

local players = game.Players

local GameManager = require(script.Parent.GameManager)

local rs = game.ReplicatedStorage
local assets = rs:WaitForChild("Assets")

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

	player.CharacterAdded:Connect(function(char)
		local Head = char:WaitForChild("Head")

		if Head then
			local statsTag : BillboardGui = assets:WaitForChild("StatsTag"):Clone()
			local nameText : TextLabel = statsTag:WaitForChild("Name")
			local levelText : TextLabel = statsTag:WaitForChild("Level")

			if nameText and levelText then
				nameText.Text = player.Name
				levelText.Text = tostring(Level.Value)
				statsTag.Parent = Head

				if DataPlayer.LevelColor[Level.Value] then
					levelText.TextColor3 = DataPlayer.LevelColor[Level.Value]
				end
			end

			Level.Changed:Connect(function()
				if DataPlayer.LevelColor[Level.Value] then
					levelText.TextColor3 = DataPlayer.LevelColor[Level.Value]
				end
				levelText.Text = tostring(Level.Value)
			end)
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
