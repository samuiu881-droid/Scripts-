local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- === LIMPIAR ANTERIORES ===
local function clean(char)
    pcall(function()
        char.NeonShurikenAcc:Destroy()
        char.NeonSwordAcc:Destroy()
    end)
end

-- === CREAR SHURIKEN (SIEMPRE DETRÁS, ELEVADA, SHIFT LOCK OK) ===
local function createShuriken(char)
    local root = char:WaitForChild("HumanoidRootPart", 10)
    if not root then return end

    clean(char)

    local acc = Instance.new("Accessory")
    acc.Name = "NeonShurikenAcc"
    acc.Parent = char

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.1, 0.1, 0.1)
    handle.Transparency = 1
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = acc

    -- Weld dinámico que se actualiza con Shift Lock
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = root
    weld.Part1 = handle
    weld.Parent = handle

    -- Centro
    local center = Instance.new("Part")
    center.Size = Vector3.new(0.6, 0.6, 0.1)
    center.Material = Enum.Material.Neon
    center.Color = Color3.fromRGB(255, 0, 0)
    center.Transparency = 0.3
    center.CanCollide = false
    center.Massless = true
    center.Parent = handle

    local cWeld = Instance.new("WeldConstraint")
    cWeld.Part0 = handle
    cWeld.Part1 = center
    cWeld.Parent = center

    -- 8 Cuchillas
    for i = 1, 8 do
        local angle = i * math.pi * 2 / 8
        local blade = Instance.new("Part")
        blade.Size = Vector3.new(0.2, 1.8, 0.6)
        blade.Material = Enum.Material.Neon
        blade.Color = Color3.fromRGB(255, 0, 0)
        blade.Transparency = 0.3
        blade.CanCollide = false
        blade.Massless = true
        blade.Parent = handle

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Wedge
        mesh.Parent = blade

        local bWeld = Instance.new("WeldConstraint")
        bWeld.Part0 = center
        bWeld.Part1 = blade
        bWeld.Parent = blade

        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255, 50, 50)
        light.Brightness = 4
        light.Range = 14
        light.Parent = blade
    end

    -- === POSICIÓN DINÁMICA (SIEMPRE DETRÁS Y ELEVADA) ===
    RunService.Heartbeat:Connect(function()
        if not handle.Parent then return end
        local behind = -root.CFrame.LookVector * 2.5
        local up = root.CFrame.UpVector * 1.5
        handle.CFrame = root.CFrame * CFrame.new(behind + up)
    end)

    -- === GIRO LENTO ===
    spawn(function()
        while center.Parent do
            center.CFrame = center.CFrame * CFrame.Angles(0, math.rad(1), 0)
            task.wait()
        end
    end)

    -- === GIRO FUERTE + PULSO + SONIDO ===
    spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://131961136"
        sound.Volume = 0.4
        sound.Parent = center

        while acc.Parent do
            task.wait(math.random(5, 9))
            sound:Play()

            for _, p in pairs(acc:GetDescendants()) do
                if p:IsA("BasePart") and p ~= handle then
                    TweenService:Create(p, TweenInfo.new(0.2), {Transparency = 0.1}):Play()
                    task.wait(0.2)
                    TweenService:Create(p, TweenInfo.new(0.4), {Transparency = 0.3}):Play()
                end
            end

            local tween = TweenService:Create(center, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {
                CFrame = center.CFrame * CFrame.Angles(0, math.rad(1080), 0)
            })
            tween:Play()
            tween.Completed:Wait()
        end
    end)

    -- === PARTÍCULAS ===
    local att = Instance.new("Attachment")
    att.Parent = center
    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://241353019"
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    particles.Size = NumberSequence.new(0.3, 0)
    particles.Transparency = NumberSequence.new(0.4, 1)
    particles.Lifetime = NumberRange.new(0.8, 1.4)
    particles.Rate = 12
    particles.Speed = NumberRange.new(2, 4)
    particles.Parent = att
end

-- === CREAR ESPADA (FORMA PERFECTA, SHIFT LOCK OK) ===
local function createSword(char)
    local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
    if not rightArm then return end

    clean(char)

    local acc = Instance.new("Accessory")
    acc.Name = "NeonSwordAcc"
    acc.Parent = char

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.3, 1.2, 0.3)
    handle.Material = Enum.Material.Neon
    handle.Color = Color3.fromRGB(255, 0, 0)
    handle.Transparency = 0.3
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = acc

    -- Weld dinámico a mano derecha
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = rightArm
    weld.Part1 = handle
    weld.Parent = handle

    -- Hoja con mesh de katana
    local blade = Instance.new("Part")
    blade.Size = Vector3.new(0.1, 5, 1.2)
    blade.Material = Enum.Material.Neon
    blade.Color = Color3.fromRGB(255, 0, 0)
    blade.Transparency = 0.15
    blade.CanCollide = false
    blade.Massless = true
    blade.Parent = acc

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://123418794"
    mesh.Scale = Vector3.new(0.8, 1, 0.8)
    mesh.Parent = blade

    local bWeld = Instance.new("WeldConstraint")
    bWeld.Part0 = handle
    bWeld.Part1 = blade
    bWeld.Parent = blade

    -- Posición dinámica en mano
    RunService.Heartbeat:Connect(function()
        if not handle.Parent then return end
        local forward = rightArm.CFrame.LookVector
        local down = -rightArm.CFrame.UpVector
        handle.CFrame = rightArm.CFrame * CFrame.new(0, -1.2, 0) * CFrame.Angles(math.rad(90), 0, 0)
        blade.CFrame = handle.CFrame * CFrame.new(0, 2.6, 0)
    end)

    -- Luz
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 80, 80)
    light.Brightness = 6
    light.Range = 16
    light.Parent = blade

    -- Partículas
    local att = Instance.new("Attachment")
    att.CFrame = CFrame.new(0, 2.5, 0)
    att.Parent = blade
    local sparks = Instance.new("ParticleEmitter")
    sparks.Texture = "rbxassetid://363133218"
    sparks.Color = ColorSequence.new(Color3.fromRGB(255, 100, 100))
    sparks.Size = NumberSequence.new(0.2, 0)
    sparks.Lifetime = NumberRange.new(0.5)
    sparks.Rate = 20
    sparks.Speed = NumberRange.new(1, 3)
    sparks.Parent = att
end

-- === APLICAR ===
local function apply()
    local char = player.Character or player.CharacterAdded:Wait()
    char:WaitForChild("HumanoidRootPart", 10)
    task.wait(4)
    createShuriken(char)
    createSword(char)
end

apply()
player.CharacterAdded:Connect(function()
    task.wait(5)
    apply()
end)

print("SHURIKEN + ESPADA NEÓN - SHIFT LOCK 100% COMPATIBLE")
