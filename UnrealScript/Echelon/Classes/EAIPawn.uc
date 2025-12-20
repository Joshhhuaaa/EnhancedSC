class EAIPawn extends EPawn
	native;

// VARIABLES 

var	EAIController AI;
var Sound GearSoundWalk;
var Sound GearSoundRun;

var EGroupAI	Group;

var bool bDisableAIforSound;

//---------------------------------------[David Kalina - 29 Oct 2001]-----
// 
// Description
//		Set randomized animation rate for AI pawns.
// 
//------------------------------------------------------------------------

function PostBeginPlay()
{
	local MeshAnimation Anim;

	RandomizedAnimRate = 0.97f + RandRange(0.0f, 0.06f);
	
	//log(Tag @ " / " @ Name @ ":" @ RandomizedAnimRate,,LAICONTROLLER);
	
	SetIKFade(1.666f,1.666f);		// set ik fade for AimAt
	
	// link animation packages
	
	LinkSkelAnim(none);				// link DefaultAnim UMeshAnimation

	// load generic anim packages

	if (Mesh != None)
	{
		Anim = MeshAnimation(DynamicLoadObject("ENPC.BedAnims", class'MeshAnimation'));
		LinkSkelAnim(Anim);

		Anim = MeshAnimation(DynamicLoadObject("ENPC.ChairAnims", class'MeshAnimation'));
		LinkSkelAnim(Anim);
		
		Anim = MeshAnimation(DynamicLoadObject("ENPC.TableAnims", class'MeshAnimation'));
		LinkSkelAnim(Anim);
		
		Anim = MeshAnimation(DynamicLoadObject("ENPC.LadderAnims", class'MeshAnimation'));
		LinkSkelAnim(Anim);

		Anim = MeshAnimation(DynamicLoadObject("ENPC.PistolAnims", class'MeshAnimation'));
		LinkSkelAnim(Anim);
		
		Anim = MeshAnimation(DynamicLoadObject("ENPC.MaleAnims", class'MeshAnimation'));
		LinkSkelAnim(Anim);

		Anim = MeshAnimation(DynamicLoadObject("ENPC.ProAnims", class'MeshAnimation'));
		LinkSkelAnim(Anim);
	}

	if (bSniper)
		AccuracyDeviation = 0;

	Super.PostBeginPlay();
}

// HACK FOR KALINATEK, May be called from pattern to start a conversation
function Trigger(actor Other, pawn EventInstigator, optional name InTag)
{
	Super.Trigger(Other, EventInstigator, InTag);
	
	//other hack for kalinatek
	DefendActor = None;

	if (Interaction != None)
		Interaction.Trigger(Other, EventInstigator);
}

//----------------------------------------[David Kalina - 9 Apr 2001]-----
// 
// Description
//		Called after Controller possesses us.
//		Set AI reference / link special event anims
// 
//------------------------------------------------------------------------

function PossessedBy(Controller C)
{
	local int i;
	local EchelonLevelInfo ELevel;

	AI = EAIController(C);

	Super.PossessedBy(C);

	ELevel = EchelonLevelInfo(Level);
	
	// load all special sequence anims specified by 

	for (i = 0; i < ELevel.SpecialEventAnims.Length; i++)
	{
		LinkSkelAnim(ELevel.SpecialEventAnims[i]);
	}
}



//----------------------------------------[David Kalina - 1 Aug 2001]-----
// 
// Description
//		Set up all anim references that won't change.
// 
//------------------------------------------------------------------------

function InitAnims()
{
	// fill most anim reference's w/ dummy names so if something is called w/out being set,
	// we know which animation is missing
	//plog("************************* InitAnims ******************************* PAWN: "$self);

	AWaitCrouch					= 'AWaitCrouch';
	AJumpStart					= 'AJumpStart';
	AFallFree					= 'AFallFree';
	AFallQuiet					= 'AFallQuiet';
	ALandHi						= 'ALandHi';
	ALandLow					= 'ALandLow';
	ALandQuiet					= 'ALandQuiet';
	ASearchBody					= 'ASearchBody';

	
	ALookForward				= 'LookStNmFd0';
	ALookLeft					= 'LookStNmLt0';
	ALookRight					= 'LookStNmRt0';
	ALookDownwards				= 'LookStNmDn0';
	ALookUpwards				= 'LookStNmUp0';
	ALookBackwards				= 'LookStNmBk0';

	ATurnBRight					= 'TurnStNmBr0';
	ATurnBLeft					= 'TurnStNmBl0';
	ATurnLt						= 'TurnStNmLt0';
	ATurnRt						= 'TurnStNmRt0';

	AWait							= 'WaitStNmFd0';
	AWaitLeft						= 'WaitStNmLt0';
	AWaitRight						= 'WaitStNmRt0';
	
	ATurnRight						= 'TurnStNmNt0';
	
	ABlendMovement.m_forward		= 'WalkStNmFd0';
	ABlendMovement.m_forwardRight	= 'WalkStNmRt0';
	ABlendMovement.m_forwardLeft	= 'WalkStNmLt0';


	// Default (Same For Every MoveFlag / WeaponStance)

		
	AGrabStart					= 'GrabStAlBg0';
	AGrabWait					= 'GrabStAlNt0';
	AGrabSqeeze					= 'GrabStAlIn0';
	AGrabRetinalStart			= 'GrabStScBg0';
	AGrabRetinalWait			= 'GrabStScNt0';
	AGrabRetinalEnd				= 'GrabStScEd0';
	AGrabRelease				= 'GrabStAlEd0';
	AGrabReleaseKnock			= 'GrabStAlKo0';
	
	// ladder climbing
	ANLUpRight					= 'LaddStNmUpR';
	ANLUpLeft					= 'LaddStNmUpL';
	ANLTopUpLeft				= 'LaddStNmEuL';
	ANLTopUpRight				= 'LaddStNmEuR';
	ANLInTop					= 'LaddStNmBu0';
	ANLTopDownRight				= 'LaddStNmBuR';	
	ANLInBottom					= 'LaddStNmBd0';
	ANLWaitLeft					= 'LaddStNmNtL';
	ANLWaitRight				= 'LaddStNmNtR';
	ANLWaitTop					= 'LaddStNmNt0';	
	ANLSlideDown				= 'LaddStNmDn0';
	ANLOutBottomLeft			= 'LaddStNmEdL';
	ANLOutBottomRight			= 'LaddStNmEdR';

	// door interactions
	ADoorOpenLt					= 'DoorStNmLt0';
	ADoorOpenRt					= 'DoorStNmRt0';
	ARetinalScanBegin			= 'ScanStNmBg0';
	ARetinalScan				= 'ScanStNmNt0';
	ARetinalScanEnd				= 'ScanStNmEd0';
	
	// falling
	AFall						= 'FallStNmDn0';

	// deaths
	ADeathLadder				= 'LaddStNmXX0';
	ADeathForwardNtrl			= 'XxxxNtAlFd0';
	ADeathBackNtrl				= 'XxxxNtAlBk0';
	ADeathLeftNtrl				= 'XxxxNtAlLt0';
	ADeathRightNtrl				= 'XxxxNtAlRt0';

	ASpasm1						= 'SpsmNtAlBF0';
	ASpasm2						= 'SpsmNtAlFL0';
	ASpasm3						= 'SpsmNtAlLR0';
	ASpasm4						= 'SpsmNtAlRB0';

	// Unconscious Revival Animations
	ARecover					= 'WakeStNmUp0';
	AReviveBody					= 'HealStAlDn0';
	ACheckDeadBody				= 'PokeStAlDn0';

	// ahem
	ACough						= 'SmokStAlNt0';
	
	// miscellaneous interactions
	AAlarmInteract				= 'AlrmStAlOn0';
	ALightSwitchInteract		= 'LigtStNmOn0';

	// radio, radio!
	ARadioBegin					= 'RdioStNmBg0';
	ARadio						= 'RdioStNmNt0';
	ARadioEnd					= 'RdioStNmEd0';

	// wall mine
	APlaceWallMineBegin			= 'MineStNmBg0';
	APlaceWallMine				= 'MineStNmNt0';
	APlaceWallMineEnd			= 'MineStNmEd0';

	ASprayFire				    = 'ShotStAlFd1';
	APitchBlackF				= 'walkStInFd0';
	APitchBlackL				= 'walkStInLt0';
	APitchBlackR				= 'walkStInRt0';

	if (bSleeping)
	{
		AStandUpR						= 'LaidBdNmUpR';
		AStandUpL						= 'LaidBdNmUpL';
		ASitDownR						= 'LaidBdNmDnR';
		ASitDownL						= 'LaidBdNmDnL';
		AWaitSitT						= 'WaitBdNmNt0';

	}
	else
	{
		AStandUpR						= 'SittAsNmUpR';
		AStandUpL						= 'SittAsNmUpL';
		AStandUpF						= 'SittChNmUp0';
		ASitDownR						= 'SittAsNmDnR';
		ASitDownL						= 'SittAsNmDnL';
		ASitDownF						= 'SittChNmDn0';
		AWaitSitT						= 'WaitAsNmFd0';
		AWaitSitS						= 'WaitChNmFdA';
	}

	switch (WeaponHandedness)
	{
	case 1:
		APitchBlackF				= 'walkStInFd1';
		APitchBlackL				= 'walkStInLt1';
		APitchBlackR				= 'walkStInRt1';
		ASprayFire					= 'ShotStAlFd1';
		break;
	case 2:
		APitchBlackF				= 'walkStInFd2';
		APitchBlackL				= 'walkStInLt2';
		APitchBlackR				= 'walkStInRt2';
		ASprayFire					= 'ShotStAlFd2';
		break;
	default:
		break;
	}
}





