class ELaserMicView extends EObjectHud;

const SCREEN_X				= 30;
const TOP_SCREEN_Y			= 41;
const BOTTOM_SCREEN_Y		= 37;
const SIDEBAR_WIDTH			= 12;
const TOPBAR_HEIGHT			= 37;
const BOTTOMBAR_HEIGHT		= 24;
const CROSS_WIDTH			= 190;
const CROSS_HEIGHT			= 115;
const CROSS_CENTER			= 51;

var ELaserMic	Mic;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	// get mic
	Mic = ELaserMic(Owner);
	if (Mic == None)
		Log(self$" ERROR : ELaserMicView Owner not a laserMic");
}

function bool Locked()
{
	return Mic.LaserMicTarget != None;
}

state s_Use
{
	function DrawView(HUD Hud, ECanvas Canvas)
	{
		local EPlayerController Epc;
		Epc = EPlayerController(Mic.Controller);

		Canvas.Style = ERenderStyle.STY_Alpha;

        if (Epc.bShowScope && Epc.bShowHUD) // Joshua - Show scope toggle
        {
            DrawNoiseBars(Canvas);
            DrawSideBars(Canvas);
            DrawTopBar(Canvas);
            DrawBottomBar(Canvas);
        }
        if (Epc.bShowCrosshair && Epc.bShowHUD) // Joshua - Show crosshair toggle
            DrawCrosshair(Canvas);

        if (Epc.bShowScope && Epc.bShowHUD) // Joshua - Show scope toggle
            DrawBlackMask(Canvas);	

		Canvas.Style = ERenderStyle.STY_Normal;
	}
}

function DrawCrosshair(ECanvas Canvas)
{
	local EHUD_COLOR color;
	local int iRefX, iRefY;
	local bool bDrawCorner;

	iRefX = 0;
	iRefY = 0;
	bDrawCorner = false;
	
	if (Locked())
	{
		color = EHC_ALPHA_RED;
		bDrawCorner = true;		
	}
	else
		color = EHC_ALPHA_WHITE;

	// Around
	DrawRectangle(SCREEN_HALF_X - CROSS_WIDTH, SCREEN_HALF_Y - CROSS_HEIGHT, SCREEN_HALF_X + CROSS_WIDTH, SCREEN_HALF_Y + CROSS_HEIGHT, 1, EHC_ALPHA_WHITE, Canvas);
	DrawRectangle(SCREEN_HALF_X - CROSS_WIDTH + 2, SCREEN_HALF_Y - CROSS_HEIGHT + 2, SCREEN_HALF_X + CROSS_WIDTH - 2, SCREEN_HALF_Y + CROSS_HEIGHT - 2, 1, EHC_ALPHA_WHITE, Canvas);

	DrawLine(SCREEN_HALF_X - CROSS_WIDTH + 3, SCREEN_HALF_Y - 1, SCREEN_HALF_X - 0.33f * CROSS_WIDTH, SCREEN_HALF_Y + 1, EHC_ALPHA_WHITE, Canvas);
	DrawLine(SCREEN_HALF_X + CROSS_WIDTH - 3, SCREEN_HALF_Y - 1, SCREEN_HALF_X + 0.33f * CROSS_WIDTH, SCREEN_HALF_Y + 1, EHC_ALPHA_WHITE, Canvas);

	// Center
	DrawRectangle(SCREEN_HALF_X - 0.5f * CROSS_CENTER, SCREEN_HALF_Y - 0.5f * CROSS_CENTER, SCREEN_HALF_X + 0.5f * CROSS_CENTER, SCREEN_HALF_Y + 0.5f * CROSS_CENTER, 1, EHC_ALPHA_GREEN, Canvas);
	DrawRectangle(SCREEN_HALF_X - 0.5f * CROSS_CENTER + 1, SCREEN_HALF_Y - 0.5f * CROSS_CENTER + 1, SCREEN_HALF_X + 0.5f * CROSS_CENTER - 1, SCREEN_HALF_Y + 0.5f * CROSS_CENTER - 1, 1, EHC_ALPHA_BLACK, Canvas);
	DrawLine(SCREEN_HALF_X - 0.5f * CROSS_CENTER + 2, SCREEN_HALF_Y - 0.5f * CROSS_CENTER + 2, SCREEN_HALF_X + 0.5f * CROSS_CENTER - 2, SCREEN_HALF_Y + 0.5f * CROSS_CENTER - 2, color, Canvas);

	if (bDrawCorner)
	{
		iRefX = SCREEN_HALF_X - 0.5f * CROSS_CENTER;
		iRefY = SCREEN_HALF_Y - 0.5f * CROSS_CENTER;
		// Draw corners around middle square
		// upper left corner
		DrawLine(iRefX - 10, iRefY - 10, iRefX, iRefY - 9, EHC_ALPHA_RED, Canvas);
		DrawLine(iRefX - 10, iRefY - 9, iRefX - 9, iRefY, EHC_ALPHA_RED, Canvas);
				
		// upper right corner
		DrawLine(iRefX + 10 + CROSS_CENTER, iRefY - 10, iRefX + CROSS_CENTER, iRefY - 9, EHC_ALPHA_RED, Canvas);
		DrawLine(iRefX + 10 + CROSS_CENTER, iRefY - 9, iRefX + 9 + CROSS_CENTER, iRefY, EHC_ALPHA_RED, Canvas);

		// bottom left corner
		DrawLine(iRefX - 10, iRefY + 10 + CROSS_CENTER, iRefX, iRefY + 9 + CROSS_CENTER, EHC_ALPHA_RED, Canvas);
		DrawLine(iRefX - 10, iRefY + 9 + CROSS_CENTER, iRefX - 9, iRefY + CROSS_CENTER, EHC_ALPHA_RED, Canvas);

		// bottom right corner
		DrawLine(iRefX + 10 + CROSS_CENTER, iRefY + 10 + CROSS_CENTER, iRefX + CROSS_CENTER, iRefY + 9 + CROSS_CENTER, EHC_ALPHA_RED, Canvas);
		DrawLine(iRefX + 10 + CROSS_CENTER, iRefY + 9 + CROSS_CENTER, iRefX + 9 + CROSS_CENTER, iRefY + CROSS_CENTER, EHC_ALPHA_RED, Canvas);		
	}
}

