--[[
╔══════════════════════════════════════════════════════════════════════════╗
║         GHOST HUB TITAN — DEFINITIVE EDITION (v33.0)                    ║
║         SCRIPT 2 / 3  —  SYSTEMS                                        ║
║         Run AFTER S1. Reads _G.GH_* from S1, populates more for S3.     ║
╚══════════════════════════════════════════════════════════════════════════╝
]]

-- ── Pull everything from _G ───────────────────────────────────────────
local Svc      = _G.GH_Svc
local UIS      = _G.GH_UIS
local Run      = _G.GH_Run
local Players  = _G.GH_Players
local Tween    = _G.GH_Tween
local Lighting = _G.GH_Lighting
local Debris   = _G.GH_Debris
local HttpSvc  = _G.GH_HttpSvc
local LP       = _G.GH_LP
local Camera   = _G.GH_Camera

local Cfg              = _G.GH_Cfg
local State            = _G.GH_State
local Anims            = _G.GH_Anims
local FX               = _G.GH_FX
local ScreenGui        = _G.GH_ScreenGui
local BloodBurst       = _G.GH_BloodBurst
local SpawnBloodPool   = _G.GH_SpawnBloodPool

local RageFill         = _G.GH_RageFill
local RageLabel        = _G.GH_RageLabel
local DeathOverlay     = _G.GH_DeathOverlay
local DeathLabel       = _G.GH_DeathLabel
local DeathSub         = _G.GH_DeathSub
local GhostHint        = _G.GH_GhostHint
local UnconsOverlay    = _G.GH_UnconsOverlay
local BloodVignette    = _G.GH_BloodVignette
local InjuryHUD        = _G.GH_InjuryHUD
local InjuryIndicators = _G.GH_InjuryIndicators

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [X] INJURY SYSTEM
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local Injuries = {
	LeftLeg=false, RightLeg=false, LeftArm=false, RightArm=false,
	Bleeding=false, BleedRate=0.8,
	InternalBleed=false, InternalRate=1.5,
	Concussion=false, Burns=false, Fracture=false, Shrapnel=false,
	Unconscious=false,
}
_G.GH_Injuries = Injuries

local function UpdateInjuryHUD()
	local labels={
		LeftLeg="Left Leg",RightLeg="Right Leg",LeftArm="Left Arm",RightArm="Right Arm",
		Bleeding="Bleeding",InternalBleed="Internal Bleed",Concussion="Concussion",
		Burns="Burns",Fracture="Fracture",Shrapnel="Shrapnel",Unconscious="Unconscious",
	}
	local any=false
	for key,row in pairs(InjuryIndicators) do
		local active=Injuries[key] or (key=="Unconscious" and State.IsUnconscious)
		row.Text=(active and "●  " or "○  ")..labels[key]
		row.TextColor3=active and Color3.fromRGB(220,60,60) or Color3.fromRGB(70,70,70)
		if active then any=true end
	end
	InjuryHUD.Visible=any
end
_G.GH_UpdateInjuryHUD = UpdateInjuryHUD

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XI] CORE LOGIC FUNCTIONS
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function GetScale()
	local char=LP.Character; if not char then return 1 end
	local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return 1 end
	local bhs=char:FindFirstChild("BodyHeightScale")
	if bhs and bhs:IsA("NumberValue") then return math.clamp(bhs.Value,0.1,10) end
	return math.clamp(hum.HipHeight/2,0.1,10)
end

local function GetAnimator()
	local char=LP.Character
	local hum=char and char:FindFirstChildOfClass("Humanoid"); if not hum then return nil end
	local a=hum:FindFirstChildOfClass("Animator")
	if not a then a=Instance.new("Animator"); a.Parent=hum end
	return a
end

_G.GH_GetScale    = GetScale
_G.GH_GetAnimator = GetAnimator

-- Ragdoll joint map
local RagdollJointMap = {
	["Root"]={type="Rigid"},
	["Waist"]={type="BallSocket",upper=15,twistUpper=1,twistLower=-1},
	["Neck"]={type="BallSocket",upper=0,twistUpper=40,twistLower=-40,friction=78480},
	["LeftShoulder"]={type="BallSocket",upper=30,twistUpper=30,twistLower=-30},
	["RightShoulder"]={type="BallSocket",upper=30,twistUpper=30,twistLower=-30},
	["LeftElbow"]={type="Hinge",lower=0,upper=135},
	["RightElbow"]={type="Hinge",lower=0,upper=135},
	["LeftWrist"]={type="Hinge",lower=-20,upper=20},
	["RightWrist"]={type="Hinge",lower=-20,upper=20},
	["LeftHip"]={type="BallSocket",upper=40,twistUpper=3,twistLower=-3},
	["RightHip"]={type="BallSocket",upper=40,twistUpper=3,twistLower=-3},
	["LeftKnee"]={type="Hinge",lower=-135,upper=-10},
	["RightKnee"]={type="Hinge",lower=-135,upper=-10},
	["LeftAnkle"]={type="Hinge",lower=0,upper=0},
	["RightAnkle"]={type="Hinge",lower=0,upper=0},
	["Left Shoulder"]={type="BallSocket",upper=90,twistUpper=40,twistLower=-40},
	["Right Shoulder"]={type="BallSocket",upper=90,twistUpper=40,twistLower=-40},
	["Left Hip"]={type="BallSocket",upper=90,twistUpper=40,twistLower=-40},
	["Right Hip"]={type="BallSocket",upper=90,twistUpper=40,twistLower=-40},
}

local function MakeRagdollConstraint(motor, jointInfo)
	local p0,p1=motor.Part0,motor.Part1; if not p0 or not p1 then return end
	local a0=Instance.new("Attachment",p0); a0.Name="GH_RagA0"; a0.CFrame=motor.C0
	local a1=Instance.new("Attachment",p1); a1.Name="GH_RagA1"; a1.CFrame=motor.C1
	if jointInfo.type=="Rigid" then
		local rc=Instance.new("RigidConstraint",p1); rc.Name="GH_RagConstraint"
		rc.Attachment0=a0; rc.Attachment1=a1
	elseif jointInfo.type=="BallSocket" then
		local bsc=Instance.new("BallSocketConstraint",p1); bsc.Name="GH_RagConstraint"
		bsc.Attachment0=a0; bsc.Attachment1=a1; bsc.LimitsEnabled=true
		bsc.UpperAngle=jointInfo.upper or 20; bsc.TwistLimitsEnabled=true
		bsc.TwistUpperAngle=jointInfo.twistUpper or 15; bsc.TwistLowerAngle=jointInfo.twistLower or -15
		bsc.Restitution=0
		if jointInfo.friction then bsc.MaxFrictionTorque=jointInfo.friction end
	elseif jointInfo.type=="Hinge" then
		local hc=Instance.new("HingeConstraint",p1); hc.Name="GH_RagConstraint"
		hc.Attachment0=a0; hc.Attachment1=a1; hc.LimitsEnabled=true
		hc.LowerAngle=jointInfo.lower or -90; hc.UpperAngle=jointInfo.upper or 90; hc.Restitution=0
	end
end

-- Forward-declare SetRagdoll (needed by Knockout before ApplyAnims is defined)
local SetRagdoll
local ApplyAnims

-- Knockout / WakeUp
local function Knockout(duration)
	if State.IsUnconscious or State.IsDead then return end
	if not Cfg.UnconsciousnessEnabled then return end
	State.IsUnconscious=true; State.UnconsTimer=duration or Cfg.KnockoutDuration
	UpdateInjuryHUD()
	local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		local a=Instance.new("Animation"); a.AnimationId="rbxassetid://"..Anims.Knockout
		local t=GetAnimator():LoadAnimation(a); t.Priority=Enum.AnimationPriority.Action
		t.Looped=false; t:Play(0.15)
	end
	UnconsOverlay.Visible=true
	Tween:Create(UnconsOverlay,TweenInfo.new(0.5),{BackgroundTransparency=0.15}):Play()
	task.defer(function() if SetRagdoll then SetRagdoll(true) end end)
end

local function WakeUp()
	if not State.IsUnconscious then return end
	State.IsUnconscious=false; State.UnconsTimer=0
	UpdateInjuryHUD()
	Tween:Create(UnconsOverlay,TweenInfo.new(1),{BackgroundTransparency=1}):Play()
	task.delay(1,function() UnconsOverlay.Visible=false end)
	task.defer(function() if SetRagdoll then SetRagdoll(false) end end)
end

_G.GH_Knockout = Knockout
_G.GH_WakeUp   = WakeUp