//---------------------------------------[David Kalina - 10 Apr 2001]-----
// 
// Description
//		Set up NPC Animations based on current BaseMoveFlags
// 
//------------------------------------------------------------------------
function SwitchAnims()
{
	local MoveFlags  lmoveflag;

	lmoveflag = BaseMoveFlags;

	//special case for grabbed NPCs that were sit
	if (GetStateName() == 's_Grabbed')
		lmoveflag = MOVE_WalkNormal;

	// update AI's focus switching properties
	if (AI != none)
	{
		AI.UpdateFocusSwitching(lmoveflag);
	}
	
	// always reset -- will be set by certain moveflags (e.g. MOVE_DesignerWalk)
	bNoBlending = false;		


	//
	//
	//		SWITCH ON "WAIT FLAGS" 
	//		Crouch v. UnCrouch v. Sitting
	//
	// 

	switch (lmoveflag)
	{
		case MOVE_Sit :

			bWantsToCrouch = false;

			if (AI != None && bSleeping)
			{
				ADeathDown				= 'XxxxBdNmDn0';
				ADeathBack					= 'XxxxBdNmDn0';
				ADeathLeft					= 'XxxxBdNmDn0';
				ADeathRight					= 'XxxxBdNmDn0';
				ADeathForward			= 'XxxxBdNmDn0';

			}
			else
			{
				if (AI != None && AI.bTableChair)
					ADeathForward			= 'XxxxAsNmFd0';
				else
					ADeathForward			= 'XxxxChAlFd0';

				ADeathBack					= 'XxxxAsNmBk0';
				ADeathLeft					= 'XxxxChAlLt0';
				ADeathRight					= 'XxxxChAlRt0';
			}

			AFragForward				= '';
			AFragBack					= '';
			AFragLeft					= '';
			AFragRight					= '';
			
			break;

		case MOVE_CrouchJog :
		case MOVE_CrouchWalk :
			
			// CROUCHED ANIMS
			
			bWantsToCrouch = true;
						
			AThrowGrenade				= 'ThroCrAlEdH';
			
			ADeathForward				= 'XxxxCrAlFd0';
			ADeathBack					= 'XxxxCrAlBk0';
			ADeathLeft					= 'XxxxCrAlLt0';
			ADeathRight					= 'XxxxCrAlRt0';
			ADeathDown					= 'XxxxCrAlDn0';

			AFragForward				= 'FragStAlFd0';
			AFragBack					= 'FragStAlBk0';
			AFragLeft					= 'FragStAlLt0';
			AFragRight					= 'FragStAlRt0';
			
			// anims switched on weapon stance, crouch vs uncrouch
			switch (WeaponStance)
			{
				case 0 : 

					ADamageHeadShotForward		= 'PainCrAlCf0';
					ADamageHeadShotBack			= 'PainCrAlCb0';
					
					ADamageChestForward			= 'PainCrAlCf0';
					ADamageChestBack			= 'PainCrAlCb0';
					ADamageChestLeft			= 'PainCrAlCl0';
					ADamageChestRight			= 'PainCrAlCr0';
					ADamageArmLeft				= 'PainCrAlAl0';
					ADamageArmRight				= 'PainCrAlAr0';
					ADamageLegLeft				= 'PainCrAlLl0';
					ADamageLegRight				= 'PainCrAlLr0';

					AHurtHandLeft				= 'HurtCrAlAl0';
					AHurtHandRight				= 'HurtCrAlAR0';
					AHurtFootLeft				= 'HurtCrAlLl0';
					AHurtFootRight				= 'HurtCrAlLr0';

					break;

				case 1 : 

					ADamageHeadShotForward		= 'PainCrAlCf1';
					ADamageHeadShotBack			= 'PainCrAlCb1';
					
					ADamageChestForward			= 'PainCrAlCf1';
					ADamageChestBack			= 'PainCrAlCb1';
					ADamageChestLeft			= 'PainCrAlCl1';
					ADamageChestRight			= 'PainCrAlCr1';
					ADamageArmLeft				= 'PainCrAlAl1';
					ADamageArmRight				= 'PainCrAlAr1';
					ADamageLegLeft				= 'PainCrAlLl1';
					ADamageLegRight				= 'PainCrAlLr1';

					AHurtHandLeft				= 'HurtCrAlAl2';
					AHurtHandRight				= 'HurtCrAlAR2';
					AHurtFootLeft				= 'HurtCrAlLl2';
					AHurtFootRight				= 'HurtCrAlLr2';

					break;

				case 2 : 

					ADamageHeadShotForward		= 'PainCrAlCf2';
					ADamageHeadShotBack			= 'PainCrAlCb2';
					
					ADamageChestForward			= 'PainCrAlCf2';
					ADamageChestBack			= 'PainCrAlCb2';
					ADamageChestLeft			= 'PainCrAlCl2';
					ADamageChestRight			= 'PainCrAlCr2';
					ADamageArmLeft				= 'PainCrAlAl2';
					ADamageArmRight				= 'PainCrAlAr2';
					ADamageLegLeft				= 'PainCrAlLl2';
					ADamageLegRight				= 'PainCrAlLr2';

					AHurtHandLeft				= 'HurtCrAlAl2';
					AHurtHandRight				= 'HurtCrAlAR2';
					AHurtFootLeft				= 'HurtCrAlLl2';
					AHurtFootRight				= 'HurtCrAlLr2';

					break;
			}

			break;


		default : 

			// UNCROUCHED ANIMS

			bWantsToCrouch = false;

			AThrowGrenade	   			= 'ThroStAlEdH';
			
			ADeathForward				= 'XxxxStAlFd0';
			ADeathBack					= 'XxxxStAlBk0';
			ADeathLeft					= 'XxxxStAlLt0';
			ADeathRight					= 'XxxxStAlRt0';
			ADeathDown					= 'XxxxStAlDn0';

			AFragForward				= 'FragStAlFd0';
			AFragBack					= 'FragStAlBk0';
			AFragLeft					= 'FragStAlLt0';
			AFragRight					= 'FragStAlRt0';
						
			// damage anims switched on weapon stance
			switch (WeaponStance)
			{
				case 0 : 

					ADamageHeadShotForward		= 'PainStAlCf0';
					ADamageHeadShotBack			= 'PainStAlCb0';
					
					ADamageChestForward			= 'PainStAlCf0';
					ADamageChestBack			= 'PainStAlCb0';
					ADamageChestLeft			= 'PainStAlCl0';
					ADamageChestRight			= 'PainStAlCr0';
					ADamageArmLeft				= 'PainStAlAl0';
					ADamageArmRight				= 'PainStAlAr0';
					ADamageLegLeft				= 'PainStAlLl0';
					ADamageLegRight				= 'PainStAlLr0';

					AHurtHandLeft				= 'HurtStAlAl0';
					AHurtHandRight				= 'HurtStAlAR0';
					AHurtFootLeft				= 'HurtStAlLl0';
					AHurtFootRight				= 'HurtStAlLr0';

					break;

				case 1 : 


					ADamageHeadShotForward		= 'PainStAlCf1';
					ADamageHeadShotBack			= 'PainStAlCb1';
					
					ADamageChestForward			= 'PainStAlCf1';
					ADamageChestBack			= 'PainStAlCb1';
					ADamageChestLeft			= 'PainStAlCl1';
					ADamageChestRight			= 'PainStAlCr1';
					ADamageArmLeft				= 'PainStAlAl1';
					ADamageArmRight				= 'PainStAlAr1';
					ADamageLegLeft				= 'PainStAlLl1';
					ADamageLegRight				= 'PainStAlLr1';

					AHurtHandLeft				= 'HurtStAlAl1';
					AHurtHandRight				= 'HurtStAlAR1';
					AHurtFootLeft				= 'HurtStAlLl1';
					AHurtFootRight				= 'HurtStAlLr1';
										
					break;

				case 2 : 

					ADamageHeadShotForward		= 'PainStAlCf2';
					ADamageHeadShotBack			= 'PainStAlCb2';
					
					ADamageChestForward			= 'PainStAlCf2';
					ADamageChestBack			= 'PainStAlCb2';
					ADamageChestLeft			= 'PainStAlCl2';
					ADamageChestRight			= 'PainStAlCr2';
					ADamageArmLeft				= 'PainStAlAl2';
					ADamageArmRight				= 'PainStAlAr2';
					ADamageLegLeft				= 'PainStAlLl2';
					ADamageLegRight				= 'PainStAlLr2';

					AHurtHandLeft				= 'HurtStAlAl2';
					AHurtHandRight				= 'HurtStAlAR2';
					AHurtFootLeft				= 'HurtStAlLl2';
					AHurtFootRight				= 'HurtStAlLr2';
					
					break;
			}
						
			break;
	}


	//
	//
	//		SWITCH ON MOVE FLAGS (Walk vs Run)
	//
	// 

	switch (lmoveflag) 
	{
		case MOVE_WalkRelaxed : 
		case MOVE_WalkNormal : 
		case MOVE_WalkAlert : 
		case MOVE_Search :
		case MOVE_Snipe : 
		case MOVE_CrouchWalk :

			SoundWalkingRatio = 0.60;
			break;

		case MOVE_JogAlert : 
		case MOVE_JogNoWeapon : 
		case MOVE_CrouchJog :

			SoundWalkingRatio = 1.0;
			break;

				
		// DesignerWalk is a special case -- reset most references and return
		case MOVE_DesignerWalk :
			bNoBlending = true;

			AWaitIn							= '';
			AWaitOut						= '';

			AWait							= DesignerWaitAnim;
			AWaitLeft						= '';
			AWaitRight						= '';

			ATurnRight						= '';

			ABlendMovement.m_forward		= DesignerWalkAnim;	
			ABlendMovement.m_forwardLeft	= '';	
			ABlendMovement.m_forwardRight	= '';

			APeekLeftBegin					= '';
			APeekLeft						= '';
			APeekRightBegin					= '';
			APeekRight						= '';
			
			return;	
	}
	

	//
	//
	//		SWITCH ON SIT ANIMS
	//
	// 

	/*	switch (lmoveflag) 
		{
			case MOVE_WalkRelaxed : 
	
			if (bSleeping)
			{
				AStandUpR						= 'LaidBdNmUpR';
				AStandUpL						= 'LaidBdNmUpL';
			}
			else
			{
				AStandUpR						= 'SittAsNmUpR';
				AStandUpL						= 'SittAsNmUpL';
				AStandUpF						= 'SittChNmUp0';
			}
			break;
				
			case MOVE_Search :
			case MOVE_WalkNormal : 
			case MOVE_WalkAlert :
			case MOVE_Snipe :
			case MOVE_JogAlert :
			case MOVE_JogNoWeapon :					
			case MOVE_CrouchWalk :  
			case MOVE_CrouchJog : 


			if (bSleeping)
			{
				AStandUpR						= 'LaidBdAlUpR';
				AStandUpL						= 'LaidBdAlUpL';
			}
			else
			{
				AStandUpR						= 'SittAsAlUpR';
				AStandUpL						= 'SittAsAlUpL';
				AStandUpF						= 'SittChAlUp0';
			}
				break;

		}
	*/

	//
	//
	//		SWITCH ON MOVE FLAGS / WEAPON STANCE
	//
	// 

	switch (WeaponStance)
	{
		// no weapon :
			
		case 0 :

			AReload						= '';
			AReloadCrouch				= '';

			ALookForward				= 'LookStNmFd0';
			ALookLeft					= 'LookStNmLt0';
			ALookRight					= 'LookStNmRt0';
			ALookDownwards				= 'LookStNmDn0';
			ALookUpwards				= 'LookStNmUp0';
			ALookBackwards				= 'LookStNmBk0';

			ATurnBRight					= 'TurnStNmBr0';
			ATurnBLeft					= 'TurnStNmBl0';
			ATurnLt						= 'TurnStNmLt0';
			ATurnRt						= 'TurnStNmRt0';
			
			switch (lmoveflag) 
			{
				case MOVE_WalkRelaxed : 
				
					AWaitIn							= '';
					AWaitOut						= '';

					AWait							= 'WaitStNmFd0';
					AWaitLeft						= 'WaitStNmLt0';
					AWaitRight						= 'WaitStNmRt0';
					
					ATurnRight						= 'TurnStNmNt0';
					//ATurnRight						= 'TurnTest';
					
					ABlendMovement.m_forward		= 'WalkStNmFd0';
					ABlendMovement.m_forwardRight	= 'WalkStNmRt0';
					ABlendMovement.m_forwardLeft	= 'WalkStNmLt0';

					break;
					
				
				case MOVE_Search :
				case MOVE_WalkNormal : 
				case MOVE_WalkAlert :
				case MOVE_Snipe :

					AWaitIn							= '';
					AWaitOut						= '';

					AWait							= 'WaitStAlFd0';
					AWaitLeft						= 'WaitStAlLt0';
					AWaitRight						= 'WaitStAlRt0';
					
					ATurnRight						= 'TurnStAlNt0';

					ABlendMovement.m_forward		= 'WalkStAlFd0';
					ABlendMovement.m_forwardRight	= 'WalkStAlRt0';
					ABlendMovement.m_forwardLeft	= 'WalkStAlLt0';
					
					break;
							
				case MOVE_JogAlert :
				case MOVE_JogNoWeapon :
					
					AWaitIn							= '';
					AWaitOut						= '';

					AWait							= 'WaitStAlFd0';
					AWaitLeft						= 'WaitStAlLt0';
					AWaitRight						= 'WaitStAlRt0';

					ATurnRight						= 'TurnStAlNt0';

					ABlendMovement.m_forward		= 'JoggStAlFd0';
					ABlendMovement.m_forwardRight	= 'JoggStAlRt0';
					ABlendMovement.m_forwardLeft	= 'JoggStAlLt0';
					
					break;
					
				case MOVE_CrouchWalk :  

					AWaitIn							= '';
					AWaitOut						= '';

					AWait							= 'WaitCrAlFd0';
					AWaitLeft						= 'WaitCrAlLt0';
					AWaitRight						= 'WaitCrAlRt0';

					ATurnRight						= 'TurnCrAlNt0';

					// NOT APPROPRIATE ANIMATIONS -- just in case, should never actually be played
					ABlendMovement.m_forward		= 'WalkCrNmFd1';
					ABlendMovement.m_forwardRight	= 'WalkCrNmRt1';
					ABlendMovement.m_forwardLeft	= 'WalkCrNmLt1';

					break;
					
				case MOVE_CrouchJog : 

					AWaitIn							= '';
					AWaitOut						= '';
					
					AWait							= 'WaitCrAlFd0';
					AWaitLeft						= 'WaitCrAlLt0';
					AWaitRight						= 'WaitCrAlRt0';
					
					ATurnRight						= 'TurnCrAlNt0';

					// NOT APPROPRIATE ANIMATIONS -- just in case, should never actually be played
					ABlendMovement.m_forward		= 'JoggCrAlFd1';
					ABlendMovement.m_forwardRight	= 'JoggCrAlRt1';
					ABlendMovement.m_forwardLeft	= 'JoggCrAlLt1';

					break;

			}

			break;

		// one handed weapon :

		case 1 :

			AReload						= 'ReloStAlNt1';
			AReloadCrouch				= 'ReloCrAlNt1';
			
			ALookForward				= 'LookStNmFd1';
			ALookLeft					= 'LookStNmLt1';
			ALookRight					= 'LookStNmRt1';
			ALookDownwards				= 'LookStNmDn1';
			ALookUpwards				= 'LookStNmUp1';
			ALookBackwards				= 'LookStNmBk1';
						
			ATurnBRight					= 'TurnStNmBr1';
			ATurnBLeft					= 'TurnStNmBl1';
			ATurnLt						= 'TurnStNmLt1';
			ATurnRt						= 'TurnStNmRt1';

			switch (lmoveflag)		
			{
				case MOVE_WalkRelaxed :

					// Walk Relaxed ==> gun away
					
					AWaitIn							= '';
					AWaitOut						= '';
					
					AWait							= 'WaitStNmFd0';
					AWaitLeft						= 'WaitStNmLt0';
					AWaitRight						= 'WaitStNmRt0';

					ATurnRight						= 'TurnStNmNt0';

					ABlendMovement.m_forward		= 'WalkStNmFd0';	
					ABlendMovement.m_forwardLeft	= 'WalkStNmLt0';
					ABlendMovement.m_forwardRight	= 'WalkStNmRt0';
					
					APeekLeftBegin					= 'PeekStBgLt1';
					APeekLeft						= 'PeekStNtLt1';
					APeekRightBegin					= 'PeekStBgRt1';
					APeekRight						= 'PeekStNtRt1';

					break;

				case MOVE_WalkNormal : 
				

					AWaitIn							= '';
					AWaitOut						= '';

					AWait							= 'WaitStNmFd1';
					AWaitLeft						= 'WaitStNmLt1';
					AWaitRight						= 'WaitStNmRt1';
					
					ATurnRight						= 'TurnStNmNt1';

					ABlendMovement.m_forward		= 'WalkStNmFd1';
					ABlendMovement.m_forwardRight	= 'WalkStNmRt1';
					ABlendMovement.m_forwardLeft	= 'WalkStNmLt1';

					APeekLeftBegin					= 'PeekStBgLt1';
					APeekLeft						= 'PeekStNtLt1';
					APeekRightBegin					= 'PeekStBgRt1';
					APeekRight						= 'PeekStNtRt1';

					break;


				case MOVE_WalkAlert :
				case MOVE_Search :
				case MOVE_Snipe : 
					
					// wait alert / walk alert animations both have gun out

					AWaitIn							= '';
					AWaitOut						= '';

					//AWaitIn							= 'DrawStAlSb1';
					//AWaitOut						= 'DrawStAlSe1';

					AWait							= 'WaitStAlFd1';
					AWaitLeft						= 'WaitStAlLt1';
					AWaitRight						= 'WaitStAlRt1';

					ATurnRight						= 'TurnStAlNt1';
					
					ABlendMovement.m_forward		= 'WalkStAlFd1';
					ABlendMovement.m_forwardRight	= 'WalkStAlRt1';
					ABlendMovement.m_forwardLeft	= 'WalkStAlLt1';

					APeekLeftBegin					= 'PeekStBgLt1';
					APeekLeft						= 'PeekStNtLt1';
					APeekRightBegin					= 'PeekStBgRt1';
					APeekRight						= 'PeekStNtRt1';

					break;

				case MOVE_JogAlert :
				case MOVE_JogNoWeapon:					
					
					AWaitIn							= '';
					AWaitOut						= '';

					//AWaitIn							= 'DrawStAlSb1';
					//AWaitOut						= 'DrawStAlSe1';

					AWait							= 'WaitStAlFd1';
					AWaitLeft						= 'WaitStAlLt1';
					AWaitRight						= 'WaitStAlRt1';

					ATurnRight						= 'TurnStAlNt1';

					ABlendMovement.m_forward		= 'JoggStAlFd1';
					ABlendMovement.m_forwardRight	= 'JoggStAlRt1';
					ABlendMovement.m_forwardLeft	= 'JoggStAlLt1';

					APeekLeftBegin					= 'PeekStBgLt1';
					APeekLeft						= 'PeekStNtLt1';
					APeekRightBegin					= 'PeekStBgRt1';
					APeekRight						= 'PeekStNtRt1';

					break;

				case MOVE_CrouchWalk :
					
					//AWaitIn							= 'DrawCrAlSb1';
					//AWaitOut						= 'DrawCrAlSe1';

					AWait							= 'WaitCrAlFd1';
					AWaitLeft						= 'WaitCrAlLt1';
					AWaitRight						= 'WaitCrAlRt1';

					ATurnRight						= 'TurnCrAlNt1';

					ABlendMovement.m_forward		= 'WalkCrNmFd1';
					ABlendMovement.m_forwardRight	= 'WalkCrNmRt1';
					ABlendMovement.m_forwardLeft	= 'WalkCrNmLt1';

					APeekLeftBegin					= 'PeekCrBgLt1';
					APeekLeft						= 'PeekCrNtLt1';
					APeekRightBegin					= 'PeekCrBgRt1';
					APeekRight						= 'PeekCrNtRt1';

					break;

				case MOVE_CrouchJog :

					AWaitIn							= '';
					AWaitOut						= '';

					//AWaitIn							= 'DrawCrAlSb1';
					//AWaitOut						= 'DrawCrAlSe1';

					AWait							= 'WaitCrAlFd1';
					AWaitLeft						= 'WaitCrAlLt1';
					AWaitRight						= 'WaitCrAlRt1';

					ATurnRight						= 'TurnCrAlNt1';

					ABlendMovement.m_forward		= 'JoggCrAlFd1';
					ABlendMovement.m_forwardRight	= 'JoggCrAlRt1';
					ABlendMovement.m_forwardLeft	= 'JoggCrAlLt1';

					APeekLeftBegin					= 'PeekCrBgLt1';
					APeekLeft						= 'PeekCrNtLt1';
					APeekRightBegin					= 'PeekCrBgRt1';
					APeekRight						= 'PeekCrNtRt1';
					
					break;
			}

			break;

			

		// two handed weapon :

		case 2 :

			AReload						= 'ReloStAlNt2';
			AReloadCrouch				= 'ReloCrAlNt2';

			ALookForward				= 'LookStNmFd2';
			ALookLeft					= 'LookStNmLt2';
			ALookRight					= 'LookStNmRt2';
			ALookDownwards				= 'LookStNmDn2';
			ALookUpwards				= 'LookStNmUp2';
			ALookBackwards				= 'LookStNmBk2';

			ATurnBRight					= 'TurnStNmBr2';
			ATurnBLeft					= 'TurnStNmBl2';
			ATurnLt						= 'TurnStNmLt2';
			ATurnRt						= 'TurnStNmRt2';

			switch (lmoveflag)
			{
				case MOVE_NotSpecified :
				
					Log("SwitchAnims called with MOVE_NotSpecified -- using MOVE_WalkRelaxed and forcing BaseMoveFlags.");
					BaseMoveFlags = MOVE_WalkRelaxed;

				case MOVE_WalkRelaxed :				// note : MOVE_WalkRelaxed ==> s_Default

					// Walk Relaxed ==> gun away

					AWaitIn							= '';
					AWaitOut						= '';
					
					AWait							= 'WaitStNmFd0';
					AWaitLeft						= 'WaitStNmLt0';
					AWaitRight						= 'WaitStNmRt0';

					ATurnRight						= 'TurnStNmNt0';

					ABlendMovement.m_forward		= 'WalkStNmFd0';	
					ABlendMovement.m_forwardLeft	= 'WalkStNmLt0';
					ABlendMovement.m_forwardRight	= 'WalkStNmRt0';

					APeekLeftBegin					= 'PeekStBgLt2';
					APeekLeft						= 'PeekStNtLt2';
					APeekRightBegin					= 'PeekStBgRt2';
					APeekRight						= 'PeekStNtRt2';
					
					break;

				case MOVE_WalkNormal:				// note : MOVE_WalkNormal ==> s_Investigate
				
					AWaitIn							= '';
					AWaitOut						= '';

					AWait							= 'WaitStNmFd2';
					AWaitLeft						= 'WaitStNmLt2';
					AWaitRight						= 'WaitStNmRt2';

					ATurnRight						= 'TurnStNmNt2';

					ABlendMovement.m_forward		= 'WalkStNmFd2';
					ABlendMovement.m_forwardLeft	= 'WalkStNmLt2';
					ABlendMovement.m_forwardRight	= 'WalkStNmRt2';

					APeekLeftBegin					= 'PeekStBgLt2';
					APeekLeft						= 'PeekStNtLt2';
					APeekRightBegin					= 'PeekStBgRt2';
					APeekRight						= 'PeekStNtRt2';

					break;


				case MOVE_Search:
				case MOVE_WalkAlert:				// note : MOVE_WalkAlert ==> s_Alert
				case MOVE_Snipe:
					
					AWaitIn							= '';
					AWaitOut						= '';

					AWait							= 'waitStAlFd2';
					AWaitLeft						= 'waitStAlLt2';
					AWaitRight						= 'waitStAlRt2';

					ATurnRight						= 'TurnStAlNt2';

					if (bSniper)
					{
						ABlendMovement.m_forward		= 'WalkStNmFd2';
						ABlendMovement.m_forwardLeft	= 'walkStNmLt2';
						ABlendMovement.m_forwardRight	= 'walkStNmRt2';
					}
					else
					{
						ABlendMovement.m_forward		= 'walkStAlFd2';
						ABlendMovement.m_forwardLeft	= 'walkStAlLt2';
						ABlendMovement.m_forwardRight	= 'walkStAlRt2';
					}

					APeekLeftBegin					= 'PeekStBgLt2';
					APeekLeft						= 'PeekStNtLt2';
					APeekRightBegin					= 'PeekStBgRt2';
					APeekRight						= 'PeekStNtRt2';

					break;

				case MOVE_JogAlert :
				case MOVE_JogNoWeapon :

					AWaitIn							= '';
					AWaitOut						= '';

					AWait							= 'waitStAlFd2';
					AWaitLeft						= 'waitStAlLt2';
					AWaitRight						= 'waitStAlRt2';

					ATurnRight						= 'TurnStAlNt2';

					ABlendMovement.m_forward		= 'JoggStAlFd2';
					ABlendMovement.m_forwardLeft	= 'JoggStAlLt2';
					ABlendMovement.m_forwardRight	= 'JoggStAlRt2';
					
					APeekLeftBegin					= 'PeekStBgLt2';
					APeekLeft						= 'PeekStNtLt2';
					APeekRightBegin					= 'PeekStBgRt2';
					APeekRight						= 'PeekStNtRt2';
					
					break;

				case MOVE_CrouchWalk :  
					
					AWaitIn							= '';
					AWaitOut						= '';

					AWait							= 'waitCrAlFd2';
					AWaitLeft						= 'waitCrAlLt2';
					AWaitRight						= 'waitCrAlRt2';

					ATurnRight						= 'TurnCrAlNt2';

					ABlendMovement.m_forward		= 'walkCrNmFd2';
					ABlendMovement.m_forwardLeft	= 'walkCrNmLt2';
					ABlendMovement.m_forwardRight	= 'walkCrNmRt2';

					APeekLeftBegin					= 'PeekCrBgLt2';
					APeekLeft						= 'PeekCrNtLt2';
					APeekRightBegin					= 'PeekCrBgRt2';
					APeekRight						= 'PeekCrNtRt2';
					
					break;

				case MOVE_CrouchJog : 

					AWaitIn							= '';
					AWaitOut						= '';

					AWait							= 'waitCrAlFd2';
					AWaitLeft						= 'waitCrAlLt2';
					AWaitRight						= 'waitCrAlRt2';

					ATurnRight						= 'TurnCrAlNt2';

					ABlendMovement.m_forward		= 'joggCrAlFd2';	
					ABlendMovement.m_forwardLeft	= 'joggCrAlLt2';	
					ABlendMovement.m_forwardRight	= 'joggCrAlRt2';

					APeekLeftBegin					= 'PeekCrBgLt2';
					APeekLeft						= 'PeekCrNtLt2';
					APeekRightBegin					= 'PeekCrBgRt2';
					APeekRight						= 'PeekCrNtRt2';
					
					break;

			}
	}
}

