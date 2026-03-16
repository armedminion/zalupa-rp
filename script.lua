--// ══════════════════════════════════════════════════════════
--//   Zalupa RP by armedminion  v11
--//   Safe Spinner (no disappear) | Rejoin button
--// ══════════════════════════════════════════════════════════

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local StarterGui=game:GetService("StarterGui")
local Lighting=game:GetService("Lighting")
local TweenService=game:GetService("TweenService")
local TeleportService=game:GetService("TeleportService")
local LP=Players.LocalPlayer
local Camera=workspace.CurrentCamera

local S={
    ESP=false,Tracers=false,Speed=false,Noclip=false,SpeedVal=100,
    God=false,InfAmmo=false,NoRecoil=false,
    Fly=false,FlySpeed=80,
    Aim=false,AimFOV=300,AimSmooth=2,AimPart="Head",
    AimShowFOV=true,AimWall=false,AimTeam=false,
    Spin=false,SpinSpeed=1500,SpinJump=30,
    AntiRag=false,
}
local LID={God=0,Ammo=0,Recoil=0}

local gP
pcall(function() gP=(gethui and gethui()) or game:GetService("CoreGui") end)
if not gP then gP=game:GetService("CoreGui") end
if gP:FindFirstChild("ZRP11") then gP.ZRP11:Destroy() end
pcall(function() RunService:UnbindFromRenderStep("ZRP_Aim") end)
pcall(function() RunService:UnbindFromRenderStep("ZRP_Spin") end)
pcall(function() RunService:UnbindFromRenderStep("ZRP_AntiRag") end)

-- ══════ MOUSE MOVE ══════
local mmr=nil;local aimMethod="none"
pcall(function() if type(mousemoverel)=="function" then mmr=mousemoverel;aimMethod="mousemoverel" end end)
if not mmr then pcall(function() if type(mouse_moverel)=="function" then mmr=mouse_moverel;aimMethod="mouse_moverel" end end) end
if not mmr then pcall(function() if getgenv and type(getgenv().mousemoverel)=="function" then mmr=getgenv().mousemoverel;aimMethod="getgenv" end end) end
if not mmr then pcall(function() if type(Input)=="table" and type(Input.MouseMove)=="function" then mmr=function(x,y) Input.MouseMove(x,y) end;aimMethod="Input" end end) end
if not mmr then pcall(function() local v=game:GetService("VirtualInputManager");if v then mmr=function(x,y) v:SendMouseMoveEvent(x,y,workspace) end;aimMethod="VIM" end end) end
if not mmr then aimMethod="scriptable" end
warn("[ZRP v11] Aim: "..aimMethod)

-- ══════ COLORS ══════
local C={
    bg=Color3.fromRGB(10,10,20),btn=Color3.fromRGB(25,25,44),
    btnH=Color3.fromRGB(35,35,58),btnOn=Color3.fromRGB(200,35,65),
    accent=Color3.fromRGB(255,45,75),accent2=Color3.fromRGB(130,80,255),
    text=Color3.fromRGB(225,225,240),dim=Color3.fromRGB(110,110,140),
    green=Color3.fromRGB(30,200,90),sep=Color3.fromRGB(255,75,110),
}

-- ══════════════════════════════════════════════
--  GUI
-- ══════════════════════════════════════════════
local SG=Instance.new("ScreenGui");SG.Name="ZRP11";SG.Parent=gP
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;SG.ResetOnSpawn=false

local MF=Instance.new("Frame");MF.Name="Main";MF.Parent=SG;MF.BackgroundColor3=C.bg
MF.BorderSizePixel=0;MF.Position=UDim2.new(0.01,0,0.03,0);MF.Size=UDim2.new(0,275,0,650)
MF.Active=true;MF.ClipsDescendants=true
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,14)

local gw=Instance.new("UIStroke");gw.Parent=MF;gw.Thickness=2;gw.Transparency=0.15
local gwG=Instance.new("UIGradient");gwG.Parent=gw
gwG.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,C.accent),ColorSequenceKeypoint.new(0.5,C.accent2),ColorSequenceKeypoint.new(1,C.accent)}
task.spawn(function() while MF and MF.Parent do for r=0,360,3 do gwG.Rotation=r;task.wait(0.03) end end end)

do local d,ds,sp
    MF.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then
        d=true;ds=i.Position;sp=MF.Position
        i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then d=false end end) end end)
    UIS.InputChanged:Connect(function(i) if d and i.UserInputType==Enum.UserInputType.MouseMovement then
        local dt=i.Position-ds;MF.Position=UDim2.new(sp.X.Scale,sp.X.Offset+dt.X,sp.Y.Scale,sp.Y.Offset+dt.Y) end end)
end

local tB=Instance.new("Frame");tB.Parent=MF;tB.Size=UDim2.new(1,0,0,3);tB.BorderSizePixel=0;tB.BackgroundColor3=Color3.new(1,1,1)
local tBG=Instance.new("UIGradient");tBG.Parent=tB
tBG.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,C.accent),ColorSequenceKeypoint.new(0.5,C.accent2),ColorSequenceKeypoint.new(1,C.accent)}

