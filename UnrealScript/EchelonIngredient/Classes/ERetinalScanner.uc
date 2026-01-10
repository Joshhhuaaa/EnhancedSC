class ERetinalScanner extends EDoorOpener;
/******************************************************************************

 Class:         ERetinalScanner

 Description:   -

 Reference:     -


******************************************************************************/
/*-----------------------------------------------------------------------------
                               E X E C ' S
-----------------------------------------------------------------------------*/
#exec new TrueTypeFontFactory Name=Verdana6 FontName="Verdana" Height=6 AntiAlias=0 CharactersPerPage=64

/*-----------------------------------------------------------------------------
                      T Y P E   D E F I N I T I O N S
-----------------------------------------------------------------------------*/
const ORIGIN_X  = 350;
const ORIGIN_Y  = 25;

const COLUMN_SIZE = 13;
const ROW_SIZE_LEFT = 7;
const ROW_SIZE_RIGHT = 13;

const RETICAL_BOX_WIDTH = 123;
const RETICAL_BOX_HEIGHT = 173;

const GREEN_BORDER_H_WIDTH = 8;
const GREEN_BORDER_V_WIDTH = 3;
const WHITE_BORDER_WIDTH   = 1;

const EYE_PICTURE_WIDTH = 111;
const EYE_PICTURE_HEIGHT = 93;

const BOX_PICTURE_WIDTH = 115;
const BOX_PICTURE_HEIGHT = 97;

const BOX_TOP_TEXT_WIDTH = 111;
const BOX_TOP_TEXT_HEIGHT = 31;
const BOX_TOP_TEXT_BLACK_ZONE_WIDTH = 107;
const BOX_TOP_TEXT_BLACK_ZONE_HEIGHT = 23;

const BOX_BOTTOM_TEXT_WIDTH = 107;
const BOX_BOTTOM_TEXT_HEIGHT = 23;
const BOX_BOTTOM_PALE_HOR_THICK = 3;
const BOX_BOTTOM_PALE_VER_THICK = 3;

const SCAN_WIDTH = 90;
const LIFE_BAR_WIDTH = 17;





var enum ECHELON_RETINAL_SCAN_STATUS
{
    ERSS_WAITING,
    ERSS_SCANNING,
    ERSS_PROCESSING,
    ERSS_GRANTING,
    ERSS_DENYING
} eRetinalScanStatus;

/*-----------------------------------------------------------------------------
                   I N S T A N C E   V A R I A B L E S
-----------------------------------------------------------------------------*/
var			EPawn				User;
var(Door)	class<EPawn>		GrantedClass;
var         EMainHUD            my_hud;

var         float               fRetinalScanTimer;

var         Color               DarkWhite;
var         Color               FrameLightGreen;
var         Color               FrameDarkGreen;
var         Color               FrameDarkerGreen;
var         Color               White;
var         Color               Black;

var         int                 iEffectCounter;
var         array<String>       aStrLeftStatic;
var         array<String>       aStrRightStatic;

var         PlayerController    oPC;

// modifiers for retinal camera view
var Vector lll;
var rotator rrr;

var EchelonLevelInfo                eLevel;
var	EchelonGameInfo			        eGame;

var bool                            bWasAGrabbedScan;

/*-----------------------------------------------------------------------------
                               C O D E
-----------------------------------------------------------------------------*/
/*-----------------------------------------------------------------------------
    Function :      PostBeginPlay

    Description:    Setup colors and string arrays
-----------------------------------------------------------------------------*/
function PostBeginPlay()
{
    local   int i;



    Super.PostBeginPlay();

	DarkWhite.R = 123;
	DarkWhite.G = 147;
	DarkWhite.B = 103;
	DarkWhite.A = 255;


    FrameLightGreen.R = 207;
    FrameLightGreen.G = 220;
    FrameLightGreen.B = 162;
    FrameLightGreen.A = 255;

    FrameDarkGreen.R = 94;
    FrameDarkGreen.G = 140;
    FrameDarkGreen.B = 85;
    FrameDarkGreen.A = 255;

    FrameDarkerGreen.R = 47;
    FrameDarkerGreen.G = 70;
    FrameDarkerGreen.B = 42;
    FrameDarkerGreen.A = 255;

    White.R = 255;
    White.G = 255;
    White.B = 255;
    White.A = 255;

    Black.R = 0;
    Black.G = 0;
    Black.B = 0;
    Black.A = 255;

    // Fill String Arrays for retinal scan effects
    for (i = 0; i < COLUMN_SIZE; i++)
    {
        aStrLeftStatic[i] = CreateRandomBinaryString(ROW_SIZE_LEFT - 3, ROW_SIZE_LEFT);
        aStrRightStatic[i] = CreateRandomGeneticString(ROW_SIZE_RIGHT - 9, ROW_SIZE_RIGHT, TRUE);
    }

    eLevel = EchelonLevelInfo(Level);
	eGame  = EchelonGameInfo(Level.Game);
}

