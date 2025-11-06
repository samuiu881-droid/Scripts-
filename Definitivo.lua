local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- === CONFIGURACIÓN ===
local SHURIKEN_SIZE = 1.8
local SPIN_SLOW_SPEED = 0.3  -- Velocidad de giro constante
local SPIN_BURST_MIN = 5    -- Segundos mínimo entre giros fuertes
local SPIN_BURST_MAX = 10   -- Segundos máximo
local PARTICLE_RATE = 15
local PULSE_BRIGHTNESS = 8

-- === BUSCAR PARTES (TSB COMPATIBLE) ===
local function findBackPart(char)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and (string.find(v.Name:lower(), "torso") or string.find(v.Name:lower(), "upper") or v.Name == "HumanoidRootPart") then
            return v
        end
    end
    return char:FindFirstChild("HumanoidRootPart")
end

local function findRightHand(char)
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") and string.find(v.Name:lower(), "right") and (string.find(v.Name:lower(), "hand") or string.find(v.Name:lower(), "arm")) then
            return v
        end
    end
    return nil
end

-- === CREAR SHURIKEN ===
local function createShuriken(char)
    local back = findBackPart(char)
    if not back then return end

    if char:FindFirstChild("NeonShurikenV2") then char.NeonShurikenV2:Destroy() end

    local model = Instance.new("Model")
    model.Name = "NeonShurikenV2"
    model.Parent = char

    local center = Instance.new("Part")
    center.Size = Vector3.new(0.2, 0.2, 0.2)
    center.Transparency = 1
    center.CanCollide = false
    center.Anchored = false
    center.CFrame = back.CFrame * CFrame.new(0, 0, -2.2)
    center.Parent = model

    local weld = Instance.new("Weld")
    weld.Part0 = back
    weld.Part1 = center
    weld.C0 = CFrame.new(0, 0, -2.2)
    weld.Parent = center

    -- 8 Cuchillas
    local blades = {}
    for i = 1, 8 do
        local angle = i * math.pi * 2 / 8
        local blade = Instance.new("Part")
        blade.Size = Vector3.new(0.25, SHURIKEN_SIZE, 0.7)
        blade.Material = Enum.Material.Neon
        blade.Color = Color3.fromRGB(255, 0, 0)
        blade.CanCollide = false
        blade.Transparency = 0.2
        blade.Parent = model

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Wedge
        mesh.Scale = Vector3.new(1, 1, 1)
        mesh.Parent = blade

        local offset = Vector3.new(math.cos(angle) * 1.4, 0, math.sin(angle) * 1.4)
        blade.CFrame = center.CFrame * CFrame.new(offset) * CFrame.Angles(0, angle, math.rad(90))

        local bweld = Instance.new("Weld")
        bweld.Part0 = center
        bweld.Part1 = blade
        bweld.C0 = CFrame.new(offset) * CFrame.Angles(0, angle, math.rad(90))
        bweld.Parent = blade

        -- Luz
        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255, 50, 50)
        light.Brightness = 3
        light.Range = 16
        light.Parent = blade

        table.insert(blades, blade)
    end

    -- === GIRO LENTO CONSTANTE ===
    RunService.Heartbeat:Connect(function(dt)
        if not center or not center.Parent then return end
        center.CFrame = center.CFrame * CFrame.Angles(0, math.rad(SPIN_SLOW_SPEED), 0)
    end)

    -- === GIRO FUERTE ALEATORIO + PULSO + SONIDO ===
    spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://1835347533"  -- Sonido futurista
        sound.Volume = 0.6
        sound.Parent = center

        while model and model.Parent do
            task.wait(math.random(SPIN_BURST_MIN, SPIN_BURST_MAX))

            -- Sonido
            sound:Play()

            -- Pulso
            for _, blade in pairs(blades) do
                local light = blade:FindFirstChild("PointLight")
                if light then
                    TweenService:Create(light, TweenInfo.new(0.3), {Brightness = PULSE_BRIGHTNESS}):Play()
                    delay(0.3, function()
                        TweenService:Create(light, TweenInfo.new(0.5), {Brightness = 3}):Play()
                    end)
                end
                TweenService:Create(blade, TweenInfo.new(0.2), {Transparency = 0.05}):Play()
                delay(0.2, function()
                    TweenService:Create(blade, TweenInfo.new(0.4), {Transparency = 0.2}):Play()
                end)
            end

            -- Giro fuerte
            local tween = TweenService:Create(center, TweenInfo.new(1.4, Enum.EasingStyle.Linear), {
                CFrame = center.CFrame * CFrame.Angles(0, math.rad(1080), 0)
            })
            tween:Play()
            tween.Completed:Wait()
        end
    end)

    -- === PARTÍCULAS ROJAS ===
    local attachment = Instance.new("Attachment")
    attachment.Parent = center

    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://241353019"  -- Partícula de fuego rojo
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    particles.Size = NumberSequence.new(0.3, 0)
    particles.Transparency = NumberSequence.new(0.3, 1)
    particles.Lifetime = NumberRange.new(0.8, 1.5)
    particles.Rate = PARTICLE_RATE
    particles.Speed = NumberRange.new(2, 5)
    particles.SpreadAngle = Vector2.new(360, 360)
    particles.VelocitySpread = 30
    particles.Parent = attachment

    return model
