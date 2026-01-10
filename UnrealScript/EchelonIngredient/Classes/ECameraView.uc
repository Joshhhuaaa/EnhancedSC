 /*=============================================================================

 Class:         ECameraView

 Description:   Camera HUD

 Reference:     -

=============================================================================*/
class ECameraView extends EObjectHud;

/*-----------------------------------------------------------------------------
                        T Y P E   D E F I N I T I O N S
-----------------------------------------------------------------------------*/
// CAMERA VIEW SIZE //
const CAM_X                 = 43;
const TOP_CAM_Y             = 45;
const BOTTOM_CAM_Y          = 40;

const SIDEBAR_WIDTH         = 12;

const BOTTOMBAR_HEIGHT      = 12;

const TOPBAR_HEIGHT         = 26;
const TOPBAR_CORNER_X       = 76;
const TOPBAR_CORNER_Y       = 11;

const CROSSHAIR_WIDTH       = 13;
const CROSSHAIR_HEIGHT      = 9;

const FILTER_HEIGHT         = 64;

const BUTTONBAR_HEIGHT = 30;

/*-----------------------------------------------------------------------------
                        M E M B E R   V A R I A B L E S
-----------------------------------------------------------------------------*/
var float           fDistance;
var int             fFilterY;
var EAirCamera		Camera;

/*-----------------------------------------------------------------------------
                                M E T H O D S
-----------------------------------------------------------------------------*/
function DrawIcon(ECanvas Canvas);
function UpdateDistanceMeter(float DeltaTime);

/*-----------------------------------------------------------------------------
    Function :      PostBeginPlay

    Description:    -
-----------------------------------------------------------------------------*/
function PostBeginPlay()
{
    Super.PostBeginPlay();

    fFilterY = TOP_CAM_Y - FILTER_HEIGHT;

	Camera = EAirCamera(Owner);
	if (Camera == None)
		Log(self$" ERROR : ECameraView Owner not a EAirCamera");
}

/*=============================================================================
    State :      s_Online
=============================================================================*/
state s_Online
{
    /*-----------------------------------------------------------------------------
        Function :      Tick

        Description:    -
    -----------------------------------------------------------------------------*/
	function Tick(float DeltaTime)
	{
        // Update Distance Meter
		UpdateDistanceMeter(DeltaTime);

		// Update Filter Position //
		fFilterY += 60.0 * DeltaTime;
		if (fFilterY > SCREEN_END_Y - BOTTOM_CAM_Y + FILTER_HEIGHT)
			fFilterY = TOP_CAM_Y - FILTER_HEIGHT;
	}

    /*-----------------------------------------------------------------------------
        Function :      DrawView

        Description:    -
    -----------------------------------------------------------------------------*/
	function DrawView(HUD Hud,ECanvas Canvas)
	{
        local EPlayerController EPC; // Joshua - Show cam toggle
        EPC = EPlayerController(Camera.Owner);

        if (EPC.bShowScope && EPC.bShowHUD)
        {
            DrawFilm(Canvas);
            DrawNoiseBars(Canvas);
            DrawSideBars(Canvas);
            DrawButtons(Canvas);
            DrawIcon(Canvas);
            DrawTopAndBottomBars(Canvas);
        }

        if (EPC.bShowCrosshair && EPC.bShowHUD) // Joshua - Show crosshair toggle
                DrawCrosshair(Canvas);

        if (EPC.bShowScope && EPC.bShowHUD)
            DrawBlackMask(Canvas);
	}
}

/*-----------------------------------------------------------------------------
    Function :      DrawPitchBars

    Description:    -
-----------------------------------------------------------------------------*/
function DrawPitchBars(ECanvas Canvas)
{
    local int offset;

    //offset = (Camera.camera_rotation.Pitch + Camera.max_pitch) / (Camera.max_pitch * 2) * (SCREEN_END_Y - TOP_CAM_Y - BOTTOM_CAM_Y - 5);

    Canvas.DrawLine(CAM_X + 2, TOP_CAM_Y + 2 + offset, SIDEBAR_WIDTH - 4, 1, Green, -1, eLevel.TGAME);
    Canvas.DrawLine(SCREEN_END_X - CAM_X - SIDEBAR_WIDTH + 2, TOP_CAM_Y + 2 + offset, SIDEBAR_WIDTH - 4, 1, Green, -1, eLevel.TGAME);
}

