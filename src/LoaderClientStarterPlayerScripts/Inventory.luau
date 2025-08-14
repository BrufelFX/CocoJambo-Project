local inventoryModule = {
    items = {},

}

local rs = game.ReplicatedStorage
local assets = rs.Assets
local player = game.Players.LocalPlayer
local data : Folder = player:WaitForChild("Data")
local inventory : Folder = data:WaitForChild("Inventory")

--TRZEBA Dokonczyc :(

function inventoryModule.AddItem(itemString : string)
    local itemIsFound = nil

    for _, item in pairs(inventoryModule.items) do
        if item.name == itemString then
            itemIsFound = item
            break
        end
    end

    if itemIsFound ~= nil then
        if player:GetAttribute("IsLoaded") then
            itemIsFound.amount += 1
        end
    else
        table.insert(inventoryModule.items, {
            name = itemString.Name,
            amount = itemString.Value,
            rarity = itemString.Rarity.Value,
        })
    end
end

function inventoryModule.RemoveItem(itemString : string)
    for index, item in pairs(inventoryModule.items) do
        if item.name == itemString then
            if item.amount > 1 then
                item.amount -= 1
            else
                table.remove(inventoryModule.items, index)
            end
        end
    end
end

inventory.ChildAdded:Connect(function(child)
    if child:IsA("StringValue") then
        inventoryModule.AddItem(child.Value)
    end
end)

return inventoryModule