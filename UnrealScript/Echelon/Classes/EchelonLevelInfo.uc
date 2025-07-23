class EchelonLevelInfo extends LevelInfo
	native;

#exec OBJ LOAD FILE=..\Animations\ESam.ukx

var(LevelPattern)		class<EPattern>			PatternClass;
var(LevelPattern)		class<EPattern>			StartPatternClass;
var(LambertWarnings)    class<EPattern>			AlarmPatternClass;
var(Sound)				bool					bMusicEnabled;
var(AI)					bool					bAllowFlashlightsEverywhere;
var(AI)					bool					bOnlyUseSingleShot;
var(AI)                 bool                    bIgnoreAlarmStage;
var(AI)					bool					bLiteWarnings;
var(Cinematic)			Array<MeshAnimation>	SpecialEventAnims;
var(Recons)				array<class<ERecon> >	Recons;
var(InventoryItems)		array<class<EInventoryItem> >	InventoryItems;
var(SamMesh)			Mesh					SamMesh;

var						EPattern				Pattern;
var						EPattern				AlarmPattern;

var(DataBank) editconst	Array<EMemoryStick>		MemoryBank;

var						EInfoPoint				InfoPointList;

var						int						AlarmStage;
var						float					AlarmModifier[5];

var                     float                   afLastBarked[44]; 
var						float					LastWhistleTime;
var						Sound					RandomWhistle;

// ladder lock mechanism
struct SLadderLock
{	
	var Pawn     LockingPawn;
	var int		 GEID;
	var byte	 LockInfo;
};

var array<SLadderLock> LadderLockArray;

var(Sound) EMusic	MusicObj;

var Sound  FindCorpseSound;

var ETGAME TGAME; // Super Texture - Put here to be accessible everywhere
var ETMENU TMENU; // Super Texture - Put here to be accessible everywhere
var ETICON TICON; // Super Texture - Put here to be accessible everywhere

