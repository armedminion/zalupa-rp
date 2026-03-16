--// ══════════════════════════════════════════════════════════
--//   Залупа РП by armedminion  v3
--//   Xeno Compatible | English UI
--// ══════════════════════════════════════════════════════════

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui       = game:GetService("StarterGui")
local Lighting         = game:GetService("Lighting")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

local Settings = {
    ESP = false, Tracers = false, Speedhack = false, Noclip = false,
    SpeedValue = 100, GodMode = false, InfAmmo = false, NoRecoil = false,
    Fly = false, FlySpeed = 80,
    Aimbot = false, AimbotKey = Enum.UserInputType.MouseButton2,
    AimbotFOV = 180, AimbotSmooth = 5, AimbotPart = "Head",
    AimbotShowFOV = true, AimbotWallCheck = false, AimbotTeamCheck = false,
}

local LoopID = { GodMode = 0, InfAmmo = 0, NoRecoil = 0 }

--// ══════════ GUI PARENT (Xeno safe) ══════════
local guiParent
pcall(function() guiParent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not guiParent then guiParent = game:GetService("CoreGui") end
if guiParent:FindFirstChild("ZalupaRP_Hub") then guiParent.ZalupaRP_Hub:Destroy() end

--// ══════════ SCREEN GUI ══════════
local SG = Instance.new("ScreenGui")
SG.Name = "ZalupaRP_Hub"
SG.Parent = guiParent
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.ResetOnSpawn = false

local MF = Instance.new("Frame")
MF.Name = "Main"
MF.Parent = SG
MF.BackgroundColor3 = Color3.fromRGB(12, 12, 22)
MF.BorderSizePixel = 0
MF.Position = UDim2.new(0.015, 0, 0.05, 0)
MF.Size = UDim2.new(0, 260, 0, 560)
MF.Active = true
MF.ClipsDescendants = true
Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 12)

local ms = Instance.new("UIStroke")
ms.Parent = MF
ms.Color = Color3.fromRGB(255, 50, 50)
ms.Thickness = 1.5
ms.Transparency = 0.3

--// ══════════ DRAG ══════════
do
    local d, ds, sp
    MF.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            d = true; ds = i.Position; sp = MF.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - ds
            MF.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
        end
    end)
end

--// ══════════ SHADOW ══════════
local sh = Instance.new("ImageLabel")
sh.Parent = MF; sh.AnchorPoint = Vector2.new(0.5,0.5)
sh.Position = UDim2.new(0.5,0,0.5,0); sh.Size = UDim2.new(1,35,1,35)
sh.BackgroundTransparency = 1; sh.Image = "rbxassetid://5554236805"
sh.ImageColor3 = Color3.new(0,0,0); sh.ImageTransparency = 0.5
sh.ScaleType = Enum.ScaleType.Slice; sh.SliceCenter = Rect.new(23,23,277,277)
sh.ZIndex = -1

--// ══════════ TITLE BAR ══════════
local TB = Instance.new("Frame")
TB.Parent = MF; TB.BackgroundColor3 = Color3.fromRGB(25,25,42)
TB.Size = UDim2.new(1,0,0,52); TB.BorderSizePixel = 0
Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 12)

local T1 = Instance.new("TextLabel")
T1.Parent = TB; T1.BackgroundTransparency = 1
T1.Position = UDim2.new(0,0,0,4); T1.Size = UDim2.new(1,0,0,28)
T1.Font = Enum.Font.GothamBlack; T1.TextSize = 17
T1.Text = "🍆  Zalupa RP"; T1.TextColor3 = Color3.fromRGB(255,50,80)

local T2 = Instance.new("TextLabel")
T2.Parent = TB; T2.BackgroundTransparency = 1
T2.Position = UDim2.new(0,0,0,28); T2.Size = UDim2.new(1,0,0,18)
T2.Font = Enum.Font.GothamSemibold; T2.TextSize = 11
T2.Text = "by armedminion  •  [H] toggle menu"; T2.TextColor3 = Color3.fromRGB(180,180,200)

