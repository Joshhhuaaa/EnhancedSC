class EMitch extends EAINonHostile
	placeable;

var float WalkSpeed;
var float RunSpeed;

function PostBeginPlay()
{
	local MeshAnimation Anim;

	
	Super(EAIPawn).PostBeginPlay();
	
	// load mitch anim package

	if (Mesh != None)
	{
		Anim = MeshAnimation(DynamicLoadObject("ENPC.MitchAnims", class'MeshAnimation'));
		LinkSkelAnim(Anim);
	}
}

function InitAnims()
{
	AWait						= 'MitcStNmNt0';

	// so we know what's missing ...
	ABlendMovement.m_forwardLeft	= 'forwardleft';
	ABlendMovement.m_forwardRight	= 'forwardright';
	ABlendMovement.m_backward		= 'backward';
	ABlendMovement.m_backwardLeft	= 'backwardleft';
	ABlendMovement.m_backwardRight	= 'backwardright';

	Super.InitAnims();

	AGrabStart					= 'GrabStAlBg0';
	AGrabWait					= 'GrabStAlNt0';
	AGrabSqeeze					= 'GrabStAlIn0';
	AGrabRetinalStart			= 'GrabStScBg0';
	AGrabRetinalWait			= 'GrabStScNt0';
	AGrabRetinalEnd				= 'GrabStScEd0';
	AGrabRelease				= 'GrabStAlEd0';
	AGrabReleaseKnock			= 'GrabStAlKo0';

	ADeathForward				= 'XxxxStAlFd0';
	ADeathBack					= 'XxxxStAlBk0';
	ADeathLeft					= 'XxxxStAlLt0';
	ADeathRight					= 'XxxxStAlRt0';
	ADeathDown					= 'XxxxStAlDn0';

	AFragForward				= 'FragStAlFd0';
	AFragBack					= 'FragStAlBk0';
	AFragLeft					= 'FragStAlLt0';
	AFragRight					= 'FragStAlRt0';

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

}


function SwitchAnims()
{
	local MoveFlags  lmoveflag;

	lmoveflag = BaseMoveFlags;

	ATurnBRight					= 'TurnStNmBr0';
	ATurnBLeft					= 'TurnStNmBl0';
	ATurnLt						= 'TurnStNmLt0';
	ATurnRt						= 'TurnStNmRt0';

	//special case for grabbed NPCs that were sit
	if (GetStateName() == 's_Grabbed')
		lmoveflag= MOVE_WalkNormal;

	switch (lmoveflag)
	{
		case MOVE_WalkRelaxed:
		case MOVE_WalkNormal: 
		case MOVE_WalkAlert:
			bNoBlending = true;

			AWait					 = 'MitcStNmNt0';
			ABlendMovement.m_forward = 'MitcStNmFd0';
			break;

		case MOVE_JogAlert:
		case MOVE_JogNoWeapon:
			
			AWait					 = 'WaitStAlFd0';
			ABlendMovement.m_forward = 'JoggStAlFd0';
			SoundWalkingRatio = 1.0;
			break;

		case MOVE_CrouchWalk: 
			break;

		case MOVE_CrouchJog:
			break;

		case MOVE_Search:
			break;

		case MOVE_Snipe:
			break;

		case MOVE_DesignerWalk:
			bNoBlending = true;

			AWait							= 'MitcStNmNt0';
			ABlendMovement.m_forward		= 'MitcStNmFd0';	
			
			return;
	}
}


event float GetMoveSpeed(MoveFlags MoveFlags)
{
	//force slow walk in pitch black
	if (bPitchBlack)
		return 85.0f;

	// apply speed based on move flag
	switch (MoveFlags)
	{
		case MOVE_WalkRelaxed:
		case MOVE_DesignerWalk:
			return 85.0f;
			break;
			
		case MOVE_WalkNormal:
			return 85.0f;
			break;
			
		case MOVE_Search:
			return 85.0f;
			break;
			
		case MOVE_Snipe:
			return 85.0f;
			break;
			
		case MOVE_WalkAlert:
			return 85.0f;
			break;
			
		case MOVE_JogAlert:
			return 350.0f;
			break;
			
		case MOVE_JogNoWeapon:
			return 350.0f;
			break;
			
		case MOVE_CrouchWalk:
			return 85.0f;
			break;
			
		case MOVE_CrouchJog:
			return 200.0f;
			break;

	}

	log("WARNING : GetMoveSpeed not switching on input MoveFlags.");
	return GroundSpeed;
}




/*************  SET ANIMATION SPEED FOR MODEL  ******************/
// to be eventually replaced with root motion speed


/*function PlayBlend(SAnimBlend	anims,
				   Rotator		lookDir,
				   vector		moveDir,
				   float		minForwardRatio,
				   float		tweenTime,
				   optional bool noloop)
{
	
	// apply speed based on move flag
	switch (BaseMoveFlags)
	{
		case MOVE_CrouchWalk :	
		case MOVE_CrouchJog : 	
		case MOVE_WalkAlert :
		case MOVE_WalkRelaxed : 
		case MOVE_WalkNormal : 
		case MOVE_Search : 
		case MOVE_Snipe :
			
			GroundSpeed = WalkSpeed;
			break;
						
		case MOVE_JogAlert :
		case MOVE_JogNoWeapon : 

			GroundSpeed = RunSpeed;
			break;

	}
	
	Super.PlayBlend(anims, lookDir, moveDir, minForwardRatio, tweenTime);
}*/

defaultproperties
{
    WalkSpeed=73.000000
    RunSpeed=325.000000
    GearSoundWalk=Sound'GearCommon.Play_Random_CivilGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_CivilGearRun'
    bNoBlending=true
    GroundSpeed=200.000000
    Mesh=SkeletalMesh'ENPC.mitchMesh'
}