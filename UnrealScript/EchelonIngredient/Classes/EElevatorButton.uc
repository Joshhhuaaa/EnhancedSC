class EElevatorButton extends EGameplayObject;

#exec OBJ LOAD FILE=..\StaticMeshes\EMeshIngredient.usx

var	EElevatorPanel	ControllerPanel;

//------------------------------------------------------------------------
// Description		
//		Setup form Panel
//------------------------------------------------------------------------
function SetController(EElevatorPanel Panel)
{
	if (Panel == None)
		Log(self$" PROBLEM: controller not valid");

	ControllerPanel = Panel;
}

//------------------------------------------------------------------------
// Description		
//		Called from Interaction when button is pushed
//------------------------------------------------------------------------
function Trigger(Actor Other, Pawn EventInstigator, name InTag)
{
	Super.Trigger(Other, EventInstigator, InTag);

	// light up the button
	if (!ControllerPanel.bPowered && EventInstigator == EchelonGameInfo(Level.game).pPlayer.ePawn)
		EchelonGameInfo(Level.Game).pPlayer.SendTransmissionMessage(Localize("Transmission", "ElevatorPower", "Localization\\HUD"), TR_CONSOLE);

	// call elevator on this floor
	ControllerPanel.RequestElevator(self);

	if (EKeyPadInteraction(Interaction).InteractionController.bIsPlayer)
		PlaySound(Sound'Electronic.Play_keyPadButton', SLOT_Interface);
	else
		PlaySound(Sound'Electronic.Play_keyPadButton', SLOT_SFX);

}

//------------------------------------------------------------------------
// Description		
//		Called from Panel when elevator is at current button floor
//------------------------------------------------------------------------
function UnTrigger(Actor Other, Pawn EventInstigator, optional name InTag)
{
}

defaultproperties
{
    bDamageable=false
    StaticMesh=StaticMesh'EMeshIngredient.Elevator.ElevatorButton'
    DrawScale=0.500000
    InteractionClass=Class'ETriggerInteraction'
}