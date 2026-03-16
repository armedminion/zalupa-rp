--// ══════════════════════════════════════════════════════════
--//   Zalupa RP by armedminion  v12  —  FULL REWRITE
--// ══════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local SGui = game:GetService("StarterGui")
local Light = game:GetService("Lighting")
local TS = game:GetService("TweenService")
local TPS = game:GetService("TeleportService")
local LP = Players.LocalPlayer
local Cam

-- ══════ CLEANUP ══════
local gP
pcall(function() gP = (gethui and gethui()) or game:GetService("CoreGui") end)
if not gP then gP = game:GetService("CoreGui") end
if gP:FindFirstChild("ZRP12") then gP.ZRP12:Destroy() end
for _,n in ipairs({"ZRP_Aim","ZRP_Spin","ZRP_AntiRag","ZRP_God"}) do
    pcall(function() RS:UnbindFromRenderStep(n) end)
end

-- ══════ DETECT MOUSEMOVEREL ══════
local mmr, aimInfo = nil, "fallback"
for _,try in ipairs({
    function() if type(mousemoverel)=="function" then mmr=mousemoverel; aimInfo="mousemoverel" end end,
    function() if type(mouse_moverel)=="function" then mmr=mouse_moverel; aimInfo="mouse_moverel" end end,
    function() if getgenv and type(getgenv().mousemoverel)=="function" then mmr=getgenv().mousemoverel; aimInfo="getgenv" end end,
    function() if type(Input)=="table" and type(Input.MouseMove)=="function" then mmr=function(x,y) Input.MouseMove(x,y) end; aimInfo="Input" end end,
}) do pcall(try); if mmr then break end end
warn("[ZRP12] Aimbot method: "..aimInfo)

-- ══════ SETTINGS ══════
local S = {
    ESP=false, Tracers=false, Speed=false, Noclip=false, SpeedVal=100,
    God=false, InfAmmo=false, NoRecoil=false,
    Fly=false, FlySpeed=80,
    Aim=false, AimFOV=350, AimSmooth=1.5, AimPart="Head",
    AimShowFOV=true, AimWall=false, AimTeam=false,
    Spin=false, SpinSpeed=1200, SpinJump=25,
    AntiRag=false,
}

-- ══════ COLORS ══════
local C = {
    bg=Color3.fromRGB(8,8,18), card=Color3.fromRGB(20,20,38),
    cardH=Color3.fromRGB(30,30,52), cardOn=Color3.fromRGB(180,30,55),
    accent=Color3.fromRGB(255,40,70), accent2=Color3.fromRGB(120,70,255),
    txt=Color3.fromRGB(230,230,245), dim=Color3.fromRGB(105,105,135),
    green=Color3.fromRGB(25,210,85), sep=Color3.fromRGB(255,70,105),
    action=Color3.fromRGB(28,18,48), actionH=Color3.fromRGB(45,30,70),
}

-- ══════════════════════════════════════════════
--  GUI BUILD
-- ══════════════════════════════════════════════
local SG = Instance.new("ScreenGui")
SG.Name="ZRP12"; SG.Parent=gP; SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.ResetOnSpawn=false

local MF = Instance.new("Frame")
MF.Parent=SG; MF.BackgroundColor3=C.bg; MF.BorderSizePixel=0
MF.Position=UDim2.new(0.01,0,0.03,0); MF.Size=UDim2.new(0,280,0,650)
MF.Active=true; MF.ClipsDescendants=true
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,14)

-- Border glow
local bdr=Instance.new("UIStroke"); bdr.Parent=MF; bdr.Thickness=2; bdr.Transparency=0.1
local bdrG=Instance.new("UIGradient"); bdrG.Parent=bdr
bdrG.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,C.accent),
    ColorSequenceKeypoint.new(0.5,C.accent2),
    ColorSequenceKeypoint.new(1,C.accent)}
task.spawn(function()
    while MF and MF.Parent do
        for r=0,360,2 do bdrG.Rotation=r; task.wait(0.02) end
    end
end)

-- Drag
do local dr,ds,sp
    MF.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            dr=true;ds=i.Position;sp=MF.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then dr=false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dr and i.UserInputType==Enum.UserInputType.MouseMovement then
            local d=i.Position-ds
            MF.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
end

-- Top accent line
local topLine=Instance.new("Frame"); topLine.Parent=MF
topLine.Size=UDim2.new(1,0,0,3); topLine.BorderSizePixel=0
topLine.BackgroundColor3=Color3.new(1,1,1)
Instance.new("UIGradient",topLine).Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,C.accent),
    ColorSequenceKeypoint.new(0.5,C.accent2),
    ColorSequenceKeypoint.new(1,C.accent)}

