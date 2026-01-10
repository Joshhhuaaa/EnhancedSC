/*=============================================================================

 Class:         EStickyView

 Description:   Sticky Camera HUD

 Reference:     -

=============================================================================*/
class EStickyView extends ECameraView;

/*-----------------------------------------------------------------------------
                        T Y P E   D E F I N I T I O N S
-----------------------------------------------------------------------------*/
const EYE_ICON_LEFT     = 509;
const EYE_ICON_TOP      = 345;

const BUTTON_BOX_WIDTH      = 19;
const BUTTON_BOX_HEIGHT     = 17;

const BUTTON_THERMAL_BOX_X  = 109;
const BUTTON_NIGHT_BOX_X    = 209;
const BUTTON_ZOOMP_BOX_X    = 204;
const BUTTON_ZOOMM_BOX_X    = 114;
const BUTTON_EXIT_BOX_X     = 23;


state s_Online
{
	function DrawView(HUD Hud, ECanvas Canvas)
	{
        local EPlayerController EPC; // Joshua - Show cam toggle
        EPC = EPlayerController(Camera.Owner);

        Super.DrawView(Hud, Canvas);

        if (EPC.bShowScope && EPC.bShowHUD)
        {
            // Sticky Cam specific stuff
            DrawZoomMeter(Canvas);
            DrawDistanceMeter(Canvas);
            DrawPitchBars(Canvas);
        }
	}
}

/*-----------------------------------------------------------------------------
                                M E T H O D S
-----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
    Function :      DrawIcon

    Description:    -
-----------------------------------------------------------------------------*/
function DrawIcon(ECanvas Canvas)
{
    Canvas.DrawColor = White;
	Canvas.Style = ERenderStyle.STY_Alpha;
    Canvas.SetPos(EYE_ICON_LEFT, EYE_ICON_TOP);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_ic_surveillance, 64, 32, 0, 0, 64, 32);
	Canvas.Style = ERenderStyle.STY_Normal;
}

