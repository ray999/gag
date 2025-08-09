local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local HttpService = game:GetService("HttpService")

local DogModelManager = {}

local dogModels = {}

local function createDogModel(player, dogName, dogId)
    local model = Instance.new("Model")
    model.Name = dogName

    dogId = dogId or HttpService:GenerateGUID(false)
    model:SetAttribute("uniqueID", dogId)

    local part = Instance.new("Part")
    part.Name = "HumanoidRootPart"
    part.Size = Vector3.new(2, 2, 3)
    part.Color = Color3.new(math.random(), math.random(), math.random())
    part.Anchored = false
    part.CanCollide = true
    part.Parent = model

    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = model
    model.Parent = Workspace
    model.PrimaryPart = part

    if player.Character and player.Character.PrimaryPart then
        model:PivotTo(player.Character.PrimaryPart.CFrame + Vector3.new(3, 0, 3))
    end

    if not dogModels[player] then
        dogModels[player] = {}
    end
    table.insert(dogModels[player], model)

    -- Make the dog follow the player
    task.spawn(function()
        while model.Parent do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local rootPart = player.Character.HumanoidRootPart
                local targetPosition = rootPart.Position - rootPart.CFrame.LookVector * 5
                humanoid:MoveTo(targetPosition)
            end
            task.wait(0.5)
        end
    end)

    return model, dogId
end

local function createStrayDogModel(dogName)
    local model = Instance.new("Model")
    model.Name = dogName
    model:SetAttribute("uniqueID", HttpService:GenerateGUID(false))

    local part = Instance.new("Part")
    part.Name = "HumanoidRootPart"
    part.Size = Vector3.new(2, 2, 3)
    part.Color = Color3.new(math.random(), math.random(), math.random())
    part.Anchored = false
    part.CanCollide = true
    part.Parent = model

    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = model
    model.Parent = Workspace
    model.PrimaryPart = part

    model:PivotTo(CFrame.new(math.random(-50,50), 5, math.random(-50,50)))


    task.spawn(function()
        while model.Parent do
            local primaryPart = model.PrimaryPart
            if primaryPart then
                local randomTarget = primaryPart.Position + Vector3.new(math.random(-20,20), 0, math.random(-20,20))
                humanoid:MoveTo(randomTarget)
            end
            task.wait(5)
        end
    end)

    return model
end

local function onPlayerRemoving(player)
    if dogModels[player] then
        for _, model in ipairs(dogModels[player]) do
            model:Destroy()
        end
        dogModels[player] = nil
    end
end

Players.PlayerRemoving:Connect(onPlayerRemoving)
function DogModelManager.CreateDogForPlayer(player, dogName)
    local _, id = createDogModel(player, dogName)
    return id
end

function DogModelManager.CreateStrayDog(dogName)
    return createStrayDogModel(dogName)
end

return DogModelManager
