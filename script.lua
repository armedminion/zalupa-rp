--// ══════════════════════════════════════════════════════════
--//   Zalupa RP by armedminion  v6
--//   Full Rewrite — Aimbot, God Mode, Beautiful UI
--// ══════════════════════════════════════════════════════════

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui       = game:GetService("StarterGui")
local Lighting         = game:GetService("Lighting")
local TweenService     = game:GetService("TweenService")
local LP               = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

--// ══════════ SETTINGS ══════════
local S = {
    ESP=false, Tracers=false, Speed=false, Noclip=false,
    SpeedVal=100, God=false, InfAmmo=false, NoRecoil=false,
    Fly=false, FlySpeed=80,
    Aim=false, AimFOV=250, AimSmooth=2, AimPart="Head",
    AimShowFOV=true, AimWall=false, AimTeam=false,
    FPSBoost=false,
}
local LoopID = {God=0, Ammo=0, Recoil=0}

--// ══════════ CLEANUP ══════════
local guiParent
pcall(function() guiParent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not guiParent then guiParent = game:GetService("CoreGui") end
if guiParent:FindFirstChild("ZRP6") then guiParent.ZRP6:Destroy() end
pcall(function() RunService:UnbindFromRenderStep("ZRP_Aim") end)

--// ══════════════════════════════════════════════
--//  BEAUTIFUL UI
--// ══════════════════════════════════════════════

-- Colors
local C = {
    bg       = Color3.fromRGB(13, 13, 26),
    panel    = Color3.fromRGB(20, 20, 36),
    btn      = Color3.fromRGB(28, 28, 48),
    btnHover = Color3.fromRGB(38, 38, 62),
    btnOn    = Color3.fromRGB(220, 40, 70),
    accent   = Color3.fromRGB(255, 50, 80),
    accent2  = Color3.fromRGB(139, 92, 246),
    text     = Color3.fromRGB(220, 220, 235),
    textDim  = Color3.fromRGB(120, 120, 150),
    green    = Color3.fromRGB(34, 197, 94),
    sep      = Color3.fromRGB(255, 80, 120),
}

local SG = Instance.new("ScreenGui")
SG.Name = "ZRP6"; SG.Parent = guiParent
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; SG.ResetOnSpawn = false

-- ═══ MAIN FRAME ═══
local MF = Instance.new("Frame")
MF.Name = "Main"; MF.Parent = SG
MF.BackgroundColor3 = C.bg; MF.BorderSizePixel = 0
MF.Position = UDim2.new(0.012,0,0.04,0)
MF.Size = UDim2.new(0,270,0,580)
MF.Active = true; MF.ClipsDescendants = true
Instance.new("UICorner", MF).CornerRadius = UDim.new(0,14)

-- Glow border
local glow = Instance.new("UIStroke")
glow.Parent = MF; glow.Thickness = 2; glow.Transparency = 0.2
local glowGrad = Instance.new("UIGradient")
glowGrad.Parent = glow
glowGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, C.accent),
    ColorSequenceKeypoint.new(0.5, C.accent2),
    ColorSequenceKeypoint.new(1, C.accent),
}
glowGrad.Rotation = 0

-- Animate glow rotation
task.spawn(function()
    while MF and MF.Parent do
        for r = 0, 360, 2 do
            glowGrad.Rotation = r
            task.wait(0.03)
        end
    end
end)

-- ═══ DRAG ═══
do
    local d,ds,sp
    MF.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            d=true; ds=i.Position; sp=MF.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local dt=i.Position-ds
            MF.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dt.X,sp.Y.Scale,sp.Y.Offset+dt.Y)
        end
    end)
end

-- ═══ TOP ACCENT BAR ═══
local topBar = Instance.new("Frame")
topBar.Parent = MF; topBar.Size = UDim2.new(1,0,0,3)
topBar.BorderSizePixel = 0; topBar.BackgroundColor3 = Color3.new(1,1,1)
local topGrad = Instance.new("UIGradient")
topGrad.Parent = topBar
topGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, C.accent),
    ColorSequenceKeypoint.new(0.5, C.accent2),
    ColorSequenceKeypoint.new(1, C.accent),
}

