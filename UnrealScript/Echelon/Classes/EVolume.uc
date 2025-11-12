class EVolume extends PhysicsVolume
	native;

#exec OBJ LOAD FILE=..\Sounds\ThrowObject.uax
#exec OBJ LOAD FILE=..\Sounds\FisherEquipement.uax

var() enum EProximity
{
	PlayerProximity,	
	NPCProximity,	    
	PawnProximity

} ProximityType;


var actor			  PlayerPawn;

//AI

var() array<PathNode> StrategicPoints;
var() array<Actor>    GrenadePoints;
var()  Name			  GroupTag;
var()  Name			  JumpLabel;
var() EGameplayObject LightSwitch;
var() EPawn			  PawnTrigger;
var()  Name			  ForceFocusTag;

var	   float		  TriggerTime;

var()  bool			  bTriggerOnlyOnce;
var()  bool			  bIsAnEventtrigger;
var()  bool			  bGrenadeAllowed;
var()  bool			  bUseGrenadePoints;
var()  bool			  bAffectLastZone;
var()  bool			  bForceJump;   //override disable messages of the pattern
var()  bool			  bDontUseIfPlayerSeen;
var()  bool			  bFlashlightVolume;
var()  bool			  bSavegame;
var()  bool			  bExplosiveVolume;
var()  bool			  bDetectCarriedPawn;
var	   bool			  bAlreadyVisited;

// Camera
var(Camera)	EVolumeSize VolumeSize;

// Ambient flags
var(Ambience) bool		bColdZone;
var(Ambience) bool		bLiquid;
var(Ambience) bool		bDyingZone;

var(FootPrint) int		iDirtynessFactor;

function PostBeginPlay()
{
	local EAIPawn P;

	Super.PostBeginPlay();

	ForEach TouchingActors(class'EAIPawn', P)
	{
		P.SetVolumeZone(true, self);
	}
	
	// JFPDemoPatch, november 16th 2002:
	//               With the new menu system the game freezes when we try to save from the checkpoints.
	//               We go to the save state, but we can't render the message box, so we can't continue since
	//               we're stuck in this state. Bypass all saves for now.
	// Joshua - bSaveGame must be true in order to have PC checkpoints
	//	bSavegame = false;
}

function CheckExplosive(Actor weapon, Pawn Instigator)
{
	local Actor A;
	local vector mom;
	if (bExplosiveVolume)
	{
		ForEach TouchingActors(class'Actor',A)
		{
			mom = Normal(A.Location - weapon.Location);
			A.TakeDamage(1000, Instigator, A.Location, -mom, mom * 20000, class'EBurned');
		}
		Spawn(class'EExplosion', weapon);
		PlaySound(Sound'FisherEquipement.Play_WallMineExplosion', SLOT_SFX);
	}

}

// override damage stuff from PhysicsVolume
function Trigger(actor Other, pawn EventInstigator, optional name InTag) // UBI MODIF - Additional parameter
{
	SetCollision(!bCollideActors);
}

function bool IsRelevant(actor Other)
{
	switch (ProximityType)
	{
		case PlayerProximity:
			return Other.bIsPawn && Pawn(Other).IsPlayerPawn();
		case NPCProximity:
			return Other.bIsPawn && (EAIController(Pawn(Other).controller) != None) && (Other.GetStateName() != 's_Carried' || bDetectCarriedPawn);
		case PawnProximity:
				if (Other.GetStateName() != 's_Carried' || bDetectCarriedPawn)
				{
				if (PawnTrigger != None)
				{
					if (PawnTrigger == Other)
						return true;
					else
						return false;
				}
				else
				{
					return Other.bIsPawn;
				}
				}
				else
					return false;

			
	}
}

