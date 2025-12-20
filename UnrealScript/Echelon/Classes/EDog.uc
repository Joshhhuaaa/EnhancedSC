//===============================================================================
//  [EDog] 
//
//	Nasty dawg base class.
//
//===============================================================================

class EDog extends EPawn
	native;

var(AI) Name		MasterTag;

var		float		BoneAlpha,
					BoneFadeIn,
					BoneFadeOut;
var		rotator		LastBodyRotation;

var		Sound		DogBark;
var		Sound		DogAttack;
var		Sound		PlayBreath;
var		Sound		StopBreath;
var		Sound		DogHit;

//
//
// NATIVE FUNCTIONALITY
//
//

native(1535) final function SetMotionBones(vector MotionDir, float Alpha);
native(1536) final function ResetMotionBones();



//
//
// ANIMATION SETUP SPECIFIC FOR AINonHostile --> AIPawn defines for all Hostile types
//
//

function PostBeginPlay()
{
	local EAIController AI;

	Super.PostBeginPlay();

	LastBodyRotation = Rotation;

	AI = EAIController(Controller);

	if (AI != None)
	{
		AI.Master =	EPawn(GetMatchingActor(MasterTag)); 
	}
}


function InitAnims()
{
	AWait						= 'Waitstnmfd0';
	ADeathForward				= 'XxxxStAlLt0';
	ADeathLeft					= 'XxxxStAlLt0';
	ADeathRight					= 'XxxxStAlRt0';
	ADeathDown					= 'XxxxStAlRt0';
	ADeathBack					= 'XxxxStAlRt0';

	ATurnBRight					= 'TurnStNmBr0';
	ATurnBLeft					= 'TurnStNmBl0';
	ATurnLt						= 'TurnStNmLt0';
	ATurnRt						= 'TurnStNmRt0';

	ATurnRight					= 'TurnstnmNt0';
}

function SwitchAnims()
{
	bWantsToCrouch = false;

	switch (BaseMoveFlags)
	{
		case MOVE_WalkRelaxed : 
		case MOVE_WalkNormal : 
		case MOVE_WalkAlert :

	
			AWait					 = 'waitstnmfd0';
			ABlendMovement.m_forward = 'walkstnmfd0';
			SoundWalkingRatio = 0.60;
			break;
			
		case MOVE_JogAlert :
		case MOVE_JogNoWeapon:
			
			AWait					 = 'waitstalfd0';
			ABlendMovement.m_forward = 'runstalfd0';
			SoundWalkingRatio = 1.0;
			break;
			
		case MOVE_CrouchWalk :  
		case MOVE_CrouchJog : 
			AWait					 = 'waitcrnmfd0';
			bWantsToCrouch = true;
			break;

		case MOVE_Search:

			AWait					 = 'waitstnmfd0';
			ABlendMovement.m_forward = 'walkstinfd0';
			SoundWalkingRatio = 0.60;
			break;

		case MOVE_Snipe:

			AWait					 = 'barkstalfd0';
			ABlendMovement.m_forward = 'walkstinfd0';
			SoundWalkingRatio = 0.60;
			break;
	}
}

function PlayDogBark()
{
	// Joshua - Prevents NPC barks during GameOver
	if (!EchelonLevelInfo(Level).bGameOver)
		PlaySound(DogBark, SLOT_SFX);
}

function PlayDogAttack()
{
	// Joshua - Prevents NPC barks during GameOver
	if (!EchelonLevelInfo(Level).bGameOver)
		PlaySound(DogAttack, SLOT_SFX);
}

/*************  SET ANIMATION SPEED FOR MODEL  ******************/
// to be eventually replaced with root motion speed
event float GetMoveSpeed(MoveFlags MoveFlags)
{
	local EGoal Goal;
	local float dist;

	//check if we are waiting for that goal
	Goal = EAIController(Controller).m_pGoalList.GetCurrent();

	if (Goal.m_GoalType == GOAL_Charge)
		dist = VSize(Location - Goal.GoalTarget.Location);

	// apply speed based on move flag
	switch (MoveFlags)
	{
		case MOVE_JogAlert :
		case MOVE_JogNoWeapon: 

			if (Goal.m_GoalType == GOAL_Charge && dist < 90)
				return 100.0f;
			if (Goal.m_GoalType == GOAL_Charge && dist < 105)
				return 200.0f;
			else if (Goal.m_GoalType == GOAL_Charge && dist < 120)
				return 400.0f;
			else if (Goal.m_GoalType == GOAL_Charge && dist < 150)
				return 445.0f;
			else					
				return 490.0f;
			
		default:			
			return 100.0f;
	}
}

event CheckForTransition(MoveFlags NewMoveFlags)
{

	// CHECK FOR CROUCH / UNCROUCH

	switch (BaseMoveFlags)
	{
		case MOVE_WalkRelaxed:
		case MOVE_WalkNormal:
		case MOVE_WalkAlert:
		case MOVE_Search:
		case MOVE_JogAlert:
		case MOVE_JogNoWeapon:
			
			// are we crouching?
			if (!bIsCrouched)
			{
				switch (NewMoveFlags)
				{
					case MOVE_CrouchJog:
					case MOVE_CrouchWalk:
						Transition_Standard('WaitCrNmBg0', 0.3f, true);
						break;
					default:
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
						Transition_Standard('WaitCrNmBg0', 0.3f, true, true);
						break;
					default:
						break;
				}
			}

			break;
	}
}

