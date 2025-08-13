local Inventory3DModelModule = {}
local rs = game:GetService("ReplicatedStorage")
local assets = rs:WaitForChild("Assets")

-- TRZEBA DOKONCZYC I ULEPSZYC ALE TO DOPIERO PO SKONCZENIU INVENTORY :D

function Inventory3DModelModule:Import(modelString : string)
    local model = self:GetModel(modelString)

    if model and model ~= nil then
        local player = game.Players.LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui")
        local testGui = playerGui:WaitForChild("test") -- Nie ISTNIEJE
        local viewportFrame : ViewportFrame = testGui:WaitForChild("ViewportFrame") -- Nie ISTNIEJE

        local camera = Instance.new("Camera")
        camera.FieldOfView = 70
        viewportFrame.CurrentCamera = camera

        model:Clone().Parent = viewportFrame
    end
end


function Inventory3DModelModule:GetModel(modelString : string)
    return assets:FindFirstChild(modelString) or error("Model not found: " .. modelString)
end

return Inventory3DModelModule