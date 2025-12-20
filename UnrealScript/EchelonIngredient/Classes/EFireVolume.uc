class EFireVolume extends EVolume;

var() bool	bNoCatchOnFire;

struct PawnInfo
{
	var EPawn	ePawn;
	var bool	bInFire;
};

var	array<PawnInfo> PawnsInFire;

// Return index if pawn is in list, else returns -1
function int FindPawn(EPawn Pawn)
{
	local int i;
	for (i = 0; i < PawnsInFire.Length; i++)
	{
		if (PawnsInFire[i].ePawn == Pawn)
			return i;
	}
	return -1;
}

// Inserts a new Pawn in list
function InsertPawn(EPawn Pawn)
{
	if (Pawn == None)
		return;

	PawnsInFire.Length = PawnsInFire.Length + 1;
	PawnsInFire[PawnsInFire.Length - 1].ePawn = Pawn;
}

function RemovePawn(EPawn Pawn)
{
	local int index;
	index = FindPawn(Pawn);
	if (index == -1)
		Log("ERROR: Pawn should be in list");

	if (PawnsInFire[index].bInFire)
	{
		//log(Pawn$" stops in Fire");
		if (bNoCatchOnFire)
			Pawn.AddAmbientDamage(-DamagePerSec);
		else
			Pawn.AddAmbientDamage(,-DamagePerSec);

	}
	PawnsInFire.Remove(index, 1);
}

function CheckForCatchOnFire(EPawn Pawn)
{
	local int i;
	if (Pawn == None)
		return;
	if (Pawn.Controller == None || Pawn.Controller.GetStateName() == 's_Roll')
		return;

	i = FindPawn(Pawn);
	if (i == -1)
		Log("ERROR: Pawn should be in list");

	if (!PawnsInFire[i].bInFire)
	{
		//log(Pawn$" is in Fire");
		PawnsInFire[i].bInFire		  = true;
		if (bNoCatchOnFire)
			Pawn.AddAmbientDamage(DamagePerSec);
		else
			Pawn.AddAmbientDamage(,DamagePerSec);
	}
}

function Touch(actor Other)
{
	Super.Touch(Other);
	
	if (!Other.bIsPawn) 
		return;

	// Insert pawn. (impossible that he's already in)
	InsertPawn(EPawn(Other));
	CheckForCatchOnFire(EPawn(Other));
}

function UnTouch(actor Other)
{
	Super.UnTouch(Other);
	
	if (!Other.bIsPawn) 
		return;

	RemovePawn(EPawn(Other));
}

function Tick(float DeltaTime)
{
	local int i;
	for (i = 0; i < PawnsInFire.Length; i++)
		CheckForCatchOnFire(PawnsInFire[i].ePawn);
}

defaultproperties
{
    DamagePerSec=100.000000
    bBlockActors=True
}