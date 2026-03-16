--// ══════════════════════════════════════════════════════════
--//   Zalupa RP by armedminion  v7
--//   AIMBOT REWRITTEN — 3 methods auto-detect
--//   + Spinner Bhop
--// ══════════════════════════════════════════════════════════

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui       = game:GetService("StarterGui")
local Lighting         = game:GetService("Lighting")
local TweenService     = game:GetService("TweenService")
local LP               = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

local S = {
    ESP=false,Tracers=false,Speed=false,Noclip=false,SpeedVal=100,
    God=false,InfAmmo=false,NoRecoil=false,
    Fly=false,FlySpeed=80,
    Aim=false,AimFOV=300,AimSmooth=2,AimPart="Head",
    AimShowFOV=true,AimWall=false,AimTeam=false,
    Spin=false,SpinSpeed=720,SpinJumpBoost=15,
}
local LoopID={God=0,Ammo=0,Recoil=0}

-- ══════════ CLEANUP ══════════
local guiParent
pcall(function() guiParent=(gethui and gethui()) or game:GetService("CoreGui") end)
if not guiParent then guiParent=game:GetService("CoreGui") end
if guiParent:FindFirstChild("ZRP7") then guiParent.ZRP7:Destroy() end
pcall(function() RunService:UnbindFromRenderStep("ZRP_Aim") end)

-- ══════════ DETECT MOUSE MOVE METHOD ══════════
local mouseMove = nil
local aimMethodName = "scriptable"

if type(mousemoverel)=="function" then
    mouseMove = mousemoverel
    aimMethodName = "mousemoverel"
elseif type(mouse_moverel)=="function" then
    mouseMove = mouse_moverel
    aimMethodName = "mouse_moverel"
elseif type(Input)=="table" and type(Input.MouseMove)=="function" then
    mouseMove = function(x,y) Input.MouseMove(x,y) end
    aimMethodName = "Input.MouseMove"
elseif type(mousemoveabs)=="function" then
    -- Some executors have absolute mouse move
    aimMethodName = "mousemoveabs"
end

-- Try VirtualInputManager as another option
local VIM = nil
pcall(function() VIM = game:GetService("VirtualInputManager") end)
if VIM and not mouseMove then
    aimMethodName = "VIM"
end

print("[ZRP v7] Aimbot method: " .. aimMethodName)

-- ══════════════════════════════════════════════
--  COLORS
-- ══════════════════════════════════════════════
local C = {
    bg=Color3.fromRGB(10,10,20), panel=Color3.fromRGB(18,18,32),
    btn=Color3.fromRGB(25,25,44), btnH=Color3.fromRGB(35,35,58),
    btnOn=Color3.fromRGB(200,35,65), accent=Color3.fromRGB(255,45,75),
    accent2=Color3.fromRGB(130,80,255), text=Color3.fromRGB(225,225,240),
    dim=Color3.fromRGB(110,110,140), green=Color3.fromRGB(30,200,90),
    sep=Color3.fromRGB(255,75,110),
}

-- ══════════════════════════════════════════════
--  GUI
-- ══════════════════════════════════════════════
local SG=Instance.new("ScreenGui")
SG.Name="ZRP7";SG.Parent=guiParent
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;SG.ResetOnSpawn=false

local MF=Instance.new("Frame")
MF.Name="Main";MF.Parent=SG;MF.BackgroundColor3=C.bg
MF.BorderSizePixel=0;MF.Position=UDim2.new(0.01,0,0.03,0)
MF.Size=UDim2.new(0,275,0,590);MF.Active=true;MF.ClipsDescendants=true
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,14)

-- Animated glow border
local glow=Instance.new("UIStroke")
glow.Parent=MF;glow.Thickness=2;glow.Transparency=0.15
local glowG=Instance.new("UIGradient")
glowG.Parent=glow
glowG.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,C.accent),
    ColorSequenceKeypoint.new(0.5,C.accent2),
    ColorSequenceKeypoint.new(1,C.accent),
}
task.spawn(function()
    while MF and MF.Parent do
        for r=0,360,3 do glowG.Rotation=r;task.wait(0.03) end
    end
end)

-- Drag
do local d,ds,sp
    MF.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 then
            d=true;ds=i.Position;sp=MF.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if d and i.UserInputType==Enum.UserInputType.MouseMovement then
            local dt=i.Position-ds
            MF.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dt.X,sp.Y.Scale,sp.Y.Offset+dt.Y)
        end
    end)
end

-- Top accent bar
local topB=Instance.new("Frame")
topB.Parent=MF;topB.Size=UDim2.new(1,0,0,3);topB.BorderSizePixel=0
topB.BackgroundColor3=Color3.new(1,1,1)
local tG=Instance.new("UIGradient")
tG.Parent=topB;tG.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,C.accent),
    ColorSequenceKeypoint.new(0.5,C.accent2),
    ColorSequenceKeypoint.new(1,C.accent),
}