-- Header
local hdr=Instance.new("Frame"); hdr.Parent=MF; hdr.BackgroundTransparency=1
hdr.Position=UDim2.new(0,0,0,3); hdr.Size=UDim2.new(1,0,0,52)

Instance.new("TextLabel",hdr).Position=UDim2.new(0,14,0,6)
local icon=hdr:GetChildren()[#hdr:GetChildren()]
icon.Size=UDim2.new(0,34,0,34);icon.BackgroundTransparency=1
icon.Font=Enum.Font.GothamBlack;icon.TextSize=26;icon.Text="🍆";icon.TextColor3=C.accent

local title=Instance.new("TextLabel"); title.Parent=hdr; title.BackgroundTransparency=1
title.Position=UDim2.new(0,52,0,4); title.Size=UDim2.new(1,-62,0,20)
title.Font=Enum.Font.GothamBlack; title.TextSize=17; title.Text="ZALUPA RP"
title.TextColor3=C.txt; title.TextXAlignment=Enum.TextXAlignment.Left

local sub=Instance.new("TextLabel"); sub.Parent=hdr; sub.BackgroundTransparency=1
sub.Position=UDim2.new(0,52,0,24); sub.Size=UDim2.new(1,-62,0,14)
sub.Font=Enum.Font.Gotham; sub.TextSize=9
sub.Text="by armedminion • v12 • [H] • "..aimInfo
sub.TextColor3=C.dim; sub.TextXAlignment=Enum.TextXAlignment.Left

local xBtn=Instance.new("TextButton"); xBtn.Parent=hdr
xBtn.BackgroundColor3=Color3.fromRGB(50,15,25)
xBtn.Position=UDim2.new(1,-40,0,8); xBtn.Size=UDim2.new(0,28,0,28)
xBtn.Font=Enum.Font.GothamBold; xBtn.TextSize=16; xBtn.Text="×"
xBtn.TextColor3=C.accent; xBtn.BorderSizePixel=0
Instance.new("UICorner",xBtn).CornerRadius=UDim.new(0,6)
xBtn.MouseButton1Click:Connect(function() MF.Visible=false end)

-- Divider
local dv=Instance.new("Frame"); dv.Parent=MF
dv.Position=UDim2.new(0.04,0,0,55); dv.Size=UDim2.new(0.92,0,0,1)
dv.BorderSizePixel=0; dv.BackgroundColor3=Color3.fromRGB(40,40,70)

-- Scroll
local SF=Instance.new("ScrollingFrame"); SF.Parent=MF
SF.Position=UDim2.new(0,0,0,58); SF.Size=UDim2.new(1,0,1,-58)
SF.BackgroundTransparency=1; SF.BorderSizePixel=0; SF.ScrollBarThickness=3
SF.ScrollBarImageColor3=C.accent
SF.CanvasSize=UDim2.new(0,0,0,0); SF.AutomaticCanvasSize=Enum.AutomaticSize.Y

local lay=Instance.new("UIListLayout"); lay.Parent=SF
lay.SortOrder=Enum.SortOrder.LayoutOrder; lay.Padding=UDim.new(0,4)
local padd=Instance.new("UIPadding"); padd.Parent=SF
padd.PaddingLeft=UDim.new(0,10); padd.PaddingRight=UDim.new(0,10)
padd.PaddingTop=UDim.new(0,6); padd.PaddingBottom=UDim.new(0,12)

local lo=0

-- ══════ UI FACTORIES ══════
local function Sep(t)
    lo=lo+1
    local f=Instance.new("Frame"); f.Parent=SF; f.BackgroundTransparency=1
    f.Size=UDim2.new(1,0,0,20); f.LayoutOrder=lo
    local dot=Instance.new("Frame"); dot.Parent=f; dot.BackgroundColor3=C.accent
    dot.Position=UDim2.new(0,0,0.5,-3); dot.Size=UDim2.new(0,6,0,6); dot.BorderSizePixel=0
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    local l=Instance.new("TextLabel"); l.Parent=f; l.BackgroundTransparency=1
    l.Position=UDim2.new(0,12,0,0); l.Size=UDim2.new(1,-12,1,0)
    l.Font=Enum.Font.GothamBold; l.TextSize=11; l.Text=t:upper()
    l.TextColor3=C.sep; l.TextXAlignment=Enum.TextXAlignment.Left
end

local function Toggle(label,cb)
    lo=lo+1
    local h=Instance.new("Frame"); h.Parent=SF; h.BackgroundColor3=C.card
    h.Size=UDim2.new(1,0,0,34); h.BorderSizePixel=0; h.LayoutOrder=lo
    Instance.new("UICorner",h).CornerRadius=UDim.new(0,8)
    local ind=Instance.new("Frame"); ind.Parent=h; ind.BackgroundColor3=Color3.fromRGB(65,65,90)
    ind.Position=UDim2.new(0,10,0.5,-5); ind.Size=UDim2.new(0,10,0,10); ind.BorderSizePixel=0
    Instance.new("UICorner",ind).CornerRadius=UDim.new(1,0)
    local lb=Instance.new("TextLabel"); lb.Parent=h; lb.BackgroundTransparency=1
    lb.Position=UDim2.new(0,26,0,0); lb.Size=UDim2.new(1,-85,1,0)
    lb.Font=Enum.Font.GothamSemibold; lb.TextSize=12; lb.Text=label
    lb.TextColor3=C.txt; lb.TextXAlignment=Enum.TextXAlignment.Left
    local st=Instance.new("TextLabel"); st.Parent=h; st.BackgroundTransparency=1
    st.Position=UDim2.new(1,-50,0,0); st.Size=UDim2.new(0,40,1,0)
    st.Font=Enum.Font.GothamBold; st.TextSize=11; st.Text="OFF"; st.TextColor3=C.dim
    local btn=Instance.new("TextButton"); btn.Parent=h; btn.BackgroundTransparency=1
    btn.Size=UDim2.new(1,0,1,0); btn.Text=""; btn.ZIndex=5
    btn.MouseEnter:Connect(function() TS:Create(h,TweenInfo.new(0.1),{BackgroundColor3=C.cardH}):Play() end)
    btn.MouseLeave:Connect(function() TS:Create(h,TweenInfo.new(0.1),{BackgroundColor3=st.Text=="ON" and C.cardOn or C.card}):Play() end)
    local on=false
    btn.MouseButton1Click:Connect(function()
        on=not on; st.Text=on and "ON" or "OFF"
        st.TextColor3=on and C.green or C.dim
        ind.BackgroundColor3=on and C.green or Color3.fromRGB(65,65,90)
        TS:Create(h,TweenInfo.new(0.12),{BackgroundColor3=on and C.cardOn or C.card}):Play()
        cb(on)
    end)
end

local function Action(label,cb)
    lo=lo+1
    local h=Instance.new("Frame"); h.Parent=SF; h.BackgroundColor3=C.action
    h.Size=UDim2.new(1,0,0,34); h.BorderSizePixel=0; h.LayoutOrder=lo
    Instance.new("UICorner",h).CornerRadius=UDim.new(0,8)
    local lb=Instance.new("TextLabel"); lb.Parent=h; lb.BackgroundTransparency=1
    lb.Position=UDim2.new(0,12,0,0); lb.Size=UDim2.new(1,-20,1,0)
    lb.Font=Enum.Font.GothamBold; lb.TextSize=12; lb.Text="⚡ "..label
    lb.TextColor3=Color3.fromRGB(190,160,255); lb.TextXAlignment=Enum.TextXAlignment.Left
    local btn=Instance.new("TextButton"); btn.Parent=h; btn.BackgroundTransparency=1
    btn.Size=UDim2.new(1,0,1,0); btn.Text=""; btn.ZIndex=5
    btn.MouseEnter:Connect(function() TS:Create(h,TweenInfo.new(0.1),{BackgroundColor3=C.actionH}):Play() end)
    btn.MouseLeave:Connect(function() TS:Create(h,TweenInfo.new(0.1),{BackgroundColor3=C.action}):Play() end)
    btn.MouseButton1Click:Connect(function()
        TS:Create(h,TweenInfo.new(0.12),{BackgroundColor3=C.green}):Play()
        lb.Text="✅ "..label; cb()
        task.delay(2,function()
            TS:Create(h,TweenInfo.new(0.15),{BackgroundColor3=C.action}):Play()
            lb.Text="⚡ "..label
        end)
    end)
end

-- ══════════════════════════════════════════════
--  ANTI-RAGDOLL FUNCTION
-- ══════════════════════════════════════════════
local function AntiRag(ch)
    if not ch then return end
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    for _,st in ipairs({
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Physics,
    }) do pcall(function() hum:SetStateEnabled(st, false) end) end

    pcall(function() hum.PlatformStand = false end)

    local state = hum:GetState()
    if state == Enum.HumanoidStateType.Ragdoll
    or state == Enum.HumanoidStateType.FallingDown
    or state == Enum.HumanoidStateType.Physics then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end

    for _, obj in ipairs(ch:GetDescendants()) do
        pcall(function()
            if obj:IsA("Motor6D") then obj.Enabled = true end
            if obj:IsA("BallSocketConstraint") then obj.Enabled = false end
            if obj:IsA("NoCollisionConstraint") then obj.Enabled = false end
            if obj:IsA("BoolValue") then
                local n = obj.Name:lower()
                if n:find("ragdoll") or n:find("stun") or n:find("knock") then
                    obj.Value = false
                end
            end
        end)
    end

    pcall(function() ch:SetAttribute("Ragdolled", nil) end)
    pcall(function() ch:SetAttribute("ragdolled", nil) end)
end

-- ══════════════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════════════
local function nukeESP()
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Character then
            for _,o in ipairs(p.Character:GetDescendants()) do
                if o.Name=="_E" or o.Name=="_EB" then
                    pcall(function() o:Destroy() end)
                end
            end
        end
    end
end

local function getTargets()
    Cam = workspace.CurrentCamera
    local r = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p == LP then continue end
        if S.AimTeam and p.Team and p.Team == LP.Team then continue end
        local ch = p.Character
        if not ch then continue end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local part = ch:FindFirstChild(S.AimPart)
                  or ch:FindFirstChild("Head")
                  or ch:FindFirstChild("HumanoidRootPart")
        if not part then pcall(function() part = hum.RootPart end) end
        if part then table.insert(r, {part=part, ch=ch}) end
    end
    return r
end

-- ═══════════════════════════════════════
--  1. ESP
-- ═══════════════════════════════════════
local espC = {}
local function dcESP()
    for _,c in ipairs(espC) do pcall(function() c:Disconnect() end) end
    espC = {}
end

local function makeESP(plr)
    if plr == LP then return end
    local function build(char)
        task.wait(0.5)
        if not S.ESP then return end
        for _,o in ipairs(char:GetChildren()) do
            if o.Name=="_E" or o.Name=="_EB" then o:Destroy() end
        end
        local hl = Instance.new("Highlight")
        hl.Name="_E"; hl.FillColor=Color3.new(1,0,0); hl.FillTransparency=0.5
        hl.OutlineColor=Color3.new(1,1,1); hl.Adornee=char; hl.Parent=char

        local at = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not at then return end
        local bb = Instance.new("BillboardGui")
        bb.Name="_EB"; bb.Size=UDim2.new(0,200,0,40)
        bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true; bb.Parent=at
        local lbl = Instance.new("TextLabel")
        lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
        lbl.Font=Enum.Font.GothamBold; lbl.TextSize=13
        lbl.TextColor3=Color3.fromRGB(255,255,0); lbl.TextStrokeTransparency=0
        lbl.Parent=bb

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            local cn; cn = RS.Heartbeat:Connect(function()
                if not S.ESP then
                    pcall(function() hl:Destroy() end)
                    pcall(function() bb:Destroy() end)
                    cn:Disconnect(); return
                end
                if not char.Parent then cn:Disconnect(); return end
                local dist = ""
                pcall(function()
                    local a = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    local b = char:FindFirstChild("HumanoidRootPart")
                    if a and b then
                        dist = " ["..math.floor((a.Position-b.Position).Magnitude).."m]"
                    end
                end)
                lbl.Text = plr.Name.." "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)..dist
            end)
            table.insert(espC, cn)
        end
    end
    if plr.Character then build(plr.Character) end
    table.insert(espC, plr.CharacterAdded:Connect(function(ch)
        if S.ESP then build(ch) end
    end))
