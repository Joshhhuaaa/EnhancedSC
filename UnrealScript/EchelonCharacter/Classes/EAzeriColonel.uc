//===============================================================================
//  [EAzeriColonel] 
//===============================================================================

class EAzeriColonel extends EAIProfessional
	placeable;

#exec OBJ LOAD FILE=..\textures\ETexCharacter.utx
#exec OBJ LOAD FILE=..\StaticMeshes\generic_obj.usx
#exec OBJ LOAD FILE=..\StaticMeshes\EMeshCharacter.usx
#exec OBJ LOAD FILE=..\Animations\ENPC.ukx PACKAGE=ENPC

// currently using FakeSoldierAMesh, no #execs needed

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_LightGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_LightGearRun'
    AccuracyDeviation=1.250000
    GearSoundFall=Sound'GearCommon.Play_LightGearFall'
    HatMesh=StaticMesh'EMeshCharacter.FalseSoldier.Ushanka'
    bCanUseRetinalScanner=True
}