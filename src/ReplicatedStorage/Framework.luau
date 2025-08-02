local framework = {}

local rs = game.ReplicatedStorage
local remoteFolder = rs.Remote

function framework:GetRemoteEvent(name)
	local event = remoteFolder:FindFirstChild(name)

	if event ~= nil then
		return event
	else
		warn("Error")
	end

	return event
end

function framework:GetRemoteFunction(name)
	local func = remoteFolder:FindFirstChild(name)

	if func ~= nil then
		return func
	else
		warn("Error")
	end
end

return framework