end

Sep("Visuals")

Toggle("ESP + Distance", function(on)
    S.ESP = on
    if on then
        for _,p in ipairs(Players:GetPlayers()) do makeESP(p) end
        table.insert(espC, Players.PlayerAdded:Connect(function(p)
            if S.ESP then makeESP(p) end
        end))
    else
        dcESP()
        task.defer(nukeESP)
    end
end)

-- ═══════════════════════════════════════
--  2. TRACERS
-- ═══════════════════════════════════════
local tL, tCn = {}, nil
local function clrT()
    if tCn then tCn:Disconnect(); tCn=nil end
    for _,l in ipairs(tL) do pcall(function() l:Remove() end) end
    tL = {}
end

Toggle("Tracers", function(on)
    S.Tracers = on
    if on then
        clrT()
        tCn = RS.RenderStepped:Connect(function()
            for i=#tL,1,-1 do pcall(function() tL[i]:Remove() end); table.remove(tL,i) end
            if not S.Tracers then clrT(); return end
            Cam = workspace.CurrentCamera
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local hr = p.Character:FindFirstChild("HumanoidRootPart")
                    local hm = p.Character:FindFirstChildOfClass("Humanoid")
                    if hr and hm and hm.Health>0 then
                        local ps,vs = Cam:WorldToViewportPoint(hr.Position)
                        if vs then
                            local ok2,ln = pcall(function()
                                local l = Drawing.new("Line")
                                l.From = Vector2.new(Cam.ViewportSize.X/2, Cam.ViewportSize.Y)
                                l.To = Vector2.new(ps.X, ps.Y)
                                l.Color = Color3.fromRGB(0,255,255)
                                l.Thickness = 1.4; l.Transparency = 1; l.Visible = true
                                return l
                            end)
                            if ok2 and ln then table.insert(tL,ln) end
                        end
                    end
                end
            end
        end)
    else clrT() end
end)

