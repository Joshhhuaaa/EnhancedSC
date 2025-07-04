//===============================================================================
//  [EGeorgianSoldier]
//===============================================================================

class EGeorgianSoldier extends EAIProfessional
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_LightGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_LightGearRun'
    AccuracyDeviation=1.250000
    GearSoundFall=Sound'GearCommon.Play_LightGearFall'
    Sounds_AttackMove=Sound'GeorgianSoldier.Play_random_GSOCombatMove'
    Sounds_AttackStop=Sound'GeorgianSoldier.Play_random_GSOCombatStop'
    Mesh=SkeletalMesh'ENPC.GESoldierAMesh'
}