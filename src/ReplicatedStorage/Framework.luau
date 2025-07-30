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

-----

function framework.OnInvokeServer(name, callback)
	local func: RemoteFunction = framework:GetRemoteFunction(name)
	func.OnServerInvoke = callback
end

function framework.OnServerEvent(name, ...)
	local event: RemoteEvent = framework:GetRemoteEvent(name)
	event.OnServerEvent:Connect(...)
end

function framework.InvokeServer(name, ...)
	local func: RemoteFunction = framework:GetRemoteFunction(name)
	return func:InvokeServer(...)
end

function framework.FireServer(name, ...)
	local event: RemoteEvent = framework:GetRemoteEvent(name)
	return event:FireServer(...)
end

---------------

function framework.OnInvokeClient(name, callback)
	local func: RemoteFunction = framework:GetRemoteFunction(name)
	func.OnClientInvoke = callback
end

function framework.OnClientEvent(name, callback)
	local event = framework:GetRemoteEvent(name)
	event.OnClientEvent:Connect(callback)
end

function framework.InvokeClient(name, ...)
	local func: RemoteFunction = framework:GetRemoteFunction(name)
	return func:InvokeClient(...)
end

function framework.FireClient(name, ...)
	local event: RemoteEvent = framework:GetRemoteEvent(name)
	return event:FireClient(...)
end

function framework.FireAllClients(name, ...)
	local event: RemoteEvent = framework:GetRemoteEvent(name)
	return event:FireAllClients(...)
end

return framework
