class EDisposablePick extends EInventoryItem;

var ESwingingDoor	Door;

function PostBeginPlay()
{
	Super.PostBeginPlay();

    HUDTex       = EchelonLevelInfo(Level).TICON.qi_ic_lockjam;
    InventoryTex = EchelonLevelInfo(Level).TICON.inv_ic_lockjam;
    ItemName     = "DisposablePick";
	ItemVideoName = "gd_disposable_pick.bik";
    Description  = "DisposablePickDesc";
	HowToUseMe  = "DisposablePickHowToUseMe";
}

function PlaceOnDoor()
{
	local Emitter E; 
	local Vector X,Y,Z;
	GetAxes(Door.MyKnob.Rotation, X, Y, Z);
	// switch Y angle
	if( Door.GetPawnSide(Controller.Pawn) != ESide_Front )
		Y = -Y;

	E = spawn(class'EBreakLockEmitter', self,,Door.MyKnob.Location - 10 * Y);
	E.SetBase(Door);

	E.PlaySound(Sound'FisherFoley.Play_DisposalPick', SLOT_SFX);

	// Unlock door
	Door.Unlock();
	EchelonGameInfo(Level.Game).pPlayer.playerStats.AddStat("LockDestroyed");
	Destroy();
}

state s_Selected
{
	function Use()
	{
		local EInteractObject	InteractObj;
		local EPlayerController Epc;
		
		Epc = EPlayerController(Controller);
		if( !Epc.IManager.IsPresent(class'EDoorInteraction', InteractObj) )
		{
			//Log("Not touching a door interaction.");
			return;
		}

		// Set door
        Door = ESwingingDoor(InteractObj.Owner.Owner);

		if( Door == None )
		{
			log("Door interaction does not have a swinging door");
			return;
		}
		else if( !Door.Locked )
		{
			log("Door already unlocked.");
			return;
		}
		else if( Door.HasSpecialOpener() )
		{
			log("Door linked to keypad/retinal scanner.");
			return;
		}
		
		Interaction = spawn(class'EBreakLockInteraction', self);
		Interaction.InitInteract(Controller);
	}
AutoUse:
	Use();
}

defaultproperties
{
    Category=CAT_GADGETS
    MaxQuantity=10
    StaticMesh=StaticMesh'EMeshIngredient.Item.DisposablePick'
    CollisionRadius=5.000000
    CollisionHeight=1.500000
}