//---------------------------------------[Frederic Blais - 20 Nov 2001]-----
// 
// PostBeginPlay
//
//------------------------------------------------------------------------
function PostBeginPlay()
{
	local EMemoryStick Ms;
    local int i;
	local EEventTrigger EventTrigger;
	local Actor A;

	// Joshua - Apply TurnOffDistance scaling based on user settings
    switch(EchelonGameInfo(Level.Game).TurnOffDistanceScale)
    {
        case TurnOffDistance_1x:
            // Default behavior, keep original values
            break;
            
        case TurnOffDistance_2x:
            // Multiply all actor TurnOffDistance values by 2
            ForEach DynamicActors(class'Actor', A)
            {
                if (A.TurnOffDistance > 0)
                {
                    A.TurnOffDistance = A.TurnOffDistance * 2;
                }
            }
            break;
            
        case TurnOffDistance_4x:
            // Multiply all actor TurnOffDistance values by 4
            ForEach DynamicActors(class'Actor', A)
            {
                if (A.TurnOffDistance > 0)
                {
                    A.TurnOffDistance = A.TurnOffDistance * 4;
                }
            }
            break;
            
        case TurnOffDistance_8x:
            // Multiply all actor TurnOffDistance values by 8
            ForEach DynamicActors(class'Actor', A)
            {
                if (A.TurnOffDistance > 0)
                {
                    A.TurnOffDistance = A.TurnOffDistance * 8;
                }
            }
            break;
    }

	// Joshua - Assigning new default meshes to these levels
	switch(GetCurrentMapName())
	{
		case "1_3_2CaspianOilRefinery":
        case "1_3_3CaspianOilRefinery": 
                EchelonLevelInfo(Level).SamMesh = SkeletalMesh'ESam.samCMesh';
                break;

        case "2_1_0CIA":
        case "2_1_1CIA":
        case "2_1_2CIA":
                EchelonLevelInfo(Level).SamMesh = SkeletalMesh'ESam.samBMesh';
                break;

        case "4_2_1_Abattoir":
        case "4_2_2_Abattoir":
                EchelonLevelInfo(Level).SamMesh = SkeletalMesh'ESam.samCMesh';
                break;

        case "4_3_0ChineseEmbassy":
        case "4_3_1ChineseEmbassy":
		case "4_3_2ChineseEmbassy":
				EchelonLevelInfo(Level).SamMesh = SkeletalMesh'ESam.samCMesh';
				break;

		case "1_6_1_1KolaCell":
				EchelonLevelInfo(Level).SamMesh = SkeletalMesh'ESam.samAMesh';
				break;
	}

	// Joshua - Disable initial pattern from this event trigger, moving it to EchelonPlayerStart
	if (GetCurrentMapName() == "3_4_3Severonickel")
	{
		ForEach AllActors(class'EEventTrigger', EventTrigger)
		{
			if(EventTrigger.name == 'EEventTrigger10')
			{
				EventTrigger.SetCollision(False);
				EventTrigger.GroupTag = '';
				EventTrigger.JumpLabel = '';
			}
		}
	}

	// Joshua - Enabling alarm stages for Vselka
	if (GetCurrentMapName() == "1_7_1_1VselkaInfiltration")
        bIgnoreAlarmStage = false;

    
    TGAME = spawn(class'ETGAME', self);
    TMENU = spawn(class'ETMENU', self);
    TICON = spawn(class'ETICON', self);

	// Add all the memoryStick in the map in the bank
	ForEach DynamicActors(class'EMemoryStick', Ms)
	{
		MemoryBank[MemoryBank.Length] = Ms;
		Ms.Bank = self;
	}

	////////////////////////////////////////////////////////
	//spawn the level pattern
	if(PatternClass !=  None)
	{
		Pattern	= Spawn(PatternClass, self);
	}

	///////////////////////////////////////////////////////
	//spawn the lambert warnings patterns
	if(AlarmPatternClass != None)
	{
		AlarmPattern	= Spawn(AlarmPatternClass, self);
	}

/*
	for(i=0; i<ImpactSurfaceToEmitterLink.length; i++)
	{
		log("ImpactSurfaceToEmitterLink["$i$"].surfType="$ImpactSurfaceToEmitterLink[i].surfType$";");
		log("ImpactSurfaceToEmitterLink["$i$"].emitterClass=class'"$ImpactSurfaceToEmitterLink[i].emitterClass$"';");
	}
*/
	pProjTexture=texture'impact01';

	ImpactSurfaceToEmitterLink.length=12;
	ImpactSurfaceToEmitterLink[0].surfType=SURFACE_ConcreteHard;
	ImpactSurfaceToEmitterLink[0].emitterClass=class'EchelonEffect.EImpactStone';
	ImpactSurfaceToEmitterLink[1].surfType=SURFACE_BreakingGlass;
	ImpactSurfaceToEmitterLink[1].emitterClass=class'EchelonEffect.EGlassSmallParticleB';
	ImpactSurfaceToEmitterLink[2].surfType=SURFACE_WoodHard;
	ImpactSurfaceToEmitterLink[2].emitterClass=class'EchelonEffect.EImpactWood';
	ImpactSurfaceToEmitterLink[3].surfType=SURFACE_DeepWater;
	ImpactSurfaceToEmitterLink[3].emitterClass=class'EchelonEffect.EImpactWater';
	ImpactSurfaceToEmitterLink[4].surfType=SURFACE_ConcreteDirt;
	ImpactSurfaceToEmitterLink[4].emitterClass=class'EchelonEffect.EImpactStone';
	ImpactSurfaceToEmitterLink[5].surfType=SURFACE_Grass;
	ImpactSurfaceToEmitterLink[5].emitterClass=class'EchelonEffect.EImpactGrass';
	ImpactSurfaceToEmitterLink[6].surfType=SURFACE_WoodBoomy;
	ImpactSurfaceToEmitterLink[6].emitterClass=class'EchelonEffect.EImpactWood';
	ImpactSurfaceToEmitterLink[7].surfType=SURFACE_RoofTile;
	ImpactSurfaceToEmitterLink[7].emitterClass=class'EchelonEffect.EGlassSmallParticleB';
	ImpactSurfaceToEmitterLink[8].surfType=SURFACE_WaterPuddle;
	ImpactSurfaceToEmitterLink[8].emitterClass=class'EchelonEffect.EImpactWater';
	ImpactSurfaceToEmitterLink[9].surfType=SURFACE_Bush;
	ImpactSurfaceToEmitterLink[9].emitterClass=class'EchelonEffect.EImpactLeaf';
	ImpactSurfaceToEmitterLink[10].surfType=SURFACE_Sand;
	ImpactSurfaceToEmitterLink[10].emitterClass=class'EchelonEffect.EImpactStone';
	ImpactSurfaceToEmitterLink[11].surfType=SURFACE_Carpet;
	ImpactSurfaceToEmitterLink[11].emitterClass=none;

	ImpactSurfaceToSubTexLink.length=14;
	ImpactSurfaceToSubTexLink[0].surfType=SURFACE_ConcreteHard;
	ImpactSurfaceToSubTexLink[0].X=192;
	ImpactSurfaceToSubTexLink[0].Y=64;
	ImpactSurfaceToSubTexLink[0].Width=32;
	ImpactSurfaceToSubTexLink[0].Height=32;
	ImpactSurfaceToSubTexLink[0].Scale=0.50;
	ImpactSurfaceToSubTexLink[1].surfType=SURFACE_ConcreteDirt;
	ImpactSurfaceToSubTexLink[1].X=64;
	ImpactSurfaceToSubTexLink[1].Y=92;
	ImpactSurfaceToSubTexLink[1].Width=32;
	ImpactSurfaceToSubTexLink[1].Height=32;
	ImpactSurfaceToSubTexLink[1].Scale=0.40;
	ImpactSurfaceToSubTexLink[2].surfType=SURFACE_Carpet;
	ImpactSurfaceToSubTexLink[2].X=160;
	ImpactSurfaceToSubTexLink[2].Y=0;
	ImpactSurfaceToSubTexLink[2].Width=32;
	ImpactSurfaceToSubTexLink[2].Height=32;
	ImpactSurfaceToSubTexLink[2].Scale=0.40;
	ImpactSurfaceToSubTexLink[3].surfType=SURFACE_MetalReverb;
	ImpactSurfaceToSubTexLink[3].X=192;
	ImpactSurfaceToSubTexLink[3].Y=0;
	ImpactSurfaceToSubTexLink[3].Width=32;
	ImpactSurfaceToSubTexLink[3].Height=32;
	ImpactSurfaceToSubTexLink[3].Scale=0.25;
	ImpactSurfaceToSubTexLink[4].surfType=SURFACE_Generic;
	ImpactSurfaceToSubTexLink[4].X=96;
	ImpactSurfaceToSubTexLink[4].Y=64;
	ImpactSurfaceToSubTexLink[4].Width=32;
	ImpactSurfaceToSubTexLink[4].Height=32;
	ImpactSurfaceToSubTexLink[4].Scale=0.25;
	ImpactSurfaceToSubTexLink[5].surfType=SURFACE_MetalSheet;
	ImpactSurfaceToSubTexLink[5].X=160;
	ImpactSurfaceToSubTexLink[5].Y=32;
	ImpactSurfaceToSubTexLink[5].Width=32;
	ImpactSurfaceToSubTexLink[5].Height=32;
	ImpactSurfaceToSubTexLink[5].Scale=0.25;
	ImpactSurfaceToSubTexLink[6].surfType=SURFACE_BreakingGlass;
	ImpactSurfaceToSubTexLink[6].X=96;
	ImpactSurfaceToSubTexLink[6].Y=96;
	ImpactSurfaceToSubTexLink[6].Width=64;
	ImpactSurfaceToSubTexLink[6].Height=64;
	ImpactSurfaceToSubTexLink[6].Scale=1.00;
	ImpactSurfaceToSubTexLink[7].surfType=SURFACE_WoodHard;
	ImpactSurfaceToSubTexLink[7].X=64;
	ImpactSurfaceToSubTexLink[7].Y=64;
	ImpactSurfaceToSubTexLink[7].Width=32;
	ImpactSurfaceToSubTexLink[7].Height=32;
	ImpactSurfaceToSubTexLink[7].Scale=0.40;
	ImpactSurfaceToSubTexLink[8].surfType=SURFACE_MetalHard;
	ImpactSurfaceToSubTexLink[8].X=192;
	ImpactSurfaceToSubTexLink[8].Y=0;
	ImpactSurfaceToSubTexLink[8].Width=32;
	ImpactSurfaceToSubTexLink[8].Height=32;
	ImpactSurfaceToSubTexLink[8].Scale=0.25;
	ImpactSurfaceToSubTexLink[9].surfType=SURFACE_Snow;
	ImpactSurfaceToSubTexLink[9].X=128;
	ImpactSurfaceToSubTexLink[9].Y=64;
	ImpactSurfaceToSubTexLink[9].Width=32;
	ImpactSurfaceToSubTexLink[9].Height=32;
	ImpactSurfaceToSubTexLink[9].Scale=0.25;
	ImpactSurfaceToSubTexLink[10].surfType=SURFACE_RoofTile;
	ImpactSurfaceToSubTexLink[10].X=192;
	ImpactSurfaceToSubTexLink[10].Y=64;
	ImpactSurfaceToSubTexLink[10].Width=32;
	ImpactSurfaceToSubTexLink[10].Height=32;
	ImpactSurfaceToSubTexLink[10].Scale=0.25;
	ImpactSurfaceToSubTexLink[11].surfType=SURFACE_WoodBoomy;
	ImpactSurfaceToSubTexLink[11].X=64;
	ImpactSurfaceToSubTexLink[11].Y=64;
	ImpactSurfaceToSubTexLink[11].Width=32;
	ImpactSurfaceToSubTexLink[11].Height=32;
	ImpactSurfaceToSubTexLink[11].Scale=0.40;
	ImpactSurfaceToSubTexLink[12].surfType=SURFACE_RoofCanevas;
	ImpactSurfaceToSubTexLink[12].X=160;
	ImpactSurfaceToSubTexLink[12].Y=32;
	ImpactSurfaceToSubTexLink[12].Width=32;
	ImpactSurfaceToSubTexLink[12].Height=32;
	ImpactSurfaceToSubTexLink[12].Scale=0.25;
	ImpactSurfaceToSubTexLink[13].surfType=SURFACE_Sand;
	ImpactSurfaceToSubTexLink[13].X=192;
	ImpactSurfaceToSubTexLink[13].Y=64;
	ImpactSurfaceToSubTexLink[13].Width=32;
	ImpactSurfaceToSubTexLink[13].Height=32;
	ImpactSurfaceToSubTexLink[13].Scale=0.50;
	
	Super.PostBeginPlay();
}