event GetRandomWaitAnim(out name ReturnName)
{
	local int choice;

	//
	//
	// CHOOSE STANDARD PERSONALITY ANIMATIONS 
	//
	//

	choice = rand(6);

	switch (BaseMoveFlags)
	{				
		case MOVE_WalkRelaxed:
		case MOVE_WalkNormal:
		case MOVE_WalkAlert:
		case MOVE_Search:
		case MOVE_JogAlert:
		case MOVE_JogNoWeapon:
			if (choice < 1) { ReturnName = 'PrsoStNmAA0'; return; }
			if (choice < 2) { ReturnName = 'PrsoStNmBB0'; return; }
			if (choice < 4) { ReturnName = 'LookStNmLt0'; return; }
			if (choice < 5) { ReturnName = 'LookStNmRt0'; return; }
			if (choice < 6) { ReturnName = 'LookStNmUp0'; return; }

			return;

		case MOVE_CrouchJog:
		case MOVE_CrouchWalk:

			if (choice < 1) { ReturnName = 'PrsoCrNmAA0'; return; }
			if (choice < 2) { ReturnName = 'PrsoCrNmBB0'; return; }
			if (choice < 4) { ReturnName = 'LookCrNmLt0'; return; }
			if (choice < 5) { ReturnName = 'LookCrNmRt0'; return; }
			if (choice < 6) { ReturnName = 'LookCrNmUp0'; return; }

			return;

	}
}

//
//
// Dog PlayBlend
// Want "trailer effect" -- forward part of body matches moveDir, back part of body catches up
//
//

function PlayBlend(SAnimBlend	anims,
				   Rotator		lookDir,
				   vector		moveDir,
				   float		minForwardRatio,
				   float		tweenTime,
				   optional bool noloop)
{	
	if (!IsPlaying(PlayBreath))
		PlaySound(PlayBreath, SLOT_SFX);

	// loop movement animation
	LoopAnimOnly(anims.m_forward,,tweenTime);

	// orient bones accordingly 
	SetMotionBones(moveDir, 30.0f);
}


event PlayWaitingBlend(vector Fwd, vector Focus, float YawDiff, float TweenTime)
{
	if (IsPlaying(PlayBreath))
		PlaySound(StopBreath, SLOT_SFX);

	ResetMotionBones();
	Super.PlayWaitingBlend(Fwd, Focus, YawDiff, TweenTime);
}


event bool RotateTowardsRotator(rotator Target, optional int TurnSpeed, optional float Damping)
{
	ResetMotionBones();
	return Super.RotateTowardsRotator(Target, TurnSpeed, Damping);
}

// ***********************************************************
//
// DAMAGE STUFF 
//
// ***********************************************************
function ResolveDamageType(int PillTag, vector Momentum, class<DamageType> DamageType)
{
	local int Speed;
	//Log("Global ResolveDamageType"@PillTag@Momentum@DamageType);

	if (DamageType == None)
		return;

	Speed = VSize(Velocity);
	switch (DamageType.name)
	{
		case 'EKnocked':
		case 'EElectrocuted':
		case 'EStunned':
			Knocked(PillTag, Momentum); 
			break;

		case 'ESleepingGas':
		case 'EBurned':
			if (Speed < 0.7f * GetMoveSpeed(MOVE_JogAlert) || Health <= 50)
				GotoState('s_Stunned','Gassed'); 
			break;
	}
}

function PlayHitE(int PillTag, Vector HitLocation, Vector Momentum)
{
	PlayAnimOnly('PainStNmNt0',,0.10);
}

function name GetFireBone(int i)
{
	switch (i)
	{
	case 0: return 'DOGik Neck1'; break;
	case 1: return 'DOGik L UpperArm'; break;
	case 2: return 'DOGik Spine1'; break;
	case 3: return 'DOGik L Foot'; break;
	case 4: return 'DOGik R Calf'; break;
	}
}

state s_Stunned
{
	function Timer()
	{
		TakeDamage(1000, None, Vect(0,0,0), Vect(0,0,0), Vect(0,0,0), None);
	}

	function bool IsOnFire()
	{
		return BodyFlames.Length > 0;
	}

Gassed:
Burned:
Stunned:
	//log("Dog stuff");
	bInTransition = true;
	Bark_Type = BARK_Cough;
	if (AStunned == 'prsostnmaa0')
		Goto('RefreshTimer');
	AStunned	= 'prsostnmaa0';
	Goto('Begin');
}

defaultproperties
{
    BoneFadeIn=0.100000
    BoneFadeOut=0.200000
    bNoBlending=True
    bNoPersonality=True
    BasicPatternClass=Class'EDogPattern'
    m_VisibilityConeAngle=100.000000
    m_VisibilityMaxDistance=2500.000000
    m_VisibilityAngleVertical=75.000000
    VisTable_Alert(0)=300.000000
    VisTable_Alert(1)=1100.000000
    VisTable_Alert(2)=1400.000000
    VisTable_Alert(3)=1700.000000
    VisTable_Alert(4)=2000.000000
    VisTable_Investigate(1)=1600.000000
    VisTable_Investigate(2)=1900.000000
    VisTable_Investigate(3)=2200.000000
    VisTable_Investigate(4)=2500.000000
    SmellRadius=350.000000
    TurnSpeed_Alert=16384
    bIsDog=True
    DrawType=DT_Sprite
    SoundRadiusSaturation=50.000000
    CollisionHeight=50.000000
    bIsNPCPawn=True
}