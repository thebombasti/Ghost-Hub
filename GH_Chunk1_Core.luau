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