//--------------------------------[Matthew Clarke - August 19th 2002]-----
// 
// Description
//		Gets NPCs to bark every 10 secs
//
//------------------------------------------------------------------------
function Timer()
{
    local int           iAttack;
    local int           iSearch;
    local int           iIdle;
    local int           iSeeingPlayer;
    local int           iGrabbed;
    local bool           bSawPlayerOnce;
    local float         fSpeedTotal;
    local bool          bMoveOrCharge;
    local bool          bPlayerIsFiring;
    local Controller    C;
    local EAIController AI;
    local EAIController Searcher;
    local EAIController Attacker;

    if((EchelonGameInfo(Level.Game).pPlayer == None) 
       ||(EchelonGameInfo(Level.Game).pPlayer.pawn.Health <=0))
    {
        // Do not bark if player is dead
        return;
    }

    for (C = Level.ControllerList; C != None; C = C.nextController)  
    {
        AI = EAIController(C);

        if((AI == None) 
        || (AI.EPawn.bIsDog)
        || (AI.GetStateName() == 's_Unconscious'))
        {
            continue;
        }

        // Check if its an NPC firing at some gameplay object
        if((AI.m_pGoalList.GetCurrent().m_GoalType == GOAL_Attack) 
        && ((AI.m_pGoalList.GetCurrent().GoalTarget) != (EchelonGameInfo(Level.Game).pPlayer.Pawn)))
        {
            continue;
        }

        if(AI.GetStateName() == 's_Grabbed')
        {
            iGrabbed++;
        }

        
        if(AI.Pattern != None)
        {
            if(AI.Pattern.GetStateName() == 'attack')
            {
                if(AI.bPlayerSeen)
                {
                    iSeeingPlayer++;
                }

                if (AI.EPawn.bSniper)
                {
                    // Check if snipers see player but dont use them to talk with
                    continue;
                }

                iAttack++; 

				if(Attacker != None)
				{
					if( FRand() > 0.4 )
                Attacker = AI;
				}
				else
				{
	                Attacker = AI;
				}

                fSpeedTotal += VSize(AI.Pawn.Velocity);

                if((AI.m_pGoalList.GetCurrent().m_GoalType == GOAL_MoveAndAttack )
                    || AI.m_pGoalList.GetCurrent().m_GoalType == GOAL_Charge )
                {
                    bMoveOrCharge = true;
                }

                if(AI.TargetIsFiring())
                {
                    bPlayerIsFiring = true;
                }

            }
            else if(AI.Pattern.GetStateName() == 'search')
            {
                if(AI.LastKnownPlayerTime != 0)
                {
                    bSawPlayerOnce = true;

					if(Searcher != None)
					{
						if( FRand() > 0.4 )
							Searcher = AI;
					}
					else
					{
                    Searcher = AI;
                }
                }

                iSearch++;                
            }
            else
            {
                iIdle++;
            }
        }
    }

    // 2+ guys attacking sam
    if ((iAttack > 1)
     && (iGrabbed == 0) 
     && (Attacker != None) 
     && (Attacker.Group != None) 
     && (Attacker.Group.PlayerHasBeenSeen()))
    {
        // BARK_AttackMove
        if((bMoveOrCharge) && (fSpeedTotal != 0.0))
        {
            EPawn(Attacker.Pawn).PlayAttackMove(); 
        }
        // BARK_LookingForYou        
        else if(iSeeingPlayer == 0)
        {
            if(ePawn(Attacker.Pawn).ICanBark())
            {
				ePawn(Attacker.Pawn).Bark_Type = BARK_LookingForYou;
	            Attacker.Pawn.PlaySound(ePawn(Attacker.Pawn).Sounds_Barks, SLOT_Barks);    

                if(ePawn(Attacker.Pawn).bIsHotBlooded)
                {
                    Attacker.TimedForceFire();
                }
            }
        }
        // BARK_AttackGetDown       
        else if(bPlayerIsFiring)
        {
            EPawn(Attacker.Pawn).PlayAttackGetDown();
        }
        // BARK_AttackStop        
        else if(fSpeedTotal == 0.0)
        {
            EPawn(Attacker.Pawn).PlayAttackStop();   
        }
    }
    // 1 guy attacking Sam, and not seeing him - just use the BARK_LookingForYou
    else if((iAttack == 1) 
         && (iGrabbed == 0) 
         && (Attacker != None) 
         && (Attacker.Group != None) 
         && (Attacker.Group.PlayerHasBeenSeen()))
    {
        if(iSeeingPlayer == 0)
        {
            if(ePawn(Attacker.Pawn).ICanBark())
            {
				ePawn(Attacker.Pawn).Bark_Type = BARK_LookingForYou;
	            Attacker.Pawn.PlaySound(ePawn(Attacker.Pawn).Sounds_Barks, SLOT_Barks);
                    
                if(ePawn(Attacker.Pawn).bIsHotBlooded)
                {
                    Attacker.TimedForceFire();
                }
            }
        }
    }
    else if((iSearch > 1) && (iAttack == 0) && (bSawPlayerOnce) && (Searcher != None))
    {
        // BARK_LostPlayer
        if(ePawn(Searcher.Pawn).ICanBark())
		{
			ePawn(Searcher.Pawn).Bark_Type = BARK_LostPlayer;
	        Searcher.Pawn.PlaySound(ePawn(Searcher.Pawn).Sounds_Barks, SLOT_Barks);
		}
    }
    

}

