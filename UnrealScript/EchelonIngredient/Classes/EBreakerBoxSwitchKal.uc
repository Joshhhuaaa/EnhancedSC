class EBreakerBoxSwitchKal extends ESwitchObject;

#exec OBJ LOAD FILE=..\StaticMeshes\EMeshIngredient.usx

var bool bDoRotation;		// just to prevent doing rotation

auto state s_On
{
	function BeginState()
	{
		local Rotator r;

		if (bDoRotation)
		{
			r = Rotation;
			r.Pitch -= 16384;
			SetRotation(r);
		}
		bDoRotation = true;

		Super.BeginState();
	}
}

state s_Off
{
	function BeginState()
	{
		local Rotator r;

		if (bDoRotation)
		{
			r = Rotation;
			r.Pitch += 16384;
			SetRotation(r);
		}
		bDoRotation = true;

		Super.BeginState();
	}
}

defaultproperties
{
    StaticMesh=StaticMesh'EMeshIngredient.Obj_Kalinatek.switchbreakerbox_kal'
}