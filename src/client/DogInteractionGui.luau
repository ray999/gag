local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CompleteDogRequest = ReplicatedStorage:WaitForChild("CompleteDogRequest")
local DogRequestUpdate = ReplicatedStorage:WaitForChild("DogRequestUpdate")
local NewDogAlert = ReplicatedStorage:WaitForChild("NewDogAlert")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local inventoryFrame = playerGui:WaitForChild("DogInventoryGui"):WaitForChild("InventoryFrame")

local function completeRequest(dogName)
    local success = CompleteDogRequest:InvokeServer(dogName)
    if success then
        print("Request completed for " .. dogName)
    end
end

local function updateDogListWithRequests(dogs)
    for _, child in ipairs(inventoryFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then -- Clear old entries
            child:Destroy()
        end
    end

    for _, dogData in ipairs(dogs) do
        local dogName = type(dogData) == "string" and dogData or dogData.Name
        local request = type(dogData) == "table" and dogData.Request or nil

        local itemFrame = Instance.new("Frame", inventoryFrame)
        itemFrame.Size = UDim2.new(1, 0, 0, 60)

        local nameLabel = Instance.new("TextLabel", itemFrame)
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Text = dogName
        nameLabel.TextColor3 = Color3.new(1,1,1)

        if request then
            local requestLabel = Instance.new("TextLabel", itemFrame)
            requestLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
            requestLabel.Position = UDim2.new(0, 0, 0.5, 0)
            requestLabel.Text = "Wants to: " .. request
            requestLabel.TextColor3 = Color3.new(1,1,0)

            local completeButton = Instance.new("TextButton", itemFrame)
            completeButton.Size = UDim2.new(0.3, 0, 0.5, 0)
            completeButton.Position = UDim2.new(0.7, 0, 0.5, 0)
            completeButton.Text = "Complete"
            completeButton.MouseButton1Click:Connect(function()
                completeRequest(dogName)
            end)
        end
    end
end

DogRequestUpdate.OnClientEvent:Connect(updateDogListWithRequests)
NewDogAlert.OnClientEvent:Connect(function(_, dogs) updateDogListWithRequests(dogs) end)

return true
