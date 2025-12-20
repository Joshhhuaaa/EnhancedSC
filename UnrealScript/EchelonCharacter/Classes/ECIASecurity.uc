//===============================================================================
//  [ECIASecurity] 
//===============================================================================

class ECIASecurity extends EAIProfessional
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_MafiosoGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_MafiosoGearRun'
    AccuracyDeviation=1.400000
    bIsHotBlooded=False
    GearSoundFall=Sound'GearCommon.Play_MediumGearFall'
    Sounds_AttackMove=Sound'CiaSecurity.Play_random_AGSCombatMove'
    Sounds_AttackStop=Sound'CiaSecurity.Play_random_AGSCombatStop'
    Mesh=SkeletalMesh'ENPC.SecurityAMesh'
}