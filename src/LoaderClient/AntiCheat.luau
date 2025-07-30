local AntiCheatModule = {
	code = 0,
}
local rs = game.ReplicatedStorage

local framework = require(rs.Framework)

local remoteFolder = rs:WaitForChild("Remote")
local antiCheatRemote = remoteFolder:WaitForChild("AntiCheat")

local player = game.Players.LocalPlayer
local character = player.Character
local humanoid: Humanoid = character:WaitForChild("Humanoid")

function AntiCheatModule.GetCode(code: number)
	AntiCheatModule.code = code
	print(AntiCheatModule.code)
end

function AntiCheatModule.Ban()
	player:Kick("AntiCheat detected something unusual")
end

humanoid.Changed:Connect(function(state)
	if state == "MaxHealth" then
		AntiCheatModule.Ban()
	elseif state == "JumpHeight" then
		if humanoid.JumpHeight > 7.2 then
			AntiCheatModule.Ban()
		end
	elseif state == "UseJumpPower" then
		if humanoid.UseJumpPower == true then
			AntiCheatModule.Ban()
		end
	end
end)

framework.OnClientEvent("AntiCheat", function(code)
	AntiCheatModule.GetCode(code)
end)

return AntiCheatModule
