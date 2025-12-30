class EGoggle extends Actor
	notplaceable;

#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax

const REN_DynLight		= 5;
const REN_ThermalVision = 10;
const REN_NightVision	= 11;

var EPlayerController	Epc;
var int					CurrentMode;
var bool				bNoThermalAvailable;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	Epc = EPlayerController(Owner);
	if (Epc == None)
		Log(self$" ERROR: Goggle owner is not a PlayerController.");

	SetBase(Epc.ePawn);
	CurrentMode = REN_DynLight;
}

function Activate()
{
	//Log("Activating"@CurrentMode);
	Epc.SetCameraMode(Epc, CurrentMode);

	if (CurrentMode == REN_ThermalVision)
	{     
		Epc.ThermalTexture = Level.pThermalTexture_A;
        Epc.bBigPixels = false;		
	}
}

// Called from PlayerController
function SwitchMode(float i)
{
	if (i < 0)
		SwitchVisionMode(REN_NightVision);
	else
		SwitchVisionMode(REN_ThermalVision);
}

function SwitchVisionMode(int NewMode)
{
	// Prevent overlapping animation, wait for channel being available
	if (Epc.ePawn.IsAnimating(Epc.ePawn.PERSONALITYCHANNEL))
		return;

	// Quick tap the same mode OR mode is not available, fallback to normal
	if (CurrentMode == NewMode || NewMode == REN_ThermalVision && bNoThermalAvailable)
		SwitchGoggle(REN_DynLight);
	else
		SwitchGoggle(NewMode);
}

// Joshua - When you want to force the goggles up
// Returns true if goggles were on and animation was played, false if already off
function bool ForceGoggleUp()
{
	// Do nothing, goggles already off
	if (CurrentMode == REN_DynLight)
		return false;

	// Set target mode to DynLight - will be activated when animation finishes
	CurrentMode = REN_DynLight;

	AddSoundRequest(Sound'Interface.Play_FisherEquipGoggle', SLOT_Interface, 0.5f);

	if (Epc.CanSwitchGoggleManually())
	{
		Epc.ePawn.BlendAnimOverCurrent('Goglcraldn0',0, 'B L Clavicle',,,Epc.ePawn.PERSONALITYCHANNEL,true);
		Epc.ePawn.AnimBlendToAlpha(Epc.ePawn.PERSONALITYCHANNEL, 1, 0.3);
	}
	else
	{
		Epc.ePawn.BlendAnimOverCurrent('Goglstaldn2',0, 'B Head',/*rate*/,/*tween*/,Epc.ePawn.PERSONALITYCHANNEL, true);
		Epc.ePawn.AnimBlendToAlpha(Epc.ePawn.PERSONALITYCHANNEL, 1, 0.15);
	}

	return true;
}

function SwitchGoggle(int NewRenderingMode);	// Notify from equiping/unequiping goggles
function Down();								// Animation has hand over the eyes
function Up();									// Animation has hand over the head

auto state GoggleUp
{
	function SwitchGoggle(int NewRenderingMode)
	{
		//Log("GoggleUp SwitchGoggle to "$NewRenderingMode);
		// change to new mode
		CurrentMode = NewRenderingMode;

		// do nothing if no change in rendering needed
		if (CurrentMode == REN_DynLight) 
			return;

		AddSoundRequest(Sound'Interface.Play_FisherEquipGoggle', SLOT_Interface, 0.5f);

		//Log("Play anim goggle down");
		if (Epc.CanSwitchGoggleManually())
		{
			Epc.ePawn.BlendAnimOverCurrent('Goglcraldn0',0, 'B L Clavicle',,,Epc.ePawn.PERSONALITYCHANNEL);
			Epc.ePawn.AnimBlendToAlpha(Epc.ePawn.PERSONALITYCHANNEL, 1, 0.3);
		}
		else
		{
			Epc.ePawn.BlendAnimOverCurrent('Goglstaldn2',0, 'B Head',/*rate*/,/*tween*/,Epc.ePawn.PERSONALITYCHANNEL);
			Epc.ePawn.AnimBlendToAlpha(Epc.ePawn.PERSONALITYCHANNEL, 1, 0.15);
		}
	}

	function Down()
	{
		Up();
	}

	function Up()
	{
		//Log("GoggleUp Up()"@CurrentMode);
		if (CurrentMode != REN_DynLight)
			GotoState('GoggleDown');
	}
}

state GoggleDown
{
	function BeginState()
	{
		local int speed;
		if (Epc.CanSwitchGoggleManually())
			speed = 4;
		else
			speed = 10;

		// move goggle bone down on the eyes
		Epc.ePawn.SetBoneRotation('BGoggles',Rot(0,0,-5400),,speed,,0.01);
	}

	function EndState()
	{
		local int speed;
		if (Epc.CanSwitchGoggleManually())
			speed = 5;
		else
			speed = 30;

		// move goggles up on the head
		Epc.ePawn.SetBoneRotation('BGoggles',Rot(0,0,-5400),,,speed,1);
	}

	function SwitchGoggle(int NewRenderingMode)
	{
		local int PrevMode;
		//Log("GoggleDown SwitchGoggle to "$NewRenderingMode);

		// change to new mode
		PrevMode = CurrentMode;
		CurrentMode = NewRenderingMode;

		// Pull goggle up
		if (CurrentMode == REN_DynLight)
		{
			AddSoundRequest(Sound'Interface.Play_FisherEquipGoggle', SLOT_Interface, 0.5f);

			//Log("Play anim goggle up");
			if (Epc.CanSwitchGoggleManually())
			{
				Epc.ePawn.BlendAnimOverCurrent('Goglcraldn0',0, 'B L Clavicle',,,Epc.ePawn.PERSONALITYCHANNEL,true);
				Epc.ePawn.AnimBlendToAlpha(Epc.ePawn.PERSONALITYCHANNEL, 1, 0.3);
			}
			else
			{
				Epc.ePawn.BlendAnimOverCurrent('Goglstaldn2',0, 'B Head',/*rate*/,/*tween*/,Epc.ePawn.PERSONALITYCHANNEL, true);
				Epc.ePawn.AnimBlendToAlpha(Epc.ePawn.PERSONALITYCHANNEL, 1, 0.15);
			}
		}
		// just switch between view
		else
		{
			Activate();
			if (PrevMode != CurrentMode)
				PlaySound(Sound'Interface.Play_FisherSwitchGoggle', SLOT_Interface);
		}
	}

	function Down()
	{
		//Log("GoggleDown Down()"@CurrentMode);
		// switch to new mode, if is coming from Up, will be new rendering, else, will be 0
		Activate();

		if (CurrentMode == REN_DynLight)
			GotoState('GoggleUp');
		else
		{
			PlaySound(Sound'FisherEquipement.Play_GoggleRun', SLOT_SFX);
		}
	}

	function Up()
	{
		Down();
	}
}

defaultproperties
{
    bHidden=True
}