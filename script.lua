--// Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

--// SCP
local scp = workspace:FindFirstChild("SCP-173")
if not scp then return end
local root = scp:FindFirstChild("HumanoidRootPart")
if not root then return end

-- Salvar propriedades originais
local originalProps = {}
for _, part in pairs(scp:GetDescendants()) do
    if part:IsA("BasePart") then
        originalProps[part] = part.CustomPhysicalProperties
    end
end

--// Funções Massless
local function makeSCPLight()
    for _, part in pairs(scp:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.3, 0.5)
        end
    end
end

local function removeSCPLight()
    for part, prop in pairs(originalProps) do
        if part:IsA("BasePart") then
            part.CustomPhysicalProperties = prop
        end
    end
end

-- Variáveis de controle
local masslessEnabled = false
local teleportOn = false
local teleportInterval = 0.01
local lastTeleport = 70

-- CFrame de teleport
local respawnPoint = CFrame.new(
    -54.0734444, 250.284332, -195.964661,
    0.115476429, -5.41263852e-08, 0.993310213,
    1.1625267e-08, 1, 5.31394306e-08,
    -0.993310213, 0, 0.115476429
)

--// Criar GUI bonita
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "SCPControlGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0.5, -150, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

-- Gradiente de fundo
local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
}

-- Título
local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(1, -20, 0, 40)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔹 SCP Control Panel"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 24
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
titleLabel.TextStrokeTransparency = 0.5
titleLabel.TextScaled = true
titleLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Função para criar botões bonitos
local function createButton(parent, yPos, text)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 260, 0, 50)
    btn.Position = UDim2.new(0, 20, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 22
    btn.Text = text
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 15)

    -- Sombra
    local shadow = Instance.new("ImageLabel", btn)
    shadow.Size = UDim2.new(1, 10, 1, 10)
    shadow.Position = UDim2.new(0, -5, 0, -5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageTransparency = 0.7
    shadow.ZIndex = -1

    return btn
end

-- Botões
local masslessBtn = createButton(frame, 70, "Ativar Leveza")
local teleportBtn = createButton(frame, 140, "Ativar Teleport")

-- Hover effect
masslessBtn.MouseEnter:Connect(function()
    masslessBtn.BackgroundColor3 = masslessEnabled and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(50, 200, 255)
end)
masslessBtn.MouseLeave:Connect(function()
    masslessBtn.BackgroundColor3 = masslessEnabled and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(0, 170, 255)
end)

teleportBtn.MouseEnter:Connect(function()
    teleportBtn.BackgroundColor3 = teleportOn and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(50, 200, 255)
end)
teleportBtn.MouseLeave:Connect(function()
    teleportBtn.BackgroundColor3 = teleportOn and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(0, 170, 255)
end)

-- Toggle Massless
masslessBtn.MouseButton1Click:Connect(function()
    masslessEnabled = not masslessEnabled
    if masslessEnabled then
        makeSCPLight()
        masslessBtn.Text = "Desativar Leveza"
        masslessBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    else
        removeSCPLight()
        masslessBtn.Text = "Ativar Leveza"
        masslessBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end)

-- Toggle Teleport
teleportBtn.MouseButton1Click:Connect(function()
    teleportOn = not teleportOn
    teleportBtn.Text = teleportOn and "Desativar Teleport" or "Ativar Teleport"
    teleportBtn.BackgroundColor3 = teleportOn and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(0, 170, 255)
end)

-- Loop de Teleport
RunService.Heartbeat:Connect(function()
    if teleportOn and tick() - lastTeleport >= teleportInterval then
        lastTeleport = tick()
        if root then
            root.CFrame = respawnPoint
        end
    end
end)