local function ApplyInjury(injuryType, bloodCount)
	local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
	if char then
		local limbMap={
			LeftLeg="Left Leg",RightLeg="Right Leg",LeftArm="Left Arm",RightArm="Right Arm",
			InternalBleed="Torso",Bleeding="HumanoidRootPart",
			Burns="Torso",Shrapnel="Torso",Fracture="Torso",
		}
		local limbName=limbMap[injuryType]
		if limbName then
			local part=char:FindFirstChild(limbName) or char:FindFirstChild("UpperTorso")
			if part then BloodBurst(part, bloodCount or 50) end
		end
	end
	if Injuries[injuryType] then return end
	Injuries[injuryType]=true
	UpdateInjuryHUD()
	if injuryType=="LeftLeg" or injuryType=="RightLeg" then
		Cfg.SprintSpeed=math.min(Cfg.SprintSpeed,14); Cfg.NormalSpeed=math.min(Cfg.NormalSpeed,10)
		State.LimpBias=(injuryType=="RightLeg") and 3 or -3
	end
	if injuryType=="Fracture" then
		Cfg.SprintSpeed=math.min(Cfg.SprintSpeed,12); Cfg.NormalSpeed=math.min(Cfg.NormalSpeed,8)
	end
	if injuryType=="Shrapnel" then
		Injuries.Bleeding=true; Injuries.BleedRate=math.max(Injuries.BleedRate,1.2)
	end
	if injuryType=="Burns" then
		task.spawn(function()
			while Injuries.Burns and not State.IsDead do
				task.wait(2)
				local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
				if h then h:TakeDamage(1*Cfg.DurabilityMult) end
				Tween:Create(FX.CC,TweenInfo.new(0.2),{TintColor=Color3.fromRGB(255,180,50)}):Play()
				task.wait(0.2)
				if not State.IsRaging then
					Tween:Create(FX.CC,TweenInfo.new(0.4),{TintColor=Color3.new(1,1,1)}):Play()
				end
			end
		end)
	end
	if injuryType=="Bleeding" then
		task.spawn(function()
			while Injuries.Bleeding and not State.IsDead do
				Tween:Create(BloodVignette,TweenInfo.new(0.4,Enum.EasingStyle.Sine),{ImageTransparency=0.3}):Play()
				if char then
					local root=char:FindFirstChild("HumanoidRootPart")
					if root then SpawnBloodPool(root.Position,math.random(50,70)*0.1) end
				end
				task.wait(0.5)
				Tween:Create(BloodVignette,TweenInfo.new(0.6,Enum.EasingStyle.Sine),{ImageTransparency=0.75}):Play()
				task.wait(0.7)
			end
			BloodVignette.ImageTransparency=1
		end)
	end
	if injuryType=="InternalBleed" then
		task.spawn(function()
			while Injuries.InternalBleed and not State.IsDead do
				task.wait(10)
				Injuries.InternalRate=math.min(Injuries.InternalRate+0.3,5)
				local c=LP.Character; local h=c and c:FindFirstChildOfClass("Humanoid")
				if h and h.Health/h.MaxHealth<0.35 then Knockout(Cfg.KnockoutDuration) end
			end
		end)
	end
	if injuryType=="Concussion" then
		task.spawn(function()
			local blackout=Instance.new("Frame",ScreenGui)
			blackout.Size=UDim2.new(1,0,1,0); blackout.BackgroundColor3=Color3.new(0,0,0)
			blackout.BackgroundTransparency=1; blackout.ZIndex=500
			Tween:Create(blackout,TweenInfo.new(0.15),{BackgroundTransparency=0}):Play()
			task.wait(0.3); Tween:Create(blackout,TweenInfo.new(0.8),{BackgroundTransparency=1}):Play()
			task.wait(0.8); blackout:Destroy()
		end)
		task.delay(1,function() if Injuries.Concussion then Knockout(Cfg.KnockoutDuration*0.5) end end)
	end
end

local function ClearInjuries()
	for k in pairs(Injuries) do if type(Injuries[k])=="boolean" then Injuries[k]=false end end
	Injuries.BleedRate=0.8; Injuries.InternalRate=1.5
	State.LimpBias=0; BloodVignette.ImageTransparency=1
	local char=LP.Character
	if char then
		for _,m in ipairs(char:GetDescendants()) do if m:IsA("Motor6D") then m.Enabled=true end end
		for _,p in ipairs(char:GetChildren()) do
			if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.CanCollide=false end
		end
	end
	Cfg.NormalSpeed=16; Cfg.SprintSpeed=26; UpdateInjuryHUD()
end

_G.GH_ApplyInjury   = ApplyInjury
_G.GH_ClearInjuries = ClearInjuries

-- Bleed tick
task.spawn(function()
	while true do
		task.wait(1)
		if not State.IsDead then
			local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
			if hum then
				if Injuries.Bleeding then hum:TakeDamage(Injuries.BleedRate*Cfg.DurabilityMult) end
				if Injuries.InternalBleed then
					hum:TakeDamage(Injuries.InternalRate*Cfg.DurabilityMult)
					for _=1,3 do
						State.StepShakeX=math.random(-10,10)*0.01; State.StepShakeY=math.random(-10,10)*0.01
						task.wait(0.05)
					end
				end
			end
		end
	end
end)

-- Unconsciousness timer
task.spawn(function()
	while true do
		Run.Heartbeat:Wait()
		if State.IsUnconscious and not State.IsDead then
			State.UnconsTimer=State.UnconsTimer-(1/60)
			if State.UnconsTimer<=0 then WakeUp() end
		end
	end
end)
UpdateInjuryHUD()

-- Animation injection
ApplyAnims = function()
	local char=LP.Character; local animate=char and char:FindFirstChild("Animate")
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	if not animate or not hum then return end
	local src=(Cfg.Source=="Main") and 1 or 2; local var=Cfg.Variant
	local idleId,walkId,runId
	if State.IsRaging then
		idleId=Anims.Idle.Rage[1]; walkId=Anims.Walk.Rage[1]; runId=Anims.Run.Rage[1]
	elseif State.IsNervous then
		idleId=Anims.Idle.Nervous[src] or Anims.Idle.Nervous[1]
		walkId=Anims.Walk.Nervous[src] or Anims.Walk.Nervous[1]
		runId=(Anims.Run[var] or Anims.Run.V1)[src]
	else
		idleId=(Anims.Idle[var] or Anims.Idle.V1)[src]
		local c2=LP.Character; local h2=c2 and c2:FindFirstChildOfClass("Humanoid")
		local hp2=h2 and (h2.Health/h2.MaxHealth) or 1
		if hp2<0.65 then walkId=Anims.Walk.Hurt[1]; runId=Anims.Walk.Hurt[1]
		else walkId=(Anims.Walk[var] or Anims.Walk.V1)[src]; runId=(Anims.Run[var] or Anims.Run.V1)[src]
		end
	end
	pcall(function()
		animate.idle.Animation1.AnimationId="rbxassetid://"..idleId
		animate.walk.WalkAnim.AnimationId="rbxassetid://"..walkId
		animate.run.RunAnim.AnimationId="rbxassetid://"..runId
	end)
	for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop(0) end
	animate.Disabled=true; task.wait(0.05); animate.Disabled=false
end
_G.GH_ApplyAnims = ApplyAnims

local function UpdateHurtAnim(hp, isMoving)
	local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
	if isMoving then
		if State.HurtIdleTrack then State.HurtIdleTrack:Stop(0.4); State.HurtIdleTrack=nil; State.LastHurtTier=-1 end
		return
	end
	local tier=0
	if hp<0.3 then tier=2 elseif hp<0.65 then tier=1 end
	if tier==State.LastHurtTier then return end
	State.LastHurtTier=tier
	if State.HurtIdleTrack then State.HurtIdleTrack:Stop(0.5); State.HurtIdleTrack=nil end
	if tier==0 then return end
	local id=(tier==2) and Anims.Idle.Hurt2 or Anims.Idle.Hurt1
	local a=Instance.new("Animation"); a.AnimationId="rbxassetid://"..id
	local track=GetAnimator():LoadAnimation(a)
	track.Priority=Enum.AnimationPriority.Action2; track.Looped=true; track:Play(1.5)
	State.HurtIdleTrack=track
end

local function PlayKeybindAnim(id, key)
	local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
	if not hum or State.IsRagdolled or State.IsUnconscious then return end
	if State.ActiveKey==key and State.ActiveTrack then
		State.ActiveTrack:Stop(0.2); State.ActiveTrack=nil; State.ActiveKey=nil; return
	end
	if State.ActiveTrack then State.ActiveTrack:Stop(0.15) end
	local animator=GetAnimator(); if not animator then return end
	local anim=Instance.new("Animation"); anim.AnimationId="rbxassetid://"..id
	local track=animator:LoadAnimation(anim)
	track.Priority=Enum.AnimationPriority.Action; track:Play(0.15)
	State.ActiveTrack=track; State.ActiveKey=key
	track.Stopped:Connect(function() if State.ActiveKey==key then State.ActiveTrack=nil; State.ActiveKey=nil end end)
	return track
end
_G.GH_PlayKeybindAnim = PlayKeybindAnim