local tF=Instance.new("Frame");tF.Parent=MF;tF.BackgroundTransparency=1;tF.Position=UDim2.new(0,0,0,3);tF.Size=UDim2.new(1,0,0,55)
local t1=Instance.new("TextLabel");t1.Parent=tF;t1.BackgroundTransparency=1;t1.Position=UDim2.new(0,14,0,8);t1.Size=UDim2.new(0,35,0,35)
t1.Font=Enum.Font.GothamBlack;t1.TextSize=28;t1.Text="🍆";t1.TextColor3=C.accent
local t2=Instance.new("TextLabel");t2.Parent=tF;t2.BackgroundTransparency=1;t2.Position=UDim2.new(0,50,0,5);t2.Size=UDim2.new(1,-60,0,22)
t2.Font=Enum.Font.GothamBlack;t2.TextSize=18;t2.Text="ZALUPA RP";t2.TextColor3=C.text;t2.TextXAlignment=Enum.TextXAlignment.Left
local t3=Instance.new("TextLabel");t3.Parent=tF;t3.BackgroundTransparency=1;t3.Position=UDim2.new(0,50,0,27);t3.Size=UDim2.new(1,-60,0,16)
t3.Font=Enum.Font.Gotham;t3.TextSize=9;t3.Text="by armedminion • v11 • [H] • "..aimMethod
t3.TextColor3=C.dim;t3.TextXAlignment=Enum.TextXAlignment.Left

local cBtn=Instance.new("TextButton");cBtn.Parent=tF;cBtn.BackgroundColor3=Color3.fromRGB(55,18,28)
cBtn.Position=UDim2.new(1,-38,0,10);cBtn.Size=UDim2.new(0,26,0,26);cBtn.Font=Enum.Font.GothamBold;cBtn.TextSize=14
cBtn.Text="×";cBtn.TextColor3=C.accent;cBtn.BorderSizePixel=0
Instance.new("UICorner",cBtn).CornerRadius=UDim.new(0,6)
cBtn.MouseButton1Click:Connect(function() MF.Visible=false end)

local dvF=Instance.new("Frame");dvF.Parent=MF;dvF.Position=UDim2.new(0.05,0,0,58)
dvF.Size=UDim2.new(0.9,0,0,1);dvF.BorderSizePixel=0;dvF.BackgroundColor3=Color3.fromRGB(45,45,75)

local SF=Instance.new("ScrollingFrame");SF.Parent=MF;SF.Position=UDim2.new(0,0,0,62);SF.Size=UDim2.new(1,0,1,-62)
SF.BackgroundTransparency=1;SF.BorderSizePixel=0;SF.ScrollBarThickness=3;SF.ScrollBarImageColor3=C.accent
SF.CanvasSize=UDim2.new(0,0,0,0);SF.AutomaticCanvasSize=Enum.AutomaticSize.Y
local LL=Instance.new("UIListLayout");LL.Parent=SF;LL.SortOrder=Enum.SortOrder.LayoutOrder;LL.Padding=UDim.new(0,3)
local pd=Instance.new("UIPadding");pd.Parent=SF;pd.PaddingLeft=UDim.new(0,10);pd.PaddingRight=UDim.new(0,10)
pd.PaddingTop=UDim.new(0,6);pd.PaddingBottom=UDim.new(0,10)

local lo=0

local function AddSep(t)
    lo=lo+1;local f=Instance.new("Frame");f.Parent=SF;f.BackgroundTransparency=1;f.Size=UDim2.new(1,0,0,22);f.LayoutOrder=lo
    local d2=Instance.new("Frame");d2.Parent=f;d2.BackgroundColor3=C.accent;d2.Position=UDim2.new(0,0,0.5,-3);d2.Size=UDim2.new(0,6,0,6);d2.BorderSizePixel=0
    Instance.new("UICorner",d2).CornerRadius=UDim.new(1,0)
    local l=Instance.new("TextLabel");l.Parent=f;l.BackgroundTransparency=1;l.Position=UDim2.new(0,12,0,0);l.Size=UDim2.new(1,-12,1,0)
    l.Font=Enum.Font.GothamBold;l.TextSize=11;l.Text=t:upper();l.TextColor3=C.sep;l.TextXAlignment=Enum.TextXAlignment.Left
end

