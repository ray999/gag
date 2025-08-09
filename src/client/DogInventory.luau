local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NewDogAlert = ReplicatedStorage:WaitForChild("NewDogAlert")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "DogInventoryGui"

-- New Dog Alert
local alertFrame = Instance.new("Frame", screenGui)
alertFrame.Name = "NewDogAlert"
alertFrame.Size = UDim2.new(0, 300, 0, 100)
alertFrame.Position = UDim2.new(0.5, -150, 0.2, 0)
alertFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
alertFrame.BackgroundTransparency = 0.2
alertFrame.BorderSizePixel = 0
alertFrame.Visible = false

local alertLabel = Instance.new("TextLabel", alertFrame)
alertLabel.Name = "AlertLabel"
alertLabel.Size = UDim2.new(1, 0, 1, 0)
alertLabel.BackgroundColor3 = Color3.new(1, 1, 1)
alertLabel.BackgroundTransparency = 1
alertLabel.TextColor3 = Color3.new(1, 1, 1)
alertLabel.Font = Enum.Font.SourceSansBold
alertLabel.TextSize = 20
alertLabel.Text = ""

-- Inventory UI
local inventoryFrame = Instance.new("Frame", screenGui)
inventoryFrame.Name = "InventoryFrame"
inventoryFrame.Size = UDim2.new(0, 400, 0, 300)
inventoryFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
inventoryFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
inventoryFrame.Visible = false

local dogList = Instance.new("UIListLayout", inventoryFrame)
dogList.Padding = UDim.new(0, 5)

-- Inventory Button
local inventoryButton = Instance.new("TextButton", screenGui)
inventoryButton.Name = "InventoryButton"
inventoryButton.Size = UDim2.new(0, 150, 0, 50)
inventoryButton.Position = UDim2.new(1, -160, 0, 10)
inventoryButton.Text = "My Dogs"
inventoryButton.BackgroundColor3 = Color3.new(0.1, 0.5, 0.8)
inventoryButton.TextColor3 = Color3.new(1, 1, 1)

local function toggleInventory()
    inventoryFrame.Visible = not inventoryFrame.Visible
end

inventoryButton.MouseButton1Click:Connect(toggleInventory)

local function updateDogList(dogs)
    for i, child in ipairs(inventoryFrame:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    for _, dogName in ipairs(dogs) do
        local dogLabel = Instance.new("TextLabel", inventoryFrame)
        dogLabel.Text = dogName
        dogLabel.Size = UDim2.new(1, -10, 0, 30)
        dogLabel.TextColor3 = Color3.new(1, 1, 1)
    end
end

local function onNewDog(dogName, allDogs)
    -- Show alert
    alertLabel.Text = "You got a new dog: " .. dogName .. "!"
    alertFrame.Visible = true
    task.wait(3)
    alertFrame.Visible = false

    -- Update inventory
    updateDogList(allDogs)
end

NewDogAlert.OnClientEvent:Connect(onNewDog)

return true
