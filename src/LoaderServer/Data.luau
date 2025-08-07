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

players.PlayerAdded:Connect(function(player : Player)
	local Data = Instance.new("Folder", player)
	Data.Name = "Data"

	player:SetAttribute("Team","None")
	player:SetAttribute("Cash",100)
	player:SetAttribute("Level",1)
	player:SetAttribute("Exp",0)
	player:SetAttribute("ExpNextLevel",100)

	player:GetAttributeChangedSignal("Exp"):Connect(function()
		if player:GetAttribute("Exp") >= player:GetAttribute("ExpNextLevel") then
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
				levelText.Text = tostring(player:GetAttribute("Level"))
				statsTag.Parent = Head
				if player:GetAttribute("Level") >= 5 and player:GetAttribute("Level") < 15 then
					levelText.TextColor3 = DataPlayer.LevelColor[5]
				elseif player:GetAttribute("Level") >= 15 and player:GetAttribute("Level") < 25 then
					levelText.TextColor3 = DataPlayer.LevelColor[15]
				elseif player:GetAttribute("Level") >= 25 and player:GetAttribute("Level") < 40 then
					levelText.TextColor3 = DataPlayer.LevelColor[25]
				elseif player:GetAttribute("Level") >= 40 then
					levelText.TextColor3 = DataPlayer.LevelColor[40]
				end
			end

			player:GetAttributeChangedSignal("Level"):Connect(function()
				if DataPlayer.LevelColor[player:GetAttribute("Level")] then
					levelText.TextColor3 = DataPlayer.LevelColor[player:GetAttribute("Level")]
				end
				levelText.Text = tostring(player:GetAttribute("Level"))
			end)
		end
	end)
end)

function DataPlayer.NextLevel(player)
	player:SetAttribute("Exp",0)
	player:SetAttribute("ExpNextLevel",player:GetAttribute("ExpNextLevel") * 1.2)
	player:SetAttribute("Level",player:GetAttribute("Level") + 1) 
end

GameManager.Countdown(30,"Start")

return DataPlayer