/*-----------------------------------------------------------------------------
    Function :      DrawButtons

    Description:    -
-----------------------------------------------------------------------------*/
function DrawButtons(ECanvas Canvas)
{
    local int xPos, yPos;
	local float xLen, yLen;
	local string sTemp;
    local EPlayerController EPC; // Joshua - Controller scheme

    EPC = EPlayerController(Camera.Owner);

    Super.DrawButtons(Canvas);

    //// TODO : Used Canvas.TextSize() instead of const for the button position.  It will avoid prob with localisation //

        // Text Stuff //
        Canvas.Font = Font'EHUDFont';
        Canvas.DrawColor = Black;



        xPos = CAM_X + SIDEBAR_WIDTH;
        yPos = SCREEN_END_Y - BOTTOM_CAM_Y - (BUTTONBAR_HEIGHT / 2) - 6;

        Canvas.SetPos(xPos + BUTTON_THERMAL_BOX_X - 5, yPos);
        Canvas.DrawTextAligned(Canvas.LocalizeStr("THERMAL"),TXT_RIGHT);

        Canvas.SetPos(xPos + BUTTON_NIGHT_BOX_X - 5, yPos);
        Canvas.DrawTextAligned(Canvas.LocalizeStr("NIGHT"),TXT_RIGHT);

        xPos = SCREEN_END_X - CAM_X - SIDEBAR_WIDTH;

        Canvas.SetPos(xPos - BUTTON_ZOOMP_BOX_X - 5, yPos);
        Canvas.DrawTextAligned(Canvas.LocalizeStr("ZOOMPLUS"),TXT_RIGHT);

        Canvas.SetPos(xPos - BUTTON_ZOOMM_BOX_X - 5, yPos);
        Canvas.DrawTextAligned(Canvas.LocalizeStr("ZOOMMINUS"),TXT_RIGHT);

        Canvas.SetPos(xPos - BUTTON_EXIT_BOX_X - 5, yPos);
        Canvas.DrawTextAligned(Canvas.LocalizeStr("EXIT"),TXT_RIGHT);

    if (eGame.bUseController) // Joshua - Controller prompts for Sticky Camera
    {
        // Button box //
        xPos = CAM_X + SIDEBAR_WIDTH;
        yPos = SCREEN_END_Y - BOTTOM_CAM_Y - (BUTTONBAR_HEIGHT - BUTTON_BOX_HEIGHT) / 2;

        // Thermal button (black square)
        Canvas.DrawLine(xPos + BUTTON_THERMAL_BOX_X, yPos - BUTTON_BOX_HEIGHT, BUTTON_BOX_WIDTH, BUTTON_BOX_HEIGHT, Canvas.black, -1, eLevel.TGAME);
        Canvas.DrawRectangle(xPos + BUTTON_THERMAL_BOX_X + 1, yPos - BUTTON_BOX_HEIGHT + 1, BUTTON_BOX_WIDTH - 2, BUTTON_BOX_HEIGHT - 2, 1, Green, -1, eLevel.TGAME);

        // Night button (black square)
        Canvas.DrawLine(xPos + BUTTON_NIGHT_BOX_X, yPos - BUTTON_BOX_HEIGHT, BUTTON_BOX_WIDTH, BUTTON_BOX_HEIGHT, Canvas.black, -1, eLevel.TGAME);
        Canvas.DrawRectangle(xPos + BUTTON_NIGHT_BOX_X + 1, yPos - BUTTON_BOX_HEIGHT + 1, BUTTON_BOX_WIDTH - 2, BUTTON_BOX_HEIGHT - 2, 1, Green, -1, eLevel.TGAME);

        xPos = SCREEN_END_X - CAM_X - SIDEBAR_WIDTH;

        // Zoom plus button (black square)
        Canvas.DrawLine(xPos - BUTTON_ZOOMP_BOX_X, yPos - BUTTON_BOX_HEIGHT, BUTTON_BOX_WIDTH, BUTTON_BOX_HEIGHT, Canvas.black, -1, eLevel.TGAME);
        Canvas.DrawRectangle(xPos - BUTTON_ZOOMP_BOX_X + 1, yPos - BUTTON_BOX_HEIGHT + 1, BUTTON_BOX_WIDTH - 2, BUTTON_BOX_HEIGHT - 2, 1, Green, -1, eLevel.TGAME);
        Canvas.SetPos(xPos - BUTTON_ZOOMP_BOX_X + 1, yPos - BUTTON_BOX_HEIGHT + 1);

        // Zoom minus button (black square)
        Canvas.DrawLine(xPos - BUTTON_ZOOMM_BOX_X, yPos - BUTTON_BOX_HEIGHT, BUTTON_BOX_WIDTH, BUTTON_BOX_HEIGHT, Canvas.black, -1, eLevel.TGAME);
        Canvas.DrawRectangle(xPos - BUTTON_ZOOMM_BOX_X + 1, yPos - BUTTON_BOX_HEIGHT + 1, BUTTON_BOX_WIDTH - 2, BUTTON_BOX_HEIGHT - 2, 1, Green, -1, eLevel.TGAME);
        Canvas.SetPos(xPos - BUTTON_ZOOMM_BOX_X + 1, yPos - BUTTON_BOX_HEIGHT + 1);

        // Exit button (black square)
        Canvas.DrawLine(xPos - BUTTON_EXIT_BOX_X, yPos - BUTTON_BOX_HEIGHT, BUTTON_BOX_WIDTH, BUTTON_BOX_HEIGHT, Canvas.black, -1, eLevel.TGAME);
        Canvas.DrawRectangle(xPos - BUTTON_EXIT_BOX_X + 1, yPos - BUTTON_BOX_HEIGHT + 1, BUTTON_BOX_WIDTH - 2, BUTTON_BOX_HEIGHT - 2, 1, Green, -1, eLevel.TGAME);

        // Draw the textures inside the button box
        Canvas.DrawColor = Green;
        xPos = CAM_X + SIDEBAR_WIDTH;
        yPos = SCREEN_END_Y - BOTTOM_CAM_Y - (BUTTONBAR_HEIGHT - BUTTON_BOX_HEIGHT) / 2;

        Canvas.Style = ERenderStyle.STY_Alpha;

        // Right arrow to change vision to thermal view
        Canvas.SetPos(xPos + BUTTON_THERMAL_BOX_X + BUTTON_BOX_WIDTH / 2 - eLevel.TGAME.GetWidth(eLevel.TGAME.sc_fleche) / 2,
                    yPos - BUTTON_BOX_HEIGHT + BUTTON_BOX_HEIGHT / 2 - eLevel.TGAME.GetHeight(eLevel.TGAME.sc_fleche) / 2);
        eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_fleche2, 12, 13, 12, 13, -12, -13);


        // Left arrow to change vision to night view
        Canvas.SetPos(xPos + BUTTON_NIGHT_BOX_X + BUTTON_BOX_WIDTH / 2 - eLevel.TGAME.GetWidth(eLevel.TGAME.sc_fleche) / 2,
                    yPos - BUTTON_BOX_HEIGHT + BUTTON_BOX_HEIGHT / 2 - eLevel.TGAME.GetHeight(eLevel.TGAME.sc_fleche) / 2);
        eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_fleche2, 12, 13, 0, 0, 12, 13);

        xPos = SCREEN_END_X - CAM_X - SIDEBAR_WIDTH;

        // Down arrow to zoom out
        Canvas.SetPos(xPos - BUTTON_ZOOMP_BOX_X + BUTTON_BOX_WIDTH / 2 - eLevel.TGAME.GetWidth(eLevel.TGAME.sc_fleche) / 2,
                    yPos - BUTTON_BOX_HEIGHT + BUTTON_BOX_HEIGHT / 2 - eLevel.TGAME.GetHeight(eLevel.TGAME.sc_fleche) / 2);
        eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_fleche, 13, 12, 13, 12, -13, -12);

        // Up arrow to zoom in
        Canvas.SetPos(xPos - BUTTON_ZOOMM_BOX_X + BUTTON_BOX_WIDTH / 2 - eLevel.TGAME.GetWidth(eLevel.TGAME.sc_fleche) / 2,
                    yPos - BUTTON_BOX_HEIGHT + BUTTON_BOX_HEIGHT / 2 - eLevel.TGAME.GetHeight(eLevel.TGAME.sc_fleche) / 2);
        eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_fleche, 13, 12, 0, 0, 13, 12);

        Canvas.Style = ERenderStyle.STY_Normal;

        Canvas.DrawColor = Green;
        if (EPC.ControllerIcon == CI_PlayStation && EPC.ControllerScheme == CS_Default) // Joshua - PlayStation controller prompts
        {
            // Joshua - Default controller scheme allows Circle to exit
            Canvas.SetPos(xPos - BUTTON_EXIT_BOX_X + 5 - 1, yPos - BUTTON_BOX_HEIGHT + 2 - 1);
            Canvas.Font = Canvas.ETextFont;
            Canvas.DrawText(Chr(0xD9)); // Circle
            Canvas.Font = Font'EHUDFont';
        }
        else
        {
            Canvas.SetPos(xPos - BUTTON_EXIT_BOX_X + 5, yPos - BUTTON_BOX_HEIGHT + 2);
            // Joshua - Default controller scheme allows B to exit, otherwise R
            if (EPC.ControllerScheme == CS_Default)
                Canvas.DrawText("B");
            else
                Canvas.DrawText("R");
        }
    }
}

