local CaseModule = {}

local rs = game.ReplicatedStorage
local framework = require(rs.Modules.Framework)
local OpeningCase : RemoteFunction = framework:GetRemoteFunction("OpenCase")


OpeningCase.OnServerInvoke = function(player,casePrice)
    local cash = player:GetAttribute("Cash")
    if cash >= casePrice then
        player:SetAttribute("ActionCase", true)
        cash -= casePrice
    end

    return true
end

return CaseModule