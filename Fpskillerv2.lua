-- ASYMMETRIC FPS KILLER - Intenta laggear más a otros (no 100% inmune tú)
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local LAGGY_TEXTURES = {
    "rbxassetid://241353936", -- heavy sparkle
    "rbxassetid://243660364", -- smoke heavy
    "rbxassetid://243098098"  -- fire
}

local function createFarLagPart()
    local pos = Vector3.new(
        math.random(-5000, 5000),
        5000 + math.random(1000, 3000),  -- muy alto en el sky
        math.random(-5000, 5000)
    )
    local part = Instance.new("Part")
    part.Size = Vector3.new(0.1,0.1,0.1)
    part.Transparency = 1
    part.Anchored = true
    part.CanCollide = false
    part.Position = pos
    part.Parent = workspace
    Debris:AddItem(part, 12)
    
    local pe = Instance.new("ParticleEmitter")
    pe.Texture = LAGGY_TEXTURES[math.random(1, #LAGGY_TEXTURES)]
    pe.Rate = 3000  -- alto rate
    pe.Lifetime = NumberRange.new(15, 25)  -- duran mucho
    pe.Speed = NumberRange.new(10, 30)
    pe.SpreadAngle = Vector2.new(360, 360)
    pe.Size = NumberSequence.new{NumberSequenceKeypoint.new(0,8), NumberSequenceKeypoint.new(1,15)}
    pe.Enabled = true
    pe.Parent = part
end

local function lagOthers()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= localPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            for i = 1, 150 do  -- partículas pegadas a ellos
                local att = Instance.new("Attachment")
                att.Position = Vector3.new(math.random(-3,3), math.random(-5,5), math.random(-3,3))
                att.Parent = hrp
                
                local pe = Instance.new("ParticleEmitter")
                pe.Texture = LAGGY_TEXTURES[math.random(1,#LAGGY_TEXTURES)]
                pe.Rate = 1500
                pe.Lifetime = NumberRange.new(8,12)
                pe.Speed = NumberRange.new(20,50)
                pe.Size = NumberSequence.new(6,12)
                pe.Enabled = true
                pe.Parent = att
                Debris:AddItem(pe, 15)
                Debris:AddItem(att, 15)
            end
        end
    end
end

-- Spam sky lejano (menos visible para ti si miras abajo)
spawn(function()
    while true do
        for i = 1, 300 do
            createFarLagPart()
        end
        wait(0.3)  -- ajusta, más bajo = más caos
    end
end)

-- Spam en otros jugadores
spawn(function()
    while true do
        lagOthers()
        wait(1.5)  -- no spamees cada frame pa no crashear tú también
    end
end)

print("Asymmetric FPS killer ON - Sky spam + target others. Aléjate y mira al suelo pa menos lag tuyo 💀")
