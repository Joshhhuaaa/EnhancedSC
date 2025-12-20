//=============================================================================
// HUD: Superclass of the heads-up display.
//=============================================================================
class HUD extends Actor
	native
	config(user);

//=============================================================================
// Variables.

#exec Texture Import File=Textures\Border.pcx NOCONSOLE

#exec new TrueTypeFontFactory PACKAGE="Engine" Name=MediumFont FontName="Arial Bold" Height=16 AntiAlias=1 CharactersPerPage=128
//#exec new TrueTypeFontFactory PACKAGE="Engine" Name=SmallFont FontName="Arial" Height=10 AntiAlias=0 CharactersPerPage=256
#exec new TrueTypeFontFactory PACKAGE="Engine" Name=SmallFont FontName="Terminal" Height=10 AntiAlias=0 CharactersPerPage=256
//#exec Font Import File=Textures\SmallFont.bmp Name=SmallFont

// Stock fonts.
var font SmallFont;          // Small system font.
var font MedFont;            // Medium system font.
var font BigFont;            // Big system font.
var font LargeFont;            // Largest system font.

var string HUDConfigWindowType;
var HUD nextHUD;	// list of huds which render to the canvas
var PlayerController PlayerOwner; // always the actual owner

var bool	bShowDebugInfo;		// if true, show properties of current ViewTarget

var bool bHideHUD;		// Should the hud display itself.

/* Draw3DLine()
draw line in world space. Should be used when engine calls RenderWorldOverlays() event.
*/
native final function Draw3DLine(vector Start, vector End, color LineColor);

function PostBeginPlay()
{
	Super.PostBeginPlay();
	PlayerOwner = PlayerController(Owner);
}

event Destroyed()
{
	Super.Destroyed();
}

// ***********************************************************************************************
// * BEGIN UBI MODIF 
// * ATurcotte (MTL) (28 Jan 2002)
// * Purpose : 
// ***********************************************************************************************
function bool KeyEvent(string Key, EInputAction Action, FLOAT Delta);
function  RealKeyEvent(string RealKeyValue, EInputAction Action, FLOAT Delta);
// ***********************************************************************************************
// * END UBI MODIF 
// * ATurcotte (MTL) (28 Jan 2002)
// ***********************************************************************************************


//=============================================================================
// Execs

/* toggles displaying properties of player's current viewtarget
*/
exec function ShowDebug()
{
	bShowDebugInfo = !bShowDebugInfo;
}

//=============================================================================
// Status drawing.

event WorldSpaceOverlays()
{
	if (bShowDebugInfo && Pawn(PlayerOwner.ViewTarget) != None)
		DrawRoute();
}

event PostRender(Canvas Canvas)
{
	local HUD H;
	local float YL,YPos;

	if (bShowDebugInfo)
	{
		YPos = 5;
		UseSmallFont(Canvas);
		PlayerOwner.ViewTarget.DisplayDebug(Canvas, YL, YPos);
	}
	else for (H = self; H != None; H = H.NextHUD)
		H.DrawHUD(Canvas);
}

function DrawRoute()
{
	local int i;
	local Controller C;
	local vector Start, End;
	local bool bPath;

	C = Pawn(PlayerOwner.ViewTarget).Controller;
	if (C == None)
		return;
	Start = PlayerOwner.ViewTarget.Location;

	// show where pawn is going
	if ((C == PlayerOwner)
		|| (C.MoveTarget == C.RouteCache[0]) && (C.MoveTarget != None))
	{
		if ((C == PlayerOwner) && (C.Destination != vect(0,0,0)))
		{
			if (C.PointReachable(C.Destination))
			{
				Draw3DLine(C.Pawn.Location, C.Destination, class'Canvas'.Static.MakeColor(255,255,255));
				return;
			}
			C.FindPathTo(C.Destination);
		}
		for (i = 0; i < 16; i++)
		{
			if (C.RouteCache[i] == None)
				break;
			bPath = true;
			Draw3DLine(Start,C.RouteCache[i].Location,class'Canvas'.Static.MakeColor(0,255,0));
			Start = C.RouteCache[i].Location;
		}
		if (bPath)
			Draw3DLine(Start,C.Destination,class'Canvas'.Static.MakeColor(255,255,255));
	}
	else if (PlayerOwner.ViewTarget.Velocity != vect(0,0,0))
		Draw3DLine(Start,C.Destination,class'Canvas'.Static.MakeColor(255,255,255));

	if (C == PlayerOwner)
		return;

	// show where pawn is looking
	if (C.Focus != None)
		End = C.Focus.Location;
	else
		End = C.FocalPoint;
	Draw3DLine(PlayerOwner.ViewTarget.Location + Pawn(PlayerOwner.ViewTarget).BaseEyeHeight * vect(0,0,1),End,class'Canvas'.Static.MakeColor(255,0,0));
}

/* DrawHUD() Draw HUD elements on canvas.
*/
function DrawHUD(Canvas Canvas);

function bool ProcessKeyEvent(int Key, int Action, FLOAT Delta)
{
	if (NextHud != None)
		return NextHud.ProcessKeyEvent(Key,Action,Delta);
	return false;
}

//=============================================================================
// Font Selection.

function UseSmallFont(Canvas Canvas)
{
	if (Canvas.ClipX <= 640)
		Canvas.Font = SmallFont;
	else
		Canvas.Font = MedFont;
}

function UseMediumFont(Canvas Canvas)
{
	if (Canvas.ClipX <= 640)
		Canvas.Font = MedFont;
	else
		Canvas.Font = BigFont;
}

function UseLargeFont(Canvas Canvas)
{
	if (Canvas.ClipX <= 640)
		Canvas.Font = BigFont;
	else
		Canvas.Font = LargeFont;
}

function UseHugeFont(Canvas Canvas)
{
	Canvas.Font = LargeFont;
}

function bool IsPlayerGameOver();

defaultproperties
{
    SmallFont=Font'SmallFont'
    MedFont=Font'SmallFont'
    BigFont=Font'SmallFont'
    LargeFont=Font'SmallFont'
    bHidden=True
}