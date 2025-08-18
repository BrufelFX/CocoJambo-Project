local GuiEffectModule = {
    Blur = {
        Size = 15
    },
    Fov = {
        ZoomIn = 60,
        ZoomOut = 70,
    },
}

local lighting = game.Lighting
local tweenService = game:GetService("TweenService")
local currentZoom = nil

function GuiEffectModule:Create_Blur()
    if lighting:FindFirstChild("BlurUi") then
        return
    end

    local blurUi = Instance.new("BlurEffect")
    blurUi.Name = "BlurUi"
    blurUi.Size = GuiEffectModule.Blur.Size
    blurUi.Parent = lighting
end

function GuiEffectModule:Create_FovZoomIn()
    if currentZoom ~= "ZoomIn" then
        currentZoom = "ZoomIn"
        local camera = game.Workspace.CurrentCamera
        local tween = tweenService:Create(camera,TweenInfo.new(0.12,Enum.EasingStyle.Sine,Enum.EasingDirection.In),{FieldOfView = GuiEffectModule.Fov.ZoomIn})
        tween:Play()
    end
end

function GuiEffectModule:Create_FovZoomOut()
    if currentZoom ~= "ZoomOut" then
        currentZoom = "ZoomOut"
        local camera = game.Workspace.CurrentCamera
        local tween = tweenService:Create(camera,TweenInfo.new(0.12,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{FieldOfView = GuiEffectModule.Fov.ZoomOut})

        tween:Play()
    end
end

function GuiEffectModule:Delete_Blur()
    if lighting:FindFirstChild("BlurUi") then
        lighting:FindFirstChild("BlurUi"):Destroy()
    end
end


return GuiEffectModule