-- ═══ TITLE AREA ═══
local titleFrame = Instance.new("Frame")
titleFrame.Parent = MF; titleFrame.BackgroundTransparency = 1
titleFrame.Position = UDim2.new(0,0,0,3); titleFrame.Size = UDim2.new(1,0,0,55)

local titleIcon = Instance.new("TextLabel")
titleIcon.Parent = titleFrame; titleIcon.BackgroundTransparency = 1
titleIcon.Position = UDim2.new(0,15,0,8); titleIcon.Size = UDim2.new(0,35,0,35)
titleIcon.Font = Enum.Font.GothamBlack; titleIcon.TextSize = 28
titleIcon.Text = "🍆"; titleIcon.TextColor3 = C.accent

local titleText = Instance.new("TextLabel")
titleText.Parent = titleFrame; titleText.BackgroundTransparency = 1
titleText.Position = UDim2.new(0,52,0,6); titleText.Size = UDim2.new(1,-60,0,22)
titleText.Font = Enum.Font.GothamBlack; titleText.TextSize = 18
titleText.Text = "ZALUPA RP"; titleText.TextColor3 = C.text
titleText.TextXAlignment = Enum.TextXAlignment.Left

local subtitleText = Instance.new("TextLabel")
subtitleText.Parent = titleFrame; subtitleText.BackgroundTransparency = 1
subtitleText.Position = UDim2.new(0,52,0,28); subtitleText.Size = UDim2.new(1,-60,0,16)
subtitleText.Font = Enum.Font.Gotham; subtitleText.TextSize = 11
subtitleText.Text = "by armedminion  •  v6  •  [H] menu"; subtitleText.TextColor3 = C.textDim
subtitleText.TextXAlignment = Enum.TextXAlignment.Left

-- ═══ DIVIDER UNDER TITLE ═══
local divTitle = Instance.new("Frame")
divTitle.Parent = MF; divTitle.Position = UDim2.new(0.05,0,0,58)
divTitle.Size = UDim2.new(0.9,0,0,1); divTitle.BorderSizePixel = 0
divTitle.BackgroundColor3 = Color3.fromRGB(50,50,80)

-- ═══ CLOSE BUTTON ═══
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = titleFrame; closeBtn.BackgroundColor3 = Color3.fromRGB(60,20,30)
closeBtn.Position = UDim2.new(1,-38,0,10); closeBtn.Size = UDim2.new(0,26,0,26)
closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 14
closeBtn.Text = "×"; closeBtn.TextColor3 = C.accent
closeBtn.BorderSizePixel = 0; closeBtn.AutoButtonColor = true
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)
closeBtn.MouseButton1Click:Connect(function() MF.Visible = false end)

-- ═══ SCROLL FRAME ═══
local SF = Instance.new("ScrollingFrame")
SF.Parent = MF; SF.Position = UDim2.new(0,0,0,62)
SF.Size = UDim2.new(1,0,1,-62); SF.BackgroundTransparency = 1
SF.BorderSizePixel = 0; SF.ScrollBarThickness = 3
SF.ScrollBarImageColor3 = C.accent
SF.CanvasSize = UDim2.new(0,0,0,0); SF.AutomaticCanvasSize = Enum.AutomaticSize.Y

local LL = Instance.new("UIListLayout")
LL.Parent = SF; LL.SortOrder = Enum.SortOrder.LayoutOrder; LL.Padding = UDim.new(0,3)
local pad = Instance.new("UIPadding")
pad.Parent = SF; pad.PaddingLeft = UDim.new(0,10)
pad.PaddingRight = UDim.new(0,10); pad.PaddingTop = UDim.new(0,6)
pad.PaddingBottom = UDim.new(0,10)

local lo = 0

--// ══════════ UI FACTORIES ══════════

