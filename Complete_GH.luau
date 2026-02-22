--[[
╔══════════════════════════════════════════════════════════════════════════╗
║         GHOST HUB TITAN — DEFINITIVE EDITION (v33.0)                    ║
║         SCRIPT 1 / 3  —  CORE                                           ║
║         Run this FIRST. Populates _G.GH_* for S2 and S3.                ║
╚══════════════════════════════════════════════════════════════════════════╝
]]

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [I] SERVICES
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
do
	local Svc = setmetatable({}, {__index = function(_, k) return game:GetService(k) end})
	_G.GH_Svc      = Svc
	_G.GH_UIS      = Svc.UserInputService
	_G.GH_Run      = Svc.RunService
	_G.GH_Players  = Svc.Players
	_G.GH_Tween    = Svc.TweenService
	_G.GH_Lighting = Svc.Lighting
	_G.GH_Debris   = Svc.Debris
	_G.GH_HttpSvc  = Svc.HttpService
	_G.GH_LP       = Svc.Players.LocalPlayer
	_G.GH_Camera   = workspace.CurrentCamera
end

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

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [II] XENO PERSISTENCE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
do
	_G.GH_SAVE_FILE     = "ghosthub_manims.json"
	_G.GH_CFG_SAVE_FILE = "GhostHub_v33.json"
end

local SAVE_FILE     = _G.GH_SAVE_FILE
local CFG_SAVE_FILE = _G.GH_CFG_SAVE_FILE

local function xenoSave(data)
	pcall(function() writefile(SAVE_FILE, HttpSvc:JSONEncode(data)) end)
end
local function xenoLoad()
	local ok, raw = pcall(readfile, SAVE_FILE)
	if ok and raw then
		local ok2, t = pcall(function() return HttpSvc:JSONDecode(raw) end)
		if ok2 then return t end
	end
	return nil
end
_G.GH_xenoSave = xenoSave
_G.GH_xenoLoad = xenoLoad

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [III] CONFIGURATION
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
do
	_G.GH_Cfg = {
		NormalSpeed=16, SprintSpeed=26, CrouchSpeed=10,
		JumpPower=50, Gravity=196.2, SpeedSmooth=10,
		CamTilt=8, CamSmooth=8, CamBob=0.3, FOV=75, LeanIntensity=15,
		WeightEnabled=true, StepVolume=0.6, StepShake=0.4, StrideFreq=0.4,
		RageSpeedMult=1.6, RageAnimSpeed=1.0, RageFOV=95,
		RageDrainRate=100/(5*60), RageHealthRegen=2.0,
		NervousShake=1.5,
		SonarMaxRadius=150,
		FallDamageEnabled=true, MinFallHeight=25,
		SpamToGetUp=true, SpamThreshold=10,
		InjuryThresholdMinor=35, InjuryThresholdMajor=55,
		MaxHealth=100, HealthVisualsEnabled=true,
		LowHealthThreshold=0.6, RegenRate=0, DurabilityMult=1.0,
		UnconsciousnessEnabled=true, KnockoutDuration=8,
		PermadeathEnabled=false, GhostOnDeath=true,
		BloodPoolsEnabled=true, BloodParticlesEnabled=true, BloodPoolSize=6.0,
		Variant="V1", Source="Main",
		ExplosionForce=true, ExplosionVelocityDamage=true,
		ProximityEnabled=false, ProximityRange=40,
		ProximityHighlight=true, ProximityMarker=true, ProximityMarkerRange=60,
		TTSEnabled=false, TTSVoiceId="1", TTSVolume=1.0, TTSRate=1.0,
		TTSPitch=0, TTSReverb=false, TTSReverbDecay=1.5, TTSReverbWet=0.3,
		TTSEcho=false, TTSEchoDelay=0.3, TTSEchoFeedback=0.2, TTSEchoWet=0.4,
		TTSDistortion=false, TTSDistLevel=0.2,
		TTSEQEnabled=false, TTSEQLow=0, TTSEQMid=0, TTSEQHigh=0,
		FocusEnabled=true, FocusKey=Enum.KeyCode.E, FocusInViewOnly=false, FocusLostThreshold=2.0,
		RagdollLimbsCollidable=true, RagdollOnExplosion=true, RagdollOnJerk=true, RagdollJerkThreshold=45,
		ProximityOffScreenMarker=true, ProximityMarkerStyle="diamond",
		NPCUseDefaultRig=false, NPCDefaultRigUserId=1,
		PingEnabled=false, PingRadius=40, PingShowMarker=true, PingScreenShake=0.3,
	}
end

local Cfg = _G.GH_Cfg

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [IV] STATE
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
do
	_G.GH_State = {
		CurrentSpeed=16, IsCrouching=false, MovementLocked=false,
		LastTilt=0, StepCycle=0, StepLock=false, StepShakeX=0, StepShakeY=0,
		OriginalC0=nil, JointRef=nil, LeanLerp=0, TiltLerp=0, LimpBias=0,
		IsRaging=false, RageValue=0, IsNervous=false,
		IsChargingSonar=false, SonarPower=0, SonarAmbient=false, SonarAmbientIntensity=0.5,
		Falling=false, LastFallY=0, LastVelocityY=0,
		IsDown=false, SpamCount=0, IsRagdolled=false,
		IsDead=false, IsGhost=false, GhostSpectateTarget=nil,
		IsUnconscious=false, UnconsTimer=0,
		ActiveTrack=nil, ActiveKey=nil, IdleAnimActive=false,
		HurtIdleTrack=nil, LastHurtTier=0, PenetrationConn=nil,
		ProximityConn=nil, ProximityMarkers={},
		FocusTarget=nil, FocusHighlight=nil, FocusLostTime=0, FocusPart=nil,
		LastRootVelocity=nil,
	}
end

local State = _G.GH_State

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [V] ANIMATION MANIFEST
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
do
	_G.GH_Anims = {
		Idle = {
			V1={"83570422520462","127972564618207"}, V2={"71483261700852","110099406570327"},
			V3={"83570422520462","127972564618207"}, Nervous={"135818607077529","135818607077529"},
			Rage={"85573078572941","85573078572941"}, Hurt1="140704739422954", Hurt2="91639463579692",
		},
		Walk = {
			V1={"122386479447449","80654091948859"}, V2={"124247546756708","136382802509224"},
			V3={"118959209918644","118959209918644"}, Nervous={"99498309796580","99498309796580"},
			Rage={"102622695004986","102622695004986"}, Hurt={"121570842511194","121570842511194"},
		},
		Run = {
			V1={"115765477049292","116881956670910"}, V2={"113952842957863","90634364448060"},
			V3={"115765477049292","116881956670910"}, Rage={"102622695004986","102622695004986"},
		},
		Crouch={"113780551991016","113780551991016"},
		RageTrigger="93919545288760", Knockout="138706623195970",
		Impalement="80955498493156", IdleRandom="80472053097767",
		M_Key={
			{id="84043660421785",name="Idle Shift 1"},{id="104049807204779",name="Idle Shift 2"},
			{id="103676484213316",name="Look Around"},{id="102838503369353",name="Shrug"},
			{id="136767849845319",name="Stretch"},{id="88105909185901",name="Lean Back"},
			{id="99069996966810",name="Crack Neck"},{id="126899447275562",name="Sit Down"},
			{id="83988109664343",name="Deep Breath"},{id="123822744060080",name="Look Behind"},
			{id="76149951852814",name="Arm Cross"},{id="86074172929360",name="Adjust Collar"},
			{id="120417779673859",name="Anim 13"},{id="119601626210532",name="Anim 14"},
			{id="118506636570113",name="Anim 15"},{id="113802991638240",name="Anim 16"},
		},
		O_Key={"80882536588409","82599509502243","123757916790042","116231343896505","82625726623732"},
		P_Key={"84516978579882","135023653330251"},
		I_Key={"93919545288760"},
		Jigs={"97086109091396","118362400960996","106534063593882","97246196405886",
			"87829410188996","117991470645633","78623817657515","78416657618448",
			"78796496757269","97500383729078"},
		Misc={Crash="112972344620357", Sit="85092320680319"},
	}
end

local Anims = _G.GH_Anims

-- Load saved M-anim names
local savedNames = xenoLoad()
if savedNames then
	for _, entry in ipairs(Anims.M_Key) do
		if savedNames[entry.id] then entry.name = savedNames[entry.id] end
	end
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [VI] VISUAL FX SETUP
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
do
	local FX = {}
	FX.Blur = Lighting:FindFirstChild("GH_Blur") or Instance.new("BlurEffect", Lighting)
	FX.Blur.Name = "GH_Blur"; FX.Blur.Size = 0
	FX.CC = Lighting:FindFirstChild("GH_CC") or Instance.new("ColorCorrectionEffect", Lighting)
	FX.CC.Name = "GH_CC"
	FX.Heartbeat = Camera:FindFirstChild("GH_HB") or Instance.new("Sound", Camera)
	FX.Heartbeat.Name = "GH_HB"
	FX.Heartbeat.SoundId = "rbxassetid://139459003161851"
	FX.Heartbeat.Looped = true; FX.Heartbeat.Volume = 0
	FX.Tinnitus = Camera:FindFirstChild("GH_TIN") or Instance.new("Sound", Camera)
	FX.Tinnitus.Name = "GH_TIN"
	FX.Tinnitus.SoundId = "rbxassetid://81860134951408"
	FX.Tinnitus.Looped = true; FX.Tinnitus.Volume = 0
	_G.GH_FX = FX
end

local FX = _G.GH_FX

-- Blood FX helpers (needed by S2 logic, defined here so S2 can reference via _G)
local function makeBloodEmitter(parent)
	local e = Instance.new("ParticleEmitter", parent)
	e.Name = "GH_Blood"
	e.Acceleration = Vector3.new(0,-35,0)
	e.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,     Color3.new(0.937,0.067,0.067)),
		ColorSequenceKeypoint.new(0.562, Color3.new(0.386,0.027,0.027)),
		ColorSequenceKeypoint.new(1,     Color3.new(0.333,0.024,0.024)),
	})
	e.Lifetime=NumberRange.new(0.35,0.8); e.LightEmission=0; e.LightInfluence=0.45
	e.LockedToPart=true; e.Orientation=Enum.ParticleOrientation.VelocityParallel
	e.Rate=0; e.RotSpeed=NumberRange.new(-5,5); e.Rotation=NumberRange.new(90,90)
	e.Size=NumberSequence.new({
		NumberSequenceKeypoint.new(0,0,0), NumberSequenceKeypoint.new(0.082,0.497,0.497),
		NumberSequenceKeypoint.new(0.371,0.166,0.166), NumberSequenceKeypoint.new(1,0,0),
	})
	e.Speed=NumberRange.new(8,18); e.SpreadAngle=Vector2.new(360,-360)
	e.Texture="rbxassetid://419625073"
	e.Transparency=NumberSequence.new({
		NumberSequenceKeypoint.new(0,0,0), NumberSequenceKeypoint.new(0.144,0.669,0.309),
		NumberSequenceKeypoint.new(1,0.762,0.237),
	})
	e.VelocityInheritance=0.15; e.ZOffset=-1
	return e
end

local function BloodBurst(part, count)
	if not Cfg.BloodParticlesEnabled then return end
	if not part or not part.Parent then return end
	local e = makeBloodEmitter(part)
	e:Emit(count or 40)
	Debris:AddItem(e, 2)
end