local CR = Instance.new("TextLabel")
CR.Parent = MF; CR.BackgroundTransparency = 1
CR.Position = UDim2.new(0,0,1,-20); CR.Size = UDim2.new(1,0,0,18)
CR.Font = Enum.Font.Gotham; CR.TextSize = 10
CR.Text = "Zalupa RP by armedminion • Xeno"; CR.TextColor3 = Color3.fromRGB(90,90,110)
CR.ZIndex = 5

--// ══════════ SCROLL FRAME ══════════
local SF = Instance.new("ScrollingFrame")
SF.Parent = MF; SF.Position = UDim2.new(0,0,0,54)
SF.Size = UDim2.new(1,0,1,-76); SF.BackgroundTransparency = 1
SF.BorderSizePixel = 0; SF.ScrollBarThickness = 4
SF.ScrollBarImageColor3 = Color3.fromRGB(255,50,80)
SF.CanvasSize = UDim2.new(0,0,0,0)
SF.AutomaticCanvasSize = Enum.AutomaticSize.Y

local LL = Instance.new("UIListLayout")
LL.Parent = SF; LL.SortOrder = Enum.SortOrder.LayoutOrder; LL.Padding = UDim.new(0,4)

local UP = Instance.new("UIPadding")
UP.Parent = SF; UP.PaddingLeft = UDim.new(0,8)
UP.PaddingRight = UDim.new(0,8); UP.PaddingTop = UDim.new(0,4)

local lo = 0

--// ══════════ FACTORIES ══════════
local function AddToggle(label, callback)
    lo = lo + 1
    local btn = Instance.new("TextButton")
    btn.Parent = SF; btn.BackgroundColor3 = Color3.fromRGB(32,32,50)
    btn.Size = UDim2.new(1,0,0,32); btn.Font = Enum.Font.GothamSemibold
    btn.Text = "  "..label..":  OFF"; btn.TextColor3 = Color3.fromRGB(200,200,215)
    btn.TextSize = 13; btn.BorderSizePixel = 0; btn.AutoButtonColor = true
    btn.LayoutOrder = lo
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
    local st = Instance.new("UIStroke")
    st.Parent = btn; st.Color = Color3.fromRGB(255,50,80)
    st.Thickness = 1.2; st.Transparency = 1
    btn.MouseEnter:Connect(function() st.Transparency = 0 end)
    btn.MouseLeave:Connect(function() st.Transparency = 1 end)
    local on = false
    btn.MouseButton1Click:Connect(function()
        on = not on
        btn.Text = "  "..label..":  "..(on and "ON" or "OFF")
        btn.BackgroundColor3 = on and Color3.fromRGB(200,40,60) or Color3.fromRGB(32,32,50)
        btn.TextColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(200,200,215)
        callback(on)
    end)
    return btn
end

local function AddAction(label, callback)
    lo = lo + 1
    local btn = Instance.new("TextButton")
    btn.Parent = SF; btn.BackgroundColor3 = Color3.fromRGB(50,30,80)
    btn.Size = UDim2.new(1,0,0,32); btn.Font = Enum.Font.GothamBold
    btn.Text = "  ⚡ "..label; btn.TextColor3 = Color3.fromRGB(220,180,255)
    btn.TextSize = 13; btn.BorderSizePixel = 0; btn.AutoButtonColor = true
    btn.LayoutOrder = lo
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)
    local st = Instance.new("UIStroke")
    st.Parent = btn; st.Color = Color3.fromRGB(180,80,255)
    st.Thickness = 1.2; st.Transparency = 1
    btn.MouseEnter:Connect(function() st.Transparency = 0 end)
    btn.MouseLeave:Connect(function() st.Transparency = 1 end)
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(80,200,80)
        btn.Text = "  ✅ "..label.." — DONE"
        callback()
        task.delay(2, function()
            btn.BackgroundColor3 = Color3.fromRGB(50,30,80)
            btn.Text = "  ⚡ "..label
        end)
    end)
    return btn
end

