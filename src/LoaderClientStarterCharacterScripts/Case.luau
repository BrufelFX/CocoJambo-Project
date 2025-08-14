local CaseModule = {
    Opening = false,
    connecting = false,
}

local player = game.Players.LocalPlayer
local rs = game.ReplicatedStorage
local assets = rs:WaitForChild("Assets")
local caseFolder = assets:WaitForChild("Cases")

local runService = game:GetService("RunService")

local caseDropModule = require(rs.Modules.CaseDrop)
local framework = require(rs.Modules.Framework)

function CaseModule:Create(caseType : string, casePrice : number)
    local case = self:Get(caseType)
    local OpeningCase : RemoteFunction = framework:GetRemoteFunction("OpenCase")
    if case then
        if CaseModule.Opening == false then
            if player:GetAttribute("Cash") >= casePrice then
                CaseModule.Opening = true
                case.Parent = workspace
                local result = OpeningCase:InvokeServer(casePrice)
                if result then
                    self:Camera(case)
                else
                    CaseModule.Opening = false
                    case:Destroy()
                    print("Nie masz pieniędzy")
                end
            end
        end
    end
end

function CaseModule:Get(caseType : string)
    for _, case : Model in pairs(caseFolder:GetChildren()) do
        if case:IsA("Model") then
            if case:GetAttribute("CaseType",caseType) then
                return case
            end
        end
    end
end

function CaseModule:Camera(Case : Model)
    local cameraCase : Model = Case:FindFirstChild("Cam")
    local cameraPoint : Part = cameraCase:FindFirstChild("CamPart"):WaitForChild("Point")
    local cameraPlayer = game.Workspace.CurrentCamera

    if CaseModule.connecting ~= nil then
        CaseModule.connecting = nil
    end

    cameraPlayer.CameraType = Enum.CameraType.Scriptable

    CaseModule.connecting = runService.RenderStepped:Connect(function(deltaTime)
        cameraPlayer.CFrame = cameraPoint.CFrame
    end)

    self:Animate(Case,cameraCase)
end

function CaseModule:Animate(case : Model, caseCam : Model)
    ---- TUTAJ BEDZIE ANIMACJA SKRZYNKI I CAMERY :D
end

---TEST

local us = game:GetService("UserInputService")

us.InputBegan:Connect(function(input, gameProcessedEvent)
    if input.KeyCode == Enum.KeyCode.F then
        CaseModule:Create("Common",100)
    end
end)

return CaseModule