local function SpawnBloodPool(position, size)
	if not Cfg.BloodPoolsEnabled then return end
	local actualSize = math.clamp((size or 0.4), 0.05, Cfg.BloodPoolSize) * 0.012
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	local excluded = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr.Character then table.insert(excluded, plr.Character) end
	end
	rayParams.FilterDescendantsInstances = excluded
	local result = workspace:Raycast(position+Vector3.new(0,0.5,0), Vector3.new(0,-8,0), rayParams)
	if not result then return end
	local groundPos = result.Position; local groundNorm = result.Normal
	local cf = CFrame.new(groundPos, groundPos+groundNorm)
		* CFrame.Angles(math.pi/2, 0, math.random(0,628)/100)
	local pool = Instance.new("Part", workspace)
	pool.Name="GH_BloodPool"; pool.Anchored=true; pool.CanCollide=false
	pool.CastShadow=false; pool.Material=Enum.Material.SmoothPlastic
	pool.Color=Color3.fromRGB(90,8,8); pool.Size=Vector3.new(0.01,0.01,0.01); pool.CFrame=cf
	local mesh = Instance.new("SpecialMesh", pool)
	mesh.MeshId="rbxassetid://847989174"; mesh.Scale=Vector3.new(1,0.02,1)
	Tween:Create(pool, TweenInfo.new(1.0, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{Size=Vector3.new(actualSize,0.01,actualSize)}):Play()
	task.delay(45, function()
		if pool and pool.Parent then
			Tween:Create(pool, TweenInfo.new(6, Enum.EasingStyle.Sine, Enum.EasingDirection.In),
				{Size=Vector3.new(0.01,0.01,0.01)}):Play()
			task.delay(6, function() if pool and pool.Parent then pool:Destroy() end end)
		end
	end)
end

_G.GH_BloodBurst     = BloodBurst
_G.GH_SpawnBloodPool = SpawnBloodPool

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [VII] UI FOUNDATION
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
do
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "GhostHub_v33"; ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; ScreenGui.IgnoreGuiInset = true
	pcall(function() ScreenGui.Parent = Svc.CoreGui end)
	if not ScreenGui.Parent then ScreenGui.Parent = LP.PlayerGui end
	_G.GH_ScreenGui = ScreenGui
end

local ScreenGui = _G.GH_ScreenGui

-- Rage Bar
do
	local RageBarBG = Instance.new("Frame", ScreenGui)
	RageBarBG.Size=UDim2.new(0.3,0,0,18); RageBarBG.Position=UDim2.new(0.35,0,0.02,0)
	RageBarBG.BackgroundColor3=Color3.fromRGB(14,4,4); RageBarBG.BorderSizePixel=0
	Instance.new("UICorner",RageBarBG).CornerRadius=UDim.new(0,5)
	do local s=Instance.new("UIStroke",RageBarBG); s.Color=Color3.fromRGB(80,10,10); s.Thickness=1.5 end
	local RageFill=Instance.new("Frame",RageBarBG)
	RageFill.Size=UDim2.new(0,0,1,0); RageFill.BackgroundColor3=Color3.fromRGB(180,15,15); RageFill.BorderSizePixel=0
	Instance.new("UICorner",RageFill).CornerRadius=UDim.new(0,5)
	local RageLabel=Instance.new("TextLabel",RageBarBG)
	RageLabel.Size=UDim2.new(1,0,1,0); RageLabel.BackgroundTransparency=1
	RageLabel.Text="RAGE  0%"; RageLabel.TextColor3=Color3.fromRGB(255,200,200)
	RageLabel.Font=Enum.Font.GothamBold; RageLabel.TextSize=10; RageLabel.ZIndex=3
	_G.GH_RageBarBG=RageBarBG; _G.GH_RageFill=RageFill; _G.GH_RageLabel=RageLabel
end

-- Death Overlay
do
	local DeathOverlay=Instance.new("Frame",ScreenGui)
	DeathOverlay.Size=UDim2.new(1,0,1,0); DeathOverlay.BackgroundColor3=Color3.fromRGB(4,0,0)
	DeathOverlay.BackgroundTransparency=1; DeathOverlay.Visible=false; DeathOverlay.ZIndex=900
	local DeathVig=Instance.new("ImageLabel",DeathOverlay)
	DeathVig.Size=UDim2.new(1,0,1,0); DeathVig.BackgroundTransparency=1
	DeathVig.Image="rbxassetid://6901238617"; DeathVig.ImageColor3=Color3.fromRGB(80,0,0)
	DeathVig.ImageTransparency=0.3; DeathVig.ZIndex=901
	local DeathLine=Instance.new("Frame",DeathOverlay)
	DeathLine.Size=UDim2.new(0.5,0,0,1); DeathLine.Position=UDim2.new(0.25,0,0.48,0)
	DeathLine.BackgroundColor3=Color3.fromRGB(180,20,20); DeathLine.BorderSizePixel=0; DeathLine.ZIndex=902
	local DeathLabel=Instance.new("TextLabel",DeathOverlay)
	DeathLabel.Size=UDim2.new(1,0,0,70); DeathLabel.Position=UDim2.new(0,0,0.38,0)
	DeathLabel.BackgroundTransparency=1; DeathLabel.Text="SYSTEM FAILURE"
	DeathLabel.TextColor3=Color3.fromRGB(220,30,30); DeathLabel.Font=Enum.Font.GothamBold
	DeathLabel.TextSize=48; DeathLabel.ZIndex=902
	local DeathSub=Instance.new("TextLabel",DeathOverlay)
	DeathSub.Size=UDim2.new(1,0,0,22); DeathSub.Position=UDim2.new(0,0,0.51,0)
	DeathSub.BackgroundTransparency=1; DeathSub.Text=""
	DeathSub.TextColor3=Color3.fromRGB(130,60,60); DeathSub.Font=Enum.Font.GothamMedium
	DeathSub.TextSize=13; DeathSub.ZIndex=902
	local RebootBtn=Instance.new("TextButton",DeathOverlay)
	RebootBtn.Size=UDim2.new(0,200,0,42); RebootBtn.Position=UDim2.new(0.5,-100,0.57,0)
	RebootBtn.BackgroundColor3=Color3.fromRGB(160,15,15); RebootBtn.TextColor3=Color3.fromRGB(255,220,220)
	RebootBtn.Text="[ REBOOT SYSTEM ]"; RebootBtn.Font=Enum.Font.GothamBold
	RebootBtn.TextSize=13; RebootBtn.ZIndex=902; RebootBtn.BorderSizePixel=0
	Instance.new("UICorner",RebootBtn).CornerRadius=UDim.new(0,4)
	do local s=Instance.new("UIStroke",RebootBtn); s.Color=Color3.fromRGB(220,30,30); s.Thickness=1 end
	RebootBtn.MouseEnter:Connect(function() RebootBtn.BackgroundColor3=Color3.fromRGB(200,20,20) end)
	RebootBtn.MouseLeave:Connect(function() RebootBtn.BackgroundColor3=Color3.fromRGB(160,15,15) end)
	RebootBtn.MouseButton1Click:Connect(function()
		local S2State = _G.GH_State
		if S2State then S2State.IsGhost=false; S2State.IsDead=false end
		DeathOverlay.Visible=false; FX.Blur.Size=0
		Tween:Create(FX.CC, TweenInfo.new(1), {TintColor=Color3.new(1,1,1),Brightness=0,Contrast=0,Saturation=0}):Play()
		Camera.CameraType=Enum.CameraType.Custom
		local char=LP.Character
		if char then local hum=char:FindFirstChildOfClass("Humanoid"); if hum then hum.Health=0 end end
	end)
	local GhostHint=Instance.new("TextLabel",DeathOverlay)
	GhostHint.Size=UDim2.new(1,0,0,18); GhostHint.Position=UDim2.new(0,0,0.65,0)
	GhostHint.BackgroundTransparency=1; GhostHint.Text="Click a player to spectate · Click again to stop"
	GhostHint.TextColor3=Color3.fromRGB(100,60,60); GhostHint.Font=Enum.Font.GothamMedium
	GhostHint.TextSize=11; GhostHint.ZIndex=902
	_G.GH_DeathOverlay=DeathOverlay; _G.GH_DeathLabel=DeathLabel
	_G.GH_DeathSub=DeathSub; _G.GH_RebootBtn=RebootBtn; _G.GH_GhostHint=GhostHint
end

-- Unconscious Overlay
do
	local UnconsOverlay=Instance.new("Frame",ScreenGui)
	UnconsOverlay.Size=UDim2.new(1,0,1,0); UnconsOverlay.BackgroundColor3=Color3.new(0,0,0)
	UnconsOverlay.BackgroundTransparency=1; UnconsOverlay.Visible=false; UnconsOverlay.ZIndex=800
	local UnconsLabel=Instance.new("TextLabel",UnconsOverlay)
	UnconsLabel.Size=UDim2.new(1,0,0,30); UnconsLabel.Position=UDim2.new(0,0,0.5,-15)
	UnconsLabel.BackgroundTransparency=1; UnconsLabel.Text="UNCONSCIOUS"
	UnconsLabel.TextColor3=Color3.fromRGB(180,180,180); UnconsLabel.Font=Enum.Font.GothamMedium
	UnconsLabel.TextSize=18; UnconsLabel.ZIndex=801
	_G.GH_UnconsOverlay=UnconsOverlay; _G.GH_UnconsLabel=UnconsLabel
end

-- Blood Vignette
do
	local BloodVignette=Instance.new("ImageLabel",ScreenGui)
	BloodVignette.Size=UDim2.new(1,0,1,0); BloodVignette.BackgroundTransparency=1
	BloodVignette.Image="rbxassetid://6901238617"; BloodVignette.ImageColor3=Color3.fromRGB(180,0,0)
	BloodVignette.ImageTransparency=1; BloodVignette.ZIndex=10; BloodVignette.ScaleType=Enum.ScaleType.Stretch
	_G.GH_BloodVignette=BloodVignette
end

-- Injury HUD
do
	local InjuryHUD=Instance.new("Frame",ScreenGui)
	InjuryHUD.Size=UDim2.new(0,165,0,200); InjuryHUD.Position=UDim2.new(1,-175,0,60)
	InjuryHUD.BackgroundColor3=Color3.fromRGB(8,8,8); InjuryHUD.BackgroundTransparency=0.3
	InjuryHUD.BorderSizePixel=0; InjuryHUD.Visible=false; InjuryHUD.ClipsDescendants=true
	Instance.new("UICorner",InjuryHUD).CornerRadius=UDim.new(0,8)
	local InjuryScroll=Instance.new("ScrollingFrame",InjuryHUD)
	InjuryScroll.Size=UDim2.new(1,0,1,0); InjuryScroll.BackgroundTransparency=1
	InjuryScroll.ScrollBarThickness=2; InjuryScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
	InjuryScroll.CanvasSize=UDim2.new(0,0,0,0)
	local _il=Instance.new("UIListLayout",InjuryScroll); _il.Padding=UDim.new(0,2)
	Instance.new("UIPadding",InjuryScroll).PaddingTop=UDim.new(0,4)
	local _it=Instance.new("TextLabel",InjuryScroll)
	_it.LayoutOrder=0; _it.Size=UDim2.new(1,0,0,18); _it.BackgroundTransparency=1
	_it.Text="INJURIES"; _it.TextColor3=Color3.fromRGB(200,60,60)
	_it.Font=Enum.Font.GothamBold; _it.TextSize=11
	local InjuryIndicators={}
	local function makeIndicator(key,label)
		local row=Instance.new("TextLabel",InjuryScroll)
		row.LayoutOrder=#InjuryIndicators+1; row.Size=UDim2.new(1,-8,0,16)
		row.BackgroundTransparency=1; row.Text="○  "..label
		row.TextColor3=Color3.fromRGB(80,80,80); row.Font=Enum.Font.GothamMedium
		row.TextSize=10; row.TextXAlignment=Enum.TextXAlignment.Left
		InjuryIndicators[key]=row
	end
	makeIndicator("LeftLeg","Left Leg"); makeIndicator("RightLeg","Right Leg")
	makeIndicator("LeftArm","Left Arm"); makeIndicator("RightArm","Right Arm")
	makeIndicator("Bleeding","Bleeding"); makeIndicator("InternalBleed","Internal Bleed")
	makeIndicator("Concussion","Concussion"); makeIndicator("Burns","Burns")
	makeIndicator("Fracture","Fracture"); makeIndicator("Shrapnel","Shrapnel")
	makeIndicator("Unconscious","Unconscious")
	_G.GH_InjuryHUD=InjuryHUD; _G.GH_InjuryIndicators=InjuryIndicators
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [VIII] MAIN WINDOW + SIDEBAR
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
do
	local MainFrame=Instance.new("Frame",ScreenGui)
	MainFrame.Size=UDim2.new(0,750,0,540); MainFrame.Position=UDim2.new(0.5,-375,0.5,-270)
	MainFrame.BackgroundColor3=Color3.fromRGB(10,10,12); MainFrame.BorderSizePixel=0; MainFrame.Visible=true
	Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,12)
	do local s=Instance.new("UIStroke",MainFrame); s.Color=Color3.fromRGB(40,40,45); s.Thickness=1.5 end
	-- Drag
	do
		local dragging,dragStart,startPos
		MainFrame.InputBegan:Connect(function(inp)
			if inp.UserInputType==Enum.UserInputType.MouseButton1 then
				dragging=true; dragStart=inp.Position; startPos=MainFrame.Position
			end
		end)
		UIS.InputChanged:Connect(function(inp)
			if dragging and inp.UserInputType==Enum.UserInputType.MouseMovement then
				local d=inp.Position-dragStart
				MainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
			end
		end)
		UIS.InputEnded:Connect(function(inp)
			if inp.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
		end)
	end
	local Sidebar=Instance.new("Frame",MainFrame)
	Sidebar.Size=UDim2.new(0,185,1,0); Sidebar.BackgroundColor3=Color3.fromRGB(14,14,18); Sidebar.BorderSizePixel=0
	Instance.new("UICorner",Sidebar).CornerRadius=UDim.new(0,12)
	local SidebarTitle=Instance.new("TextLabel",Sidebar)
	SidebarTitle.Size=UDim2.new(1,0,0,44); SidebarTitle.BackgroundTransparency=1
	SidebarTitle.Text="GHOST HUB"; SidebarTitle.TextColor3=Color3.fromRGB(110,150,255)
	SidebarTitle.Font=Enum.Font.GothamBold; SidebarTitle.TextSize=17
	local SidebarSub=Instance.new("TextLabel",Sidebar)
	SidebarSub.Size=UDim2.new(1,0,0,14); SidebarSub.Position=UDim2.new(0,0,0,36)
	SidebarSub.BackgroundTransparency=1; SidebarSub.Text="DEFINITIVE  v33"
	SidebarSub.TextColor3=Color3.fromRGB(80,80,90); SidebarSub.Font=Enum.Font.GothamMedium; SidebarSub.TextSize=9
	local NavSearchFrame=Instance.new("Frame",Sidebar)
	NavSearchFrame.Size=UDim2.new(0.88,0,0,26); NavSearchFrame.Position=UDim2.new(0.06,0,0,56)
	NavSearchFrame.BackgroundColor3=Color3.fromRGB(22,22,30); NavSearchFrame.BorderSizePixel=0
	Instance.new("UICorner",NavSearchFrame).CornerRadius=UDim.new(0,5)
	do local s=Instance.new("UIStroke",NavSearchFrame); s.Color=Color3.fromRGB(50,50,65); s.Thickness=1 end
	local NavSearchBox=Instance.new("TextBox",NavSearchFrame)
	NavSearchBox.Size=UDim2.new(1,-8,1,0); NavSearchBox.Position=UDim2.new(0,6,0,0)
	NavSearchBox.BackgroundTransparency=1; NavSearchBox.PlaceholderText="search tabs..."
	NavSearchBox.PlaceholderColor3=Color3.fromRGB(70,70,80); NavSearchBox.Text=""
	NavSearchBox.TextColor3=Color3.fromRGB(200,200,220); NavSearchBox.Font=Enum.Font.GothamMedium
	NavSearchBox.TextSize=10; NavSearchBox.TextXAlignment=Enum.TextXAlignment.Left
	local NavScroll=Instance.new("ScrollingFrame",Sidebar)
	NavScroll.Size=UDim2.new(1,0,1,-90); NavScroll.Position=UDim2.new(0,0,0,90)
	NavScroll.BackgroundTransparency=1; NavScroll.ScrollBarThickness=3
	NavScroll.ScrollBarImageColor3=Color3.fromRGB(80,130,255)
	NavScroll.CanvasSize=UDim2.new(0,0,0,0); NavScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
	NavScroll.BorderSizePixel=0
	local NavContainer=Instance.new("Frame",NavScroll)
	NavContainer.Size=UDim2.new(1,0,0,0); NavContainer.AutomaticSize=Enum.AutomaticSize.Y
	NavContainer.BackgroundTransparency=1
	local NavLayout=Instance.new("UIListLayout",NavContainer)
	NavLayout.Padding=UDim.new(0,4); NavLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
	NavLayout.SortOrder=Enum.SortOrder.LayoutOrder
	Instance.new("UIPadding",NavContainer).PaddingTop=UDim.new(0,4)
	local ContentFrame=Instance.new("Frame",MainFrame)
	ContentFrame.Size=UDim2.new(1,-200,1,-20); ContentFrame.Position=UDim2.new(0,195,0,10)
	ContentFrame.BackgroundTransparency=1
	_G.GH_MainFrame=MainFrame; _G.GH_Sidebar=Sidebar
	_G.GH_NavSearchBox=NavSearchBox; _G.GH_NavScroll=NavScroll
	_G.GH_NavContainer=NavContainer; _G.GH_ContentFrame=ContentFrame
