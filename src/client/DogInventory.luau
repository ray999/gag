local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NewDogAlert = ReplicatedStorage:WaitForChild("NewDogAlert")
local AssetLoader = require(ReplicatedStorage.Shared.AssetLoader)
local AssetIds = require(ReplicatedStorage.Shared.AssetIds)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = AssetLoader.loadGui(AssetIds.DogInventoryGui, playerGui)
if screenGui then
    screenGui.Name = "DogInventoryGui"
end

local alertFrame = screenGui and screenGui:WaitForChild("NewDogAlert")
local alertLabel = alertFrame and alertFrame:WaitForChild("AlertLabel")
local inventoryFrame = screenGui and screenGui:WaitForChild("InventoryFrame")
local inventoryButton = screenGui and screenGui:WaitForChild("InventoryButton")

local dogList = inventoryFrame and inventoryFrame:FindFirstChildWhichIsA("UIListLayout")
if not dogList and inventoryFrame then
    dogList = Instance.new("UIListLayout", inventoryFrame)
    dogList.Padding = UDim.new(0, 5)
end

local function toggleInventory()
    if inventoryFrame then
        inventoryFrame.Visible = not inventoryFrame.Visible
    end
end

if inventoryButton then
    inventoryButton.MouseButton1Click:Connect(toggleInventory)
end

local function updateDogList(dogs)
    if not inventoryFrame then
        return
    end

    for i, child in ipairs(inventoryFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    for _, dog in ipairs(dogs) do
        local dogLabel = Instance.new("TextLabel", inventoryFrame)
        dogLabel.Text = dog.Name .. " (" .. dog.Id .. ")"
        dogLabel.Size = UDim2.new(1, -10, 0, 30)
        dogLabel.TextColor3 = Color3.new(1, 1, 1)
    end
end

local function onNewDog(dog, allDogs)
    if alertLabel and alertFrame then
        alertLabel.Text = "You got a new dog: " .. dog.Name .. " (" .. dog.Id .. ")!"
        alertFrame.Visible = true
        task.wait(3)
        alertFrame.Visible = false
    end

    updateDogList(allDogs)
end

NewDogAlert.OnClientEvent:Connect(onNewDog)

return true