-- Title
local tF=Instance.new("Frame")
tF.Parent=MF;tF.BackgroundTransparency=1
tF.Position=UDim2.new(0,0,0,3);tF.Size=UDim2.new(1,0,0,55)

local tI=Instance.new("TextLabel")
tI.Parent=tF;tI.BackgroundTransparency=1
tI.Position=UDim2.new(0,14,0,8);tI.Size=UDim2.new(0,35,0,35)
tI.Font=Enum.Font.GothamBlack;tI.TextSize=28;tI.Text="🍆";tI.TextColor3=C.accent

local tT=Instance.new("TextLabel")
tT.Parent=tF;tT.BackgroundTransparency=1
tT.Position=UDim2.new(0,50,0,5);tT.Size=UDim2.new(1,-60,0,22)
tT.Font=Enum.Font.GothamBlack;tT.TextSize=18
tT.Text="ZALUPA RP";tT.TextColor3=C.text;tT.TextXAlignment=Enum.TextXAlignment.Left

local tS=Instance.new("TextLabel")
tS.Parent=tF;tS.BackgroundTransparency=1
tS.Position=UDim2.new(0,50,0,27);tS.Size=UDim2.new(1,-60,0,16)
tS.Font=Enum.Font.Gotham;tS.TextSize=10
tS.Text="by armedminion • v7 • [H] menu • Aim: "..aimMethodName
tS.TextColor3=C.dim;tS.TextXAlignment=Enum.TextXAlignment.Left

-- Close btn
local cB=Instance.new("TextButton")
cB.Parent=tF;cB.BackgroundColor3=Color3.fromRGB(55,18,28)
cB.Position=UDim2.new(1,-38,0,10);cB.Size=UDim2.new(0,26,0,26)
cB.Font=Enum.Font.GothamBold;cB.TextSize=14;cB.Text="×"
cB.TextColor3=C.accent;cB.BorderSizePixel=0
Instance.new("UICorner",cB).CornerRadius=UDim.new(0,6)
cB.MouseButton1Click:Connect(function() MF.Visible=false end)

-- Divider
local dv=Instance.new("Frame")
dv.Parent=MF;dv.Position=UDim2.new(0.05,0,0,58)
dv.Size=UDim2.new(0.9,0,0,1);dv.BorderSizePixel=0
dv.BackgroundColor3=Color3.fromRGB(45,45,75)

-- Scroll
local SF=Instance.new("ScrollingFrame")
SF.Parent=MF;SF.Position=UDim2.new(0,0,0,62)
SF.Size=UDim2.new(1,0,1,-62);SF.BackgroundTransparency=1
SF.BorderSizePixel=0;SF.ScrollBarThickness=3
SF.ScrollBarImageColor3=C.accent
SF.CanvasSize=UDim2.new(0,0,0,0);SF.AutomaticCanvasSize=Enum.AutomaticSize.Y

Instance.new("UIListLayout",SF).SortOrder=Enum.SortOrder.LayoutOrder
local pad=Instance.new("UIPadding")
pad.Parent=SF;pad.PaddingLeft=UDim.new(0,10);pad.PaddingRight=UDim.new(0,10)
pad.PaddingTop=UDim.new(0,6);pad.PaddingBottom=UDim.new(0,10)
SF:FindFirstChildOfClass("UIListLayout").Padding=UDim.new(0,3)

local lo=0

-- ══════════ FACTORIES ══════════
local function AddSep(t)
    lo=lo+1
    local f=Instance.new("Frame");f.Parent=SF;f.BackgroundTransparency=1
    f.Size=UDim2.new(1,0,0,22);f.LayoutOrder=lo
    local dot=Instance.new("Frame");dot.Parent=f;dot.BackgroundColor3=C.accent
    dot.Position=UDim2.new(0,0,0.5,-3);dot.Size=UDim2.new(0,6,0,6);dot.BorderSizePixel=0
    Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
    local l=Instance.new("TextLabel");l.Parent=f;l.BackgroundTransparency=1
    l.Position=UDim2.new(0,12,0,0);l.Size=UDim2.new(1,-12,1,0)
    l.Font=Enum.Font.GothamBold;l.TextSize=11;l.Text=t:upper()
    l.TextColor3=C.sep;l.TextXAlignment=Enum.TextXAlignment.Left
end

