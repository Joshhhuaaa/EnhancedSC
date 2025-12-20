//=============================================================================
//
// class EAIFemale
//
// intended specifically for Female.UKX Animation Setup
//
//=============================================================================

class EAIFemale extends EAIPawn
	notplaceable;


//
//
//	Perform all #exec setup on all Female meshes and animations.
//	Save UKX when finished.
//
//

#exec OBJ LOAD FILE=..\Animations\EFemale.ukx PACKAGE=EFemale

// females use a different LBP
#exec MESH LIPSYNCHBONES MESH=BurFemAMesh FILE=..\lipsynch\female.lbp
#exec MESH LIPSYNCHBONES MESH=AnnaMesh FILE=..\lipsynch\female.lbp
#exec MESH LIPSYNCHBONES MESH=FranceCoen FILE=..\lipsynch\female.lbp


//
//
//  Attachments
//	
//


// no weapons allowed for females .. only ref. female.psa
#exec MESH CLEARATTACHTAGS	MESH=BurFemAMesh			
#exec MESH CLEARATTACHTAGS	MESH=AnnaMesh
#exec MESH CLEARATTACHTAGS	MESH=FranceCoen


//
//
// Pills -- Clear before processing
//
//

#exec MESH CLEARPILLINFO	MESH=BurFemAMesh			
#exec MESH CLEARPILLINFO	MESH=AnnaMesh
#exec MESH CLEARPILLINFO	MESH=FranceCoen

// Head
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B Head"			X=4.172 Y=-2.376 Z=0.0
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B Head"			X=11.519 Y=-0.428 Z=0.0

// L Body

#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B Spine2"			X=15.820 Y=-2.171 Z=6.210
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B Pelvis"			X=2.591 Y=-2.420 Z=4.759

// L UpperArm and L ForeArm
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B L UpperArm"		X=0.503 Y=1.035 Z=0.881
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B L Forearm"		X=0.345 Y=1.431 Z=-1.673
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B L Forearm"		X=17.537 Y=1.051 Z=-1.409

// L Hand
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B L Hand"			X=4.393 Y=-0.614 Z=-1.436

// L Thigh
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B L Thigh"		X=3.650 Y=-1.730 Z=0.0802
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B L Calf"			X=-0.205 Y=-2.376 Z=-1.444

// L Calf
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B L Calf"			X=5.693 Y=-0.653 Z=-1.457
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B L Foot"			X=-4.250 Y=-1.127 Z=-0.0661

// L Foot
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B L Foot"			X=5.318 Y=0.159 Z=-0.153
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B L Toe0"			X=5.208 Y=-3.884 Z=-0.137

// R Body
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B Spine2"			X=15.820 Y=-2.171 Z=-6.210
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B Pelvis"			X=2.591 Y=-2.420 Z=-4.759

// R UpperArm and R ForeArm
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B R UpperArm"		X=0.503 Y=1.035 Z=-0.881
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B R Forearm"		X=0.345 Y=1.431 Z=1.673
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B R Forearm"		X=17.537 Y=1.051 Z=1.409

// R Hand
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B R Hand"			X=4.393 Y=-0.614 Z=1.436

// R Thigh
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B R Thigh"		X=3.650 Y=-1.730 Z=-0.0802
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B R Calf"			X=-0.205 Y=-2.376 Z=1.444

// R Calf
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B R Calf"			X=5.693 Y=-0.653 Z=1.457
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B R Foot"			X=-4.250 Y=-1.127 Z=0.0661

// R Foot
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B R Foot"			X=5.318 Y=0.159 Z=0.153
#exec MESH ADDPILLVERTEX	MESH=FranceCoen		BONE="B R Toe0"			X=5.208 Y=-3.884 Z=0.137


//  Head
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=0 VERTEX2=1 RADIUS=6.0 TAG=1 PRIORITY=3

// L Body
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=2 VERTEX2=3 RADIUS=9.5 TAG=2 PRIORITY=3

// L UpperArm
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=4 VERTEX2=5 RADIUS=5.0 TAG=3 PRIORITY=2

// L ForeArm
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=5 VERTEX2=6 RADIUS=4.5 TAG=4 PRIORITY=1

// L Hand
#exec MESH ADDSPHEREPILL	MESH=FranceCoen		VERTEX=7 RADIUS=6.0 TAG=5 PRIORITY=1

// L Thigh
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=8 VERTEX2=9 RADIUS=7.5 TAG=6 PRIORITY=2

// L Calf
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=10 VERTEX2=11 RADIUS=5.5 TAG=7 PRIORITY=1