/*-----------------------------------------------------------------------------
    Function :      DrawView

    Description:    Main drawring/rendering function
-----------------------------------------------------------------------------*/
function DrawView(HUD Hud, ECanvas Canvas)
{
    local Vector oLoc;
    local Rotator  oRot;

    oRot = Rotation;
	oRot.Pitch += rrr.Pitch;
	oRot.Yaw += rrr.Yaw;
	oRot.Roll += rrr.Roll;

	oLoc = Location;
	oLoc += lll.X * (Vect(1,0,0) >> oRot);
	oLoc += lll.Y * (Vect(0,1,0) >> oRot);
	oLoc += lll.Z * (Vect(0,0,1) >> oRot);

    if (eGame.pPlayer.bShowInventory && eGame.pPlayer.bShowHUD) // Joshua - Show Retinal Scanner info only if inventory enabled
	{
        Canvas.BeginScene(0, 0, Canvas.ViewPortSizeX(), Canvas.ViewPortSizeY(), Canvas.ViewPortSizeX(), Canvas.ViewPortSizeY(), Canvas.E_CLEAR_ALL);
        bHidden = TRUE;

        Canvas.DrawCameraPortal(oLoc, oRot, 90.0, Canvas.E_CLEAR_NONE);
        bHidden = FALSE;

        Canvas.BeginScene(0, 0, Canvas.ViewPortSizeX(), Canvas.ViewPortSizeY(), 640.0f, 480.0f, Canvas.E_CLEAR_NONE);
        DrawStaticFrame(Canvas);
        DrawDynamicStuff(Canvas);
    }
}

function TileTex(int xTopLeft, int yTopLeft, int width, int height, ECanvas Canvas, int TextInd)
{
	// LEFT BORDER
	Canvas.SetPos(xTopLeft, yTopLeft);
	eLevel.TGAME.DrawTileFromManager(Canvas,
		                              TextInd,
									  width,
									  height,
									  0, 0, eLevel.TGAME.GetWidth(TextInd), eLevel.TGAME.GetHeight(TextInd));
}

function DrawSquareLine(int xTopLeft, int yTopLeft, int width, int height, ECanvas Canvas, int TexInd, Color myColor)
{
	// LEFT BORDER
	Canvas.DrawColor = myColor;

	// LEFT BORDER
	Canvas.SetPos(xTopLeft, yTopLeft);
	eLevel.TGAME.DrawTileFromManager(Canvas, TexInd,1, height, 0, 0, 1, 1);

	// RIGHT BORDER
	Canvas.SetPos(xTopLeft + width - 1, yTopLeft);
	eLevel.TGAME.DrawTileFromManager(Canvas, TexInd,1, height, 0, 0, 1, 1);

	// TOP BORDER
	Canvas.SetPos(xTopLeft, yTopLeft);
	eLevel.TGAME.DrawTileFromManager(Canvas, TexInd, width, 1, 0, 0, 1, 1);

	// BOTTOM BORDER
	Canvas.SetPos(xTopLeft, yTopLeft + height - 1);
	eLevel.TGAME.DrawTileFromManager(Canvas, TexInd, width, 1, 0, 0, 1, 1);


	Canvas.SetDrawColor(128,128,128,255);
}