local function AddToggle(label, callback)
    lo=lo+1
    local h=Instance.new("Frame");h.Parent=SF;h.BackgroundColor3=C.btn
    h.Size=UDim2.new(1,0,0,34);h.BorderSizePixel=0;h.LayoutOrder=lo
    Instance.new("UICorner",h).CornerRadius=UDim.new(0,8)
    local ind=Instance.new("Frame");ind.Parent=h;ind.BackgroundColor3=Color3.fromRGB(70,70,95)
    ind.Position=UDim2.new(0,10,0.5,-5);ind.Size=UDim2.new(0,10,0,10);ind.BorderSizePixel=0
    Instance.new("UICorner",ind).CornerRadius=UDim.new(1,0)
    local lbl=Instance.new("TextLabel");lbl.Parent=h;lbl.BackgroundTransparency=1
    lbl.Position=UDim2.new(0,26,0,0);lbl.Size=UDim2.new(1,-85,1,0)
    lbl.Font=Enum.Font.GothamSemibold;lbl.TextSize=12;lbl.Text=label
    lbl.TextColor3=C.text;lbl.TextXAlignment=Enum.TextXAlignment.Left
    local st=Instance.new("TextLabel");st.Parent=h;st.BackgroundTransparency=1
    st.Position=UDim2.new(1,-50,0,0);st.Size=UDim2.new(0,40,1,0)
    st.Font=Enum.Font.GothamBold;st.TextSize=11;st.Text="OFF";st.TextColor3=C.dim
    local btn=Instance.new("TextButton");btn.Parent=h;btn.BackgroundTransparency=1
    btn.Size=UDim2.new(1,0,1,0);btn.Text="";btn.ZIndex=5
    btn.MouseEnter:Connect(function() TweenService:Create(h,TweenInfo.new(0.12),{BackgroundColor3=C.btnH}):Play() end)
    btn.MouseLeave:Connect(function()
        local on=st.Text=="ON"
        TweenService:Create(h,TweenInfo.new(0.12),{BackgroundColor3=on and C.btnOn or C.btn}):Play()
    end)
    local on=false
    btn.MouseButton1Click:Connect(function()
        on=not on;st.Text=on and "ON" or "OFF"
        st.TextColor3=on and C.green or C.dim
        ind.BackgroundColor3=on and C.green or Color3.fromRGB(70,70,95)
        TweenService:Create(h,TweenInfo.new(0.15),{BackgroundColor3=on and C.btnOn or C.btn}):Play()
        callback(on)
    end)
    return btn
end

local function AddAction(label, callback)
    lo=lo+1
    local h=Instance.new("Frame");h.Parent=SF;h.BackgroundColor3=Color3.fromRGB(32,22,52)
    h.Size=UDim2.new(1,0,0,34);h.BorderSizePixel=0;h.LayoutOrder=lo
    Instance.new("UICorner",h).CornerRadius=UDim.new(0,8)
    local lbl=Instance.new("TextLabel");lbl.Parent=h;lbl.BackgroundTransparency=1
    lbl.Position=UDim2.new(0,12,0,0);lbl.Size=UDim2.new(1,-20,1,0)
    lbl.Font=Enum.Font.GothamBold;lbl.TextSize=12;lbl.Text="⚡ "..label
    lbl.TextColor3=Color3.fromRGB(195,165,255);lbl.TextXAlignment=Enum.TextXAlignment.Left
    local btn=Instance.new("TextButton");btn.Parent=h;btn.BackgroundTransparency=1
    btn.Size=UDim2.new(1,0,1,0);btn.Text="";btn.ZIndex=5
    btn.MouseEnter:Connect(function() TweenService:Create(h,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(48,35,72)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(h,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(32,22,52)}):Play() end)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(h,TweenInfo.new(0.15),{BackgroundColor3=C.green}):Play()
        lbl.Text="✅ "..label.." — DONE"; callback()
        task.delay(2,function()
            TweenService:Create(h,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(32,22,52)}):Play()
            lbl.Text="⚡ "..label
        end)
    end)
end

-- ══════════ UTILITY ══════════
local function nukeESP()
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Character then
            for _,o in ipairs(p.Character:GetDescendants()) do
                if o.Name=="_ESP" or o.Name=="_ESPBb" then pcall(function() o:Destroy() end) end
            end
        end
    end
end

local function getTargets()
    local t={}
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP then continue end
        if S.AimTeam and p.Team and p.Team==LP.Team then continue end
        local ch=p.Character; if not ch then continue end
        local hum=ch:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 then continue end
        local part=ch:FindFirstChild(S.AimPart) or ch:FindFirstChild("Head") or ch:FindFirstChild("HumanoidRootPart")
        if not part then pcall(function() part=hum.RootPart end) end
        if part then table.insert(t,{p=p,part=part,hum=hum,ch=ch}) end
    end
    return t
end

-- ═══════════════════════════════════════════════
--  1. ESP
-- ═══════════════════════════════════════════════
local espC={}
local function dcESP() for _,c in ipairs(espC) do pcall(function() c:Disconnect() end) end; espC={} end

