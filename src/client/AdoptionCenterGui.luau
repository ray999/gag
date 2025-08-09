local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes)
local DogSettings = require(ReplicatedStorage.Shared.DogSettings)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdoptionCenterGui"
screenGui.Parent = playerGui

-- Adoption Center UI
local mainFrame = screenGui:FindFirstChild("AdoptionCenterFrame")
if not mainFrame then
    mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Name = "AdoptionCenterFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
    mainFrame.Visible = false

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Text = "Adoption Center"
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 24
end

local dogList = mainFrame:FindFirstChild("DogList")
if not dogList then
    dogList = Instance.new("ScrollingFrame", mainFrame)
    dogList.Name = "DogList"
    dogList.Size = UDim2.new(1, -20, 1, -60)
    dogList.Position = UDim2.new(0, 10, 0, 50)
    dogList.BackgroundColor3 = Color3.fromRGB(220, 220, 220)

    local listLayout = Instance.new("UIListLayout", dogList)
    listLayout.Padding = UDim.new(0, 5)
end

-- Open/Close Button
local toggleButton = screenGui:FindFirstChild("AdoptionCenterButton")
if not toggleButton then
    toggleButton = Instance.new("TextButton", screenGui)
    toggleButton.Name = "AdoptionCenterButton"
    toggleButton.Size = UDim2.new(0, 150, 0, 50)
    toggleButton.Position = UDim2.new(1, -320, 0, 10)
    toggleButton.Text = "Adoption Center"
end

local function toggleUI()
    mainFrame.Visible = not mainFrame.Visible
end

toggleButton.MouseButton1Click:Connect(toggleUI)

local function buyDog(dogName)
    local success, message = Remotes.BuyDog:InvokeServer(dogName)
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

Remotes.AdoptionCenterRestocked.OnClientEvent:Connect(updateDogList)

-- Initial fetch
local initialDogs = Remotes.GetAdoptionDogs:InvokeServer()
updateDogList(initialDogs)

return true
