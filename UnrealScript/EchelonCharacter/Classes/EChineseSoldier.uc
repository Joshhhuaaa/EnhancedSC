//===============================================================================
//  [EChineseSoldier] 
//===============================================================================

class EChineseSoldier extends EAIProfessional
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_LightGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_LightGearRun'
    GearSoundFall=Sound'GearCommon.Play_LightGearFall'
    Sounds_AttackMove=Sound'ChineseSoldier.Play_random_CSOCombatMove'
    Sounds_AttackStop=Sound'ChineseSoldier.Play_random_CSOCombatStop'
    Mesh=SkeletalMesh'ENPC.RenegadeAMesh'
}