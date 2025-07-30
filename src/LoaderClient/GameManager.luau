local GameManagerModule = {}

local rs = game.ReplicatedStorage
local Framework = require(rs.Framework)

function GameManagerModule.UpdateTextCountDown(sec)
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    local gameGui = playerGui.Game
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


Framework.OnClientEvent("CountDown",function(sec)
    GameManagerModule.UpdateTextCountDown(sec)
end)


return GameManagerModule