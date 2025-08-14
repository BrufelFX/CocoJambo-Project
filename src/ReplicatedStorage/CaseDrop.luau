local CaseDropModule = {
    ["CommonCase"] = {
        Chance = 40,
        Rarity = 4,
        items =  {
            "CommonItem1",
            "CommonItem2",
            "CommonItem3"
        },
    },
    ["RareCase"] = {
        Chance = 30,
        Rarity = 3,
        items = {
            "RareItem1",
            "RareItem2",
            "RareItem3"
        },
    },
    ["EpicCase"] = {
        Chance = 20,
        Rarity = 2,
        items = {
            "EpicItem1",
            "EpicItem2",
            "EpicItem3"
        },
    },
    ["LegendaryCase"] = {
        Chance = 10,
        Rarity = 1,
        items = {
            "LegendaryItem1",
            "LegendaryItem2",
            "LegendaryItem3"
        },
    }
}

function CaseDropModule:GetRandomCase()
    local totalChance = 0

    for _, case in pairs(CaseDropModule) do
        if type(case) == "table" and case.Chance then
            totalChance = totalChance + case.Chance
        end
    end

    local randomNum = math.random(1,totalChance)
    local cumulate = 0

    for name, case in pairs(CaseDropModule) do
        if type(case) == "table" then
            cumulate = cumulate + case.Chance
            if randomNum <= cumulate then
                local item = self:GetRandomItem(case)
                return item
            end
        end
    end
end


function CaseDropModule:GetRandomItem(case)
    local randomItem = case.items[math.random(1,#case.items)]
    return randomItem
end


return CaseDropModule