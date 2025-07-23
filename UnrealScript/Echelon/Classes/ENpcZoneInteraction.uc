class ENpcZoneInteraction extends EInteractObject;

var	EPawn					Npc;
var	EPlayerController		Epc;
var bool                    bAlreadyInterrogated; // Joshua - Flag to track if this NPC has already been interrogated

// conversation
var EPattern				ConversationPattern;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	Npc = ePawn(Owner);
	if( Npc == None )
		Log("Problem with ENpcZoneInteraction owner");

	// Spawn the conversation
	ResetConversation();

	// Set initial state
	InitialState = GetValidState();
}

function SetInteractLocation( Pawn InteractPawn )
{
	local Vector X,Y,Z, MovePos, SearchLocation;
	local Rotator SearchDir;
	local vector HitLocation, HitNormal;
	
	MovePos = Npc.Location;
	
	SearchDir = Npc.Rotation;
	SearchDir.Yaw += 16000;
	
	
	if(InteractPawn.bIsPlayerPawn)
	{
		MovePos.Z	= InteractPawn.Location.Z;									// keep on same Z
	}
	else
	{
		if( Trace(HitLocation, HitNormal, MovePos + vect(0,0,-200), MovePos,,,,,true) != None )
		{
			HitLocation.Z += InteractPawn.CollisionHeight;
			MovePos = HitLocation;
		}
	}

	InteractPawn.m_locationStart		= InteractPawn.Location;
	InteractPawn.m_orientationStart		= InteractPawn.Rotation;
	
	InteractPawn.m_locationEnd			= MovePos;
	InteractPawn.m_orientationEnd.Yaw	= SearchDir.Yaw;
	InteractPawn.m_orientationEnd.Pitch	= 0;
	InteractPawn.m_orientationEnd.Roll	= 0;
}

function Touch(Actor Other)
{
    local EAIController EAI;
    local ENPCZoneInteraction ENZIOther;
    local Vector vRotNPC;
    local Vector vRotOtherNPC;
    local float  fDot;

    if((NPC == None) || (NPC.Controller == None))
    {
        Super.Touch(Other);
        return;
    }

    EAI = EAIController(NPC.Controller);
    ENZIOther = ENPCZoneInteraction(Other);

    if((ENZIOther != None) 
    && (ENZIOther.NPC != None) 
    && (EAI != None) 
    && (EAI.AIEvent != None)
    && (EAI.Group != None))
    {
        if((NPC.GetStateName() == 's_Dying')
         ||(NPC.GetStateName() == 's_Unconscious')
         ||(ENZIOther.NPC.GetStateName() == 's_Dying')
         ||(ENZIOther.NPC.GetStateName() == 's_Unconscious'))
        {
            // Don't want to greet dead ppl, we're not making Resident Evil here 
            Super.Touch(Other);
            return;
        }

        vRotNPC = Vector(NPC.Rotation);
        vRotOtherNPC = Vector(ENZIOther.NPC.Rotation);
        fDot = vRotNPC dot vRotOtherNPC;
        
        if(fDot < -0.707) // Check if NPCs are facing each other
        {
            EAI.AIEvent.Reset();
		    EAI.AIEvent.EventType			= AI_SEE_NPC;	
		    EAI.AIEvent.EventTarget			= ENZIOther.NPC;

		    EAI.Group.AIEventCallBack(EAI, EAI.AIEvent);
        }
    }

    Super.Touch(Other);
}

function name GetValidState( optional bool bByPassGrabCheck )
{
	//Log("GetValidState"@ConversationPattern@Npc.bCanBeGrabbed@bByPassGrabCheck@Npc.GetStateName());

	// In any case, we should go into grab
	if( Npc.bCanBeGrabbed && (bByPassGrabCheck || Npc.GetStateName() != 's_Grabbed') )
		return 's_NpcGrabInteraction';
	
	// We have a conversation
	else if( ConversationPattern != None )
		return 's_NpcTalkInteraction';

	// No nothing
	else
		return 's_Disabled';
}