local function AddSep(text)
    lo = lo + 1
    local f = Instance.new("Frame")
    f.Parent = SF; f.BackgroundTransparency = 1
    f.Size = UDim2.new(1,0,0,24); f.LayoutOrder = lo

    local dot = Instance.new("Frame")
    dot.Parent = f; dot.BackgroundColor3 = C.accent
    dot.Position = UDim2.new(0,0,0.5,-3); dot.Size = UDim2.new(0,6,0,6)
    dot.BorderSizePixel = 0
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = f; lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0,12,0,0); lbl.Size = UDim2.new(1,-12,1,0)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11
    lbl.Text = text:upper(); lbl.TextColor3 = C.sep
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function AddToggle(label, callback)
    lo = lo + 1
    local holder = Instance.new("Frame")
    holder.Parent = SF; holder.BackgroundColor3 = C.btn
    holder.Size = UDim2.new(1,0,0,36); holder.BorderSizePixel = 0
    holder.LayoutOrder = lo
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)

    -- Indicator dot
    local ind = Instance.new("Frame")
    ind.Parent = holder; ind.BackgroundColor3 = Color3.fromRGB(80,80,100)
    ind.Position = UDim2.new(0,10,0.5,-5); ind.Size = UDim2.new(0,10,0,10)
    ind.BorderSizePixel = 0
    Instance.new("UICorner", ind).CornerRadius = UDim.new(1,0)

    -- Label
    local lbl = Instance.new("TextLabel")
    lbl.Parent = holder; lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0,28,0,0); lbl.Size = UDim2.new(1,-90,1,0)
    lbl.Font = Enum.Font.GothamSemibold; lbl.TextSize = 12
    lbl.Text = label; lbl.TextColor3 = C.text
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    -- Status
    local status = Instance.new("TextLabel")
    status.Parent = holder; status.BackgroundTransparency = 1
    status.Position = UDim2.new(1,-55,0,0); status.Size = UDim2.new(0,45,1,0)
    status.Font = Enum.Font.GothamBold; status.TextSize = 11
    status.Text = "OFF"; status.TextColor3 = C.textDim

    -- Click area
    local btn = Instance.new("TextButton")
    btn.Parent = holder; btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1,0,1,0); btn.Text = ""; btn.ZIndex = 5

    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(holder, TweenInfo.new(0.15), {BackgroundColor3 = C.btnHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        local on = status.Text == "ON"
        TweenService:Create(holder, TweenInfo.new(0.15), {BackgroundColor3 = on and C.btnOn or C.btn}):Play()
    end)

    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        status.Text = on and "ON" or "OFF"
        status.TextColor3 = on and C.green or C.textDim
        ind.BackgroundColor3 = on and C.green or Color3.fromRGB(80,80,100)
        TweenService:Create(holder, TweenInfo.new(0.2), {
            BackgroundColor3 = on and C.btnOn or C.btn
        }):Play()
        callback(on)
    end)
    return btn
end

local function AddAction(label, callback)
    lo = lo + 1
    local holder = Instance.new("Frame")
    holder.Parent = SF; holder.BackgroundColor3 = Color3.fromRGB(35,25,55)
    holder.Size = UDim2.new(1,0,0,36); holder.BorderSizePixel = 0
    holder.LayoutOrder = lo
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)

    local lbl = Instance.new("TextLabel")
    lbl.Parent = holder; lbl.BackgroundTransparency = 1
    lbl.Position = UDim2.new(0,12,0,0); lbl.Size = UDim2.new(1,-20,1,0)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
    lbl.Text = "⚡ "..label; lbl.TextColor3 = Color3.fromRGB(200,170,255)
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton")
    btn.Parent = holder; btn.BackgroundTransparency = 1
    btn.Size = UDim2.new(1,0,1,0); btn.Text = ""; btn.ZIndex = 5

    btn.MouseEnter:Connect(function()
        TweenService:Create(holder, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(50,35,75)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(holder, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(35,25,55)}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        TweenService:Create(holder, TweenInfo.new(0.2), {BackgroundColor3 = C.green}):Play()
        lbl.Text = "✅ "..label.." — DONE"
        callback()
        task.delay(2, function()
            TweenService:Create(holder, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(35,25,55)}):Play()
            lbl.Text = "⚡ "..label
        end)
    end)
    return btn
end

--// ══════════════════════════════════════════════
--//  UTILITY
--// ══════════════════════════════════════════════

local function nukeAllESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            for _, o in ipairs(p.Character:GetDescendants()) do
                if o.Name=="_ESP" or o.Name=="_ESPBb" then pcall(function() o:Destroy() end) end
            end
        end
    end
end

