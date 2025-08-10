local GuiTabBarModule = {
    LevelColor = {
		[5] = Color3.fromRGB(35, 171, 224),
		[15] = Color3.fromRGB(174, 69, 235),
		[25] = Color3.fromRGB(160, 34, 34),
		[40] = Color3.fromRGB(255, 224, 51)
	},
}

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local tabBarGui = playerGui:WaitForChild("TabBar")
local topFrame : Frame = tabBarGui:WaitForChild("Top")
local inventoryButton : ImageButton = topFrame:WaitForChild("InventoryButton")
local questsButton : ImageButton = topFrame:WaitForChild("QuestsButton")
local shopButton : ImageButton = topFrame:WaitForChild("ShopButton")
local playersInServerButton : ImageButton = topFrame:WaitForChild("PlayersInServerButton")
local statsButton : ImageButton = topFrame:WaitForChild("StatsButton")
local settingsButton : ImageButton = topFrame:WaitForChild("SettingsButton")
local spectateButton : ImageButton = topFrame:WaitForChild("SpectateButton")

local bottomFrame : Frame = tabBarGui:WaitForChild("Bottom")
local levelMoney : Frame = bottomFrame:WaitForChild("LevelMoney")
local barLevel : Frame = levelMoney:WaitForChild("BarLevel")
local bar : Frame = barLevel:WaitForChild("Bar")
local circleLevel : Frame = levelMoney:WaitForChild("CircleLevel")
local levelText : TextLabel = circleLevel:WaitForChild("LevelText")
local expAndExpNextLevel : TextLabel = levelMoney:WaitForChild("Exp/NextLevel")

local TweenService = game:GetService("TweenService")

player:GetAttributeChangedSignal("Exp"):Connect(function()
    GuiTabBarModule.UpdateExpAndExpNextLevel()
    GuiTabBarModule.UpdateTweenServiceBar()
end)

player:GetAttributeChangedSignal("Level"):Connect(function()
    levelText.Text = tostring(player:GetAttribute("Level"))
    GuiTabBarModule.UpdateLevelTextColor()
end)

function GuiTabBarModule.Load()
    GuiTabBarModule.UpdateExpAndExpNextLevel()
    GuiTabBarModule.UpdateTweenServiceBar()
    levelText.Text = tostring(player:GetAttribute("Level"))
    GuiTabBarModule.UpdateLevelTextColor()
end

function GuiTabBarModule.UpdateExpAndExpNextLevel()
    expAndExpNextLevel.Text = tostring(math.ceil(player:GetAttribute("Exp"))).."/"..tostring(math.ceil(player:GetAttribute("ExpNextLevel")))
end

function GuiTabBarModule.UpdateTweenServiceBar()
    TweenService:Create(bar,TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,false),{Size = UDim2.fromScale(player:GetAttribute("Exp") / player:GetAttribute("ExpNextLevel"),1)}):Play()
end

function GuiTabBarModule.UpdateLevelTextColor()
    if player:GetAttribute("Level") >= 5 and player:GetAttribute("Level") < 15 then
		levelText.TextColor3 = GuiTabBarModule.LevelColor[5]
	elseif player:GetAttribute("Level") >= 15 and player:GetAttribute("Level") < 25 then
		levelText.TextColor3 = GuiTabBarModule.LevelColor[15]
	elseif player:GetAttribute("Level") >= 25 and player:GetAttribute("Level") < 40 then
		levelText.TextColor3 = GuiTabBarModule.LevelColor[25]
	elseif player:GetAttribute("Level") >= 40 then
		levelText.TextColor3 = GuiTabBarModule.LevelColor[40]
	end
end

function GuiTabBarModule.EffectMouseEnter(button)
    local uiStroke : UIStroke = button:FindFirstChild("UIStroke")

    TweenService:Create(uiStroke,TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,false), {Color = Color3.fromRGB(255,255,255)}):Play()
end

function GuiTabBarModule.EffectMouseLeave(button)
    local uiStroke : UIStroke = button:FindFirstChild("UIStroke")

    TweenService:Create(uiStroke,TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,false), {Color = Color3.fromRGB(0,0,0)}):Play()
end


for _, buttons : ImageButton in pairs(topFrame:GetChildren()) do
    if buttons:IsA("ImageButton") then
        buttons.MouseButton1Click:Connect(function()
            print(buttons.Name)
        end)

        buttons.MouseEnter:Connect(function()
            GuiTabBarModule.EffectMouseEnter(buttons)
        end)

        buttons.MouseLeave:Connect(function()
            GuiTabBarModule.EffectMouseLeave(buttons)
        end)
    end
end

if game:IsLoaded() then
    GuiTabBarModule.Load()
end

return GuiTabBarModule