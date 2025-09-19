local GameManagerModule = {
	countPlayer = 0,
	playersToMatch = {},
	teams = { "Person", "Killer", "Sherif" },
	teamsCountMax = { -1, 1, 1 }, -- -1 is nolimit
	teamsUsed = { 0, 0, 0 },
	thread = nil,
}

local rs = game.ReplicatedStorage
local framework = require(rs.Modules.Framework)
local countDownRemote : RemoteEvent = framework:GetRemoteEvent("CountDown")

function GameManagerModule:Countdown(Sec,GameType)
	local CountdownTask
	
	CountdownTask = function()
		for i = Sec,0,-1 do
			task.wait(1)
			countDownRemote:FireAllClients(i)
		end

		if GameType == "Start" then
			self:Start()
		elseif GameType == "End" then
			--SOON END COUNTDOWN
		end
	end

	self.thread = coroutine.create(CountdownTask)
	coroutine.resume(self.thread)
end

function GameManagerModule:Start()
	local players = game:GetService("Players")

	for i in pairs(players:GetPlayers()) do
		self.countPlayer += 1
	end

	if self.countPlayer > 0 then
		if self.countPlayer % 2 == 0 or self.countPlayer > 2 then
			for _, v in pairs(players:GetPlayers()) do
				table.insert(self.playersToMatch, {Gracz = v, opis = "NieWybrany",status = "Alive"})
			end
			self:Los()
		else
			print("Nie wystarczająca liczba osób")
			wait(2)
			print("Poczekam Troche Dłużej")
			self.countPlayer = 0
			self:Countdown(120,"Start")
		end
	end
end

function GameManagerModule:EndedLosy()
	for _, graczeLista in pairs(self.playersToMatch) do
		if graczeLista.opis == "NieWybrany" and graczeLista.status == "Alive" then
			self:ChangeOpisPlayer(graczeLista.Gracz,"Wybrany")
			graczeLista.Gracz:SetAttribute("Team",self.teams[1])
			self.teamsUsed[1] += 1
		end
	end

	print("Gra jest gotowa do rundy")
	print("Zebrani Gracze: ")
	print(self.playersToMatch)
	self.countPlayer = 0
end

function GameManagerModule:Los()
	local losKiller = self:LosKiller()

	if losKiller == true then
		local losSherif = self:LosSherif()
		
		if losSherif == true then
			local losPerson = self:LosPerson()

			if losPerson == true then
				self:EndedLosy()
			else
				print("Nie udało się wylosować person")
				table.clear(self.playersToMatch)
				self.countPlayer = 0
				self.teamsUsed = {0,0,0}
				self:Countdown(60,"Start")
			end
		else
			print("Nie udało się wylosować sherifa")
			table.clear(self.playersToMatch)
			self.countPlayer = 0
			self.teamsUsed = {0,0,0}
			self:Countdown(60,"Start")
		end
	else
		print("Nie udało się wylosować killera")
		table.clear(self.playersToMatch)
		self.countPlayer = 0
		self.teamsUsed = {0,0,0}
		self:Countdown(60,"Start")
	end
end

function GameManagerModule:LosKiller()
	local PlayerNotChosed = {}

	for _, dane in pairs(self.playersToMatch) do
		if dane.opis == "NieWybrany" and dane.status == "Alive" then
			table.insert(PlayerNotChosed,dane.Gracz)
		end
	end

	if #PlayerNotChosed == 0 then
		return false
	end

	local PickUpRandomKiller: Player = PlayerNotChosed[math.random(1, #PlayerNotChosed)]

	if self.teamsCountMax[2] > self.teamsUsed[2] then
		if PickUpRandomKiller then
			self:ChangeOpisPlayer(PickUpRandomKiller,"Wybrany")
			PickUpRandomKiller:SetAttribute("Team",self.teams[2])
			self.teamsUsed[2] = 1
			print("Wybrano killera " .. PickUpRandomKiller.Name)
			table.clear(PlayerNotChosed)
		else
			warn("wyjebało killer")
		end
	end
	return true
end

function GameManagerModule:LosSherif()
	local PlayerNotChosed = {}

	for _, dane in pairs(self.playersToMatch) do
		if dane.opis == "NieWybrany" and dane.status == "Alive" then
			table.insert(PlayerNotChosed,dane.Gracz)
		end
	end

	if #PlayerNotChosed == 0 then
		return false
	end

	local PickUpRandomSherif: Player = PlayerNotChosed[math.random(1, #PlayerNotChosed)]
	
	if self.teamsCountMax[3] > self.teamsUsed[3] then
		if PickUpRandomSherif then
			self:ChangeOpisPlayer(PickUpRandomSherif,"Wybrany")
			PickUpRandomSherif:SetAttribute("Team",self.teams[3])
			self.teamsUsed[3] = 1
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

function GameManagerModule:LosPerson()
	for _, v in pairs(self.playersToMatch) do
		if v.opis == "NieWybrany" and v.status == "Alive" then
			self.teamsUsed[1] += 1
			self:ChangeOpisPlayer(v.Gracz,"Wybrany")
			v.Gracz:SetAttribute("Team",self.teams[1])
		end
	end

	return true
end

function GameManagerModule:GetOpisFromPlayer(player)
	for _, dane in pairs(self.playersToMatch) do
		if dane.Gracz == player then
			return dane.opis
		end
	end
	return nil
end

function GameManagerModule:ChangeOpisPlayer(player, NewOpis)
	for _, dane in pairs(self.playersToMatch) do
		if dane.Gracz == player then
			dane.opis = NewOpis
			break
		end
	end
end

function GameManagerModule:Died(player : Player)
	for _, dane in pairs(self.playersToMatch) do
		if dane.Gracz == player then
			dane.status = "Not Alive"
		end
	end
end

return GameManagerModule
