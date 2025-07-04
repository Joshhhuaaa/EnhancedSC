class EObjectHud extends Actor;

// General screen Stuff
const   SCREEN_HALF_X               = 320;
const   SCREEN_HALF_Y               = 240;  
const   SCREEN_END_X                = 640;
const   SCREEN_END_Y                = 480;

enum EHUD_COLOR 
{
    EHC_GREEN,
	EHC_GREEN_PALE,
    EHC_RED,
    EHC_BLACK,       
    EHC_GRAY,
    EHC_ALPHA_BLACK,
    EHC_ALPHA_WHITE,
	EHC_ALPHA_RED,
    EHC_ALPHA_GREEN,	
};

var Color           Black;
var Color           White;
var Color			Green;
var Color			GreenPale;

var EchelonLevelInfo	eLevel;		// Link to mega textures
var EchelonGameInfo	    eGame;		// Link to Hud Offset Values

function PostBeginPlay()
{
	Super.PostBeginPlay();

    eGame  = EchelonGameInfo(Owner.Level.Game);
	eLevel = EchelonLevelInfo(Owner.Level);
}

function DrawView(HUD Hud, ECanvas Canvas);		// Drawing
function ObjectHudTick( float DeltaTime );		// Ticking

//------------------------------------------------------------------------
// Description		
//		Draws a vertical or horizontal line from pt A to pt B
//------------------------------------------------------------------------
function DrawLine(int AX, int AY, int BX, int BY, EHUD_COLOR eColor, ECanvas Canvas)
{
    local int iTemp, index;
	
    // Arrange Position //
    if (BX < AX)
    {
        iTemp = BX;
        BX = AX;
        AX = iTemp;
    }
	
    if (BY < AY)
    {
        iTemp = BY;
        BY = AY;
        AY = iTemp;
    }
	
    // Get color index //
    switch(eColor)
    {
	case EHC_GREEN:
		Canvas.DrawColor = Green;
		break;
	case EHC_GREEN_PALE:
		Canvas.DrawColor = GreenPale;		
		break;
	case EHC_RED:
		Canvas.SetDrawColor(128,0,0);
		break;
	case EHC_BLACK:
		Canvas.DrawColor = Black;
		break;
	case EHC_GRAY:
		Canvas.SetDrawColor(80,80,80);
		break;
	case EHC_ALPHA_BLACK:
		Canvas.DrawColor = Black;
		Canvas.DrawColor.A = 128;
		break;
	case EHC_ALPHA_WHITE:
		Canvas.SetDrawColor(128,128,128);
		Canvas.DrawColor.A = 128;
		break;
	case EHC_ALPHA_RED:
		Canvas.SetDrawColor(90,0,0);
		Canvas.DrawColor.A = 128;
		break;
	case EHC_ALPHA_GREEN:
		Canvas.DrawColor = Green;
		Canvas.DrawColor.A = 128;
		break;	
    }
	
    Canvas.SetPos(AX, AY);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.pixel, BX-AX, BY-AY, 0, 0, 1, 1);
}

//------------------------------------------------------------------------
// Description		
//		
//------------------------------------------------------------------------
function DrawRectangle(int AX, int AY, int BX, int BY, int LineWidth, EHUD_COLOR eColor, ECanvas Canvas)
{
    // TOP //
    DrawLine(AX, AY, BX, AY + LineWidth, eColor, Canvas);
    // BOTTOM //
    DrawLine(AX, BY - LineWidth, BX, BY, eColor, Canvas);
    // LEFT //
    DrawLine(AX, AY + LineWidth, AX + LineWidth, BY - LineWidth, eColor, Canvas);
    // RIGHT //
    DrawLine(BX - LineWidth, AY + LineWidth, BX, BY - LineWidth, eColor, Canvas);
}

// TEMP WRAPPER
//function DrawLine(int OriginX, int OriginY, int Length, int Width, EHUD_COLOR eColor, ECanvas Canvas)
//{
//	Canvas.DrawLine(OriginX, OriginY, Length, Width, eColor);
//}
//function DrawRectangle(int AX, int AY, int BX, int BY, int LineWidth, EHUD_COLOR eColor, ECanvas Canvas)
//{
//	Canvas.DrawRectangle(AX, AY, BX, BY, LineWidth, eColor);
//}

//------------------------------------------------------------------------
// Description		
//		
//------------------------------------------------------------------------
function DrawSniperMask(ECanvas Canvas)
{
    local int width, height;

    width = eLevel.TGAME.GetWidth(eLevel.TGAME.svf2_bordernoir);
    height = eLevel.TGAME.GetHeight(eLevel.TGAME.svf2_bordernoir);

    Canvas.SetDrawColor(128,128,128);
	Canvas.Style=ERenderStyle.STY_Alpha;
    // Black Mask
    Canvas.SetPos(0,0);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_bordernoir, width ,height, 0, 0, width, height);

    Canvas.SetPos(0, SCREEN_END_Y - height);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_bordernoir, width ,height, 0, height, width, -height);
    
    Canvas.SetPos(SCREEN_END_X - width, 0);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_bordernoir, width ,height, width, 0, -width, height);
    
    Canvas.SetPos(SCREEN_END_X - width, SCREEN_END_Y - height);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_bordernoir, width ,height, width, height, -width, -height);
	Canvas.Style=ERenderStyle.STY_Normal;
}

defaultproperties
{
    Black=(R=0,G=0,B=0,A=255)
    White=(R=128,G=128,B=128,A=255)
    Green=(R=38,G=81,B=50,A=255)
    GreenPale=(R=47,G=83,B=62,A=255)
    bHidden=true
}