local function AddToggle(label,cb)
    lo=lo+1
    local h=Instance.new("Frame");h.Parent=SF;h.BackgroundColor3=C.btn;h.Size=UDim2.new(1,0,0,34);h.BorderSizePixel=0;h.LayoutOrder=lo
    Instance.new("UICorner",h).CornerRadius=UDim.new(0,8)
    local ind=Instance.new("Frame");ind.Parent=h;ind.BackgroundColor3=Color3.fromRGB(70,70,95)
    ind.Position=UDim2.new(0,10,0.5,-5);ind.Size=UDim2.new(0,10,0,10);ind.BorderSizePixel=0
    Instance.new("UICorner",ind).CornerRadius=UDim.new(1,0)
    local lb=Instance.new("TextLabel");lb.Parent=h;lb.BackgroundTransparency=1;lb.Position=UDim2.new(0,26,0,0);lb.Size=UDim2.new(1,-85,1,0)
    lb.Font=Enum.Font.GothamSemibold;lb.TextSize=12;lb.Text=label;lb.TextColor3=C.text;lb.TextXAlignment=Enum.TextXAlignment.Left
    local st=Instance.new("TextLabel");st.Parent=h;st.BackgroundTransparency=1;st.Position=UDim2.new(1,-50,0,0);st.Size=UDim2.new(0,40,1,0)
    st.Font=Enum.Font.GothamBold;st.TextSize=11;st.Text="OFF";st.TextColor3=C.dim
    local btn=Instance.new("TextButton");btn.Parent=h;btn.BackgroundTransparency=1;btn.Size=UDim2.new(1,0,1,0);btn.Text="";btn.ZIndex=5
    btn.MouseEnter:Connect(function() TweenService:Create(h,TweenInfo.new(0.12),{BackgroundColor3=C.btnH}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(h,TweenInfo.new(0.12),{BackgroundColor3=st.Text=="ON" and C.btnOn or C.btn}):Play() end)
    local on=false
    btn.MouseButton1Click:Connect(function()
        on=not on;st.Text=on and "ON" or "OFF";st.TextColor3=on and C.green or C.dim
        ind.BackgroundColor3=on and C.green or Color3.fromRGB(70,70,95)
        TweenService:Create(h,TweenInfo.new(0.15),{BackgroundColor3=on and C.btnOn or C.btn}):Play()
        cb(on)
    end)
end

local function AddAction(label,cb)
    lo=lo+1
    local h=Instance.new("Frame");h.Parent=SF;h.BackgroundColor3=Color3.fromRGB(32,22,52)
    h.Size=UDim2.new(1,0,0,34);h.BorderSizePixel=0;h.LayoutOrder=lo
    Instance.new("UICorner",h).CornerRadius=UDim.new(0,8)
    local lb=Instance.new("TextLabel");lb.Parent=h;lb.BackgroundTransparency=1;lb.Position=UDim2.new(0,12,0,0);lb.Size=UDim2.new(1,-20,1,0)
    lb.Font=Enum.Font.GothamBold;lb.TextSize=12;lb.Text="⚡ "..label
    lb.TextColor3=Color3.fromRGB(195,165,255);lb.TextXAlignment=Enum.TextXAlignment.Left
    local btn=Instance.new("TextButton");btn.Parent=h;btn.BackgroundTransparency=1;btn.Size=UDim2.new(1,0,1,0);btn.Text="";btn.ZIndex=5
    btn.MouseEnter:Connect(function() TweenService:Create(h,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(48,35,72)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(h,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(32,22,52)}):Play() end)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(h,TweenInfo.new(0.15),{BackgroundColor3=C.green}):Play();lb.Text="✅ "..label.." — DONE";cb()
        task.delay(2,function() TweenService:Create(h,TweenInfo.new(0.2),{BackgroundColor3=Color3.fromRGB(32,22,52)}):Play();lb.Text="⚡ "..label end)
    end)
end

-- ══════════════════════════════════════════════
--  ANTI-RAGDOLL CORE
-- ══════════════════════════════════════════════
local function forceAntiRagdoll(ch)
    if not ch then return end
    local hum=ch:FindFirstChildOfClass("Humanoid");if not hum then return end

    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false) end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,false) end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,false) end)
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Physics,false) end)
    pcall(function() hum.PlatformStand=false end)
    pcall(function() hum.Sit=false end)

    local state=hum:GetState()
    if state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown
    or state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.PlatformStanding then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end

    pcall(function() for _,o in ipairs(ch:GetDescendants()) do
        if o:IsA("Motor6D") then o.Enabled=true end
        if o:IsA("BallSocketConstraint") then o.Enabled=false end
        if o:IsA("NoCollisionConstraint") then o.Enabled=false end
    end end)

    pcall(function() for _,o in ipairs(ch:GetDescendants()) do
        if (o:IsA("Script") or o:IsA("LocalScript") or o:IsA("ModuleScript")) then
            if o.Name:lower():find("ragdoll") then pcall(function() o.Disabled=true end);pcall(function() o:Destroy() end) end
        end
        if o:IsA("BoolValue") then
            local n=o.Name:lower()
            if n:find("ragdoll") or n:find("stun") or n:find("knocked") then o.Value=false end
        end
    end end)

    pcall(function()
        ch:SetAttribute("Ragdolled",nil)
        ch:SetAttribute("ragdolled",nil)
        ch:SetAttribute("IsRagdolled",nil)
    end)