local function doESP(plr)
    if plr==LP then return end
    local function oc(char)
        task.wait(0.6); if not S.ESP then return end
        for _,o in ipairs(char:GetChildren()) do
            if o.Name=="_ESP" or o.Name=="_ESPBb" then o:Destroy() end
        end
        local hl=Instance.new("Highlight");hl.Name="_ESP"
        hl.FillColor=Color3.fromRGB(255,0,0);hl.FillTransparency=0.5
        hl.OutlineColor=Color3.new(1,1,1);hl.Adornee=char;hl.Parent=char
        local at=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
        if not at then return end
        local bb=Instance.new("BillboardGui");bb.Name="_ESPBb"
        bb.Size=UDim2.new(0,220,0,44);bb.StudsOffset=Vector3.new(0,3.2,0)
        bb.AlwaysOnTop=true;bb.Parent=at
        local lb=Instance.new("TextLabel");lb.Size=UDim2.new(1,0,1,0)
        lb.BackgroundTransparency=1;lb.Font=Enum.Font.GothamBold;lb.TextSize=14
        lb.TextColor3=Color3.fromRGB(255,255,0);lb.TextStrokeTransparency=0;lb.Parent=bb
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then
            local cn;cn=RunService.Heartbeat:Connect(function()
                if not S.ESP then pcall(function() hl:Destroy() end);pcall(function() bb:Destroy() end);cn:Disconnect();return end
                if not char or not char.Parent then cn:Disconnect();return end
                local d=""
                pcall(function()
                    local a=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                    local b=char:FindFirstChild("HumanoidRootPart")
                    if a and b then d=" ["..math.floor((a.Position-b.Position).Magnitude).."m]" end
                end)
                lb.Text=plr.Name.." "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)..d
            end)
            table.insert(espC,cn)
        end
    end
    if plr.Character then oc(plr.Character) end
    table.insert(espC,plr.CharacterAdded:Connect(function(ch) if S.ESP then oc(ch) end end))
end

AddSep("Visuals")
AddToggle("ESP + Distance",function(s)
    S.ESP=s
    if s then
        for _,p in ipairs(Players:GetPlayers()) do doESP(p) end
        table.insert(espC,Players.PlayerAdded:Connect(function(p) if S.ESP then doESP(p) end end))
    else dcESP();task.defer(nukeESP) end
end)

-- ═══════════════════════════════════════════════
--  2. TRACERS
-- ═══════════════════════════════════════════════
local tL={};local tCn
local function clrT()
    if tCn then tCn:Disconnect();tCn=nil end
    for _,l in ipairs(tL) do pcall(function() l:Remove() end) end;tL={}
end

AddToggle("Tracers",function(s)
    S.Tracers=s
    if s then clrT()
        tCn=RunService.RenderStepped:Connect(function()
            for i=#tL,1,-1 do pcall(function() tL[i]:Remove() end);table.remove(tL,i) end
            if not S.Tracers then clrT();return end
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and p.Character then
                    local hr=p.Character:FindFirstChild("HumanoidRootPart")
                    local hm=p.Character:FindFirstChildOfClass("Humanoid")
                    if hr and hm and hm.Health>0 then
                        local ps,vs=Camera:WorldToViewportPoint(hr.Position)
                        if vs then
                            local ok,ln=pcall(function()
                                local l=Drawing.new("Line")
                                l.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y)
                                l.To=Vector2.new(ps.X,ps.Y);l.Color=Color3.fromRGB(0,255,255)
                                l.Thickness=1.4;l.Transparency=1;l.Visible=true;return l
                            end)
                            if ok and ln then table.insert(tL,ln) end
                        end
                    end
                end
            end
        end)
    else clrT() end
end)

-- ═══════════════════════════════════════════════
--  3. AIMBOT — 3 METHODS AUTO-DETECT
-- ═══════════════════════════════════════════════
AddSep("Combat")

local fovC,aimDot
pcall(function()
    fovC=Drawing.new("Circle");fovC.Color=C.accent;fovC.Thickness=1.5
    fovC.Filled=false;fovC.Transparency=0.6;fovC.NumSides=72
    fovC.Radius=S.AimFOV;fovC.Visible=false
end)
pcall(function()
    aimDot=Drawing.new("Circle");aimDot.Color=C.green;aimDot.Thickness=0
    aimDot.Filled=true;aimDot.Transparency=1;aimDot.NumSides=20
    aimDot.Radius=5;aimDot.Visible=false
end)

local aimHold=false
local AIMBOT_BOUND=false
local savedCamType=nil