/*-----------------------------------------------------------------------------
    Function :      DrawNoiseBars

    Description:    -
-----------------------------------------------------------------------------*/
function DrawNoiseBars(ECanvas Canvas)
{
    local float pRotation;
    local int position;
    local int qPos, rPos, yPos;
    local string szFirstDir, szSecondDir;
    local int p1, p2;

    yPos = SCREEN_END_Y - BOTTOM_CAM_Y - BUTTONBAR_HEIGHT - BOTTOMBAR_HEIGHT - 6;

    pRotation = float(Camera.camera_rotation.Yaw & 65535) / 65535.0;

    // Hack for Defense Ministry
    // Joshua - This shifts the compass by 90 degrees so the East Wing of the map point towards East on the binoculars
	if (Left(GetCurrentMapName(), 3) == "1_2")
		pRotation += 0.25;
	if (pRotation >= 1.0)
		pRotation -= 1.0;

    position = pRotation * 5040;

    qPos = position / 630;
    rPos = position % 630;

    switch (qPos)
    {
        case 0:
            szFirstDir = "N";
            szSecondDir = "NE";
            p1 = 8;
            p2 = 12;
            break;
        case 1:
            szFirstDir = "NE";
            szSecondDir = "E";
            p1 = 12;
            p2 = 8;
            break;
        case 2:
            szFirstDir = "E";
            szSecondDir = "SE";
            p1 = 8;
            p2 = 12;
            break;
        case 3:
            szFirstDir = "SE";
            szSecondDir = "S";
            p1 = 12;
            p2 = 8;
            break;
        case 4:
            szFirstDir = "S";
            szSecondDir = "SW";
            p1 = 8;
            p2 = 14;
            break;
        case 5:
            szFirstDir = "SW";
            szSecondDir = "W";
            p1 = 14;
            p2 = 10;
            break;
        case 6:
            szFirstDir = "W";
            szSecondDir = "NW";
            p1 = 10;
            p2 = 14;
            break;
        case 7:
            szFirstDir = "NW";
            szSecondDir = "N";
            p1 = 14;
            p2 = 8;
            break;
    }

    // Draw Compass Coordinates //
    Canvas.DrawColor = Green;
    Canvas.Font = Font'EHUDFont';

    Canvas.SetPos(SCREEN_HALF_X - rPos, yPos - 16);
    Canvas.DrawText("["$szFirstDir$"]");

    Canvas.SetPos(SCREEN_HALF_X - rPos + p1, yPos - 9);
    Canvas.DrawText(".");
    Canvas.SetPos(SCREEN_HALF_X - rPos + p1, yPos - 8);
    Canvas.DrawText(".");

    Canvas.SetPos(SCREEN_HALF_X + (630 - rPos), yPos - 16);
    Canvas.DrawText("["$szSecondDir$"]");

    Canvas.SetPos(SCREEN_HALF_X + (630 - rPos) + p2, yPos - 9);
    Canvas.DrawText(".");
    Canvas.SetPos(SCREEN_HALF_X + (630 - rPos) + p2, yPos - 8);
    Canvas.DrawText(".");

    // Draw noise bars //
    DrawNoiseBar(CAM_X + SIDEBAR_WIDTH , yPos - 4, SCREEN_END_X - CAM_X - SIDEBAR_WIDTH, yPos, rPos % 126, Canvas);
    DrawNoiseBar(CAM_X + SIDEBAR_WIDTH , yPos + 2, SCREEN_END_X - CAM_X - SIDEBAR_WIDTH, yPos + 6, -rPos % 126, Canvas);
}

/*-----------------------------------------------------------------------------
    Function :      DrawNoiseBar

    Description:    Draw the "info" bar at top and bottom of the sniper view
-----------------------------------------------------------------------------*/
function DrawNoiseBar(int AX, int AY, int BX, int BY, int OffsetX, ECanvas Canvas)
{
    Canvas.DrawColor = White;

    Canvas.SetPos(AX, AY);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_anim_border, 630, abs(BY - AY), OffsetX, 0, 630, 4);
}

/*-----------------------------------------------------------------------------
    Function :      DrawFilm

    Description:    Draws noisy film effect on cam
-----------------------------------------------------------------------------*/
function DrawFilm(ECanvas Canvas)
{
    Canvas.DrawColor = White;
	Canvas.Style = ERenderStyle.STY_Alpha;

    Canvas.SetPos(CAM_X + SIDEBAR_WIDTH, fFilterY);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sb_filtre, SCREEN_END_X - CAM_X * 2 - SIDEBAR_WIDTH * 2, 64, 0, 0, 1, 64);
}