function DrawTopBar(ECanvas Canvas)
{
	local int i, j;
	local int u, v;
	local int eqSlot;
	local float value, cValue;
	local float eqStart, eqEnd, eqHalfRange;
	local EHUD_COLOR c;

    DrawRectangle(SCREEN_X + SIDEBAR_WIDTH - 1, TOP_SCREEN_Y, SCREEN_END_X - SCREEN_X - SIDEBAR_WIDTH + 1, TOP_SCREEN_Y + TOPBAR_HEIGHT,
                  1, EHC_BLACK, Canvas);
    DrawRectangle(SCREEN_X + SIDEBAR_WIDTH, TOP_SCREEN_Y + 1, SCREEN_END_X - SCREEN_X - SIDEBAR_WIDTH, TOP_SCREEN_Y + TOPBAR_HEIGHT - 1,
                  1, EHC_GREEN, Canvas);
    DrawLine(SCREEN_X + SIDEBAR_WIDTH + 1, TOP_SCREEN_Y + 2, SCREEN_END_X - SCREEN_X - SIDEBAR_WIDTH - 1, TOP_SCREEN_Y + TOPBAR_HEIGHT - 2, 
			 EHC_ALPHA_GREEN, Canvas);

	// Sound equalizer
	eqStart		= 4.f * SCREEN_X;
	eqEnd		= SCREEN_END_X - 4.f * SCREEN_X;
	eqHalfRange = (eqEnd - eqStart) / 2.f;

	for (i = 0; i < eqEnd - eqStart; i += 6)
	{
		value = 6.f * (1 - Abs((eqHalfRange - i) / eqHalfRange));
		value -= 6.f * FRand();
		value = Clamp(value, 0, 5.5);
		
		for (j = 0; j < 6; j++)
		{
			u = eqStart + i;
			v = TOP_SCREEN_Y + 8 + 4 * j;
			cValue = Value / (6 - j);

			if (cValue < 0.2f || Value < j || !Locked())
				c = EHC_ALPHA_BLACK;
			else				
				c = EHC_ALPHA_GREEN;

			DrawLine(u, v, u + 4, v + 2, c, Canvas);
		}
	}


}

