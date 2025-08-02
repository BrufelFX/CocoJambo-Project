local ConsoleModule = {}

local rs = game.ReplicatedStorage
local framework = require(rs:WaitForChild("Framework"))
local antiCheat = require(script.Parent:WaitForChild("AntiCheat"))

local players = game:GetService("Players")

local adminRemote : RemoteFunction = framework:GetRemoteEvent("Admin")

adminRemote.OnServerInvoke = function(player,code,AdminType)
    if code == antiCheat.code then
        if AdminType == "kill_all" then
            for _, v : Player in pairs(players:GetPlayers()) do
                local character = v.Character or v.CharacterAdded:Wait()
                if character then
                    local humanoid = character:WaitForChild("Humanoid")
                    if humanoid.Health > 0 then
                        humanoid.Health = 0
                    end
                else
                    return
                end
            end

            return '<font color="#E8EB34">[SYSTEM] </font> Killed ALL :D'
        else
            return '<font color="#E8EB34">[SYSTEM] </font> AdminType ERROR'
        end
    else
        return '<font color="#E8EB34">[SYSTEM] </font> AntiCheat ERROR'
    end
end

return ConsoleModule