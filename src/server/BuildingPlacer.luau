local Workspace = game:GetService("Workspace")

local buildings = Workspace:WaitForChild("GameBuildings")

local function place(modelName, primaryPartName, cframe)
    local model = buildings:FindFirstChild(modelName)
    if not model then
        return
    end
    local primary = model:FindFirstChild(primaryPartName)
    if primary then
        model.PrimaryPart = primary
        model:SetPrimaryPartCFrame(cframe)
    end
end

place("AdoptionCenter", "Wall1", CFrame.new(0, 5, 0))
place("SnackMachine", "Body", CFrame.new(0, 3, 20))

return true