//------------------------------------------------------------------------
// Description		
//		Reset this conversation
//------------------------------------------------------------------------
function ResetConversation()
{
	if( Npc.PatternClass != None )
		ConversationPattern = spawn(Npc.PatternClass, self);
}

//------------------------------------------------------------------------
// Description		
//		Npc is now freed
//------------------------------------------------------------------------
function Release()
{
	//Log("Release");
	// Restore valid interaction
	SetCollision(true);

	GotoState(GetValidState(true));
}

//------------------------------------------------------------------------
// Description		
//		When a Npc gets grabbed (from EAIController)
//------------------------------------------------------------------------
function NpcGrabbed()
{
	//Log("NpcGrabbed");

	// Check to force on environment object
	if( Npc.ForceObjectOnGrab != None && Npc.ForceObjectOnGrab.Interaction != None )
		Npc.ForceObjectOnGrab.Interaction.InitInteract(Epc);
	// if there's a conversation set, change state automatically to be able to Interrogate Npc
	else if( ConversationPattern != None )
		GotoState('s_NpcTalkInteraction');
}

//------------------------------------------------------------------------
// Description		
//		When an Npc gets inert
//------------------------------------------------------------------------
function ResetInert()
{
	//Log("ResetInert");
	GotoState('s_NpcInert');
}

//------------------------------------------------------------------------
// Description		
//		Completely delete a conversation
//------------------------------------------------------------------------
function EndEvent()
{
	// Coming from EPattern when a conversation completely ends
	//Log("END EVENT FROM PATTERN");
	ConversationPattern = None;
	GotoState(GetValidState());
}

function SetStandingSize()
{
	SetCollision(true);
	SetBase(None);
	SetLocation(Npc.Location);
	SetCollisionSize(Npc.CollisionRadius + 30.0, Npc.CollisionHeight * 0.6);
	SetBase(Owner);
}

// ----------------------------------------------------------------------
// Grab interaction ready
// ----------------------------------------------------------------------
state s_NpcGrabInteraction
{
	function BeginState()
	{
		//Log("BeginState() s_NpcGrabInteraction"@InitialState);
		// move grab interaction to center of npc
		SetStandingSize();

		// GRAB
		SetPriority(100);
	}

	function bool IsAvailable()
	{
		local vector Pos, PlayerPos, offset;
		local vector testPos, testExtent;

		if(!Super.IsAvailable())
			return false;

        if(NPC.bIsDog)
        {
            return false;
        }

        if(EAIPawn(NPC).AI.IsInState('s_RetinalScanner'))
        {
            return false;           
        }

		if(InteractionPlayerController.Pawn.bIsCrouched)
		{
			testExtent.X = InteractionPlayerController.Pawn.CollisionRadius;
			testExtent.Y = testExtent.X;
			testExtent.Z = InteractionPlayerController.Pawn.default.CollisionHeight;

			testPos = InteractionPlayerController.Pawn.Location;
			testPos.Z += (testExtent.Z - InteractionPlayerController.Pawn.CollisionHeight);

			if(!InteractionPlayerController.Pawn.FastPointCheck(testPos, testExtent, true, true))
			{
				return false;
			}
		}

		Pos.X = -Npc.CollisionRadius;
		Pos = Npc.ToWorld(Pos);
		Pos.Z += InteractionPlayerController.Pawn.CollisionHeight - Npc.CollisionHeight;
		PlayerPos = InteractionPlayerController.Pawn.Location;
		offset = Pos - PlayerPos;
		// Too high or too low
		if(Abs(offset.Z) > 60.0)
			return false;

		offset.Z = 0;

		if(Npc.bIsCrouched && EAIPawn(Npc).AI.Pattern.IsInState('Hide'))
			return true;

		return (VSize(offset) < (InteractionPlayerController.Pawn.CollisionRadius + 30.0));
	}

	function string	GetDescription()
	{
			return Localize("Interaction", "NpcZone1", "Localization\\HUD");
	}

	function InitInteract( Controller Instigator )
	{
		Epc = EPlayerController(Instigator);
		if( Epc != None )
		{
			Epc.m_AttackTarget = Npc;
			Epc.GotoState('s_Grab');
		}

		SetCollision(false);
	}
}