function PlayReload(optional bool upperOnly, optional bool bigTween)
{
	if (!bIsCrouched)
		BlendAnimOverCurrent(AReload, 1, UpperBodyBoneName,1.0,0.2);
	else
		BlendAnimOverCurrent(AReloadCrouch, 1, UpperBodyBoneName,1.0,0.2);
}

//---------------------------------------[David Kalina - 25 Mar 2002]-----
// 
// Description
//		Return appropriate Reaction Animation based on character and anim state.
//		Either specifies a single out animation as a reaction, or it 
//		specifies two animations and a BlendAlpha for use in GOAL_Action.
// 
//------------------------------------------------------------------------

function GetReactionAnim(out name Anim, out name AnimB, out float BlendAlpha, optional eReactionAnimGroup ReactionGroup)
{
	if (ReactionGroup == REACT_None)
		return;

	switch (WeaponStance)
	{
		case 0 :
			switch (ReactionGroup) 
			{

				// STRAIGHT UP REACTION ANIMS
				case REACT_ImmediateThreat :
					Anim		= 'ReacStNmBB0';
					break;

				case REACT_MovingObject :
					Anim		= 'LookStNmFd0';
					break;

				case REACT_BrokenObject :
					Anim		= 'LookStNmDn0';
					break;

				case REACT_SeeUnknownPerson :
					Anim		= 'LookStNmFd0';
					break;

				case REACT_SeeGrenade :
					break;

				case REACT_Blinded :
					Anim		= 'FlshStAlBg0';
					break;

				case REACT_SearchFailed :
					Anim		= 'ReacStNmAA0';
					break;

				case REACT_SeeInterrogation :
					Anim		= 'SignStAlFd0';
					break;

				case REACT_Surprised :
					Anim		= 'ReacStNmZZ0';
					break;

				case REACT_AboutToDie :
                    Anim        = 'PrsoCrALAA0';
					break;

				// BLENDED REACTIONS
				case REACT_CuriousNoise :

					Anim		= 'ReacStNmFd0';
					AnimB		= 'ReacStAlFd0';
					BlendAlpha  = 0.0f;

					break;
				
				case REACT_CuriousObject :

					Anim		= 'ReacStNmFd0';
					AnimB		= 'ReacStAlFd0';
					BlendAlpha  = 0.0f;
					break;

				case REACT_SeeLightsOut :
					Anim		= 'ReacStNmFd0';
					AnimB		= 'ReacStAlFd0';
					BlendAlpha  = 0.35f;
					break;
					
				case REACT_AlarmingNoise :

					Anim		= 'ReacStNmFd0';
					AnimB		= 'ReacStAlFd0';
					BlendAlpha  = 0.5f;

					break;

				case REACT_SeeWallMine :
					Anim		= 'ReacStNmFd0';
					AnimB		= 'ReacStAlFd0';
					BlendAlpha  = 0.75f;
					break;

				case REACT_DistantThreat :
					
					Anim		= 'ReacStNmFd0';
					AnimB		= 'ReacStAlFd0';
					BlendAlpha  = 1.0f;
					
					break;

				case REACT_SeeBody :
					Anim		= 'ReacStNmFd0';
					AnimB		= 'ReacStAlFd0';
					BlendAlpha  = 1.0f;
					break;

			}

			break;


		case 1 :

			switch (ReactionGroup) 
			{

				// STRAIGHT UP REACTION ANIMS
				case REACT_ImmediateThreat :
					Anim		= 'ReacStNmBB1';
					break;

				case REACT_MovingObject :
					Anim		= 'LookStNmFd1';
					break;

				case REACT_BrokenObject :
					Anim		= 'LookStNmDn1';
					break;

				case REACT_SeeUnknownPerson :
					Anim		= 'LookStNmFd1';
					break;

				case REACT_SeeGrenade :
					break;

				case REACT_Blinded :
					Anim		= 'FlshStAlBg1';
					break;

				case REACT_SearchFailed :
					Anim		= 'ReacStNmAA1';
					break;

				case REACT_SeeInterrogation :
					Anim		= 'SignStAlFd1';
					break;

				case REACT_Surprised :
					Anim		= 'ReacStNmZZ1';
					break;

				case REACT_AboutToDie :
                    Anim        = 'PrsoCrALAA1';
					break;

				// BLENDED REACTIONS
				case REACT_CuriousNoise :

					Anim		= 'ReacStNmFd1';
					AnimB		= 'ReacStAlFd1';
					BlendAlpha  = 0.0f;

					break;
				
				case REACT_CuriousObject :

					Anim		= 'ReacStNmFd1';
					AnimB		= 'ReacStAlFd1';
					BlendAlpha  = 0.0f;
					break;

				case REACT_SeeLightsOut :
					Anim		= 'ReacStNmFd1';
					AnimB		= 'ReacStAlFd1';
					BlendAlpha  = 0.35f;
					break;
					
				case REACT_AlarmingNoise :

					Anim		= 'ReacStNmFd1';
					AnimB		= 'ReacStAlFd1';
					BlendAlpha  = 0.5f;

					break;

				case REACT_SeeWallMine :
					Anim		= 'ReacStNmFd1';
					AnimB		= 'ReacStAlFd1';
					BlendAlpha  = 0.75f;
					break;

				case REACT_DistantThreat :
					
					Anim		= 'ReacStNmFd1';
					AnimB		= 'ReacStAlFd1';
					BlendAlpha  = 1.0f;
					
					break;

				case REACT_SeeBody :
					Anim		= 'ReacStNmFd1';
					AnimB		= 'ReacStAlFd1';
					BlendAlpha  = 1.0f;
					break;

			}

			break;

		case 2 : 

			switch (ReactionGroup) 
			{

				// STRAIGHT UP REACTION ANIMS
				case REACT_ImmediateThreat :
					Anim		= 'ReacStNmBB2';
					break;

				case REACT_MovingObject :
					Anim		= 'LookStNmFd2';
					break;

				case REACT_BrokenObject :
					Anim		= 'LookStNmDn2';
					break;

				case REACT_SeeUnknownPerson :
					Anim		= 'LookStNmFd2';
					break;

				case REACT_SeeGrenade :
					break;

				case REACT_Blinded :
					Anim		= 'FlshStAlBg2';
					break;

				case REACT_SearchFailed :
					Anim		= 'ReacStNmAA2';
					break;

				case REACT_SeeInterrogation :
					Anim		= 'SignStAlFd2';
					break;

				case REACT_Surprised :
					Anim		= 'ReacStNmZZ2';
					break;

				case REACT_AboutToDie :
                    Anim        = 'PrsoCrALAA2';
					break;

				// BLENDED REACTIONS
				case REACT_CuriousNoise :

					Anim		= 'ReacStNmFd2';
					AnimB		= 'ReacStAlFd2';
					BlendAlpha  = 0.0f;

					break;
				
				case REACT_CuriousObject :

					Anim		= 'ReacStNmFd2';
					AnimB		= 'ReacStAlFd2';
					BlendAlpha  = 0.0f;
					break;

				case REACT_SeeLightsOut :
					Anim		= 'ReacStNmFd2';
					AnimB		= 'ReacStAlFd2';
					BlendAlpha  = 0.35f;
					break;
					
				case REACT_AlarmingNoise :

					Anim		= 'ReacStNmFd2';
					AnimB		= 'ReacStAlFd2';
					BlendAlpha  = 0.5f;

					break;

				case REACT_SeeWallMine :
					Anim		= 'ReacStNmFd2';
					AnimB		= 'ReacStAlFd2';
					BlendAlpha  = 0.75f;
					break;

				case REACT_DistantThreat :
					
					Anim		= 'ReacStNmFd2';
					AnimB		= 'ReacStAlFd2';
					BlendAlpha  = 1.0f;
					
					break;

				case REACT_SeeBody :
					Anim		= 'ReacStNmFd2';
					AnimB		= 'ReacStAlFd2';
					BlendAlpha  = 1.0f;
					break;

			}

			break;

	}
}



