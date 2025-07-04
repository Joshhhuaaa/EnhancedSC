//===============================================================================
//  [ECIABureaucrat] 
//===============================================================================

class ECIABureaucrat extends EAINonHostile
	placeable;

#exec OBJ LOAD FILE=..\StaticMeshes\2-1_cia_obj.usx

var() bool bCupDude;
var EGameplayObject Cup;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( bCupDude )
	{
		Cup = spawn(class'EGameplayObject', self);
		Cup.SetStaticMesh(StaticMesh'FoamCup01_CIA');
		Cup.SetCollision(false);
		AttachToBone(Cup, 'CupBone');
	}
}

defaultproperties
{
    GearSoundWalk=Sound'GearCommon.Play_Random_BureaucrateGearWalk'
    GearSoundRun=Sound'GearCommon.Play_Random_BureaucrateGearRun'
    GearSoundFall=Sound'GearCommon.Play_CivilGearFall'
    Mesh=SkeletalMesh'ENPC.BureaucratAMesh'
}