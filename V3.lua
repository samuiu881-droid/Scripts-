local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local function createAccessoryShuriken(char)
    local root = char:WaitForChild("HumanoidRootPart", 10)
    if not root then return end

    -- Limpiar viejos
    if char:FindFirstChild("NeonShurikenAcc") then char.NeonShurikenAcc:Destroy() end

    -- Crear Accessory para shuriken
    local acc = Instance.new("Accessory")
    acc.Name = "NeonShurikenAcc"
    acc.Parent = char

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.1, 0.1, 0.1)
    handle.Transparency = 1
    handle.CanCollide = false
    handle.Parent = acc

    -- Attachment en root para posición detrás
    local att0 = Instance.new("Attachment")
    att0.Name = "ShurikenAtt"
    att0.CFrame = CFrame.new(0, 0, -2.5) * CFrame.Angles(0, math.pi, 0)
    att0.Parent = root

    local att1 = Instance.new("Attachment")
    att1.CFrame = CFrame.new()
    att1.Parent = handle

    local weld = Instance.new("Weld")
    weld.Part0 = root
    weld.Part1 = handle
    weld.C0 = CFrame.new(0, 0, -2.5) * CFrame.Angles(0, math.pi, 0)
    weld.Parent = handle

    -- Centro shuriken
    local center = Instance.new("Part")
    center.Name = "Center"
    center.Size = Vector3.new(0.5, 0.5, 0.1)
    center.Material = Enum.Material.Neon
    center.Color = Color3.fromRGB(255, 0, 0)
    center.Transparency = 0.4
    center.CanCollide = false
    center.Parent = handle

    local centerWeld = Instance.new("Weld")
    centerWeld.Part0 = handle
    centerWeld.Part1 = center
    centerWeld.Parent = center

    -- 6 Cuchillas (más simple para evitar lag)
    for i = 1, 6 do
        local angle = (i - 1) * (math.pi * 2 / 6)
        local blade = Instance.new("Part")
        blade.Size = Vector3.new(0.2, 1.5, 0.5)
        blade.Material = Enum.Material.Neon
        blade.Color = Color3.fromRGB(255, 0, 0)
        blade.CanCollide = false
        blade.Parent = handle

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Wedge
        mesh.Parent = blade

        local offset = CFrame.new(math.cos(angle) * 1, 0, math.sin(angle) * 1) * CFrame.Angles(0, angle, math.rad(90))
        local bWeld = Instance.new("Weld")
        bWeld.Part0 = center
        bWeld.Part1 = blade
        bWeld.C0 = offset
        bWeld.Parent = blade

        -- Glow
        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255, 0, 0)
        light.Brightness = 4
        light.Range = 12
        light.Parent = blade
    end

    -- Giro lento
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not center.Parent then conn:Disconnect() return end
        center.CFrame = center.CFrame * CFrame.Angles(0, math.rad(0.5), 0)
    end)

    -- Giro burst + pulso
    spawn(function()
        while acc.Parent do
            task.wait(math.random(4, 8))
            -- Pulso
            for _, desc in pairs(acc:GetDescendants()) do
                if desc:IsA("BasePart") and desc ~= handle then
                    TweenService:Create(desc, TweenInfo.new(0.3), {Transparency = 0.1}):Play()
                    task.wait(0.3)
                    TweenService:Create(desc, TweenInfo.new(0.5), {Transparency = 0.4}):Play()
                end
            end
            -- Giro fuerte
            TweenService:Create(center, TweenInfo.new(1, Enum.EasingStyle.Linear), {CFrame = center.CFrame * CFrame.Angles(0, math.rad(720), 0)}):Play()
        end
    end)

    -- Partículas
    local att = Instance.new("Attachment")
    att.Parent = center
    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://241353019"
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    particles.Lifetime = NumberRange.new(1)
    particles.Rate = 10
    particles.Speed = NumberRange.new(3)
    particles.Parent = att

    -- Sonido
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://131961136"  -- Sonido energía
    sound.Volume = 0.5
    sound.Parent = center
    -- Reproduce en bursts
    spawn(function()
        while acc.Parent do
            task.wait(math.random(6, 12))
            sound:Play()
        end
    end)
end

local function createSword(char)
    local root = char:WaitForChild("HumanoidRootPart", 10)
    if not root then return end

    if char:FindFirstChild("NeonSwordAcc") then char.NeonSwordAcc:Destroy() end

    -- Buscar mano derecha mejorada
    local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand") or char:FindFirstChildOfClass("BasePart")
    if not rightArm then rightArm = root end  -- Fallback

    local acc = Instance.new("Accessory")
    acc.Name = "NeonSwordAcc"
    acc.Parent = char

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.2, 4, 0.2)
    handle.Material = Enum.Material.Neon
    handle.Color = Color3.fromRGB(255, 0, 0)
    handle.Transparency = 0.2
    handle.CanCollide = false
    handle.Parent = acc

    local att0 = Instance.new("Attachment")
    att0.CFrame = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(90), 0, 0)
    att0.Parent = rightArm

    local att1 = Instance.new("Attachment")
    att1.Parent = handle

    local weld = Instance.new("Weld")
    weld.Part0 = rightArm
    weld.Part1 = handle
    weld.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(90), 0, 0)
    weld.Parent = handle

    -- Hoja
    local blade = Instance.new("Part")
    blade.Size = Vector3.new(0.1, 5, 1)
    blade.Material = Enum.Material.Neon
    blade.Color = Color3.fromRGB(255, 0, 0)
    blade.Transparency = 0.1
    blade.CanCollide = false
    blade.Parent = acc

    local bWeld = Instance.new("Weld")
    bWeld.Part0 = handle
    bWeld.Part1 = blade
    bWeld.C0 = CFrame.new(0, 2.5, 0)
    bWeld.Parent = blade

    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 50, 50)
    light.Brightness = 5
    light.Range = 15
    light.Parent = blade

    -- Partículas espada
    local att = Instance.new("Attachment")
    att.CFrame = CFrame.new(0, 3, 0)
    att.Parent = blade
    local sparks = Instance.new("ParticleEmitter")
    sparks.Texture = "rbxassetid://363133218"
    sparks.Color = ColorSequence.new(Color3.fromRGB(255, 100, 100))
    sparks.Lifetime = NumberRange.new(0.5)
    sparks.Rate = 15
    sparks.Speed = NumberRange.new(2)
    sparks.Parent = att
end

local function apply()
    local char = player.Character
    if not char then return end
    task.wait(5)  -- Más espera para TSB

    createAccessoryShuriken(char)
    createSword(char)
end

apply()
player.CharacterAdded:Connect(function()
    task.wait(6)
    apply()
end)

print("SCRIPT NEÓN CARGADO - Revisa debug si no ves nada")
