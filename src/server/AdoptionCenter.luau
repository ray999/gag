local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local DogSettings = require(ReplicatedStorage.Shared.DogSettings)
local PlayerManager = require(script.Parent.PlayerManager)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local DogModelManager = require(script.Parent.DogModelManager)

local AdoptionCenter = {}

local availableDogs = {}

local function getRandomDog()
    local allDogNames = {}
    for name, data in pairs(DogSettings.Dogs) do
        if data.Currency == "DogCoins" then -- Only DogCoins dogs for adoption center
            table.insert(allDogNames, name)
        end
    end
    return allDogNames[math.random(1, #allDogNames)]
end

local function refreshAdoptionCenter()
    table.clear(availableDogs)
    for i = 1, 10 do
        local dogName = getRandomDog()
        table.insert(availableDogs, dogName)
    end
    print("Adoption center has been restocked.")
    Remotes.AdoptionCenterRestocked:FireAllClients(availableDogs)
end

local function buyDog(player, dogName)
    local playerData = PlayerManager.getPlayerState(player)
    local dogInfo = DogSettings.Dogs[dogName]

    if not table.find(availableDogs, dogName) then
        return false, "This dog is not available."
    end

    if playerData.DogCoins < dogInfo.Price then
        return false, "Not enough DogCoins."
    end

    playerData.DogCoins = playerData.DogCoins - dogInfo.Price
    table.insert(player.Character and playerData.Dogs or {}, dogName)

    -- Remove dog from adoption center
    for i, name in ipairs(availableDogs) do
        if name == dogName then
            table.remove(availableDogs, i)
            break
        end
    end

    Remotes.UpdateDogCoins:FireClient(player, playerData.DogCoins)
    Remotes.NewDogAlert:FireClient(player, dogName, playerData.Dogs)
    DogModelManager.CreateDogForPlayer(player, dogName)
    Remotes.AdoptionCenterRestocked:FireAllClients(availableDogs) -- Update for all clients

    print(player.Name .. " bought a " .. dogName)
    return true, "Purchase successful!"
end

Remotes.GetAdoptionDogs.OnServerInvoke = function(player)
    return availableDogs
end

Remotes.BuyDog.OnServerInvoke = buyDog

task.spawn(function()
    while true do
        refreshAdoptionCenter()
        task.wait(25 * 60) -- 25 minutes
    end
end)

return AdoptionCenter

