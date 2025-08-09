local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DogModelManager = require(script.Parent.DogModelManager)
local DogSettings = require(ReplicatedStorage.Shared.DogSettings)

local StrayDogSpawner = {}

local function getRandomDogName()
    local names = {}
    for name in pairs(DogSettings.Dogs) do
        table.insert(names, name)
    end
    return names[math.random(1, #names)]
end

for _ = 1, 3 do
    DogModelManager.CreateStrayDog(getRandomDogName())
end

return StrayDogSpawner
