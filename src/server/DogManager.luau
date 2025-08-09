local Players = game:GetService("Players")

local PlayerManager = require(script.Parent.PlayerManager)
local Remotes = require(script.Parent.Remotes)

local DogManager = {}

local dogRequests = {
    "Camping", "Swimming", "Eating", "Sleeping", "Playing", 
    "Drinking", "Walking", "Watching TV", "Socializing"
}

local function giveRandomRequest(player, dogName)
    local request = dogRequests[math.random(1, #dogRequests)]
    local playerData = PlayerManager.getPlayerState(player)
    
    if playerData then
        for i, dog in ipairs(playerData.Dogs) do
            if (type(dog) == "string" and dog == dogName) or (type(dog) == "table" and dog.Name == dogName) then
                playerData.Dogs[i] = { Name = dogName, Request = request }
                print(player.Name .. "'s dog " .. dogName .. " wants to go " .. request)
                Remotes.DogRequestUpdate:FireClient(player, playerData.Dogs)
                return
            end
        end
    end
end

local function completeRequest(player, dogName)
    local playerData = PlayerManager.getPlayerState(player)
    if playerData then
        for i, dogData in ipairs(playerData.Dogs) do
            if dogData.Name == dogName and dogData.Request then
                playerData.Dogs[i] = dogData.Name -- Reset to string
                playerData.DogCoins = playerData.DogCoins + 200
                Remotes.UpdateDogCoins:FireClient(player, playerData.DogCoins)
                Remotes.DogRequestUpdate:FireClient(player, playerData.Dogs)
                print(player.Name .. " completed " .. dogName .. "'s request.")
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
                local randomDogIndex = math.random(1, #playerData.Dogs)
                local dog = playerData.Dogs[randomDogIndex]
                
                local dogName
                if type(dog) == "string" then
                    dogName = dog
                elseif type(dog) == "table" and not dog.Request then
                    dogName = dog.Name
                end

                if dogName then
                    giveRandomRequest(player, dogName)
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
