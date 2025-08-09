local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UpdateDogCoins = ReplicatedStorage:WaitForChild("UpdateDogCoins")
local AssetLoader = require(ReplicatedStorage.Shared.AssetLoader)
local AssetIds = require(ReplicatedStorage.Shared.AssetIds)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = AssetLoader.loadGui(AssetIds.CoinDisplayGui, playerGui)
if screenGui then
    screenGui.Name = "WalletGui"
end

local walletLabel = screenGui and screenGui:WaitForChild("WalletLabel")
if walletLabel then
    walletLabel.Text = "Wallet: ..."
end

local function onUpdateDogCoins(newAmount)
    if walletLabel then
        walletLabel.Text = "Wallet: " .. newAmount
    end
end

UpdateDogCoins.OnClientEvent:Connect(onUpdateDogCoins)

return true
