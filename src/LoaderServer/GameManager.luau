local GameManagerModule = {
	countPlayer = 0,
	playersToMatch = {},
	teams = { "Person", "Killer", "Sherif" },
	teamsCountMax = { -1, 1, 1 }, -- -1 is nolimit
	teamsUsed = { 0, 0, 0 },
	thread = nil,
}

local rs = game.ReplicatedStorage
local framework = require(rs.Framework)
local countDownRemote : RemoteEvent = framework:GetRemoteEvent("CountDown")

function GameManagerModule.Countdown(Sec,GameType)
	local CountdownTask
	
	CountdownTask = function()
		for i = Sec,0,-1 do
			task.wait(1)
			countDownRemote:FireAllClients(i)
		end

		if GameType == "Start" then
			GameManagerModule.Start()
		elseif GameType == "End" then
			--SOON END COUNTDOWN
		end
	end

	GameManagerModule.thread = coroutine.create(CountdownTask)
	coroutine.resume(GameManagerModule.thread)
end

function GameManagerModule.Start()
	local players = game:GetService("Players")

	for i in pairs(players:GetPlayers()) do
		GameManagerModule.countPlayer += 1
	end

	if GameManagerModule.countPlayer > 0 then
		if GameManagerModule.countPlayer % 2 == 0 or GameManagerModule.countPlayer > 2 then
			for _, v in pairs(players:GetPlayers()) do
				table.insert(GameManagerModule.playersToMatch, {Gracz = v, opis = "NieWybrany"})
			end
			GameManagerModule.Los()
		else
			print("Nie wystarczająca liczba osób")
		end
	end
end

function GameManagerModule.EndedLosy()
	for _, graczeLista in pairs(GameManagerModule.playersToMatch) do
		if graczeLista.opis == "NieWybrany" then
			GameManagerModule.ChangeOpisPlayer(graczeLista.Gracz,"Wybrany")
			graczeLista.Gracz.Data.Team.Value = GameManagerModule.teams[1]
			GameManagerModule.teamsUsed[1] += 1

			for _, graczeListaKolejna in pairs(GameManagerModule.playersToMatch) do
				if graczeListaKolejna.opis == "NieWybrany" then
					local find = table.find(GameManagerModule.playersToMatch,graczeListaKolejna.Gracz)
					if find then
						table.remove(GameManagerModule.playersToMatch,find)
					end
				end
			end
		end
	end

	print("Gra jest gotowa do rundy")
	print("Zebrani Gracze: ")
	print(GameManagerModule.playersToMatch)
end

function GameManagerModule.Los()
	local losKiller = GameManagerModule.LosKiller()

	if losKiller == true then
		local losSherif = GameManagerModule.LosSherif()
		
		if losSherif == true then
			local losPerson = GameManagerModule.LosPerson()

			if losPerson == true then
				GameManagerModule.EndedLosy()
			end
		end
	end
end

function GameManagerModule.LosKiller()
	local PlayerNotChosed = {}

	for _, dane in pairs(GameManagerModule.playersToMatch) do
		if dane.opis == "NieWybrany" then
			table.insert(PlayerNotChosed,dane.Gracz)
		end
	end

	if #PlayerNotChosed == 0 then
		return false
	end

	local PickUpRandomKiller: Player = PlayerNotChosed[math.random(1, #PlayerNotChosed)]

	if GameManagerModule.teamsCountMax[2] > GameManagerModule.teamsUsed[2] then
		if PickUpRandomKiller then
			GameManagerModule.ChangeOpisPlayer(PickUpRandomKiller,"Wybrany")
			PickUpRandomKiller.Data.Team.Value = GameManagerModule.teams[2]
			GameManagerModule.teamsUsed[2] = 1
			print("Wybrano killera " .. PickUpRandomKiller.Name)
			table.clear(PlayerNotChosed)
		else
			warn("wyjebało killer")
		end
	end
	return true
end

function GameManagerModule.LosSherif()
	local PlayerNotChosed = {}

	for _, dane in pairs(GameManagerModule.playersToMatch) do
		if dane.opis == "NieWybrany" then
			table.insert(PlayerNotChosed,dane.Gracz)
		end
	end

	if #PlayerNotChosed == 0 then
		return false
	end

	local PickUpRandomSherif: Player = PlayerNotChosed[math.random(1, #PlayerNotChosed)]
	
	if GameManagerModule.teamsCountMax[3] > GameManagerModule.teamsUsed[3] then
		if PickUpRandomSherif then
			GameManagerModule.ChangeOpisPlayer(PickUpRandomSherif,"Wybrany")
			PickUpRandomSherif.Data.Team.Value = GameManagerModule.teams[3]
			GameManagerModule.teamsUsed[3] = 1
			print("Wybrano sherif " .. PickUpRandomSherif.Name)
			table.clear(PlayerNotChosed)
		else
			warn("wyjebało sherif")
		end
	else
		print("nie wiem")
	end
	return true
end

function GameManagerModule.LosPerson()
	for _, v in pairs(GameManagerModule.playersToMatch) do
		if v.opis == "NieWybrany" then
			GameManagerModule.teamsUsed[1] += 1
			GameManagerModule.ChangeOpisPlayer(v.Gracz,"Wybrany")
			v.Gracz.Data.Team.Value = GameManagerModule.teams[1]
		end
	end

	return true
end

function GameManagerModule.GetOpisFromPlayer(player)
	for _, dane in pairs(GameManagerModule.playersToMatch) do
		if dane.Gracz == player then
			return dane.opis
		end
	end
	return nil
end

function GameManagerModule.ChangeOpisPlayer(player, NewOpis)
	for _, dane in pairs(GameManagerModule.playersToMatch) do
		if dane.Gracz == player then
			dane.opis = NewOpis
			break
		end
	end
end

return GameManagerModule
