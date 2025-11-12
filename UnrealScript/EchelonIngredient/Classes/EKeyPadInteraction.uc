class EKeyPadInteraction extends EPopObjectInteraction;

var EKeyPad		MyKeyPad;

function PostBeginPlay()
{
	GetKeyPad();
	Super.PostBeginPlay();
}

function string	GetDescription()
{
	return Localize("Interaction", "KeyPad", "Localization\\HUD");
}

function bool IsAvailable()
{
	return MyKeyPad.GetStateName() == 's_Idle' && Super.IsAvailable();
}

function LockOwner(bool bLocked)
{
	if (MyKeyPad == None)
		return;

	if (bLocked)
		MyKeyPad.GotoState('s_Use');
	else
		MyKeyPad.GotoState('s_Idle');
}

function InitInteract(Controller Instigator)
{
	if (MyKeyPad == None || MyKeyPad.LinkedActors.Length == 0)
	{
		Log("Something wrong in EKeyPadInteraction"@Owner@MyKeyPad.LinkedActors.Length);
		return;
	}

	Super.InitInteract(Instigator);

	// Lock as soon as used.  Npc lock it upon reaching the keypad
	if (Instigator.bIsPlayer)
		LockOwner(true);
	Instigator.GotoState('s_KeyPadInteract');
}

function GetKeyPad()
{
	MyKeyPad = EKeyPad(Owner);
	if (MyKeyPad == None)
		Log("ERROR: problem with EKeyPadInteraction owner "$Owner);
}

function SetInteractLocation(Pawn InteractPawn)
{
	local Vector X, Y, Z, MovePos;
	local EPawn InteractEPawn;
	local vector HitLocation, HitNormal;
	
	InteractEPawn = EPawn(InteractPawn);
	
	if (InteractEPawn != none)
	{	
		// get MyKeyPad object rotation axes for positioning
		GetAxes(MyKeyPad.Rotation, X, Y, Z);
		MovePos = MyKeyPad.Location;

		MovePos += (1.3f * InteractEPawn.CollisionRadius) * X;

		if (InteractEPawn.bIsPlayerPawn)
		{
			MovePos.Z	= InteractEPawn.Location.Z;									// keep on same Z
		}
		else
		{
			if (Trace(HitLocation, HitNormal, MovePos + vect(0,0,-200), MovePos,,,,,true) != None)
			{
				HitLocation.Z += InteractEPawn.CollisionHeight;
				MovePos = HitLocation;
			}
		}

		InteractEPawn.m_locationStart	= InteractEPawn.Location;
		InteractEPawn.m_orientationStart= InteractEPawn.Rotation;
		InteractEPawn.m_locationEnd		= MovePos;
		InteractEPawn.m_orientationEnd	= Rotator(-X);
	}
}