function Touch(actor Other)
{
	local Pawn Player;
	local EGroupAI Group;
	local EGameplayObject EGO;

	Super.Touch(Other);

	if ((bSavegame) 
     && (Other.bIsPlayerPawn) 
     && (EPawn(Other).Controller != None) 
	 && ((!EchelonGameInfo(Level.Game).bEliteMode && EchelonLevelInfo(Level).AlarmStage < 4)
	 || (EchelonGameInfo(Level.Game).bEliteMode && EchelonLevelInfo(Level).AlarmStage < 3)) // Joshua - Elite only allows for 3 alarms
	 && !IsGameOver()) // Do not save if the player is about to be put GameOver because of the alarm stage
	{
		// Joshua - New method to add PC checkpoints
		if (EchelonGameInfo(level.Game).bEnableCheckpoints)
		{
			EPlayerController(EPawn(Other).Controller).bAutoSaveLoad = true;
			EPlayerController(EPawn(Other).Controller).bSavingTraining = true;
			EPlayerController(EPawn(Other).Controller).bCheckpoint = true;
			EPlayerController(EPawn(Other).Controller).CheckpointLevel = GetCurrentMapName();
			ConsoleCommand("SAVEGAME FILENAME=" $ Localize("Common", "CheckpointName", "Localization\\Enhanced") $ " OVERWRITE=TRUE");
		}
		bSavegame = false;
	}
	else if (bIsAnEventtrigger)
	{
		if (!((bAlreadyVisited) && (bTriggerOnlyOnce)))
		{
			if (IsRelevant(Other))
			{
				//if (Level.TimeSeconds - TriggerTime < 0.2)
				//	return;
				//TriggerTime = Level.TimeSeconds;

				//set visited flag
				bAlreadyVisited = true;

				foreach DynamicActors(class'EGroupAI', Group, GroupTag)
				{
					Group.SendJumpEvent(JumpLabel,bAffectLastZone,bForceJump);
					break; 
				}			
			}
			
		}

	}
	else if (!bFlashlightVolume)
	{
		// make sure not touching through wall
		Player = Pawn(Other);
		if (Player != None && Player.Controller != None)
		{
			//be sure it's only the player
			if (Player.controller.bIsPlayer)
			{
				//set the current zone in the player controller
				EPlayerController(Player.controller).CurrentVolume = self;
			}
		}
	}

	// As soon as cylinder touches, let go of camera and pop message
	// Perhaps player is dead, always use a valid EPlayerController pointer
	if (bDyingZone && Other.bIsPlayerPawn)
	{
		EchelonGameInfo(Level.Game).pPlayer.bInvincible = true;
		EchelonGameInfo(Level.Game).pPlayer.m_camera.GotoState('s_Fixed');
		EchelonGameInfo(Level.Game).pPlayer.EndMission(false, 0);
	}

	EGO = EGameplayObject(Other);
	if (EGO != None && bLiquid)
	{
		if (EGO.bIsProjectile)
			EGO.PlaySound(Sound'ThrowObject.Play_WaterImpact', SLOT_SFX);
	}

}

function UnTouch(actor Other)
{
	local Pawn       Player;

	Super.UnTouch(Other);

	if (!bIsAnEventtrigger && !bFlashlightVolume)
	{
		Player = Pawn(Other);
		if (Player != None && Player.Controller != None)
		{
			if (Player.controller.bIsPlayer)
			{
				//set the current zone in the player controller
				if (EPlayerController(Player.controller).CurrentVolume == self)
					EPlayerController(Player.controller).CurrentVolume = none;
			}
		}
	}
}

function PawnEnteredVolume(Pawn P)
{
	local EPawn ePawn;
	ePawn = EPawn(P);

	Super.PawnEnteredVolume(P);

	if (ePawn == None)
		Log(self$" ERROR: Pawn entering volume is not a Pawn!"@P);

	ePawn.SetVolumeZone(true, self);

	if ((LightSwitch != None) && (EAIController(ePawn.controller) != None) && (PawnTrigger != None))
	{
		if (PawnTrigger == ePawn)
		{
			if (EAIController(ePawn.controller).pattern != None)
			{
				if (EAIController(ePawn.controller).pattern.GetStateName() == 'search')
					EAIController(ePawn.controller).pattern.CheckSwitchAlreadyLocked(1,LightSwitch);
			}
		}
	}
}

function PawnLeavingVolume(Pawn P)
{
	local EPawn ePawn;
	ePawn = EPawn(P);

	Super.PawnLeavingVolume(P);

	if (ePawn == None)
		Log(self$" ERROR: Pawn leaving volume is not a Pawn!"@P);

	ePawn.SetVolumeZone(false, self);
}

defaultproperties
{
    bAffectLastZone=true
    bDetectCarriedPawn=true
    bStatic=false
}