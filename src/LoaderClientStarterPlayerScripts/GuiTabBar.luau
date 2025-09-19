local GuiTabBarModule = {
    LevelColor = {
		[5] = Color3.fromRGB(35, 171, 224),
		[15] = Color3.fromRGB(174, 69, 235),
		[25] = Color3.fromRGB(160, 34, 34),
		[40] = Color3.fromRGB(255, 224, 51)
	},
    lastCash = 0,
    thread = nil,
    currentCategory = nil,
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
local cashFrame : Frame = levelMoney:WaitForChild("CashFrame")
local cashCount : TextLabel = cashFrame:WaitForChild("CashCount")

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local categoryGuiTopModule = require(script.Parent:WaitForChild("CategoryGuiTop"))

player:GetAttributeChangedSignal("Exp"):Connect(function()
    GuiTabBarModule.UpdateExpAndExpNextLevel()
    GuiTabBarModule.UpdateTweenServiceBar()
end)

player:GetAttributeChangedSignal("Level"):Connect(function()
    levelText.Text = tostring(player:GetAttribute("Level"))
    GuiTabBarModule.UpdateLevelTextColor()
end)

player:GetAttributeChangedSignal("Cash"):Connect(function()
    local newCash = player:GetAttribute("Cash")
    if GuiTabBarModule.thread and coroutine.status(GuiTabBarModule.thread) ~= "dead" then
        coroutine.close(GuiTabBarModule.thread)
        GuiTabBarModule.thread = nil
    end

    GuiTabBarModule.thread = coroutine.create(function()
        while GuiTabBarModule.lastCash ~= newCash do
            if GuiTabBarModule.lastCash < newCash then
                local diff = newCash - GuiTabBarModule.lastCash
                GuiTabBarModule.lastCash += math.min(2, diff)
            elseif GuiTabBarModule.lastCash > newCash then
                local diff = newCash - GuiTabBarModule.lastCash
                GuiTabBarModule.lastCash -= math.min(2, diff)
            end
            cashCount.Text = tostring(GuiTabBarModule.lastCash)
            task.wait(0.02)
        end
    end)
    coroutine.resume(GuiTabBarModule.thread)
end)

player:GetAttributeChangedSignal("ActionCase"):Connect(function()
    GuiTabBarModule.ActionCaseCall(player:GetAttribute("ActionCase"))
end)

function GuiTabBarModule:Load()
    self:UpdateExpAndExpNextLevel()
    self:UpdateTweenServiceBar()
    levelText.Text = tostring(player:GetAttribute("Level"))
    cashCount.Text = tostring(player:GetAttribute("Cash"))
    self:UpdateLevelTextColor()
    GuiTabBarModule.lastCash = tonumber(player:GetAttribute("Cash"))
end

function GuiTabBarModule:UpdateExpAndExpNextLevel()
    expAndExpNextLevel.Text = tostring(math.ceil(player:GetAttribute("Exp"))).."/"..tostring(math.ceil(player:GetAttribute("ExpNextLevel")))
end

function GuiTabBarModule:UpdateTweenServiceBar()
    TweenService:Create(bar,TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,false),{Size = UDim2.fromScale(player:GetAttribute("Exp") / player:GetAttribute("ExpNextLevel"),1)}):Play()
end

function GuiTabBarModule:UpdateLevelTextColor()
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

function GuiTabBarModule:EffectMouseEnter(button)
    local image : ImageLabel = button:FindFirstChild("image")

    TweenService:Create(image,TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,false), {Size = UDim2.fromScale(1.1,1.1)}):Play()
end

function GuiTabBarModule:EffectMouseLeave(button)
    local image : ImageLabel = button:FindFirstChild("image")

    TweenService:Create(image,TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.In,0,false), {Size = UDim2.fromScale(1.0,1.0)}):Play()
end


for _, buttons : ImageButton in pairs(topFrame:GetChildren()) do
    if buttons:IsA("TextButton") then
        buttons.MouseButton1Click:Connect(function()
            if buttons.Name == "PlayersInServerButton" then
                if GuiTabBarModule.currentCategory ~= "PlayersInServer" then
                    GuiTabBarModule.currentCategory = "PlayersInServer"
                    categoryGuiTopModule:PlayerInServerSelect()
                end
            elseif buttons.Name == "StatsButton" then
                if GuiTabBarModule.currentCategory ~= "Stats" then
                    GuiTabBarModule.currentCategory = "Stats"
                    categoryGuiTopModule:StatsSelect()
                end
            elseif buttons.Name == "InventoryButton" then
                if GuiTabBarModule.currentCategory ~= "Inventory" then
                    GuiTabBarModule.currentCategory = "Inventory"
                    categoryGuiTopModule:InventorySelect()
                end
            elseif buttons.Name == "QuestsButton" then
                if GuiTabBarModule.currentCategory ~= "Quests" then
                    GuiTabBarModule.currentCategory = "Quests"
                    categoryGuiTopModule:QuestsSelect()
                end
            elseif buttons.Name == "ShopButton" then
                if GuiTabBarModule.currentCategory ~= "Shop" then
                    GuiTabBarModule.currentCategory = "Shop"
                    categoryGuiTopModule:ShopSelect()
                end
            elseif buttons.Name == "SettingsButton" then
                if GuiTabBarModule.currentCategory ~= "Settings" then
                    GuiTabBarModule.currentCategory = "Settings"
                    categoryGuiTopModule:SettingsSelect()
                end
            end
        end)

        buttons.MouseEnter:Connect(function()
            GuiTabBarModule:EffectMouseEnter(buttons)
        end)

        buttons.MouseLeave:Connect(function()
            GuiTabBarModule:EffectMouseLeave(buttons)
        end)
    end
end

function GuiTabBarModule.ActionCaseCall(bool : boolean)
    if bool == true then
        tabBarGui.Enabled = false
    else
        tabBarGui.Enabled = true
    end
end


local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")

local categoryGuiTop = playerGui:WaitForChild("CategoryGuiTop")
local exitButton : TextButton = categoryGuiTop:WaitForChild("Canva"):WaitForChild("Frame"):WaitForChild("Category"):WaitForChild("Exit")

humanoid.Died:Connect(function()
    GuiTabBarModule.currentCategory = nil
    categoryGuiTopModule:Clear()
    categoryGuiTopModule:DisableFrame()
end)

exitButton.MouseButton1Click:Connect(function()
    GuiTabBarModule.currentCategory = nil
end)

GuiTabBarModule:Load()

return GuiTabBarModule