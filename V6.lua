local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- === LIMPIAR ===
local function clean(char)
    pcall(function()
        char:FindFirstChild("NeonShurikenModel")?.Parent = nil
        char:FindFirstChild("NeonSwordModel")?.Parent = nil
    end)
end

-- === SHURIKEN (DETÁS + ELEVADA) ===
local function createShuriken(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    clean(char)

    local model = Instance.new("Model")
    model.Name = "NeonShurikenModel"
    model.Parent = char

    -- Handle (invisible)
    local handle = Instance.new("Part")
    handle.Size = Vector3.new(0.1, 0.1, 0.1)
    handle.Transparency = 1
    handle.CanCollide = false
    handle.Anchored = false
    handle.Massless = true
    handle.Parent = model

    -- Attachment en Root
    local rootAtt = Instance.new("Attachment")
    rootAtt.Name = "ShurikenRootAtt"
    rootAtt.CFrame = CFrame.new(0, 1.5, -2.5)  -- Detrás + elevada
    rootAtt.Parent = root

    -- Attachment en Handle
    local handleAtt = Instance.new("Attachment")
    handleAtt.Parent = handle

    -- AlignPosition + AlignOrientation
    local ap = Instance.new("AlignPosition")
    ap.Attachment0 = rootAtt
    ap.Attachment1 = handleAtt
    ap.Responsiveness = 200
    ap.MaxForce = math.huge
    ap.Parent = handle

    local ao = Instance.new("AlignOrientation")
    ao.Attachment0 = rootAtt
    ao.Attachment1 = handleAtt
    ao.Responsiveness = 200
    ao.MaxTorque = math.huge
    ao.CFrame = CFrame.Angles(0, math.pi, 0)
    ao.Parent = handle

    -- Centro
    local center = Instance.new("Part")
    center.Size = Vector3.new(0.8, 0.8, 0.1)
    center.Material = Enum.Material.Neon
    center.Color = Color3.fromRGB(255, 0, 0)
    center.Transparency = 0.3
    center.CanCollide = false
    center.Massless = true
    center.Parent = model

    local centerWeld = Instance.new("WeldConstraint")
    centerWeld.Part0 = handle
    centerWeld.Part1 = center
    centerWeld.Parent = center

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
        blade.Parent = model

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Wedge
        mesh.Parent = blade

        local offset = CFrame.new(math.cos(angle) * 1.1, 0, math.sin(angle) * 1.1) * CFrame.Angles(0, angle, math.rad(90))
        local bWeld = Instance.new("WeldConstraint")
        bWeld.Part0 = center
        bWeld.Part1 = blade
        bWeld.Parent = blade
        blade.CFrame = center.CFrame * offset

        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255, 50, 50)
        light.Brightness = 4
        light.Range = 14
        light.Parent = blade
    end

    -- === GIRO LENTO (solo centro) ===
    spawn(function()
        while center and center.Parent do
            center.CFrame = center.CFrame * CFrame.Angles(0, math.rad(1.2), 0)
            task.wait()
        end
    end)

    -- === GIRO FUERTE + PULSO + SONIDO ===
    spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://131961136"
        sound.Volume = 0.4
        sound.Parent = center

        while model.Parent do
            task.wait(math.random(5, 9))
            sound:Play()

            for _, p in pairs(model:GetDescendants()) do
                if p:IsA("BasePart") and p.Name ~= "Handle" then
                    pcall(function()
                        game:GetService("TweenService"):Create(p, TweenInfo.new(0.2), {Transparency = 0.1}):Play()
                    end)
                    task.wait(0.2)
                    pcall(function()
                        game:GetService("TweenService"):Create(p, TweenInfo.new(0.4), {Transparency = 0.3}):Play()
                    end)
                end
            end

            local start = center.CFrame
            local goal = start * CFrame.Angles(0, math.rad(1080), 0)
            pcall(function()
                game:GetService("TweenService"):Create(center, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {CFrame = goal}):Play()
            end)
            task.wait(1.2)
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

-- === ESPADA EN MANO DERECHA ===
local function createSword(char)
    local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
    if not rightArm then return end

    local model = Instance.new("Model")
    model.Name = "NeonSwordModel"
    model.Parent = char

    local handle = Instance.new("Part")
    handle.Size = Vector3.new(0.3, 1.2, 0.3)
    handle.Material = Enum.Material.Neon
    handle.Color = Color3.fromRGB(255, 0, 0)
    handle.Transparency = 0.3
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = model

    local armAtt = Instance.new("Attachment")
    armAtt.CFrame = CFrame.new(0, -1.2, 0) * CFrame.Angles(math.rad(90), 0, 0)
    armAtt.Parent = rightArm

    local handleAtt = Instance.new("Attachment")
    handleAtt.Parent = handle

    local ap = Instance.new("AlignPosition")
    ap.Attachment0 = armAtt
    ap.Attachment1 = handleAtt
    ap.Responsiveness = 200
    ap.MaxForce = math.huge
    ap.Parent = handle

    local ao = Instance.new("AlignOrientation")
    ao.Attachment0 = armAtt
    ao.Attachment1 = handleAtt
    ao.Responsiveness = 200
    ao.MaxTorque = math.huge
    ao.Parent = handle

    -- Hoja
    local blade = Instance.new("Part")
    blade.Size = Vector3.new(0.1, 5, 1.2)
    blade.Material = Enum.Material.Neon
    blade.Color = Color3.fromRGB(255, 0, 0)
    blade.Transparency = 0.15
    blade.CanCollide = false
    blade.Massless = true
    blade.Parent = model

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://123418794"
    mesh.Scale = Vector3.new(0.8, 1, 0.8)
    mesh.Parent = blade

    local bWeld = Instance.new("WeldConstraint")
    bWeld.Part0 = handle
    bWeld.Part1 = blade
    bWeld.Parent = blade
    blade.CFrame = handle.CFrame * CFrame.new(0, 2.6, 0)

    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 80, 80)
    light.Brightness = 6
    light.Range = 16
    light.Parent = blade

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
    task.wait(3)
    clean(char)
    createShuriken(char)
    createSword(char)
end

apply()
player.CharacterAdded:Connect(function()
    task.wait(4)
    apply()
end)

print("VISUALES NEÓN ACTIVADOS - 100% SEGURO, SIN VOID")