local function AddSep(text)
    lo = lo + 1
    local l = Instance.new("TextLabel")
    l.Parent = SF; l.BackgroundTransparency = 1
    l.Size = UDim2.new(1,0,0,20); l.Font = Enum.Font.GothamBold
    l.Text = "── "..text.." ──"; l.TextColor3 = Color3.fromRGB(255,80,100)
    l.TextSize = 11; l.LayoutOrder = lo
end

--// ══════════ UTILITY ══════════
local function nukeAllESP()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            for _, o in ipairs(p.Character:GetDescendants()) do
                if o.Name == "_ESP" or o.Name == "_ESPName" then
                    pcall(function() o:Destroy() end)
                end
            end
        end
    end
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
    if plr == LocalPlayer then return end
    local function onChar(char)
        task.wait(0.6)
        if not Settings.ESP then return end
        for _, o in ipairs(char:GetChildren()) do
            if o.Name == "_ESP" or o.Name == "_ESPName" then o:Destroy() end
        end
        local hl = Instance.new("Highlight")
        hl.Name = "_ESP"; hl.FillColor = Color3.fromRGB(255,0,0)
        hl.FillTransparency = 0.55; hl.OutlineColor = Color3.fromRGB(255,255,255)
        hl.Adornee = char; hl.Parent = char

        local attach = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not attach then return end
        local bb = Instance.new("BillboardGui")
        bb.Name = "_ESPName"; bb.Size = UDim2.new(0,220,0,44)
        bb.StudsOffset = Vector3.new(0,3.2,0); bb.AlwaysOnTop = true; bb.Parent = attach

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 14
        lbl.TextColor3 = Color3.fromRGB(255,255,0); lbl.TextStrokeTransparency = 0
        lbl.Parent = bb

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local cn; cn = RunService.Heartbeat:Connect(function()
                if not Settings.ESP then
                    pcall(function() hl:Destroy() end)
                    pcall(function() bb:Destroy() end)
                    cn:Disconnect(); return
                end
                if not char or not char.Parent then cn:Disconnect(); return end
                local dist = ""
                pcall(function()
                    local a = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local b = char:FindFirstChild("HumanoidRootPart")
                    if a and b then dist = "  ["..math.floor((a.Position-b.Position).Magnitude).."m]" end
                end)
                lbl.Text = plr.Name.."  "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)..dist
            end)
            table.insert(espConns, cn)
        end
    end
    if plr.Character then onChar(plr.Character) end
    local c = plr.CharacterAdded:Connect(function(ch) if Settings.ESP then onChar(ch) end end)
    table.insert(espConns, c)
end

AddSep("VISUALS")

AddToggle("ESP", function(s)
    Settings.ESP = s
    if s then
        for _, p in ipairs(Players:GetPlayers()) do applyESP(p) end
        table.insert(espConns, Players.PlayerAdded:Connect(function(p) if Settings.ESP then applyESP(p) end end))
    else
        disconnectESP()
        task.defer(nukeAllESP)
    end
end)

--// ═══════════════════════════════════════════════
--//  2. TRACERS
--// ═══════════════════════════════════════════════
local tLines = {}
local tConn

local function clearTracers()
    if tConn then tConn:Disconnect(); tConn = nil end
    for _, l in ipairs(tLines) do pcall(function() l:Remove() end) end
    tLines = {}
end

AddToggle("Tracers", function(s)
    Settings.Tracers = s
    if s then
        clearTracers()
        tConn = RunService.RenderStepped:Connect(function()
            for i = #tLines, 1, -1 do pcall(function() tLines[i]:Remove() end); table.remove(tLines, i) end
            if not Settings.Tracers then clearTracers(); return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    local hum = p.Character:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local pos, vis = Camera:WorldToViewportPoint(hrp.Position)
                        if vis then
                            local ok2, line = pcall(function()
                                local l = Drawing.new("Line")
                                l.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                                l.To = Vector2.new(pos.X, pos.Y)
                                l.Color = Color3.fromRGB(0,255,255); l.Thickness = 1.4
                                l.Transparency = 1; l.Visible = true; return l
                            end)
                            if ok2 and line then table.insert(tLines, line) end
                        end
                    end
                end
            end
        end)
    else clearTracers() end
end)