local function getClosest()
    Camera=workspace.CurrentCamera
    local best,bestD=nil,S.AimFOV
    local cx,cy=Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2
    local ctr=Vector2.new(cx,cy)

    for _,t in ipairs(getTargets()) do
        local ps,on=Camera:WorldToViewportPoint(t.part.Position)
        if on then
            local d=(Vector2.new(ps.X,ps.Y)-ctr).Magnitude
            if d<bestD then
                if S.AimWall then
                    local rp=RaycastParams.new()
                    rp.FilterType=Enum.RaycastFilterType.Blacklist
                    rp.FilterDescendantsInstances={LP.Character,Camera}
                    local r=workspace:Raycast(Camera.CFrame.Position,(t.part.Position-Camera.CFrame.Position).Unit*2000,rp)
                    if r and not r.Instance:IsDescendantOf(t.ch) then continue end
                end
                bestD=d;best=t
            end
        end
    end
    return best
end

local function bindAim()
    if AIMBOT_BOUND then return end;AIMBOT_BOUND=true

    RunService:BindToRenderStep("ZRP_Aim",Enum.RenderPriority.Camera.Value+10,function()
        Camera=workspace.CurrentCamera
        local cx,cy=Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2

        -- FOV circle
        if fovC then
            if S.Aim and S.AimShowFOV then
                fovC.Position=Vector2.new(cx,cy);fovC.Radius=S.AimFOV;fovC.Visible=true
            else fovC.Visible=false end
        end

        if not S.Aim or not aimHold then
            if aimDot then aimDot.Visible=false end
            -- Restore camera type when not holding
            if savedCamType then
                pcall(function() Camera.CameraType=savedCamType end)
                savedCamType=nil
            end
            return
        end

        local target=getClosest()
        if not target then
            if aimDot then aimDot.Visible=false end
            if savedCamType then
                pcall(function() Camera.CameraType=savedCamType end)
                savedCamType=nil
            end
            return
        end

        local tPos=target.part.Position
        local camPos=Camera.CFrame.Position

        -- Show dot on target
        if aimDot then
            local sp=Camera:WorldToViewportPoint(tPos)
            aimDot.Position=Vector2.new(sp.X,sp.Y);aimDot.Visible=true
        end

        local screenPos,onScreen=Camera:WorldToViewportPoint(tPos)
        if not onScreen then return end

        local deltaX=screenPos.X-cx
        local deltaY=screenPos.Y-cy

        -- ═══ METHOD 1: mousemoverel (BEST — works in 1st person) ═══
        if mouseMove then
            local sx=deltaX/S.AimSmooth
            local sy=deltaY/S.AimSmooth
            local mx=200
            sx=math.clamp(sx,-mx,mx)
            sy=math.clamp(sy,-mx,mx)
            if math.abs(sx)>0.3 or math.abs(sy)>0.3 then
                mouseMove(sx,sy)
            end

        -- ═══ METHOD 2: VirtualInputManager ═══
        elseif VIM then
            pcall(function()
                local sx=deltaX/S.AimSmooth
                local sy=deltaY/S.AimSmooth
                VIM:SendMouseMoveEvent(sx,sy,workspace)
            end)

        -- ═══ METHOD 3: Scriptable Camera (UNIVERSAL FALLBACK) ═══
        else
            -- Save original camera type ONCE
            if not savedCamType then
                savedCamType=Camera.CameraType
            end

            -- Set to scriptable so Roblox doesn't override us
            Camera.CameraType=Enum.CameraType.Scriptable

            local dir=(tPos-camPos).Unit
            local goal=CFrame.lookAt(camPos,camPos+dir)
            local alpha=math.clamp(1/S.AimSmooth,0.05,1)
            Camera.CFrame=Camera.CFrame:Lerp(goal,alpha)
        end

        -- Rotate character body toward target (helps bullets hit)
        pcall(function()
            local hrp=LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local d=(tPos-hrp.Position)
                local flat=Vector3.new(d.X,0,d.Z)
                if flat.Magnitude>0.1 then
                    hrp.CFrame=CFrame.lookAt(hrp.Position,hrp.Position+flat.Unit)
                end
            end
        end)
    end)
end

local function unbindAim()
    AIMBOT_BOUND=false
    pcall(function() RunService:UnbindFromRenderStep("ZRP_Aim") end)
    if fovC then fovC.Visible=false end
    if aimDot then aimDot.Visible=false end
    if savedCamType then
        pcall(function() Camera.CameraType=savedCamType end)
        savedCamType=nil
    end
end

AddToggle("Aimbot (RMB / Q)",function(s)
    S.Aim=s; if s then bindAim() else unbindAim() end
end)

UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.UserInputType==Enum.UserInputType.MouseButton2 or i.KeyCode==Enum.KeyCode.Q then aimHold=true end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton2 or i.KeyCode==Enum.KeyCode.Q then aimHold=false end
end)

