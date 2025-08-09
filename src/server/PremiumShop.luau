local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DogSettings = require(ReplicatedStorage.Shared.DogSettings)
local PlayerManager = require(script.Parent.PlayerManager)
local Remotes = require(script.Parent.Remotes)
local DogModelManager = require(script.Parent.DogModelManager)

local PremiumShop = {}

local function processReceipt(receiptInfo)
    local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
    if not player then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local playerData = PlayerManager.getPlayerState(player)
    if not playerData then
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end

    local dogName
    for name, data in pairs(DogSettings.Dogs) do
        if data.ProductId == receiptInfo.ProductId then
            dogName = name
            break
        end
    end

    if dogName then
        local dogId = DogModelManager.CreateDogForPlayer(player, dogName)
        local newDog = { Id = dogId, Name = dogName, Request = nil }
        table.insert(playerData.Dogs, newDog)
        print(player.Name .. " has purchased a " .. dogName .. "!")
        Remotes.NewDogAlert:FireClient(player, newDog, playerData.Dogs)
        return Enum.ProductPurchaseDecision.PurchaseGranted
    else
        warn("Could not find dog with ProductId: " .. receiptInfo.ProductId)
        return Enum.ProductPurchaseDecision.NotProcessedYet
    end
end

MarketplaceService.ProcessReceipt = processReceipt

return PremiumShop