// ----------------------------------------------------------------------
// Talk interaction ready
// ----------------------------------------------------------------------
state s_NpcTalkInteraction
{
	function BeginState()
	{
		//Log("BeginState() s_NpcTalkInteraction");
		//Log("BeginState() s_NpcGrabInteraction"@InitialState);
		// move grab interaction to center of npc
		SetStandingSize();

		bSeeToInteract = true;
	}

	function EndState()
	{
		bSeeToInteract = false;
	}

	// Called from pattern on Pawn then here to start a conversation
	function Trigger( actor Other, pawn EventInstigator, optional name InTag )
	{
		if( EchelonGameInfo(Level.Game).pPlayer != None )
		{
			Touch(EchelonGameInfo(Level.Game).pPlayer.Pawn);
			InitInteract(EchelonGameInfo(Level.Game).pPlayer);
	}
	}
	function InitInteract( Controller Instigator )
	{
		// Set the player Controller
		ConversationPattern.CommBox = EMainHUD(EPlayerController(Instigator).myHUD).CommunicationBox;

		// set the conversation
		Epc = EPlayerController(Instigator);
		ConversationPattern.Characters[0] = Instigator;
		ConversationPattern.Characters[1] = Npc.Controller;
		// Begin interrogation with a grabbed guy .. shake him
		if( Instigator.GetStateName() == 's_Grab' )
		{
			Instigator.GotoState(,'ForceInterrogate');
			// Only increment the interrogation stat if this NPC hasn't been interrogated before
			if( !bAlreadyInterrogated )
			{
				Epc.playerStats.AddStat("NPCsInterrogated");
				bAlreadyInterrogated = true;
			}
		}
		// Begin interrogation shilw walking .. just freeze
		else
		{
			Instigator.Interaction = self;
			Instigator.GotoState('s_Conversation');
		}

		// Call this after everything to prevent a pattern with only End() to mess with my state
		if( ConversationPattern.CommBox.bFree )
			GotoState('s_NpcTalking');
	}

	function bool IsAvailable()
	{
		return EMainHUD(EPlayerController(InteractionPlayerController).myHUD).CommunicationBox.bFree && Super.IsAvailable();
	}

	function string	GetDescription()
	{
		local string str;

		if( Npc.Controller.GetStateName() == 's_Grabbed' )
			str = Localize("Interaction", "NpcZone2", "Localization\\HUD");
		else
			str = Localize("Interaction", "NpcZone3", "Localization\\HUD");

		// Joshua - Removing "..." after Interrogate... and Talk To...
		return str; //$ Localize("Interaction", "NpcZone4", "Localization\\HUD"); // Joshua - Removed space after Interrogate / Talk To
	}
}

state s_NpcTalking
{
	function BeginState()
	{
		//Log("BeginState() s_NpcTalking");
		// Start conversation segment
		ConversationPattern.StartPattern();
		bSeeToInteract = true;
	}

	function EndState()
	{
		bSeeToInteract = false;

		// If conversation is running, stop it
		if( ConversationPattern != None && ConversationPattern.bConversationRunning )
			ConversationPattern.StopPattern(true);

		// Make sure the Npc getting disabled doesn't freeze Sam
		if( Epc.GetStateName() != 's_Grab' && Epc.GetStateName() != 's_GrabTargeting' && Epc.ePawn.Health > 0 )
		{
			//Log("Sending EPc in PlayerWalking");
			UnTouch(Epc.Pawn);
			Epc.Interaction = None;
			Epc.ReturnFromInteraction();
		}
	}

	function InitInteract(Controller Instigator)
	{
		// Forward interrogation (while grab) .. shake him
		if( Instigator.GetStateName() == 's_Grab' )
			Instigator.GotoState(,'ForceInterrogate');
		// Forward conversation (while walking) .. just freeze for safety should already be s_Conversation
		else if( Instigator.GetStateName() != 's_Conversation' )
		{
			Log(self$" ERROR : Player not in s_Conversation");
			Instigator.GotoState('s_Conversation');
		}

		ConversationPattern.StepForward();
	}

	function string	GetDescription()
	{
		return Localize("Interaction", "NpcZone5", "Localization\\HUD");
	}

	// Received from pattern when a conversation segment ends
	function PostInteract( Controller Instigator )
	{
		//Log("PostInteract");
		GotoState(GetValidState());
	}
}

