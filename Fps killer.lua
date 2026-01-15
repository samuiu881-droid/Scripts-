-- V3 Nuclear - Máximo brainrot
for i = 1, 500 do  -- Spam inicial brutal
    local explosion = Instance.new("Explosion")
    explosion.BlastPressure = 0
    explosion.BlastRadius = 0
    explosion.Position = Vector3.new(math.random(-1000,1000), 100, math.random(-1000,1000))
    explosion.Parent = workspace
end

-- + partículas infinitas en skybox
local skyPart = Instance.new("Part")
skyPart.Size = Vector3.new(1,1,1)
skyPart.Transparency = 1
skyPart.Anchored = true
skyPart.Position = Vector3.new(0, 1000, 0)
skyPart.Parent = workspace

local megaPE = Instance.new("ParticleEmitter")
megaPE.Texture = "rbxassetid://243098098"  -- Algo bien tóxico
megaPE.Rate = 10000  -- INSANO
megaPE.Lifetime = NumberRange.new(1,3)
megaPE.Speed = NumberRange.new(100,200)
megaPE.Enabled = true
megaPE.Parent = skyPart
