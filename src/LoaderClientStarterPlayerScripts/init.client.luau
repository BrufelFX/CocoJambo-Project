for _, v in pairs(script:GetDescendants()) do
	if v:IsA("ModuleScript") then
		local success, errorMes = pcall(function()
			require(v)
		end)
		
		if success then
			print("✅", "("..v.Name..")", "-", "Module ClientPlayer Is Loaded.")
		else
			warn("❌", "("..v.Name..")", "-", "Module ClientPlayer Is Not Loaded.", errorMes)
		end
	end
end
