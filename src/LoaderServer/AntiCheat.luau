local AntiCheatModule = {
	code = 0,
}

local rs = game.ReplicatedStorage

local framework = require(rs.Framework)
local antiCheatRemote : RemoteEvent = framework:GetRemoteEvent("AntiCheat")


function AntiCheatModule.GenereteCode()
	local code = math.random(0, 123456)

	return code
end

task.spawn(function()
	while wait(1) do
		local code = AntiCheatModule.GenereteCode()
		if type(code) == "number" then
			AntiCheatModule.code = code
			antiCheatRemote:FireAllClients(code)
		end
	end
end)

return AntiCheatModule
