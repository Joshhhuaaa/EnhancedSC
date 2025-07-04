//===============================================================================
//  [EFrances] 
//===============================================================================

class EFrances extends EAIFemale
	placeable;

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_CivilGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_CivilGearRun'
    bCanWhistle=false
    bDontCheckChangedActor=true
    GearSoundFall=Sound'GearCommon.Play_CivilGearFall'
    Health=10
    Mesh=SkeletalMesh'EFemale.FranceCoen'
}