/*-----------------------------------------------------------------------------
    Function :      DrawSideBars

    Description:    -
-----------------------------------------------------------------------------*/
function DrawSideBars(ECanvas Canvas)
{
    local int iCurrPos;

    Canvas.DrawColor = White;

    // Left Fill //
    for (iCurrPos = TOP_CAM_Y + 2; iCurrPos < SCREEN_END_Y - BOTTOM_CAM_Y; iCurrPos += 6)
    {
        Canvas.SetPos(CAM_X + 2, iCurrPos);
        eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_fond_ligne, SIDEBAR_WIDTH - 4, 6, 0, 0, 1, 6);
    }

    // Right Fill //
    for (iCurrPos = TOP_CAM_Y + 2; iCurrPos < SCREEN_END_Y - BOTTOM_CAM_Y; iCurrPos += 6)
    {
        Canvas.SetPos(SCREEN_END_X - CAM_X - SIDEBAR_WIDTH + 2, iCurrPos);
        eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_fond_ligne, SIDEBAR_WIDTH - 4, 6, 0, 0, 1, 6);
    }

    // Left Bar Border //
    Canvas.DrawRectangle(CAM_X    , TOP_CAM_Y    , SIDEBAR_WIDTH    , SCREEN_END_Y - TOP_CAM_Y - BOTTOM_CAM_Y    , 1, Canvas.black, -1, eLevel.TGAME);
    Canvas.DrawRectangle(CAM_X + 1, TOP_CAM_Y + 1, SIDEBAR_WIDTH - 2, SCREEN_END_Y - TOP_CAM_Y - BOTTOM_CAM_Y - 2, 1, Green, -1, eLevel.TGAME);
    // Right Bar Border //
    Canvas.DrawRectangle(SCREEN_END_X - CAM_X - SIDEBAR_WIDTH    , TOP_CAM_Y    , SIDEBAR_WIDTH    , SCREEN_END_Y - TOP_CAM_Y - BOTTOM_CAM_Y    , 1, Canvas.black, -1, eLevel.TGAME);
    Canvas.DrawRectangle(SCREEN_END_X - CAM_X - SIDEBAR_WIDTH + 1, TOP_CAM_Y + 1, SIDEBAR_WIDTH - 2, SCREEN_END_Y - TOP_CAM_Y - BOTTOM_CAM_Y - 2, 1, Green, -1, eLevel.TGAME);
}

/*-----------------------------------------------------------------------------
    Function :      DrawButtons

    Description:    -
-----------------------------------------------------------------------------*/
function DrawButtons(ECanvas Canvas)
{
    // Borders //
    Canvas.DrawRectangle(CAM_X + SIDEBAR_WIDTH - 1, SCREEN_END_Y - BOTTOM_CAM_Y - BUTTONBAR_HEIGHT    ,
                         SCREEN_END_X - (CAM_X + SIDEBAR_WIDTH - 1) * 2, BUTTONBAR_HEIGHT   , 1, Canvas.black, -1, eLevel.TGAME);
    Canvas.DrawRectangle(CAM_X + SIDEBAR_WIDTH    , SCREEN_END_Y - BOTTOM_CAM_Y - BUTTONBAR_HEIGHT + 1,
                         SCREEN_END_X - (CAM_X + SIDEBAR_WIDTH) * 2    , BUTTONBAR_HEIGHT - 2, 1, Green, -1, eLevel.TGAME);

    // Fill with green //
    Canvas.DrawLine(CAM_X + SIDEBAR_WIDTH + 1, SCREEN_END_Y - BOTTOM_CAM_Y - BUTTONBAR_HEIGHT + 2,
                     SCREEN_END_X - (CAM_X + SIDEBAR_WIDTH + 1) * 2, BUTTONBAR_HEIGHT - 4, Green, 128, eLevel.TGAME);
}

