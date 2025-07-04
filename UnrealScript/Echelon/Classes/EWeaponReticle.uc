class EWeaponReticle extends EObjectHud;

var EPlayerController	Epc;		// Player
var EWeapon				Weapon;		// Weapon owner

var bool				bDrawCrosshair;

enum CROSSHAIR_STYLE{CH_NONE, CH_NONHOSTILE};
var CROSSHAIR_STYLE chStyle;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// get weapon
	Weapon = EWeapon(Owner);
	if( Weapon == None )
		Log(self$" ERROR : EWeaponReticle Owner not a weapon");
}

// called only when Weapon goes into Inventory
function SetEpc()
{
	if( Epc == None )
		Epc = EPlayerController(Weapon.Owner);
}

function DrawView(HUD Hud,ECanvas Canvas)
{
	Super.DrawView(Hud, Canvas);

    if (Epc.bShowCrosshair && Epc.bShowHUD) // Joshua - Show crosshair toggle
	    DrawCrosshair(Canvas);
}

function DrawCrosshair(ECanvas Canvas)
{
    local int chWidth, chHeight;

    switch(chStyle)
    {
        case CH_NONE:
            Canvas.SetDrawColor(38,81,50);
            break;
        case CH_NONHOSTILE:
            Canvas.SetDrawColor(27,70,122);
            break;
    }

    chWidth = eLevel.TGAME.GetWidth(Weapon.ReticuleTex);
    chHeight = eLevel.TGAME.GetHeight(Weapon.ReticuleTex);

    Canvas.SetPos(319 - chWidth/2, 239 - chHeight/2);
    eLevel.TGAME.DrawTilefromManager(Canvas, Weapon.ReticuleTex, chWidth, chHeight, 0, 0, chWidth, chHeight);
}

state s_Selected
{
	function ObjectHudTick( float DeltaTime )
	{
        Super.ObjectHudTick(DeltaTime);

        if(Epc != None && Epc.m_targetActor != None && Epc.m_targetActor.bIsPawn && !EPawn(Epc.m_targetActor).bHostile )
			chStyle = CH_NONHOSTILE;
        else
            chStyle = CH_NONE;
	}
}

state s_Firing
{
}

state s_Reloading
{
	function BeginState()
	{
		// Make crosshair flash
        SetTimer(0.2, true);
	}

    function EndState()
    {
        SetTimer(0.0, false);
    }

    function Timer()
    {
        bDrawCrosshair = !bDrawCrosshair;
	}

    function DrawView( HUD Hud,ECanvas Canvas )
    {
		Super.DrawView(Hud, Canvas);
        Canvas.SetDrawColor(128,128,128);

	    if(bDrawCrosshair && Epc.bShowCrosshair && Epc.bShowHUD) // Joshua - Show crosshair toggle
	        DrawCrosshair(Canvas);
    }
}

