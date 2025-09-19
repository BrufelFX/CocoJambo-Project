local CategoryGuiTopModule = {
    LevelColor = {
		[5] = Color3.fromRGB(35, 171, 224),
		[15] = Color3.fromRGB(174, 69, 235),
		[25] = Color3.fromRGB(160, 34, 34),
		[40] = Color3.fromRGB(255, 224, 51)
	},
}

local rs = game.ReplicatedStorage
local assets : Folder = rs:WaitForChild("Assets")
local players = game:GetService("Players")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local categoryGuiTop : ScreenGui = playerGui:WaitForChild("CategoryGuiTop")
local frame : Frame = categoryGuiTop:WaitForChild("Canva"):WaitForChild("Frame")
local category : Frame = frame:WaitForChild("Category")
local categoryText : TextLabel = category:WaitForChild("CategoryText")
local exitButton : TextButton = category:WaitForChild("Exit")

local playersInServer : ScrollingFrame = frame:WaitForChild("PlayersInServer")
local playersInServerFolder : Folder = assets:WaitForChild("PlayersInServer")
local playerFrame : Frame = playersInServerFolder:WaitForChild("Player")

local statsFrame : Frame = frame:WaitForChild("Stats")
local totalKills : Frame = statsFrame:WaitForChild("TotalKillsFrame")
local totalEscapes : Frame = statsFrame:WaitForChild("TotalEscapesFrame")

local GuiEffectModule = require(rs.Modules.GuiEffects)

function CategoryGuiTopModule:Clear()
    for _, guis in pairs(frame:GetChildren()) do
        if guis:IsA("ScrollingFrame") or guis:IsA("Frame") and guis.Name ~= "Category" then
            if guis.Visible == true then
                guis.Visible = false
            end
        end
    end

    return true
end

function CategoryGuiTopModule:ActionCaseCall(bool : boolean)
    if bool == true then
        categoryGuiTop.Enabled = false
    else
        categoryGuiTop.Enabled = true
    end
end

function CategoryGuiTopModule:DisableFrame()
    frame.Visible = false
    GuiEffectModule:Delete_Blur()
    GuiEffectModule:Create_FovZoomOut()
end

function CategoryGuiTopModule:PlayerInServerSelect()
    if frame.Visible == false then
        frame.Visible = true
    end

    local result = self:Clear()

    if not result then
        return
    end

    GuiEffectModule:Create_Blur()
    GuiEffectModule:Create_FovZoomIn()
    for _, framesInPlayerInServer in pairs(playersInServer:GetChildren()) do
        if framesInPlayerInServer:IsA("Frame") then
            framesInPlayerInServer:Destroy()
        end
    end

    for _, playersInGame : Player in pairs(players:GetPlayers()) do
        local playerFrameIn : Frame = playerFrame:Clone()
        local displayName : TextLabel = playerFrameIn:FindFirstChild("Displayname")
        local userName : TextLabel = playerFrameIn:FindFirstChild("Username")
        local avatar : Frame = playerFrameIn:FindFirstChild("Avatar")
        local image : ImageLabel = avatar:FindFirstChild("image")
        local levelText : TextLabel = avatar:FindFirstChild("Level")


        local userId = playersInGame.UserId
        local thumType = Enum.ThumbnailType.AvatarBust
        local thumSize = Enum.ThumbnailSize.Size150x150
        local content = players:GetUserThumbnailAsync(userId,thumType,thumSize)
            
        image.Image = content
        userName.Text = "@"..playersInGame.Name
        displayName.Text = playersInGame.DisplayName
        levelText.Text = tostring(playersInGame:GetAttribute("Level"))
        playerFrameIn.Name = userId

        if playersInGame:GetAttribute("Level") >= 5 and playersInGame:GetAttribute("Level") < 15 then
            levelText.TextColor3 = CategoryGuiTopModule.LevelColor[5]
        elseif playersInGame:GetAttribute("Level") >= 15 and playersInGame:GetAttribute("Level") < 25 then
            levelText.TextColor3 = CategoryGuiTopModule.LevelColor[15]
        elseif playersInGame:GetAttribute("Level") >= 25 and playersInGame:GetAttribute("Level") < 40 then
            levelText.TextColor3 = CategoryGuiTopModule.LevelColor[25]
        elseif playersInGame:GetAttribute("Level") >= 40 then
            levelText.TextColor3 = CategoryGuiTopModule.LevelColor[40]
        end
        categoryText.Text = "Players In Server"
        playerFrameIn.Parent = playersInServer
        playersInServer.Visible = true
    end
end

function CategoryGuiTopModule:StatsSelect()
    if frame.Visible == false then
        frame.Visible = true
    end

    local result = self:Clear()

    if not result then
        return
    end

    GuiEffectModule:Create_Blur()
    GuiEffectModule:Create_FovZoomIn()

    local textCountKills : TextLabel = totalKills:WaitForChild("Count")
    local TextCountEscapes : TextLabel = totalEscapes:WaitForChild("Count")

    textCountKills.Text = tostring(player:GetAttribute("Kills"))
    TextCountEscapes.Text = tostring(player:GetAttribute("Escapes"))

    categoryText.Text = "Stats"
    statsFrame.Visible = true
end

function CategoryGuiTopModule:InventorySelect()
    if frame.Visible == false then
        frame.Visible = true
    end

    local result = self:Clear()

    if not result then
        return
    end

    GuiEffectModule:Create_Blur()
    GuiEffectModule:Create_FovZoomIn()

    local inventoryFrame : Frame = frame:WaitForChild("Inventory")
    categoryText.Text = "Inventory"
    inventoryFrame.Visible = true
end

function CategoryGuiTopModule:ShopSelect()
    if frame.Visible == false then
        frame.Visible = true
    end

    local result = self:Clear()

    if not result then
        return
    end

    GuiEffectModule:Create_Blur()
    GuiEffectModule:Create_FovZoomIn()

    local shopFrame : Frame = frame:WaitForChild("Shop")
    categoryText.Text = "Shop"
    shopFrame.Visible = true
end

function CategoryGuiTopModule:QuestsSelect()
    if frame.Visible == false then
        frame.Visible = true
    end

    local result = self:Clear()

    if not result then
        return
    end

    GuiEffectModule:Create_Blur()
    GuiEffectModule:Create_FovZoomIn()

    local questFrame : Frame = frame:WaitForChild("Quest")
    categoryText.Text = "Quest"
    questFrame.Visible = true
end

function CategoryGuiTopModule:SettingsSelect()
    if frame.Visible == false then
        frame.Visible = true
    end

    local result = self:Clear()

    if not result then
        return
    end

    GuiEffectModule:Create_Blur()
    GuiEffectModule:Create_FovZoomIn()

    local settingsFrame : Frame = frame:WaitForChild("Settings")
    categoryText.Text = "Settings"
    settingsFrame.Visible = true
end

player:GetAttributeChangedSignal("ActionCase"):Connect(function()
    CategoryGuiTopModule:ActionCaseCall(player:GetAttribute("ActionCase"))
end)

exitButton.MouseButton1Click:Connect(function()
    CategoryGuiTopModule:Clear()
    CategoryGuiTopModule:DisableFrame()
    categoryText.Text = "Category"
    
end)


return CategoryGuiTopModule