//===============================================================================
//  [EMercenaryTechnician]
//===============================================================================

class EMercenaryTechnician extends EAINonHostile
	placeable;

#exec OBJ LOAD FILE=..\StaticMeshes\EMeshIngredient.usx
#exec OBJ LOAD FILE=..\Sounds\MercenaryTech.uax

var()	bool			bHasBriefcase;
var()	EGroupAI		PickupGroupAi;
var()	name			PickupJumpLabel;
var()	name			LostJumpLabel;
var		EBriefcase		Briefcase;
var		EGameplayObject	ComputerScreen;


function PostBeginPlay()
{
	local MeshAnimation Anim;


	Super(EAIPawn).PostBeginPlay();


	// chest screen
	ComputerScreen = spawn(class'EGameplayObject', self);
	ComputerScreen.Tag = 'MercScreen';
	ComputerScreen.SetStaticMesh(StaticMesh'LapTopScreen');
	AttachToBone(ComputerScreen, 'Screen');
	ComputerScreen.bBlockProj = false;
	ComputerScreen.bBlockNPCVision = false;

	// briefcase
	if (bHasBriefcase)
	{
		Briefcase = spawn(class'EBriefcase', self);
		Briefcase.GroupAI = PickupGroupAi;
		Briefcase.JumpLabel = PickupJumpLabel;
		Briefcase.LostJumpLabel = LostJumpLabel;
		AttachToBone(Briefcase, Briefcase.GetHandAttachTag());
		Briefcase.bBlockProj = false;

		// load briefcase anim package
		if (Mesh != None)
		{
			Anim = MeshAnimation(DynamicLoadObject("ENPC.caseAnims", class'MeshAnimation'));
			LinkSkelAnim(Anim);
		}

	}
}


function SwitchAnims()
{
	Super(EAIPawn).SwitchAnims();

	//do extra work for the briefcase
	if (bHasBriefcase)
	{
		switch (BaseMoveFlags)
		{
			case MOVE_WalkRelaxed :
			case MOVE_WalkNormal :
			case MOVE_WalkAlert :
				ABlendMovement.m_forward = 'WalkStNmFdV';
				break;

			case MOVE_JogAlert :
			case MOVE_JogNoWeapon :
				ABlendMovement.m_forward = 'JoggStAlFdV';
				break;
		}
	}
}

function Destroyed()
{
	if (ComputerScreen != None)
		ComputerScreen.Destroy();
	Super.Destroyed();
}

state s_Unconscious
{
	function BeginState()
	{
		// Briefcase
		if (Briefcase != None)
			Briefcase.Throw(Controller, vect(0,0,0));
		Briefcase = None;

		Super.BeginState();
	}
}

state s_Dying
{
	function BeginState()
	{
		// Briefcase
		if (Briefcase != None)
			Briefcase.Throw(Controller, vect(0,0,0));
		Briefcase = None;

		Super.BeginState();
	}
}

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_BureaucrateGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_BureaucrateGearRun'
    GearSoundFall=Sound'GearCommon.Play_CivilGearFall'
    Mesh=SkeletalMesh'ENPC.MercTechAMesh'
}