/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
// Alarm Stages
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
function IncreaseAlarmStage()
{

    if (bIgnoreAlarmStage)
    {
        return;
    }

	//be sure the pattern is initialize
    if( AlarmPattern !=  None)
    {
	    if(!AlarmPattern.bInit)
		    AlarmPattern.InitPattern();
    }

	// Joshua - Elite Mode, 3 alarms and the mission's over
    if (EchelonGameInfo(Level.Game).bEliteMode)
	{
		if(AlarmStage < 2)
		{
			AlarmStage++;
			EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("AlarmTriggered");

			log("**** Alarm Stage increased at level: "$AlarmStage$" ****");

			if( AlarmPattern !=  None)
			{
				switch(AlarmStage)
				{
				case 1:
					if(!bLiteWarnings)
						AlarmPattern.GotoPatternLabel('AlarmStageA');
					break;
				case 2:
					AlarmPattern.GotoPatternLabel('AlarmStageC');
					break;
				}
			}
		}
		else if(AlarmStage == 2)
		{
			AlarmStage++;
			EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("AlarmTriggered");

			log("*** Last Alarm stage reached: GameOver ***");

			if( AlarmPattern !=  None)
			{
				log("AlarmPattern !=  None");
				AlarmPattern.GotoPatternLabel('AlarmStageD');
			}
		}
	}
	else
	{
		if(AlarmStage < 3)
		{
			AlarmStage++;
			EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("AlarmTriggered");

			log("**** Alarm Stage increased at level: "$AlarmStage$" ****");

			if( AlarmPattern !=  None)
			{
				switch(AlarmStage)
				{
				case 1:
					if(!bLiteWarnings)
						AlarmPattern.GotoPatternLabel('AlarmStageA');
					break;
				case 2:
					break;
				case 3:
					AlarmPattern.GotoPatternLabel('AlarmStageC');
					break;
				}
			}
		}
		else if(AlarmStage == 3)
		{
			AlarmStage++;
			EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("AlarmTriggered");

			log("*** Last Alarm stage reached: GameOver ***");

			if( AlarmPattern !=  None)
			{
				log("AlarmPattern !=  None");
				AlarmPattern.GotoPatternLabel('AlarmStageD');
			}
		}
	}
}


