local size = Vector3.new(25, 25, 25)
local visualSize = Vector3.new(5, 5, 5)
local rep = game.ReplicatedStorage.Assets.Hitboxes
for i, v in pairs(rep:GetChildren()) do
    v.Part.Size = size
end

while task.wait(0.1) do
    for i, v in pairs(game.Workspace:GetChildren()) do
        if v.Name:find("CLIENT") then
            v:GetChildren()[1].Size = visualSize
        end
    end
end
