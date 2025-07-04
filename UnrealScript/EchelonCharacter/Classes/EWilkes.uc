//===============================================================================
//  [EWilkes] 
//===============================================================================

class EWilkes extends EAINonHostile
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_CivilGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_CivilGearRun'
    bCanWhistle=false
    bDontCheckChangedActor=true
    Mesh=SkeletalMesh'ENPC.WilkesMesh'
}