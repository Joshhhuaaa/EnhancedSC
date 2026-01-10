class ESoundTrigger extends Actor
	placeable;

#exec Texture Import File=..\Engine\Textures\S_SoundTrigger.pcx Name=S_SoundTrigger Mips=Off MASKED=1 NOCONSOLE

var		bool						bAlreadyVisited;
var()	bool						bTriggerOnlyOnce;
var()	bool						bQuietWhenCrouched;
var()	bool						NPCTrigger;
var()	bool						bMakeAINoise;

var		Pawn						PawnInstigator;
var()	Sound						SoundEvent;
var()	float						Radius;
var()	ESoundSlot					SoundType;

var()	SurfaceNoiseInfo			FootstepNoise;
var()	EPawn.SurfaceNoiseType		FootstepSurfaceType;

enum ESoundTriggerNoiseType
{
	ST_UseNoiseRadiusOnly,
	ST_UseExistingFootstepInfo,
	ST_UseNewFootstepInfo
};

var()	ESoundTriggerNoiseType		SoundTriggerNoiseType;


//timer before sending AI event
function Timer()
{
	log("Sound Trigger "$self$" sent an AI sound event");

	Instigator = PawnInstigator;


	switch (SoundTriggerNoiseType)
	{
		case ST_UseNoiseRadiusOnly :

			PawnInstigator.MakeNoise(Radius, NOISE_Object_Falling);
			return;

		case ST_UseExistingFootstepInfo :

			FootstepNoise = EPawn(PawnInstigator).GetFootstepNoiseInfo(FootstepSurfaceType);
			break;

		case ST_UseNewFootstepInfo :

			// FootstepNoise specified by designer
			break;
	}

	// for UseExistingFootstepInfo and UseNewFootstepInfo -- mirror surface noise usage in DareAudioSubsystem.cpp

	if (Instigator.bIsCrouched)
		Radius = FootstepNoise.CrouchWalkRadius + ((FootstepNoise.CrouchJogRadius - FootstepNoise.CrouchWalkRadius) * PawnInstigator.SoundWalkingRatio);
	else
		Radius = FootstepNoise.WalkRadius + ((FootstepNoise.JogRadius - FootstepNoise.WalkRadius) * PawnInstigator.SoundWalkingRatio);

	if (PawnInstigator.SoundWalkingRatio <= 0.65f)
		PawnInstigator.MakeNoise(Radius, NOISE_LightFootstep);
	else
		PawnInstigator.MakeNoise(Radius, NOISE_HeavyFootstep);

	//log("calculated radius : " $ Radius);
}



/*-----------------------------------------------------------*\
|															 |
| Touch                                                      |
|                                                            |
\*-----------------------------------------------------------*/
function Touch(actor Other)
{
	local Pawn P;
	local vector HitLocation, HitNormal;
	local float SoundDuration;

	//cast the actor in Pawn
	P = Pawn(Other);

	if (P != None)
	{
		if ((P.controller.bIsPlayer && !(bQuietWhenCrouched && P.bIsCrouched)) || (NPCTrigger && P.controller.IsA('EAIController')))
		{
			// make sure not touching through wall
			if (Trace(HitLocation, HitNormal, Other.Location, Location, true) == Other)
			{
				if (!(bAlreadyVisited && bTriggerOnlyOnce))
				{
					if (!IsPlayingAnyActor(SoundEvent))
					{
						bAlreadyVisited = true;
						PlaySound(SoundEvent, SoundType);

						//send AI sound
						if (bMakeAINoise)
						{
							PawnInstigator = P;
							SoundDuration = GetSoundDuration(SoundEvent);
							if (SoundDuration == -1)
								SetTimer(0.1f, false);
							else
								SetTimer(SoundDuration, false);
						}
					}
				}
			}
		}
	}
}

event Trigger(Actor other, Pawn EventInstigator, optional name InTag)
{
	PlaySound(SoundEvent, SoundType);
}

defaultproperties
{
    NPCTrigger=True
    bHidden=True
    Texture=Texture'S_SoundTrigger'
    CollisionRadius=40.000000
    CollisionHeight=40.000000
    bCollideActors=True
}