-- ═══════════════════════════════════════
--  3. AIMBOT — SIMPLE & EFFECTIVE
-- ═══════════════════════════════════════
Sep("Combat")

local fovC
pcall(function()
    fovC = Drawing.new("Circle")
    fovC.Color=C.accent; fovC.Thickness=1.5; fovC.Filled=false
    fovC.Transparency=0.6; fovC.NumSides=72; fovC.Radius=S.AimFOV
    fovC.Visible=false
end)

local aimHold = false

local function findTarget()
    Cam = workspace.CurrentCamera
    local cx, cy = Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2
    local best, bestD = nil, S.AimFOV
    for _,t in ipairs(getTargets()) do
        local sp, vis = Cam:WorldToViewportPoint(t.part.Position)
        if vis then
            local d = math.sqrt((sp.X-cx)^2 + (sp.Y-cy)^2)
            if d < bestD then
                if S.AimWall then
                    local rp = RaycastParams.new()
                    rp.FilterType = Enum.RaycastFilterType.Blacklist
                    rp.FilterDescendantsInstances = {LP.Character, Cam}
                    local ray = workspace:Raycast(Cam.CFrame.Position,
                        (t.part.Position - Cam.CFrame.Position).Unit * 2000, rp)
                    if ray and not ray.Instance:IsDescendantOf(t.ch) then continue end
                end
                bestD = d; best = t
            end
        end
    end
    return best