end

-- === CREAR ESPADA ===
local function createSword(char)
    local hand = findRightHand(char)
    if not hand then return end

    if char:FindFirstChild("NeonKatana") then char.NeonKatana:Destroy() end

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.3, 3.8, 0.3)
    handle.Material = Enum.Material.Neon
    handle.Color = Color3.fromRGB(255, 0, 0)
    handle.Transparency = 0.15
    handle.CanCollide = false
    handle.Parent = char

    handle.CFrame = hand.CFrame * CFrame.new(0, -2.1, 0) * CFrame.Angles(math.rad(90), 0, 0)

    local weld = Instance.new("Weld")
    weld.Part0 = hand
    weld.Part1 = handle
    weld.C0 = CFrame.new(0, -2.1, 0) * CFrame.Angles(math.rad(90), 0, 0)
    weld.Parent = handle

    -- Hoja
    local blade = Instance.new("Part")
    blade.Size = Vector3.new(0.15, 4.8, 1.4)
    blade.Material = Enum.Material.Neon
    blade.Color = Color3.fromRGB(255, 0, 0)
    blade.Transparency = 0.1
    blade.CanCollide = false
    blade.CFrame = handle.CFrame * CFrame.new(0, 2.5, 0)
    blade.Parent = char

    local bweld = Instance.new("Weld")
    bweld.Part0 = handle
    bweld.Part1 = blade
    bweld.C0 = CFrame.new(0, 2.5, 0)
    bweld.Parent = blade

    -- Luz
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 80, 80)
    light.Brightness = 6
    light.Range = 16
    light.Parent = blade

    -- Partículas en espada
    local att = Instance.new("Attachment")
    att.CFrame = CFrame.new(0, 2, 0)
    att.Parent = blade

    local spark = Instance.new("ParticleEmitter")
    spark.Texture = "rbxassetid://363133218"
    spark.Color = ColorSequence.new(Color3.fromRGB(255, 100, 100))
    spark.Size = NumberSequence.new(0.2, 0)
    spark.Lifetime = NumberRange.new(0.4)
    spark.Rate = 20
    spark.Speed = NumberRange.new(1, 3)
    spark.Parent = att
end

-- === APLICAR VISUALES ===
local function applyVisuals()
    local char = player.Character or player.CharacterAdded:Wait()
    char:WaitForChild("HumanoidRootPart", 10)
    task.wait(3) -- TSB tarda

    createShuriken(char)
    createSword(char)
end

-- Ejecutar
applyVisuals()
player.CharacterAdded:Connect(function()
    task.wait(4)
    applyVisuals()
end)

print("NEON SHURIKEN + KATANA CARGADOS - DOMINA TSB")