/*-----------------------------------------------------------------------------
    Function :      DrawTopAndBottomBars

    Description:    -
-----------------------------------------------------------------------------*/
function DrawTopAndBottomBars(ECanvas Canvas)
{
    local int xPos, yPos, width;

    xPos = CAM_X + SIDEBAR_WIDTH;
    yPos = SCREEN_END_Y - BOTTOM_CAM_Y - BUTTONBAR_HEIGHT - BOTTOMBAR_HEIGHT + 1;
    width = SCREEN_END_X - (CAM_X + SIDEBAR_WIDTH) * 2;

    // Bottom Bar Borders //
    Canvas.DrawRectangle(xPos - 1, yPos    , width + 2, BOTTOMBAR_HEIGHT    , 1, Canvas.black, -1, eLevel.TGAME);
    Canvas.DrawRectangle(xPos    , yPos + 1, width    , BOTTOMBAR_HEIGHT - 2, 1, Green, -1, eLevel.TGAME);

    // Fill Bottom Box //
    Canvas.DrawLine(xPos + 1, yPos + 2, width - 2, BOTTOMBAR_HEIGHT - 3, Green, 128, eLevel.TGAME);

    // Top Bar H Borders //
    yPos = TOP_CAM_Y;

    Canvas.DrawLine(xPos, yPos    , width, 1, Canvas.black, -1, eLevel.TGAME);
    Canvas.DrawLine(xPos, yPos + 1, width, 1, Green, -1, eLevel.TGAME);

    Canvas.DrawLine(xPos, yPos + TOPBAR_HEIGHT - 1, TOPBAR_CORNER_X    , 1, Canvas.black, -1, eLevel.TGAME);
    Canvas.DrawLine(xPos, yPos + TOPBAR_HEIGHT - 2, TOPBAR_CORNER_X - 1, 1, Green, -1, eLevel.TGAME);

    Canvas.DrawLine(xPos + width - TOPBAR_CORNER_X    , yPos + TOPBAR_HEIGHT - 1, TOPBAR_CORNER_X    , 1, Canvas.black, -1, eLevel.TGAME);
    Canvas.DrawLine(xPos + width - TOPBAR_CORNER_X + 1, yPos + TOPBAR_HEIGHT - 2, TOPBAR_CORNER_X - 1, 1, Green, -1, eLevel.TGAME);

    Canvas.DrawLine(xPos + TOPBAR_CORNER_X - 1, yPos + TOPBAR_CORNER_Y - 1, width - TOPBAR_CORNER_X * 2 + 2 , 1, Canvas.black, -1, eLevel.TGAME);
    Canvas.DrawLine(xPos + TOPBAR_CORNER_X - 2, yPos + TOPBAR_CORNER_Y - 2, width - TOPBAR_CORNER_X * 2 + 4, 1, Green, -1, eLevel.TGAME);

    // Top Bar V Borders //
    Canvas.DrawLine(xPos            , yPos + 2, 1, TOPBAR_HEIGHT - 4, Green, -1, eLevel.TGAME);
    Canvas.DrawLine(xPos + width - 1, yPos + 2, 1, TOPBAR_HEIGHT - 4, Green, -1, eLevel.TGAME);

    Canvas.DrawLine(xPos + TOPBAR_CORNER_X - 1, yPos + TOPBAR_CORNER_Y    , 1, TOPBAR_HEIGHT - TOPBAR_CORNER_Y - 1, Canvas.black, -1, eLevel.TGAME);
    Canvas.DrawLine(xPos + TOPBAR_CORNER_X - 2, yPos + TOPBAR_CORNER_Y - 1, 1, TOPBAR_HEIGHT - TOPBAR_CORNER_Y - 1, Green, -1, eLevel.TGAME);

    Canvas.DrawLine(xPos + width - TOPBAR_CORNER_X    , yPos + TOPBAR_CORNER_Y    , 1, TOPBAR_HEIGHT - TOPBAR_CORNER_Y - 1, Canvas.black, -1, eLevel.TGAME);
    Canvas.DrawLine(xPos + width - TOPBAR_CORNER_X + 1, yPos + TOPBAR_CORNER_Y - 1, 1, TOPBAR_HEIGHT - TOPBAR_CORNER_Y - 1, Green, -1, eLevel.TGAME);

    // Fill Top Border //
    Canvas.DrawLine(xPos + 1, yPos + 2, TOPBAR_CORNER_X - 3, TOPBAR_HEIGHT - 4, Green, 128, eLevel.TGAME);
    Canvas.DrawLine(xPos + width - TOPBAR_CORNER_X + 2, yPos + 2, TOPBAR_CORNER_X - 3, TOPBAR_HEIGHT - 4, Green, 128, eLevel.TGAME);
    Canvas.DrawLine(xPos + TOPBAR_CORNER_X - 2, yPos + 2, width - TOPBAR_CORNER_X * 2 + 4, TOPBAR_CORNER_Y - 4, Green, 128, eLevel.TGAME);
}

