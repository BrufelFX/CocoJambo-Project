local AntiCheatModule = {
	code = 0,
}

local rs = game.ReplicatedStorage
local remoteFolder = rs:WaitForChild("Remote")
local antiCheatRemote = remoteFolder:WaitForChild("AntiCheat")

local framework = require(rs.Framework)

function AntiCheatModule.GenereteCode()
	local code = math.random(0, 123456)

	return code
end

task.spawn(function()
	while wait(1) do
		local code = AntiCheatModule.GenereteCode()
		if type(code) == "number" then
			AntiCheatModule.code = code
			framework.FireAllClients("AntiCheat", code)
		end
	end
end)

return AntiCheatModule
