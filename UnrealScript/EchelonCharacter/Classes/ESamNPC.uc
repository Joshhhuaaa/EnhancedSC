//===============================================================================
//  [spetsnaz] 
//===============================================================================

class ESamNPC extends EAIPawn
	placeable;

//---------------------------------------[David Kalina - 29 Oct 2001]-----
// 
// Description
//		Set randomized animation rate for AI pawns.
// 
//------------------------------------------------------------------------
function PostBeginPlay()
{
	local EWeapon Weapon;
	local MeshAnimation Anim;
	local int i;

	RandomizedAnimRate = 0.97f + RandRange(0.0f, 0.06f);

	// Joshua - Check for level specific overrides
	switch (GetCurrentMapName())
    {
        case "0_0_2_Training":
        case "0_0_3_Training":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Training);
            break;
            
        case "1_1_0Tbilisi":
        case "1_1_1Tbilisi": 
        case "1_1_2Tbilisi":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Tbilisi);
            break;

		case "1_2_1DefenseMinistry":
        case "1_2_2DefenseMinistry": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_DefenseMinistry);
            break;

		case "1_3_2CaspianOilRefinery":
        case "1_3_3CaspianOilRefinery": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_CaspianOilRefinery);
            break;

        case "2_1_0CIA":
        case "2_1_1CIA":
		case "2_1_2CIA":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_CIA);
            break;
            
        case "2_2_1_Kalinatek":
        case "2_2_2_Kalinatek": 
        case "2_2_3_Kalinatek":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Kalinatek);
            break;

		case "3_2_1_PowerPlant":
        case "3_2_2_PowerPlant": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_PowerPlant);
            break;

        case "3_4_2Severonickel":
        case "3_4_3Severonickel":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Severonickel);
            break;
            
        case "4_1_1ChineseEmbassy":
        case "4_1_2ChineseEmbassy": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_ChineseEmbassy);
            break;

		case "4_2_1_Abattoir":
        case "4_2_2_Abattoir": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Abattoir);
            break;

        case "4_3_0ChineseEmbassy":
        case "4_3_1ChineseEmbassy":
		case "4_3_2ChineseEmbassy":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_ChineseEmbassy2);
            break;
            
		case "5_1_1_PresidentialPalace":
        case "5_1_2_PresidentialPalace": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_PresidentialPalace);
            break;			
            
		case "1_6_1_1KolaCell":
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_KolaCell);
            break;	

		case "1_7_1_1VselkaInfiltration":
        case "1_7_1_2Vselka": 
			SetSamMesh(EchelonGameInfo(Level.Game).ESam_Vselka);
            break;

		default:
			SetSamMesh(0);
			break;
    }

	// load generic anim packages
	Anim = MeshAnimation(DynamicLoadObject("ESam.samAnims", class'MeshAnimation'));
	LinkSkelAnim(Anim);

	//
	// Weaponry
	//
	for (i = 0; i<DynInitialInventory.Length; i++)
	{
		if (DynInitialInventory[i] == class'EF2000')
		{
			Weapon = Spawn(class'EF2000', self);
			AttachToBone(Weapon, Weapon.AttachAwayTag);
		}
		else if (DynInitialInventory[i] == class'EFn7')
		{
			Weapon = Spawn(class'EFn7', self);
			AttachToBone(Weapon, Weapon.AttachAwayTag);
		}
	}

	// Remove everything to prevent the weapons to be in inventory
	DynInitialInventory.Remove(0, DynInitialInventory.Length);

	Super(EPawn).PostBeginPlay();		// skip AIPawn initialization -- don't want to link incompatible NPC animations
}




//----------------------------------------[David Kalina - 1 Aug 2001]-----
// 
// Description
//		Initialize anims for THE UNHOLY SAM
// 
//------------------------------------------------------------------------