//---------------------------------------[David Kalina - 13 Aug 2001]-----
// 
// Description
//		Check for possible transition animation between 
//		our current BaseMoveFlags and the input NewMoveFlags.
// 
//------------------------------------------------------------------------

event CheckForTransition(MoveFlags NewMoveFlags)
{

	// CHECK FOR CROUCH / UNCROUCH

	switch (BaseMoveFlags)
	{
		case MOVE_WalkRelaxed :
		case MOVE_WalkNormal :
		case MOVE_WalkAlert :
		case MOVE_Search :
		case MOVE_JogAlert:
		case MOVE_JogNoWeapon :
			
			// are we crouching?
			if (!bIsCrouched)
			{
				switch (NewMoveFlags)
				{
					case MOVE_CrouchJog:
					case MOVE_CrouchWalk:
						switch (WeaponStance)
						{
							case 0 : 
								Transition_Standard('WaitCrAlBg0', 0.3f, true);
								break;
							case 1 : 
								Transition_Standard('WaitCrAlBg1', 0.3f, true);
								break;
							case 2 : 
								Transition_Standard('WaitCrAlBg2', 0.3f, true);
								break;
						}
						break;
				}
			}

			break;

		case MOVE_CrouchJog:
		case MOVE_CrouchWalk:

			// are we uncrouching?

			if (bIsCrouched)
			{
				switch (NewMoveFlags) 
				{
					case MOVE_WalkRelaxed:
					case MOVE_WalkNormal:
					case MOVE_WalkAlert:
					case MOVE_Search:
					case MOVE_JogAlert:
					case MOVE_JogNoWeapon:

						switch (WeaponStance)
						{
							// uncrouch anims are crouch begin animations played backwards
							case 0 : 
								Transition_Standard('WaitCrAlBg0', 0.3f, true, true);
								break;
							case 1 : 
								Transition_Standard('WaitCrAlBg1', 0.3f, true, true);
								break;
							case 2 : 
								Transition_Standard('WaitCrAlBg2', 0.3f, true, true);
								break;
						}
						break;
				}
			}

			break;
	}


	// CHECK FOR WEAPON DRAW / PUT AWAY

	// don't draw weapon if going to MOVE_JogNoWeapon

	switch (BaseMoveFlags) 
	{
		case MOVE_WalkRelaxed :
		case MOVE_Sit :
		case MOVE_JogNoWeapon :
			
			// draw weapon
			switch (NewMoveFlags)
			{				
				case MOVE_WalkNormal : 
				case MOVE_WalkAlert : 
				case MOVE_Search :
				case MOVE_JogAlert:
				case MOVE_CrouchJog :
				case MOVE_CrouchWalk : 

					if (WeaponHandedness > 0 && WeaponStance == 0)
					{
						plog("Transition_WeaponSelect");
						Transition_WeaponSelect();
					}

					break;
			}

			break;

		case MOVE_WalkRelaxed:
		case MOVE_WalkNormal :
		case MOVE_WalkAlert :
		case MOVE_Search :
		case MOVE_JogAlert:	
		case MOVE_CrouchJog :
		case MOVE_CrouchWalk : 

			// put away weapon
			if (WeaponStance > 0)
			{
				if (NewMoveFlags == MOVE_WalkRelaxed || NewMoveFlags == MOVE_Sit)
				{
					Transition_WeaponAway();
				}
			}
			
			break;
	}
}