-- ═══════════════════════════════════════════════
--  4. INFINITE AMMO
-- ═══════════════════════════════════════════════
local ammoKW={"ammo","clip","mag","bullet","round","cartridge","shell","reserve","currentammo","maxammo"}
local function pV(root) for _,d in ipairs(root:GetDescendants()) do
    if d:IsA("NumberValue") or d:IsA("IntValue") then
        local n=d.Name:lower()
        for _,k in ipairs(ammoKW) do if n:find(k) then d.Value=9999;break end end
    end
end end

AddToggle("Infinite Ammo",function(s)
    S.InfAmmo=s;LoopID.Ammo=LoopID.Ammo+1
    if s then local id=LoopID.Ammo;task.spawn(function()
        while S.InfAmmo and LoopID.Ammo==id do pcall(function()
            local ch=LP.Character
            if ch then for _,t in ipairs(ch:GetChildren()) do
                if t:IsA("Tool") or t:IsA("Model") then pV(t) end
            end end
            local bp=LP:FindFirstChild("Backpack");if bp then pV(bp) end
            pV(LP.PlayerGui)
        end);task.wait(0.1) end
    end) end
end)

-- ═══════════════════════════════════════════════
--  5. NO RECOIL
-- ═══════════════════════════════════════════════
local rcKW={"recoil","spread","kick","sway","bloom","deviation","scatter","shake","aimkick","camkick","visual_recoil"}

AddToggle("No Recoil",function(s)
    S.NoRecoil=s;LoopID.Recoil=LoopID.Recoil+1
    if s then local id=LoopID.Recoil;task.spawn(function()
        while S.NoRecoil and LoopID.Recoil==id do pcall(function()
            local function zr(r) for _,d in ipairs(r:GetDescendants()) do
                if d:IsA("NumberValue") or d:IsA("IntValue") then
                    local n=d.Name:lower()
                    for _,k in ipairs(rcKW) do if n:find(k) then d.Value=0;break end end
                end
            end end
            local ch=LP.Character
            if ch then for _,t in ipairs(ch:GetChildren()) do
                if t:IsA("Tool") or t:IsA("Model") then zr(t) end
            end end
            local bp=LP:FindFirstChild("Backpack");if bp then zr(bp) end
        end);task.wait(0.1) end
    end) end
end)

-- ═══════════════════════════════════════════════
--  6. GOD MODE — MULTI-LAYER
-- ═══════════════════════════════════════════════
local godC={}
local function clrGod() for _,c in ipairs(godC) do pcall(function() c:Disconnect() end) end;godC={} end

local function applyGod(ch)
    if not ch then return end
    local hum=ch:FindFirstChildOfClass("Humanoid");if not hum then return end
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false) end)
    pcall(function() hum.MaxHealth=math.huge;hum.Health=math.huge end)
    pcall(function()
        local hs=ch:FindFirstChild("Health")
        if hs and hs:IsA("Script") then hs:Destroy() end
    end)
    pcall(function()
        if not ch:FindFirstChildOfClass("ForceField") then
            local ff=Instance.new("ForceField",ch);ff.Visible=false
        end
    end)
    -- Block health changes
    local hc=hum.HealthChanged:Connect(function(h)
        if S.God and h<math.huge then
            task.defer(function() pcall(function() hum.Health=math.huge end) end)
        end
    end)
    table.insert(godC,hc)
    -- Kill damage scripts
    pcall(function()
        for _,o in ipairs(ch:GetDescendants()) do
            local n=o.Name:lower()
            if o:IsA("Script") and (n:find("damage") or n:find("hurt") or n:find("kill")) then o:Destroy() end
        end
    end)
end

local function remGod(ch)
    if not ch then return end
    pcall(function()
        local hum=ch:FindFirstChildOfClass("Humanoid")
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Dead,true);hum.MaxHealth=100;hum.Health=100 end
    end)
    pcall(function() local ff=ch:FindFirstChildOfClass("ForceField");if ff then ff:Destroy() end end)
end

AddToggle("God Mode",function(s)
    S.God=s;LoopID.God=(LoopID.God or 0)+1;clrGod()
    if s then
        applyGod(LP.Character)
        table.insert(godC,LP.CharacterAdded:Connect(function(ch) task.wait(1);if S.God then applyGod(ch) end end))
        local id=LoopID.God
        task.spawn(function()
            while S.God and LoopID.God==id do pcall(function()
                local ch=LP.Character;if not ch then return end
                local hum=ch:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
                    if hum.Health<math.huge then hum.Health=math.huge end
                    if hum.MaxHealth<math.huge then hum.MaxHealth=math.huge end
                end
                if not ch:FindFirstChildOfClass("ForceField") then
                    local ff=Instance.new("ForceField",ch);ff.Visible=false
                end
            end);task.wait(0.03) end
        end)
    else remGod(LP.Character) end
end)

