//===============================================================================
//  [EGeorgianPalaceGuard]
//===============================================================================

class EGeorgianPalaceGuard extends EAIProfessional
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_LightGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_LightGearRun'
    GearSoundFall=Sound'GearCommon.Play_LightGearFall'
    Sounds_AttackMove=Sound'GeorgianPalaceGuard.Play_random_GPGCombatMove'
    Sounds_AttackStop=Sound'GeorgianPalaceGuard.Play_random_GPGCombatStop'
    Mesh=SkeletalMesh'ENPC.PalaceGuardAMesh'
}