function InitAnims()
{
	// fill most anim reference's w/ dummy names so if something is called w/out being set,
	// we know which animation is missing

	AWait								= 'AWait';
	AWaitCrouch							= 'AWaitCrouch';
	AJumpStart							= 'AJumpStart';
	AFallFree							= 'AFallFree';
	AFallQuiet							= 'AFallQuiet';
	ALandHi								= 'ALandHi';
	ALandLow							= 'ALandLow';
	ALandQuiet							= 'ALandQuiet';
	
	ASearchBody							= 'ASearchBody';
	AThrowGrenade	   				    = 'ThroStAlFdH';

	AReload						= 'reloStAlFd2';
	AReloadCrouch				= 'reloCrAlFd2';
	
	AWaitCrouch					= 'waitCrAlFd2';
	AGrabStart					= 'grabstalbg0';
	AGrabWait					= 'grabstalnt0';
	AGrabSqeeze					= 'GrabStAlIn0';
	AGrabRetinalStart			= 'GrabStCpBg0';
	AGrabRetinalWait			= 'GrabStCpNt0';
	AGrabRetinalEnd				= 'GrabStCpEd0';
	AGrabRelease				= 'grabstaled0';
	AGrabReleaseKnock			= 'grabstalko0';
	
	// ladder climbing
	ANLUpRight					= 'LaddStNmUpR';
	ANLUpLeft					= 'LaddStNmUpL';
	ANLOutBottomLeft			= 'LaddStAlIOL';
	ANLOutBottomRight			= 'LaddStAlIOR';
	ANLTopUpLeft				= 'LaddStNmEuL';
	ANLTopUpRight				= 'LaddStNmEuR';
	ANLInTop					= 'LaddStNmBu0';
	ANLTopDownRight				= 'LaddStNmBuR';	
	ANLInBottom					= 'LaddStNmBd0';
	ANLWaitLeft					= 'LaddStNmNtL';
	ANLWaitRight				= 'LaddStNmNtR';
	ANLWaitTop					= 'LaddStNmNt0';	
	ANLSlideDown				= 'LaddStNmDn0';


	// place a wallmine
	APlaceWallMine				= 'ThroStAlFdH';	// temp


	// door interactions
	ADoorOpenLt					= 'doorStNmLt0';
	ADoorOpenRt					= 'doorStNmRt0';
	ADoorTryOpenLt				= 'doorStNmLt2';	// temp
	ADoorTryOpenRt				= 'doorStNmRt2';	// temp
	ARetinalScanBegin			= 'ScanStNmBg0';
	ARetinalScan				= 'ScanStNmNt0';
	ARetinalScanEnd				= 'ScanStNmEd0';
	
	// falling
	AFall						= 'fallstalfr0';

	// Unconscious Revival Animations
	ARecover					= 'WakeStAlUp2';
	AReviveBody					= 'WakeStAlDn2';

	// ahem
	ACough						= 'SmokStAlFd0';

	// death
	ADeathForward				= 'XxxxStAlFD2';
	ADeathBack					= 'XxxxstalBK2';
	ADeathLeft					= 'XxxxstalLT2';
	ADeathRight					= 'XxxxstalRT2';

}


//---------------------------------------[David Kalina - 10 Apr 2001]-----
// 
// Description
//		Set up NPC Animations based on current BaseMoveFlags
// 
//------------------------------------------------------------------------
function SwitchAnims()
{
	//
	//
	//		SWITCH ON "WAIT FLAGS" 
	//		Crouch v. UnCrouch v. Sitting
	//
	// 

	switch (BaseMoveFlags)
	{
		case MOVE_CrouchJog :
		case MOVE_CrouchWalk :
			
			// CROUCHED ANIMS
			
			bWantsToCrouch = true;
			
			break;

		default : 

			// UNCROUCHED ANIMS

			bWantsToCrouch = false;
									
			break;
	}

	// switch anims based on WeaponStance / BaseMoveFlags
	switch (WeaponStance)
	{

		// no weapon :
			
		case 0 :
		
		// one handed weapon :

		case 1 :

		// two handed weapon :

		case 2 :

			switch (BaseMoveFlags)
			{
				case MOVE_NotSpecified :
				
					Log("SwitchAnims called with MOVE_NotSpecified -- using MOVE_WalkRelaxed and forcing BaseMoveFlags.");
					BaseMoveFlags = MOVE_WalkRelaxed;

				case MOVE_WalkRelaxed :				// note : MOVE_WalkRelaxed ==> s_Default
				case MOVE_WalkNormal:				// note : MOVE_WalkNormal ==> s_Investigate
				case MOVE_Search:
				case MOVE_WalkAlert:				// note : MOVE_WalkAlert ==> s_Alert
				case MOVE_Snipe:

					AWaitIn							= '';
					AWait							= 'waitStAlFd0';
					AWaitOut						= '';

					ABlendMovement.m_forward		= 'walkStAlFd0';

					SoundWalkingRatio = 0.60;

					break;

				case MOVE_JogAlert :
				case MOVE_JogNoWeapon :

					AWaitIn							= '';
					AWait							= 'waitStAlFd0';
					AWaitOut						= 'joggStAlEd0';

					ABlendMovement.m_forward		= 'joggStAlFd0';

					SoundWalkingRatio = 1.0;
					
					break;
				
				case MOVE_CrouchWalk :  
					
					AWaitIn							= '';
					AWait							= 'waitCrAlFd0';
					AWaitOut						= '';

					ABlendMovement.m_forward		= 'walkCrAlFd0';

					SoundWalkingRatio = 0.60;
					
					break;

				case MOVE_CrouchJog : 

					AWaitIn							= '';
					AWait							= 'waitCrAlFd0';
					AWaitOut						= '';

					ABlendMovement.m_forward		= 'joggCrAlFd0';	

					SoundWalkingRatio = 1.0;

					break;
	
			}
	}
}

