class EButterfly extends EGameplayObject;

#exec OBJ LOAD FILE=..\Animations\ESkelIngredients.ukx

var() bool	bFly360;

auto state s_Butterlfying
{
	function BeginState()
	{
		AnimEnd(0);
	}

	function AnimEnd(int Channel)
	{
		if (bFly360)
			PlayAnim('360', 0.5f + FRand());
		else
			PlayAnim('180', 0.5f + FRand());
	}
}

defaultproperties
{
    bFly360=true
    Physics=PHYS_RootMotion
    DrawType=DT_Mesh
    Mesh=SkeletalMesh'ESkelIngredients.mothMesh'
    bCollideActors=false
    HeatIntensity=0.200000
    bIsSoftBody=true
}