-- ═══════════════════════════════════════════════
--  7. SPEED HACK
-- ═══════════════════════════════════════════════
AddSep("Movement")

AddToggle("Speed (x"..S.SpeedVal..")",function(s)
    S.Speed=s
    pcall(function() LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed=s and S.SpeedVal or 16 end)
end)
LP.CharacterAdded:Connect(function(ch) task.wait(1)
    if S.Speed then pcall(function() ch:FindFirstChildOfClass("Humanoid").WalkSpeed=S.SpeedVal end) end
end)

-- ═══════════════════════════════════════════════
--  8. NOCLIP
-- ═══════════════════════════════════════════════
local ncCn;local ncS={}

AddToggle("Noclip",function(s)
    S.Noclip=s
    if s then
        ncS={}
        pcall(function() for _,p in ipairs(LP.Character:GetDescendants()) do
            if p:IsA("BasePart") then ncS[p]=p.CanCollide end
        end end)
        if ncCn then ncCn:Disconnect() end
        ncCn=RunService.Stepped:Connect(function()
            if not S.Noclip then ncCn:Disconnect();ncCn=nil;return end
            pcall(function() for _,p in ipairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide=false end
            end end)
        end)
    else
        if ncCn then ncCn:Disconnect();ncCn=nil end
        task.defer(function()
            for pt,og in pairs(ncS) do pcall(function() if pt and pt.Parent then pt.CanCollide=og end end) end;ncS={}
            pcall(function() local ch=LP.Character;if not ch then return end
                for _,nm in ipairs({"HumanoidRootPart","Head","Torso","UpperTorso","LowerTorso"}) do
                    local p=ch:FindFirstChild(nm);if p and p:IsA("BasePart") then p.CanCollide=true end
                end
            end)
        end)
    end
end)

-- ═══════════════════════════════════════════════
--  9. FLY
-- ═══════════════════════════════════════════════
local flCn,flBV,flBG
local function stopFly()
    S.Fly=false
    if flCn then flCn:Disconnect();flCn=nil end
    if flBV then pcall(function() flBV:Destroy() end);flBV=nil end
    if flBG then pcall(function() flBG:Destroy() end);flBG=nil end
    pcall(function() LP.Character:FindFirstChildOfClass("Humanoid").PlatformStand=false end)
end
local function startFly()
    stopFly();S.Fly=true
    local ch=LP.Character;if not ch then return end
    local hr=ch:FindFirstChild("HumanoidRootPart")
    local hm=ch:FindFirstChildOfClass("Humanoid");if not hr or not hm then return end
    hm.PlatformStand=true
    flBV=Instance.new("BodyVelocity");flBV.MaxForce=Vector3.one*1e9;flBV.Velocity=Vector3.zero;flBV.Parent=hr
    flBG=Instance.new("BodyGyro");flBG.MaxTorque=Vector3.one*1e9;flBG.P=9e4;flBG.D=500;flBG.Parent=hr
    flCn=RunService.RenderStepped:Connect(function()
        if not S.Fly or not hr or not hr.Parent then stopFly();return end
        local dir=Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.yAxis end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.yAxis end
        flBV.Velocity=dir.Magnitude>0 and dir.Unit*S.FlySpeed or Vector3.zero
        flBG.CFrame=Camera.CFrame
    end)
end

AddToggle("Fly (WASD+Space+Shift)",function(s) if s then startFly() else stopFly() end end)
LP.CharacterAdded:Connect(function() if S.Fly then stopFly() end end)

-- ═══════════════════════════════════════════════
--  10. SPINNER + BHOP (НОВОЕ)
-- ═══════════════════════════════════════════════
AddSep("Fun")

local spinCn,spinBAV
local origJP=50

local function stopSpin()
    S.Spin=false
    if spinCn then spinCn:Disconnect();spinCn=nil end
    if spinBAV then pcall(function() spinBAV:Destroy() end);spinBAV=nil end
    pcall(function()
        local hum=LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            -- Restore jump
            if hum:FindFirstChild("UseJumpPower") then
                hum.JumpPower=origJP
            else
                hum.JumpHeight=7.2 -- default
            end
        end
    end)
end