-- Находим все живые цели включая тех кто в машинах
local function getAllTargets()
    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        if S.AimTeam and p.Team and p.Team == LP.Team then continue end

        local char = p.Character
        if not char then continue end

        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        -- Ищем целевую часть (работает и в машине)
        local part = char:FindFirstChild(S.AimPart)
                  or char:FindFirstChild("Head")
                  or char:FindFirstChild("HumanoidRootPart")

        if not part then
            -- Если части не видно, ищем через Humanoid.RootPart
            pcall(function()
                if hum.RootPart then part = hum.RootPart end
            end)
        end

        if part then
            table.insert(targets, {player = p, part = part, humanoid = hum, character = char})
        end
    end
    return targets
end

--// ═══════════════════════════════════════════════
--//  1. ESP
--// ═══════════════════════════════════════════════
local espConns = {}
local function disconnectESP()
    for _, c in ipairs(espConns) do pcall(function() c:Disconnect() end) end
    espConns = {}
end

local function applyESP(plr)
    if plr == LP then return end
    local function onChar(char)
        task.wait(0.6)
        if not S.ESP then return end
        for _, o in ipairs(char:GetChildren()) do
            if o.Name=="_ESP" or o.Name=="_ESPBb" then o:Destroy() end
        end
        local hl = Instance.new("Highlight")
        hl.Name="_ESP"; hl.FillColor=Color3.fromRGB(255,0,0)
        hl.FillTransparency=0.5; hl.OutlineColor=Color3.new(1,1,1)
        hl.Adornee=char; hl.Parent=char

        local attach = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not attach then return end
        local bb = Instance.new("BillboardGui")
        bb.Name="_ESPBb"; bb.Size=UDim2.new(0,220,0,44)
        bb.StudsOffset=Vector3.new(0,3.2,0); bb.AlwaysOnTop=true; bb.Parent=attach
        local lbl = Instance.new("TextLabel")
        lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
        lbl.Font=Enum.Font.GothamBold; lbl.TextSize=14
        lbl.TextColor3=Color3.fromRGB(255,255,0); lbl.TextStrokeTransparency=0; lbl.Parent=bb

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local cn; cn = RunService.Heartbeat:Connect(function()
                if not S.ESP then
                    pcall(function() hl:Destroy() end); pcall(function() bb:Destroy() end)
                    cn:Disconnect(); return
                end
                if not char or not char.Parent then cn:Disconnect(); return end
                local dist = ""
                pcall(function()
                    local a = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    local b = char:FindFirstChild("HumanoidRootPart")
                    if a and b then dist=" ["..math.floor((a.Position-b.Position).Magnitude).."m]" end
                end)
                local seat = hum.Sit and " 🚗" or ""
                lbl.Text = plr.Name.." "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)..dist..seat
            end)
            table.insert(espConns, cn)
        end
    end
    if plr.Character then onChar(plr.Character) end
    local c = plr.CharacterAdded:Connect(function(ch) if S.ESP then onChar(ch) end end)
    table.insert(espConns, c)
end

AddSep("Visuals")

AddToggle("ESP + Distance", function(s)
    S.ESP = s
    if s then
        for _, p in ipairs(Players:GetPlayers()) do applyESP(p) end
        table.insert(espConns, Players.PlayerAdded:Connect(function(p) if S.ESP then applyESP(p) end end))
    else disconnectESP(); task.defer(nukeAllESP) end
end)

--// ═══════════════════════════════════════════════
--//  2. TRACERS
--// ═══════════════════════════════════════════════
local tLines={}; local tConn
local function clearTracers()
    if tConn then tConn:Disconnect(); tConn=nil end
    for _, l in ipairs(tLines) do pcall(function() l:Remove() end) end; tLines={}
end

AddToggle("Tracers", function(s)
    S.Tracers = s
    if s then
        clearTracers()
        tConn = RunService.RenderStepped:Connect(function()
            for i=#tLines,1,-1 do pcall(function() tLines[i]:Remove() end); table.remove(tLines,i) end
            if not S.Tracers then clearTracers(); return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local hrp=p.Character:FindFirstChild("HumanoidRootPart")
                    local hum=p.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health>0 then
                        local pos,vis=Camera:WorldToViewportPoint(hrp.Position)
                        if vis then
                            local ok2,line=pcall(function()
                                local l=Drawing.new("Line")
                                l.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
                                l.To=Vector2.new(pos.X,pos.Y)
                                l.Color=Color3.fromRGB(0,255,255); l.Thickness=1.4
                                l.Transparency=1; l.Visible=true; return l
                            end)
                            if ok2 and line then table.insert(tLines,line) end
                        end
                    end
                end
            end
        end)
    else clearTracers() end
end)