-- Ragdoll
SetRagdoll = function(enabled)
	local char=LP.Character; if not char then return end
	local hum=char:FindFirstChildOfClass("Humanoid"); if not hum then return end
	local root=char:FindFirstChild("HumanoidRootPart"); if not root then return end
	State.IsRagdolled=enabled; hum.PlatformStand=enabled; hum.AutoRotate=not enabled
	local animate=char:FindFirstChild("Animate")
	if enabled then
		if animate then animate.Disabled=true end
		for _,motor in ipairs(char:GetDescendants()) do
			if motor:IsA("Motor6D") then
				motor.Enabled=false
				local jointInfo=RagdollJointMap[motor.Name] or {type="BallSocket",upper=20,twistUpper=15,twistLower=-15}
				MakeRagdollConstraint(motor,jointInfo)
				local p1=motor.Part1
				if p1 and p1.Name~="HumanoidRootPart" then p1.CanCollide=Cfg.RagdollLimbsCollidable end
			end
		end
		root.AssemblyLinearVelocity=root.AssemblyLinearVelocity+Vector3.new(0,-4,0)
	else
		for _,v in ipairs(char:GetDescendants()) do
			if v.Name=="GH_RagConstraint" or v.Name=="GH_RagA0" or v.Name=="GH_RagA1" then v:Destroy() end
		end
		for _,motor in ipairs(char:GetDescendants()) do if motor:IsA("Motor6D") then motor.Enabled=true end end
		for _,part in ipairs(char:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide=(part.Name=="HumanoidRootPart") end
		end
		if animate then animate.Disabled=false end
		hum.AutoRotate=true; task.delay(0.1,ApplyAnims)
	end
end
_G.GH_SetRagdoll = SetRagdoll

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XII] GHOST MODE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local ghostCamConn, ghostClickConn

local function StopGhostCam()
	if ghostCamConn then ghostCamConn:Disconnect(); ghostCamConn=nil end
	if ghostClickConn then ghostClickConn:Disconnect(); ghostClickConn=nil end
	Camera.CameraType=Enum.CameraType.Custom; State.GhostSpectateTarget=nil
end

local function StartGhostMode()
	State.IsGhost=true
	local char=LP.Character
	if char then
		for _,p in ipairs(char:GetDescendants()) do
			if p:IsA("BasePart") then p.Transparency=1; p.CanCollide=false end
		end
		local hum=char:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed=0; hum.JumpPower=0; hum.PlatformStand=true end
		local root=char:FindFirstChild("HumanoidRootPart")
		if root then root.CFrame=CFrame.new(1e6,1e6,1e6) end
	end
	Camera.CameraType=Enum.CameraType.Scriptable
	local camCF=Camera.CFrame; local camSpeed=28; local camSens=0.003
	local rotX,rotY=0,0; local _,ry,_=camCF:ToEulerAnglesYXZ(); rotY=ry
	Tween:Create(FX.CC,TweenInfo.new(1.5),{TintColor=Color3.fromRGB(180,220,255),Saturation=-0.4,Contrast=0.15,Brightness=0.05}):Play()
	Tween:Create(FX.Blur,TweenInfo.new(1),{Size=4}):Play()
	ghostClickConn=UIS.InputBegan:Connect(function(inp,gpe)
		if gpe then return end
		if inp.UserInputType~=Enum.UserInputType.MouseButton1 then return end
		local mouse=LP:GetMouse(); local target=mouse.Target
		if not target then State.GhostSpectateTarget=nil; return end
		for _,plr in ipairs(Players:GetPlayers()) do
			if plr~=LP and plr.Character and target:IsDescendantOf(plr.Character) then
				if State.GhostSpectateTarget==plr then
					State.GhostSpectateTarget=nil; GhostHint.Text="Click a player to spectate · Click again to stop"
				else
					State.GhostSpectateTarget=plr; GhostHint.Text="Spectating: "..plr.Name.."  (click again to stop)"
				end
				return
			end
		end
		State.GhostSpectateTarget=nil
	end)
	ghostCamConn=Run.RenderStepped:Connect(function(dt)
		if not State.IsGhost then StopGhostCam(); return end
		if State.GhostSpectateTarget then
			local tChar=State.GhostSpectateTarget.Character
			local tRoot=tChar and tChar:FindFirstChild("HumanoidRootPart")
			if tRoot then Camera.CFrame=CFrame.new(tRoot.Position+Vector3.new(0,2,6),tRoot.Position) end
			return
		end
		local mouseDelta=UIS:GetMouseDelta()
		rotY=rotY-mouseDelta.X*camSens
		rotX=math.clamp(rotX-mouseDelta.Y*camSens,-math.pi/2.2,math.pi/2.2)
		local rot=CFrame.Angles(0,rotY,0)*CFrame.Angles(rotX,0,0)
		local forward=rot.LookVector; local right=rot.RightVector; local up=Vector3.new(0,1,0)
		local move=Vector3.new(0,0,0)
		if UIS:IsKeyDown(Enum.KeyCode.W) then move=move+forward end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move=move-forward end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move=move-right end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move=move+right end
		if UIS:IsKeyDown(Enum.KeyCode.E) then move=move+up end
		if UIS:IsKeyDown(Enum.KeyCode.Q) then move=move-up end
		local spd=UIS:IsKeyDown(Enum.KeyCode.LeftShift) and camSpeed*2.5 or camSpeed
		local pos=Camera.CFrame.Position+move*spd*dt
		Camera.CFrame=CFrame.new(pos)*rot
	end)
	UIS.MouseBehavior=Enum.MouseBehavior.LockCurrentPosition
end

_G.GH_StopGhostCam  = StopGhostCam
_G.GH_StartGhostMode = StartGhostMode

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XIII] RAGE / NERVOUS / SONAR / PING
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function SetRage(active)
	State.IsRaging=active
	if active then
		State.MovementLocked=true; FX.Heartbeat:Play(); FX.Heartbeat.PlaybackSpeed=0.8
		local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
		local triggerTrack
		if hum then
			for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop(0) end
			local a=Instance.new("Animation"); a.AnimationId="rbxassetid://"..Anims.RageTrigger
			triggerTrack=GetAnimator():LoadAnimation(a); triggerTrack.Looped=false; triggerTrack:Play(0.1)
		end
		Tween:Create(FX.Heartbeat,TweenInfo.new(3),{Volume=1.4,PlaybackSpeed=1.4}):Play()
		Tween:Create(FX.CC,TweenInfo.new(3),{TintColor=Color3.fromRGB(255,40,40),Contrast=0.4,Brightness=-0.2}):Play()
		Tween:Create(Camera,TweenInfo.new(3),{FieldOfView=Cfg.RageFOV}):Play()
		local unlocked=false
		local function unlock()
			if unlocked then return end; unlocked=true; State.MovementLocked=false; ApplyAnims()
		end
		if triggerTrack then triggerTrack.Stopped:Connect(unlock); task.delay(6,unlock) else unlock() end
	else
		State.MovementLocked=false
		Tween:Create(FX.Heartbeat,TweenInfo.new(2),{Volume=0,PlaybackSpeed=1}):Play()
		Tween:Create(FX.CC,TweenInfo.new(2),{TintColor=Color3.new(1,1,1),Contrast=0,Brightness=0,Saturation=0}):Play()
		Tween:Create(Camera,TweenInfo.new(2),{FieldOfView=Cfg.FOV}):Play()
		task.delay(2,function() if not State.IsRaging then FX.Heartbeat:Stop() end end)
		ApplyAnims()
	end
end

local function AddRage(amount)
	State.RageValue=math.clamp(State.RageValue+amount,0,100)
	RageLabel.Text="RAGE  "..math.floor(State.RageValue).."%"
	Tween:Create(RageFill,TweenInfo.new(0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
		{Size=UDim2.new(State.RageValue/100,0,1,0)}):Play()
	if State.RageValue>=100 and not State.IsRaging then SetRage(true) end
end

local function DoSonarPing(power)
	local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then return end
	local radius=Cfg.SonarMaxRadius*power
	local ring=Instance.new("Part",workspace)
	ring.Shape=Enum.PartType.Ball; ring.Material=Enum.Material.ForceField
	ring.Color=Color3.fromRGB(0,255,220); ring.Transparency=0.4
	ring.Anchored=true; ring.CanCollide=false; ring.CastShadow=false
	ring.Position=root.Position; ring.Size=Vector3.new(1,1,1)
	Tween:Create(ring,TweenInfo.new(1,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
		{Size=Vector3.new(radius,radius,radius),Transparency=1}):Play()
	Debris:AddItem(ring,1.1)
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr~=LP and plr.Character then
			local r=plr.Character:FindFirstChild("HumanoidRootPart")
			if r and (r.Position-root.Position).Magnitude<=radius/2 then
				local hl=Instance.new("Highlight",plr.Character)
				hl.FillColor=Color3.fromRGB(0,255,220); hl.OutlineColor=Color3.new(1,1,1)
				Debris:AddItem(hl,3)
			end
		end
	end
end

local function DoPingEffect(position, radius)
	position=position or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and LP.Character.HumanoidRootPart.Position)
	radius=radius or Cfg.PingRadius
	if not position then return end
	if Cfg.PingShowMarker then
		local ring=Instance.new("Part",workspace)
		ring.Shape=Enum.PartType.Ball; ring.Material=Enum.Material.ForceField
		ring.Color=Color3.fromRGB(0,200,255); ring.Transparency=0.6
		ring.Anchored=true; ring.CanCollide=false; ring.CastShadow=false
		ring.Position=position; ring.Size=Vector3.new(1,1,1)
		Tween:Create(ring,TweenInfo.new(0.8,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),
			{Size=Vector3.new(radius*2,radius*2,radius*2),Transparency=1}):Play()
		Debris:AddItem(ring,1)
	end
	if Cfg.PingScreenShake and Cfg.PingScreenShake>0 then
		task.spawn(function()
			for _=1,6 do
				State.StepShakeX=(math.random()-0.5)*Cfg.PingScreenShake*0.02
				State.StepShakeY=(math.random()-0.5)*Cfg.PingScreenShake*0.02
				Run.RenderStepped:Wait()
			end
			State.StepShakeX=0; State.StepShakeY=0
		end)
	end
end

_G.GH_SetRage     = SetRage
_G.GH_AddRage     = AddRage
_G.GH_DoSonarPing = DoSonarPing
_G.GH_DoPingEffect= DoPingEffect

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XIV] DEATH
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function HandleDeath()
	if State.IsDead then return end
	State.IsDead=true
	local flash=Instance.new("Frame",ScreenGui)
	flash.Size=UDim2.new(1,0,1,0); flash.BackgroundColor3=Color3.new(1,1,1); flash.ZIndex=800
	task.wait(0.06); flash:Destroy()
	if Cfg.PermadeathEnabled then
		if Cfg.GhostOnDeath then
			DeathLabel.Text="YOU HAVE DIED"; DeathSub.Text="Ghost mode active — REBOOT to respawn"
			GhostHint.Visible=true; DeathOverlay.Visible=true
			Tween:Create(DeathOverlay,TweenInfo.new(1),{BackgroundTransparency=0.5}):Play()
			task.defer(StartGhostMode)
		else
			DeathLabel.Text="YOU HAVE DIED"; DeathSub.Text="Leaving in 3 seconds..."
			GhostHint.Visible=false; DeathOverlay.Visible=true
			Tween:Create(DeathOverlay,TweenInfo.new(1),{BackgroundTransparency=0}):Play()
			task.delay(3,function() game:GetService("TeleportService"):Teleport(game.PlaceId) end)
		end
	else
		DeathLabel.Text="SYSTEM FAILURE"; DeathSub.Text=""; GhostHint.Visible=false
		DeathOverlay.Visible=true
		Tween:Create(DeathOverlay,TweenInfo.new(1),{BackgroundTransparency=0}):Play()
	end