function DrawBottomBar(ECanvas Canvas)
{
    local string text;
	local float xLen, yLen;
	local float textY;

    // Joshua - Zoom functionality
    local float     fZoomRatio;
    local string    strZoom;
    local float     RADCurr;
    local float     RADDef;
    local EPlayerController Epc;

    DrawRectangle(SCREEN_X + SIDEBAR_WIDTH - 1, SCREEN_END_Y - BOTTOM_SCREEN_Y - BOTTOMBAR_HEIGHT, SCREEN_END_X - SCREEN_X - SIDEBAR_WIDTH + 1, SCREEN_END_Y - BOTTOM_SCREEN_Y,
                  1, EHC_BLACK, Canvas);
    DrawRectangle(SCREEN_X + SIDEBAR_WIDTH, SCREEN_END_Y - BOTTOM_SCREEN_Y - BOTTOMBAR_HEIGHT + 1, SCREEN_END_X - SCREEN_X - SIDEBAR_WIDTH, SCREEN_END_Y - BOTTOM_SCREEN_Y - 1,
                  1, EHC_GREEN, Canvas);
    DrawLine(SCREEN_X + SIDEBAR_WIDTH + 1, SCREEN_END_Y - BOTTOM_SCREEN_Y - BOTTOMBAR_HEIGHT + 2, SCREEN_END_X - SCREEN_X - SIDEBAR_WIDTH - 1, SCREEN_END_Y - BOTTOM_SCREEN_Y - 2, 
		     EHC_ALPHA_GREEN, Canvas);

    Canvas.Font = Font'EHUDFont';
    Canvas.DrawColor = Black;	

	// ZOOM
    // Joshua - Zoom functionality
    Epc = EPlayerController(Mic.Controller);
    if (Epc.bLaserMicZoomLevels)
    {
        RADCurr = (Mic.current_fov / 180.0) * 3.1416;
        RADDef = (90.0 / 180.0) * 3.1416;
        fZoomRatio = tan(RADDef / 2.0) / tan(RADCurr / 2.0);
        if (fZoomRatio < 1.0)
            fZoomRatio = 1.0;
        strZoom = Localize("HUD", "LaserMicZoom", "Localization\\Enhanced") @ int(fZoomRatio)$"X";

        Canvas.TextSize(strZoom, xLen, yLen);
        textY = SCREEN_END_Y - BOTTOM_SCREEN_Y - 0.5f * (BOTTOMBAR_HEIGHT + yLen);
        Canvas.SetPos(SCREEN_X + SIDEBAR_WIDTH + 8, textY);
        Canvas.DrawText(strZoom);
    }
    else
    {
        text = Canvas.LocalizeStr("ZOOM_4X");
        Canvas.TextSize(text, xLen, yLen);
        textY = SCREEN_END_Y - BOTTOM_SCREEN_Y - 0.5f * (BOTTOMBAR_HEIGHT + yLen);
        Canvas.SetPos(SCREEN_X + SIDEBAR_WIDTH + 8, textY);
        Canvas.DrawText(text);
    }

	text = "" $ VSize(EPlayerController(Mic.controller).m_targetLocation - Mic.Location) / 100 $ " M";
	Canvas.TextSize(text, xLen, yLen);
	textY = SCREEN_END_Y - BOTTOM_SCREEN_Y - 0.5f * (BOTTOMBAR_HEIGHT + yLen);
    Canvas.SetPos(SCREEN_END_X - SIDEBAR_WIDTH - 40 - xLen, textY);
    Canvas.DrawText(text);

	// Text
	if (Locked())
	{
		text = Canvas.LocalizeStr("DECODING");
		Canvas.TextSize(text, xLen, yLen);
		Canvas.SetPos(SCREEN_HALF_X - 0.5f * xLen, textY);
		Canvas.DrawText(text);
	}
	else
	{
		text = Canvas.LocalizeStr("SEARCHING");
		Canvas.TextSize(text, xLen, yLen);
		Canvas.SetPos(SCREEN_HALF_X - 0.5f * xLen, textY);
		Canvas.DrawText(text);
	}
}