end

-- ══════════════════════════════════════════════
--  UTILITY
-- ══════════════════════════════════════════════
local function nukeESP()
    for _,p in ipairs(Players:GetPlayers()) do if p.Character then
        for _,o in ipairs(p.Character:GetDescendants()) do
            if o.Name=="_ESP" or o.Name=="_ESPBb" then pcall(function() o:Destroy() end) end end end end
end

local function getTargets()
    local t={}
    for _,p in ipairs(Players:GetPlayers()) do
        if p==LP then continue end
        if S.AimTeam and p.Team and p.Team==LP.Team then continue end
        local ch=p.Character;if not ch then continue end
        local hum=ch:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health<=0 then continue end
        local part=ch:FindFirstChild(S.AimPart) or ch:FindFirstChild("Head") or ch:FindFirstChild("HumanoidRootPart")
        if not part then pcall(function() part=hum.RootPart end) end
        if part then table.insert(t,{p=p,part=part,hum=hum,ch=ch}) end
    end;return t
end

-- ═══════════════════════════════════════════════
--  1. ESP
-- ═══════════════════════════════════════════════
local espC={}
local function dcESP() for _,c in ipairs(espC) do pcall(function() c:Disconnect() end) end;espC={} end
local function doESP(plr)
    if plr==LP then return end
    local function oc(char)
        task.wait(0.6);if not S.ESP then return end
        for _,o in ipairs(char:GetChildren()) do if o.Name=="_ESP" or o.Name=="_ESPBb" then o:Destroy() end end
        local hl=Instance.new("Highlight");hl.Name="_ESP";hl.FillColor=Color3.fromRGB(255,0,0)
        hl.FillTransparency=0.5;hl.OutlineColor=Color3.new(1,1,1);hl.Adornee=char;hl.Parent=char
        local at=char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart");if not at then return end
        local bb=Instance.new("BillboardGui");bb.Name="_ESPBb";bb.Size=UDim2.new(0,220,0,44)
        bb.StudsOffset=Vector3.new(0,3.2,0);bb.AlwaysOnTop=true;bb.Parent=at
        local lbl=Instance.new("TextLabel");lbl.Size=UDim2.new(1,0,1,0);lbl.BackgroundTransparency=1
        lbl.Font=Enum.Font.GothamBold;lbl.TextSize=14;lbl.TextColor3=Color3.fromRGB(255,255,0)
        lbl.TextStrokeTransparency=0;lbl.Parent=bb
        local hum=char:FindFirstChildOfClass("Humanoid")
        if hum then local cn;cn=RunService.Heartbeat:Connect(function()
            if not S.ESP then pcall(function() hl:Destroy() end);pcall(function() bb:Destroy() end);cn:Disconnect();return end
            if not char or not char.Parent then cn:Disconnect();return end
            local d="";pcall(function() local a=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
                local b=char:FindFirstChild("HumanoidRootPart")
                if a and b then d=" ["..math.floor((a.Position-b.Position).Magnitude).."m]" end end)
            lbl.Text=plr.Name.." "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)..d
        end);table.insert(espC,cn) end
    end
    if plr.Character then oc(plr.Character) end
    table.insert(espC,plr.CharacterAdded:Connect(function(ch) if S.ESP then oc(ch) end end))
end

AddSep("Visuals")
AddToggle("ESP + Distance",function(s) S.ESP=s
    if s then for _,p in ipairs(Players:GetPlayers()) do doESP(p) end
        table.insert(espC,Players.PlayerAdded:Connect(function(p) if S.ESP then doESP(p) end end))
    else dcESP();task.defer(nukeESP) end
end)

-- ═══════════════════════════════════════════════
--  2. TRACERS
-- ═══════════════════════════════════════════════
local tL={};local tCn
local function clrT() if tCn then tCn:Disconnect();tCn=nil end;for _,l in ipairs(tL) do pcall(function() l:Remove() end) end;tL={} end
AddToggle("Tracers",function(s) S.Tracers=s
    if s then clrT();tCn=RunService.RenderStepped:Connect(function()
        for i=#tL,1,-1 do pcall(function() tL[i]:Remove() end);table.remove(tL,i) end
        if not S.Tracers then clrT();return end
        for _,p in ipairs(Players:GetPlayers()) do if p~=LP and p.Character then
            local hr=p.Character:FindFirstChild("HumanoidRootPart");local hm=p.Character:FindFirstChildOfClass("Humanoid")
            if hr and hm and hm.Health>0 then local ps,vs=Camera:WorldToViewportPoint(hr.Position)
                if vs then local ok,ln=pcall(function() local l=Drawing.new("Line")
                    l.From=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y);l.To=Vector2.new(ps.X,ps.Y)
                    l.Color=Color3.fromRGB(0,255,255);l.Thickness=1.4;l.Transparency=1;l.Visible=true;return l end)
                    if ok and ln then table.insert(tL,ln) end end end end end
    end) else clrT() end