end

local function aimLoop()
    pcall(function() RS:UnbindFromRenderStep("ZRP_Aim") end)

    RS:BindToRenderStep("ZRP_Aim", Enum.RenderPriority.Input.Value, function()
        Cam = workspace.CurrentCamera
        local cx, cy = Cam.ViewportSize.X/2, Cam.ViewportSize.Y/2

        -- FOV circle
        if fovC then
            if S.Aim and S.AimShowFOV then
                fovC.Position = Vector2.new(cx,cy)
                fovC.Radius = S.AimFOV; fovC.Visible = true
            else fovC.Visible = false end
        end

        if not S.Aim or not aimHold then return end

        local t = findTarget()
        if not t then return end

        local sp, vis = Cam:WorldToViewportPoint(t.part.Position)
        if not vis then return end

        local dx = sp.X - cx
        local dy = sp.Y - cy

        -- ═══ MOUSEMOVEREL — двигает мышь, камера следует, пули попадают ═══
        if mmr then
            local moveX = dx / S.AimSmooth
            local moveY = dy / S.AimSmooth

            -- Не дёргать если уже на цели
            if math.abs(dx) > 2 or math.abs(dy) > 2 then
                mmr(moveX, moveY)
            end
        else
            -- Fallback: Scriptable camera (пули могут не попадать)
            Cam.CameraType = Enum.CameraType.Scriptable
            local dir = (t.part.Position - Cam.CFrame.Position).Unit
            local goal = CFrame.lookAt(Cam.CFrame.Position, Cam.CFrame.Position + dir)
            Cam.CFrame = Cam.CFrame:Lerp(goal, math.clamp(1/S.AimSmooth, 0.1, 1))
        end
    end)
end

Toggle("Aimbot (RMB / Q)", function(on)
    S.Aim = on
    if on then aimLoop()
    else
        pcall(function() RS:UnbindFromRenderStep("ZRP_Aim") end)
        if fovC then fovC.Visible = false end
        pcall(function()
            if Cam and Cam.CameraType == Enum.CameraType.Scriptable then
                Cam.CameraType = Enum.CameraType.Custom
            end
        end)
    end
end)

UIS.InputBegan:Connect(function(i,g) if g then return end
    if i.UserInputType==Enum.UserInputType.MouseButton2 or i.KeyCode==Enum.KeyCode.Q then
        aimHold = true
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton2 or i.KeyCode==Enum.KeyCode.Q then
        aimHold = false
        if not mmr then
            pcall(function()
                if Cam and Cam.CameraType==Enum.CameraType.Scriptable then
                    Cam.CameraType=Enum.CameraType.Custom
                end
            end)
        end
    end
end)

-- ═══════════════════════════════════════
--  4. INFINITE AMMO
-- ═══════════════════════════════════════
local ammoKW = {"ammo","clip","mag","bullet","round","cartridge","shell","reserve"}
local ammoId = 0

