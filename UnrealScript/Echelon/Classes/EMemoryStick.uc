class EMemoryStick extends EGameplayObject;

struct MSGoal
{
	var() name		GoalID;
	var() String	GoalStringID;
};

struct Attachment
{
    var() Texture Icon;
    var() string  NameStringID;
    var() int     Size;
};

var()   string                  MemoryTextSection;  // Section in the localization file
var()   string                  From;				// Header
var()   string                  To;
var()   string                  SentStringID;
var()   string                  SubjectStringID;
var()   string                  MemoryTextID;       // StringID in the localization file 
var()   Array<string>		    NotesStringID;		// Notes to be added to Inventory
var()   Array<MSGoal>		    Goals;				// Goals to be added to Inventory
var()   Array<Attachment>	    Pictures;			// Contained pictures available in Memory stick

var()   array<Actor>		    AccessActors;		// Unique object name that will retrieve information (from unique actor)
var()   bool				    DestroyUponRead;	// True if you want this information card to be displayed/found only once.

var	    EchelonLevelInfo	    Bank;			// Pointer on bank information

function PostBeginPlay()
{
	// If memorystick is to be found on something, hide it and remove interaction
	if (AccessActors.Length > 0)
	{
		bHidden			= true;
		bPickable		= false;
		InteractionClass= None; // do this before Super.PostBeginPlay()
	}

	Super.PostBeginPlay();
}

function bool NotifyPickup(Controller Instigator)
{	
	EPlayerController(Instigator).AddReconText(string(ObjectName), MemoryTextSection, From, To, SentStringID, SubjectStringID, MemoryTextID, false);
	UploadDataToPDA();

	return true;
}

function UploadDataToPDA()
{
    local int               i;
	local EPlayerController Epc;

	Epc = EchelonGameInfo(Level.Game).pPlayer;

    if (Epc == None)
        return;

	PlaySound(Sound'Interface.Play_DataTransfer', SLOT_Interface);

	// Add Goals
	if (Goals.Length > 0)
	{
		for (i = 0; i < Goals.Length; i++)
			Epc.AddGoal(Goals[i].GoalID, "", MemoryTextSection, Goals[i].GoalStringID, "Localization\\MemoryStick",, "", MemoryTextSection, Goals[i].GoalStringID, "Localization\\MemoryStick");

        if (Goals.Length > 1)
		    Epc.SendTransmissionMessage(Goals.Length $ " " $ Localize("HUD", "Goals", "Localization\\HUD") $ " " $ Localize("HUD", "Added", "Localization\\HUD"), TR_INVENTORY);
        else
            Epc.SendTransmissionMessage(Goals.Length $ " " $ Localize("HUD", "Goal", "Localization\\HUD")  $ " " $ Localize("HUD", "Added", "Localization\\HUD"), TR_INVENTORY);
	}

	// Add Notes
	if (NotesStringID.Length > 0)
	{
		for (i = 0; i < NotesStringID.Length; i++)
			Epc.AddNote("", MemoryTextSection, NotesStringID[i], "Localization\\MemoryStick", false);

        if (NotesStringID.Length > 1)
		    Epc.SendTransmissionMessage(NotesStringID.Length $ " " $ Localize("HUD", "Notes", "Localization\\HUD") $ " " $ Localize("HUD", "Added", "Localization\\HUD"), TR_INVENTORY);
        else
            Epc.SendTransmissionMessage(NotesStringID.Length $ " " $ Localize("HUD", "Note", "Localization\\HUD")  $ " " $ Localize("HUD", "Added", "Localization\\HUD"), TR_INVENTORY);
	}

	// Send event once read
	TriggerPattern();

    // Destroy after Read //
	if (DestroyUponRead)
	{
		Bank.RemoveMemoryStick(self);
		Destroy();
	}
}

defaultproperties
{
    DestroyUponRead=true
    ObjectName="DataStick"
    bDamageable=false
    StaticMesh=StaticMesh'EMeshIngredient.Item.MemoryStick'
    CollisionRadius=2.000000
    CollisionHeight=2.000000
}