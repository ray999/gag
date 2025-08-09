local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = require(ReplicatedStorage.Shared.Remotes)

local PlayerManager = {}

local playerData = {}

function PlayerManager.getPlayerState(player)
	return playerData[player]
end

local function onPlayerAdded(player)
	playerData[player] = {
		DogCoins = 0,
		Dogs = {}, -- { Id = string, Name = string, Request = string? }
	}
	print(player.Name .. " has joined the game!")

	-- Send initial DogCoins value
	Remotes.UpdateDogCoins:FireClient(player, playerData[player].DogCoins)
end

local function onPlayerRemoving(player)
	playerData[player] = nil
	print(player.Name .. " has left the game.")
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Initialize data for players already in the game
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

task.spawn(function()
    while task.wait(60) do
        for player, data in pairs(playerData) do
            data.DogCoins = data.DogCoins + 500
            print("Gave 500 DogCoins to " .. player.Name .. ". New balance: " .. data.DogCoins)
            Remotes.UpdateDogCoins:FireClient(player, data.DogCoins)
        end
    end
end)

return PlayerManager
