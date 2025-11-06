local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local function clean(char)
    pcall(function()
        char:FindFirstChild("ShurikenAcc")?.:Destroy()
        char:FindFirstChild("SwordAcc")?.:Destroy()
    end)
end

local function createShuriken(char)
    local torso = char:WaitForChild("Torso", 5)
    if not torso then return end
    clean(char)

    -- Accessory para shuriken
    local acc = Instance.new("Accessory")
    acc.Name = "ShurikenAcc"
    acc.Parent = char

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.1, 0.1, 0.1)
    handle.Transparency = 1
    handle.CanCollide = false
    handle.Parent = acc

    -- Attachment en Torso (R6) - DETRÁS + ELEVADA
    local att0 = Instance.new("Attachment")
    att0.CFrame = CFrame.new(0, 0.5, -2) * CFrame.Angles(0, math.pi, 0)
    att0.Parent = torso

    local att1 = Instance.new("Attachment")
    att1.Parent = handle

    -- Weld
    local weld = Instance.new("Weld")
    weld.Part0 = torso
    weld.Part1 = handle
    weld.C0 = CFrame.new(0, 0.5, -2) * CFrame.Angles(0, math.pi, 0)
    weld.Parent = handle

    -- Centro neón
    local center = Instance.new("Part")
    center.Name = "Center"
    center.Size = Vector3.new(0.8, 0.8, 0.15)
    center.Material = Enum.Material.Neon
    center.Color = Color3.fromRGB(255, 0, 0)
    center.Transparency = 0.4
    center.CanCollide = false
    center.Parent = handle

    local cweld = Instance.new("Weld")
    cweld.Part0 = handle
    cweld.Part1 = center
    cweld.Parent = center

    -- 8 Cuchillas estrella (como tu imagen)
    for i = 1, 8 do
        local angle = (i-1) * (math.pi*2/8)
        local blade = Instance.new("Part")
        blade.Size = Vector3.new(0.25, 2, 0.6)
        blade.Material = Enum.Material.Neon
        blade.Color = Color3.fromRGB(255, 0, 0)
        blade.Transparency = 0.3
        blade.CanCollide = false
        blade.Parent = handle

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Wedge
        mesh.Scale = Vector3.new(1,1,1)
        mesh.Parent = blade

        local offset = CFrame.new(math.cos(angle)*1.2, 0, math.sin(angle)*1.2) * CFrame.Angles(0, angle + math.pi/2, 0)
        local bweld = Instance.new("Weld")
        bweld.Part0 = center
        bweld.Part1 = blade
        bweld.C0 = offset
        bweld.Parent = blade

        -- Glow
        local light = Instance.new("PointLight")
        light.Color = Color3.fromRGB(255,50,50)
        light.Brightness = 5
        light.Range = 15
        light.Parent = blade
    end

    -- Giro lento
    spawn(function()
        while acc.Parent do
            center.CFrame = center.CFrame * CFrame.Angles(0, math.rad(2), 0)
            task.wait()
        end
    end)

    -- Burst giro + pulso
    spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://131961136"
        sound.Volume = 0.5
        sound.Parent = center
        while acc.Parent do
            task.wait(math.random(4,8))
            sound:Play()
            for _,p in pairs(acc:GetDescendants()) do
                if p:IsA("BasePart") and p ~= handle then
                    TweenService:Create(p, TweenInfo.new(0.3),{Transparency=0.1}):Play()
                    task.spawn(function() task.wait(0.5); TweenService:Create(p, TweenInfo.new(0.4),{Transparency=0.3}):Play() end)
                end
            end
            TweenService:Create(center, TweenInfo.new(1.5,Enum.EasingStyle.Linear),{CFrame=center.CFrame * CFrame.Angles(0,math.rad(1440),0)}):Play()
            task.wait(1.5)
        end
    end)

    -- Partículas
    local att = Instance.new("Attachment")
    att.Parent = center
    local parts = Instance.new("ParticleEmitter")
    parts.Texture = "rbxassetid://241353019"
    parts.Color = ColorSequence.new(Color3.fromRGB(255,0,0))
    parts.Lifetime = NumberRange.new(1)
    parts.Rate = 15
    parts.Speed = NumberRange.new(3)
    parts.Parent = att
end

local function createSword(char)
    local rightArm = char:WaitForChild("Right Arm", 5)
    if not rightArm then return end

    local acc = Instance.new("Accessory")
    acc.Name = "SwordAcc"
    acc.Parent = char

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.3,1.2,0.3)
    handle.Material = Enum.Material.Neon
    handle.Color = Color3.fromRGB(255,0,0)
    handle.Transparency = 0.3
    handle.CanCollide = false
    handle.Parent = acc

    -- Posición en mano derecha R6
    local weld = Instance.new("Weld")
    weld.Part0 = rightArm
    weld.Part1 = handle
    weld.C0 = CFrame.new(0,-1,0) * CFrame.Angles(math.rad(90),0,0)
    weld.Parent = handle

    -- Hoja espada
    local blade = Instance.new("Part")
    blade.Size = Vector3.new(0.2,5,1)
    blade.Material = Enum.Material.Neon
    blade.Color = Color3.fromRGB(255,0,0)
    blade.Transparency = 0.2
    blade.CanCollide = false
    blade.Parent = acc

    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = "rbxassetid://123418794"  -- Espada mesh
    mesh.Scale = Vector3.new(1,1.2,0.8)
    mesh.Parent = blade

    local bweld = Instance.new("Weld")
    bweld.Part0 = handle
    bweld.Part1 = blade
    bweld.C0 = CFrame.new(0,2.5,0)
    bweld.Parent = blade

    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255,80,80)
    light.Brightness = 6
    light.Range = 18
    light.Parent = blade

    -- Chispas
    local att = Instance.new("Attachment")
    att.CFrame = CFrame.new(0,3,0)
    att.Parent = blade
    local sparks = Instance.new("ParticleEmitter")
    sparks.Texture = "rbxassetid://363133218"
    sparks.Color = ColorSequence.new(Color3.fromRGB(255,100,100))
    sparks.Rate = 25
    sparks.Lifetime = NumberRange.new(0.6)
    sparks.Speed = NumberRange.new(2)
    sparks.Parent = att
end

local function apply()
    local char = player.Character or player.CharacterAdded:Wait()
    task.wait(2)
    clean(char)
    createShuriken(char)
    createSword(char)
    print("¡SHURIKEN ROJA NEÓN + ESPADA CARGADAS EN R6 TSB!")
end

apply()
player.CharacterAdded:Connect(apply)
