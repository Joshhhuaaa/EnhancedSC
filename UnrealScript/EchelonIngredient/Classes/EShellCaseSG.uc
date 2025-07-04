class EShellCaseSG extends EShellCase;

#exec OBJ LOAD FILE=..\Sounds\GunCommon.uax
#exec OBJ LOAD FILE=..\StaticMeshes\EMeshIngredient.usx

defaultproperties
{
    ShellSound=Sound'GunCommon.Play_Switch_ShellPlasticImpact'
    StaticMesh=StaticMesh'EMeshIngredient.weapon.CaseSG'
}