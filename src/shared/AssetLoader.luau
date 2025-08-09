local InsertService = game:GetService("InsertService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AssetsFolder = ReplicatedStorage:WaitForChild("LoadedAssets")

local AssetLoader = {}

function AssetLoader.loadAsset(assetId)
    local numericId = tonumber(assetId)
    if not numericId then
        warn("Invalid asset ID " .. tostring(assetId))
        return nil
    end

    if RunService:IsServer() then
        local existing = AssetsFolder:FindFirstChild(tostring(assetId))
        if existing then
            return existing:Clone()
        end

        local ok, model = pcall(function()
            return InsertService:LoadAsset(numericId)
        end)
        if ok and model then
            local obj = model:GetChildren()[1]
            if obj then
                obj.Name = tostring(assetId)
                obj.Parent = AssetsFolder
                return obj:Clone()
            end
        else
            local msg = tostring(model)
            warn("Failed to load asset with ID " .. tostring(assetId) .. ": " .. msg)
            if msg:find("not authorized") then
                warn("Ensure the asset is public or that this experience has permission to use it.")
            end
            return nil
        end
        warn("Failed to load asset with ID " .. tostring(assetId))
        return nil
    else
        local asset = AssetsFolder:FindFirstChild(tostring(assetId))
        if not asset then
            local loadRemote = ReplicatedStorage:WaitForChild("LoadAsset")
            local ok, loaded = pcall(function()
                return loadRemote:InvokeServer(assetId)
            end)
            if ok and loaded then
                asset = AssetsFolder:WaitForChild(tostring(assetId), 5)
                if not asset then
                    warn("Failed to load asset with ID " .. tostring(assetId))
                    return nil
                end
            else
                warn("Failed to load asset with ID " .. tostring(assetId))
                return nil
            end
        end
        return asset and asset:Clone() or nil
    end
end

function AssetLoader.loadGui(assetId, parent)
    local gui = AssetLoader.loadAsset(assetId)
    if gui then
        gui.Parent = parent
        return gui
    end
    return nil
end

return AssetLoader