function DrawWhiteSquareCorner(int xTopLeft, int yTopLeft, int width, int height, ECanvas Canvas)
{

	Canvas.SetDrawColor(128,128,128,255);

	// TOP LEFT CORNER
	Canvas.SetPos(xTopLeft, yTopLeft);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.rs_coin, 8, 8, 8, 0, -8, 8);

	// BOTTOM LEFT CORNER
	Canvas.SetPos(xTopLeft, yTopLeft + height - 8);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.rs_coin, 8, 8, 8, 8, -8, -8);

	// TOP RIGHT CORNER
	Canvas.SetPos(xTopLeft + width - 8, yTopLeft);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.rs_coin, 8, 8, 0, 0, 8, 8);

	// BOTTOM RIGHT CORNER
	Canvas.SetPos(xTopLeft + width - 8, yTopLeft + height - 8);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.rs_coin, 8, 8, 0, 8, 8, -8);

	// LEFT BORDER
	Canvas.SetPos(xTopLeft, yTopLeft + 8);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.rs_stroke_v,1, height - 16, 0, 0, 1, 8);

	// RIGHT BORDER
	Canvas.SetPos(xTopLeft + width - 1, yTopLeft + 8);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.rs_stroke_v,1, height - 16, 0, 0, 1, 8);

	// TOP BORDER
	Canvas.SetPos(xTopLeft + 8, yTopLeft);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.rs_stroke_h, width - 16, 1, 0, 0, 8, 1);

	// BOTTOM BORDER
	Canvas.SetPos(xTopLeft + 8, yTopLeft + height - 1);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.rs_stroke_h, width - 16, 1, 0, 0, 8, 1);

	Canvas.SetDrawColor(128,128,128,255);
}

/*-----------------------------------------------------------------------------
    Function :      DrawStaticFrame

    Description:    -
-----------------------------------------------------------------------------*/
function DrawStaticFrame(ECanvas Canvas)
{
	local int xPos, yPos;
	local EPlayerController EPC;

	EPC = EPlayerController(oPC);

	// Joshua - Adjust position for horizontal lifebar (place under lifebar on right edge)
	if (EPC != None && EPC.bHorizontalLifeBar)
	{
		xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH;
		yPos = eGame.HUD_OFFSET_Y + LIFE_BAR_WIDTH;
	}
	else
	{
		xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH - LIFE_BAR_WIDTH;
		yPos = eGame.HUD_OFFSET_Y;
	}

	Canvas.Style = ERenderStyle.STY_Alpha;

	// Fill the background
	Canvas.DrawLine(xPos, yPos, RETICAL_BOX_WIDTH, RETICAL_BOX_HEIGHT, FrameDarkerGreen, -1, eLevel.TGAME);

	DrawWhiteSquareCorner(xPos, yPos, RETICAL_BOX_WIDTH, RETICAL_BOX_HEIGHT, Canvas);

	DrawSquareLine(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH,
					yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH,
					BOX_PICTURE_WIDTH,
					BOX_PICTURE_HEIGHT,
					Canvas,
					eLevel.TGAME.rs_stroke_v,
					DarkWhite);

	DrawSquareLine(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1,
					yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + 1,
					BOX_PICTURE_WIDTH - 2,
					BOX_PICTURE_HEIGHT - 2,
					Canvas,
					eLevel.TGAME.rs_stroke_v,
					Black);

	// Display eye texture
	Canvas.SetPos(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 2,
		           yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + 2);

	eLevel.TGAME.DrawTileFromManager(Canvas,
		                              eLevel.TGAME.rs_oeil,
									  EYE_PICTURE_WIDTH,
									  EYE_PICTURE_HEIGHT,
									  0, 0, EYE_PICTURE_WIDTH, EYE_PICTURE_HEIGHT);

	DrawSquareLine(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH,
					yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1,
					BOX_PICTURE_WIDTH,
					BOX_TOP_TEXT_HEIGHT,
					Canvas,
					eLevel.TGAME.rs_stroke_v,
					DarkWhite);

	TileTex(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1,
		     yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1,
			 BOX_PICTURE_WIDTH - 2,
			 3,
			 Canvas,
			 eLevel.TGAME.rs_fond_stroke);

	// Fill the background
	Canvas.DrawLine(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1 + BOX_BOTTOM_PALE_VER_THICK,
		             yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1 + BOX_BOTTOM_PALE_HOR_THICK,
					 BOX_TOP_TEXT_BLACK_ZONE_WIDTH,
					 BOX_TOP_TEXT_BLACK_ZONE_HEIGHT,
					 Black, -1, eLevel.TGAME);

	Canvas.SetDrawColor(128,128,128,255);

	TileTex(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1,
		     yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1 + BOX_TOP_TEXT_BLACK_ZONE_HEIGHT + BOX_BOTTOM_PALE_HOR_THICK,
			 BOX_PICTURE_WIDTH - 2,
			 3,
			 Canvas,
			 eLevel.TGAME.rs_fond_stroke);

	// Bottom text
	DrawSquareLine(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH,
					yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + BOX_TOP_TEXT_HEIGHT - 1,
					BOX_PICTURE_WIDTH,
					BOX_TOP_TEXT_HEIGHT,
					Canvas,
					eLevel.TGAME.rs_stroke_v,
					DarkWhite);

	TileTex(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1,
		     yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1 + BOX_TOP_TEXT_HEIGHT - 1,
			 BOX_PICTURE_WIDTH - 2,
			 3,
			 Canvas,
			 eLevel.TGAME.rs_fond_stroke);

	// Fill the background
	Canvas.DrawLine(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1 + BOX_BOTTOM_PALE_VER_THICK ,
		             yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1 + BOX_BOTTOM_PALE_HOR_THICK + BOX_TOP_TEXT_HEIGHT - 1,
					 BOX_TOP_TEXT_BLACK_ZONE_WIDTH,
					 BOX_TOP_TEXT_BLACK_ZONE_HEIGHT,
					 Black, -1, eLevel.TGAME);

	Canvas.SetDrawColor(128,128,128,255);

	TileTex(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1,
		     yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1 + BOX_TOP_TEXT_HEIGHT - 1 + BOX_TOP_TEXT_BLACK_ZONE_HEIGHT + BOX_BOTTOM_PALE_HOR_THICK ,
			 BOX_PICTURE_WIDTH - 2,
			 3,
			 Canvas,
			 eLevel.TGAME.rs_fond_stroke);
}

