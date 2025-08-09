local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local Remotes = require(ReplicatedStorage.Shared.Remotes)

local DogModelManager = {}

local dogModels = {}

local function createDogModel(player, dogName)
    local model = Instance.new("Model")
    model.Name = dogName
    model.Parent = Workspace
    model:SetAttribute("uniqueID", HttpService:GenerateGUID(false))

    local rootPart = Instance.new("Part")
    rootPart.Name = "HumanoidRootPart"
    rootPart.Size = Vector3.new(2, 2, 3)
    rootPart.Color = Color3.new(math.random(), math.random(), math.random())
    rootPart.Anchored = false
    rootPart.CanCollide = true
    rootPart.Parent = model
    model.PrimaryPart = rootPart

    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = model

    model:SetPrimaryPartCFrame(player.Character.PrimaryPart.CFrame + Vector3.new(3, 0, 3))

    if not dogModels[player] then
        dogModels[player] = {}
    end
    table.insert(dogModels[player], model)

    -- Make the dog follow the player
    task.spawn(function()
        while model.Parent do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = player.Character.HumanoidRootPart.Position
                humanoid:MoveTo(targetPosition)
            end
            task.wait(0.5)
        end
    end)

    return model
end

local function createStrayDogModel(dogName)
    local model = Instance.new("Model")
    model.Name = dogName
    model.Parent = Workspace
    model:SetAttribute("uniqueID", HttpService:GenerateGUID(false))

    local rootPart = Instance.new("Part")
    rootPart.Name = "HumanoidRootPart"
    rootPart.Size = Vector3.new(2, 2, 3)
    rootPart.Color = Color3.new(math.random(), math.random(), math.random())
    rootPart.Anchored = false
    rootPart.CanCollide = true
    rootPart.Parent = model
    model.PrimaryPart = rootPart

    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = model

    model:SetPrimaryPartCFrame(CFrame.new(math.random(-50,50), 5, math.random(-50,50)))

    task.spawn(function()
        while model.Parent do
            local randomTarget = model.PrimaryPart.Position + Vector3.new(math.random(-20,20), 0, math.random(-20,20))
            humanoid:MoveTo(randomTarget)
            task.wait(5)
        end
    end)

    return model
end

local function onNewDog(player, dogName, allDogs)
    createDogModel(player, dogName)
end

local function onPlayerRemoving(player)
    if dogModels[player] then
        for _, model in ipairs(dogModels[player]) do
            model:Destroy()
        end
        dogModels[player] = nil
    end
end

Remotes.NewDogAlert.OnServerEvent:Connect(onNewDog)

Players.PlayerRemoving:Connect(onPlayerRemoving)

-- We need a server-side event to trigger dog creation.
-- Let's modify the NewDogAlert to be fired from the server to the server.
-- A better approach would be a dedicated signal module, but for now, this will work.

function DogModelManager.CreateDogForPlayer(player, dogName)
    createDogModel(player, dogName)
end

function DogModelManager.CreateStrayDog(dogName)
    return createStrayDogModel(dogName)
end

return DogModelManager
