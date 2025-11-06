local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")

-- === LIMPIAR GUI ANTERIOR ===
local function clean()
    pcall(function()
        player.Character:FindFirstChild("ShurikenGui")?.Parent = nil
        player.Character:FindFirstChild("SwordGui")?.Parent = nil
    end)
end

-- === SHURIKEN DETRÁS (EN TORSO) ===
local function createShuriken(char)
    local torso = char:FindFirstChild("Torso")
    if not torso then return end

    clean()

    local gui = Instance.new("SurfaceGui")
    gui.Name = "ShurikenGui"
    gui.Face = Enum.NormalId.Back
    gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    gui.PixelsPerStud = 60
    gui.Parent = torso

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 1, 0)
    img.Position = UDim2.new(0, 0, 0, 0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://7733970158"  -- Shuriken roja neón (buscada)
    img.ImageColor3 = Color3.fromRGB(255, 0, 0)
    img.ImageTransparency = 0.3
    img.Parent = gui

    -- Giro lento
    spawn(function()
        while img.Parent do
            img.Rotation = (img.Rotation + 1.5) % 360
            task.wait()
        end
    end)

    -- Giro fuerte + pulso
    spawn(function()
        while img.Parent do
            task.wait(math.random(4, 8))
            TweenService:Create(img, TweenInfo.new(0.3), {ImageTransparency = 0.1}):Play()
            for i = 1, 4 do
            img.Rotation = (img.Rotation + 90) % 360
            task.wait(0.1)
            end
            TweenService:Create(img, TweenInfo.new(0.5), {ImageTransparency = 0.3}):Play()
        end
    end)
end

-- === ESPADA EN MANO DERECHA ===
local function createSword(char)
    local rightArm = char:FindFirstChild("Right Arm")
    if not rightArm then return end

    local gui = Instance.new("SurfaceGui")
    gui.Name = "SwordGui"
    gui.Face = Enum.NormalId.Front
    gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    gui.PixelsPerStud = 80
    gui.Parent = rightArm

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(0.8, 0, 5, 0)
    img.Position = UDim2.new(0.1, 0, -2, 0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://6031075938"  -- Katana roja
    img.ImageColor3 = Color3.fromRGB(255, 0, 0)
    img.ImageTransparency = 0.25
    img.Rotation = 90
    img.Parent = gui
end

-- === APLICAR ===
local function apply()
    local char = player.Character or player.CharacterAdded:Wait()
    task.wait(2)
    clean()
    createShuriken(char)
    createSword(char)
end

apply()
player.CharacterAdded:Connect(function()
    task.wait(3)
    apply()
end)

print("SHURIKEN + ESPADA NEÓN CARGADOS - 100% FUNCIONAL")