Toggle("Infinite Ammo", function(on)
    S.InfAmmo = on; ammoId = ammoId + 1
    if on then
        local myId = ammoId
        task.spawn(function()
            while S.InfAmmo and ammoId == myId do
                pcall(function()
                    local function patch(root)
                        for _,d in ipairs(root:GetDescendants()) do
                            if d:IsA("NumberValue") or d:IsA("IntValue") then
                                local n = d.Name:lower()
                                for _,k in ipairs(ammoKW) do
                                    if n:find(k) then d.Value = 9999; break end
                                end
                            end
                        end
                    end
                    local ch = LP.Character
                    if ch then
                        for _,t in ipairs(ch:GetChildren()) do
                            if t:IsA("Tool") or t:IsA("Model") then patch(t) end
                        end
                    end
                    local bp = LP:FindFirstChild("Backpack")
                    if bp then patch(bp) end
                    patch(LP.PlayerGui)
                end)
                task.wait(0.1)
            end
        end)
    end
end)

-- ═══════════════════════════════════════
--  5. NO RECOIL
-- ═══════════════════════════════════════
local rcKW = {"recoil","spread","kick","sway","bloom","deviation","scatter","shake"}
local rcId = 0

Toggle("No Recoil", function(on)
    S.NoRecoil = on; rcId = rcId + 1
    if on then
        local myId = rcId
        task.spawn(function()
            while S.NoRecoil and rcId == myId do
                pcall(function()
                    local function zero(root)
                        for _,d in ipairs(root:GetDescendants()) do
                            if d:IsA("NumberValue") or d:IsA("IntValue") then
                                local n = d.Name:lower()
                                for _,k in ipairs(rcKW) do
                                    if n:find(k) then d.Value = 0; break end
                                end
                            end
                        end
                    end
                    local ch = LP.Character
                    if ch then
                        for _,t in ipairs(ch:GetChildren()) do
                            if t:IsA("Tool") or t:IsA("Model") then zero(t) end
                        end
                    end
                    local bp = LP:FindFirstChild("Backpack")
                    if bp then zero(bp) end
                end)
                task.wait(0.1)
            end
        end)
    end
end)

-- ═══════════════════════════════════════
--  6. GOD MODE — НЕ ТРОГАЕТ FORCEFIELD, НЕ ТРОГАЕТ СОСТОЯНИЯ
--     Просто постоянно хилит + удаляет скрипты урона
-- ═══════════════════════════════════════
local godId = 0
local godConns = {}

Toggle("God Mode", function(on)
    S.God = on; godId = godId + 1
    for _,c in ipairs(godConns) do pcall(function() c:Disconnect() end) end
    godConns = {}

    if on then
        local myId = godId

        local function protect(ch)
            if not ch then return end
            local hum = ch:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            -- Отключаем смерть
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)

            -- Ставим большое HP (не math.huge — это ломает некоторые игры)
            pcall(function() hum.MaxHealth = 99999999; hum.Health = 99999999 end)

            -- При получении урона — мгновенное восстановление
            local hc = hum.HealthChanged:Connect(function(hp)
                if S.God and hp < 99999999 then
                    task.defer(function()
                        pcall(function() hum.Health = 99999999 end)
                    end)
                end
            end)
            table.insert(godConns, hc)

            -- Удаляем скрипты урона/здоровья
            pcall(function()
                for _,o in ipairs(ch:GetDescendants()) do
                    if o:IsA("Script") then
                        local n = o.Name:lower()
                        if n == "health" or n:find("damage") then
                            o:Destroy()
                        end
                    end
                end
            end)
        end

        protect(LP.Character)

        local charConn = LP.CharacterAdded:Connect(function(ch)
            task.wait(0.8)
            if S.God and godId == myId then protect(ch) end
        end)
        table.insert(godConns, charConn)

        -- Постоянный цикл восстановления
        task.spawn(function()
            while S.God and godId == myId do
                pcall(function()
                    local ch = LP.Character
                    if ch then
                        local hum = ch:FindFirstChildOfClass("Humanoid")
                        if hum then
                            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                            if hum.Health < 99999999 then hum.Health = 99999999 end
                            if hum.MaxHealth < 99999999 then hum.MaxHealth = 99999999 end
                        end
                    end
                end)
                task.wait(0.05)
            end
            -- При выключении — возвращаем нормальные значения
            pcall(function()
                local ch = LP.Character
                if ch then
                    local hum = ch:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                        hum.MaxHealth = 100; hum.Health = 100
                    end
                end
            end)
        end)
    end
end)

-- ═══════════════════════════════════════
--  7. ANTI-RAGDOLL
-- ═══════════════════════════════════════
Toggle("Anti-Ragdoll", function(on)
    S.AntiRag = on
    if on then
        pcall(function() RS:UnbindFromRenderStep("ZRP_AntiRag") end)
        RS:BindToRenderStep("ZRP_AntiRag", Enum.RenderPriority.Character.Value+5, function()
            if S.AntiRag then AntiRag(LP.Character) end
        end)
    else
        pcall(function() RS:UnbindFromRenderStep("ZRP_AntiRag") end)
        pcall(function()
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
            end
        end)
    end
end)