--// ═══════════════════════════════════════════════
--//  3. AIMBOT — ПОЛНЫЙ РЕФАКТОРИНГ
--//     Метод 1: mousemoverel (первое лицо)
--//     Метод 2: CFrame (третье лицо)
--//     Работает с целями в машинах
--// ═══════════════════════════════════════════════
AddSep("Combat")

local fovCircle
pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Color=C.accent; fovCircle.Thickness=1.5
    fovCircle.Filled=false; fovCircle.Transparency=0.6
    fovCircle.NumSides=72; fovCircle.Radius=S.AimFOV; fovCircle.Visible=false
end)

-- Dot in center for aiming reference
local aimDot
pcall(function()
    aimDot = Drawing.new("Circle")
    aimDot.Color=C.green; aimDot.Thickness=0
    aimDot.Filled=true; aimDot.Transparency=1
    aimDot.NumSides=20; aimDot.Radius=4; aimDot.Visible=false
end)

local aimHolding = false

local function getClosestInFOV()
    Camera = workspace.CurrentCamera
    local best, bestDist = nil, S.AimFOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local targets = getAllTargets()

    for _, t in ipairs(targets) do
        local pos, onScreen = Camera:WorldToViewportPoint(t.part.Position)
        if onScreen then
            local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
            if d < bestDist then
                -- Wall check
                if S.AimWall then
                    local params = RaycastParams.new()
                    params.FilterType = Enum.RaycastFilterType.Blacklist
                    params.FilterDescendantsInstances = {LP.Character, Camera}
                    local ray = workspace:Raycast(Camera.CFrame.Position, (t.part.Position - Camera.CFrame.Position).Unit * 2000, params)
                    if ray and not ray.Instance:IsDescendantOf(t.character) then
                        continue
                    end
                end
                bestDist = d
                best = t
            end
        end
    end
    return best
end

-- Detect first person
local function isFirstPerson()
    local ch = LP.Character
    if not ch then return false end
    local head = ch:FindFirstChild("Head")
    if not head then return false end
    return (Camera.CFrame.Position - head.Position).Magnitude < 1.5
end

-- Has mousemoverel? (Xeno, Synapse, Fluxus etc.)
local hasMMR = (type(mousemoverel) == "function")

-- ═══ MAIN AIMBOT FUNCTION (BindToRenderStep priority 201) ═══
local AIMBOT_BOUND = false

local function bindAimbot()
    if AIMBOT_BOUND then return end
    AIMBOT_BOUND = true

    RunService:BindToRenderStep("ZRP_Aim", Enum.RenderPriority.Camera.Value + 1, function()
        Camera = workspace.CurrentCamera

        -- FOV Circle update
        if fovCircle then
            if S.Aim and S.AimShowFOV then
                local ctr = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                fovCircle.Position = ctr; fovCircle.Radius = S.AimFOV; fovCircle.Visible = true
            else
                fovCircle.Visible = false
            end
        end

        if not S.Aim or not aimHolding then
            if aimDot then aimDot.Visible = false end
            return
        end

        local target = getClosestInFOV()
        if not target then
            if aimDot then aimDot.Visible = false end
            return
        end

        local targetPos = target.part.Position
        local camPos = Camera.CFrame.Position

        -- Show aim dot on target
        if aimDot then
            local sp = Camera:WorldToViewportPoint(targetPos)
            aimDot.Position = Vector2.new(sp.X, sp.Y)
            aimDot.Visible = true
        end

        -- ═══ METHOD 1: mousemoverel (best for first person) ═══
        if hasMMR then
            local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
            if onScreen then
                local centerX = Camera.ViewportSize.X / 2
                local centerY = Camera.ViewportSize.Y / 2

                local deltaX = screenPos.X - centerX
                local deltaY = screenPos.Y - centerY

                -- Smoothing
                deltaX = deltaX / S.AimSmooth
                deltaY = deltaY / S.AimSmooth

                -- Clamp to avoid crazy jumps
                local maxMove = 150
                deltaX = math.clamp(deltaX, -maxMove, maxMove)
                deltaY = math.clamp(deltaY, -maxMove, maxMove)

                -- Only move if delta is significant
                if math.abs(deltaX) > 0.5 or math.abs(deltaY) > 0.5 then
                    mousemoverel(deltaX, deltaY)
                end
            end
        else
            -- ═══ METHOD 2: CFrame (fallback) ═══
            local dir = (targetPos - camPos).Unit
            local goal = CFrame.lookAt(camPos, camPos + dir)
            local alpha = math.clamp(1 / S.AimSmooth, 0.05, 1)
            Camera.CFrame = Camera.CFrame:Lerp(goal, alpha)
        end

        -- Rotate character body toward target
        pcall(function()
            local hrp = LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dir = (targetPos - hrp.Position)
                local flatDir = Vector3.new(dir.X, 0, dir.Z)
                if flatDir.Magnitude > 0.1 then
                    hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flatDir.Unit)
                end
            end
        end)
    end)