end)

-- ═══════════════════════════════════════════════
--  3. AIMBOT
-- ═══════════════════════════════════════════════
AddSep("Combat")

local fovC,aimDot
pcall(function() fovC=Drawing.new("Circle");fovC.Color=C.accent;fovC.Thickness=1.5
    fovC.Filled=false;fovC.Transparency=0.6;fovC.NumSides=72;fovC.Radius=S.AimFOV;fovC.Visible=false end)
pcall(function() aimDot=Drawing.new("Circle");aimDot.Color=C.green;aimDot.Thickness=0
    aimDot.Filled=true;aimDot.Transparency=1;aimDot.NumSides=20;aimDot.Radius=5;aimDot.Visible=false end)

local aimHold=false

local function getClosest()
    Camera=workspace.CurrentCamera
    local best,bestD=nil,S.AimFOV
    local cx,cy=Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2
    for _,t in ipairs(getTargets()) do
        local ps,on=Camera:WorldToViewportPoint(t.part.Position)
        if on then local d=(Vector2.new(ps.X,ps.Y)-Vector2.new(cx,cy)).Magnitude
            if d<bestD then
                if S.AimWall then local rp=RaycastParams.new();rp.FilterType=Enum.RaycastFilterType.Blacklist
                    rp.FilterDescendantsInstances={LP.Character,Camera}
                    local r=workspace:Raycast(Camera.CFrame.Position,(t.part.Position-Camera.CFrame.Position).Unit*2000,rp)
                    if r and not r.Instance:IsDescendantOf(t.ch) then continue end end
                bestD=d;best=t end end
    end;return best
end

local function bindAim()
    pcall(function() RunService:UnbindFromRenderStep("ZRP_Aim") end)
    RunService:BindToRenderStep("ZRP_Aim",Enum.RenderPriority.Input.Value-1,function()
        Camera=workspace.CurrentCamera;local cx,cy=Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2
        if fovC then if S.Aim and S.AimShowFOV then fovC.Position=Vector2.new(cx,cy);fovC.Radius=S.AimFOV;fovC.Visible=true else fovC.Visible=false end end
        if not S.Aim or not aimHold then if aimDot then aimDot.Visible=false end;return end
        local target=getClosest();if not target then if aimDot then aimDot.Visible=false end;return end
        local sp,on=Camera:WorldToViewportPoint(target.part.Position);if not on then return end
        if aimDot then aimDot.Position=Vector2.new(sp.X,sp.Y);aimDot.Visible=true end
        local dx,dy=sp.X-cx,sp.Y-cy
        if mmr then
            local sx,sy=dx/S.AimSmooth,dy/S.AimSmooth
            sx=math.clamp(sx,-150,150);sy=math.clamp(sy,-150,150)
            if math.abs(dx)>1 or math.abs(dy)>1 then mmr(sx,sy) end
        else
            Camera.CameraType=Enum.CameraType.Scriptable
            local dir=(target.part.Position-Camera.CFrame.Position).Unit
            Camera.CFrame=Camera.CFrame:Lerp(CFrame.lookAt(Camera.CFrame.Position,Camera.CFrame.Position+dir),math.clamp(1/S.AimSmooth,0.1,1))
        end
    end)
end
local function unbindAim()
    pcall(function() RunService:UnbindFromRenderStep("ZRP_Aim") end)
    if fovC then fovC.Visible=false end;if aimDot then aimDot.Visible=false end
    pcall(function() if Camera.CameraType==Enum.CameraType.Scriptable then Camera.CameraType=Enum.CameraType.Custom end end)
end
AddToggle("Aimbot (RMB / Q)",function(s) S.Aim=s;if s then bindAim() else unbindAim() end end)

UIS.InputBegan:Connect(function(i,g) if g then return end
    if i.UserInputType==Enum.UserInputType.MouseButton2 or i.KeyCode==Enum.KeyCode.Q then aimHold=true end end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton2 or i.KeyCode==Enum.KeyCode.Q then aimHold=false
        if not mmr then pcall(function() if Camera.CameraType==Enum.CameraType.Scriptable then Camera.CameraType=Enum.CameraType.Custom end end) end end end)

-- ═══════════════════════════════════════════════
--  4-5. INFINITE AMMO + NO RECOIL
-- ═══════════════════════════════════════════════
local ammoKW={"ammo","clip","mag","bullet","round","cartridge","shell","reserve","currentammo","maxammo"}
local function pV(root) for _,d in ipairs(root:GetDescendants()) do if d:IsA("NumberValue") or d:IsA("IntValue") then
    local n=d.Name:lower();for _,k in ipairs(ammoKW) do if n:find(k) then d.Value=9999;break end end end end end
