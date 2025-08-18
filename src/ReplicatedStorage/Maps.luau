local MapsModule = {
    Forest = {
        SpawnKiller = nil,
        SpawnPlayers = {}, -- KILKA SPAWN, JEDEN SPAWN BĘDZIE DLA JEDNEGO GRACZA
        ItemsToCollect = {},
        ---SYSTEM VOTE
        CountVote = 0,
        VotePlayer = {}
    },
    Farm = {
        SpawnKiller = nil,
        SpawnPlayers = {}, -- KILKA SPAWN, JEDEN SPAWN BĘDZIE DLA JEDNEGO GRACZA
        ItemsToCollect = {},
        ---SYSTEM VOTE
        CountVote = 0,
        VotePlayer = {}
    }
}

-- MAP BĘDZIE WIĘCEJ
-- SKRYPT DZIEJE SIE PO SERWERZE
-- NIEKTORE DANE BĘDA PRZESYŁANE Z CLIENT DO SERWERA NAPRZYKLAD PRZY GLOSOWANIU

function MapsModule:GetRandomMaps()
    local mapNames = {}
    for name, _ in pairs(self) do
        if type(self[name]) == "table" then
            table.insert(mapNames,name)
        end
    end

    local result = {}

    for i = 1, math.min(2,#mapNames) do
        local index = math.random(1,#mapNames)
        local picked = mapNames[index]
        table.insert(result,picked)
        table.remove(mapNames,index)
    end

    return result
end

function MapsModule:Vote(player,mapName : string)
    for _, maps in pairs(self) do
        if table.find(maps.VotePlayer,player) then
            return
        end
    end
    for name, map in pairs(self) do
        if name == mapName then
            map.CountVote += 1
            table.insert(map.VotePlayer,player)
        end
    end
end



return MapsModule