// ----------------------------------------------------------------------
// state s_Disabled - used to temporarily turn off interaction
//		useful, e.g. when an NPC is killed - don't want to be able to 
//		grab him anymore, but don't want to enable pickup/search right away
// ----------------------------------------------------------------------
state s_Disabled
{
	Ignores InitInteract, Interact, PostInteract;

	function BeginState()
	{
		//Log("BeginState() s_Disabled");
		SetCollision(false);
	}
}

// ----------------------------------------------------------------------
// state s_NpcInert
// ----------------------------------------------------------------------
state s_NpcInert
{
	function BeginState()
	{
		//Log("BeginState() s_NpcInert");
		ResetInert();

		SetPriority(1000000);
	}

	function ResetInert()
	{
		local vector Pos;
		local float BodyLength, InteractionHeight;

		BodyLength = 60;
		InteractionHeight = 20;

		Pos = Npc.Location;
		Pos.Z -= (Npc.CollisionHeight - InteractionHeight);
		
		if ( !Npc.bNoPickupInteraction )
		{
			SetCollision(true);
			SetBase(None);
			SetLocation(Pos);
			SetBase(Owner);
			SetCollisionSize(BodyLength, InteractionHeight);
		}
	}

	function string	GetDescription()
	{
			return Localize("Interaction", "NpcZone6", "Localization\\HUD");
	}

	// Pickup calls
	function InitInteract( Controller Instigator )
	{
		local EAIController AI;

		Epc = EPlayerController(Instigator);
		if( Epc != None )
		{
			Epc.m_AttackTarget = Npc;
			if(Npc.BaseMoveFlags == MOVE_Sit)
			{
				Npc.m_slipeRight = (Vector(Npc.Rotation) cross (Npc.Location - Epc.ePawn.Location)).Z > 0.0;
				Epc.GotoState('s_PushNPCOffChair');
				Npc.GotoState(, 'FallFromChair');
			}
			else
			{
				Epc.ePawn.m_locationStart		= Epc.ePawn.Location;
				Epc.ePawn.m_locationEnd			= Npc.Location;
				Epc.ePawn.m_orientationStart	= Epc.ePawn.Rotation;
				Epc.ePawn.m_orientationEnd.Yaw	= Npc.Rotation.Yaw + 16384;
				Epc.ePawn.m_orientationEnd.Pitch= 0;
				Epc.ePawn.m_orientationEnd.Roll	= 0;
				Epc.GotoState('s_Carry');
			}
		}
		else
		{
			Instigator.GotoState('s_ReviveAnotherNPC');
			SetCollision(false);
		}
	}

	function bool IsAvailable()
	{
		local float offsetZ;
		local vector offset;

        if(NPC.bIsDog)
        {
            return false;
        }

		offset = Npc.Location - InteractionPlayerController.Pawn.Location;
		offsetZ = offset.Z;
		offset.Z = 0.0;

		if(Npc.BaseMoveFlags == MOVE_Sit)
		{
			return VSize(offset) < 80;
		}

		if(!Super.IsAvailable())
			return false;

		offsetZ += InteractionPlayerController.Pawn.CollisionHeight - Npc.CollisionHeight;
		return (offsetZ < 30.0);
	}

	// Interaction allows unconscious NPCs to be revived by other NPCs.
	function Interact( Controller Instigator )
	{
		if( Instigator.bIsPlayer )
			return; // impossible

		// I'm revived by Instigator
		EAIController(Npc.Controller).Revive();
	}
}

defaultproperties
{
    bIsNPCRelevant=true
}