//===============================================================================
//  [EEliteForce]
//===============================================================================

class EEliteForce extends EAIProfessional
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_HeavyGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_HeavyGearRun'
    AccuracyDeviation=0.800000
    bCanWhistle=False
    GearSoundFall=Sound'GearCommon.Play_HeavyGearFall'
    Sounds_AttackMove=Sound'EliteForce.Play_random_EFOCombatMove'
    Sounds_AttackStop=Sound'EliteForce.Play_random_EFOCombatStop'
    HatMesh=StaticMesh'EMeshCharacter.Elite.EliteHelmet'
    Mesh=SkeletalMesh'ENPC.EliteAMesh'
}