/*-----------------------------------------------------------------------------
    Function :      UpdateDistanceMeter

    Description:    -
-----------------------------------------------------------------------------*/
function UpdateDistanceMeter(float DeltaTime)
{
    local vector            HitLocation;
    local vector            HitNormal;
    local vector            TraceEnd;
    local Actor             Traced;
    local int               iPillTag;

    TraceEnd = Location + (vector(Camera.camera_rotation) * 5000);

    Traced = Trace(HitLocation, HitNormal, TraceEnd, Location, True);

    if (Traced != None)
    {
        fDistance = Dist(HitLocation, Location);
    }
    else
    {
        fDistance = 0.0;
    }
}

/*-----------------------------------------------------------------------------
    Function :      DrawZoomMeter

    Description:    -
-----------------------------------------------------------------------------*/
function DrawZoomMeter(ECanvas Canvas)
{
    local float     fZoomRatio;
    local string    strZoom;
    local float     RADCurr;
    local float     RADDef;
    local float     xLen, yLen;

    RADCurr = (EStickyCamera(Camera).current_fov / 180.0) * 3.1416;
    RADDef = (90.0 / 180.0) * 3.1416;

    fZoomRatio = tan(RADDef / 2.0) / tan(RADCurr / 2.0);

    if (fZoomRatio < 1.0)
        fZoomRatio = 1.0;

    strZoom = (int(fZoomRatio)$"X");

    Canvas.Font = Font'EHUDFont';
    Canvas.DrawColor = Green;

    Canvas.SetPos(CAM_X + SIDEBAR_WIDTH + 8, TOP_CAM_Y + 8);
    Canvas.DrawText("--");

    Canvas.SetPos(CAM_X + SIDEBAR_WIDTH + TOPBAR_CORNER_X - 21, TOP_CAM_Y + 8);
    Canvas.DrawText("--");

    Canvas.TextSize(strZoom, xLen, yLen);
    Canvas.SetPos(CAM_X + SIDEBAR_WIDTH + (float(TOPBAR_CORNER_X - 1) / 2.0f - xLen / 2.0f), TOP_CAM_Y + 8);
    Canvas.DrawText(strZoom);
}

/*-----------------------------------------------------------------------------
    Function :      DrawDistanceMeter

    Description:    -
-----------------------------------------------------------------------------*/
function DrawDistanceMeter(ECanvas Canvas)
{
    local string strFormattedDistance;
    local int    iDecimal;

    Canvas.Font = Font'EHUDFont';
    Canvas.DrawColor = Green;

    // Only keep 2 numbers after '.'
    strFormattedDistance = String(fDistance / 100.0);
    iDecimal = InStr(strFormattedDistance, ".");
    strFormattedDistance = Left(strFormattedDistance, iDecimal + 3);
    strFormattedDistance = strFormattedDistance $ " M";

    // If trace didnt return anything, just draw a dash.
    if (fDistance <= 0.0)
        strFormattedDistance = "  - ";

    //Canvas.SetPos(SCREEN_END_X - GADGETS_RIGHT + 67, GADGETS_TOP - 3);
    Canvas.SetPos(SCREEN_END_X - CAM_X - SIDEBAR_WIDTH - 7, TOP_CAM_Y + 8);
    Canvas.DrawTextRightAligned(strFormattedDistance);
}



