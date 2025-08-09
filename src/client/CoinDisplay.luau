local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes)

local player = Players.LocalPlayer

local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "DogCoinGui"

local coinLabel = Instance.new("TextLabel", screenGui)
coinLabel.Name = "CoinLabel"
coinLabel.Size = UDim2.new(0, 200, 0, 50)
coinLabel.Position = UDim2.new(0, 10, 0, 10)
coinLabel.BackgroundColor3 = Color3.new(0, 0, 0)
coinLabel.BackgroundTransparency = 0.5
coinLabel.TextColor3 = Color3.new(1, 1, 1)
coinLabel.Font = Enum.Font.SourceSansBold
coinLabel.TextSize = 24
coinLabel.Text = "DogCoins: ..."

local function onUpdateDogCoins(newAmount)
	coinLabel.Text = "DogCoins: " .. newAmount
end

Remotes.UpdateDogCoins.OnClientEvent:Connect(onUpdateDogCoins)
