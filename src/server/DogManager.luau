local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local PlayerManager = require(script.Parent.PlayerManager)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

local DogManager = {}

local dogRequests = {
    "Camping", "Swimming", "Eating", "Sleeping", "Playing", 
    "Drinking", "Walking", "Watching TV", "Socializing"
}

local function giveRandomRequest(player, dogId)
    local request = dogRequests[math.random(1, #dogRequests)]
    local playerData = PlayerManager.getPlayerState(player)

    if playerData then
        for _, dog in ipairs(playerData.Dogs) do
            if dog.Id == dogId and not dog.Request then
                dog.Request = request
                print(player.Name .. "'s dog " .. dog.Name .. " wants to go " .. request)
                Remotes.DogRequestUpdate:FireClient(player, playerData.Dogs)
                return
            end
        end
    end
end

local function completeRequest(player, dogId)
    local playerData = PlayerManager.getPlayerState(player)
    if playerData then
        for _, dog in ipairs(playerData.Dogs) do
            if dog.Id == dogId and dog.Request then
                dog.Request = nil
                playerData.DogCoins = playerData.DogCoins + 200
                Remotes.UpdateDogCoins:FireClient(player, playerData.DogCoins)
                Remotes.DogRequestUpdate:FireClient(player, playerData.Dogs)
                print(player.Name .. " completed " .. dog.Name .. "'s request.")
                return true
            end
        end
    end
    return false
end

Remotes.CompleteDogRequest.OnServerInvoke = completeRequest

local function setupDogRequestLoop(player)
    task.spawn(function()
        while player:IsDescendantOf(Players) do
            task.wait(math.random(30, 60)) -- Every 30-60 seconds for testing
            local playerData = PlayerManager.getPlayerState(player)
            if playerData and #playerData.Dogs > 0 then
                local randomDog = playerData.Dogs[math.random(1, #playerData.Dogs)]

                if randomDog and not randomDog.Request then
                    giveRandomRequest(player, randomDog.Id)
                end
            end
        end
    end)
end

Players.PlayerAdded:Connect(setupDogRequestLoop)

for _, player in ipairs(Players:GetPlayers()) do
    setupDogRequestLoop(player)
end

return DogManager
