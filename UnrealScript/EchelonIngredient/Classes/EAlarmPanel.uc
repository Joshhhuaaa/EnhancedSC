class EAlarmPanel extends EAlarmPanelObject;

#exec OBJ LOAD FILE=..\textures\ETexIngredient.utx
#exec OBJ LOAD FILE=..\StaticMeshes\EMeshIngredient.usx

var		EGameplayObject	Handle, Glass;
var		bool			bGlassBroken;

function PostBeginPlay()
{
	Handle				= spawn(class'EGameplayObject', self);
	if (Handle == None)
		log("Problem with EAlarmPanel"@self@"spawning handle");
	Handle.SetStaticMesh(StaticMesh'EMeshIngredient.Object.AlarmHandle');

	Glass				= spawn(class'EGameplayObject', self);
	if (Glass == None)
		log("Problem with EAlarmPanel"@self@"spawning glass");
	Glass.SetStaticMesh(StaticMesh'EMeshIngredient.Object.AlarmGlass');

	Super.PostBeginPlay();
}

state s_Activate
{
Begin:
	if (!bGlassBroken)
	{
		Glass.Destroy();
	}
	bGlassBroken = true;

	if (Alarm != None)
		Alarm.EnableAlarm(self, EAlarmInteraction(Interaction).InteractionController);
}

state s_Deactivate
{
	function BeginState()
	{
		if (Alarm != None)
			Alarm.DisableAlarm(self);
	}
}

defaultproperties
{
    bDamageable=False
    AlarmLinkType=EAlarm_Trigger
    StaticMesh=StaticMesh'EMeshIngredient.Object.AlarmBox'
    InteractionClass=Class'EAlarmInteraction'
}