local InsertService = game:GetService("InsertService")
local RunService = game:GetService("RunService")

local AssetLoader = {}

function AssetLoader.loadAsset(assetId)
    local numericId = tonumber(assetId)
    if not numericId then
        warn("Invalid asset ID " .. tostring(assetId))
        return nil
    end

    local ok, result = pcall(function()
        if RunService:IsServer() then
            local model = InsertService:LoadAsset(numericId)
            return model and model:GetChildren()[1]
        else
            return require(numericId)
        end
    end)

    if ok and result then
        return result
    else
        warn("Failed to load asset with ID " .. tostring(assetId) .. ": " .. tostring(result))

        return nil
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

