//===============================================================================
//  [EFalseRussianSoldier] 
//===============================================================================

class EFalseRussianSoldier extends EAIProfessional
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_HeavyGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_HeavyGearRun'
    GearSoundFall=Sound'GearCommon.Play_HeavyGearFall'
    HatMesh=StaticMesh'EMeshCharacter.FalseSoldier.Ushanka'
    Mesh=SkeletalMesh'ENPC.FakeSoldierAMesh'
}