end

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [IX] UI COMPONENT FACTORY
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
do
	local Pages    = {}
	local NavBtns  = {}
	local navOrder = 0
	local elemOrder= 0

	local NavContainer  = _G.GH_NavContainer
	local ContentFrame  = _G.GH_ContentFrame
	local NavSearchBox  = _G.GH_NavSearchBox

	local function NextOrder() elemOrder+=1; return elemOrder end

	local function NewPage(name)
		local pg=Instance.new("ScrollingFrame",ContentFrame)
		pg.Size=UDim2.new(1,0,1,0); pg.BackgroundTransparency=1; pg.Visible=false
		pg.ScrollBarThickness=3; pg.ScrollBarImageColor3=Color3.fromRGB(80,130,255)
		pg.CanvasSize=UDim2.new(0,0,0,0); pg.AutomaticCanvasSize=Enum.AutomaticSize.Y
		local layout=Instance.new("UIListLayout",pg)
		layout.Padding=UDim.new(0,8); layout.SortOrder=Enum.SortOrder.LayoutOrder
		local pad=Instance.new("UIPadding",pg)
		pad.PaddingLeft=UDim.new(0,4); pad.PaddingRight=UDim.new(0,6)
		pad.PaddingTop=UDim.new(0,6); pad.PaddingBottom=UDim.new(0,10)
		Pages[name]=pg; return pg
	end

	local function ShowPage(name)
		for k,v in pairs(Pages) do v.Visible=(k==name) end
		for k,b in pairs(NavBtns) do
			local active=(k==name)
			b.TextColor3=active and Color3.new(1,1,1) or Color3.fromRGB(140,140,150)
			b.BackgroundColor3=active and Color3.fromRGB(40,80,200) or Color3.fromRGB(25,25,30)
			b.BackgroundTransparency=active and 0 or 0.5
		end
	end

	local function NavBtn(label, pageName)
		navOrder+=1
		local b=Instance.new("TextButton",NavContainer)
		b.LayoutOrder=navOrder; b.Size=UDim2.new(0.9,0,0,34)
		b.BackgroundColor3=Color3.fromRGB(25,25,30); b.BackgroundTransparency=0.5
		b.Text=label; b.TextColor3=Color3.fromRGB(140,140,150)
		b.Font=Enum.Font.GothamBold; b.TextSize=11
		b.MouseButton1Click:Connect(function() ShowPage(pageName) end)
		Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
		NavBtns[pageName]=b; return b
	end

	NavSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local q=NavSearchBox.Text:lower()
		for pageName,btn in pairs(NavBtns) do
			btn.Visible=(q=="" or pageName:lower():find(q,1,true)~=nil)
		end
	end)

	local function Header(txt,parent)
		local f=Instance.new("Frame",parent); f.LayoutOrder=NextOrder()
		f.Size=UDim2.new(1,0,0,24); f.BackgroundColor3=Color3.fromRGB(18,18,28); f.BorderSizePixel=0
		Instance.new("UICorner",f).CornerRadius=UDim.new(0,4)
		local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,-10,1,0); l.Position=UDim2.new(0,8,0,0)
		l.BackgroundTransparency=1; l.Text=txt:upper(); l.TextColor3=Color3.fromRGB(100,140,255)
		l.Font=Enum.Font.GothamBold; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left
		return f
	end

	local function Btn(txt,cb,parent)
		local b=Instance.new("TextButton",parent); b.LayoutOrder=NextOrder()
		b.Size=UDim2.new(1,0,0,32); b.BackgroundColor3=Color3.fromRGB(22,22,28); b.BorderSizePixel=0
		b.Text=txt; b.TextColor3=Color3.fromRGB(210,210,210); b.Font=Enum.Font.GothamMedium; b.TextSize=12
		Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
		do local s=Instance.new("UIStroke",b); s.Color=Color3.fromRGB(40,40,50); s.Thickness=1 end
		b.MouseEnter:Connect(function() b.BackgroundColor3=Color3.fromRGB(32,32,42) end)
		b.MouseLeave:Connect(function() b.BackgroundColor3=Color3.fromRGB(22,22,28) end)
		b.MouseButton1Click:Connect(cb); return b
	end

	local function Slider(txt,min,max,def,cb,parent,isInt)
		local c=Instance.new("Frame",parent); c.LayoutOrder=NextOrder()
		c.Size=UDim2.new(1,0,0,52); c.BackgroundTransparency=1
		local function fmt(v) return isInt and math.floor(v) or math.floor(v*10)/10 end
		local lbl=Instance.new("TextLabel",c); lbl.Size=UDim2.new(1,0,0,18)
		lbl.BackgroundTransparency=1; lbl.Text=txt..":  "..fmt(def)
		lbl.TextColor3=Color3.fromRGB(180,180,190); lbl.Font=Enum.Font.GothamMedium
		lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
		local track=Instance.new("Frame",c); track.Size=UDim2.new(1,0,0,7)
		track.Position=UDim2.new(0,0,0,28); track.BackgroundColor3=Color3.fromRGB(35,35,42); track.BorderSizePixel=0
		Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
		local fill=Instance.new("Frame",track); fill.Size=UDim2.new((def-min)/(max-min),0,1,0)
		fill.BackgroundColor3=Color3.fromRGB(80,140,255); fill.BorderSizePixel=0
		Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)
		local knob=Instance.new("Frame",track); knob.Size=UDim2.new(0,13,0,13)
		knob.AnchorPoint=Vector2.new(0.5,0.5); knob.Position=UDim2.new((def-min)/(max-min),0,0.5,0)
		knob.BackgroundColor3=Color3.new(1,1,1); knob.BorderSizePixel=0
		Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
		local function applyDrag()
			local rc,ic
			rc=Run.RenderStepped:Connect(function()
				local rel=math.clamp((UIS:GetMouseLocation().X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1)
				local val=min+rel*(max-min)
				fill.Size=UDim2.new(rel,0,1,0); knob.Position=UDim2.new(rel,0,0.5,0)
				lbl.Text=txt..":  "..fmt(val); cb(val)
			end)
			ic=UIS.InputEnded:Connect(function(inp)
				if inp.UserInputType==Enum.UserInputType.MouseButton1 then rc:Disconnect(); ic:Disconnect() end
			end)
		end
		track.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then applyDrag() end end)
		knob.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then applyDrag() end end)
		return c
	end

	local function Toggle(txt,initVal,cb,parent)
		local row=Instance.new("Frame",parent); row.LayoutOrder=NextOrder()
		row.Size=UDim2.new(1,0,0,32); row.BackgroundTransparency=1
		local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(0.72,0,1,0)
		lbl.BackgroundTransparency=1; lbl.Text=txt; lbl.TextColor3=Color3.fromRGB(200,200,210)
		lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
		local tstate=initVal
		local tbtn=Instance.new("TextButton",row); tbtn.Size=UDim2.new(0,52,0,24)
		tbtn.Position=UDim2.new(1,-52,0.5,-12); tbtn.Text=tstate and "ON" or "OFF"
		tbtn.BackgroundColor3=tstate and Color3.fromRGB(40,160,80) or Color3.fromRGB(90,30,30)
		tbtn.TextColor3=Color3.new(1,1,1); tbtn.Font=Enum.Font.GothamBold; tbtn.TextSize=11; tbtn.BorderSizePixel=0
		Instance.new("UICorner",tbtn).CornerRadius=UDim.new(0,4)
		tbtn.MouseButton1Click:Connect(function()
			tstate=not tstate; tbtn.Text=tstate and "ON" or "OFF"
			tbtn.BackgroundColor3=tstate and Color3.fromRGB(40,160,80) or Color3.fromRGB(90,30,30)
			cb(tstate)
		end)
		return row
	end

	local function TextInput(placeholder,parent,onSubmit)
		local f=Instance.new("Frame",parent); f.LayoutOrder=NextOrder()
		f.Size=UDim2.new(1,0,0,34); f.BackgroundColor3=Color3.fromRGB(18,18,24); f.BorderSizePixel=0
		Instance.new("UICorner",f).CornerRadius=UDim.new(0,5)
		local tb=Instance.new("TextBox",f); tb.Size=UDim2.new(1,-10,1,0); tb.Position=UDim2.new(0,6,0,0)
		tb.BackgroundTransparency=1; tb.PlaceholderText=placeholder; tb.Text=""
		tb.TextColor3=Color3.new(1,1,1); tb.PlaceholderColor3=Color3.fromRGB(100,100,100)
		tb.Font=Enum.Font.GothamMedium; tb.TextSize=12; tb.TextXAlignment=Enum.TextXAlignment.Left
		tb.FocusLost:Connect(function(enter) if enter then onSubmit(tb.Text) end end)
		return f, tb
	end

	-- Expose all factory functions via _G
	_G.GH_Pages      = Pages
	_G.GH_NavBtns    = NavBtns
	_G.GH_NextOrder  = NextOrder
	_G.GH_NewPage    = NewPage
	_G.GH_ShowPage   = ShowPage
	_G.GH_NavBtn     = NavBtn
	_G.GH_Header     = Header
	_G.GH_Btn        = Btn
	_G.GH_Slider     = Slider
	_G.GH_Toggle     = Toggle
	_G.GH_TextInput  = TextInput
end

print("[GH S1] Core loaded — run S2 next")

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