-- ═══════════════════════════════════════
--  8. SPEED
-- ═══════════════════════════════════════
Sep("Movement")

Toggle("Speed (x"..S.SpeedVal..")", function(on)
    S.Speed = on
    pcall(function()
        LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = on and S.SpeedVal or 16
    end)
end)

LP.CharacterAdded:Connect(function(ch)
    task.wait(1)
    if S.Speed then
        pcall(function() ch:FindFirstChildOfClass("Humanoid").WalkSpeed = S.SpeedVal end)
    end
end)

-- ═══════════════════════════════════════
--  9. NOCLIP
-- ═══════════════════════════════════════
local ncCn, ncSaved = nil, {}

Toggle("Noclip", function(on)
    S.Noclip = on
    if on then
        ncSaved = {}
        pcall(function()
            for _,p in ipairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") then ncSaved[p] = p.CanCollide end
            end
        end)
        if ncCn then ncCn:Disconnect() end
        ncCn = RS.Stepped:Connect(function()
            if not S.Noclip then ncCn:Disconnect(); ncCn=nil; return end
            pcall(function()
                for _,p in ipairs(LP.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end)
        end)
    else
        if ncCn then ncCn:Disconnect(); ncCn=nil end
        task.defer(function()
            for pt,og in pairs(ncSaved) do
                pcall(function() if pt and pt.Parent then pt.CanCollide = og end end)
            end
            ncSaved = {}
            pcall(function()
                local ch = LP.Character
                if ch then
                    for _,nm in ipairs({"HumanoidRootPart","Head","Torso","UpperTorso","LowerTorso"}) do
                        local p = ch:FindFirstChild(nm)
                        if p and p:IsA("BasePart") then p.CanCollide = true end
                    end
                end
            end)
        end)
    end
end)

-- ═══════════════════════════════════════
--  10. FLY
-- ═══════════════════════════════════════
local flCn, flBV, flBG

local function stopFly()
    S.Fly = false
    if flCn then flCn:Disconnect(); flCn=nil end
    if flBV then pcall(function() flBV:Destroy() end); flBV=nil end
    if flBG then pcall(function() flBG:Destroy() end); flBG=nil end
    pcall(function() LP.Character:FindFirstChildOfClass("Humanoid").PlatformStand = false end)
end

local function startFly()
    stopFly(); S.Fly = true
    local ch = LP.Character; if not ch then return end
    local hr = ch:FindFirstChild("HumanoidRootPart")
    local hm = ch:FindFirstChildOfClass("Humanoid")
    if not hr or not hm then return end
    hm.PlatformStand = true
    flBV = Instance.new("BodyVelocity")
    flBV.MaxForce = Vector3.one * 1e9; flBV.Velocity = Vector3.zero; flBV.Parent = hr
    flBG = Instance.new("BodyGyro")
    flBG.MaxTorque = Vector3.one * 1e9; flBG.P = 9e4; flBG.D = 500; flBG.Parent = hr
    flCn = RS.RenderStepped:Connect(function()
        if not S.Fly or not hr or not hr.Parent then stopFly(); return end
        Cam = workspace.CurrentCamera
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - Cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + Cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.yAxis end
        flBV.Velocity = dir.Magnitude > 0 and dir.Unit * S.FlySpeed or Vector3.zero
        flBG.CFrame = Cam.CFrame
    end)
end

Toggle("Fly (WASD+Space+Shift)", function(on)
    if on then startFly() else stopFly() end
end)
LP.CharacterAdded:Connect(function() if S.Fly then stopFly() end end)

-- ═══════════════════════════════════════
--  11. SPINNER — БЕЗОПАСНЫЙ (ТОЛЬКО Humanoid.AutoRotate OFF + поворот)
--
--  НЕ ТРОГАЕТ CFrame !!!
--  Вместо этого: выключает AutoRotate и
--  использует BodyGyro для плавного вращения.
--  BodyGyro НЕ создаёт столкновений = НЕТ РАГДОЛЛА.
--  Персонаж НЕ ПРОПАДАЕТ потому что позиция не меняется.
-- ═══════════════════════════════════════
Sep("Fun")

local spinBound = false
local spinGyro = nil
local spinAngle = 0
local origJP = 50

local function bindSpin()
    if spinBound then return end; spinBound = true
    pcall(function() RS:UnbindFromRenderStep("ZRP_Spin") end)

    pcall(function()
        local hum = LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then origJP = hum.JumpPower end
    end)

    spinAngle = 0

    RS:BindToRenderStep("ZRP_Spin", Enum.RenderPriority.Character.Value - 1, function(dt)
        if not S.Spin then return end
        local ch = LP.Character; if not ch then return end
        local hrp = ch:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local hum = ch:FindFirstChildOfClass("Humanoid"); if not hum then return end

        -- Анти-рагдолл
        AntiRag(ch)

        -- Лечение от урона спиннера
        pcall(function()
            if hum.Health < hum.MaxHealth then hum.Health = hum.MaxHealth end
        end)

        -- Выключаем авторотацию — персонаж не поворачивается сам
        pcall(function() hum.AutoRotate = false end)

        -- Обновляем угол
        spinAngle = spinAngle + math.rad(S.SpinSpeed) * dt

        -- BodyGyro для плавного вращения (НЕ BodyAngularVelocity)
        -- BodyGyro плавно поворачивает без силы = без рагдолла
        if not spinGyro or not spinGyro.Parent then
            spinGyro = Instance.new("BodyGyro")
            spinGyro.Name = "_SpinGyro"
            spinGyro.MaxTorque = Vector3.new(0, 1e6, 0) -- только Y ось
            spinGyro.P = 1e6   -- высокая мощность = быстрый поворот
            spinGyro.D = 100
            spinGyro.Parent = hrp
        end

        -- Задаём целевой CFrame для гироскопа
        local pos = hrp.Position
        spinGyro.CFrame = CFrame.new(pos) * CFrame.Angles(0, spinAngle, 0)

        -- Прыжок выше
        pcall(function() hum.JumpPower = origJP + S.SpinJump end)

        -- Автопрыжок
        if hum.FloorMaterial ~= Enum.Material.Air then
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end

        -- Мягкое ограничение падения
        pcall(function()
            if hrp.Velocity.Y < -80 then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, -80, hrp.Velocity.Z)
            end
        end)
    end)
