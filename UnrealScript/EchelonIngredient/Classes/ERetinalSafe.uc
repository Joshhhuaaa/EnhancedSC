class ERetinalSafe extends EGameplayObject;

#exec OBJ LOAD FILE=..\textures\ETexIngredient.utx 
#exec OBJ LOAD FILE=..\Animations\ESkelIngredients.ukx
#exec OBJ LOAD FILE=..\Sounds\Door.uax

var()	class<EPawn>		GrantedClass;
var		EPawn				User;
var		PlayerController	oPC;

function ValidateUser(Pawn Scanned)
{
	User = EPawn(Scanned);
	GotoState(,'Validate');
}

function bool IsValid(Pawn Scanned)
{
	return EPawn(Scanned).IsA(GrantedClass.name);
}

state s_Use
{
Validate:
	// Get the player controller
	oPC = Level.Game.PlayerC;
	if (oPC == None)
		Log("ERROR: Level PlayerController shouldn't be None");

	PlaySound(Sound'Electronic.Play_RetinalScan', SLOT_SFX);

	Sleep(3);

    // Restore View if set above
    if (User.Controller.bIsPlayer || User.Controller.GetStateName() == 's_Grabbed')
		//oPC.AnimEnd(79);
		Interaction.PostInteract(oPC);
	else
		//User.Controller.AnimEnd(79);
		Interaction.PostInteract(User.Controller);

	// Inform alarm that access was denied
    if (IsValid(User))
	{
		PlayAnim('Open');
		ResetInteraction();

		PlaySound(Sound'Door.Play_SafeOpen1', SLOT_SFX);
		AddSoundRequest(Sound'Door.Play_SafeOpen2', SLOT_SFX, 1.5f);
	}
	else if (Alarm != None)
		Alarm.EnableAlarm(self, User.Controller);

	GotoState('');
}

defaultproperties
{
    bDamageable=False
    AlarmLinkType=EAlarm_Trigger
    DrawType=DT_Mesh
    Mesh=SkeletalMesh'ESkelIngredients.safeMesh'
    CollisionRadius=60.000000
    CollisionHeight=140.000000
    bBlockPlayers=True
    bBlockActors=True
    InteractionClass=Class'ERetinalSafeInteraction'
}