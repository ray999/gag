local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes)
local AssetLoader = require(ReplicatedStorage.Shared.AssetLoader)

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")

local screenGui = AssetLoader.loadGui("1ac654213aa2686d08a8495700003bcb", playerGui)
if not screenGui then
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "WalletGui"
    screenGui.Parent = playerGui
end
screenGui:SetAttribute("uniqueID", "1ac654213aa2686d08a8495700003bcb")

local walletLabel = screenGui:FindFirstChild("WalletLabel")
if not walletLabel then
    walletLabel = Instance.new("TextLabel", screenGui)
    walletLabel.Name = "WalletLabel"
    walletLabel.Size = UDim2.new(0, 200, 0, 50)
    walletLabel.Position = UDim2.new(0, 10, 0, 10)
    walletLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    walletLabel.BackgroundTransparency = 0.5
    walletLabel.TextColor3 = Color3.new(1, 1, 1)
    walletLabel.Font = Enum.Font.SourceSansBold
    walletLabel.TextSize = 24
    walletLabel.Text = "Wallet: ..."
end

local function onUpdateDogCoins(newAmount)
        walletLabel.Text = "Wallet: " .. newAmount
end

Remotes.UpdateDogCoins.OnClientEvent:Connect(onUpdateDogCoins)
