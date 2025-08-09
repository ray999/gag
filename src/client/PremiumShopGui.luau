local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DogSettings = require(ReplicatedStorage.Shared.DogSettings)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Main GUI
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "PremiumShopGui"

-- Premium Shop UI
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "PremiumShopFrame"
mainFrame.Size = UDim2.new(0, 500, 0, 400)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Gold
mainFrame.Visible = false

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "Premium Shop"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 24

local dogList = Instance.new("ScrollingFrame", mainFrame)
dogList.Size = UDim2.new(1, -20, 1, -60)
dogList.Position = UDim2.new(0, 10, 0, 50)
dogList.BackgroundColor3 = Color3.fromRGB(255, 250, 205) -- LemonChiffon

local listLayout = Instance.new("UIListLayout", dogList)
listLayout.Padding = UDim.new(0, 5)

-- Open/Close Button
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Name = "PremiumShopButton"
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(1, -480, 0, 10)
toggleButton.Text = "Premium Shop"

local function toggleUI()
    mainFrame.Visible = not mainFrame.Visible
end

toggleButton.MouseButton1Click:Connect(toggleUI)

local function promptPurchase(productId)
    MarketplaceService:PromptProductPurchase(player, productId)
end

for dogName, dogInfo in pairs(DogSettings.Dogs) do
    if dogInfo.Currency == "Robux" then
        local itemFrame = Instance.new("Frame", dogList)
        itemFrame.Size = UDim2.new(1, 0, 0, 40)
        itemFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

        local nameLabel = Instance.new("TextLabel", itemFrame)
        nameLabel.Size = UDim2.new(0.5, 0, 1, 0)
        nameLabel.Text = dogName .. " (" .. dogInfo.Rarity .. ")"

        local buyButton = Instance.new("TextButton", itemFrame)
        buyButton.Size = UDim2.new(0.3, 0, 0.8, 0)
        buyButton.Position = UDim2.new(0.7, 0, 0.1, 0)
        buyButton.Text = "R$ " .. dogInfo.Price
        buyButton.MouseButton1Click:Connect(function()
            promptPurchase(dogInfo.ProductId)
        end)
    end
end