end
_G.GH_HandleDeath = HandleDeath

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XV] EXPLOSION PHYSICS + VELOCITY DAMAGE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
task.spawn(function()
	while true do
		Run.Heartbeat:Wait()
		local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
		if root then State.LastVelocityY=root.Velocity.Y end
	end
end)

local function MakeExplosion(position, blastRadius, blastForce)
	local exp=Instance.new("Explosion",workspace)
	exp.Position=position; exp.BlastRadius=blastRadius or 20
	exp.BlastPressure=Cfg.ExplosionForce and (blastForce or 500000) or 0
	exp.ExplosionType=Enum.ExplosionType.CratersAndDebris; exp.DestroyJointRadiusPercent=0
	if Cfg.ExplosionForce then
		local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
		local hum=char and char:FindFirstChildOfClass("Humanoid")
		if root and hum then
			local dist=(root.Position-position).Magnitude
			if dist<blastRadius then
				local falloff=1-(dist/blastRadius)
				hum:TakeDamage(falloff*80*Cfg.DurabilityMult)
				local dir=(root.Position-position+Vector3.new(0,3,0)).Unit
				root.Velocity=root.Velocity+dir*falloff*120
				if falloff>0.6 then ApplyInjury("Burns",60); ApplyInjury("Shrapnel",30) end
				BloodBurst(root,math.floor(falloff*80))
				if Cfg.RagdollOnExplosion and falloff>0.3 then
					SetRagdoll(true)
					task.delay(2.5,function() if not State.IsDead then SetRagdoll(false) end end)
				end
			end
		end
	end
end
_G.GH_MakeExplosion = MakeExplosion

local function SetupPenetrationDetection()
	if State.PenetrationConn then State.PenetrationConn:Disconnect() end
	local char=LP.Character; if not char then return end
	local torso=char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"); if not torso then return end
	State.PenetrationConn=torso.Touched:Connect(function(hit)
		if State.IsDead or not hit or not hit.Parent then return end
		if hit:IsDescendantOf(char) then return end
		local vel=hit.Velocity.Magnitude; if vel<60 then return end
		local hum=char:FindFirstChildOfClass("Humanoid"); if not hum or hum.Health<=0 then return end
		local dmg=math.clamp(vel*0.8,30,hum.MaxHealth*0.6)
		hum:TakeDamage(dmg*Cfg.DurabilityMult)
		BloodBurst(torso,120); SpawnBloodPool(torso.Position,math.random(50,70)*0.1)
		ApplyInjury("InternalBleed",0); ApplyInjury("Bleeding",0)
		local a=Instance.new("Animation"); a.AnimationId="rbxassetid://"..Anims.Impalement
		local track=GetAnimator():LoadAnimation(a)
		track.Priority=Enum.AnimationPriority.Action4; track.Looped=false; track:Play(0.05)
		local root=char:FindFirstChild("HumanoidRootPart")
		if root then
			local dir=(root.Position-hit.Position).Unit
			root.Velocity=root.Velocity+dir*math.min(vel,80)
		end
		SetRagdoll(true)
		task.delay(2.5,function() if not State.IsDead then SetRagdoll(false) end end)
		State.PenetrationConn:Disconnect()
		task.delay(3,SetupPenetrationDetection)
	end)
end
_G.GH_SetupPenetrationDetection = SetupPenetrationDetection

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XVI] PROXIMITY HIGHLIGHT + DIRECTIONAL MARKER
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local ProximityHighlights  = {}
local ProximityBillboards  = {}
local ProximityOffScreenFrames = {}

local function ClearProximityFX()
	for _,hl in pairs(ProximityHighlights) do pcall(function() hl:Destroy() end) end
	for _,bb in pairs(ProximityBillboards) do pcall(function() bb:Destroy() end) end
	for _,f  in pairs(ProximityOffScreenFrames) do pcall(function() f:Destroy() end) end
	ProximityHighlights={}; ProximityBillboards={}; ProximityOffScreenFrames={}
end

local function UpdateProximity()
	if not Cfg.ProximityEnabled then ClearProximityFX(); return end
	local myChar=LP.Character; local myRoot=myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myRoot then return end
	local seen={}
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr~=LP and plr.Character then
			local r=plr.Character:FindFirstChild("HumanoidRootPart")
			if r then
				local dist=(r.Position-myRoot.Position).Magnitude; seen[plr]=true
				if dist<=Cfg.ProximityRange then
					if Cfg.ProximityHighlight and not ProximityHighlights[plr] then
						local hl=Instance.new("Highlight",plr.Character)
						hl.FillColor=Color3.fromRGB(255,120,0); hl.OutlineColor=Color3.fromRGB(255,200,0)
						hl.FillTransparency=0.5; ProximityHighlights[plr]=hl
					end
				else
					if ProximityHighlights[plr] then ProximityHighlights[plr]:Destroy(); ProximityHighlights[plr]=nil end
				end
				if Cfg.ProximityMarker and dist<=Cfg.ProximityMarkerRange then
					if not ProximityBillboards[plr] then
						local head=plr.Character:FindFirstChild("Head") or r
						local bbg=Instance.new("BillboardGui",head)
						bbg.Name="GH_ProxBB"; bbg.Size=UDim2.new(0,70,0,22)
						bbg.StudsOffset=Vector3.new(0,2.5,0); bbg.AlwaysOnTop=false
						bbg.MaxDistance=Cfg.ProximityMarkerRange
						local lbl=Instance.new("TextLabel",bbg)
						lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
						lbl.Text="⬥ "..plr.Name; lbl.TextColor3=Color3.fromRGB(255,200,80)
						lbl.Font=Enum.Font.GothamBold; lbl.TextSize=11; lbl.TextStrokeTransparency=0.4
						ProximityBillboards[plr]=bbg
					else
						local lbl=ProximityBillboards[plr]:FindFirstChildOfClass("TextLabel")
						local d=math.floor((r.Position-myRoot.Position).Magnitude)
						if lbl then lbl.Text="⬥ "..plr.Name.."  ("..d..")" end
					end
				elseif ProximityBillboards[plr] and dist>Cfg.ProximityMarkerRange then
					ProximityBillboards[plr]:Destroy(); ProximityBillboards[plr]=nil
				end
				if Cfg.ProximityOffScreenMarker and Cfg.ProximityMarker and dist<=Cfg.ProximityMarkerRange then
					local headPos=(plr.Character:FindFirstChild("Head") or r).Position
					local screenPos,onScreen=Camera:WorldToScreenPoint(headPos)
					local vp=Camera.ViewportSize; local margin=24
					local cx,cy=vp.X/2,vp.Y/2; local dx=screenPos.X-cx; local dy=screenPos.Y-cy
					if not onScreen or screenPos.X<-margin or screenPos.X>vp.X+margin or screenPos.Y<-margin or screenPos.Y>vp.Y+margin then
						local len=math.sqrt(dx*dx+dy*dy)
						if len>1 then
							local t=math.huge
							if math.abs(dx)>0.001 then t=math.min(t,(dx>0 and (vp.X-margin-cx) or (margin-cx))/dx) end
							if math.abs(dy)>0.001 then t=math.min(t,(dy>0 and (vp.Y-margin-cy) or (margin-cy))/dy) end
							if t>0 and t<math.huge then screenPos=Vector3.new(cx+dx*t,cy+dy*t,0) end
						end
						local edgeX=math.clamp(screenPos.X,margin,vp.X-margin)
						local edgeY=math.clamp(screenPos.Y,margin,vp.Y-margin)
						if not ProximityOffScreenFrames[plr] then
							local container=Instance.new("Frame",ScreenGui)
							container.Name="GH_ProxOffScreen"; container.Size=UDim2.new(0,22,0,22)
							container.AnchorPoint=Vector2.new(0.5,0.5); container.BackgroundTransparency=1; container.ZIndex=100
							local diamond=Instance.new("Frame",container)
							diamond.AnchorPoint=Vector2.new(0.5,0.5); diamond.Position=UDim2.new(0.5,0,0.5,0)
							diamond.Size=UDim2.new(0,16,0,16); diamond.Rotation=45
							diamond.BackgroundColor3=Color3.fromRGB(255,200,80); diamond.BorderSizePixel=0
							Instance.new("UICorner",diamond).CornerRadius=UDim.new(0,1)
							local outline=Instance.new("UIStroke",diamond)
							outline.Color=Color3.fromRGB(40,30,0); outline.Thickness=1.5; outline.Transparency=0
							local exclam=Instance.new("TextLabel",container)
							exclam.Size=UDim2.new(1,0,1,0); exclam.Position=UDim2.new(0,0,0,0)
							exclam.BackgroundTransparency=1; exclam.Text="!"
							exclam.TextColor3=Color3.fromRGB(255,255,255); exclam.Font=Enum.Font.GothamBlack
							exclam.TextSize=14; exclam.TextStrokeColor3=Color3.fromRGB(40,30,0)
							exclam.TextStrokeTransparency=0; exclam.ZIndex=101
							ProximityOffScreenFrames[plr]=container
						end
						ProximityOffScreenFrames[plr].Position=UDim2.new(0,edgeX,0,edgeY)
						ProximityOffScreenFrames[plr].Visible=true
					else
						if ProximityOffScreenFrames[plr] then ProximityOffScreenFrames[plr].Visible=false end
					end
				else
					if ProximityOffScreenFrames[plr] then ProximityOffScreenFrames[plr]:Destroy(); ProximityOffScreenFrames[plr]=nil end
				end
			end
		end
	end
	for plr,hl in pairs(ProximityHighlights) do if not seen[plr] then hl:Destroy(); ProximityHighlights[plr]=nil end end
	for plr,bb in pairs(ProximityBillboards) do if not seen[plr] then bb:Destroy(); ProximityBillboards[plr]=nil end end
	for plr,f  in pairs(ProximityOffScreenFrames) do if not seen[plr] then f:Destroy(); ProximityOffScreenFrames[plr]=nil end end