--// ═══════════════════════════════════════════════
--//  3. AIMBOT
--// ═══════════════════════════════════════════════
AddSep("COMBAT")

local fovCircle
pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Color = Color3.fromRGB(255,50,80); fovCircle.Thickness = 1.5
    fovCircle.Filled = false; fovCircle.Transparency = 0.7
    fovCircle.NumSides = 64; fovCircle.Radius = Settings.AimbotFOV; fovCircle.Visible = false
end)

local aimActive = false
local aimConn

local function isVis(origin, part)
    if not Settings.AimbotWallCheck then return true end
    local p = RaycastParams.new()
    p.FilterType = Enum.RaycastFilterType.Blacklist
    p.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local r = workspace:Raycast(origin, (part.Position-origin).Unit*1000, p)
    if r then return r.Instance:IsDescendantOf(part.Parent) end
    return true
end

local function getTarget()
    local best, bestD = nil, Settings.AimbotFOV
    local ctr = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            local part = p.Character:FindFirstChild(Settings.AimbotPart)
                      or p.Character:FindFirstChild("Head")
                      or p.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and part then
                if Settings.AimbotTeamCheck and p.Team and p.Team == LocalPlayer.Team then continue end
                local pos, vis = Camera:WorldToViewportPoint(part.Position)
                if vis then
                    local d = (Vector2.new(pos.X,pos.Y)-ctr).Magnitude
                    if d < bestD and isVis(Camera.CFrame.Position, part) then
                        bestD = d; best = part
                    end
                end
            end
        end
    end
    return best
end

AddToggle("Aimbot (RMB / Q)", function(s)
    Settings.Aimbot = s
    if s then
        if fovCircle then fovCircle.Visible = Settings.AimbotShowFOV end
        if aimConn then aimConn:Disconnect() end
        aimConn = RunService.RenderStepped:Connect(function()
            if not Settings.Aimbot then
                if fovCircle then fovCircle.Visible = false end
                aimConn:Disconnect(); aimConn = nil; return
            end
            local ctr = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            if fovCircle then
                fovCircle.Position = ctr; fovCircle.Radius = Settings.AimbotFOV
                fovCircle.Visible = Settings.AimbotShowFOV
            end
            if not aimActive then return end
            local t = getTarget()
            if t then
                local cf = Camera.CFrame
                local dir = (t.Position - cf.Position).Unit
                local goal = CFrame.lookAt(cf.Position, cf.Position + dir)
                Camera.CFrame = cf:Lerp(goal, math.clamp(1/Settings.AimbotSmooth, 0.05, 1))
            end
        end)
    else
        if fovCircle then fovCircle.Visible = false end
        if aimConn then aimConn:Disconnect(); aimConn = nil end
    end
end)

UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.UserInputType == Settings.AimbotKey or i.KeyCode == Enum.KeyCode.Q then aimActive = true end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Settings.AimbotKey or i.KeyCode == Enum.KeyCode.Q then aimActive = false end
end)

--// ═══════════════════════════════════════════════
--//  4. INF AMMO
--// ═══════════════════════════════════════════════
local ammoKW = {"ammo","clip","mag","bullet","round","cartridge","shell","reserve","currentammo","maxammo"}

local function patchVal(root)
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("NumberValue") or d:IsA("IntValue") then
            local n = d.Name:lower()
            for _, kw in ipairs(ammoKW) do if n:find(kw) then d.Value = 9999; break end end
        end
    end
end

AddToggle("Infinite Ammo", function(s)
    Settings.InfAmmo = s; LoopID.InfAmmo = LoopID.InfAmmo + 1
    if s then
        local id = LoopID.InfAmmo
        task.spawn(function()
            while Settings.InfAmmo and LoopID.InfAmmo == id do
                pcall(function()
                    local ch = LocalPlayer.Character
                    if ch then for _, t in ipairs(ch:GetChildren()) do
                        if t:IsA("Tool") or t:IsA("Model") then patchVal(t) end
                    end end
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    if bp then patchVal(bp) end
                    patchVal(LocalPlayer.PlayerGui)
                end); task.wait(0.1)
            end
        end)
    end
end)

