local AssetLoader = {}

function AssetLoader.loadAsset(assetId)
    local ok, result = pcall(function()
        return game:GetObjects("rbxassetid://" .. assetId)[1]
    end)
    if ok and result then
        return result
    else
        warn("Failed to load asset with ID " .. assetId .. ": " .. tostring(result))
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

