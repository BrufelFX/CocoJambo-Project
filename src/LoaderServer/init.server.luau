for _, v in pairs(script:GetDescendants()) do
	if v:IsA("ModuleScript") then
		local sucess, error = pcall(function()
			task.spawn(function()
				require(v)
			end)
		end)

		if sucess then
			warn("ModuleScripts Is Loaded - Server")
		else
			warn("Error Loader with ModuleScripts - Server")
		end
	end
end