/*-----------------------------------------------------------------------------
    Function :      DrawBlackMask

    Description:    -
-----------------------------------------------------------------------------*/
function DrawBlackMask(ECanvas Canvas)
{
    // TOP //
    Canvas.DrawLine(0, 0, SCREEN_END_X, TOP_CAM_Y, Canvas.black, -1, eLevel.TGAME);
    // BOTTOM //
    Canvas.DrawLine(0, SCREEN_END_Y - BOTTOM_CAM_Y, SCREEN_END_X, TOP_CAM_Y, Canvas.black, -1, eLevel.TGAME);
    // LEFT //
    Canvas.DrawLine(0,TOP_CAM_Y, CAM_X, SCREEN_END_Y - TOP_CAM_Y - BOTTOM_CAM_Y, Canvas.black, -1, eLevel.TGAME);
    // RIGHT //
    Canvas.DrawLine(SCREEN_END_X - CAM_X, TOP_CAM_Y, CAM_X, SCREEN_END_Y - TOP_CAM_Y - BOTTOM_CAM_Y, Canvas.black, -1, eLevel.TGAME);
}

/*-----------------------------------------------------------------------------
    Function :      DrawCrosshair

    Description:    -
-----------------------------------------------------------------------------*/
function DrawCrosshair(ECanvas Canvas)
{
    // H //
    Canvas.DrawLine(SCREEN_HALF_X - CROSSHAIR_WIDTH / 2, SCREEN_HALF_Y, CROSSHAIR_WIDTH, 1, Canvas.white, 128, eLevel.TGAME);

    // V //
    Canvas.DrawLine(SCREEN_HALF_X, SCREEN_HALF_Y - CROSSHAIR_HEIGHT / 2, 1, CROSSHAIR_HEIGHT / 2, Canvas.white, 128, eLevel.TGAME);
    Canvas.DrawLine(SCREEN_HALF_X, SCREEN_HALF_Y + 1, 1, CROSSHAIR_HEIGHT / 2, Canvas.white, 128, eLevel.TGAME);

    // H LEFT //
    Canvas.DrawLine(SCREEN_HALF_X - CROSSHAIR_WIDTH / 2, SCREEN_HALF_Y - 1, CROSSHAIR_WIDTH / 2, 1, Canvas.black, 128, eLevel.TGAME);
    Canvas.DrawLine(SCREEN_HALF_X - CROSSHAIR_WIDTH / 2, SCREEN_HALF_Y + 1, CROSSHAIR_WIDTH / 2, 1, Canvas.black, 128, eLevel.TGAME);

    // H RIGHT //
    Canvas.DrawLine(SCREEN_HALF_X + 1, SCREEN_HALF_Y - 1, CROSSHAIR_WIDTH / 2, 1, Canvas.black, 128, eLevel.TGAME);
    Canvas.DrawLine(SCREEN_HALF_X + 1, SCREEN_HALF_Y + 1, CROSSHAIR_WIDTH / 2, 1, Canvas.black, 128, eLevel.TGAME);

    // V TOP //
    Canvas.DrawLine(SCREEN_HALF_X - 1, SCREEN_HALF_Y - CROSSHAIR_HEIGHT / 2, 1, CROSSHAIR_HEIGHT / 2 - 1, Canvas.black, 128, eLevel.TGAME);
    Canvas.DrawLine(SCREEN_HALF_X + 1, SCREEN_HALF_Y - CROSSHAIR_HEIGHT / 2, 1, CROSSHAIR_HEIGHT / 2 - 1, Canvas.black, 128, eLevel.TGAME);

    // V BOTTOM //
    Canvas.DrawLine(SCREEN_HALF_X - 1, SCREEN_HALF_Y + 2, 1, CROSSHAIR_HEIGHT / 2 - 1, Canvas.black, 128, eLevel.TGAME);
    Canvas.DrawLine(SCREEN_HALF_X + 1, SCREEN_HALF_Y + 2, 1, CROSSHAIR_HEIGHT / 2 - 1, Canvas.black, 128, eLevel.TGAME);
}

/*-----------------------------------------------------------------------------
    Event :         Dist

    Description:    utility function
-----------------------------------------------------------------------------*/
function float Dist(vector a, vector b)
{
    return sqrt((b.X - a.X) * (b.X - a.X) + (b.Y - a.Y) * (b.Y - a.Y) + (b.Z - a.Z) * (b.Z - a.Z));
}


