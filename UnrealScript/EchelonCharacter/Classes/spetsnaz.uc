//===============================================================================
//  [spetsnaz] 
//===============================================================================

class spetsnaz extends EAIProfessional
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_HeavyGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_HeavyGearRun'
    GearSoundFall=Sound'GearCommon.Play_HeavyGearFall'
    Sounds_AttackMove=Sound'Exspetsnaz.Play_random_EXSCombatMove'
    Sounds_AttackStop=Sound'Exspetsnaz.Play_random_EXSCombatStop'
    Mesh=SkeletalMesh'ENPC.SpetsnazAMesh'
}