function DrawSideBars(ECanvas Canvas)
{
    local int iCurrPos;

    Canvas.DrawColor = White;

    // Left Fill //
    for (iCurrPos = TOP_SCREEN_Y + 2; iCurrPos < SCREEN_END_Y - BOTTOM_SCREEN_Y; iCurrPos += 6)
    {
        Canvas.SetPos(SCREEN_X + 2, iCurrPos);
        eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_fond_ligne, SIDEBAR_WIDTH - 4, 6, 0, 0, 1, 6);
    }

    // Right Fill //
    for (iCurrPos = TOP_SCREEN_Y + 2; iCurrPos < SCREEN_END_Y - BOTTOM_SCREEN_Y; iCurrPos += 6)
    {
        Canvas.SetPos(SCREEN_END_X - SCREEN_X - SIDEBAR_WIDTH + 2, iCurrPos);
        eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_fond_ligne, SIDEBAR_WIDTH - 4, 6, 0, 0, 1, 6);
    }

    // Left Bar Border //
    DrawRectangle(SCREEN_X    , TOP_SCREEN_Y    , SCREEN_X + SIDEBAR_WIDTH    , SCREEN_END_Y - BOTTOM_SCREEN_Y    , 1, EHC_BLACK, Canvas);
    DrawRectangle(SCREEN_X + 1, TOP_SCREEN_Y + 1, SCREEN_X + SIDEBAR_WIDTH - 1, SCREEN_END_Y - BOTTOM_SCREEN_Y - 1, 1, EHC_GREEN, Canvas);

    // Left Bar Border //
    DrawRectangle(SCREEN_END_X - SCREEN_X - SIDEBAR_WIDTH    , TOP_SCREEN_Y    , SCREEN_END_X - SCREEN_X    , SCREEN_END_Y - BOTTOM_SCREEN_Y    , 1, EHC_BLACK, Canvas);
    DrawRectangle(SCREEN_END_X - SCREEN_X - SIDEBAR_WIDTH + 1, TOP_SCREEN_Y + 1, SCREEN_END_X - SCREEN_X - 1, SCREEN_END_Y - BOTTOM_SCREEN_Y - 1, 1, EHC_GREEN, Canvas);
}

function DrawNoiseBars(ECanvas Canvas)
{
    local float pRotation;
    local int position;
    local int qPos, rPos, yPos;
    local string szFirstDir, szSecondDir;
    local int p1, p2;

    yPos = SCREEN_END_Y - BOTTOM_SCREEN_Y - BOTTOMBAR_HEIGHT - 6;

    pRotation = float(Mic.Controller.Rotation.Yaw & 65535) / 65535.0;

    // Hack for Defense Ministry
    // Joshua - This shifts the compass by 90 degrees so the East Wing of the map point towards East on the binoculars
	if (left(GetCurrentMapName(), 3) == "1_2")
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
    DrawNoiseBar(SCREEN_X + SIDEBAR_WIDTH               , yPos - 4, 
                 SCREEN_END_X - SCREEN_X - SIDEBAR_WIDTH, yPos, 
                 rPos % 126, Canvas);
    DrawNoiseBar(SCREEN_X + SIDEBAR_WIDTH               , yPos + 2, 
                 SCREEN_END_X - SCREEN_X - SIDEBAR_WIDTH, yPos + 6, 
                 -rPos % 126, Canvas);    
}

function DrawNoiseBar(int AX, int AY, int BX, int BY, int OffsetX, ECanvas Canvas)
{
    Canvas.DrawColor = White;

    Canvas.SetPos(AX, AY);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_anim_border, 630, abs(BY - AY), OffsetX, 0, 630, 4); 
}

function DrawBlackMask(ECanvas Canvas)
{
    // TOP //
    DrawLine(0, 0, SCREEN_END_X, TOP_SCREEN_Y, EHC_BLACK, Canvas);
    // BOTTOM //
    DrawLine(0, SCREEN_END_Y - BOTTOM_SCREEN_Y, SCREEN_END_X, SCREEN_END_Y, EHC_BLACK, Canvas);
    // LEFT //
    DrawLine(0, TOP_SCREEN_Y, SCREEN_X, SCREEN_END_Y - BOTTOM_SCREEN_Y, EHC_BLACK, Canvas);
    // RIGHT //
    DrawLine(SCREEN_END_X - SCREEN_X, TOP_SCREEN_Y, SCREEN_END_X, SCREEN_END_Y - BOTTOM_SCREEN_Y, EHC_BLACK, Canvas);
}
