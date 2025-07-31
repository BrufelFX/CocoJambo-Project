local ConsoleModule = {
    Commands = {"show_players","show_person","show_killer","show_sherif"},
    ConsoleLaunched = false,
}

local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local rs = game.ReplicatedStorage
local assets : Folder = rs:WaitForChild("Assets")
local consoleGuiAssets : Folder = assets:WaitForChild("ConsoleGui")
local textConsole : TextLabel = consoleGuiAssets:WaitForChild("TextConsole")

local gameGui : ScreenGui = playerGui:WaitForChild("Game")
local consoleFolder : Folder = gameGui:WaitForChild("Console")
local consoleFrame : Frame = consoleFolder:WaitForChild("ConsoleFrame")
local scrollingFrame : ScrollingFrame = consoleFrame:WaitForChild("ScrollingFrame")
local textInput : TextBox = consoleFrame:WaitForChild("TextInput")

local AntiCheat = require(script.Parent:WaitForChild("AntiCheat"))

local Players = game:GetService("Players")
local us = game:GetService("UserInputService")

function ConsoleModule.Launch()
    consoleFrame.Visible = true
    ConsoleModule.TextFormat('<font color="#E8EB34">[SYSTEM] </font> Console Is Launched!')

    ConsoleModule.ConsoleLaunched = true
end

function ConsoleModule.TextFormat(text)
    local textConsoleClone = textConsole:Clone()
    textConsoleClone.Text = "> "..tostring(text)
    textConsoleClone.Parent = scrollingFrame
    textInput.Text = ""
    if not string.match(text, "^<font color=\"#%x+\">%[SYSTEM%]%s*</font>") then
        ConsoleModule.Target(text)
    end
end

function ConsoleModule.Target(text)
    local textClear = string.gsub(text,"[%d=]", "")
    textClear = string.gsub(textClear, "%s+", "")
    textClear = string.lower(textClear)
    local find = table.find(ConsoleModule.Commands,textClear)
    if find then
        local number = string.match(text, "%d+")
        ConsoleModule.Fire(tonumber(find),tonumber(number))
    else
        ConsoleModule.TextFormat('<font color="#E8EB34">[SYSTEM] </font> Invalid Command')
    end
end

function ConsoleModule.Fire(numTable,numberFire)
    if numTable == 1 then
        ConsoleModule.Show_Players(numberFire)
    elseif numTable == 2 then
        ConsoleModule.Show_Person(numberFire)
    elseif numTable == 3 then
        ConsoleModule.Show_Killer(numberFire)
    elseif  numTable == 4 then
        ConsoleModule.Show_Sherif(numberFire)
    end
end

function ConsoleModule.Show_Players(numberFire)
    local connect
    if numberFire == 1 then
        connect = true
        local function AddEsp(player)
            local espHighlight = Instance.new("Highlight",player.Character)
            espHighlight.Name = "Esp_"..AntiCheat.code
        end

        for _, v : Player in pairs(Players:GetPlayers()) do
            if v ~= player then
                if not v.Character:FindFirstAncestorOfClass("Highlight") then
                    AddEsp(v) 
                end
            else
                local countPlayer = #Players:GetChildren()

                if countPlayer == 1 or countPlayer == 0 then
                    ConsoleModule.TextFormat('<font color="#E8EB34">[SYSTEM] </font> No Players!')
                end
            end
        end

        game.Players.PlayerAdded:Connect(function(player)
            local character = player.Character or player.CharacterAdded:Wait()
            if not character:FindFirstAncestorOfClass("Highlight") then
                if connect == true then
                    AddEsp(player)
                end
            end
        end)
    elseif numberFire == 0 then
        connect = false
        for _, v : Player in pairs(Players:GetPlayers()) do
            if v ~= player then
                local espHighlight = v.Character:FindFirstChildOfClass("Highlight")
                if espHighlight then
                    espHighlight:Destroy()
                end
            end
        end
    end
end

function ConsoleModule.Show_Person(numberFire)
    local connect
    if numberFire == 1 then
        connect = true
        local function AddEsp(player)
            local espHighlight = Instance.new("Highlight",player.Character)
            espHighlight.Name = "Esp_"..AntiCheat.code
            espHighlight.FillColor = Color3.fromRGB(0, 255, 0)
        end

        for _, v : Player in pairs(Players:GetPlayers()) do
            if v.Data.Team.Value == "Person" then
                if not v.Character:FindFirstAncestorOfClass("Highlight") then
                    AddEsp(v)
                else
                    local highlight = v.Character:FindFirstAncestorOfClass("Highlight")
                    if highlight then
                        highlight:Destroy()
                        AddEsp(v)
                    end
                end
            end
        end
    elseif numberFire == 0 then
        connect = false
        for _, v : Player in pairs(Players:GetPlayers()) do
            local espHighlight = v.Character:FindFirstChildOfClass("Highlight")
            if espHighlight then
                espHighlight:Destroy()
            end
        end
    end
end

function ConsoleModule.Show_Killer(numberFire)
    local connect
    if numberFire == 1 then
        connect = true
        local function AddEsp(player)
            local espHighlight = Instance.new("Highlight",player.Character)
            espHighlight.Name = "Esp_"..AntiCheat.code
            espHighlight.FillColor = Color3.fromRGB(255,0,0)
        end

        for _, v : Player in pairs(Players:GetPlayers()) do
            if v.Data.Team.Value == "Killer" then
                if not v.Character:FindFirstAncestorOfClass("Highlight") then
                    AddEsp(v)
                else
                    local highlight = v.Character:FindFirstAncestorOfClass("Highlight")
                    if highlight then
                        highlight:Destroy()
                        AddEsp(v)
                    end
                end
            end
        end
    elseif numberFire == 0 then
        connect = false
        for _, v : Player in pairs(Players:GetPlayers()) do
            local espHighlight = v.Character:FindFirstChildOfClass("Highlight")
            if espHighlight then
                espHighlight:Destroy()
            end
        end
    end
end

function ConsoleModule.Show_Sherif(numberFire)
    local connect
    if numberFire == 1 then
        connect = true
        local function AddEsp(player)
            local espHighlight = Instance.new("Highlight",player.Character)
            espHighlight.Name = "Esp_"..AntiCheat.code
            espHighlight.FillColor = Color3.fromRGB(0,0,255)
        end

        for _, v : Player in pairs(Players:GetPlayers()) do
            if v.Data.Team.Value == "Sherif" then
                if not v.Character:FindFirstAncestorOfClass("Highlight") then
                    AddEsp(v)
                else
                    local highlight = v.Character:FindFirstAncestorOfClass("Highlight")
                    if highlight then
                        highlight:Destroy()
                        AddEsp(v)
                    end
                end
            end
        end
    elseif numberFire == 0 then
        connect = false
        for _, v : Player in pairs(Players:GetPlayers()) do
            local espHighlight = v.Character:FindFirstChildOfClass("Highlight")
            if espHighlight then
                espHighlight:Destroy()
            end
        end
    end
end

us.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then
        return
    end

    if input.KeyCode == Enum.KeyCode.Return then
        if textInput.Text ~= "" and ConsoleModule.ConsoleLaunched then
            ConsoleModule.TextFormat(textInput.Text)
        end
    end

    if input.KeyCode == Enum.KeyCode.N then
        if ConsoleModule.ConsoleLaunched == false then

            ConsoleModule.Launch()
        end
    end
end)


return ConsoleModule