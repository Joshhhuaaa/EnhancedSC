//===============================================================================
//  [ECook]
//===============================================================================

class ECook extends EAINonHostile
	placeable;

#exec OBJ LOAD FILE=..\StaticMeshes\EMeshCharacter.usx

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_CivilGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_CivilGearRun'
}