--[[
╔══════════════════════════════════════════════════════════════════════════╗
║         GHOST HUB TITAN — DEFINITIVE EDITION (v33.0)                    ║
║         SCRIPT 3 / 3  —  UI PAGES + BOOTSTRAP                          ║
║         Run AFTER S1 and S2.                                             ║
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

local Cfg             = _G.GH_Cfg
local State           = _G.GH_State
local Anims           = _G.GH_Anims
local FX              = _G.GH_FX
local ScreenGui       = _G.GH_ScreenGui
local CFG_SAVE_FILE   = _G.GH_CFG_SAVE_FILE

-- UI factories
local NewPage    = _G.GH_NewPage
local ShowPage   = _G.GH_ShowPage
local NavBtn     = _G.GH_NavBtn
local Header     = _G.GH_Header
local Btn        = _G.GH_Btn
local Slider     = _G.GH_Slider
local Toggle     = _G.GH_Toggle
local TextInput  = _G.GH_TextInput
local NextOrder  = _G.GH_NextOrder

-- Systems
local ApplyAnims             = _G.GH_ApplyAnims
local SetRagdoll             = _G.GH_SetRagdoll
local SetRage                = _G.GH_SetRage
local AddRage                = _G.GH_AddRage
local DoSonarPing            = _G.GH_DoSonarPing
local DoPingEffect           = _G.GH_DoPingEffect
local Knockout               = _G.GH_Knockout
local WakeUp                 = _G.GH_WakeUp
local ApplyInjury            = _G.GH_ApplyInjury
local ClearInjuries          = _G.GH_ClearInjuries
local MakeExplosion          = _G.GH_MakeExplosion
local SetupPenetrationDetection = _G.GH_SetupPenetrationDetection
local ClearProximityFX       = _G.GH_ClearProximityFX
local SpawnNPC               = _G.GH_SpawnNPC
local NPCList                = _G.GH_NPCList
local SpawnedObjects         = _G.GH_SpawnedObjects
local GetHumDesc             = _G.GH_GetHumDesc
local ApplyDesc              = _G.GH_ApplyDesc
local ApplyScale             = _G.GH_ApplyScale
local CatalogSearch          = _G.GH_CatalogSearch
local AvatarState            = _G.GH_AvatarState
local Injuries               = _G.GH_Injuries
local ClearFocus             = _G.GH_ClearFocus
local GetAmbientSound        = _G.GH_GetAmbientSound
local GetOrCreateAmbientEffect = _G.GH_GetOrCreateAmbientEffect
local AmbientEffects         = _G.GH_AmbientEffects
local xenoSave               = _G.GH_xenoSave
local GetScale               = _G.GH_GetScale
local GetAnimator            = _G.GH_GetAnimator
local PlayKeybindAnim        = _G.GH_PlayKeybindAnim
local StopGhostCam           = _G.GH_StopGhostCam
local DeathOverlay           = _G.GH_DeathOverlay
local BloodVignette          = _G.GH_BloodVignette
local UnconsOverlay          = _G.GH_UnconsOverlay

-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
-- [XXIV] UI PAGES
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- ── FRIEND TREE OVERLAY ───────────────────────────────────────────────
local TreeOverlay=Instance.new("Frame",ScreenGui)
TreeOverlay.Size=UDim2.new(1,0,1,0); TreeOverlay.BackgroundColor3=Color3.fromRGB(12,12,16)
TreeOverlay.BackgroundTransparency=0.05; TreeOverlay.Visible=false; TreeOverlay.ZIndex=500

local TreeCloseBtn=Instance.new("TextButton",TreeOverlay)
TreeCloseBtn.Size=UDim2.new(0,90,0,30); TreeCloseBtn.Position=UDim2.new(1,-100,0,10)
TreeCloseBtn.Text="✕  CLOSE"; TreeCloseBtn.BackgroundColor3=Color3.fromRGB(80,20,20)
TreeCloseBtn.TextColor3=Color3.new(1,1,1); TreeCloseBtn.Font=Enum.Font.GothamBold
TreeCloseBtn.TextSize=12; TreeCloseBtn.BorderSizePixel=0; TreeCloseBtn.ZIndex=501
Instance.new("UICorner",TreeCloseBtn).CornerRadius=UDim.new(0,5)
TreeCloseBtn.MouseButton1Click:Connect(function() TreeOverlay.Visible=false; UIS.MouseBehavior=Enum.MouseBehavior.Default end)

local TreeTitle=Instance.new("TextLabel",TreeOverlay)
TreeTitle.Size=UDim2.new(0,400,0,30); TreeTitle.Position=UDim2.new(0,16,0,10)
TreeTitle.BackgroundTransparency=1; TreeTitle.Text="FRIEND TREE"
TreeTitle.TextColor3=Color3.fromRGB(110,150,255); TreeTitle.Font=Enum.Font.GothamBold
TreeTitle.TextSize=16; TreeTitle.TextXAlignment=Enum.TextXAlignment.Left; TreeTitle.ZIndex=501

local TreeViewport=Instance.new("Frame",TreeOverlay)
TreeViewport.Size=UDim2.new(1,0,1,-50); TreeViewport.Position=UDim2.new(0,0,0,50)
TreeViewport.BackgroundTransparency=1; TreeViewport.ClipsDescendants=true; TreeViewport.ZIndex=500

local TreeGrid=Instance.new("Frame",TreeViewport)
TreeGrid.Size=UDim2.new(1,0,1,0); TreeGrid.BackgroundColor3=Color3.fromRGB(16,16,22)
TreeGrid.BorderSizePixel=0; TreeGrid.ZIndex=500
for i=0,30 do
	local hLine=Instance.new("Frame",TreeGrid); hLine.Size=UDim2.new(1,0,0,1); hLine.Position=UDim2.new(0,0,0,i*50)
	hLine.BackgroundColor3=Color3.fromRGB(28,28,38); hLine.BorderSizePixel=0; hLine.ZIndex=500
	local vLine=Instance.new("Frame",TreeGrid); vLine.Size=UDim2.new(0,1,1,0); vLine.Position=UDim2.new(0,i*50,0,0)
	vLine.BackgroundColor3=Color3.fromRGB(28,28,38); vLine.BorderSizePixel=0; vLine.ZIndex=500
end

local TreeCanvas=Instance.new("Frame",TreeViewport)
TreeCanvas.Size=UDim2.new(0,4000,0,4000); TreeCanvas.Position=UDim2.new(0,-1800,0,-1800)
TreeCanvas.BackgroundTransparency=1; TreeCanvas.ZIndex=501

local treeDragging,treeDragStart,treeCanvasStart=false,nil,nil
TreeViewport.InputBegan:Connect(function(inp)
	if inp.UserInputType==Enum.UserInputType.MouseButton2 then
		treeDragging=true; treeDragStart=Vector2.new(inp.Position.X,inp.Position.Y); treeCanvasStart=TreeCanvas.Position
	end
end)
UIS.InputChanged:Connect(function(inp)
	if treeDragging and inp.UserInputType==Enum.UserInputType.MouseMovement then
		local delta=Vector2.new(inp.Position.X,inp.Position.Y)-treeDragStart
		TreeCanvas.Position=UDim2.new(treeCanvasStart.X.Scale,treeCanvasStart.X.Offset+delta.X,treeCanvasStart.Y.Scale,treeCanvasStart.Y.Offset+delta.Y)
	end
end)
UIS.InputEnded:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton2 then treeDragging=false end end)

-- Node popup
local NodePopup=Instance.new("Frame",TreeOverlay)
NodePopup.Size=UDim2.new(0,200,0,160); NodePopup.BackgroundColor3=Color3.fromRGB(18,18,28)
NodePopup.BorderSizePixel=0; NodePopup.Visible=false; NodePopup.ZIndex=600
Instance.new("UICorner",NodePopup).CornerRadius=UDim.new(0,8)
do local s=Instance.new("UIStroke",NodePopup); s.Color=Color3.fromRGB(60,80,200); s.Thickness=1.5 end
local PopupName=Instance.new("TextLabel",NodePopup)
PopupName.Size=UDim2.new(1,-10,0,28); PopupName.Position=UDim2.new(0,8,0,6); PopupName.BackgroundTransparency=1
PopupName.TextColor3=Color3.fromRGB(200,210,255); PopupName.Font=Enum.Font.GothamBold; PopupName.TextSize=13
PopupName.TextXAlignment=Enum.TextXAlignment.Left; PopupName.ZIndex=601
local PopupId=Instance.new("TextLabel",NodePopup)
PopupId.Size=UDim2.new(1,-10,0,16); PopupId.Position=UDim2.new(0,8,0,30); PopupId.BackgroundTransparency=1
PopupId.TextColor3=Color3.fromRGB(90,90,110); PopupId.Font=Enum.Font.GothamMedium; PopupId.TextSize=10
PopupId.TextXAlignment=Enum.TextXAlignment.Left; PopupId.ZIndex=601

local popupActionDefs={{label="Expand Friends",key="expand"},{label="Spawn as NPC",key="spawn"},{label="Wear their Look",key="wear"},{label="Copy User ID",key="copy"}}
local popupBtns={}
for i,action in ipairs(popupActionDefs) do
	local pb=Instance.new("TextButton",NodePopup)
	pb.Size=UDim2.new(1,-16,0,24); pb.Position=UDim2.new(0,8,0,48+(i-1)*26)
	pb.BackgroundColor3=Color3.fromRGB(28,28,40); pb.TextColor3=Color3.fromRGB(190,200,255)
	pb.Font=Enum.Font.GothamMedium; pb.TextSize=11; pb.Text=action.label; pb.BorderSizePixel=0; pb.ZIndex=602
	Instance.new("UICorner",pb).CornerRadius=UDim.new(0,4)
	pb.MouseEnter:Connect(function() pb.BackgroundColor3=Color3.fromRGB(40,50,90) end)
	pb.MouseLeave:Connect(function() pb.BackgroundColor3=Color3.fromRGB(28,28,40) end)
	popupBtns[action.key]=pb
end
local activePopupUserId,activePopupNode=nil,nil
local function ClosePopup() NodePopup.Visible=false; activePopupUserId=nil; activePopupNode=nil end
local function OpenPopup(userId,displayName,screenX,screenY,nodeRef)
	activePopupUserId=userId; activePopupNode=nodeRef; PopupName.Text=displayName; PopupId.Text="ID: "..tostring(userId)
	local vp=Camera.ViewportSize
	NodePopup.Position=UDim2.new(0,math.clamp(screenX,0,vp.X-210),0,math.clamp(screenY,50,vp.Y-170))
	NodePopup.Visible=true
end
TreeViewport.InputBegan:Connect(function(inp) if inp.UserInputType==Enum.UserInputType.MouseButton1 then ClosePopup() end end)

popupBtns["spawn"].MouseButton1Click:Connect(function()
	if not activePopupUserId then return end
	local uid=activePopupUserId; ClosePopup()
	Cfg.NPCUseDefaultRig=true; Cfg.NPCDefaultRigUserId=uid
	SpawnNPC("Neutral",16); Cfg.NPCUseDefaultRig=false
end)
popupBtns["wear"].MouseButton1Click:Connect(function()
	if not activePopupUserId then return end
	local uid=activePopupUserId; ClosePopup()
	task.spawn(function() local ok,desc=pcall(function() return Players:GetHumanoidDescriptionFromUserId(uid) end); if ok and desc then ApplyDesc(desc) end end)
end)
popupBtns["copy"].MouseButton1Click:Connect(function()
	if not activePopupUserId then return end
	print("[GH Friend Tree] User ID:",activePopupUserId)
	popupBtns["copy"].Text="Copied! (see output)"; task.delay(2,function() popupBtns["copy"].Text="Copy User ID" end); ClosePopup()
end)

-- Tree builder
local treeNodes={}
local function ClearTree() for _,n in ipairs(treeNodes) do pcall(function() n:Destroy() end) end; treeNodes={} end
local function DrawLine(x0,y0,x1,y1)
	local dx=x1-x0; local dy=y1-y0; local length=math.sqrt(dx*dx+dy*dy); local angle=math.deg(math.atan2(dy,dx))
	local line=Instance.new("Frame",TreeCanvas)
	line.Size=UDim2.new(0,length,0,2); line.Position=UDim2.new(0,(x0+x1)/2-length/2,0,(y0+y1)/2-1)
	line.Rotation=angle; line.BackgroundColor3=Color3.fromRGB(60,70,120); line.BorderSizePixel=0; line.ZIndex=502
	table.insert(treeNodes,line); return line
end
local NODE_SIZE=70; local DEPTH_GAP=160; local SIBLING_GAP=100
local function MakeNode(userId,displayName,cx,cy,depth)
	local nodeFrame=Instance.new("Frame",TreeCanvas)
	nodeFrame.Size=UDim2.new(0,NODE_SIZE,0,NODE_SIZE); nodeFrame.Position=UDim2.new(0,cx-NODE_SIZE/2,0,cy-NODE_SIZE/2)
	nodeFrame.BackgroundColor3=Color3.fromRGB(20,20,32); nodeFrame.BorderSizePixel=0; nodeFrame.ZIndex=503
	Instance.new("UICorner",nodeFrame).CornerRadius=UDim.new(1,0)
	do local s=Instance.new("UIStroke",nodeFrame)
		s.Color=depth==0 and Color3.fromRGB(110,150,255) or depth==1 and Color3.fromRGB(80,120,200) or Color3.fromRGB(50,70,130)
		s.Thickness=depth==0 and 2.5 or 1.5
	end
	local img=Instance.new("ImageLabel",nodeFrame); img.Size=UDim2.new(1,-8,1,-8); img.Position=UDim2.new(0,4,0,4)
	img.BackgroundTransparency=1; img.ZIndex=504; Instance.new("UICorner",img).CornerRadius=UDim.new(1,0)
	task.spawn(function()
		local ok,url=pcall(function() return Players:GetUserThumbnailAsync(userId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size100x100) end)
		if ok then img.Image=url end
	end)
	local lbl=Instance.new("TextLabel",TreeCanvas); lbl.Size=UDim2.new(0,120,0,18)
	lbl.Position=UDim2.new(0,cx-60,0,cy+NODE_SIZE/2+4); lbl.BackgroundTransparency=1; lbl.Text=displayName
	lbl.TextColor3=Color3.fromRGB(180,190,220); lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=10; lbl.ZIndex=503
	table.insert(treeNodes,lbl)
	local clickBtn=Instance.new("TextButton",nodeFrame); clickBtn.Size=UDim2.new(1,0,1,0)
	clickBtn.BackgroundTransparency=1; clickBtn.Text=""; clickBtn.ZIndex=505
	clickBtn.MouseButton1Click:Connect(function()
		local absPos=nodeFrame.AbsolutePosition; OpenPopup(userId,displayName,absPos.X+NODE_SIZE+8,absPos.Y,nodeFrame)
	end)
	table.insert(treeNodes,nodeFrame); return nodeFrame
end

local function BuildFriendTree(rootUserId)
	ClearTree(); TreeTitle.Text="FRIEND TREE  —  loading..."
	task.spawn(function()
		local rootName="Player"
		pcall(function() rootName=Players:GetNameFromUserIdAsync(rootUserId) end)
		TreeTitle.Text="FRIEND TREE  —  "..rootName
		local centerX=2000; local centerY=300
		MakeNode(rootUserId,rootName,centerX,centerY,0)
		local ok,pages=pcall(function() return Players:GetFriendsAsync(rootUserId) end)
		if not ok then TreeTitle.Text="FRIEND TREE  —  failed to load friends"; return end
		local friends={}
		while true do
			local page=pages:GetCurrentPage()
			for _,info in ipairs(page) do table.insert(friends,info); if #friends>=20 then break end end
			if pages.IsFinished or #friends>=20 then break end
			pages:AdvanceToNextPageAsync()
		end
		local count=#friends
		for i,friendInfo in ipairs(friends) do
			local fx=(count==1) and centerX or (centerX-(count-1)*SIBLING_GAP/2+(i-1)*SIBLING_GAP)
			local fy=centerY+DEPTH_GAP
			DrawLine(centerX,centerY+NODE_SIZE/2,fx,fy-NODE_SIZE/2)
			MakeNode(friendInfo.Id,friendInfo.DisplayName,fx,fy,1)
			popupBtns["expand"].MouseButton1Click:Connect(function()
				if activePopupUserId~=friendInfo.Id then return end; ClosePopup()
				task.spawn(function()
					local ok2,pages2=pcall(function() return Players:GetFriendsAsync(friendInfo.Id) end); if not ok2 then return end
					local sub={}
					while true do
						local pg=pages2:GetCurrentPage()
						for _,inf in ipairs(pg) do table.insert(sub,inf); if #sub>=10 then break end end
						if pages2.IsFinished or #sub>=10 then break end
						pages2:AdvanceToNextPageAsync()
					end
					for j,subInfo in ipairs(sub) do
						local sx=fx-(#sub-1)*60/2+(j-1)*60; local sy=fy+DEPTH_GAP
						DrawLine(fx,fy+NODE_SIZE/2,sx,sy-NODE_SIZE/2)
						MakeNode(subInfo.Id,subInfo.DisplayName,sx,sy,2)
					end
				end)
			end)
		end
	end)
end

-- ── PLAYER SEARCH ─────────────────────────────────────────────────────
local pgPlayerSearch=NewPage("PlayerSearch"); NavBtn("PLAYER SEARCH","PlayerSearch")
Header("Search Any Player",pgPlayerSearch)
local _,psSearchBox=TextInput("Username or User ID...",pgPlayerSearch,function() end)
Btn("🔍  Open Friend Tree",function()
	if not psSearchBox or psSearchBox.Text=="" then return end
	local query=psSearchBox.Text
	task.spawn(function()
		local userId=tonumber(query)
		if not userId then local ok,id=pcall(function() return Players:GetUserIdFromNameAsync(query) end); if not ok then return end; userId=id end
		TreeOverlay.Visible=true; BuildFriendTree(userId)
	end)
end,pgPlayerSearch)
Btn("🏠  My Own Friend Tree",function() TreeOverlay.Visible=true; BuildFriendTree(LP.UserId) end,pgPlayerSearch)
Header("In-Server Players",pgPlayerSearch)
local psInServerFrame=Instance.new("Frame",pgPlayerSearch); psInServerFrame.LayoutOrder=NextOrder()
psInServerFrame.Size=UDim2.new(1,0,0,0); psInServerFrame.AutomaticSize=Enum.AutomaticSize.Y; psInServerFrame.BackgroundTransparency=1
Instance.new("UIListLayout",psInServerFrame).Padding=UDim.new(0,4)
local function RefreshPSInServer()
	for _,c in ipairs(psInServerFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
	for _,plr in ipairs(Players:GetPlayers()) do
		local b=Instance.new("TextButton",psInServerFrame)
		b.Size=UDim2.new(1,0,0,30); b.BackgroundColor3=Color3.fromRGB(22,22,28)
		b.TextColor3=Color3.fromRGB(200,200,210); b.Text=plr.Name..(plr==LP and "  (you)" or "")
		b.Font=Enum.Font.GothamMedium; b.TextSize=11; b.BorderSizePixel=0
		Instance.new("UICorner",b).CornerRadius=UDim.new(0,5)
		b.MouseButton1Click:Connect(function() TreeOverlay.Visible=true; BuildFriendTree(plr.UserId) end)
	end
end
RefreshPSInServer()
Btn("↺  Refresh",function() RefreshPSInServer() end,pgPlayerSearch)

-- ── OVERVIEW ─────────────────────────────────────────────────────────
local pgOverview=NewPage("Overview"); NavBtn("OVERVIEW","Overview")
Header("Variant & Source",pgOverview)
for _,v in ipairs({"V1","V2","V3"}) do Btn("Set Variant: "..v,function() Cfg.Variant=v; ApplyAnims() end,pgOverview) end
Btn("Source: Main / Alt",function() Cfg.Source=(Cfg.Source=="Main") and "Alt" or "Main"; ApplyAnims() end,pgOverview)
Header("Quick Actions",pgOverview)
Btn("Reload Animations",function() ApplyAnims() end,pgOverview)
Btn("Stop Keybind Anim",function() if State.ActiveTrack then State.ActiveTrack:Stop(0.2) end; State.ActiveTrack=nil; State.ActiveKey=nil end,pgOverview)
Btn("Clear All FX",function()
	FX.Blur.Size=0; FX.CC.Brightness=0; FX.CC.Contrast=0; FX.CC.Saturation=0
	FX.CC.TintColor=Color3.new(1,1,1); FX.Heartbeat:Stop(); FX.Tinnitus:Stop()
end,pgOverview)
Btn("Respawn",function() LP:LoadCharacter() end,pgOverview)
Btn("Toggle Proximity FX",function() Cfg.ProximityEnabled=not Cfg.ProximityEnabled end,pgOverview)

-- ── MOVEMENT ─────────────────────────────────────────────────────────
local pgMovement=NewPage("Movement"); NavBtn("MOVEMENT","Movement")
Header("Speeds",pgMovement)
Slider("Walk Speed",5,150,16,function(v) Cfg.NormalSpeed=v end,pgMovement,true)
Slider("Sprint Speed",5,300,26,function(v) Cfg.SprintSpeed=v end,pgMovement,true)
Slider("Crouch Speed",1,80,10,function(v) Cfg.CrouchSpeed=v end,pgMovement,true)
Slider("Jump Power",0,250,50,function(v) Cfg.JumpPower=v end,pgMovement,true)
Slider("Gravity",10,1000,196.2,function(v) Cfg.Gravity=v end,pgMovement,false)
Slider("Speed Smooth",1,25,10,function(v) Cfg.SpeedSmooth=v end,pgMovement,false)
Header("Fall Damage",pgMovement)
Toggle("Fall Damage",true,function(v) Cfg.FallDamageEnabled=v end,pgMovement)
Toggle("Spam-Space Getup",true,function(v) Cfg.SpamToGetUp=v end,pgMovement)
Slider("Min Fall Height",5,100,25,function(v) Cfg.MinFallHeight=v end,pgMovement,true)

-- ── HEALTH ────────────────────────────────────────────────────────────
local pgHealth=NewPage("Health"); NavBtn("HEALTH","Health")
Header("Max Health",pgHealth)
Slider("Max HP",100,10000,100,function(v)
	Cfg.MaxHealth=v; task.spawn(function()
		local c=LP.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); if not h then return end
		h.MaxHealth=v; task.wait(); h.Health=v
	end)
end,pgHealth,true)
Header("Set Health",pgHealth)
Btn("Heal to Full",function() task.spawn(function() local c=LP.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); if not h then return end; h.MaxHealth=Cfg.MaxHealth; task.wait(); h.Health=h.MaxHealth end) end,pgHealth)
for _,pct in ipairs({75,50,25,10}) do
	Btn("Set HP: "..pct.."%",function() task.spawn(function() local c=LP.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); if not h then return end; h.MaxHealth=Cfg.MaxHealth; task.wait(); h.Health=h.MaxHealth*(pct/100) end) end,pgHealth)