local function startSpin()
    stopSpin();S.Spin=true
    local ch=LP.Character;if not ch then return end
    local hr=ch:FindFirstChild("HumanoidRootPart")
    local hum=ch:FindFirstChildOfClass("Humanoid")
    if not hr or not hum then return end

    -- Save original jump
    pcall(function()
        if hum:FindFirstChild("UseJumpPower") then
            origJP=hum.JumpPower
            hum.JumpPower=origJP+S.SpinJumpBoost
        else
            origJP=hum.JumpHeight
            hum.JumpHeight=origJP+3
        end
    end)

    -- BodyAngularVelocity for spinning
    spinBAV=Instance.new("BodyAngularVelocity")
    spinBAV.MaxTorque=Vector3.new(0,math.huge,0)
    spinBAV.AngularVelocity=Vector3.new(0,math.rad(S.SpinSpeed),0)
    spinBAV.Parent=hr

    -- Auto-bhop
    spinCn=RunService.Heartbeat:Connect(function()
        if not S.Spin then stopSpin();return end
        local ch2=LP.Character;if not ch2 then return end
        local hum2=ch2:FindFirstChildOfClass("Humanoid")
        if not hum2 then return end

        -- Auto jump when on ground
        if hum2.FloorMaterial~=Enum.Material.Air then
            hum2:ChangeState(Enum.HumanoidStateType.Jumping)
        end

        -- Keep jump boost applied
        pcall(function()
            if hum2:FindFirstChild("UseJumpPower") then
                if hum2.JumpPower<origJP+S.SpinJumpBoost then
                    hum2.JumpPower=origJP+S.SpinJumpBoost
                end
            end
        end)

        -- Make sure spin body velocity exists
        pcall(function()
            local hr2=ch2:FindFirstChild("HumanoidRootPart")
            if hr2 and not hr2:FindFirstChildOfClass("BodyAngularVelocity") then
                spinBAV=Instance.new("BodyAngularVelocity")
                spinBAV.MaxTorque=Vector3.new(0,math.huge,0)
                spinBAV.AngularVelocity=Vector3.new(0,math.rad(S.SpinSpeed),0)
                spinBAV.Parent=hr2
            end
        end)
    end)
end

AddToggle("Spinner + Bhop",function(s) if s then startSpin() else stopSpin() end end)

-- Re-apply on respawn
LP.CharacterAdded:Connect(function(ch)
    task.wait(1)
    if S.Spin then
        stopSpin()
        S.Spin=true -- re-enable
        startSpin()
    end
end)

-- ═══════════════════════════════════════════════
--  11. FPS BOOST
-- ═══════════════════════════════════════════════
AddSep("Performance")

AddAction("FPS BOOST (Massive)",function()
    pcall(function()
        settings().Rendering.QualityLevel=Enum.QualityLevel.Level01
        UserSettings():GetService("UserGameSettings").SavedQualityLevel=Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function() Lighting.GlobalShadows=false;Lighting.FogEnd=9e9 end)
    for _,n in ipairs({"BloomEffect","BlurEffect","ColorCorrectionEffect","SunRaysEffect","DepthOfFieldEffect","Atmosphere"}) do
        for _,o in ipairs(Lighting:GetChildren()) do if o:IsA(n) then pcall(function() o:Destroy() end) end end
        for _,o in ipairs(Camera:GetChildren()) do if o:IsA(n) then pcall(function() o:Destroy() end) end end
    end
    for _,o in ipairs(workspace:GetDescendants()) do
        for _,c in ipairs({"ParticleEmitter","Fire","Smoke","Sparkles","Trail","Beam","PointLight","SpotLight","SurfaceLight"}) do
            if o:IsA(c) then pcall(function() o:Destroy() end);break end
        end
    end
    for _,o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Decal") or o:IsA("Texture") then pcall(function() o.Transparency=1 end) end
        if o:IsA("MeshPart") then pcall(function() o.RenderFidelity=Enum.RenderFidelity.Performance end) end
        if o:IsA("BasePart") then pcall(function() o.CastShadow=false end) end
    end
    pcall(function()
        local t=workspace.Terrain;t.WaterWaveSize=0;t.WaterWaveSpeed=0
        t.WaterReflectance=0;t.WaterTransparency=0;t.Decoration=false
    end)
    pcall(function() if sethiddenproperty then sethiddenproperty(Lighting,"Technology",Enum.Technology.Compatibility) end end)
    pcall(function() collectgarbage("collect") end)
    print("[ZRP] FPS BOOST done!")
end)

-- ═══════════════════════════════════════════════
--  HOTKEY H
-- ═══════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode==Enum.KeyCode.H then MF.Visible=not MF.Visible end
end)

-- ═══════════════════════════════════════════════
--  LOADED
-- ═══════════════════════════════════════════════
pcall(function()
    StarterGui:SetCore("SendNotification",{
        Title="🍆 Zalupa RP v7",
        Text="Loaded! Aim method: "..aimMethodName.."\nH=menu | RMB/Q=aim",
        Duration=7
    })
end)
print("[Zalupa RP v7] Loaded | Aimbot: "..aimMethodName)