AddToggle("Infinite Ammo",function(s) S.InfAmmo=s;LID.Ammo=LID.Ammo+1
    if s then local id=LID.Ammo;task.spawn(function() while S.InfAmmo and LID.Ammo==id do pcall(function()
        local ch=LP.Character;if ch then for _,t in ipairs(ch:GetChildren()) do if t:IsA("Tool") or t:IsA("Model") then pV(t) end end end
        local bp=LP:FindFirstChild("Backpack");if bp then pV(bp) end;pV(LP.PlayerGui)
    end);task.wait(0.1) end end) end end)

local rcKW={"recoil","spread","kick","sway","bloom","deviation","scatter","shake","aimkick","camkick","visual_recoil"}
AddToggle("No Recoil",function(s) S.NoRecoil=s;LID.Recoil=LID.Recoil+1
    if s then local id=LID.Recoil;task.spawn(function() while S.NoRecoil and LID.Recoil==id do pcall(function()
        local function zr(r) for _,d in ipairs(r:GetDescendants()) do if d:IsA("NumberValue") or d:IsA("IntValue") then
            local n=d.Name:lower();for _,k in ipairs(rcKW) do if n:find(k) then d.Value=0;break end end end end end
        local ch=LP.Character;if ch then for _,t in ipairs(ch:GetChildren()) do if t:IsA("Tool") or t:IsA("Model") then zr(t) end end end
        local bp=LP:FindFirstChild("Backpack");if bp then zr(bp) end
    end);task.wait(0.1) end end) end end)

-- ═══════════════════════════════════════════════
--  6. GOD MODE
-- ═══════════════════════════════════════════════
local godC={}
local function clrGod() for _,c in ipairs(godC) do pcall(function() c:Disconnect() end) end;godC={} end
local function applyGod(ch) if not ch then return end;local hum=ch:FindFirstChildOfClass("Humanoid");if not hum then return end
    pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false) end)
    pcall(function() hum.MaxHealth=math.huge;hum.Health=math.huge end)
    pcall(function() if not ch:FindFirstChildOfClass("ForceField") then local ff=Instance.new("ForceField",ch);ff.Visible=false end end)
    local hc=hum.HealthChanged:Connect(function() if S.God then task.defer(function() pcall(function() hum.Health=math.huge end) end) end end)
    table.insert(godC,hc) end
local function remGod(ch) if not ch then return end
    pcall(function() local hum=ch:FindFirstChildOfClass("Humanoid")
        if hum then hum:SetStateEnabled(Enum.HumanoidStateType.Dead,true);hum.MaxHealth=100;hum.Health=100 end end)
    pcall(function() local ff=ch:FindFirstChildOfClass("ForceField");if ff then ff:Destroy() end end) end
AddToggle("God Mode",function(s) S.God=s;LID.God=(LID.God or 0)+1;clrGod()
    if s then applyGod(LP.Character)
        table.insert(godC,LP.CharacterAdded:Connect(function(ch) task.wait(0.5);if S.God then applyGod(ch) end end))
        local id=LID.God;task.spawn(function() while S.God and LID.God==id do pcall(function()
            local ch=LP.Character;if not ch then return end;local hum=ch:FindFirstChildOfClass("Humanoid");if not hum then return end
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
            if hum.Health~=math.huge then hum.Health=math.huge end
            if not ch:FindFirstChildOfClass("ForceField") then local ff=Instance.new("ForceField",ch);ff.Visible=false end
        end);task.wait(0.03) end end)
    else remGod(LP.Character) end end)

-- ═══════════════════════════════════════════════
--  7. ANTI-RAGDOLL (отдельная кнопка)
-- ═══════════════════════════════════════════════
AddToggle("Anti-Ragdoll",function(s) S.AntiRag=s
    if s then
        pcall(function() RunService:UnbindFromRenderStep("ZRP_AntiRag") end)
        RunService:BindToRenderStep("ZRP_AntiRag",Enum.RenderPriority.Character.Value+5,function()
            if not S.AntiRag then return end;forceAntiRagdoll(LP.Character)
        end)
    else pcall(function() RunService:UnbindFromRenderStep("ZRP_AntiRag") end)
        pcall(function() local ch=LP.Character;if not ch then return end;local hum=ch:FindFirstChildOfClass("Humanoid");if not hum then return end
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics,true) end)
    end end)

-- ═══════════════════════════════════════════════
--  8. SPEED
-- ═══════════════════════════════════════════════
AddSep("Movement")
AddToggle("Speed (x"..S.SpeedVal..")",function(s) S.Speed=s
    pcall(function() LP.Character:FindFirstChildOfClass("Humanoid").WalkSpeed=s and S.SpeedVal or 16 end) end)
LP.CharacterAdded:Connect(function(ch) task.wait(1);if S.Speed then pcall(function() ch:FindFirstChildOfClass("Humanoid").WalkSpeed=S.SpeedVal end) end end)