//---------------------------------------[David Kalina - 22 Oct 2001]-----
// 
// Description
//		Return a wait cycle depending on the current MoveFlags.
// 
//------------------------------------------------------------------------

event GetRandomWaitAnim(out name ReturnName)
{
	local int choice;


	if (IsPawnTalking())
	{
		//
		//
		// CHOOSE TALKING ANIMATIONS 
		//
		//

		choice = rand(4);

		switch (choice)
		{
			case 0 : ReturnName = 'TalkStNmAA0'; break;
			case 1 : ReturnName = 'TalkStNmBB0'; break;
			case 2 : ReturnName = 'TalkStNmCC0'; break;
			case 3 : ReturnName = 'TalkStNmDD0'; break;
		}
	}

	else
	{

		//
		//
		// CHOOSE STANDARD PERSONALITY ANIMATIONS 
		//
		//

		choice = rand(50);

		switch (WeaponStance)
		{				
			case 0 : 
				if (choice < 5)  { ReturnName = 'PrsoStNmAA0'; return; }
				if (choice < 8)  { ReturnName = 'PrsoStNmBB0'; return; }
				if (choice < 12) { ReturnName = 'PrsoStNmCC0'; return; }
				if (choice < 17) { ReturnName = 'PrsoStNmDD0'; return; }
				if (choice < 24) { ReturnName = 'PrsoStNmEE0'; return; }
				if (choice < 27) { ReturnName = 'LookStNmBk0'; return; }
				if (choice < 32) { ReturnName = 'LookStNmLt0'; return; }
				if (choice < 37) { ReturnName = 'LookStNmRt0'; return; }
				if (choice < 40) { ReturnName = 'LookStNmUp0'; return; }
				if (choice < 50) { ReturnName = 'ReacStNmFd0'; return; }


				return;

			case 1 : 
				if (choice < 5)  { ReturnName = 'PrsoStNmAA1'; return; }
				if (choice < 8)  { ReturnName = 'PrsoStNmBB1'; return; }
				if (choice < 15) { ReturnName = 'PrsoStNmCC1'; return; }
				if (choice < 20) { ReturnName = 'PrsoStNmDD1'; return; }
				if (choice < 23) { ReturnName = 'LookStNmBk1'; return; }
				if (choice < 28) { ReturnName = 'LookStNmLt1'; return; }
				if (choice < 33) { ReturnName = 'LookStNmRt1'; return; }
				if (choice < 35) { ReturnName = 'LookStNmUp1'; return; }
				if (choice < 50) { ReturnName = 'ReacStNmFd1'; return; }

				return;

			case 2 : 
				if (choice < 5)  { ReturnName = 'PrsoStNmAA2'; return; }
				if (choice < 12) { ReturnName = 'PrsoStNmBB2'; return; }
				if (choice < 20) { ReturnName = 'PrsoStNmCC2'; return; }
				if (choice < 25) { ReturnName = 'PrsoStNmDD2'; return; }
				if (choice < 28) { ReturnName = 'LookStNmBk2'; return; }
				if (choice < 33) { ReturnName = 'LookStNmLt2'; return; }
				if (choice < 38) { ReturnName = 'LookStNmRt2'; return; }
				if (choice < 40) { ReturnName = 'LookStNmUp2'; return; }
				if (choice < 50) { ReturnName = 'ReacStNmFd2'; return; }

				return;
		}
	}
}




