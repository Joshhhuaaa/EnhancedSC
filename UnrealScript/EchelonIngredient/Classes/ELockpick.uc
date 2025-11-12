class ELockpick extends EInventoryItem;

#exec OBJ LOAD FILE=..\Sounds\FisherFoley.uax

var EPickLockSystem		PLS;

var Sound StartLockPick;
var Sound ReleasePine;
var Sound FindPine;
var Sound TryLockPick;
var Sound OpenLock;

function PostBeginPlay()
{
	Super.PostBeginPlay();

    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_lockpick;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_lockpick;
    ItemName     = "LockPick";
	ItemVideoName = "gd_lockpick.bik";
    Description  = "LockPickDesc";
	HowToUseMe  = "LockPickHowToUseMe";
}

state s_Selected
{
	function Use()
	{
		local EInteractObject	InteractObj;
		local ESwingingDoor		Door;
		local EPlayerController Epc;
		
		Epc = EPlayerController(Controller);
		if (!Epc.IManager.IsPresent(class'EDoorInteraction', InteractObj))
		{
			Log("Not touching a door interaction.");
			return;
		}

		// Set door
        Door = ESwingingDoor(InteractObj.Owner.Owner);

		if (Door == None)
		{
			log("Door interaction does not have a swinging door");
			return;
		}
		else if (!Door.Locked)
		{
			log("Door already unlocked.");
			return;
		}
		else if (Door.HasSpecialOpener())
		{
			log("Door linked to keypad/retinal scanner.");
			return;
		}
		
		// Spawn my interaction
		Interaction = spawn(class'EPickLockInteraction');
		EPickLockInteraction(Interaction).Set(Door, self);
		// Set Controller interaction (do this before starting interaction for if the move doesn't succede, it won't start the interaction)
		Controller.Interaction = Interaction;
		// Send controller into pick lock state
		Controller.GotoState('s_PickLock');
	}
AutoUse:
	Use();
}

defaultproperties
{
    StartLockPick=Sound'FisherFoley.Play_FisherStartlockPick'
    ReleasePine=Sound'FisherFoley.Play_FisherReleasePine'
    FindPine=Sound'FisherFoley.Play_FisherFindPine'
    TryLockPick=Sound'FisherFoley.Play_Random_FisherTryLockPick'
    OpenLock=Sound'FisherFoley.Play_FisherOPenLock'
    Category=CAT_GADGETS
    StaticMesh=none
}