end

local function unbindAimbot()
    AIMBOT_BOUND = false
    pcall(function() RunService:UnbindFromRenderStep("ZRP_Aim") end)
    if fovCircle then fovCircle.Visible = false end
    if aimDot then aimDot.Visible = false end
end

AddToggle("Aimbot (RMB / Q)", function(s)
    S.Aim = s
    if s then bindAimbot() else unbindAimbot() end
end)

-- Hold RMB or Q
UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.UserInputType == Enum.UserInputType.MouseButton2 or i.KeyCode == Enum.KeyCode.Q then
        aimHolding = true
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton2 or i.KeyCode == Enum.KeyCode.Q then
        aimHolding = false
    end
end)

--// ═══════════════════════════════════════════════
--//  4. INFINITE AMMO
--// ═══════════════════════════════════════════════
local ammoKW={"ammo","clip","mag","bullet","round","cartridge","shell","reserve","currentammo","maxammo"}
local function patchVal(root)
    for _,d in ipairs(root:GetDescendants()) do
        if d:IsA("NumberValue") or d:IsA("IntValue") then
            local n=d.Name:lower()
            for _,kw in ipairs(ammoKW) do if n:find(kw) then d.Value=9999; break end end
        end
    end
end

AddToggle("Infinite Ammo", function(s)
    S.InfAmmo=s; LoopID.Ammo=LoopID.Ammo+1
    if s then
        local id=LoopID.Ammo
        task.spawn(function()
            while S.InfAmmo and LoopID.Ammo==id do
                pcall(function()
                    local ch=LP.Character
                    if ch then for _,t in ipairs(ch:GetChildren()) do
                        if t:IsA("Tool") or t:IsA("Model") then patchVal(t) end
                    end end
                    local bp=LP:FindFirstChild("Backpack"); if bp then patchVal(bp) end
                    patchVal(LP.PlayerGui)
                end); task.wait(0.1)
            end
        end)
    end
end)

--// ═══════════════════════════════════════════════
--//  5. NO RECOIL
--// ═══════════════════════════════════════════════
local recoilKW={"recoil","spread","kick","sway","bloom","deviation","scatter","shake","aimkick","camkick","visual_recoil"}

AddToggle("No Recoil", function(s)
    S.NoRecoil=s; LoopID.Recoil=LoopID.Recoil+1
    if s then
        local id=LoopID.Recoil
        task.spawn(function()
            while S.NoRecoil and LoopID.Recoil==id do
                pcall(function()
                    local function zr(root)
                        for _,d in ipairs(root:GetDescendants()) do
                            if d:IsA("NumberValue") or d:IsA("IntValue") then
                                local n=d.Name:lower()
                                for _,kw in ipairs(recoilKW) do if n:find(kw) then d.Value=0; break end end
                            end
                        end
                    end
                    local ch=LP.Character
                    if ch then for _,t in ipairs(ch:GetChildren()) do
                        if t:IsA("Tool") or t:IsA("Model") then zr(t) end
                    end end
                    local bp=LP:FindFirstChild("Backpack"); if bp then zr(bp) end
                end); task.wait(0.1)
            end
        end)
    end
end)

--// ═══════════════════════════════════════════════
--//  6. GOD MODE — ПОЛНЫЙ РЕФАКТОРИНГ
--// ═══════════════════════════════════════════════
local godConns = {}

local function cleanGod()
    for _, c in ipairs(godConns) do pcall(function() c:Disconnect() end) end
    godConns = {}
end