--// ═══════════════════════════════════════════════
--//  5. NO RECOIL
--// ═══════════════════════════════════════════════
local recoilKW = {"recoil","spread","kick","sway","bloom","deviation","scatter","shake","aimkick","camkick","visual_recoil"}

AddToggle("No Recoil", function(s)
    Settings.NoRecoil = s; LoopID.NoRecoil = LoopID.NoRecoil + 1
    if s then
        local id = LoopID.NoRecoil
        task.spawn(function()
            while Settings.NoRecoil and LoopID.NoRecoil == id do
                pcall(function()
                    local function zr(root)
                        for _, d in ipairs(root:GetDescendants()) do
                            if d:IsA("NumberValue") or d:IsA("IntValue") then
                                local n = d.Name:lower()
                                for _, kw in ipairs(recoilKW) do if n:find(kw) then d.Value = 0; break end end
                            end
                        end
                    end
                    local ch = LocalPlayer.Character
                    if ch then for _, t in ipairs(ch:GetChildren()) do
                        if t:IsA("Tool") or t:IsA("Model") then zr(t) end
                    end end
                    local bp = LocalPlayer:FindFirstChild("Backpack")
                    if bp then zr(bp) end
                end); task.wait(0.1)
            end
        end)
    end
end)

--// ═══════════════════════════════════════════════
--//  6. GOD MODE
--// ═══════════════════════════════════════════════
AddToggle("God Mode", function(s)
    Settings.GodMode = s; LoopID.GodMode = LoopID.GodMode + 1
    if s then
        local id = LoopID.GodMode
        task.spawn(function()
            while Settings.GodMode and LoopID.GodMode == id do
                pcall(function()
                    local ch = LocalPlayer.Character
                    if ch then
                        local hs = ch:FindFirstChild("Health")
                        if hs and hs:IsA("Script") then hs:Destroy() end
                        local hum = ch:FindFirstChildOfClass("Humanoid")
                        if hum then hum.Health = hum.MaxHealth end
                        if not ch:FindFirstChildOfClass("ForceField") then
                            local ff = Instance.new("ForceField", ch); ff.Visible = false
                        end
                    end
                end); task.wait(0.05)
            end
            pcall(function()
                local ff = LocalPlayer.Character:FindFirstChildOfClass("ForceField")
                if ff then ff:Destroy() end
            end)
        end)
    end
end)

--// ═══════════════════════════════════════════════
--//  7. SPEEDHACK
--// ═══════════════════════════════════════════════
AddSep("MOVEMENT")

AddToggle("Speed Hack (x"..Settings.SpeedValue..")", function(s)
    Settings.Speedhack = s
    pcall(function()
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = s and Settings.SpeedValue or 16 end
    end)
end)

LocalPlayer.CharacterAdded:Connect(function(ch)
    task.wait(1)
    if Settings.Speedhack then
        pcall(function() ch:FindFirstChildOfClass("Humanoid").WalkSpeed = Settings.SpeedValue end)
    end
end)

--// ═══════════════════════════════════════════════
--//  8. NOCLIP
--// ═══════════════════════════════════════════════
local ncConn

AddToggle("Noclip", function(s)
    Settings.Noclip = s
    if s then
        if ncConn then ncConn:Disconnect() end
        ncConn = RunService.Stepped:Connect(function()
            if not Settings.Noclip then ncConn:Disconnect(); ncConn = nil; return end
            pcall(function()
                for _, p in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end)
        end)
    else
        if ncConn then ncConn:Disconnect(); ncConn = nil end
    end
end)

--// ═══════════════════════════════════════════════
--//  9. FLY
--// ═══════════════════════════════════════════════
local flyConn, flyBV, flyBG

