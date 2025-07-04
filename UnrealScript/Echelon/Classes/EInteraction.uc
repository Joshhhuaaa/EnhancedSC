class EInteraction extends Interaction;

var EPlayerController Epc;

function Setup( EPlayerController PlayerController )
{
	Epc = PlayerController;

	if( Epc == None )
		Log(self$" ERROR: got an invalid PlayerController");
}