end

Run.Heartbeat:Connect(function() UpdateProximity() end)
_G.GH_ClearProximityFX = ClearProximityFX

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XVII] FOOTSTEP WEIGHT
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local function TriggerStep(scale)
	if not Cfg.WeightEnabled then return end
	local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then return end
	local snd=Instance.new("Sound",root)
	snd.SoundId=(scale>1.4) and "rbxassetid://138090008" or "rbxassetid://134854597"
	snd.Volume=Cfg.StepVolume*(0.6+scale*0.4); snd.PlaybackSpeed=math.clamp(1.1-scale*0.15,0.5,1.5)
	snd:Play(); Debris:AddItem(snd,1.5)
	if scale>1.1 then
		local shake=Cfg.StepShake*scale
		task.spawn(function()
			for _=1,5 do
				State.StepShakeX=math.random(-10,10)*0.005*shake
				State.StepShakeY=math.random(-10,10)*0.005*shake
				Run.RenderStepped:Wait()
			end
			State.StepShakeX=0; State.StepShakeY=0
		end)
	end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XVIII] MAIN GAME LOOP
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Run.RenderStepped:Connect(function(dt)
	local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
	local root=char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not root then return end

	if hum.Health<=0.1 and hum.MaxHealth>0 and not State.IsDead then HandleDeath() end

	if Cfg.RegenRate>0 and not State.IsDead and hum.Health>0 then
		hum.Health=math.min(hum.MaxHealth, hum.Health+(hum.MaxHealth*Cfg.RegenRate/100)*dt)
	end

	if Cfg.ExplosionVelocityDamage then
		local velY=root.Velocity.Y; local landVel=math.abs(velY)
		if landVel>80 and math.abs(State.LastVelocityY)<10 then
			local dmg=(landVel-80)*0.5*Cfg.DurabilityMult
			if dmg>5 then
				hum:TakeDamage(dmg); BloodBurst(root,math.floor(dmg*0.5))
				if dmg>30 then SetRagdoll(true); task.delay(2,function() if not State.IsDead then SetRagdoll(false) end end) end
			end
		end
		State.LastVelocityY=root.Velocity.Y
	end

	if Cfg.RagdollOnJerk and not State.IsRagdolled and not State.IsDead and not State.IsGhost then
		local vel=root.Velocity
		if State.LastRootVelocity then
			local jerk=(vel-State.LastRootVelocity).Magnitude
			if jerk>(Cfg.RagdollJerkThreshold or 45) then
				SetRagdoll(true)
				task.delay(2,function() if not State.IsDead then SetRagdoll(false) end end)
			end
		end
		State.LastRootVelocity=vel
	else
		State.LastRootVelocity=root.Velocity
	end

	if State.IsDead and hum.Health>0 and not State.IsGhost and not Cfg.PermadeathEnabled then
		State.IsDead=false; DeathOverlay.Visible=false
	end

	if State.MovementLocked or State.IsRagdolled or State.IsUnconscious or (State.IsDead and not State.IsGhost) then
		hum.WalkSpeed=0; hum.JumpPower=0
	elseif not State.IsGhost then
		local target=Cfg.NormalSpeed
		if State.IsCrouching then target=Cfg.CrouchSpeed
		elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then target=Cfg.SprintSpeed end
		if State.IsRaging then target=target*Cfg.RageSpeedMult end
		local alpha=math.clamp(Cfg.SpeedSmooth*dt,0,1)
		State.CurrentSpeed=State.CurrentSpeed+(target-State.CurrentSpeed)*alpha
		hum.WalkSpeed=State.CurrentSpeed; hum.JumpPower=Cfg.JumpPower
		workspace.Gravity=Cfg.Gravity
	end

	if State.IsRaging then
		State.RageValue=math.max(0,State.RageValue-Cfg.RageDrainRate*dt)
		if State.RageValue<=0 then SetRage(false) end
		local tx=State.RageValue/100
		RageFill.Size=UDim2.new(RageFill.Size.X.Scale+(tx-RageFill.Size.X.Scale)*math.clamp(8*dt,0,1),0,1,0)
		RageLabel.Text="RAGE  "..math.floor(State.RageValue).."%"
		local pulse=0.6+math.sin(tick()*6)*0.15
		RageFill.BackgroundColor3=Color3.new(pulse,0,0)
		if Cfg.RageHealthRegen>0 and hum.Health<hum.MaxHealth then
			hum.Health=math.min(hum.MaxHealth,hum.Health+(hum.MaxHealth*Cfg.RageHealthRegen/100)*dt)
		end
	end

	local hp=hum.Health/hum.MaxHealth
	if Cfg.HealthVisualsEnabled and not State.IsRaging then
		local missing=1-hp; local lerpA=math.clamp(3*dt,0,1)
		FX.Blur.Size=FX.Blur.Size+(missing*14-FX.Blur.Size)*lerpA
		FX.CC.Brightness=FX.CC.Brightness+(-missing*0.35-FX.CC.Brightness)*lerpA
		FX.CC.Contrast=FX.CC.Contrast+(missing*0.25-FX.CC.Contrast)*lerpA
		FX.CC.Saturation=FX.CC.Saturation+(-missing*0.7-FX.CC.Saturation)*lerpA
		if hp<Cfg.LowHealthThreshold then
			if not FX.Heartbeat.IsPlaying then FX.Heartbeat:Play() end
			FX.Heartbeat.Volume=missing*0.7; FX.Heartbeat.PlaybackSpeed=0.5+hp*0.4
		else
			FX.Heartbeat.Volume=math.max(0,FX.Heartbeat.Volume-dt*0.5)
			if FX.Heartbeat.Volume<=0 and not State.IsRaging then FX.Heartbeat:Stop() end
		end
	end
	UpdateHurtAnim(hp, hum.MoveDirection.Magnitude>0.1)

	if root.Velocity.Y<-15 then
		if not State.Falling then State.LastFallY=root.Position.Y; State.Falling=true end
	elseif State.Falling and math.abs(root.Velocity.Y)<1 then
		State.Falling=false
		local dist=State.LastFallY-root.Position.Y
		if dist>Cfg.MinFallHeight and Cfg.FallDamageEnabled then
			hum:TakeDamage((dist-Cfg.MinFallHeight)*1.4*Cfg.DurabilityMult)
			FX.Blur.Size=28; FX.CC.Brightness=-0.5
			Tween:Create(FX.Blur,TweenInfo.new(3),{Size=0}):Play()
			Tween:Create(FX.CC,TweenInfo.new(3),{Brightness=0}):Play()
			BloodBurst(root,60); SpawnBloodPool(root.Position,math.random(50,70)*0.1)
			local minor=Cfg.InjuryThresholdMinor or 35; local major=Cfg.InjuryThresholdMajor or 55
			if dist>minor then ApplyInjury(math.random()>0.5 and "LeftLeg" or "RightLeg",40); ApplyInjury("Bleeding",0) end
			if dist>major then ApplyInjury("LeftLeg",0); ApplyInjury("RightLeg",0); ApplyInjury("Concussion",0) end
			if Cfg.SpamToGetUp then
				State.IsDown=true; State.SpamCount=0; hum.PlatformStand=true; SetRagdoll(true)
			end
		end
	end

	if State.IsChargingSonar then
		State.SonarPower=math.min(1,State.SonarPower+dt)
		FX.Blur.Size=math.max(FX.Blur.Size,State.SonarPower*12)
	end

	if State.SonarAmbient then
		local i=State.SonarAmbientIntensity
		FX.CC.TintColor=Color3.fromRGB(0,255,255)
		if i>0.6 then FX.Tinnitus.Volume=i; if not FX.Tinnitus.IsPlaying then FX.Tinnitus:Play() end end
	else
		if not State.IsRaging then FX.CC.TintColor=Color3.new(1,1,1) end
		FX.Tinnitus.Volume=math.max(0,FX.Tinnitus.Volume-dt*0.4)
		if FX.Tinnitus.Volume<=0 then FX.Tinnitus:Stop() end
	end

	local joint=root:FindFirstChild("RootJoint")
	if joint then
		if State.JointRef~=joint then State.JointRef=joint; State.OriginalC0=joint.C0 end
		if State.OriginalC0 then
			local moveDir=root.CFrame:VectorToObjectSpace(hum.MoveDirection)
			local scale=GetScale(); local leanMag=Cfg.LeanIntensity/math.max(1,scale*0.4)
			local targetLean=math.rad(-moveDir.X*leanMag); local targetPitch=math.rad(moveDir.Z*leanMag*0.5)
			State.LeanLerp=State.LeanLerp+(targetLean-State.LeanLerp)*math.clamp(8*dt,0,1)
			State.TiltLerp=State.TiltLerp+(targetPitch-State.TiltLerp)*math.clamp(8*dt,0,1)
			joint.C0=State.OriginalC0*CFrame.Angles(State.TiltLerp,0,State.LeanLerp)
		end
	end

	local bobY=0; local shakeX=State.StepShakeX; local shakeY=State.StepShakeY
	if hum.MoveDirection.Magnitude>0.1 and hum.FloorMaterial~=Enum.Material.Air then
		local scale=GetScale(); State.StepCycle=State.StepCycle+dt*hum.WalkSpeed*Cfg.StrideFreq
		local wave=math.sin(State.StepCycle)
		if (wave>0.9 or wave<-0.9) and not State.StepLock then
			State.StepLock=true; TriggerStep(scale)
		elseif math.abs(wave)<0.4 then State.StepLock=false end
		bobY=math.abs(wave)*Cfg.CamBob*scale*0.2
	end
	if State.IsNervous then
		local s=Cfg.NervousShake
		shakeX=shakeX+math.rad(math.random(-10,10)*0.012*s)
		shakeY=shakeY+math.rad(math.random(-10,10)*0.012*s)
	end
	if Injuries.Concussion then shakeX=shakeX+math.rad(math.random(-10,10)*0.025); shakeY=shakeY+math.rad(math.random(-10,10)*0.025) end
	if State.IsUnconscious then shakeX=shakeX+math.rad(math.random(-10,10)*0.01); shakeY=shakeY+math.rad(math.random(-10,10)*0.01) end
	local limpRoll=math.rad(State.LimpBias or 0)*0.04
	local sideways=hum.MoveDirection:Dot(Camera.CFrame.RightVector)
	local tiltTarget=-sideways*Cfg.CamTilt
	State.LastTilt=State.LastTilt+(tiltTarget-State.LastTilt)*math.clamp(Cfg.CamSmooth*dt,0,1)
	if not State.IsRaging and not State.IsGhost then
		local fovTarget=Cfg.FOV+math.max(0,hum.WalkSpeed-16)*0.6
		Camera.FieldOfView=Camera.FieldOfView+(fovTarget-Camera.FieldOfView)*math.clamp(6*dt,0,1)
	end
	if not State.IsGhost then
		Camera.CFrame=Camera.CFrame*CFrame.new(shakeX,bobY+shakeY,0)*CFrame.Angles(0,0,math.rad(State.LastTilt)+limpRoll)
	end

	if State.FocusTarget and State.FocusPart and Cfg.FocusEnabled then
		if not State.FocusPart.Parent or not State.FocusTarget.Parent then
			if _G.GH_ClearFocus then _G.GH_ClearFocus(false) end; return
		end
		if Cfg.FocusInViewOnly then
			local origin=Camera.CFrame.Position
			local dir=(State.FocusPart.Position-origin).Unit
			local rayParams=RaycastParams.new()
			rayParams.FilterType=Enum.RaycastFilterType.Exclude
			rayParams.FilterDescendantsInstances={LP.Character or {}}
			local hit=workspace:Raycast(origin,dir*500,rayParams)
			local blocked=hit and not State.FocusTarget:IsAncestorOf(hit.Instance) and not (hit.Instance==State.FocusTarget)
			if blocked then
				State.FocusLostTime=State.FocusLostTime+dt
				if State.FocusHighlight then State.FocusHighlight.OutlineTransparency=0.3+math.sin(tick()*8)*0.3 end
			else
				State.FocusLostTime=0
				if State.FocusHighlight then State.FocusHighlight.OutlineTransparency=0 end
			end
			if State.FocusLostTime>=(Cfg.FocusLostThreshold or 2) then
				if _G.GH_ClearFocus then _G.GH_ClearFocus(true) end
			end
		end
		if State.FocusTarget and State.FocusPart and not State.IsGhost then
			local toPos=State.FocusPart.Position+Vector3.new(0,1.5,0)
			local cur=Camera.CFrame
			local goal=CFrame.new(cur.Position,toPos)
			Camera.CFrame=cur:Lerp(goal,math.clamp(2*dt,0,0.5))
		end
	end
end)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XIX] IDLE RANDOMIZER
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
task.spawn(function()
	while true do
		task.wait(math.random(10,30))
		local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
		if hum and hum.MoveDirection.Magnitude<0.1 and not State.ActiveTrack
			and not State.IsRaging and not State.IsDead and math.random(100)<=30 then
			local a=Instance.new("Animation"); a.AnimationId="rbxassetid://"..Anims.IdleRandom
			local track=GetAnimator():LoadAnimation(a)
			track.Priority=Enum.AnimationPriority.Idle; track.Looped=true; track:Play(0.5)
			State.IdleAnimActive=true
			local elapsed,duration=0,math.random(10,60)
			while elapsed<duration and State.IdleAnimActive do
				task.wait(1); elapsed+=1
				local c=LP.Character; local h=c and c:FindFirstChildOfClass("Humanoid")
				if not h or h.MoveDirection.Magnitude>0.1 then break end
			end
			track:Stop(0.4); State.IdleAnimActive=false
		end
	end
end)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XIX.5] FOCUS SYSTEM
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local NPCList = {} -- defined here so focus and input can reference it
_G.GH_NPCList = NPCList