/*-----------------------------------------------------------------------------
    Function :      DrawDynamicStuff

    Description:    -
-----------------------------------------------------------------------------*/
function DrawDynamicStuff(ECanvas Canvas)
{

    // Draw Random green characters that make it look like eye is really analysed and looked up in database.
    DrawEffects(Canvas);
    DrawTextOutput(Canvas);
}

/*-----------------------------------------------------------------------------
    Function :      DrawRetinalTarget

    Description:    Draw Target and little line things over eye
-----------------------------------------------------------------------------*/
function DrawRetinalTarget(ECanvas Canvas)
{
    local int i, xPos, yPos;
    local EPlayerController EPC;

    EPC = EPlayerController(oPC);

    // Joshua - Adjust position for horizontal lifebar (place under lifebar on right edge)
    if (EPC != None && EPC.bHorizontalLifeBar)
    {
        xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH;
        yPos = eGame.HUD_OFFSET_Y + LIFE_BAR_WIDTH;
    }
    else
    {
        xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH - LIFE_BAR_WIDTH;
        yPos = eGame.HUD_OFFSET_Y;
    }

    Canvas.DrawColor = White;
    Canvas.SetPos(xPos + 50, yPos + 42);
    Canvas.DrawTile(Texture'rs_scan1', 32, 32, 0, 0, 32, 32);

    // Square around Eye
    DrawSquare(xPos + 11, yPos + 16, xPos + 115, yPos + 100, 1, FrameLightGreen, Canvas);

    // Little lines
    // Top
    for (i = 0; i < 6; i++)
    {
        Canvas.DrawLine(xPos + 65, yPos + 20 + (i * 4), 2, 1, FrameLightGreen, -1, eLevel.TGAME);
    }

    // Bottom
    for (i = 0; i < 6; i++)
    {
        Canvas.DrawLine(xPos + 65, yPos + 75 + (i * 4), 2, 1, FrameLightGreen, -1, eLevel.TGAME);
    }

    // Left
    for (i = 0; i < 8; i++)
    {
        Canvas.DrawLine(xPos + 16 + (i * 4), yPos + 59, 2, 1, FrameLightGreen, -1, eLevel.TGAME);
    }

    // Right
    for (i = 0; i < 8; i++)
    {
        Canvas.DrawLine(xPos + 83 + (i * 4), yPos + 59, 2, 1, FrameLightGreen, -1, eLevel.TGAME);
    }
}

