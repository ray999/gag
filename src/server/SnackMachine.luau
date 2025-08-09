local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local DogSettings = require(ReplicatedStorage.Shared.DogSettings)
local PlayerManager = require(script.Parent.PlayerManager)
local Remotes = require(script.Parent.Remotes)
local DogModelManager = require(script.Parent.DogModelManager)

local SnackMachine = {}

local snackMachineModel = Workspace.GameBuildings.SnackMachine
snackMachineModel:SetAttribute("uniqueID", "1ac654213aa2686d08a84957000039b7")

local function getDogByRarity(rarity)
    local dogsOfRarity = {}
    for name, data in pairs(DogSettings.Dogs) do
        if data.Rarity == rarity then
            table.insert(dogsOfRarity, name)
        end
    end
    if #dogsOfRarity > 0 then
        return dogsOfRarity[math.random(1, #dogsOfRarity)]
    end
    return nil
end

local function attractDog(player)
    local chance = math.random()

    local dogName
    if chance <= 0.01 then -- 1% chance for SuperRare
        dogName = getDogByRarity("SuperRare")
    elseif chance <= 0.05 then -- 4% chance for Rare (5% - 1%)
        dogName = getDogByRarity("Rare")
    elseif chance <= 0.20 then -- 15% chance for Common (20% - 5%)
        dogName = getDogByRarity("Common")
    end

    if dogName then
        local playerData = PlayerManager.getPlayerState(player)
        if playerData and player.Character then
            local dogId = DogModelManager.CreateDogForPlayer(player, dogName)
            local newDog = { Id = dogId, Name = dogName, Request = nil }
            table.insert(playerData.Dogs, newDog)
            print(player.Name .. " has attracted a " .. dogName .. "!")
            Remotes.NewDogAlert:FireClient(player, newDog, playerData.Dogs)
        end
    end
end

local function setupMachineForPlayer(player)
    local machineClone = snackMachineModel:Clone()
    machineClone.Name = player.Name .. "'s Snack Machine"
    machineClone.Parent = Workspace

    machineClone.PrimaryPart = machineClone:FindFirstChild("Body")

    if player.Character and machineClone.PrimaryPart then
        machineClone:SetPrimaryPartCFrame(player.Character:GetPrimaryPartCFrame() + Vector3.new(5, 0, 5))
    end
    player.CharacterAdded:Connect(function(character)
        if machineClone.PrimaryPart then
            machineClone:SetPrimaryPartCFrame(character:GetPrimaryPartCFrame() + Vector3.new(5, 0, 5))
        end
    end)

    task.spawn(function()
        while player:IsDescendantOf(Players) do
            task.wait(10)
            attractDog(player)
        end
    end)
end

Players.PlayerAdded:Connect(setupMachineForPlayer)

-- Setup for players already in game
for _, player in ipairs(Players:GetPlayers()) do
    setupMachineForPlayer(player)
end

return SnackMachine