local function stopFly()
    Settings.Fly = false
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then pcall(function() flyBV:Destroy() end); flyBV = nil end
    if flyBG then pcall(function() flyBG:Destroy() end); flyBG = nil end
    pcall(function() LocalPlayer.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false end)
end

local function startFly()
    stopFly(); Settings.Fly = true
    local ch = LocalPlayer.Character; if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    hum.PlatformStand = true

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    flyBV.Velocity = Vector3.zero; flyBV.Parent = hrp

    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
    flyBG.P = 9e4; flyBG.D = 500; flyBG.Parent = hrp

    flyConn = RunService.RenderStepped:Connect(function()
        if not Settings.Fly or not hrp or not hrp.Parent then stopFly(); return end
        local dir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.yAxis end
        flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * Settings.FlySpeed or Vector3.zero
        flyBG.CFrame = Camera.CFrame
    end)
end

AddToggle("Fly (WASD+Space+Shift)", function(s)
    if s then startFly() else stopFly() end
end)

LocalPlayer.CharacterAdded:Connect(function() if Settings.Fly then stopFly() end end)

--// ═══════════════════════════════════════════════
--//  10. FPS BOOST
--// ═══════════════════════════════════════════════
AddSep("PERFORMANCE")

AddAction("FPS BOOST (Massive)", function()
    -- Render quality minimum
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)

    -- Disable shadows & fog
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 1
    end)

    -- Kill all post-processing
    local pfx = {"BloomEffect","BlurEffect","ColorCorrectionEffect","SunRaysEffect","DepthOfFieldEffect","Atmosphere"}
    for _, n in ipairs(pfx) do
        for _, o in ipairs(Lighting:GetChildren()) do if o:IsA(n) then pcall(function() o:Destroy() end) end end
        for _, o in ipairs(Camera:GetChildren()) do if o:IsA(n) then pcall(function() o:Destroy() end) end end
    end

    -- Kill particles, fire, smoke, trails, beams, lights
    local kc = {"ParticleEmitter","Fire","Smoke","Sparkles","Trail","Beam","PointLight","SpotLight","SurfaceLight"}
    for _, o in ipairs(workspace:GetDescendants()) do
        for _, c in ipairs(kc) do if o:IsA(c) then pcall(function() o:Destroy() end); break end end
    end

    -- Hide decals & textures
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Decal") or o:IsA("Texture") then pcall(function() o.Transparency = 1 end) end
    end

    -- Terrain optimizations
    pcall(function()
        local t = workspace.Terrain
        t.WaterWaveSize = 0; t.WaterWaveSpeed = 0
        t.WaterReflectance = 0; t.WaterTransparency = 0; t.Decoration = false
    end)

    -- MeshPart LOD + disable shadows on all parts
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("MeshPart") then pcall(function() o.RenderFidelity = Enum.RenderFidelity.Performance end) end
        if o:IsA("BasePart") then pcall(function() o.CastShadow = false end) end
    end

    -- Reduce humanoid overhead for others
    for _, o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Humanoid") and not o:IsDescendantOf(LocalPlayer.Character or game) then
            pcall(function()
                o.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                o.HealthDisplayDistance = 0; o.NameDisplayDistance = 0
            end)
        end
    end

    -- Lighting technology downgrade
    pcall(function() if sethiddenproperty then sethiddenproperty(Lighting, "Technology", Enum.Technology.Compatibility) end end)

    -- Garbage collect
    pcall(function() collectgarbage("collect") end)

    print("[Zalupa RP] FPS BOOST applied!")
end)

--// ═══════════════════════════════════════════════
--//  HOTKEY — H
--// ═══════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.H then MF.Visible = not MF.Visible end
end)

--// ═══════════════════════════════════════════════
--//  LOADED NOTIFICATION
--// ═══════════════════════════════════════════════
pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title    = "🍆 Zalupa RP",
        Text     = "by armedminion v3 loaded!\nH=menu | RMB/Q=aim | WASD=fly",
        Duration = 7,
    })
end)
print("[Zalupa RP by armedminion] v3 loaded — H=menu | RMB/Q=aim")