//---------------------------------------[David Kalina - 16 Apr 2002]-----
// 
// Description
//		Test for currently playing random anim.
// 
//------------------------------------------------------------------------

function bool IsExtraWaiting(optional int f)
{
	local name CurrentAnimSeq;
	local float CurrentFrame, CurrentRate;
	GetAnimParams(0, CurrentAnimSeq, CurrentFrame, CurrentRate);
	
	switch (WeaponStance)
	{				
		case 0 : 	

			return CurrentAnimSeq == 'PrsoStNmAA0' || 
				   CurrentAnimSeq == 'PrsoStNmBB0' || 
				   CurrentAnimSeq == 'PrsoStNmCC0' || 
				   CurrentAnimSeq == 'PrsoStNmDD0' ||
				   CurrentAnimSeq == 'PrsoStNmEE0' ||
				   CurrentAnimSeq == 'LookStNmBk0' ||
				   CurrentAnimSeq == 'LookStNmLt0' ||
				   CurrentAnimSeq == 'LookStNmRt0' ||
				   CurrentAnimSeq == 'LookStNmUp0' ||
				   CurrentAnimSeq == 'ReacStNmFd0';
		  
		case 1 : 

			return CurrentAnimSeq == 'PrsoStNmAA1' || 
				   CurrentAnimSeq == 'PrsoStNmBB1' || 
				   CurrentAnimSeq == 'PrsoStNmCC1' || 
				   CurrentAnimSeq == 'PrsoStNmDD1' ||
				   CurrentAnimSeq == 'LookStNmBk1' ||
				   CurrentAnimSeq == 'LookStNmLt1' ||
				   CurrentAnimSeq == 'LookStNmRt1' ||
				   CurrentAnimSeq == 'LookStNmUp1' ||
				   CurrentAnimSeq == 'ReacStNmFd1';

		case 2 : 

			return CurrentAnimSeq == 'PrsoStNmAA2' || 
				   CurrentAnimSeq == 'PrsoStNmBB2' || 
				   CurrentAnimSeq == 'PrsoStNmCC2' || 
				   CurrentAnimSeq == 'PrsoStNmDD2' ||
				   CurrentAnimSeq == 'LookStNmBk2' ||
				   CurrentAnimSeq == 'LookStNmLt2' ||
				   CurrentAnimSeq == 'LookStNmRt2' ||
				   CurrentAnimSeq == 'LookStNmUp2' ||
				   CurrentAnimSeq == 'ReacStNmFd2';
	}

	return false;
}