/*-----------------------------------------------------------------------------
    Function :      DrawTextOutput

    Description:    Draws scanee name and access granted/denied msg
-----------------------------------------------------------------------------*/
function DrawTextOutput(ECanvas Canvas)
{
	local int xPos, yPos;
	local float xLen, yLen;
	local string text;
	local EPlayerController EPC;

	EPC = EPlayerController(oPC);

	// Joshua - Adjust position for horizontal lifebar (place under lifebar on right edge)
	if (EPC != None && EPC.bHorizontalLifeBar)
	{
		xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH;
		yPos = eGame.HUD_OFFSET_Y + LIFE_BAR_WIDTH;
	}
	else
	{
		xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH - LIFE_BAR_WIDTH;
		yPos = eGame.HUD_OFFSET_Y;
	}

	Canvas.Font = Font'EHUDFont';
	text = "T";
	Canvas.TextSize(text, xLen, yLen);

    if ((eRetinalScanStatus == ERSS_DENYING))
    {
        Canvas.DrawColor.R = 255;
        Canvas.DrawColor.G = 161;
        Canvas.DrawColor.B = 101;


        Canvas.SetPos(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1 + BOX_BOTTOM_PALE_VER_THICK + 1 ,
		               yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1 + BOX_BOTTOM_PALE_HOR_THICK);
        Canvas.DrawText(Canvas.LocalizeStr("IDENTITY"));


		Canvas.SetPos(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1 + BOX_BOTTOM_PALE_VER_THICK + 1 ,
		               yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1 + BOX_BOTTOM_PALE_HOR_THICK + yLen - 3);
        Canvas.DrawText(Canvas.LocalizeStr("UNKNOWN"));


        Canvas.DrawColor.R = 255;
        Canvas.DrawColor.G = 161;
        Canvas.DrawColor.B = 101;
        Canvas.SetPos(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1 + BOX_BOTTOM_PALE_VER_THICK + 1 ,
			           yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1 + BOX_BOTTOM_PALE_HOR_THICK + BOX_TOP_TEXT_HEIGHT - 1);
        Canvas.DrawText(Canvas.LocalizeStr("ACCESS_DENIED"));

    }

    if ((eRetinalScanStatus == ERSS_GRANTING))
    {
        // Write pawn name (no, not Pawn->Name, its real name)
        Canvas.DrawColor.R = 75;
        Canvas.DrawColor.G = 128;
        Canvas.DrawColor.B= 82;
        Canvas.SetPos(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1 + BOX_BOTTOM_PALE_VER_THICK + 1 ,
		               yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1 + BOX_BOTTOM_PALE_HOR_THICK);

        //Canvas.DrawText("KOMBAYN");
		Canvas.DrawText(Canvas.LocalizeStr("KNOWN"));

        Canvas.SetPos(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1 + BOX_BOTTOM_PALE_VER_THICK + 1 ,
		               yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1 + BOX_BOTTOM_PALE_HOR_THICK + yLen - 3);

        Canvas.DrawText(Canvas.LocalizeStr("COLONEL"));

        Canvas.DrawColor.R = 98;
        Canvas.DrawColor.G = 161;
        Canvas.DrawColor.B = 101;
        Canvas.SetPos(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH + 1 + BOX_BOTTOM_PALE_VER_THICK + 1,
			           yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + BOX_PICTURE_HEIGHT - 1 + 1 + BOX_BOTTOM_PALE_HOR_THICK + BOX_TOP_TEXT_HEIGHT - 1);
        Canvas.DrawText(Canvas.LocalizeStr("GRANT_ACCESS"));

    }
}