-- ═══════════════════════════════════════════════
--  9. NOCLIP
-- ═══════════════════════════════════════════════
local ncCn;local ncS={}
AddToggle("Noclip",function(s) S.Noclip=s
    if s then ncS={};pcall(function() for _,p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then ncS[p]=p.CanCollide end end end)
        if ncCn then ncCn:Disconnect() end
        ncCn=RunService.Stepped:Connect(function() if not S.Noclip then ncCn:Disconnect();ncCn=nil;return end
            pcall(function() for _,p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end) end)
    else if ncCn then ncCn:Disconnect();ncCn=nil end
        task.defer(function() for pt,og in pairs(ncS) do pcall(function() if pt and pt.Parent then pt.CanCollide=og end end) end;ncS={}
            pcall(function() local ch=LP.Character;if not ch then return end
                for _,nm in ipairs({"HumanoidRootPart","Head","Torso","UpperTorso","LowerTorso"}) do
                    local p=ch:FindFirstChild(nm);if p and p:IsA("BasePart") then p.CanCollide=true end end end) end)
    end end)

-- ═══════════════════════════════════════════════
--  10. FLY
-- ═══════════════════════════════════════════════
local flCn,flBV,flBG
local function stopFly() S.Fly=false
    if flCn then flCn:Disconnect();flCn=nil end
    if flBV then pcall(function() flBV:Destroy() end);flBV=nil end
    if flBG then pcall(function() flBG:Destroy() end);flBG=nil end
    pcall(function() LP.Character:FindFirstChildOfClass("Humanoid").PlatformStand=false end) end
local function startFly() stopFly();S.Fly=true
    local ch=LP.Character;if not ch then return end
    local hr=ch:FindFirstChild("HumanoidRootPart");local hm=ch:FindFirstChildOfClass("Humanoid")
    if not hr or not hm then return end;hm.PlatformStand=true
    flBV=Instance.new("BodyVelocity");flBV.MaxForce=Vector3.one*1e9;flBV.Velocity=Vector3.zero;flBV.Parent=hr
    flBG=Instance.new("BodyGyro");flBG.MaxTorque=Vector3.one*1e9;flBG.P=9e4;flBG.D=500;flBG.Parent=hr
    flCn=RunService.RenderStepped:Connect(function()
        if not S.Fly or not hr or not hr.Parent then stopFly();return end
        local dir=Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir=dir+Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir=dir-Camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir=dir-Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir=dir+Camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir=dir+Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir=dir-Vector3.yAxis end
        flBV.Velocity=dir.Magnitude>0 and dir.Unit*S.FlySpeed or Vector3.zero;flBG.CFrame=Camera.CFrame end)
end
AddToggle("Fly (WASD+Space+Shift)",function(s) if s then startFly() else stopFly() end end)
LP.CharacterAdded:Connect(function() if S.Fly then stopFly() end end)

-- ═══════════════════════════════════════════════
--  11. SPINNER — ТОЛЬКО НА ЗЕМЛЕ (НЕ ПРОПАДАЕТ)
-- ═══════════════════════════════════════════════
--
--  ПОЧЕМУ ПРОПАДАЛ:
--  CFrame.lookAt/CFrame.Angles заменяли ВСЮ ориентацию HRP каждый кадр.
--  Сервер видел резкие изменения → считал телепортацией → ресетил позицию.
--  В воздухе это особенно заметно потому что нет привязки к земле.
--
--  РЕШЕНИЕ:
--  Используем CFrame = CFrame * CFrame.Angles(0, delta, 0)
--  Это ДОБАВЛЯЕТ маленькую дельту вращения к ТЕКУЩЕМУ CFrame.
--  Не заменяет позицию. Не заменяет ориентацию целиком.
--  В ВОЗДУХЕ — НЕ ВРАЩАЕМ вообще.
--
-- ═══════════════════════════════════════════════
AddSep("Fun")

local spinBound=false
local origJP=50

local function bindSpin()
    if spinBound then return end;spinBound=true
    pcall(function() RunService:UnbindFromRenderStep("ZRP_Spin") end)
    pcall(function() origJP=LP.Character:FindFirstChildOfClass("Humanoid").JumpPower end)

    RunService:BindToRenderStep("ZRP_Spin",Enum.RenderPriority.Character.Value+1,function(dt)
        if not S.Spin then return end
        local ch=LP.Character;if not ch then return end
        local hrp=ch:FindFirstChild("HumanoidRootPart");if not hrp then return end
        local hum=ch:FindFirstChildOfClass("Humanoid");if not hum then return end

        -- Анти-рагдолл
        forceAntiRagdoll(ch)

        -- Лечение
        pcall(function() if hum.Health<hum.MaxHealth then hum.Health=hum.MaxHealth end end)

        -- Прыжок выше
        pcall(function() hum.JumpPower=origJP+S.SpinJump end)

        -- ═══ ВРАЩЕНИЕ ТОЛЬКО НА ЗЕМЛЕ ═══
        local onGround = hum.FloorMaterial ~= Enum.Material.Air

        if onGround then
            -- Маленькая дельта вращения — НЕ заменяем CFrame целиком
            local rotDelta = math.rad(S.SpinSpeed) * dt
            pcall(function()
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, rotDelta, 0)
            end)

            -- Автопрыжок
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end
        -- В воздухе — НИЧЕГО НЕ ДЕЛАЕМ с CFrame (не пропадает)

        -- Мягкое ограничение падения
        pcall(function()
            if hrp.Velocity.Y < -80 then
                hrp.Velocity = Vector3.new(hrp.Velocity.X, -80, hrp.Velocity.Z)
            end
        end)
    end)