end
Slider("Custom HP %",1,100,100,function(v) task.spawn(function() local c=LP.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); if not h then return end; h.MaxHealth=Cfg.MaxHealth; task.wait(); h.Health=h.MaxHealth*(v/100) end) end,pgHealth,true)
Header("Accelerated Healing",pgHealth)
Toggle("Regen Enabled",false,function(v) if not v then Cfg.RegenRate=0 end end,pgHealth)
Slider("Regen % MaxHP/sec",0.1,10,1,function(v) Cfg.RegenRate=v end,pgHealth,false)
Header("Durability",pgHealth)
Toggle("Durability (25% dmg)",false,function(v) Cfg.DurabilityMult=v and 0.25 or 1.0 end,pgHealth)
Slider("Damage Multiplier",0.05,2,1,function(v) Cfg.DurabilityMult=v end,pgHealth,false)
Header("Permadeath",pgHealth)
Toggle("Permadeath Enabled",false,function(v) Cfg.PermadeathEnabled=v end,pgHealth)
Toggle("Ghost on Death",true,function(v) Cfg.GhostOnDeath=v end,pgHealth)

-- ── VISUALS ───────────────────────────────────────────────────────────
local pgVisuals=NewPage("Visuals"); NavBtn("VISUALS","Visuals")
Header("Camera",pgVisuals)
Slider("Lean Intensity",0,50,15,function(v) Cfg.LeanIntensity=v end,pgVisuals,false)
Slider("Camera Tilt",0,30,8,function(v) Cfg.CamTilt=v end,pgVisuals,false)
Slider("Cam Smoothing",1,20,8,function(v) Cfg.CamSmooth=v end,pgVisuals,false)
Slider("Bob Intensity",0,5,0.3,function(v) Cfg.CamBob=v end,pgVisuals,false)
Slider("Base FOV",30,120,75,function(v) Cfg.FOV=v end,pgVisuals,true)
Header("Footsteps",pgVisuals)
Toggle("Weight System",true,function(v) Cfg.WeightEnabled=v end,pgVisuals)
Slider("Step Volume",0,3,0.6,function(v) Cfg.StepVolume=v end,pgVisuals,false)
Slider("Step Shake",0,5,0.4,function(v) Cfg.StepShake=v end,pgVisuals,false)
Slider("Stride Freq",0.1,2,0.4,function(v) Cfg.StrideFreq=v end,pgVisuals,false)
Header("Health Visuals",pgVisuals)
Toggle("Health Visuals",true,function(v) Cfg.HealthVisualsEnabled=v end,pgVisuals)
Header("Lighting",pgVisuals)
Btn("Apply Bloom",function() local b=Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect",Lighting); b.Intensity=0.8; b.Size=24; b.Threshold=0.95 end,pgVisuals)
Btn("Remove Bloom",function() local b=Lighting:FindFirstChildOfClass("BloomEffect"); if b then b:Destroy() end end,pgVisuals)
Btn("Day (14:00)",function() Lighting.ClockTime=14 end,pgVisuals)
Btn("Night (0:00)",function() Lighting.ClockTime=0 end,pgVisuals)
Btn("Reset Lighting",function() Lighting.Brightness=2; Lighting.OutdoorAmbient=Color3.new(0.5,0.5,0.5); Lighting.Ambient=Color3.new(0,0,0) end,pgVisuals)

-- ── STATES ────────────────────────────────────────────────────────────
local pgStates=NewPage("States"); NavBtn("STATES","States")
Header("Rage",pgStates)
Toggle("Rage Mode",false,function(v) if v then AddRage(100) else SetRage(false); State.RageValue=0 end end,pgStates)
Slider("Rage Speed Mult",1,3,1.6,function(v) Cfg.RageSpeedMult=v end,pgStates,false)
Slider("Rage Anim Speed",0.5,5,1.0,function(v) Cfg.RageAnimSpeed=v end,pgStates,false)
Slider("Rage HP Regen/sec",0,15,2.0,function(v) Cfg.RageHealthRegen=v end,pgStates,false)
Header("Nervous",pgStates)
Toggle("Nervous Mode",false,function(v) State.IsNervous=v; ApplyAnims() end,pgStates)
Slider("Nervous Shake",0,5,1.5,function(v) Cfg.NervousShake=v end,pgStates,false)
Header("Sonar",pgStates)
Toggle("Sonar Ambient FX",false,function(v) State.SonarAmbient=v end,pgStates)
Slider("Sonar Intensity",0,10,5,function(v) State.SonarAmbientIntensity=v/10 end,pgStates,false)
Slider("Sonar Radius",50,400,150,function(v) Cfg.SonarMaxRadius=v end,pgStates,true)
Btn("Manual Sonar Ping",function() DoSonarPing(1) end,pgStates)
Header("Ping / LiDAR",pgStates)
Toggle("Ping Enabled",false,function(v) Cfg.PingEnabled=v end,pgStates)
Toggle("Ping Show Marker",true,function(v) Cfg.PingShowMarker=v end,pgStates)
Slider("Ping Radius",10,150,40,function(v) Cfg.PingRadius=v end,pgStates,true)
Slider("Ping Screen Shake",0,2,0.3,function(v) Cfg.PingScreenShake=v end,pgStates,false)
Btn("Manual Ping",function() DoPingEffect() end,pgStates)
Header("Focus (E to focus)",pgStates)
Toggle("Focus Enabled",true,function(v) Cfg.FocusEnabled=v; if not v then ClearFocus(false) end end,pgStates)
Toggle("In View Only",false,function(v) Cfg.FocusInViewOnly=v end,pgStates)
Slider("Focus Lost Threshold",0.5,5,2,function(v) Cfg.FocusLostThreshold=v end,pgStates,false)
Btn("Clear Focus",function() ClearFocus(false) end,pgStates)
Header("Ragdoll",pgStates)
Btn("Toggle Ragdoll [R]",function() SetRagdoll(not State.IsRagdolled) end,pgStates)
Header("Unconsciousness",pgStates)
Toggle("Knockout Enabled",true,function(v) Cfg.UnconsciousnessEnabled=v end,pgStates)
Slider("Knockout Duration",1,30,8,function(v) Cfg.KnockoutDuration=v end,pgStates,true)
Btn("Force Knockout",function() Knockout(Cfg.KnockoutDuration) end,pgStates)
Btn("Wake Up",function() WakeUp() end,pgStates)

-- ── INJURIES ──────────────────────────────────────────────────────────
local pgInjuries=NewPage("Injuries"); NavBtn("INJURIES","Injuries")
Header("Blood",pgInjuries)
Toggle("Blood Particles",true,function(v) Cfg.BloodParticlesEnabled=v end,pgInjuries)
Toggle("Blood Pools",true,function(v) Cfg.BloodPoolsEnabled=v end,pgInjuries)
Slider("Pool Size",1,7,6,function(v) Cfg.BloodPoolSize=v end,pgInjuries,false)
Header("Status",pgInjuries)
Btn("Clear All Injuries",function() ClearInjuries() end,pgInjuries)
Header("Apply Manually",pgInjuries)
Btn("Broken Left Leg",function() ApplyInjury("LeftLeg",60) end,pgInjuries)
Btn("Broken Right Leg",function() ApplyInjury("RightLeg",60) end,pgInjuries)
Btn("Broken Left Arm",function() ApplyInjury("LeftArm",40) end,pgInjuries)
Btn("Broken Right Arm",function() ApplyInjury("RightArm",40) end,pgInjuries)
Btn("Start Bleeding",function() ApplyInjury("Bleeding",30) end,pgInjuries)
Btn("Internal Bleeding",function() ApplyInjury("InternalBleed",80) end,pgInjuries)
Btn("Concussion",function() ApplyInjury("Concussion",20) end,pgInjuries)
Btn("Burns",function() ApplyInjury("Burns",50) end,pgInjuries)
Btn("Fracture",function() ApplyInjury("Fracture",30) end,pgInjuries)
Btn("Shrapnel",function() ApplyInjury("Shrapnel",40) end,pgInjuries)
Header("Rates",pgInjuries)
Slider("Bleed HP/sec",0.1,5,0.8,function(v) Injuries.BleedRate=v end,pgInjuries,false)
Slider("Internal HP/sec",0.1,8,1.5,function(v) Injuries.InternalRate=v end,pgInjuries,false)
Header("Explosion Physics",pgInjuries)
Toggle("Explosion Force",true,function(v) Cfg.ExplosionForce=v end,pgInjuries)
Toggle("Velocity Damage",true,function(v) Cfg.ExplosionVelocityDamage=v end,pgInjuries)
Btn("Test Explosion",function() local c=LP.Character; local r=c and c:FindFirstChild("HumanoidRootPart"); if r then MakeExplosion(r.Position+Vector3.new(10,0,0),25,400000) end end,pgInjuries)
Header("Ragdoll",pgInjuries)
Toggle("Limbs Collidable",true,function(v) Cfg.RagdollLimbsCollidable=v end,pgInjuries)
Toggle("Ragdoll On Explosion",true,function(v) Cfg.RagdollOnExplosion=v end,pgInjuries)
Toggle("Ragdoll On Jerk",true,function(v) Cfg.RagdollOnJerk=v end,pgInjuries)
Slider("Jerk Threshold",20,120,45,function(v) Cfg.RagdollJerkThreshold=v end,pgInjuries,true)
Header("Penetration Detection",pgInjuries)
Toggle("Penetration Detection",false,function(v)
	if v then SetupPenetrationDetection()
	elseif State.PenetrationConn then State.PenetrationConn:Disconnect() end
end,pgInjuries)
Header("Fall Thresholds",pgInjuries)
Slider("Minor Injury (studs)",25,80,35,function(v) Cfg.InjuryThresholdMinor=v end,pgInjuries,true)
Slider("Major Injury (studs)",40,120,55,function(v) Cfg.InjuryThresholdMajor=v end,pgInjuries,true)

-- ── ANIMATIONS ────────────────────────────────────────────────────────
local pgAnims=NewPage("Animations"); NavBtn("ANIMATIONS","Animations")
local function saveAnimNames()
	local t={}; for _,entry in ipairs(Anims.M_Key) do t[entry.id]=entry.name end; xenoSave(t)
end
Header("M-Key",pgAnims)
do
	local row=Instance.new("Frame",pgAnims); row.LayoutOrder=NextOrder()
	row.Size=UDim2.new(1,0,0,38); row.BackgroundColor3=Color3.fromRGB(14,14,24); row.BorderSizePixel=0
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,5)
	local tb=Instance.new("TextBox",row); tb.Size=UDim2.new(0.65,0,0,28); tb.Position=UDim2.new(0,6,0.5,-14)
	tb.BackgroundColor3=Color3.fromRGB(22,22,32); tb.BorderSizePixel=0; tb.PlaceholderText="Add Anim ID..."
	tb.Text=""; tb.TextColor3=Color3.new(1,1,1); tb.PlaceholderColor3=Color3.fromRGB(80,80,80)
	tb.Font=Enum.Font.GothamMedium; tb.TextSize=11; tb.TextXAlignment=Enum.TextXAlignment.Left
	Instance.new("UICorner",tb).CornerRadius=UDim.new(0,4)
	local addBtn=Instance.new("TextButton",row); addBtn.Size=UDim2.new(0.3,0,0,28)
	addBtn.Position=UDim2.new(0.68,0,0.5,-14); addBtn.BackgroundColor3=Color3.fromRGB(40,100,60)
	addBtn.TextColor3=Color3.new(1,1,1); addBtn.Text="+ ADD"; addBtn.Font=Enum.Font.GothamBold
	addBtn.TextSize=11; addBtn.BorderSizePixel=0; Instance.new("UICorner",addBtn).CornerRadius=UDim.new(0,4)
	addBtn.MouseButton1Click:Connect(function()
		local id=tb.Text:match("%d+"); if not id or id=="" then return end
		table.insert(Anims.M_Key,{id=id,name="Custom "..id}); tb.Text=""; saveAnimNames()
	end)