/*-----------------------------------------------------------------------------
    Function :      DrawEffects

    Description:    -
-----------------------------------------------------------------------------*/
function DrawEffects(ECanvas Canvas)
{
    switch (eRetinalScanStatus)
    {
    case ERSS_WAITING:                      // Don't show anything
        break;

    case ERSS_SCANNING:                     // Left part dynamic
        DrawScanEffect(Canvas);
        //DrawLeftEffects(Canvas, TRUE);
        break;

    case ERSS_PROCESSING:                   // Left part static; Right part dynamic
		DrawScanEffect(Canvas);
        //DrawLeftEffects(Canvas, FALSE);
        //DrawRightEffects(Canvas, TRUE);
        break;

    case ERSS_GRANTING:                     // Both parts static
    case ERSS_DENYING:
        //DrawLeftEffects(Canvas, FALSE);
        //DrawRightEffects(Canvas, FALSE);
        break;

    default:
        break;

    }
}

/*-----------------------------------------------------------------------------
    Function :      DrawLeftEffects

    Description:    Draw the random text effect on left side
-----------------------------------------------------------------------------*/
function DrawLeftEffects(ECanvas Canvas, bool bDynamic)
{
    local string    strRandomText;
    local int       i, xPos, yPos;
    local EPlayerController EPC;

    EPC = EPlayerController(oPC);

    // Joshua - Adjust position for horizontal lifebar
    if (EPC != None && EPC.bHorizontalLifeBar)
    {
        xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH;
        yPos = eGame.HUD_OFFSET_Y + LIFE_BAR_WIDTH;
    }
    else
    {
        xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH - LIFE_BAR_WIDTH;
        yPos = eGame.HUD_OFFSET_Y;
    }

    Canvas.Font = Font'Verdana6';
    Canvas.DrawColor = FrameDarkGreen;
    Canvas.SetPos(xPos + 132, yPos + 25);

    for (i = 0; i < COLUMN_SIZE; i++)
    {
        Canvas.SetPos(xPos + 132, yPos + 25 + (i * 6));

        if (bDynamic)
        {
            Canvas.DrawText(CreateRandomBinaryString(ROW_SIZE_LEFT - 3, ROW_SIZE_LEFT));
        }
        else
        {
            Canvas.DrawText(aStrLeftStatic[i]);
        }
    }
}

/*-----------------------------------------------------------------------------
    Function :      DrawRightEffects

    Description:    Draw the random text effect on right side
-----------------------------------------------------------------------------*/
function DrawRightEffects(ECanvas Canvas, bool bDynamic)
{
    local string    strRandomText;
    local int       i, xPos, yPos;
    local EPlayerController EPC;

    EPC = EPlayerController(oPC);

    // Joshua - Adjust position for horizontal lifebar
    if (EPC != None && EPC.bHorizontalLifeBar)
    {
        xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH;
        yPos = eGame.HUD_OFFSET_Y + LIFE_BAR_WIDTH;
    }
    else
    {
        xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH - LIFE_BAR_WIDTH;
        yPos = eGame.HUD_OFFSET_Y;
    }

    Canvas.Font = Font'Verdana6';
    Canvas.DrawColor = FrameDarkGreen;

    for (i = 0; i < COLUMN_SIZE; i++)
    {
        Canvas.SetPos(xPos + 178, yPos + 25 + (i * 6));

        if (bDynamic)
        {
            Canvas.DrawText(CreateRandomGeneticString(ROW_SIZE_RIGHT - 9, ROW_SIZE_RIGHT, TRUE));
        }
        else
        {
            Canvas.DrawText(aStrRightStatic[i]);
        }
    }
}