/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
// MEMORY INFORMATION 
/////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////
function bool GetMemoryStick( out Array<EMemoryStick> Mems, Actor AccessActor, optional bool bTest )
{
	local int i, j;

	//Log("Bank information"@MemoryBank.Length);
	//Log("Asking for memory with info class="$AccessClass$" tag="$AccessTag$" actor="$AccessActor);

	for( i=0; i<MemoryBank.Length; i++ )
	{
		for( j=0; j< MemoryBank[i].AccessActors.Length; j++ )
		{
			if( MemoryBank[i].AccessActors[j] != AccessActor )
				continue;

			// Found
			//Log("...Found");
			Mems[Mems.Length] = MemoryBank[i];

			// If this stick should be destroyed after reading, remove now from list,
			// since mem stick destroys itself in this case
			if( MemoryBank[i].DestroyUponRead && !bTest )
			{
				MemoryBank.Remove(i,1);
				i--;
			}

			break;
		}
	}

	//Log(Mems.Length$" found");

	return Mems.Length > 0;
}

function RemoveMemoryStick( EMemoryStick Ms )
{
	local int i;
	for( i=0; i<MemoryBank.Length; i++ )
	{
		if( MemoryBank[i] == Ms )
		{
			MemoryBank.Remove(i,1);
			return;
		}
	}
}





