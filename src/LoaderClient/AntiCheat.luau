local RunService = game:GetService("RunService")
local AntiCheatModule = {
	code = 0,
	timeFly = 0,
}
local rs = game.ReplicatedStorage

local framework = require(rs.Framework)

local remoteFolder = rs:WaitForChild("Remote")
local antiCheatRemote = remoteFolder:WaitForChild("AntiCheat")

local player = game.Players.LocalPlayer
local character = player.Character
local humanoid: Humanoid = character:WaitForChild("Humanoid")

function AntiCheatModule.GetCode(code: number)
	AntiCheatModule.code = code
	print(AntiCheatModule.code)
end

function AntiCheatModule.Ban()
	player:Kick("AntiCheat detected something unusual")
end

function AntiCheatModule.DetectTeleport()
	if character then
		local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")

		local PositionFirst = HumanoidRootPart.Position

		delay(1, function()
			local PositionSecond = HumanoidRootPart.Position

			if (PositionSecond - PositionFirst).Magnitude > 60 then
				AntiCheatModule.Ban()
			end
		end)
	end
end

function AntiCheatModule.DetectNoclip()
	local character = player.Character

	if character then
		local root = character:FindFirstChild("HumanoidRootPart")

		if root then
			local touchingParts = workspace:GetPartBoundsInBox(root.CFrame, root.Size / 1.4)

			for _, part in pairs(touchingParts) do
				if part.CanCollide and not part:IsDescendantOf(character) then
					AntiCheat.Detected("Noclip")
				end
			end
		end
	end
end

function AntiCheatModule.DetectFly()
	local HumanoidRootPart = character.HumanoidRootPart

	if HumanoidRootPart then
		local origin = HumanoidRootPart.Position
		local direction = Vector3.new(0, -5, 0)

		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = { character }
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude

		local result = workspace:Raycast(origin, direction, raycastParams)

		if not result and humanoid.FloorMaterial == Enum.Material.Air then
			AntiCheatModule.timeFly += RunService.RenderStepped:Wait()

			if AntiCheatModule.timeFly > 2 then
				AntiCheatModule.Ban()
			end
		else
			AntiCheatModule.timeFly = 0
		end
	end
end

humanoid.Changed:Connect(function(state)
	if state == "MaxHealth" then
		AntiCheatModule.Ban()
	elseif state == "JumpHeight" then
		if humanoid.JumpHeight > 7.2 then
			AntiCheatModule.Ban()
		end
	elseif state == "UseJumpPower" then
		if humanoid.UseJumpPower == true then
			AntiCheatModule.Ban()
		end
	elseif state == "WalkSpeed" then
		if humanoid.WalkSpeed > 22 then
			AntiCheatModule.Ban()
		end
	end
end)

character.ChildRemoved:Connect(function(child)
	if child:IsA("MeshPart") then
		AntiCheatModule.Ban()
	end
	if child:IsA("Humanoid") then
		AntiCheatModule.Ban()
	end
	if child:IsA("BasePart") then
		if child.Name == "HumanoidRootPart" then
			AntiCheatModule.Ban()
		end
	end
end)

local backpack = player.Backpack

backpack.ChildAdded:Connect(function(child)
	if child:IsA("HopperBin") then
		AntiCheatModule.Ban()
	end
end)

RunService.RenderStepped:Connect(function(deltaTime)
	AntiCheatModule.DetectTeleport()
	AntiCheatModule.DetectNoclip()
	AntiCheatModule.DetectFly()
end)

framework.OnClientEvent("AntiCheat", function(code)
	AntiCheatModule.GetCode(code)
end)

return AntiCheatModule