/*************  SET ANIMATION SPEED FOR MODEL  ******************/
// to be eventually replaced with root motion speed


event float GetMoveSpeed(MoveFlags MoveFlags)
{
	//force slow walk in pitch black
	if (bPitchBlack)
		return 85.0f;

	// apply speed based on move flag
	switch (MoveFlags)
	{
		case MOVE_WalkRelaxed : 
			return 130.0f;
			break;
			
		case MOVE_WalkNormal : 
			return 130.0f;
			break;
			
		case MOVE_Search : 
			return 130.0f;
			break;
			
		case MOVE_Snipe : 
			return 130.0f;
			break;
			
		case MOVE_WalkAlert :
			return 130.0f;
			break;
			
		case MOVE_JogAlert :
			return 350.0f;
			break;
			
		case MOVE_JogNoWeapon: 
			return 350.0f;
			break;
			
		case MOVE_CrouchWalk :
			return 85.0f;
			break;
			
		case MOVE_CrouchJog : 
			return 200.0f;
			break;

		case MOVE_DesignerWalk :
			return DesignerWalkSpeed;
			break;
	}

	log("WARNING : GetMoveSpeed not switching on input MoveFlags.");
	return GroundSpeed;
}



//---------------------------------------[David Kalina - 25 Sep 2001]-----
// 
// Description
//		Intended to check EAIController state and ensure that our 
//		MoveFlags match the current state.
//
// Input
//		NewMoveFlags : 
//
//------------------------------------------------------------------------