// L Foot
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=12 VERTEX2=13 RADIUS=4.5 TAG=8 PRIORITY=1

// R Body
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=14 VERTEX2=15 RADIUS=9.5 TAG=9 PRIORITY=3

// R UpperArm
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=16 VERTEX2=17 RADIUS=5.0 TAG=10 PRIORITY=2

// R ForeArm
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=17 VERTEX2=18 RADIUS=4.5 TAG=11 PRIORITY=1

// R Hand
#exec MESH ADDSPHEREPILL	MESH=FranceCoen		VERTEX=19 RADIUS=6.0 TAG=12 PRIORITY=1

// R Thigh
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=20 VERTEX2=21 RADIUS=7.5 TAG=13 PRIORITY=2

// R Calf
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=22 VERTEX2=23 RADIUS=5.5 TAG=14 PRIORITY=1

// R Foot
#exec MESH ADDCYLINDERPILL	MESH=FranceCoen		VERTEX1=24 VERTEX2=25 RADIUS=4.5 TAG=15 PRIORITY=1


//
//
// Animation Flags
//
//

#exec ANIM CLEARFLAGS		ANIM=FemaleAnims


#exec SAVEPACKAGE FILE=..\Animations\EFemale.ukx PACKAGE=EFemale

//---------------------------------------[David Kalina - 16 Apr 2002]-----
// 
// Description
//		Must load FemaleAnims for EAIFemale class types.
//
//------------------------------------------------------------------------

function PostBeginPlay()
{
	local MeshAnimation Anim;

	RandomizedAnimRate = 0.97f + RandRange(0.0f, 0.06f);
		
	SetIKFade(1.666f,1.666f);		// set ik fade for AimAt
	
	Super(EPawn).PostBeginPlay();
	
	// load female anim package

	if (Mesh != None)
	{
		Anim = MeshAnimation(DynamicLoadObject("EFemale.FemaleAnims", class'MeshAnimation'));
		LinkSkelAnim(Anim);
	}
}

function InitAnims()
{
	Super(EPawn).InitAnims();

	AWait					= 'WaitStFmFd0';

	ADeathForward			= 'XxxxStFmFd0';
	ADeathBack				= 'XxxxStFmBk0';
	ADeathLeft				= 'XxxxStFmLt0';
	ADeathRight				= 'XxxxStFmRt0';
	ADeathDown				= 'XxxxStFmDn0';
}

// redefine w/ nothing temporarily
function SwitchAnims()
{
	switch (BaseMoveFlags)
	{
		case MOVE_WalkRelaxed : 
		case MOVE_WalkNormal : 
		case MOVE_WalkAlert :

			AWait					 = 'WaitStFmFd0';
			ABlendMovement.m_forward = 'WalkStFmFd0';
			SoundWalkingRatio = 0.60;
			break;

		case MOVE_JogAlert :
		case MOVE_JogNoWeapon:

		// should be replaced?
		case MOVE_CrouchWalk :  
		case MOVE_CrouchJog : 
		case MOVE_Search:
		case MOVE_Snipe:
			
			AWait					 = 'WaitStFaFd0';
			ABlendMovement.m_forward = 'JoggStFaFd0';
			SoundWalkingRatio = 1.0;
			break;
	}
}

//function GetMoveSpeed() {}

function GetReactionAnim(out name Anim, out name AnimB, out float BlendAlpha, optional eReactionAnimGroup ReactionGroup) 
{
	Anim = 'ReacStFmAA0';
}

event CheckForTransition(MoveFlags NewMoveFlags) {}


event GetRandomWaitAnim(out name ReturnName) 
{
	local int choice;

	//
	//
	// CHOOSE STANDARD PERSONALITY ANIMATIONS 
	//
	//

	choice = rand(5);

	switch (WeaponStance)
	{				
		case 0 : 			
			switch (choice)
			{
				case 0 : ReturnName = 'PrsoStFmAA0'; break;
				case 1 : ReturnName = 'PrsoStFmBB0'; break;
				case 2 : ReturnName = 'PrsoStFmCC0'; break;
				case 3 : ReturnName = 'PrsoStFmDD0'; break;
				case 4 : ReturnName = 'PrsoStFmEE0'; break;
			}

			return;
	}
}


function bool IsExtraWaiting(optional int f) { return false; }

defaultproperties
{
    bNoBlending=True
    bNoAiming=True
    BasicPatternClass=Class'Echelon.EBureaucratPattern'
    AnimSequence="waitstnmfd0"
}