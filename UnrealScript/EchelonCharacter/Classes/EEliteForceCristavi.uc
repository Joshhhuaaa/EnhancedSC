//===============================================================================
//  [EEliteForceCristavi] 
//===============================================================================

class EEliteForceCristavi extends EAIProfessional
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_HeavyGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_HeavyGearRun'
    AccuracyDeviation=0.800000
    bCanWhistle=False
    GearSoundFall=Sound'GearCommon.Play_HeavyGearFall'
    HatMesh=StaticMesh'EMeshCharacter.Elite.EliteHelmet'
    Mesh=SkeletalMesh'ENPC.EliteAMesh'
}