local function ClearFocus(wasLost)
	if State.FocusHighlight then pcall(function() State.FocusHighlight:Destroy() end); State.FocusHighlight=nil end
	if wasLost then
		local red=Instance.new("Frame",ScreenGui)
		red.Size=UDim2.new(1,0,1,0); red.BackgroundColor3=Color3.fromRGB(120,0,0)
		red.BackgroundTransparency=1; red.ZIndex=850
		Tween:Create(red,TweenInfo.new(0.15),{BackgroundTransparency=0.4}):Play()
		task.delay(0.2,function() Tween:Create(red,TweenInfo.new(0.3),{BackgroundTransparency=1}):Play(); task.delay(0.35,function() red:Destroy() end) end)
	end
	State.FocusTarget=nil; State.FocusPart=nil; State.FocusLostTime=0
end

local function StartFocus(targetPart)
	if not targetPart or not targetPart.Parent then return end
	ClearFocus(false)
	local parent=targetPart:IsA("Model") and targetPart or targetPart.Parent
	local root2=parent:FindFirstChild("HumanoidRootPart") or parent:FindFirstChild("Head") or targetPart
	State.FocusPart=root2; State.FocusTarget=parent; State.FocusLostTime=0
	State.FocusHighlight=Instance.new("Highlight",parent)
	State.FocusHighlight.FillColor=Color3.fromRGB(0,200,255)
	State.FocusHighlight.OutlineColor=Color3.fromRGB(255,255,255)
	State.FocusHighlight.FillTransparency=0.6
end

_G.GH_ClearFocus = ClearFocus
_G.GH_StartFocus = StartFocus

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XX] INPUT HANDLING
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local MainFrame = _G.GH_MainFrame

