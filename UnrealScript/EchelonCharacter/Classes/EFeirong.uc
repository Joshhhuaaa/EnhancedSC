//===============================================================================
//  [EFeirong] 
//===============================================================================

class EFeirong extends EAINonHostile
	placeable;

var() bool				bHasBottleInHand;
var   EGameplayObject	Bottle;

function PostBeginPlay()
{
	local MeshAnimation Anim;

	Super.PostBeginPlay();

	// bottle
	if( bHasBottleInHand )
	{
		Bottle = spawn(class'EKolaVodka', self);
		Bottle.SetCollision(false);
		Bottle.ResetInteraction();
		AttachToBone(Bottle, 'BottleBone');
	}

	// load generic anim packages
	if(Mesh != None)
	{
		Anim = MeshAnimation(DynamicLoadObject("ENPC.FeirongAnims", class'MeshAnimation'));
		LinkSkelAnim( Anim );

	}
}


function InitAnims()
{
	Super.InitAnims();

	if(bDrunk)
	{
		AWait							= 'FeirStNmDk0';

		AStandUpR						= 'FeirAsNmUp0';
		AStandUpL						= 'FeirAsNmUp0';
		AWaitSitT						= 'FeirAsNmNt0';
	}
}


function GetReactionAnim(out name Anim, out name AnimB, out float BlendAlpha, optional eReactionAnimGroup ReactionGroup)
{
	if(!bDrunk)
		Super.GetReactionAnim(Anim, AnimB, BlendAlpha,ReactionGroup);
}

function name GetWeaponSelectAnim()
{
	if(!bDrunk)
		return Super.GetWeaponSelectAnim();
	else
		return '';
}


function SwitchAnims()
{
	local MoveFlags  lmoveflag;

	lmoveflag=BaseMoveFlags;

	//special case for grabbed NPCs that were sit
	if(GetStateName() == 's_Grabbed')
		lmoveflag= MOVE_WalkNormal;


	Super.SwitchAnims();

	if(bDrunk)
	{
		ATurnRight	= '';

		switch (WeaponStance)
		{
			// one handed weapon :
			case 1 :

				switch (lmoveflag)		
				{
					case MOVE_WalkRelaxed :
					case MOVE_WalkNormal : 
					case MOVE_WalkAlert :
					case MOVE_Search :
					case MOVE_Snipe : 
						bNoBlending = true;
		
						AWait							= 'FeirStNmNt0';
						ABlendMovement.m_forward		= 'FeirStNmFd0';

						break;
				}

				break;
		}
	}
}

event float GetMoveSpeed(MoveFlags MoveFlags)
{

	if(bDrunk)
	{
		// apply speed based on move flag
		switch (MoveFlags)
		{
			case MOVE_WalkRelaxed : 				
			case MOVE_WalkNormal : 
			case MOVE_Search : 				
			case MOVE_Snipe : 				
			case MOVE_WalkAlert :
				return 85.0f;
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
	}
	else
	{
		return 	Super.GetMoveSpeed(MoveFlags);

	}
}

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_CivilGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_CivilGearRun'
    bCanWhistle=false
    Mesh=SkeletalMesh'ENPC.FeirongMesh'
}