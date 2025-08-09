local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Remotes = require(ReplicatedStorage.Shared.Remotes)

local DogModelManager = {}

local dogModels = {}

local function createDogModel(player, dogName)
    local model = Instance.new("Model")
    model.Name = dogName
    model.Parent = Workspace

    local part = Instance.new("Part")
    part.Size = Vector3.new(2, 2, 3)
    part.Color = Color3.new(math.random(), math.random(), math.random())
    part.Anchored = false
    part.CanCollide = true
    part.Parent = model

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

Remotes.NewDogAlert.OnClientEvent:Connect(function(dogName, allDogs)
    -- This needs to be handled on the server. We'll adjust the logic.
end)

Players.PlayerRemoving:Connect(onPlayerRemoving)

-- We need a server-side event to trigger dog creation.
-- Let's modify the NewDogAlert to be fired from the server to the server.
-- A better approach would be a dedicated signal module, but for now, this will work.

function DogModelManager.CreateDogForPlayer(player, dogName)
    createDogModel(player, dogName)
end

return DogModelManager