event MoveFlags UpdateMoveFlagState(MoveFlags NewMoveFlags, optional bool _bForceAware)
{
	switch (NewMoveFlags)
	{
		// regardless of MOVE_Walk -- always return the MOVE_Walk<X> based on state
		case MOVE_WalkNormal :	
		case MOVE_WalkRelaxed : 
		case MOVE_WalkAlert :
		case MOVE_Search:

			if (AI.GetStateName() == 's_Default')
				return MOVE_WalkRelaxed;
			
			if (AI.GetStateName() == 's_Investigate')
				return MOVE_WalkNormal;
			
			if (AI.GetStateName() == 's_Alert')
            {
                if (_bForceAware)
    				return MOVE_WalkNormal;
                else
				    return MOVE_WalkAlert;
            }
			else
			{
				if (AI.m_LastStateName == 's_Default')
					return MOVE_WalkRelaxed;
				
				if (AI.m_LastStateName == 's_Investigate')
					return MOVE_WalkNormal;
				
				if (AI.m_LastStateName == 's_Alert')
				{
					if (_bForceAware)
    					return MOVE_WalkNormal;
					else
						return MOVE_WalkAlert;
				}
			}

			break;
	}
	
	return NewMoveFlags;
}

//----------------------------------------[David Kalina - 6 Mar 2002]-----
// 
// Description
//		Forward event to AIController so it can send event to group.
// 
//------------------------------------------------------------------------

function NotifyShotJustMissed(Pawn Instigator)
{
	AI.NotifyShotJustMissed(Instigator);
}



//---------------------------------------[David Kalina - 25 Apr 2002]-----
// 
// Description
//		Check for entering flashlight zone.
// 
//------------------------------------------------------------------------
function SetVolumeZone(bool bEntering, EVolume Volume)
{
	if (Volume.bFlashlightVolume)
	{
		if (bEntering)
			AI.bInFlashlightVolume = true;
		else
			AI.bInFlashLightVolume = false;
	}

	Super.SetVolumeZone(bEntering, Volume);
}


//---------------------------------------[David Kalina - 17 Apr 2002]-----
// 
// Description
//		Re-definition of base EPawn PlayNarrowLadderOutBottom.
// 
//------------------------------------------------------------------------

function PlayNarrowLadderOutBottom()
{
	// rotational root motion anim
	LockRootMotion(1, true);

	if (m_climbingUpperHand == CHLEFT)
		PlayAnimOnly(ANLOutBottomRight);
	else
		PlayAnimOnly(ANLOutBottomLeft);
}



//----------------------------------------[David Kalina - 1 May 2002]-----
// 
// Description
//		Get appropriate weapon selection animation.
//
//------------------------------------------------------------------------

function name GetWeaponSelectAnim()
{
	if (bIsCrouched)
	{
		// weapon selection depends on the handedness of the weapon this AI owns
		switch (WeaponHandedness) 
		{ 
			case 0 : 
				return '';
				
			case 1 : 
				return 'DrawCrAlLb1';

			case 2 : 
				return 'DrawCrAlBg2';
		}
	}
	else
	{
		// weapon selection depends on the handedness of the weapon this AI owns
		switch (WeaponHandedness) 
		{ 
			case 0 : 
				return '';
				
			case 1 : 
				return 'DrawStAlLb1';

			case 2 : 
				return 'DrawStAlBg2';
		}
	}
}
			

//----------------------------------------[David Kalina - 2 May 2002]-----
// 
// Description
//		Item selection depends on current crouch / uncrouch status.
// 
//------------------------------------------------------------------------

function name GetItemSelectAnim()
{
	local EPlayerController EPC; // Joshua - Back to Wall throw support

	EPC = EPlayerController(Owner);

	if (!PendingItem.bIsProjectile)
		return '';

	// Joshua - Back to Wall throw support
	if (EPC.bBTWThrow)
	{
		if (EPC.m_BTWSide)
		{
			if (bIsCrouched)
				return 'PT_BackCrThBgR';
			else
				return 'PT_BackStThBgR';
		}
		else
		{
			if (bIsCrouched)
				return 'PT_BackCrThBgL';
			else
				return 'PT_BackStThBgL';
		}
	}

	if (bIsCrouched)
		return 'ThroCrAlBgH';
	else
		return 'ThroStAlBgH';
}


//----------------------------------------[David Kalina - 5 May 2002]-----
// 
// Description
//		Play damage animation.  
// 
//------------------------------------------------------------------------
function PlayHitE(int PillTag, Vector HitLocation, Vector Momentum)
{
	if ((AI.bIsOnLadder) || (bDontPlayDamageAnim))
		return;

	Super.PlayHitE(PillTag, HitLocation, Momentum);
}

function PlayNPCGear()
{
	if (SoundWalkingRatio < 0.65)
		PlaySound(GearSoundWalk, SLOT_SFX);
	else
		PlaySound(GearSoundRun, SLOT_SFX);
}

function bool PressingFire()
{
	return  EAIController(controller).bfiring;
}

defaultproperties
{
    AccuracyDeviation=1.000000
    MinSearchTime=30.000000
    DyingGaspRadius=900.000000
    KnockedGaspRadius=250.000000
    ElectrocutedGaspRadius=400.000000
    IntuitionTime=1.000000
    TimeBeforePlayerCanHide=0.750000
    PlayerCanHideDistance=50.000000
    Laziness_DefaultState=0.700000
    Laziness_AwareState=0.400000
    Laziness_AlertState=0.200000
    IgnoreGroupNoiseType=NOISE_HeavyFootstep
    IgnoreNPCNoiseType=NOISE_HeavyFootstep
    EyeBoneName="BLftEye"
    UpperBodyBoneName="B Spine2"
    YawTurnSpeed=65000
    ABlendGrab=(m_forward="grabstalfd0",m_backward="grabstalbk0",m_forwardRight="grabstalrt0")
	PawnSampleBrightness(0)=(BoneName="B Head")
	PawnSampleBrightness(1)=(BoneName="B Spine")
	PawnSampleBrightness(2)=(BoneName="B Spine1")
	PawnSampleBrightness(3)=(BoneName="B Spine2")
	PawnSampleBrightness(4)=(BoneName="B R UpperArm")
	PawnSampleBrightness(5)=(BoneName="B R Forearm")
	PawnSampleBrightness(6)=(BoneName="B R Hand")
	PawnSampleBrightness(7)=(BoneName="B L UpperArm")
	PawnSampleBrightness(8)=(BoneName="B L Forearm")
	PawnSampleBrightness(9)=(BoneName="B L Hand")
	PawnSampleBrightness(10)=(BoneName="B R Thigh")
	PawnSampleBrightness(11)=(BoneName="B R Calf")
	PawnSampleBrightness(12)=(BoneName="B R Foot")
	PawnSampleBrightness(13)=(BoneName="B L Thigh")
	PawnSampleBrightness(14)=(BoneName="B L Calf")
	PawnSampleBrightness(15)=(BoneName="B L Foot")
    AnimSequence="waitStNmFd2"
    GroundSpeed=400.000000
    AirControl=0.350000
    CrouchHeight=45.000000
    CrouchRadius=35.000000
    m_NarrowLadderArmsZone=(X=38.000000,Y=0.000000,Z=100.000000)
    m_NarrowLadderArmsRadius=10.000000
    bBlockNPCVision=False
    bIsNPCPawn=True
}