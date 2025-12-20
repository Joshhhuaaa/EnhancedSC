class EExitInteraction extends EInteractObject;

function string	GetDescription()
{
	return Localize("Interaction", "Exit", "Localization\\HUD");
}

// Just to be sure nothing gets called.
function Touch(actor Other);
function UnTouch(actor Other);
function Tick(float DeltaTime);
function bool IsAvailable()
{
	return true;
}

defaultproperties
{
    iPriority=-1
    bCollideActors=False
}