// Joshua - New Sam mesh function
function SetSamMesh(int SamMeshType)
{
    switch (SamMeshType)
    {
		case 0:
			Mesh = EchelonLevelInfo(Level).SamMesh;
			if (Mesh == none)
			{
				// JFP: Temp hack, following the Oct-30-2002 merge some maps didn't have the SamMesh set.
				// Added this for backward compatibility.
				Mesh = SkeletalMesh'ESam.samAMesh';
				log("JFPDEBUG: Hardcoding the default Sam mesh, since no mesh appeared to be set in the Level. Fix this in UnrealEd. New mesh:"@Mesh);
			}
			break;
        case 1:
            Mesh = SkeletalMesh'ESam.samAMesh';
            break;
        case 2:
            Mesh = SkeletalMesh'ESam.samBMesh';
            break;
        case 3:
            Mesh = SkeletalMesh'ESam.samCMesh';
            break;
        case 4:
            Mesh = SkeletalMesh'ESam.samAMesh';
			Skins.Length = 0;
			Skins[0] = Texture(DynamicLoadObject("ETexCharacter.Sam.SamDBody", class'Texture'));
			Skins[1] = Texture(DynamicLoadObject("ETexCharacter.Sam.SamDBody", class'Texture'));
			Skins[2] = Texture(DynamicLoadObject("ETexCharacter.Sam.SamDFace", class'Texture'));
            break;
        case 5:
            Mesh = SkeletalMesh'ESam.samBMesh';
			Skins.Length = 0;
			Skins[0] = Texture(DynamicLoadObject("ETexCharacter.Sam.SamEFace", class'Texture'));
			Skins[1] = Texture(DynamicLoadObject("ETexCharacter.Sam.SamEBody", class'Texture'));
			Skins[2] = Texture(DynamicLoadObject("ETexCharacter.Sam.SamEBody", class'Texture'));
			Skins[3] = EGlow(DynamicLoadObject("ETexCharacter.Sam.pda_GLW_SamB", class'EGlow'));
			Skins[4] = Texture(DynamicLoadObject("ETexCharacter.Sam.SamEFace", class'Texture'));
            break;
        case 6:
            Mesh = SkeletalMesh'ESam.samAMesh';
			Skins.Length = 0;
			Skins[0] = Texture(DynamicLoadObject("ETexCharacter.Sam.SamFBody", class'Texture'));
			Skins[1] = Texture(DynamicLoadObject("ETexCharacter.Sam.SamFBody", class'Texture'));
			Skins[2] = Texture(DynamicLoadObject("ETexCharacter.Sam.SamFFace", class'Texture'));
            break;
        default:
			Mesh = EchelonLevelInfo(Level).SamMesh;
			if (Mesh == none)
			{
				Mesh=SkeletalMesh'ESam.samAMesh';
			}
            break;
    }
}

defaultproperties
{
    bNoBlending=True
    bDontCheckChangedActor=True
    m_VisibilityConeAngle=0.000000
    m_VisibilityMaxDistance=0.000000
    m_VisibilityAngleVertical=0.000000
    m_MaxPeripheralVisionDistance=0.000000
}