end

local function unbindSpin()
    spinBound=false
    pcall(function() RunService:UnbindFromRenderStep("ZRP_Spin") end)
    pcall(function()
        local ch=LP.Character;if not ch then return end
        local hum=ch:FindFirstChildOfClass("Humanoid");if not hum then return end
        hum.JumpPower=origJP
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead,true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown,true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll,true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics,true)
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end)
end

AddToggle("Spinner + Bhop",function(s) S.Spin=s;if s then bindSpin() else unbindSpin() end end)

LP.CharacterAdded:Connect(function(ch) task.wait(1)
    if S.Spin then pcall(function() origJP=ch:FindFirstChildOfClass("Humanoid").JumpPower end)
        unbindSpin();S.Spin=true;bindSpin() end end)

-- ═══════════════════════════════════════════════
--  12. FPS BOOST
-- ═══════════════════════════════════════════════
AddSep("Performance")
AddAction("FPS BOOST",function()
    pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01
        UserSettings():GetService("UserGameSettings").SavedQualityLevel=Enum.SavedQualitySetting.QualityLevel1 end)
    pcall(function() Lighting.GlobalShadows=false;Lighting.FogEnd=9e9 end)
    for _,n in ipairs({"BloomEffect","BlurEffect","ColorCorrectionEffect","SunRaysEffect","DepthOfFieldEffect","Atmosphere"}) do
        for _,o in ipairs(Lighting:GetChildren()) do if o:IsA(n) then pcall(function() o:Destroy() end) end end
        for _,o in ipairs(Camera:GetChildren()) do if o:IsA(n) then pcall(function() o:Destroy() end) end end end
    for _,o in ipairs(workspace:GetDescendants()) do
        for _,c in ipairs({"ParticleEmitter","Fire","Smoke","Sparkles","Trail","Beam","PointLight","SpotLight","SurfaceLight"}) do
            if o:IsA(c) then pcall(function() o:Destroy() end);break end end end
    for _,o in ipairs(workspace:GetDescendants()) do
        if o:IsA("Decal") or o:IsA("Texture") then pcall(function() o.Transparency=1 end) end
        if o:IsA("MeshPart") then pcall(function() o.RenderFidelity=Enum.RenderFidelity.Performance end) end
        if o:IsA("BasePart") then pcall(function() o.CastShadow=false end) end end
    pcall(function() local t=workspace.Terrain;t.WaterWaveSize=0;t.WaterWaveSpeed=0;t.WaterReflectance=0;t.WaterTransparency=0;t.Decoration=false end)
    pcall(function() if sethiddenproperty then sethiddenproperty(Lighting,"Technology",Enum.Technology.Compatibility) end end)
    pcall(function() collectgarbage("collect") end)
end)

-- ═══════════════════════════════════════════════
--  13. REJOIN SAME SERVER
-- ═══════════════════════════════════════════════
AddSep("Server")

AddAction("Rejoin Same Server",function()
    pcall(function()
        StarterGui:SetCore("SendNotification",{
            Title="🔄 Rejoining...",
            Text="Reconnecting to same server...",
            Duration=3
        })
    end)

    local placeId = game.PlaceId
    local jobId = game.JobId

    -- Метод 1: TeleportToPlaceInstance (тот же сервер)
    local ok = pcall(function()
        TeleportService:TeleportToPlaceInstance(placeId, jobId, LP)
    end)

    -- Метод 2: Если первый не сработал — через queue
    if not ok then
        pcall(function()
            LP:Kick("\n\n🔄 Rejoin: roblox.com/games/"..placeId.."?gameInstanceId="..jobId.."\n\nCopy link above and paste in browser")
        end)
    end
end)

-- ═══════════════════════════════════════════════
--  HOTKEY H
-- ═══════════════════════════════════════════════
UIS.InputBegan:Connect(function(i,g) if g then return end;if i.KeyCode==Enum.KeyCode.H then MF.Visible=not MF.Visible end end)

-- ═══════════════════════════════════════════════
--  LOADED
-- ═══════════════════════════════════════════════
pcall(function() StarterGui:SetCore("SendNotification",{
    Title="🍆 Zalupa RP v11",
    Text="Safe Spinner + Rejoin!\nAim: "..aimMethod.."\nH=menu",Duration=7}) end)
warn("[Zalupa RP v11] Loaded")
