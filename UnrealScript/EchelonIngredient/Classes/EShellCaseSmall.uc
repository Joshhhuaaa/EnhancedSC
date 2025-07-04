class EShellCaseSmall extends EShellCase;

#exec OBJ LOAD FILE=..\Sounds\GunCommon.uax
#exec OBJ LOAD FILE=..\StaticMeshes\EMeshIngredient.usx

defaultproperties
{
    ShellSound=Sound'GunCommon.Play_Switch_ShellSingleImpact'
    StaticMesh=StaticMesh'EMeshIngredient.weapon.CaseSmall'
    DrawScale=0.750000
}