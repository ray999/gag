local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes)

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WalletGui"
screenGui.Parent = playerGui

local walletLabel = Instance.new("TextLabel")
walletLabel.Name = "WalletLabel"
walletLabel.Size = UDim2.new(0, 200, 0, 50)
walletLabel.Position = UDim2.new(0, 10, 0, 10)
walletLabel.BackgroundColor3 = Color3.new(0, 0, 0)
walletLabel.BackgroundTransparency = 0.5
walletLabel.TextColor3 = Color3.new(1, 1, 1)
walletLabel.Font = Enum.Font.SourceSansBold
walletLabel.TextSize = 24
walletLabel.Text = "Wallet: ..."
walletLabel.Parent = screenGui

local function onUpdateDogCoins(newAmount)
    walletLabel.Text = "Wallet: " .. newAmount
end

Remotes.UpdateDogCoins.OnClientEvent:Connect(onUpdateDogCoins)

return true