end
for i,entry in ipairs(Anims.M_Key) do
	local row=Instance.new("Frame",pgAnims); row.LayoutOrder=NextOrder()
	row.Size=UDim2.new(1,0,0,62); row.BackgroundColor3=Color3.fromRGB(18,18,24); row.BorderSizePixel=0
	Instance.new("UICorner",row).CornerRadius=UDim.new(0,5)
	local playBtn=Instance.new("TextButton",row); playBtn.Size=UDim2.new(0,60,0,30)
	playBtn.Position=UDim2.new(0,6,0,4); playBtn.BackgroundColor3=Color3.fromRGB(40,80,200)
	playBtn.Text="PLAY"; playBtn.TextColor3=Color3.new(1,1,1); playBtn.Font=Enum.Font.GothamBold
	playBtn.TextSize=11; playBtn.BorderSizePixel=0; Instance.new("UICorner",playBtn).CornerRadius=UDim.new(0,4)
	playBtn.MouseButton1Click:Connect(function() PlayKeybindAnim(entry.id,"M"..i) end)
	local nameLbl=Instance.new("TextLabel",row); nameLbl.Size=UDim2.new(1,-80,0,20); nameLbl.Position=UDim2.new(0,72,0,4)
	nameLbl.BackgroundTransparency=1; nameLbl.Text=entry.name; nameLbl.TextColor3=Color3.fromRGB(210,210,210)
	nameLbl.Font=Enum.Font.GothamBold; nameLbl.TextSize=12; nameLbl.TextXAlignment=Enum.TextXAlignment.Left
	local idLbl=Instance.new("TextLabel",row); idLbl.Size=UDim2.new(1,-80,0,14); idLbl.Position=UDim2.new(0,72,0,22)
	idLbl.BackgroundTransparency=1; idLbl.Text=entry.id; idLbl.TextColor3=Color3.fromRGB(90,90,100)
	idLbl.Font=Enum.Font.GothamMedium; idLbl.TextSize=9; idLbl.TextXAlignment=Enum.TextXAlignment.Left
	local renameTB=Instance.new("TextBox",row); renameTB.Size=UDim2.new(1,-80,0,22); renameTB.Position=UDim2.new(0,72,0,38)
	renameTB.BackgroundColor3=Color3.fromRGB(28,28,35); renameTB.BorderSizePixel=0; renameTB.PlaceholderText="Rename…"
	renameTB.Text=""; renameTB.TextColor3=Color3.new(1,1,1); renameTB.PlaceholderColor3=Color3.fromRGB(80,80,80)
	renameTB.Font=Enum.Font.GothamMedium; renameTB.TextSize=10; renameTB.TextXAlignment=Enum.TextXAlignment.Left
	Instance.new("UICorner",renameTB).CornerRadius=UDim.new(0,3)
	renameTB.FocusLost:Connect(function(enter) if enter and renameTB.Text~="" then entry.name=renameTB.Text; nameLbl.Text=entry.name; renameTB.Text=""; saveAnimNames() end end)
end

local function makeAddableBankSection(title,bank)
	Header(title.." (+ Add ID)",pgAnims)
	local addRow=Instance.new("Frame",pgAnims); addRow.LayoutOrder=NextOrder()
	addRow.Size=UDim2.new(1,0,0,38); addRow.BackgroundColor3=Color3.fromRGB(14,14,24); addRow.BorderSizePixel=0
	Instance.new("UICorner",addRow).CornerRadius=UDim.new(0,5)
	local tb=Instance.new("TextBox",addRow); tb.Size=UDim2.new(0.65,0,0,28); tb.Position=UDim2.new(0,6,0.5,-14)
	tb.BackgroundColor3=Color3.fromRGB(22,22,32); tb.BorderSizePixel=0; tb.PlaceholderText="Add Anim ID..."; tb.Text=""
	tb.TextColor3=Color3.new(1,1,1); tb.PlaceholderColor3=Color3.fromRGB(80,80,80); tb.Font=Enum.Font.GothamMedium
	tb.TextSize=11; tb.TextXAlignment=Enum.TextXAlignment.Left; Instance.new("UICorner",tb).CornerRadius=UDim.new(0,4)
	local ab=Instance.new("TextButton",addRow); ab.Size=UDim2.new(0.3,0,0,28); ab.Position=UDim2.new(0.68,0,0.5,-14)
	ab.BackgroundColor3=Color3.fromRGB(40,100,60); ab.TextColor3=Color3.new(1,1,1); ab.Text="+ ADD"
	ab.Font=Enum.Font.GothamBold; ab.TextSize=11; ab.BorderSizePixel=0; Instance.new("UICorner",ab).CornerRadius=UDim.new(0,4)
	ab.MouseButton1Click:Connect(function() local id=tb.Text:match("%d+"); if not id or id=="" then return end; table.insert(bank,id); tb.Text="" end)
	for i,id in ipairs(bank) do Btn(title:sub(1,1)..i.."  ["..id.."]",function() PlayKeybindAnim(id,title..i) end,pgAnims) end
end
makeAddableBankSection("O-Key",Anims.O_Key)
makeAddableBankSection("P-Key",Anims.P_Key)
makeAddableBankSection("I-Key",Anims.I_Key)
Header("Jigs & Dances",pgAnims)
for i,id in ipairs(Anims.Jigs) do Btn("JIG "..i.."  ["..id.."]",function() PlayKeybindAnim(id,"JIG"..i) end,pgAnims) end
Header("Misc",pgAnims)
Btn("Crash  ["..Anims.Misc.Crash.."]",function() PlayKeybindAnim(Anims.Misc.Crash,"CRASH") end,pgAnims)
Btn("Sit    ["..Anims.Misc.Sit.."]",function() PlayKeybindAnim(Anims.Misc.Sit,"SIT") end,pgAnims)

-- ── NPC / SPAWN ───────────────────────────────────────────────────────
local pgSpawn=NewPage("Spawn"); NavBtn("SPAWN","Spawn")
Header("Spawn NPC",pgSpawn)
local npcBehaviorVal="Neutral"; local behaviorBtns={}
for _,beh in ipairs({"Friendly","Neutral","Hostile"}) do
	local b=Btn(beh,function()
		npcBehaviorVal=beh
		for _,bb in pairs(behaviorBtns) do bb.BackgroundColor3=Color3.fromRGB(22,22,28) end
		behaviorBtns[beh].BackgroundColor3=Color3.fromRGB(40,60,140)
	end,pgSpawn)
	behaviorBtns[beh]=b
