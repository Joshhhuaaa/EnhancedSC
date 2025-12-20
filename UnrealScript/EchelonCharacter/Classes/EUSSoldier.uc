//===============================================================================
//  [EUSSoldier]
//===============================================================================

class EUSSoldier extends EAIProfessional
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_HeavyGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_HeavyGearRun'
    AccuracyDeviation=1.400000
    bIsHotBlooded=False
    GearSoundFall=Sound'GearCommon.Play_HeavyGearFall'
    Mesh=SkeletalMesh'ENPC.SoldierAMesh'
}