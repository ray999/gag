local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = {}

-- Asset Loading
Remotes.LoadAsset = Instance.new("RemoteFunction")
Remotes.LoadAsset.Name = "LoadAsset"
Remotes.LoadAsset.Parent = ReplicatedStorage

local LoadedAssets = Instance.new("Folder")
LoadedAssets.Name = "LoadedAssets"
LoadedAssets.Parent = ReplicatedStorage

Remotes.LoadAsset.OnServerInvoke = function(_, assetId)
    local AssetLoader = require(ReplicatedStorage.Shared.AssetLoader)
    AssetLoader.loadAsset(assetId)
    return true
end

-- Dog Coins & Inventory
Remotes.UpdateDogCoins = Instance.new("RemoteEvent")
Remotes.UpdateDogCoins.Name = "UpdateDogCoins"
Remotes.UpdateDogCoins.Parent = ReplicatedStorage

Remotes.NewDogAlert = Instance.new("RemoteEvent")
Remotes.NewDogAlert.Name = "NewDogAlert"
Remotes.NewDogAlert.Parent = ReplicatedStorage

-- Adoption Center
Remotes.GetAdoptionDogs = Instance.new("RemoteFunction")
Remotes.GetAdoptionDogs.Name = "GetAdoptionDogs"
Remotes.GetAdoptionDogs.Parent = ReplicatedStorage

Remotes.BuyDog = Instance.new("RemoteFunction")
Remotes.BuyDog.Name = "BuyDog"
Remotes.BuyDog.Parent = ReplicatedStorage

Remotes.AdoptionCenterRestocked = Instance.new("RemoteEvent")
Remotes.AdoptionCenterRestocked.Name = "AdoptionCenterRestocked"
Remotes.AdoptionCenterRestocked.Parent = ReplicatedStorage

-- Dog Requests
Remotes.DogRequestUpdate = Instance.new("RemoteEvent")
Remotes.DogRequestUpdate.Name = "DogRequestUpdate"
Remotes.DogRequestUpdate.Parent = ReplicatedStorage

Remotes.CompleteDogRequest = Instance.new("RemoteFunction")
Remotes.CompleteDogRequest.Name = "CompleteDogRequest"
Remotes.CompleteDogRequest.Parent = ReplicatedStorage

return Remotes