end
behaviorBtns["Neutral"].BackgroundColor3=Color3.fromRGB(40,60,140)
local npcSpeedVal=16
local _,npcSpeedBox=TextInput("NPC Walk Speed (default 16)...",pgSpawn,function(v) npcSpeedVal=tonumber(v) or 16 end)
Btn("⊕  Spawn NPC",function() SpawnNPC(npcBehaviorVal,npcSpeedVal) end,pgSpawn)
Header("Spawn Model by ID",pgSpawn)
local _,modelIdBox=TextInput("Model Asset ID...",pgSpawn,function() end)
Btn("⊕  Spawn Model",function()
	if not modelIdBox or modelIdBox.Text=="" then return end
	local id=tonumber(modelIdBox.Text); if not id then return end
	local char=LP.Character; local root=char and char:FindFirstChild("HumanoidRootPart")
	task.spawn(function()
		local ok,asset=pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
		if not ok or not asset then return end
		local model=asset:FindFirstChildOfClass("Model") or asset
		if root then local cf=root.CFrame*CFrame.new(0,0,-6); if model:IsA("Model") and model.PrimaryPart then model:SetPrimaryPartCFrame(cf) elseif model:IsA("BasePart") then model.CFrame=cf end end
		model.Parent=workspace; table.insert(SpawnedObjects,{model=model,type="model"}); asset:Destroy()
	end)
end,pgSpawn)
Header("Cleanup",pgSpawn)
Btn("Remove All Spawned",function() for _,rec in ipairs(SpawnedObjects) do pcall(function() rec.model:Destroy() end) end; for i=#SpawnedObjects,1,-1 do table.remove(SpawnedObjects,i) end; for i=#NPCList,1,-1 do table.remove(NPCList,i) end end,pgSpawn)
Btn("Remove Last Spawned",function() if #SpawnedObjects==0 then return end; pcall(function() table.remove(SpawnedObjects).model:Destroy() end) end,pgSpawn)

-- ── CATALOG ───────────────────────────────────────────────────────────
local pgCatalog=NewPage("Catalog"); NavBtn("CATALOG","Catalog")
Header("Avatar Creator",pgCatalog)
local catTypes={"Hat","HairAccessory","FaceAccessory","NeckAccessory","ShoulderAccessory","FrontAccessory","BackAccessory","WaistAccessory","Shirt","Pants","Face","TShirt"}
local catVal="Hat"
do
	local catScroll=Instance.new("ScrollingFrame",pgCatalog); catScroll.LayoutOrder=NextOrder()
	catScroll.Size=UDim2.new(1,0,0,38); catScroll.CanvasSize=UDim2.new(0,#catTypes*82,0,0)
	catScroll.ScrollBarThickness=3; catScroll.BackgroundTransparency=1
	local rl=Instance.new("UIListLayout",catScroll); rl.FillDirection=Enum.FillDirection.Horizontal; rl.Padding=UDim.new(0,4)
	local catBtns={}
	for _,t in ipairs(catTypes) do
		local tb=Instance.new("TextButton",catScroll); tb.Size=UDim2.new(0,78,0,30)
		tb.Text=t; tb.TextSize=10; tb.Font=Enum.Font.GothamMedium
		tb.BackgroundColor3=Color3.fromRGB(25,25,35); tb.TextColor3=Color3.fromRGB(180,180,200); tb.BorderSizePixel=0
		Instance.new("UICorner",tb).CornerRadius=UDim.new(0,4)
		catBtns[t]=tb
		tb.MouseButton1Click:Connect(function() catVal=t; for _,b in pairs(catBtns) do b.BackgroundColor3=Color3.fromRGB(25,25,35) end; tb.BackgroundColor3=Color3.fromRGB(60,80,180) end)
	end
	catBtns["Hat"].BackgroundColor3=Color3.fromRGB(60,80,180)
end
local _,catalogSearchBox=TextInput("Search keyword...",pgCatalog,function() end)
local catResultsFrame=Instance.new("Frame",pgCatalog); catResultsFrame.LayoutOrder=NextOrder()
catResultsFrame.Size=UDim2.new(1,0,0,0); catResultsFrame.AutomaticSize=Enum.AutomaticSize.Y; catResultsFrame.BackgroundTransparency=1
Instance.new("UIListLayout",catResultsFrame).Padding=UDim.new(0,3)
local catStatus=Instance.new("TextLabel",catResultsFrame); catStatus.Size=UDim2.new(1,0,0,22)
catStatus.BackgroundTransparency=1; catStatus.Text="Enter search and press Search"
catStatus.TextColor3=Color3.fromRGB(120,120,140); catStatus.Font=Enum.Font.GothamMedium; catStatus.TextSize=11; catStatus.LayoutOrder=0
local function RenderCatalogResults(items,err)
	for _,c in ipairs(catResultsFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
	if err or not items then catStatus.Text="Error: "..(err or "?"); return end
	if #items==0 then catStatus.Text="No results"; return end
	catStatus.Text=#items.." results:"
	for i,item in ipairs(items) do
		local name=item.name or ("Item "..i); local id=item.id or 0
		local rb=Instance.new("TextButton",catResultsFrame); rb.Size=UDim2.new(1,0,0,30)
		rb.BackgroundColor3=Color3.fromRGB(20,22,32); rb.Text=name.."  ["..id.."]"
		rb.TextColor3=Color3.fromRGB(200,210,255); rb.Font=Enum.Font.GothamMedium; rb.TextSize=11
		rb.BorderSizePixel=0; rb.LayoutOrder=i+1; Instance.new("UICorner",rb).CornerRadius=UDim.new(0,4)
		rb.MouseButton1Click:Connect(function()
			local hum,desc=GetHumDesc(); if not hum or not desc then return end
			local at=(item.itemType or catVal)
			if at=="Shirt" then desc.Shirt=id elseif at=="Pants" then desc.Pants=id
			elseif at=="TShirt" then desc.GraphicTShirt=id elseif at=="Face" then desc.Face=id
			else local cur=desc.HatAccessory or ""; desc.HatAccessory=cur=="" and tostring(id) or (cur..","..id) end
			ApplyDesc(desc); rb.BackgroundColor3=Color3.fromRGB(20,50,20)
		end)
	end
end
Btn("🔍  Search",function() local q=catalogSearchBox and catalogSearchBox.Text or ""; if q=="" then catStatus.Text="Enter a keyword first"; return end; catStatus.Text="Searching..."; CatalogSearch(q,catVal,RenderCatalogResults) end,pgCatalog)
Header("Body Colors",pgCatalog)
local colorParts={{"Head","HeadColor"},{"Torso","TorsoColor"},{"Left Arm","LeftArmColor"},{"Right Arm","RightArmColor"},{"Left Leg","LeftLegColor"},{"Right Leg","RightLegColor"}}
local brickColors={{"White",Color3.new(1,1,1)},{"Black",Color3.new(0.06,0.06,0.06)},{"Bright red",Color3.fromRGB(196,40,28)},{"Bright blue",Color3.fromRGB(13,105,172)},{"Bright green",Color3.fromRGB(39,140,41)},{"Bright yellow",Color3.fromRGB(245,205,48)},{"Sand green",Color3.fromRGB(120,144,130)},{"Medium stone",Color3.fromRGB(163,162,165)},{"Reddish brown",Color3.fromRGB(105,64,40)},{"Dark orange",Color3.fromRGB(218,133,65)},{"Pink",Color3.fromRGB(255,152,220)},{"Cyan",Color3.fromRGB(1,172,228)}}
for _,pair in ipairs(colorParts) do
	local partName,descKey=pair[1],pair[2]
	local lbl=Instance.new("TextLabel",pgCatalog); lbl.LayoutOrder=NextOrder(); lbl.Size=UDim2.new(1,0,0,16)
	lbl.BackgroundTransparency=1; lbl.Text=partName; lbl.TextColor3=Color3.fromRGB(160,160,180)
	lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=11; lbl.TextXAlignment=Enum.TextXAlignment.Left
	local swatchRow=Instance.new("Frame",pgCatalog); swatchRow.LayoutOrder=NextOrder(); swatchRow.Size=UDim2.new(1,0,0,24); swatchRow.BackgroundTransparency=1
	local rl2=Instance.new("UIListLayout",swatchRow); rl2.FillDirection=Enum.FillDirection.Horizontal; rl2.Padding=UDim.new(0,3)
	for _,cp in ipairs(brickColors) do
		local colName,col=cp[1],cp[2]
		local sw=Instance.new("TextButton",swatchRow); sw.Size=UDim2.new(0,20,0,20); sw.BackgroundColor3=col; sw.BorderSizePixel=0; sw.Text=""
		Instance.new("UICorner",sw).CornerRadius=UDim.new(0,3)
		sw.MouseButton1Click:Connect(function() local hum,desc=GetHumDesc(); if not hum or not desc then return end; desc[descKey]=BrickColor.new(colName); ApplyDesc(desc) end)
	end
end
Header("Scale (R15 only)",pgCatalog)
Slider("Head Size",0.5,2,1,function(v) ApplyScale("Head",v) end,pgCatalog,false)
Slider("Height",0.9,1.05,1,function(v) ApplyScale("Height",v) end,pgCatalog,false)
Slider("Width",0.7,1,1,function(v) ApplyScale("Width",v) end,pgCatalog,false)
Slider("Depth",0.7,1,1,function(v) ApplyScale("Depth",v) end,pgCatalog,false)
Slider("Body Type",0,1,0,function(v) ApplyScale("BodyType",v) end,pgCatalog,false)
Slider("Proportion",0,1,0,function(v) ApplyScale("Proportion",v) end,pgCatalog,false)
Header("Apply by ID",pgCatalog)
local _,idBox=TextInput("Asset ID...",pgCatalog,function() end)
Btn("Apply Accessory ID",function() if not idBox or idBox.Text=="" then return end; local id=tonumber(idBox.Text); if not id then return end; local hum,desc=GetHumDesc(); if not hum then return end; local cur=desc.HatAccessory or ""; desc.HatAccessory=cur=="" and tostring(id) or (cur..","..id); ApplyDesc(desc) end,pgCatalog)
Btn("Apply Shirt ID",function() if idBox and idBox.Text~="" then local h,d=GetHumDesc(); if h then d.Shirt=tonumber(idBox.Text); ApplyDesc(d) end end end,pgCatalog)
Btn("Apply Pants ID",function() if idBox and idBox.Text~="" then local h,d=GetHumDesc(); if h then d.Pants=tonumber(idBox.Text); ApplyDesc(d) end end end,pgCatalog)
Btn("Apply Face ID",function() if idBox and idBox.Text~="" then local h,d=GetHumDesc(); if h then d.Face=tonumber(idBox.Text); ApplyDesc(d) end end end,pgCatalog)
Btn("Clear All Accessories",function() local h,d=GetHumDesc(); if not h then return end; d.HatAccessory=""; d.HairAccessory=""; d.FaceAccessory=""; d.NeckAccessory=""; d.ShouldersAccessory=""; d.FrontAccessory=""; d.BackAccessory=""; d.WaistAccessory=""; ApplyDesc(d) end,pgCatalog)
Header("Reset",pgCatalog)
Btn("⟳ Reset to Original",function()
	if AvatarState.OriginalDesc then ApplyDesc(AvatarState.OriginalDesc)
	else task.spawn(function() local ok,d=pcall(function() return Players:GetHumanoidDescriptionFromUserId(LP.UserId) end); if ok and d then ApplyDesc(d) end end) end
end,pgCatalog)
Toggle("Persist Through Respawn",true,function(v) AvatarState.PersistCatalog=v end,pgCatalog)

-- ── PLAYERS ───────────────────────────────────────────────────────────
local TTSForPlayers={}; local PastPlayersList={}
Players.PlayerRemoving:Connect(function(plr)
	table.insert(PastPlayersList,{name=plr.Name,userId=plr.UserId,leftAt=os.time()})
	if #PastPlayersList>50 then table.remove(PastPlayersList,1) end
end)
local GH_TTS_OnPlayerChat=Instance.new("BindableEvent")
GH_TTS_OnPlayerChat.Name="GH_TTS_OnPlayerChat"; GH_TTS_OnPlayerChat.Parent=ScreenGui
GH_TTS_OnPlayerChat.Event:Connect(function(playerName,message)
	if not TTSForPlayers[playerName] then return end
	if _G.GH_TTS and message and message~="" then pcall(function() _G.GH_TTS.Text=message; _G.GH_TTS.TimePosition=0; _G.GH_TTS:Play() end) end
end)
local pgPlayers=NewPage("Players"); NavBtn("PLAYERS","Players")
Header("In Server",pgPlayers)
local playersListFrame=Instance.new("Frame",pgPlayers); playersListFrame.LayoutOrder=NextOrder()
playersListFrame.Size=UDim2.new(1,0,0,0); playersListFrame.AutomaticSize=Enum.AutomaticSize.Y; playersListFrame.BackgroundTransparency=1
Instance.new("UIListLayout",playersListFrame).Padding=UDim.new(0,4)
local function RefreshPlayersList()
	for _,c in ipairs(playersListFrame:GetChildren()) do if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end end
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr~=LP then
			local row=Instance.new("Frame",playersListFrame); row.Size=UDim2.new(1,0,0,36)
			row.BackgroundColor3=Color3.fromRGB(22,22,28); row.BorderSizePixel=0
			Instance.new("UICorner",row).CornerRadius=UDim.new(0,5)
			local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(0.5,-4,1,0); lbl.Position=UDim2.new(0,8,0,0)
			lbl.BackgroundTransparency=1; lbl.Text=plr.Name; lbl.TextColor3=Color3.fromRGB(200,200,210)
			lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
			local stats=Instance.new("TextLabel",row); stats.Size=UDim2.new(0.5,-8,0,14); stats.Position=UDim2.new(0.5,0,0,2)
			stats.BackgroundTransparency=1; stats.Text="—"; stats.TextColor3=Color3.fromRGB(120,120,140)
			stats.Font=Enum.Font.GothamMedium; stats.TextSize=9; stats.TextXAlignment=Enum.TextXAlignment.Right
			task.spawn(function()
				while row and row.Parent and plr.Parent do
					local c=plr.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); local r=c and c:FindFirstChild("HumanoidRootPart")
					if h and r then stats.Text=string.format("HP %d  |  %.0f, %.0f, %.0f",h.Health,r.Position.X,r.Position.Y,r.Position.Z) else stats.Text="—" end
					task.wait(0.5)
				end
			end)
			local ttsBtn=Instance.new("TextButton",row); ttsBtn.Size=UDim2.new(0,70,0,22); ttsBtn.Position=UDim2.new(1,-78,0.5,-11)
			ttsBtn.Text=TTSForPlayers[plr.Name] and "TTS ON" or "TTS OFF"
			ttsBtn.BackgroundColor3=TTSForPlayers[plr.Name] and Color3.fromRGB(40,100,60) or Color3.fromRGB(50,50,55)
			ttsBtn.TextColor3=Color3.new(1,1,1); ttsBtn.Font=Enum.Font.GothamBold; ttsBtn.TextSize=10; ttsBtn.BorderSizePixel=0
			Instance.new("UICorner",ttsBtn).CornerRadius=UDim.new(0,4)
			ttsBtn.MouseButton1Click:Connect(function()
				TTSForPlayers[plr.Name]=not TTSForPlayers[plr.Name]
				ttsBtn.Text=TTSForPlayers[plr.Name] and "TTS ON" or "TTS OFF"
				ttsBtn.BackgroundColor3=TTSForPlayers[plr.Name] and Color3.fromRGB(40,100,60) or Color3.fromRGB(50,50,55)
			end)
		end
	end
end
RefreshPlayersList()
Btn("Refresh List",function() RefreshPlayersList() end,pgPlayers)
Header("Players Who Left",pgPlayers)
local pastScroll=Instance.new("ScrollingFrame",pgPlayers); pastScroll.LayoutOrder=NextOrder()
pastScroll.Size=UDim2.new(1,0,0,120); pastScroll.BackgroundTransparency=1; pastScroll.ScrollBarThickness=2
pastScroll.CanvasSize=UDim2.new(0,0,0,0); pastScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
Instance.new("UIListLayout",pastScroll).Padding=UDim.new(0,2)
local function RefreshPastPlayers()
	for _,c in ipairs(pastScroll:GetChildren()) do c:Destroy() end
	for i=#PastPlayersList,1,-1 do
		local rec=PastPlayersList[i]; local row=Instance.new("TextLabel",pastScroll)
		row.Size=UDim2.new(1,0,0,20); row.BackgroundTransparency=1
		row.Text=rec.name.."  (ID: "..tostring(rec.userId)..")"
		row.TextColor3=Color3.fromRGB(100,100,110); row.Font=Enum.Font.GothamMedium; row.TextSize=10; row.TextXAlignment=Enum.TextXAlignment.Left
	end
end
Btn("Refresh Past",function() RefreshPastPlayers() end,pgPlayers)

-- ── PROXIMITY ─────────────────────────────────────────────────────────
local pgProx=NewPage("Proximity"); NavBtn("PROXIMITY","Proximity")
Header("Player Proximity System",pgProx)
Toggle("Enable Proximity FX",false,function(v) Cfg.ProximityEnabled=v; if not v then ClearProximityFX() end end,pgProx)
Toggle("Highlight Nearby Players",true,function(v) Cfg.ProximityHighlight=v end,pgProx)
Toggle("Marker/Name Billboard",true,function(v) Cfg.ProximityMarker=v end,pgProx)
Slider("Highlight Range",10,200,40,function(v) Cfg.ProximityRange=v end,pgProx,true)
Slider("Marker Range",10,300,60,function(v) Cfg.ProximityMarkerRange=v end,pgProx,true)
Toggle("Off-Screen Directional Marker",true,function(v) Cfg.ProximityOffScreenMarker=v end,pgProx)

-- ── AUDIO ─────────────────────────────────────────────────────────────
local pgAudio=NewPage("Audio"); NavBtn("AUDIO","Audio")
Header("Ambient / Music Player",pgAudio)
local _,audioIdBox=TextInput("Sound ID or rbxassetid://...",pgAudio,function() end)
Slider("Volume",0,5,1,function(v) GetAmbientSound().Volume=v end,pgAudio,false)
Slider("Pitch",0.1,4,1,function(v) GetAmbientSound().PlaybackSpeed=v end,pgAudio,false)
Toggle("Looped",true,function(v) GetAmbientSound().Looped=v end,pgAudio)
Btn("▶  Play",function() local snd=GetAmbientSound(); if audioIdBox and audioIdBox.Text~="" then local raw=audioIdBox.Text; if raw:match("^%d+$") then raw="rbxassetid://"..raw end; snd.SoundId=raw end; snd:Play() end,pgAudio)
Btn("⏸  Pause",function() GetAmbientSound():Pause() end,pgAudio)
Btn("⏹  Stop",function() GetAmbientSound():Stop() end,pgAudio)
Header("Ambient Effects",pgAudio)
Toggle("Ambient Reverb",false,function(v) local r=GetOrCreateAmbientEffect("Reverb","ReverbSoundEffect"); r.Enabled=v; if v then r.DecayTime=Cfg.TTSReverbDecay; r.WetLevel=Cfg.TTSReverbWet end end,pgAudio)
Toggle("Ambient Echo",false,function(v) local e=GetOrCreateAmbientEffect("Echo","EchoSoundEffect"); e.Enabled=v; if v then e.Delay=Cfg.TTSEchoDelay; e.Feedback=Cfg.TTSEchoFeedback; e.WetLevel=Cfg.TTSEchoWet end end,pgAudio)
Toggle("Ambient Distortion",false,function(v) local d=GetOrCreateAmbientEffect("Distortion","DistortionSoundEffect"); d.Enabled=v; if v then d.Level=Cfg.TTSDistLevel end end,pgAudio)
Slider("Reverb Decay",0.1,10,1.5,function(v) Cfg.TTSReverbDecay=v; local r=AmbientEffects["Reverb"]; if r then r.DecayTime=v end end,pgAudio,false)
Slider("Reverb Wet",0,1,0.3,function(v) Cfg.TTSReverbWet=v; local r=AmbientEffects["Reverb"]; if r then r.WetLevel=v end end,pgAudio,false)
Slider("Echo Delay",0.05,1,0.3,function(v) Cfg.TTSEchoDelay=v; local e=AmbientEffects["Echo"]; if e then e.Delay=v end end,pgAudio,false)
Slider("Echo Wet",0,1,0.4,function(v) Cfg.TTSEchoWet=v; local e=AmbientEffects["Echo"]; if e then e.WetLevel=v end end,pgAudio,false)
Slider("Distortion Level",0,1,0.2,function(v) Cfg.TTSDistLevel=v; local d=AmbientEffects["Distortion"]; if d then d.Level=v end end,pgAudio,false)
Header("Preset Ambients",pgAudio)
local ambientPresets={{name="Forest",id="rbxassetid://142693328"},{name="Rain",id="rbxassetid://140932594"},{name="Wind",id="rbxassetid://161876916"},{name="Heartbeat",id="rbxassetid://139459003161851"},{name="City",id="rbxassetid://166619644"},{name="Silence",id=""}}
for _,pr in ipairs(ambientPresets) do Btn(pr.name,function() local snd=GetAmbientSound(); if pr.id=="" then snd:Stop(); return end; snd.SoundId=pr.id; snd.Looped=true; snd:Play() end,pgAudio) end
Header("Global Sound FX",pgAudio)
local FXChain={}
local function GetOrCreateFX(class,name) if FXChain[name] then return FXChain[name] end; local fx=Instance.new(class); fx.Name="GH_"..name; fx.Parent=workspace; FXChain[name]=fx; return fx end
Toggle("Reverb",false,function(v) GetOrCreateFX("ReverbSoundEffect","Reverb").Enabled=v end,pgAudio)
Toggle("Echo",false,function(v) GetOrCreateFX("EchoSoundEffect","Echo").Enabled=v end,pgAudio)
Toggle("Distortion",false,function(v) GetOrCreateFX("DistortionSoundEffect","Distortion").Enabled=v end,pgAudio)
Toggle("Equalizer",false,function(v) GetOrCreateFX("EqualizerSoundEffect","EQ").Enabled=v end,pgAudio)
Slider("Reverb Decay",0,30,1.5,function(v) GetOrCreateFX("ReverbSoundEffect","Reverb").DecayTime=v end,pgAudio,false)
Slider("EQ Low Gain",-14,14,0,function(v) GetOrCreateFX("EqualizerSoundEffect","EQ").LowGain=v end,pgAudio,false)
Slider("EQ High Gain",-14,14,0,function(v) GetOrCreateFX("EqualizerSoundEffect","EQ").HighGain=v end,pgAudio,false)
Btn("🏛 Cathedral",function() local r=GetOrCreateFX("ReverbSoundEffect","Reverb"); r.DecayTime=8; r.Density=1; r.WetLevel=0.7; r.Enabled=true end,pgAudio)
Btn("📻 Radio",function() local eq=GetOrCreateFX("EqualizerSoundEffect","EQ"); eq.LowGain=-8; eq.MidGain=3; eq.HighGain=-6; eq.Enabled=true; local d=GetOrCreateFX("DistortionSoundEffect","Distortion"); d.Level=0.2; d.Enabled=true end,pgAudio)
Btn("🧹 Clear FX",function() for _,fx in pairs(FXChain) do fx.Enabled=false end end,pgAudio)

-- ── TTS ───────────────────────────────────────────────────────────────
do
	local pgTTS=NewPage("TTS"); NavBtn("TTS","TTS")
	Header("Text-to-Speech",pgTTS)
	Toggle("TTS Enabled",false,function(v) Cfg.TTSEnabled=v end,pgTTS)
	Header("Voice",pgTTS)
	local voiceBtns={}
	for i=1,8 do
		local vb=Btn("Voice "..i,function()
			Cfg.TTSVoiceId=tostring(i)
			if _G.GH_TTS then pcall(function() _G.GH_TTS.VoiceId=Cfg.TTSVoiceId end) end
			for j,b in ipairs(voiceBtns) do b.BackgroundColor3=(j==i) and Color3.fromRGB(40,80,200) or Color3.fromRGB(22,22,28) end
		end,pgTTS)
		voiceBtns[i]=vb
	end
	voiceBtns[1].BackgroundColor3=Color3.fromRGB(40,80,200)
	Header("Volume & Rate",pgTTS)
	Slider("Output Volume",0,5,1,function(v) Cfg.TTSVolume=v; if _G.GH_TTS_FADER then _G.GH_TTS_FADER.Volume=v end end,pgTTS,false)
	Slider("Playback Rate",0.5,2,1,function(v) Cfg.TTSRate=v; if _G.GH_TTS_PITCH then pcall(function() _G.GH_TTS_PITCH.Pitch=math.clamp(v*2^(Cfg.TTSPitch/12),0.5,2) end) end end,pgTTS,false)
	Header("Pitch",pgTTS)
	Slider("Pitch (semitones)",-12,12,0,function(v) Cfg.TTSPitch=v; if _G.GH_TTS_PITCH then pcall(function() _G.GH_TTS_PITCH.Pitch=math.clamp(Cfg.TTSRate*2^(v/12),0.5,2) end) end end,pgTTS,false)
	Header("Effects",pgTTS)
	Toggle("TTS Reverb",false,function(v) Cfg.TTSReverb=v; if _G.GH_TTS_REVERB then pcall(function() _G.GH_TTS_REVERB.Bypass=not v end) end end,pgTTS)
	Toggle("TTS Echo",false,function(v) Cfg.TTSEcho=v; if _G.GH_TTS_ECHO then pcall(function() _G.GH_TTS_ECHO.Bypass=not v end) end end,pgTTS)
	Toggle("TTS Distortion",false,function(v) Cfg.TTSDistortion=v; if _G.GH_TTS_DIST then pcall(function() _G.GH_TTS_DIST.Bypass=not v end) end end,pgTTS)
	Header("FX Presets",pgTTS)
	Btn("🤖 Robot",function() Cfg.TTSPitch=-5; if _G.GH_TTS_PITCH then pcall(function() _G.GH_TTS_PITCH.Pitch=math.clamp(2^(-5/12),0.5,2) end) end; if _G.GH_TTS_DIST then pcall(function() _G.GH_TTS_DIST.Level=0.35; _G.GH_TTS_DIST.Bypass=false end) end end,pgTTS)
	Btn("👻 Ghost",function() Cfg.TTSPitch=6; if _G.GH_TTS_PITCH then pcall(function() _G.GH_TTS_PITCH.Pitch=math.clamp(2^(6/12),0.5,2) end) end; if _G.GH_TTS_REVERB then pcall(function() _G.GH_TTS_REVERB.DecayTime=8; _G.GH_TTS_REVERB.WetLevel=0.7; _G.GH_TTS_REVERB.Bypass=false end) end end,pgTTS)
	Btn("😈 Demon",function() Cfg.TTSPitch=-10; if _G.GH_TTS_PITCH then pcall(function() _G.GH_TTS_PITCH.Pitch=math.clamp(2^(-10/12),0.5,2) end) end; if _G.GH_TTS_REVERB then pcall(function() _G.GH_TTS_REVERB.DecayTime=4; _G.GH_TTS_REVERB.Bypass=false end) end; if _G.GH_TTS_DIST then pcall(function() _G.GH_TTS_DIST.Level=0.5; _G.GH_TTS_DIST.Bypass=false end) end end,pgTTS)
	Btn("🧹 Clear FX",function() Cfg.TTSPitch=0; Cfg.TTSRate=1; if _G.GH_TTS_PITCH then pcall(function() _G.GH_TTS_PITCH.Pitch=1 end) end; if _G.GH_TTS_REVERB then pcall(function() _G.GH_TTS_REVERB.Bypass=true end) end; if _G.GH_TTS_DIST then pcall(function() _G.GH_TTS_DIST.Bypass=true end) end end,pgTTS)
	Header("Test",pgTTS)
	local _,testBox=TextInput("Type to speak...",pgTTS,function() end)
	Btn("▶ Speak Text",function() if not _G.GH_TTS then return end; local msg=(testBox and testBox.Text~="") and testBox.Text or "Hello World"; pcall(function() _G.GH_TTS.Text=msg; _G.GH_TTS.TimePosition=0; _G.GH_TTS:Play() end) end,pgTTS)
	Btn("⏹ Stop Speaking",function() if _G.GH_TTS then pcall(function() _G.GH_TTS:Stop() end) end end,pgTTS)
end

-- ── LAUNCHER ──────────────────────────────────────────────────────────
local pgLauncher=NewPage("Launcher"); NavBtn("LAUNCHER","Launcher")
Header("Launch Yourself",pgLauncher)
local launchPower=150; local launchAngle=45; local launchMode="Forward"
local modeBtns={}
for _,mode in ipairs({"Forward","Up","Camera","Custom"}) do
	local mb=Btn(mode,function() launchMode=mode; for k,b in pairs(modeBtns) do b.BackgroundColor3=(k==mode) and Color3.fromRGB(40,80,200) or Color3.fromRGB(22,22,28) end end,pgLauncher)
	modeBtns[mode]=mb
end
modeBtns["Forward"].BackgroundColor3=Color3.fromRGB(40,80,200)
Slider("Launch Power",10,800,150,function(v) launchPower=v end,pgLauncher,true)
Slider("Upward Angle",0,90,45,function(v) launchAngle=v end,pgLauncher,true)
Header("Custom Direction",pgLauncher)
local customDir=Vector3.new(0,1,0)
local _,cdxBox=TextInput("X  (e.g. 0)",pgLauncher,function(v) customDir=Vector3.new(tonumber(v) or customDir.X,customDir.Y,customDir.Z) end)
local _,cdyBox=TextInput("Y  (e.g. 1)",pgLauncher,function(v) customDir=Vector3.new(customDir.X,tonumber(v) or customDir.Y,customDir.Z) end)
local _,cdzBox=TextInput("Z  (e.g. 0)",pgLauncher,function(v) customDir=Vector3.