local function applyGod(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- 1) Запрещаем состояние смерти
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)

    -- 2) Огромное здоровье
    pcall(function()
        hum.MaxHealth = 999999999
        hum.Health = 999999999
    end)

    -- 3) Убиваем скрипт Health если есть
    pcall(function()
        local hs = char:FindFirstChild("Health")
        if hs and hs:IsA("Script") then hs:Destroy() end
    end)

    -- 4) ForceField невидимый
    pcall(function()
        if not char:FindFirstChildOfClass("ForceField") then
            local ff = Instance.new("ForceField", char); ff.Visible = false
        end
    end)

    -- 5) HealthChanged — мгновенное восстановление
    local hcConn = hum.HealthChanged:Connect(function(newHealth)
        if S.God and newHealth < 999999999 then
            hum.Health = 999999999
        end
    end)
    table.insert(godConns, hcConn)

    -- 6) Убиваем все скрипты урона в персонаже
    pcall(function()
        for _, obj in ipairs(char:GetDescendants()) do
            local n = obj.Name:lower()
            if obj:IsA("Script") and (n:find("damage") or n:find("hurt") or n:find("kill")) then
                obj:Destroy()
            end
        end
    end)
end

local function removeGod(char)
    if not char then return end
    pcall(function()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end)
    pcall(function()
        local ff = char:FindFirstChildOfClass("ForceField")
        if ff then ff:Destroy() end
    end)
end

AddToggle("God Mode", function(s)
    S.God = s; LoopID.God = (LoopID.God or 0) + 1
    cleanGod()
    if s then
        applyGod(LP.Character)
        local charConn = LP.CharacterAdded:Connect(function(ch)
            task.wait(1)
            if S.God then applyGod(ch) end
        end)
        table.insert(godConns, charConn)

        -- Periodic re-apply (in case game resets health)
        local loopId = LoopID.God
        task.spawn(function()
            while S.God and LoopID.God == loopId do
                pcall(function()
                    local ch = LP.Character
                    if ch then
                        local hum = ch:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                            if hum.MaxHealth < 999999999 then hum.MaxHealth = 999999999 end
                            if hum.Health < 999999999 then hum.Health = 999999999 end
                        end
                        if not ch:FindFirstChildOfClass("ForceField") then
                            local ff = Instance.new("ForceField", ch); ff.Visible = false
                        end
                    end
                end)
                task.wait(0.05)
            end
        end)
    else
        removeGod(LP.Character)
    end
end)

--// ═══════════════════════════════════════════════
--//  7. SPEED HACK
--// ═══════════════════════════════════════════════
AddSep("Movement")

AddToggle("Speed Hack (x"..S.SpeedVal..")", function(s)
    S.Speed = s
    pcall(function()
        LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = s and S.SpeedVal or 16
    end)
end)

LP.CharacterAdded:Connect(function(ch)
    task.wait(1)
    if S.Speed then pcall(function() ch:FindFirstChildOfClass("Humanoid").WalkSpeed = S.SpeedVal end) end
end)

--// ═══════════════════════════════════════════════
--//  8. NOCLIP (FIXED)
--// ═══════════════════════════════════════════════
local ncConn; local ncSaved={}

