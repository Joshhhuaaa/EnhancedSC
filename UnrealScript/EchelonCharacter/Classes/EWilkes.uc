//===============================================================================
//  [EWilkes]
//===============================================================================

class EWilkes extends EAINonHostile
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_CivilGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_CivilGearRun'
    bCanWhistle=False
    bDontCheckChangedActor=True
    Mesh=SkeletalMesh'ENPC.WilkesMesh'
}