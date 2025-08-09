local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local inventoryFrame = playerGui:WaitForChild("DogInventoryGui"):WaitForChild("InventoryFrame")

local function completeRequest(dogId)
    local success = Remotes.CompleteDogRequest:InvokeServer(dogId)
    if success then
        print("Request completed for dog " .. dogId)
    end
end

local function updateDogListWithRequests(dogs)
    for _, child in ipairs(inventoryFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then -- Clear old entries
            child:Destroy()
        end
    end

    for _, dog in ipairs(dogs) do
        local itemFrame = Instance.new("Frame", inventoryFrame)
        itemFrame.Size = UDim2.new(1, 0, 0, 60)

        local nameLabel = Instance.new("TextLabel", itemFrame)
        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
        nameLabel.Text = dog.Name .. " (" .. dog.Id .. ")"
        nameLabel.TextColor3 = Color3.new(1,1,1)

        if dog.Request then
            local requestLabel = Instance.new("TextLabel", itemFrame)
            requestLabel.Size = UDim2.new(0.7, 0, 0.5, 0)
            requestLabel.Position = UDim2.new(0, 0, 0.5, 0)
            requestLabel.Text = "Wants to: " .. dog.Request
            requestLabel.TextColor3 = Color3.new(1,1,0)

            local completeButton = Instance.new("TextButton", itemFrame)
            completeButton.Size = UDim2.new(0.3, 0, 0.5, 0)
            completeButton.Position = UDim2.new(0.7, 0, 0.5, 0)
            completeButton.Text = "Complete"
            completeButton.MouseButton1Click:Connect(function()
                completeRequest(dog.Id)
            end)
        end
    end
end

Remotes.DogRequestUpdate.OnClientEvent:Connect(updateDogListWithRequests)
Remotes.NewDogAlert.OnClientEvent:Connect(function(_, dogs) updateDogListWithRequests(dogs) end)

return true