AddToggle("Noclip", function(s)
    S.Noclip = s
    if s then
        ncSaved={}
        pcall(function()
            for _,p in ipairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") then ncSaved[p]=p.CanCollide end
            end
        end)
        if ncConn then ncConn:Disconnect() end
        ncConn = RunService.Stepped:Connect(function()
            if not S.Noclip then ncConn:Disconnect(); ncConn=nil; return end
            pcall(function()
                for _,p in ipairs(LP.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide=false end
                end
            end)
        end)
    else
        if ncConn then ncConn:Disconnect(); ncConn=nil end
        task.defer(function()
            for part,orig in pairs(ncSaved) do
                pcall(function() if part and part.Parent then part.CanCollide=orig end end)
            end; ncSaved={}
            pcall(function()
                local ch=LP.Character; if not ch then return end
                for _,name in ipairs({"HumanoidRootPart","Head","Torso","UpperTorso","LowerTorso"}) do
                    local p=ch:FindFirstChild(name)
                    if p and p:IsA("BasePart") then p.CanCollide=true end
                end
            end)
        end)
    end
end)

--// ═══════════════════════════════════════════════
--//  9. FLY
--// ═══════════════════════════════════════════════
local flyConn,flyBV,flyBG

local function stopFly()
    S.Fly=false
    if flyConn then flyConn:Disconnect(); flyConn=nil end
    if flyBV then pcall(function() flyBV:Destroy() end); flyBV=nil end
    if flyBG then pcall(function() flyBG:Destroy() end); flyBG=nil end
    pcall(function() LP.Character:FindFirstChildOfClass("Humanoid").PlatformStand=false end)
end

local function startFly()
    stopFly(); S.Fly=true
    local ch=LP.Character; if not ch then return end
    local hrp=ch:FindFirstChild("HumanoidRootPart")
    local hum=ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    hum.PlatformStand=true
    flyBV=Instance.new("BodyVelocity"); flyBV.MaxForce=Vector3.new(1e9,1e9,1e9)
    flyBV.Velocity=Vector3.zero; flyBV.Parent=hrp
    flyBG=Instance.new("BodyGyro"); flyBG.MaxTorque=Vector3.new(1e9,1e9,1e9)
    flyBG.P=9e4; flyBG.D=500; flyBG.Parent=hrp
    flyConn=RunService.RenderStepped:Connect(function()
        if not S.Fly or not hrp or not hrp.Parent then stopFly(); return end
        local dir=Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.yAxis end
        flyBV.Velocity=dir.Magnitude>0 and dir.Unit*S.FlySpeed or Vector3.zero
        flyBG.CFrame=Camera.CFrame
    end)
end

AddToggle("Fly (WASD+Space+Shift)", function(s)
    if s then startFly() else stopFly() end
end)

LP.CharacterAdded:Connect(function() if S.Fly then stopFly() end end)

--// ═══════════════════════════════════════════════
--//  10. FPS BOOST
--// ═══════════════════════════════════════════════
AddSep("Performance")

AddAction("FPS BOOST (Massive)", function()
    pcall(function()
        settings().Rendering.QualityLevel=Enum.QualityLevel.Level01
        UserSettings():GetService("UserGameSettings").SavedQualityLevel=Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function() Lighting.GlobalShadows=false; Lighting.FogEnd=9e9 end)
    for _,n in ipairs({"BloomEffect","BlurEffect","ColorCorrectionEffect","SunRaysEffect","DepthOfFieldEffect","Atmosphere"}) do
        for _,o in ipairs(Lighting:GetChildren()) do if o:IsA(n) then pcall(function() o:Destroy() end) end end
        for _,o in ipairs(Camera:GetChildren()) do if o:IsA(n) then pcall(function() o:Destroy() end) end end
    end
    for _,o in ipairs(workspace:GetDescendants()) do
        for _,c in ipairs({"ParticleEmitter","Fire","Smoke","Sparkles","Trail","Beam","PointLight","SpotLight","SurfaceLight"}) do
            if o:IsA(c) then pcall(function() o:Destroy() end); break end
        end
    end
    for _,o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Decal") or o:IsA("Texture") then pcall(function() o.Transparency=1 end) end
        if o:IsA("MeshPart") then pcall(function() o.RenderFidelity=Enum.RenderFidelity.Performance end) end
        if o:IsA("BasePart") then pcall(function() o.CastShadow=false end) end
    end
    pcall(function()
        local t=workspace.Terrain
        t.WaterWaveSize=0;t.WaterWaveSpeed=0;t.WaterReflectance=0;t.WaterTransparency=0;t.Decoration=false
    end)
    pcall(function() if sethiddenproperty then sethiddenproperty(Lighting,"Technology",Enum.Technology.Compatibility) end end)
    pcall(function() collectgarbage("collect") end)
    print("[ZRP] FPS BOOST done!")
end)

--// ═══════════════════════════════════════════════
--//  HOTKEY H
--// ═══════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode==Enum.KeyCode.H then MF.Visible=not MF.Visible end
end)

--// ═══════════════════════════════════════════════
--//  LOADED
--// ═══════════════════════════════════════════════
pcall(function()
    StarterGui:SetCore("SendNotification",{
        Title="🍆 Zalupa RP v6",
        Text="Loaded! H=menu | RMB/Q=aim\nAimbot works in 1st person + vehicles",
        Duration=7
    })
end)
print("[Zalupa RP v6] Loaded — by armedminion")
