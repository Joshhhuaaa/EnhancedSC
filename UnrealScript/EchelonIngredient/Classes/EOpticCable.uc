class EOpticCable extends EInventoryItem;

#exec OBJ LOAD FILE=..\Sounds\Interface.uax

var()   float		    Damping;
var	    rotator		    camera_rotation;
var     int			    start_yaw;
var		vector			start_location;
var     ESwingingDoor   Door;

const valid_range = 13000;

function PostBeginPlay()
{
	Super.PostBeginPlay();

    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_opticcable;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_opticcable;
    ItemName     = "OpticCable";
	ItemVideoName = "gd_optique_cable.bik";
    Description  = "OpticCableDesc";
	HowToUseMe  = "OpticCableHowToUseMe";
}

// same as Normalize for a rotator but for an int only
function int CenterToZero(int v)
{
	v = v & 65535; 
	if (v >= 32769) 
		v -= 65536;
	return v;
}

function bool IsInRange(int iStart, int iRange, int iCur)
{
    local int iDelta;
	iDelta = CenterToZero(iCur - iStart);
    return Abs(iDelta) < iRange;
}

//---------------------------------------[Matthew Clarke - June 23 2002]-----
// 
// Description
//		Send a msg to Door's Group AI when optic cable is FINISHED using
//
//---------------------------------------------------------------------------
function UsedOnDoor(ESwingingDoor ESD)
{
    if (ESD == None)
    {
        return;
    }

	//send an EventTrigger when the Optic Cable is finished
	if (ESD.OpticCableGroupAI == None)
    {
		return;
    }

	ESD.OpticCableGroupAI.SendJumpEvent(ESD.OpticCableJumpLabel, false, false);
}

//-----------------------------------[Matthew Clarke - August 13th 2002]-----
// 
// Description
//		Send a msg to Door's Group AI when optic cable is STARTING use
//
//---------------------------------------------------------------------------
function UsingOnDoor(ESwingingDoor ESD)
{
    if (ESD == None)
    {
        return;
    }

	//send an EventTrigger when the Optic Cable is finished
	if (ESD.OpticCableGroupAIBegin == None)
    {
		return;
    }

	ESD.OpticCableGroupAIBegin.SendJumpEvent(ESD.OpticCableJumpLabelBegin, false, false);
}

function GetOpticStart()
{
	local vector X,Y,Z, min, max, BBox;
	Door.GetBoundingBox(min, max, true);
	BBox = max - min;

	GetAxes(Door.Rotation, X,Y,Z);

	// switch Y angle
	if (Door.GetPawnSide(Controller.Pawn) != ESide_Front)
		Y = -Y;

	// Door center point
	start_location = Door.Location + (min >> Door.Rotation) + ((BBox / 2.f) >> Door.Rotation);
	// X @ half way in center of door.
	// Y @ on the side
	start_location += Y * ((BBox.Y / 2.f) + 2.f);	// 2 to prevent being in door.
	// Z @ at the bottom of the door
	start_location -= Z * ((BBox.Z / 2.f) - 5.f); // -5 prevents being in floor

	camera_rotation = Rotator(Y);
	camera_rotation.Pitch += 4500;
	start_yaw		= CenterToZero(camera_rotation.Yaw);
}

// Joshua - Add optical cable interaction
function AddedToInventory()
{
	EPlayerController(Controller).OpticCableItem = self;
	Super.AddedToInventory();
}

function Select(EInventory Inv)
{
	Super.Select(Inv);
	PlaySound(Sound'Interface.Play_FisherEquipEspionCam', SLOT_Interface);
}

function HudView(bool bIn)
{
	local EPlayerController Epc;
	Epc = EPlayerController(Controller);
	//Log("HUD VIEW!!!"@bIn@Controller);
	if (bIn)
	{
		// Camera location
		Epc.SetLocation(start_location);
		// Camera rotation
		Epc.SetRotation(camera_rotation);
		
		if (!Epc.bOpticCableVisions)
			Epc.SetCameraMode(self, REN_NightVision);
		Epc.iRenderMask = 2;

		Enable('Tick');
	}
	else
	{
		Disable('Tick');

		// Joshua - Xbox was playing this sound upon leaving, so I added it to PC
		PlaySound(Sound'Interface.Play_FisherEquipEspionCam', SLOT_Interface);

		Epc.PopCamera(self);
		Epc.iRenderMask = 0;
	}
}


