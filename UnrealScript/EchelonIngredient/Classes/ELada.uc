class ELada extends EGameplayObject;

/* Joshua - This actor does not appear to be used in the final game. ELada.ukx can be taken from Pandora Tomorrow's files if you want to restore it.
#exec OBJ LOAD FILE=..\Animations\ELada.ukx

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=SkeletalMesh'ELada.LADA'
}
*/




/* Joshua - This is the original script used by this class:

#exec OBJ LOAD FILE=..\textures\ETexIngredient.utx

// Joshua - The PSK file exported from UModel doesn't seem to be compatible with the SC engine.

#exec MESH  MODELIMPORT MESH=ladaMesh MODELFILE=models\lada.PSK LODSTYLE=10
#exec MESH  ORIGIN MESH=ladaMesh X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0
#exec ANIM  IMPORT ANIM=ladaAnims ANIMFILE=models\lada.PSA COMPRESS=1 MAXKEYS=999999
#exec MESHMAP   SCALE MESHMAP=ladaMesh X=1.0 Y=1.0 Z=1.0
#exec MESH  DEFAULTANIM MESH=ladaMesh ANIM=ladaAnims

#exec MESHMAP SETTEXTURE MESHMAP=ladaMesh NUM=0 TEXTURE=lada
#exec MESHMAP SETTEXTURE MESHMAP=ladaMesh NUM=1 TEXTURE=tire

#exec ANIM DIGEST  ANIM=ladaAnims USERAWINFO VERBOSE

defaultproperties
{
    DrawType=DT_Mesh
    Mesh=SkeletalMesh'ladaMesh'
}
*/