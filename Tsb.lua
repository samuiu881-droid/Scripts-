local Players = game:GetService("Players")
local player = Players.LocalPlayer

local function addVisuals(char)
    if not char then return end
    
    local torso = char:WaitForChild("UpperTorso")
    local rightHand = char:WaitForChild("RightHand")
    
    -- Shuriken roja neón detrás de la espalda
    local shuriken = Instance.new("MeshPart")
    shuriken.Name = "NeonShuriken"
    shuriken.MeshId = "rbxassetid://157205818"  -- Mesh ID para shuriken (Metal Cog Shuriken)
    shuriken.Material = Enum.Material.Neon
    shuriken.Color = Color3.fromRGB(255, 0, 0)
    shuriken.Size = Vector3.new(1, 0.2, 1)  -- Ajusta el tamaño si es necesario
    shuriken.CanCollide = false
    shuriken.Anchored = false
    
    -- Posicionar detrás de la espalda
    shuriken.CFrame = torso.CFrame * CFrame.new(0, 0, -2.5) * CFrame.Angles(0, math.pi, 0)
    shuriken.Parent = char
    
    -- Weld a la espalda
    local shurikenWeld = Instance.new("WeldConstraint")
    shurikenWeld.Part0 = torso
    shurikenWeld.Part1 = shuriken
    shurikenWeld.Parent = shuriken
    
    -- Espada roja neón en la mano derecha
    local sword = Instance.new("MeshPart")
    sword.Name = "NeonSword"
    sword.MeshId = "rbxassetid://123418794"  -- Mesh ID para espada clásica
    sword.Material = Enum.Material.Neon
    sword.Color = Color3.fromRGB(255, 0, 0)
    sword.Size = Vector3.new(0.2, 4, 0.2)  -- Largo de espada, ajusta si quieres
    sword.CanCollide = false
    sword.Anchored = false
    
    -- Posicionar en la mano derecha (ajusta los offsets para que quede bien)
    sword.CFrame = rightHand.CFrame * CFrame.new(0, -1.5, 0) * CFrame.Angles(math.pi / 2, 0, 0)
    sword.Parent = char
    
    -- Weld a la mano
    local swordWeld = Instance.new("WeldConstraint")
    swordWeld.Part0 = rightHand
    swordWeld.Part1 = sword
    swordWeld.Parent = sword
end

-- Aplicar al personaje actual
if player.Character then
    addVisuals(player.Character)
end

-- Reaplicar al respawnear
player.CharacterAdded:Connect(addVisuals)