/*-----------------------------------------------------------------------------
    Function :      DrawScanEffect

    Description:    -
-----------------------------------------------------------------------------*/
function DrawScanEffect(ECanvas Canvas)
{
	local int xPos, yPos;
	local EPlayerController EPC;

	EPC = EPlayerController(oPC);

    Canvas.DrawColor = White;
    iEffectCounter += 2;

	// Joshua - Adjust position for horizontal lifebar
	if (EPC != None && EPC.bHorizontalLifeBar)
	{
		xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH;
		yPos = eGame.HUD_OFFSET_Y + LIFE_BAR_WIDTH;
	}
	else
	{
		xPos = 640 - eGame.HUD_OFFSET_X - RETICAL_BOX_WIDTH - LIFE_BAR_WIDTH;
		yPos = eGame.HUD_OFFSET_Y;
	}


    // The "if else's" are there because we need to do it in there parts, cause cliping doesn't work

    if (iEffectCounter < SCAN_WIDTH)   // Not completely in yet, clip me at top
    {
        Canvas.SetPos(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH,
			           yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH);
        Canvas.DrawTile(Texture'rs_animvideo', BOX_PICTURE_WIDTH, iEffectCounter, 0, SCAN_WIDTH - iEffectCounter, 8, iEffectCounter);
    }
    else if (iEffectCounter < (BOX_PICTURE_HEIGHT)) // Contained
    {
        Canvas.SetPos(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH,
			           yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + (iEffectCounter - SCAN_WIDTH));
        Canvas.DrawTile(Texture'rs_animvideo', BOX_PICTURE_WIDTH, SCAN_WIDTH, 0, 0, 8, SCAN_WIDTH);
    }
    else if (iEffectCounter < (BOX_PICTURE_HEIGHT + 8))    // Going out, clip me at bottom
    {
        Canvas.SetPos(xPos + WHITE_BORDER_WIDTH + GREEN_BORDER_V_WIDTH,
			           yPos + WHITE_BORDER_WIDTH + GREEN_BORDER_H_WIDTH + (iEffectCounter - SCAN_WIDTH));
        Canvas.DrawTile(Texture'rs_animvideo', BOX_PICTURE_WIDTH, SCAN_WIDTH - (iEffectCounter - BOX_PICTURE_HEIGHT) , 0, 0, 8, SCAN_WIDTH - (iEffectCounter - BOX_PICTURE_HEIGHT));
    }
}

/*-----------------------------------------------------------------------------
    Function :      ValidateUser

    Description:    -
-----------------------------------------------------------------------------*/
function ValidateUser(Pawn Scanned)
{
	User = EPawn(Scanned);

	if (User == None)
    {
		Log("Problem with ValidateUser type");
    }

	GotoState(,'Validate');
}

/*-----------------------------------------------------------------------------
    Function :      CreateRandomBinaryString

    Description:
-----------------------------------------------------------------------------*/
function String CreateRandomBinaryString(int iStrLenMin, int iStrLenMax, optional bool bWithSpaces)
{
    local int       i;
    local int       iStrLen;
    local String    strRandomText;

    iStrLen = iStrLenMin + int((iStrLenMax - iStrLenMin) * FRand()) + 1;

    // Just make sure, in case FRand() returns 1.0;
    if (iStrLen > iStrLenMax)
    {
        iStrLen = iStrLenMax;
    }

    for (i = 0; i < iStrLen; i++)
    {
        if (FRand() < 0.5)
        {
            strRandomText = strRandomText $ "1";
        }
        else
        {
            strRandomText = strRandomText $ "0";
        }

        if (bWithSpaces)
        {
            strRandomText = strRandomText $ " ";
        }
    }

    return strRandomText;
}

/*-----------------------------------------------------------------------------
    Function :      CreateRandomGeneticString

    Description:    Not as scientific as it sounds
-----------------------------------------------------------------------------*/
function String CreateRandomGeneticString(int iStrLenMin, int iStrLenMax, optional bool bWithHyphens)
{
    local String    strRandomText;
    local int       i;
    local int       iStrLen;
    local float     fRandom;

    iStrLen = iStrLenMin + int((iStrLenMax - iStrLenMin) * FRand()) + 1;

    // Just make sure, in case FRand() returns 1.0;
    if (iStrLen > iStrLenMax)
    {
        iStrLen = iStrLenMax;
    }

    for (i = 0; i < iStrLen; i += 2)
    {
        if ((bWithHyphens) && (i != 0))
        {
            strRandomText = strRandomText $ "-";
        }

        fRandom = FRand();

        if (fRandom < 0.25)
        {
            strRandomText = strRandomText $ "A";
        }
        else if (fRandom < 0.50)
        {
            strRandomText = strRandomText $ "C";
        }
        else if (fRandom < 0.75)
        {
            strRandomText = strRandomText $ "G";
        }
        else
        {
            strRandomText = strRandomText $ "T";
        }
    }

    return strRandomText;
}