function KeyEvent(String Key, EInputAction Action, float Delta, optional bool bAuto)
{
	
	local EPlayerController EPC; // Joshua - Adding controller support for keypads
	local int OldSelectedButton; // Joshua - Adding NumPad support for keypads
	EPC = EPlayerController(EKeyPadInteraction(Interaction).InteractionController);
	
	// Process Npc interaction
	if (bAuto)
	{
		Action		= IST_Press;
		Key			= "Interaction";
		MyKeyPad.SelectedButton	= GetValidkey();
		if (MyKeyPad.SelectedButton == -1)
			return;
	}

	if (MyKeyPad.GetStateName() != 's_Use')
		return;

	if (Action == IST_Press)
	{
		// Joshua - Start of NumPad support
		OldSelectedButton = MyKeyPad.SelectedButton;
        switch (Key)
		{
		case "Keypad_NumPad0":
		    MyKeyPad.SelectedButton = 10;
			MyKeyPad.KeyPushed();
			break;
        case "Keypad_NumPad1":
		    MyKeyPad.SelectedButton = 0;
			MyKeyPad.KeyPushed();
			break;
        case "Keypad_NumPad2":
		    MyKeyPad.SelectedButton = 1;
			MyKeyPad.KeyPushed();
			break;
        case "Keypad_NumPad3":
		    MyKeyPad.SelectedButton = 2;
			MyKeyPad.KeyPushed();
			break;
        case "Keypad_NumPad4":
		    MyKeyPad.SelectedButton = 3;
			MyKeyPad.KeyPushed();
			break;
        case "Keypad_NumPad5":
		    MyKeyPad.SelectedButton = 4;
			MyKeyPad.KeyPushed();
			break;
        case "Keypad_NumPad6":
		    MyKeyPad.SelectedButton = 5;
			MyKeyPad.KeyPushed();
			break;
        case "Keypad_NumPad7":
		    MyKeyPad.SelectedButton = 6;
			MyKeyPad.KeyPushed();
			break;
        case "Keypad_NumPad8":
		    MyKeyPad.SelectedButton = 7;
			MyKeyPad.KeyPushed();
			break;
        case "Keypad_NumPad9":
		    MyKeyPad.SelectedButton = 8;
			MyKeyPad.KeyPushed();
			break;
        case "Keypad_NumPadPeriod":
		    MyKeyPad.SelectedButton = 11;
			MyKeyPad.KeyPushed();
			break;
        case "Keypad_GreyStar":
        case "Keypad_Backspace":
		    MyKeyPad.SelectedButton = 9;
			MyKeyPad.KeyPushed();
			break;
		}
		// Joshua - End of NumPad support
		switch (Key)
		{
		case "AnalogUp" :
		case "MoveForward" :
			if (MyKeyPad.SelectedButton > 2)
				MyKeyPad.SelectedButton -= 3;
			break;

		case "AnalogDown" :
		case "MoveBackward" :
			if (MyKeyPad.SelectedButton < 9)
				MyKeyPad.SelectedButton += 3;
			break;
		
		case "AnalogLeft" :
		case "StrafeLeft" :
			if (MyKeyPad.SelectedButton > 0 && MyKeyPad.SelectedButton % 3 != 0)
				MyKeyPad.SelectedButton -= 1;
			break;
		
		case "AnalogRight" :
		case "StrafeRight" :
			if (MyKeyPad.SelectedButton < 11 && (MyKeyPad.SelectedButton + 1) % 3 != 0)
				MyKeyPad.SelectedButton += 1;
			break;
		
		case "Fire" :
			PostInteract(InteractionController);
			break;

		case "Interaction" :
			if (!EPC.eGame.bUseController) // Joshua - Adding controller support for keypads
				if (bAuto)
					MyKeyPad.KeyPushed();
			else
				MyKeyPad.KeyPushed();
			break;
		}
		
		// Joshua - Adding NumPad support for keypads
		if (OldSelectedButton != MyKeyPad.SelectedButton)
		   MyKeyPad.GlowSelected();
	}
}

//------------------------------------------------------------------------
// Description		Must return the valid key for Npc
//------------------------------------------------------------------------
function int GetValidkey()
{
	local int i, Index;

	Index = Len(MyKeyPad.Inputedcode);
	for (i = 0; i < ArrayCount(MyKeyPad.KeyButtons); i++)
	{
		if (MyKeyPad.KeyButtons[i].Value == Mid(MyKeyPad.AccessCode, Index, 1))
			return i;
	}

	return -1;
}

// Joshua - Keypad hint
function bool CheckKeyCode(Controller Instigator, string Key)
{
	local EPlayerController Epc;
	local EListNode Node ;
	local ENote Note;

	Epc = EPlayerController(Instigator);

	if (Epc == None)
		return false;

	Node = Epc.NoteBook.FirstNode;
	While (Node != None)
	{
		Note = ENote(Node.Data);
		if ((Note !=None) && (InStr(Note.Note, Key)>-1))
		{
			return true;
		}
		Node = Node.NextNode;
	}

	return false;
}

function Touch(actor Other)
{
	local Pawn P;
	local EPlayerController EPC;

	Super.Touch(Other);

	P = Pawn(Other);
	if (P == None || !P.bIsPlayerPawn || P.Controller == None)
		return;

	EPC = EPlayerController(P.Controller);

	if (EPC != None && EPC.CanAddInteract(self) && IsAvailable() && CheckKeyCode(EPC, MyKeyPad.AccessCode))
	{
		EPC.CurrentGoal = Localize("HUD", "Keypad_Goal", "Localization\\Enhanced")@MyKeyPad.AccessCode;
		EPC.bShowKeyNum = true;
	}
}

function UnTouch(actor Other)
{
	local Pawn P;
	local EPlayerController EPC;

	EPC = EPlayerController(InteractionPlayerController);

	Super.UnTouch(Other);

	if (EPC != None && InteractionController == None)
	{
		EPC.RefreshGoals();
		EPC.bShowKeyNum = false;
	}
}

defaultproperties
{
    ViewRelativeLocation=(X=15.000000,Y=-4.000000,Z=0.000000)
    ViewRelativeRotation=(Pitch=-2000,Yaw=32768,Roll=0)
}