UIS.InputBegan:Connect(function(inp, gpe)
	if gpe then return end
	if inp.KeyCode==Enum.KeyCode.LeftAlt then
		MainFrame.Visible=not MainFrame.Visible
		if State.IsGhost then
			UIS.MouseBehavior=MainFrame.Visible and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCurrentPosition
		end
		return
	end
	if State.IsGhost then return end
	local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid")
	if State.IsDown and inp.KeyCode==Enum.KeyCode.Space then
		State.SpamCount+=1
		if State.SpamCount>=Cfg.SpamThreshold then
			State.IsDown=false
			if hum then hum.PlatformStand=false end
			SetRagdoll(false)
		end
		return
	end
	if State.IsDead and not State.IsGhost then return end
	if not hum then return end
	if inp.KeyCode==Enum.KeyCode.M then
		PlayKeybindAnim(Anims.M_Key[math.random(#Anims.M_Key)].id,"M")
	elseif inp.KeyCode==Enum.KeyCode.O then
		PlayKeybindAnim(Anims.O_Key[math.random(#Anims.O_Key)],"O")
	elseif inp.KeyCode==Enum.KeyCode.P then
		PlayKeybindAnim(Anims.P_Key[math.random(#Anims.P_Key)],"P")
	elseif inp.KeyCode==Enum.KeyCode.I then
		PlayKeybindAnim(Anims.I_Key[math.random(#Anims.I_Key)],"I")
	elseif inp.KeyCode==Enum.KeyCode.C then
		State.IsCrouching=not State.IsCrouching
		if State.IsCrouching then
			local a=Instance.new("Animation"); a.AnimationId="rbxassetid://113780551991016"
			local t=GetAnimator():LoadAnimation(a); t.Priority=Enum.AnimationPriority.Action; t:Play(0.15)
		end
		ApplyAnims()
	elseif inp.KeyCode==Enum.KeyCode.R then
		SetRagdoll(not State.IsRagdolled)
	elseif inp.KeyCode==Enum.KeyCode.Z then
		if State.IsRaging then SetRage(false); State.RageValue=0 else AddRage(20) end
	elseif inp.KeyCode==Enum.KeyCode.Q then
		State.IsChargingSonar=true; State.SonarPower=0
	elseif Cfg.FocusEnabled and inp.KeyCode==Cfg.FocusKey then
		if State.FocusTarget then ClearFocus(false); return end
		local mouse=LP:GetMouse(); local target=mouse.Target
		if target and target:IsDescendantOf(workspace) then
			StartFocus(target)
		end
	end
end)

UIS.InputEnded:Connect(function(inp)
	if inp.KeyCode==Enum.KeyCode.Q and State.IsChargingSonar then
		State.IsChargingSonar=false; DoSonarPing(State.SonarPower); FX.Blur.Size=0
	end
	if inp.KeyCode==Enum.KeyCode.LeftAlt and not State.IsGhost then
		UIS.MouseBehavior=Enum.MouseBehavior.Default
	end
end)

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XXI] NPC SYSTEM
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local SpawnedObjects = {}
_G.GH_SpawnedObjects = SpawnedObjects

local NPC_DETECT_RANGE = 60
local NPC_ATTACK_RANGE = 5
local NPC_FLEE_HP_PCT  = 0.25
local NPC_ATTACK_DMG   = 10
local NPC_ATTACK_CD    = 1.5

local function NPC_FindNearestPlayer(root)
	local best,bestDist=nil,math.huge
	for _,p in ipairs(Players:GetPlayers()) do
		local c=p.Character; local r2=c and c:FindFirstChild("HumanoidRootPart")
		if r2 then local d=(r2.Position-root.Position).Magnitude; if d<bestDist then bestDist=d; best=c end end
	end
	return best,bestDist
end

local function BuildHealthBar(npcModel)
	local head=npcModel:FindFirstChild("Head") or npcModel:FindFirstChild("HumanoidRootPart"); if not head then return end
	local bbg=Instance.new("BillboardGui",head); bbg.Name="GH_NPC_HB"
	bbg.Size=UDim2.new(0,80,0,16); bbg.StudsOffset=Vector3.new(0,2.8,0); bbg.AlwaysOnTop=false; bbg.MaxDistance=50
	local bg=Instance.new("Frame",bbg)
	bg.Size=UDim2.new(1,0,0.55,0); bg.Position=UDim2.new(0,0,0,0.45)
	bg.BackgroundColor3=Color3.fromRGB(40,0,0); bg.BorderSizePixel=0
	Instance.new("UICorner",bg).CornerRadius=UDim.new(0,3)
	local fill=Instance.new("Frame",bg); fill.Name="Fill"; fill.Size=UDim2.new(1,0,1,0)
	fill.BackgroundColor3=Color3.fromRGB(180,30,30); fill.BorderSizePixel=0
	Instance.new("UICorner",fill).CornerRadius=UDim.new(0,3)
	return fill
end

local function StartNPCBrain(rec)
	local model=rec.model
	local hpFill=BuildHealthBar(model)
	task.spawn(function()
		local lastAttack=0
		while model and model.Parent do
			local hum=model:FindFirstChildOfClass("Humanoid")
			local root=model:FindFirstChild("HumanoidRootPart")
			if not hum or not root or hum.Health<=0 then break end
			if hpFill and hpFill.Parent then
				local pct=hum.Health/hum.MaxHealth
				hpFill.Size=UDim2.new(pct,0,1,0)
				hpFill.BackgroundColor3=Color3.fromRGB(math.floor(180*(1-pct)+40*pct),math.floor(160*pct),0)
			end
			local hpPct=hum.Health/hum.MaxHealth
			local nearChar,nearDist=NPC_FindNearestPlayer(root)
			local nearHum=nearChar and nearChar:FindFirstChildOfClass("Humanoid")
			local nearRoot=nearChar and nearChar:FindFirstChild("HumanoidRootPart")
			if rec.behavior=="Hostile" then
				if nearChar and nearDist<NPC_DETECT_RANGE then
					if nearRoot then hum:MoveTo(nearRoot.Position) end
					if nearDist<NPC_ATTACK_RANGE and tick()-lastAttack>NPC_ATTACK_CD then
						lastAttack=tick(); if nearHum then nearHum:TakeDamage(NPC_ATTACK_DMG) end
					end
				elseif rec.nodeMap and #rec.nodeMap>0 then
					rec.nodeIdx=(rec.nodeIdx or 0)%#rec.nodeMap+1; hum:MoveTo(rec.nodeMap[rec.nodeIdx])
				end
			elseif rec.behavior=="Friendly" then
				local myChar=LP.Character; local myRoot=myChar and myChar:FindFirstChild("HumanoidRootPart")
				if myRoot then local d=(myRoot.Position-root.Position).Magnitude; if d>6 then hum:MoveTo(myRoot.Position) end end
			elseif rec.behavior=="Neutral" then
				if hpPct<NPC_FLEE_HP_PCT and nearChar and nearRoot and nearDist<NPC_DETECT_RANGE then
					local fleeDir=(root.Position-nearRoot.Position).Unit; hum:MoveTo(root.Position+fleeDir*20)
				elseif rec.nodeMap and #rec.nodeMap>0 then
					rec.nodeIdx=(rec.nodeIdx or 0)%#rec.nodeMap+1; hum:MoveTo(rec.nodeMap[rec.nodeIdx])
				end
			end
			task.wait(0.5)
		end
		if model and model.Parent then
			local root2=model:FindFirstChild("HumanoidRootPart")
			if root2 then BloodBurst(root2,80); SpawnBloodPool(root2.Position,0.5) end
			task.delay(4,function() pcall(function() model:Destroy() end) end)
		end
		for i,r in ipairs(NPCList) do if r==rec then table.remove(NPCList,i); break end end
	end)
end

local function GenerateNodes(center,count,radius)
	local nodes={}
	for i=1,count do
		local angle=(i/count)*math.pi*2
		local x=center.X+math.cos(angle)*radius; local z=center.Z+math.sin(angle)*radius
		local res=workspace:Raycast(Vector3.new(x,center.Y+10,z),Vector3.new(0,-30,0),RaycastParams.new())
		local y=res and (res.Position.Y+0.5) or center.Y
		table.insert(nodes,Vector3.new(x,y,z))
	end
	return nodes
end

local function SpawnNPC(behavior, walkSpeed)
	local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart"); if not root then return end
	local spawnPos=root.Position+root.CFrame.LookVector*6+Vector3.new(0,3,0)
	walkSpeed=walkSpeed or 16
	if Cfg.NPCUseDefaultRig then
		local ok,model=pcall(function() return Players:CreateHumanoidModelFromUserId(Cfg.NPCDefaultRigUserId or 1) end)
		if ok and model and model:FindFirstChildOfClass("Humanoid") then
			model.Name="GH_NPC_"..behavior; model.Parent=workspace
			local hrp=model:FindFirstChild("HumanoidRootPart")
			if hrp then hrp.CFrame=CFrame.new(spawnPos) end
			local hum=model:FindFirstChildOfClass("Humanoid")
			hum.MaxHealth=100; hum.Health=100; hum.WalkSpeed=walkSpeed; hum.JumpPower=50
			local nodes=GenerateNodes(spawnPos,6,18)
			local rec={model=model,behavior=behavior,nodeMap=nodes,nodeIdx=0}
			table.insert(NPCList,rec); table.insert(SpawnedObjects,{model=model,type="npc"})
			StartNPCBrain(rec); return rec
		end
	end
	local bodyColor=behavior=="Hostile" and Color3.fromRGB(180,30,30)
		or behavior=="Friendly" and Color3.fromRGB(30,160,80)
		or Color3.fromRGB(140,120,70)
	local model=Instance.new("Model",workspace); model.Name="GH_NPC_"..behavior
	local function makePart(name,sz,pos,col,noCollide)
		local p=Instance.new("Part",model); p.Name=name
		p.Size=sz; p.CFrame=CFrame.new(pos); p.Color=col or bodyColor
		p.CanCollide=not noCollide; p.CastShadow=false; return p
	end
	local skinColor=Color3.fromRGB(255,220,185)
	local hrp=makePart("HumanoidRootPart",Vector3.new(2,2,1),spawnPos,Color3.new(0,0,0),false); hrp.Transparency=1
	local ut=makePart("UpperTorso",Vector3.new(2,1.5,1),spawnPos+Vector3.new(0,0.5,0))
	local lt=makePart("LowerTorso",Vector3.new(2,1.5,1),spawnPos+Vector3.new(0,-1.0,0))
	local head=makePart("Head",Vector3.new(2,1,1),spawnPos+Vector3.new(0,2.2,0),skinColor,true)
	local ula=makePart("UpperLeftArm",Vector3.new(1,1.2,1),spawnPos+Vector3.new(-1.5,0.5,0),skinColor,true)
	local ura=makePart("UpperRightArm",Vector3.new(1,1.2,1),spawnPos+Vector3.new(1.5,0.5,0),skinColor,true)
	local lla=makePart("LowerLeftArm",Vector3.new(1,1.2,1),spawnPos+Vector3.new(-1.5,-0.8,0),skinColor,true)
	local lra=makePart("LowerRightArm",Vector3.new(1,1.2,1),spawnPos+Vector3.new(1.5,-0.8,0),skinColor,true)
	local ull=makePart("UpperLeftLeg",Vector3.new(1,1.2,1),spawnPos+Vector3.new(-0.6,-2.2,0),bodyColor,true)
	local url=makePart("UpperRightLeg",Vector3.new(1,1.2,1),spawnPos+Vector3.new(0.6,-2.2,0),bodyColor,true)
	local lll=makePart("LowerLeftLeg",Vector3.new(1,1.3,1),spawnPos+Vector3.new(-0.6,-3.6,0),bodyColor,true)
	local lrl=makePart("LowerRightLeg",Vector3.new(1,1.3,1),spawnPos+Vector3.new(0.6,-3.6,0),bodyColor,true)
	local function motor(name,p0,p1,c0,c1)
		local m=Instance.new("Motor6D",p0); m.Name=name; m.Part0=p0; m.Part1=p1; m.C0=c0; m.C1=c1
	end
	motor("Root",hrp,lt,CFrame.new(0,-1,0)*CFrame.Angles(-math.pi/2,0,math.pi),CFrame.new(0,-0.75,0)*CFrame.Angles(-math.pi/2,0,math.pi))
	motor("Waist",lt,ut,CFrame.new(0,0.75,0),CFrame.new(0,-0.75,0))
	motor("Neck",ut,head,CFrame.new(0,1.2,0),CFrame.new(0,-0.5,0))
	motor("LeftShoulder",ut,ula,CFrame.new(-1.2,0.4,0),CFrame.new(0.5,0.6,0))
	motor("RightShoulder",ut,ura,CFrame.new(1.2,0.4,0),CFrame.new(-0.5,0.6,0))
	motor("LeftElbow",ula,lla,CFrame.new(0,-0.6,0),CFrame.new(0,0.6,0))
	motor("RightElbow",ura,lra,CFrame.new(0,-0.6,0),CFrame.new(0,0.6,0))
	motor("LeftHip",lt,ull,CFrame.new(-0.6,-0.75,0),CFrame.new(0,0.6,0))
	motor("RightHip",lt,url,CFrame.new(0.6,-0.75,0),CFrame.new(0,0.6,0))
	motor("LeftKnee",ull,lll,CFrame.new(0,-0.6,0),CFrame.new(0,0.65,0))
	motor("RightKnee",url,lrl,CFrame.new(0,-0.6,0),CFrame.new(0,0.65,0))
	local bbg=Instance.new("BillboardGui",head); bbg.Size=UDim2.new(0,90,0,22)
	bbg.StudsOffset=Vector3.new(0,1.8,0); bbg.AlwaysOnTop=false; bbg.MaxDistance=50
	local nl=Instance.new("TextLabel",bbg); nl.Size=UDim2.new(1,0,1,0); nl.BackgroundTransparency=1
	nl.Text=behavior
	nl.TextColor3=behavior=="Hostile" and Color3.fromRGB(255,100,100) or behavior=="Friendly" and Color3.fromRGB(100,255,120) or Color3.fromRGB(255,220,120)
	nl.Font=Enum.Font.GothamBold; nl.TextSize=11
	local hum=Instance.new("Humanoid",model)
	hum.MaxHealth=100; hum.Health=100; hum.WalkSpeed=walkSpeed; hum.JumpPower=50; hum.HipHeight=2.2
	hum.AutoRotate=true; hum.BreakJointsOnDeath=false
	model.PrimaryPart=hrp
	local nodes=GenerateNodes(spawnPos,6,18)
	local rec={model=model,behavior=behavior,nodeMap=nodes,nodeIdx=0}
	table.insert(NPCList,rec); table.insert(SpawnedObjects,{model=model,type="npc"})
	StartNPCBrain(rec); return rec
end
_G.GH_SpawnNPC = SpawnNPC

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XXII] AVATAR CATALOG SYSTEM
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local AvatarState = {
	OriginalDesc=nil, AppliedDesc=nil, PersistCatalog=true,
	Scale={BodyType=0,Depth=1,Head=1,Height=1,Proportion=0,Width=1},
}
_G.GH_AvatarState = AvatarState

task.spawn(function()
	pcall(function() AvatarState.OriginalDesc=Players:GetHumanoidDescriptionFromUserId(LP.UserId) end)
end)

local function GetHumDesc()
	local char=LP.Character; local hum=char and char:FindFirstChildOfClass("Humanoid"); if not hum then return nil end
	return hum, hum:GetAppliedDescription()
end

local function ApplyDesc(desc)
	local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if not hum or not desc then return end
	pcall(function() hum:ApplyDescription(desc) end); AvatarState.AppliedDesc=desc
end

local function ApplyScale(key,val)
	AvatarState.Scale[key]=val
	local hum,desc=GetHumDesc(); if not hum or not desc then return end
	pcall(function() desc[key]=val end); ApplyDesc(desc)
end

LP.CharacterAdded:Connect(function()
	if AvatarState.PersistCatalog and AvatarState.AppliedDesc then
		task.wait(2); ApplyDesc(AvatarState.AppliedDesc)
	end
end)

local function CatalogSearch(query, assetType, callback)
	local url=("https://catalog.roblox.com/v1/search/items?category=All&keyword=%s&limit=10"):format(HttpSvc:UrlEncode(query))
	if assetType and assetType~="" then url=url.."&assetType="..assetType end
	task.spawn(function()
		local result=nil
		for _,reqFn in ipairs({
			function() return syn and syn.request and syn.request({Url=url,Method="GET"}).Body end,
			function() return http and http.request and http.request({Url=url,Method="GET"}).Body end,
			function() return request and request({Url=url,Method="GET"}).Body end,
			function() return http_request and http_request({Url=url,Method="GET"}).Body end,
		}) do
			local ok,r=pcall(reqFn); if ok and r then result=r; break end
		end
		if not result then callback(nil,"No HTTP method available"); return end
		local ok2,data=pcall(function() return HttpSvc:JSONDecode(result) end)
		if ok2 and data and data.data then callback(data.data)
		else callback(nil,"Parse error") end
	end)
end

_G.GH_GetHumDesc     = GetHumDesc
_G.GH_ApplyDesc      = ApplyDesc
_G.GH_ApplyScale     = ApplyScale
_G.GH_CatalogSearch  = CatalogSearch

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XXIII] AUDIO TAB SUPPORT
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
local AmbientSound   = nil
local AmbientEffects = {}

local function GetAmbientSound()
	if not AmbientSound or not AmbientSound.Parent then
		AmbientSound=Camera:FindFirstChild("GH_Ambient") or Instance.new("Sound",Camera)
		AmbientSound.Name="GH_Ambient"
	end
	return AmbientSound
end

local function GetOrCreateAmbientEffect(name, className)
	local snd=GetAmbientSound()
	local fx=AmbientEffects[name] or snd:FindFirstChild("GH_Ambient_"..name)
	if fx then AmbientEffects[name]=fx; return fx end
	fx=Instance.new(className,snd); fx.Name="GH_Ambient_"..name
	pcall(function() fx.Enabled=false end)
	AmbientEffects[name]=fx; return fx
end

_G.GH_GetAmbientSound          = GetAmbientSound
_G.GH_GetOrCreateAmbientEffect = GetOrCreateAmbientEffect
_G.GH_AmbientEffects           = AmbientEffects

print("[GH S2] Systems loaded — run S3 next")