/*-----------------------------------------------------------------------------
    Function :      DrawSquare

    Description:    -
-----------------------------------------------------------------------------*/
function DrawSquare(int AX, int AY, int BX, int BY, int iBorderWidth, Color oColor, ECanvas Canvas)
{
    Canvas.DrawLine(AX, AY, (BX - AX) + iBorderWidth, iBorderWidth, oColor, -1, eLevel.TGAME);
    Canvas.DrawLine(AX, BY, (BX - AX) + iBorderWidth, iBorderWidth, oColor, -1, eLevel.TGAME);
    Canvas.DrawLine(AX, AY, (BY - AY) + iBorderWidth, iBorderWidth, oColor, -1, eLevel.TGAME);
    Canvas.DrawLine(BX, AY, (BY - AY) + iBorderWidth, iBorderWidth, oColor, -1, eLevel.TGAME);
}

/*=============================================================================
    State:          s_Idle

    Description:    When scanner is not used
=============================================================================*/
auto state s_Idle
{
}

/*=============================================================================
    State:          s_Use

    Description:    Scanner is being used by Sam
=============================================================================*/
state s_Use
{
    /*-------------------------------------------------------------------------
        Function :      BeginState

        Description:    -
    -------------------------------------------------------------------------*/
	function BeginState()
	{
		// Play sound
        // Validate npc using it
	}

Validate:
    eRetinalScanStatus = ERSS_WAITING;

	// Get the player controller
	oPC = Level.Game.PlayerC;
	if (oPC == None)
		Log("ERROR: Level PlayerController shouldn't be None");

	// If it's the player or a Npc forced retinal scanning, pop the interface
	if (User.Controller.bIsPlayer || User.Controller.GetStateName() == 's_Grabbed')
	{
        my_hud = EMainHUD(oPC.myHud);
		my_hud.Slave(self);
	}

    if (User.Controller.GetStateName() == 's_Grabbed')
    {
        bWasAGrabbedScan = true;
    }
    else
    {
        bWasAGrabbedScan = false;
    }

	AddSoundRequest(Sound'Electronic.Play_RetinalScan', SLOT_SFX, 1.4f);

    eRetinalScanStatus = ERSS_SCANNING;
    iEffectCounter = 0;
    Sleep(3);
    eRetinalScanStatus = ERSS_PROCESSING;
	iEffectCounter = 0;
    LightBrightness = 0;

	Sleep(3);

    if (User.IsA(GrantedClass.name))
	{
		// Send
		if (User.Controller.GetStateName() == 's_Grabbed')
			TriggerLinkedActors(oPC.Pawn);
		else
			TriggerLinkedActors(User);

        eRetinalScanStatus = ERSS_GRANTING;
	}
	else
	{
        eRetinalScanStatus = ERSS_DENYING;

		// Inform alarm that access was denied
		if (Alarm != None)
			Alarm.EnableAlarm(self, User.Controller);
	}

    Sleep(2);

    // Restore View if set above
    if (User.Controller.bIsPlayer || bWasAGrabbedScan)
	{
		EMainHUD(oPC.myHud).NormalView();
		oPC.AnimEnd(79);
		Interaction.PostInteract(oPC);
	}
	else
		//User.Controller.AnimEnd(79);
		Interaction.PostInteract(User.Controller);

    eRetinalScanStatus = ERSS_WAITING;
}

/*-----------------------------------------------------------------------------
                       D E F A U L T   P R O P E R T I E S
-----------------------------------------------------------------------------*/

defaultproperties
{
    rrr=(Pitch=10000,Yaw=0,Roll=0)
    bIsRetinalScanner=True
    AlarmLinkType=EAlarm_Trigger
    StaticMesh=StaticMesh'EMeshIngredient.Object.retinal_scanner'
    CollisionRadius=8.000000
    CollisionHeight=37.000000
    bBlockPlayers=True
    bBlockActors=True
    InteractionClass=Class'ERetinalScannerInteraction'
}