state s_Selected
{
	function Use()
	{
		local Vector	HitLocation, HitNormal, StartTrace, EndTrace;
		local Actor		Hit;

		StartTrace = Controller.Pawn.ToWorld(Controller.Pawn.CollisionRadius * Vect(1,0,0));
		EndTrace = StartTrace + Controller.Pawn.ToWorldDir(Vect(20,0,0));
		Hit = Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);

		// Look up door
        Door = ESwingingDoor(Hit);
		if (Door == None)
		{
			//log("Object in front is not a door");
			return;
		}
		else if (Door.bOpening || Door.bClosing)
		{
			//log("Door moving");
			return;
		}
		else if (Door.NoOpticCable)
		{
			//log("Flagged as No optic cable");
			return;
		}

		GetOpticStart();

		// send message to Owner (Controller) that item can be place
		Controller.GotoState('s_OpticCable');
	}
}

// Joshua - Optic Cable interaction
state s_InteractSelected
{
	function Use()
	{
		if (Door.bOpening || Door.bClosing || !Door.bClosed || Door.NoOpticCable)
		{
			//log("Door moving");
			return;
		}

		GetOpticStart();

		// Send message to Owner (Controller) that item can be place
		Controller.GotoState('s_OpticCable');
	}
AutoUse:
	Use();
}

state s_Sneaking
{
	function BeginState()
	{
		local EPlayerController Epc;
		Epc = EPlayerController(Controller);
		
		Disable('Tick');
		EMainHUD(Epc.myHud).Slave(self);
		ObjectHud.GotoState('s_Sneaking');

		Door.bKindaInUse = true;
        UsingOnDoor(Door);

		// Joshua - This is the original behavior of SC1, replacing it with the "Begin" state label
		// PlaySound(Sound'FisherEquipement.Play_CamEspionRun', SLOT_SFX);
	}
	
	function EndState()
	{
		local EPlayerController Epc;
		Epc = EPlayerController(Controller);

		Door.bKindaInUse = false;
        UsedOnDoor(Door);
        Door = None;

		ObjectHud.GotoState('');
	}

	function Use()
	{
		GotoState('s_Selected');
		Controller.GotoState('s_OpticCable', 'End');
	}

	function Tick(float deltaTime)
	{
		local Rotator			noised_rotation;
		local float				delta_damping;
		local int				clamped_yaw;
		local EPlayerController Epc;
		Epc = EPlayerController(Controller);

		// give rotationnary cable movement
		delta_damping	= Epc.aTurn * Damping;
		clamped_yaw		= camera_rotation.Yaw;
		clamped_yaw	   += delta_damping;
		clamped_yaw		= CenterToZero(clamped_yaw);
		
		//Log("start["$start_yaw$"] range["$65535/4$"] clamped_yaw["$clamped_yaw$"] IsInRange"@IsInRange(start_yaw, 65535/4, clamped_yaw));
		if (IsInRange(start_yaw, valid_range, clamped_yaw))
		{
			camera_rotation.Yaw	   =  clamped_yaw;
			camera_rotation.Roll   += delta_damping;

			noised_rotation			= camera_Rotation;
			noised_rotation.Roll   += (FRand() - 0.5) * delta_damping / 2;
			noised_rotation.Yaw    += (FRand() - 0.5) * delta_damping / 2;
		}
		else
			noised_rotation			= camera_rotation;

		// control Camera
		Epc.SetRotation(noised_rotation);
	}

// Joshua - This is the Pandora Tomorrow behavior of the optic cable sounds
Begin:
	PlaySound(Sound'Interface.Play_FisherEquipEspionCam', SLOT_Interface);
	Sleep(GetSoundDuration(Sound'Interface.Play_FisherEquipEspionCam'));
	PlaySound(Sound'FisherEquipement.Play_CamEspionRun', SLOT_SFX);
}

defaultproperties
{
    Damping=1000.000000
    Category=CAT_GADGETS
    ObjectHudClass=Class'EOpticCableView'
    StaticMesh=None
}