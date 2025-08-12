for _, v in pairs(script:GetDescendants()) do
	if v:IsA("ModuleScript") then
		local sucess, error = pcall(function()
			task.spawn(function()
				require(v)
			end)
		end)

		if sucess then
			warn("ModuleScripts Is Loaded - Client")
		else
			warn("Error Loader with ModuleScripts - Client")
		end
	end
end
