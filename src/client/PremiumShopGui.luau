local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DogSettings = require(ReplicatedStorage.Shared.DogSettings)
local AssetLoader = require(ReplicatedStorage.Shared.AssetLoader)
local AssetIds = require(ReplicatedStorage.Shared.AssetIds)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = AssetLoader.loadGui(AssetIds.PremiumShopGui, playerGui)
if screenGui then
    screenGui.Name = "PremiumShopGui"
end

local mainFrame = screenGui and screenGui:WaitForChild("PremiumShopFrame")
local dogList = mainFrame and mainFrame:WaitForChild("DogList")
local toggleButton = screenGui and screenGui:WaitForChild("PremiumShopButton")

local function toggleUI()
    if mainFrame then
        mainFrame.Visible = not mainFrame.Visible
    end
end

if toggleButton then
    toggleButton.MouseButton1Click:Connect(toggleUI)
end

local function promptPurchase(productId)
    MarketplaceService:PromptProductPurchase(player, productId)
end

for dogName, dogInfo in pairs(DogSettings.Dogs) do
    if dogInfo.Currency == "Robux" and dogList then
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

return true
