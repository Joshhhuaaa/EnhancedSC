//=============================================================================
// EAnimatedObject
//
// Base class for any object with animation that is not a Pawn.
//
// Every time it receives a trigger event, it plays the next animation in the
// TriggeredAnimations array.
//
//=============================================================================

class EAnimatedObject extends EGameplayObject;

var   int						CurrentAnimIndex;
var() name						NeutralPoseAnim;
var() bool						bLoopNeutral;
var() bool						bNoRootMotionFirstAnim;
var() bool						bShowAfterFirstTrigger;
var() array<Name>				NeutralAnims;
var() array<Name>				TriggeredAnimations;

struct AttachedActorInfo
{
	var() Actor					AttachedActor;
	var() Name					AttachBone;
	var() vector				AttachRelativeLocation;
	var() rotator				AttachRelativeRotation;
};

var() array<AttachedActorInfo>	AttachList;

var	  int			TriggerBuffer;




auto state s_Init
{
	function BeginState()
	{
		local int i;
		local EPawn AttachedPawn;
		local AttachedActorInfo AttachInfo;

		for (i = 0; i < AttachList.Length; i++)
		{
			AttachInfo = AttachList[i];

			log("Attaching " $ AttachInfo.AttachedActor $ " to : " $ AttachInfo.AttachBone);
			log("	at Relative Loc/Rot : " $ AttachInfo.AttachRelativeLocation @ AttachInfo.AttachRelativeRotation);

			AttachToBone(AttachInfo.AttachedActor, AttachInfo.AttachBone);

			AttachInfo.AttachedActor.SetRelativeLocation(AttachInfo.AttachRelativeLocation);
			AttachInfo.AttachedActor.SetRelativeRotation(AttachInfo.AttachRelativeRotation);

			AttachedPawn = ePawn(AttachInfo.AttachedActor);
			if (AttachedPawn != none)
			{
				AttachedPawn.bIsAttachedToAnimObject = true;
				AttachedPawn.SetPhysics(PHYS_None);
			}
		}

		if (bShowAfterFirstTrigger)
			bHidden = true;

		GotoState('s_Idle');
	}
}

state s_Idle
{
	function BeginState()
	{
		SetPhysics(PHYS_None);

		// this should effectively exit the root motion
		if (bLoopNeutral)
			LoopAnim(NeutralPoseAnim);
		else
			PlayAnim(NeutralPoseAnim);

	}

	event Trigger(Actor other, Pawn EventInstigator, optional name InTag)
	{
		if (bShowAfterFirstTrigger)
			bHidden = false;

		SetPhysics(PHYS_None);
		PlayAnim(TriggeredAnimations[CurrentAnimIndex]);
		
		if (!bNoRootMotionFirstAnim || CurrentAnimIndex > 0)
		{
			LockRootMotion(1, true);
			SetPhysics(PHYS_RootMotion);
		}

		if (NeutralAnims.Length > CurrentAnimIndex)
		{
			if (NeutralAnims[CurrentAnimIndex] != '')
				NeutralPoseAnim = NeutralAnims[CurrentAnimIndex];
		}

		CurrentAnimIndex++;

		GotoState('s_Animating');
	}
}


state s_Animating
{
	event AnimEnd(int Channel)
	{
		if (CurrentAnimIndex == TriggeredAnimations.Length)
		{
			GotoState('s_Finished');
		}
		else
		{
			if (TriggerBuffer > 0)
			{
				TriggerBuffer--;

				SetPhysics(PHYS_None);
				PlayAnim(TriggeredAnimations[CurrentAnimIndex]);
				
				if (!bNoRootMotionFirstAnim || CurrentAnimIndex > 0)
				{
					LockRootMotion(1, true);
					SetPhysics(PHYS_RootMotion);
				}

				if (NeutralAnims.Length > CurrentAnimIndex)
				{
					if (NeutralAnims[CurrentAnimIndex] != '')
						NeutralPoseAnim = NeutralAnims[CurrentAnimIndex];
				}

				CurrentAnimIndex++;
			}
			else
			{
				GotoState('s_Idle');
			}
		}
	}

	event Trigger(Actor other, Pawn EventInstigator, optional name InTag)
	{
		TriggerBuffer++;
	}

}


state s_Finished 
{
	function BeginState()
	{
		SetPhysics(PHYS_None);

		// this should effectively exit the root motion
		if (bLoopNeutral)
			LoopAnim(NeutralPoseAnim);
		else
			PlayAnim(NeutralPoseAnim);

		//SetPhysics(PHYS_Walking);
	}

}

defaultproperties
{
    StaticMesh=None
}