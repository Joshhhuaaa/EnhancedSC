class EBriefcase extends EGameplayObject;

var name LostJumpLabel;

function PostBeginPlay()
{
	// Do this first
	Super.PostBeginPlay();

	if (Owner.bIsPawn)
		ResetInteraction();
}

function name GetHandAttachTag()
{
	return 'Briefcase';
}

function PhysicsVolumeChange(PhysicsVolume NewVolume)
{
	local EVolume Vol;
	
	Super.PhysicsVolumeChange(NewVolume);

	Vol = EVolume(NewVolume);

	// send event to GroupAI when destroyed
	if (Vol != None && Vol.bDyingZone && GroupAI != None && LostJumpLabel != '')
		GroupAI.SendJumpEvent(LostJumpLabel, false, false);
}

defaultproperties
{
    ObjectName="Briefcase"
    bPickable=True
    bDamageable=False
    StaticMesh=StaticMesh'EMeshIngredient.Object.Briefcase'
    CollisionHeight=6.000000
    bCollideActors=False
}