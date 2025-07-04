//===============================================================================
//  [EGeorgianCitizen] 
//===============================================================================

class EGeorgianCitizen extends EAINonHostile
	placeable;

#exec OBJ LOAD FILE=..\Sounds\GeorgianCitizen.uax

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_CivilGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_CivilGearRun'
    GearSoundFall=Sound'GearCommon.Play_CivilGearFall'
    Mesh=SkeletalMesh'ENPC.ERussianCivilianAMesh'
}