//----------------------------------------[David Kalina - 3 Aug 2001]-----
// 
// Description
//		Add ladder to dynarray
//		Encode direction in sign of stored LadderID
//
// Input
//		LadderID : ID (tag) of Ladder GE
//		Direction : 0 | from top to bottom
//					1 | from bottom to top
// 
//------------------------------------------------------------------------
native(1528) final function LockLadder( int LadderID, Pawn LockingPawn, bool bClimbingUp, bool bClimbingDown, bool bAtTop, bool bAtBottom );


//----------------------------------------[David Kalina - 3 Aug 2001]-----
// 
// Description
//		Unlock specified ladder (regardless of direction)
//
// Input
//		LadderID : 
//
//------------------------------------------------------------------------

native(1529) final function UnlockLadder( int LadderID );


//----------------------------------------[David Kalina - 3 Aug 2001]-----
// 
// Description
//		Returns true if the ladder is locked in the specified direction.
//		Typically, whomever is calling the function should check
//		for a lock in the OPPOSITE direction from which they want to go.
// 
// Input
//		LadderID : 
//		Direction : Direction to check for lock.
// 
//------------------------------------------------------------------------

native(1530) final function bool IsLadderLocked( int LadderID, byte Direction );




//---------------------------------------[David Kalina - 28 Jan 2002]-----
// 
// Description
//		Is the ladder specified by LadderID presently locked by LockingPawn?
// 
//------------------------------------------------------------------------

native(1532) final function bool IsLadderLockedBy( int LadderID, Pawn LockingPawn );



//---------------------------------------[Frederic Blais - 27 Feb 2002]-----
// 
// Description
// 
// _Type
// 0 = Stress Music
// 1 = Combat Music
//
// _bPlay
// false = stop
// true = play
//
//------------------------------------------------------------------------
function SendMusicRequest(int _Type, bool _bPlay, Actor _Instigator, optional bool DontPlayPunch )
{
	if( bMusicEnabled && MusicObj != None )
		MusicObj.SendMusicRequest( _Type,  _bPlay,  _Instigator, DontPlayPunch );
}

defaultproperties
{
    AlarmPatternClass=Class'LambertWarnings'
    bMusicEnabled=true
    AlarmModifier(0)=1.000000
    AlarmModifier(1)=0.660000
    AlarmModifier(2)=0.330000
    RandomWhistle=Sound'GenericLife.Play_GenericWhistle1'
}