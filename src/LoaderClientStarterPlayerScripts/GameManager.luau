local GameManagerModule = {}

local rs = game.ReplicatedStorage
local framework = require(rs.Modules.Framework)
local countDownRemote : RemoteEvent = framework:GetRemoteEvent("CountDown")

function GameManagerModule.UpdateTextCountDown(sec)
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local gameGui = playerGui:WaitForChild("Game")
    local folderCountDown = gameGui:WaitForChild("Countdown")
    local textCount : TextLabel = folderCountDown:WaitForChild("Count")
    textCount.Text = tostring(sec)

    if sec == 0 then
        task.wait(1)
        textCount.Visible = false
    else
        textCount.Visible = true
    end
end

countDownRemote.OnClientEvent:Connect(function(sec)
    GameManagerModule.UpdateTextCountDown(sec)
end)


return GameManagerModule