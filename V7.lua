local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- === LIMPIAR EFECTOS ANTERIORES ===
local function cleanEffects()
    pcall(function()
        player.Character:FindFirstChild("NeonShurikenEffect")?.Parent = nil
        player.Character:FindFirstChild("NeonSwordEffect")?.Parent = nil
    end)
end

-- === SHURIKEN NEÓN ROJO (EFECTO DETRÁS) ===
local function createShurikenEffect(char)
    local head = char:FindFirstChild("Head")
    if not head then return end

    cleanEffects()

    local effect = Instance.new("BillboardGui")
    effect.Name = "NeonShurikenEffect"
    effect.Adornee = head
    effect.Size = UDim2.new(3, 0, 3, 0)
    effect.StudsOffset = Vector3.new(0, 1.5, -3)  -- Detrás + elevada
    effect.AlwaysOnTop = true
    effect.LightInfluence = 0
    effect.Parent = char

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundTransparency = 1
    frame.Parent = effect

    -- Imagen de shuriken (roja neón)
    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://1835347533"  -- Icono rojo brillante (puedes cambiar)
    img.ImageColor3 = Color3.fromRGB(255, 0, 0)
    img.ImageTransparency = 0.3
    img.Parent = frame

    -- Giro lento
    spawn(function()
        while effect.Parent do
            img.Rotation = img.Rotation + 1.5
            task.wait()
        end
    end)

    -- Giro fuerte + pulso
    spawn(function()
        while effect.Parent do
            task.wait(math.random(5, 9))
            TweenService:Create(img, TweenInfo.new(0.3), {ImageTransparency = 0.1}):Play()
            for i = 1, 3 do
                img.Rotation = img.Rotation + 120
                task.wait(0.1)
            end
            TweenService:Create(img, TweenInfo.new(0.5), {ImageTransparency = 0.3}):Play()
        end
    end)

    -- Partículas rojas detrás
    local att = Instance.new("Attachment")
    att.CFrame = CFrame.new(0, 1.5, -3)
    att.Parent = head

    local particles = Instance.new("ParticleEmitter")
    particles.Texture = "rbxassetid://241353019"
    particles.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    particles.Size = NumberSequence.new(0.4, 0)
    particles.Transparency = NumberSequence.new(0.4, 1)
    particles.Lifetime = NumberRange.new(1, 1.5)
    particles.Rate = 15
    particles.Speed = NumberRange.new(2, 4)
    particles.SpreadAngle = Vector2.new(60, 60)
    particles.Parent = att
end

-- === ESPADA NEÓN ROJO (EN MANO DERECHA) ===
local function createSwordEffect(char)
    local rightArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightHand")
    if not rightArm then return end

    local effect = Instance.new("BillboardGui")
    effect.Name = "NeonSwordEffect"
    effect.Adornee = rightArm
    effect.Size = UDim2.new(1, 0, 5, 0)
    effect.StudsOffset = Vector3.new(0, -2, 0)
    effect.AlwaysOnTop = true
    effect.LightInfluence = 0
    effect.Parent = char

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://6031075938"  -- Icono de katana
    img.ImageColor3 = Color3.fromRGB(255, 0, 0)
    img.ImageTransparency = 0.2
    img.Rotation = 90
    img.Parent = effect

    -- Partículas en la punta
    local att = Instance.new("Attachment")
    att.CFrame = CFrame.new(0, -4.5, 0)
    att.Parent = rightArm

    local sparks = Instance.new("ParticleEmitter")
    sparks.Texture = "rbxassetid://363133218"
    sparks.Color = ColorSequence.new(Color3.fromRGB(255, 100, 100))
    sparks.Size = NumberSequence.new(0.2, 0)
    sparks.Transparency = NumberSequence.new(0.3, 1)
    sparks.Lifetime = NumberRange.new(0.5)
    sparks.Rate = 25
    sparks.Speed = NumberRange.new(1, 3)
    sparks.Parent = att
end

-- === APLICAR ===
local function apply()
    local char = player.Character or player.CharacterAdded:Wait()
    char:WaitForChild("Head", 10)
    char:WaitForChild("HumanoidRootPart", 10)
    task.wait(3)
    cleanEffects()
    createShurikenEffect(char)
    createSwordEffect(char)
end

apply()
player.CharacterAdded:Connect(function()
    task.wait(4)
    apply()
end)

print("VISUALES NEÓN ACTIVADOS - 100% VISIBLES, SIN BLOQUEO")
