//=============================================================================
// StaticMeshActor.
// An actor that is drawn using a static mesh(a mesh that never changes, and
// can be cached in video memory, resulting in a speed boost).
//=============================================================================

class StaticMeshActor extends Actor
	native
	placeable;

var Matrix globalMatrix;
var byte globalValid; // cant be bool because of deconstage...

//Sound trigger features added to static mesh
var	   bool				 bAlreadyVisited;

var(SoundTrigger)  bool		bTriggerOnlyOnce;
var(SoundTrigger)  bool		bQuietWhenCrouched;
var(SoundTrigger)  bool		bMakeAINoise;
var(SoundTrigger)  bool     NPCTrigger;
var(SoundTrigger)  ESoundSlot SoundType;
var(SoundTrigger)  Sound	SoundEvent;
var(SoundTrigger)  float	Radius;

var Sound	BulletHitMetal;
var Sound	BulletHitVine;

function Touch(actor Other)
{
	local Pawn P;
	local vector HitLocation, HitNormal;
	local actor TracedActor;

	//cast the actor in Pawn
	P = Pawn(Other);

	if (SoundEvent == None)
		return;

	if (P != None)
	{
		if ((P.controller.bIsPlayer && !(bQuietWhenCrouched && P.bIsCrouched)) || (NPCTrigger && P.controller.IsA('EAIController')))
		{
			TracedActor = Trace(HitLocation, HitNormal, Other.Location, Location, true);

			// make sure not touching through wall
			if (!TracedActor.bWorldGeometry)
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
							Instigator = P;
							MakeNoise(Radius, NOISE_Object_Falling);
						}
					}
				}
			}
		}
	}
}

event BulletWentTru(Actor Instigator, vector HitLocation, vector HitNormal, vector Momentum, Material HitMaterial)
{
	if (bClimbable)
	{
		if (SurfaceType == SURFACE_FenceMetal)
			PlaySound(BulletHitMetal, SLOT_SFX);
		else if (SurfaceType == SURFACE_FenceVine)
			PlaySound(BulletHitVine, SLOT_SFX);
	}
	else
		Super.BulletWentTru(Instigator, HitLocation, HitNormal, Momentum, HitMaterial);
}

defaultproperties
{
    NPCTrigger=true
    bStatic=true
    bAcceptsProjectors=true
    DrawType=DT_StaticMesh
    bShadowCast=true
    CollisionRadius=1.000000
    CollisionHeight=1.000000
    bCollideActors=true
    bBlockProj=true
    bBlockBullet=true
    bBlockNPCShot=true
    bBlockNPCVision=true
    bCPBlockPlayers=true
    bCPBlockActors=true
    bCPBlockCamera=true
    bIsTouchable=false
    bEdShouldSnap=true
}