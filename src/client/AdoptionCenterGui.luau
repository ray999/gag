local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BuyDog = ReplicatedStorage:WaitForChild("BuyDog")
local AdoptionCenterRestocked = ReplicatedStorage:WaitForChild("AdoptionCenterRestocked")
local GetAdoptionDogs = ReplicatedStorage:WaitForChild("GetAdoptionDogs")
local DogSettings = require(ReplicatedStorage.Shared.DogSettings)
local AssetLoader = require(ReplicatedStorage.Shared.AssetLoader)
local AssetIds = require(ReplicatedStorage.Shared.AssetIds)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = AssetLoader.loadGui(AssetIds.AdoptionCenterGui, playerGui)
if screenGui then
    screenGui.Name = "AdoptionCenterGui"
end

local mainFrame = screenGui and screenGui:WaitForChild("AdoptionCenterFrame")
local dogList = mainFrame and mainFrame:WaitForChild("DogList")
local toggleButton = screenGui and screenGui:WaitForChild("AdoptionCenterButton")

local function toggleUI()
    if mainFrame then
        mainFrame.Visible = not mainFrame.Visible
    end
end

if toggleButton then
    toggleButton.MouseButton1Click:Connect(toggleUI)
end

local function buyDog(dogName)
    local success, message = BuyDog:InvokeServer(dogName)
    if not success then
        -- TODO: Show an error message to the player
        print(message)
    end
end

local function updateDogList(dogs)
    for _, child in ipairs(dogList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    for _, dogName in ipairs(dogs) do
        local dogInfo = DogSettings.Dogs[dogName]
        local itemFrame = Instance.new("Frame", dogList)
        itemFrame.Size = UDim2.new(1, 0, 0, 40)
        itemFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local nameLabel = Instance.new("TextLabel", itemFrame)
        nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
        nameLabel.Text = dogName .. " (" .. dogInfo.Rarity .. ")"

        local buyButton = Instance.new("TextButton", itemFrame)
        buyButton.Size = UDim2.new(0.3, 0, 0.8, 0)
        buyButton.Position = UDim2.new(0.7, 0, 0.1, 0)
        buyButton.Text = dogInfo.Price .. " Coins"
        buyButton.MouseButton1Click:Connect(function()
            buyDog(dogName)
        end)
    end
end

AdoptionCenterRestocked.OnClientEvent:Connect(updateDogList)

-- Initial fetch
local initialDogs = GetAdoptionDogs:InvokeServer()
updateDogList(initialDogs)

return true