end

local function unbindSpin()
    spinBound = false
    pcall(function() RS:UnbindFromRenderStep("ZRP_Spin") end)
    if spinGyro then pcall(function() spinGyro:Destroy() end); spinGyro = nil end
    pcall(function()
        local ch = LP.Character; if not ch then return end
        local hum = ch:FindFirstChildOfClass("Humanoid"); if not hum then return end
        hum.JumpPower = origJP
        hum.AutoRotate = true
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        -- Убираем остатки
        local hrp = ch:FindFirstChild("HumanoidRootPart")
        if hrp then
            local sg = hrp:FindFirstChild("_SpinGyro")
            if sg then sg:Destroy() end
        end
    end)
end

Toggle("Spinner + Bhop", function(on)
    S.Spin = on
    if on then bindSpin() else unbindSpin() end
end)

LP.CharacterAdded:Connect(function(ch)
    task.wait(1)
    if S.Spin then
        pcall(function() origJP = ch:FindFirstChildOfClass("Humanoid").JumpPower end)
        spinGyro = nil
        unbindSpin(); S.Spin = true; bindSpin()
    end
end)

-- ═══════════════════════════════════════
--  12. FPS BOOST
-- ═══════════════════════════════════════
Sep("Performance")

Action("FPS BOOST", function()
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function() Light.GlobalShadows = false; Light.FogEnd = 9e9 end)
    for _,n in ipairs({"BloomEffect","BlurEffect","ColorCorrectionEffect","SunRaysEffect","DepthOfFieldEffect","Atmosphere"}) do
        for _,o in ipairs(Light:GetChildren()) do if o:IsA(n) then pcall(function() o:Destroy() end) end end
        for _,o in ipairs(workspace.CurrentCamera:GetChildren()) do if o:IsA(n) then pcall(function() o:Destroy() end) end end
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
        t.WaterWaveSize=0; t.WaterWaveSpeed=0; t.WaterReflectance=0
        t.WaterTransparency=0; t.Decoration=false
    end)
    pcall(function()
        if sethiddenproperty then
            sethiddenproperty(Light, "Technology", Enum.Technology.Compatibility)
        end
    end)
    pcall(function() collectgarbage("collect") end)
end)

-- ═══════════════════════════════════════
--  13. REJOIN SAME SERVER
-- ═══════════════════════════════════════
Sep("Server")

Action("Rejoin Same Server", function()
    pcall(function()
        SGui:SetCore("SendNotification", {
            Title = "🔄 Rejoining...",
            Text = "Same server: "..game.JobId:sub(1,8).."...",
            Duration = 3
        })
    end)
    task.wait(0.5)
    pcall(function()
        TPS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
    end)
end)

-- ═══════════════════════════════════════
--  HOTKEY
-- ═══════════════════════════════════════
UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.H then MF.Visible = not MF.Visible end
end)

-- ═══════════════════════════════════════
--  LOADED
-- ═══════════════════════════════════════
pcall(function()
    SGui:SetCore("SendNotification", {
        Title = "🍆 Zalupa RP v12",
        Text = "Full rewrite! Aim: "..aimInfo.."\nH=menu | RMB/Q=aim",
        Duration = 7
    })
end)
warn("[Zalupa RP v12] Loaded — full rewrite")
