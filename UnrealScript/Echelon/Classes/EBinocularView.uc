/******************************************************************************

 Class:         EBinocularView

 Description:   Goggle Binocular

 Reference:     -


******************************************************************************/
class EBinocularView extends EObjectHud;

var color	HUDColor, NewTextColor;
var color	GreenColor;
var color	BrightGreenColor;
var color   ColorObjectHUD; // SCPT LevelInfo
var color   ColorTextHUD; // SCPT LevelInfo
var color   Green, Gray;

// Green Ring const's
const GREEN_BORDER_TEXURE_SIZE_X    = 188;
const GREEN_BORDER_TEXURE_SIZE_Y    = 240;

// Noise Bars const's
const NOISE_BARS_VERT_DIST          = 185;
const NOISE_BARS_HORIZ_SIZE         = 400;
//const NOISE_BARS_MAX_SPEED          = 100.0;

state s_Zooming
{
	function DrawView(HUD hud, ECanvas Canvas)
	{
        local EPlayerController Epc;
        Epc = EAbstractGoggle(owner).Epc;

        if (Epc.bShowHUD && Epc.bShowScope)
        {
            DrawNoiseBars(Canvas);
            //DrawUpDownPad(Canvas);
            DrawDistanceMeter(Canvas);
            DrawZoomMeter(Canvas);
            DrawGreenRing(Canvas);
        }
	}
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	HUDColor = ColorObjectHUD;
	NewTextColor = ColorTextHUD;
}

//------------------------------------------------------------------------
// Description
//
//------------------------------------------------------------------------
function DrawNoiseBars(ECanvas Canvas)
{
    local float pRotation;
    local int position;
    local int qPos, rPos;
    local string szFirstDir, szSecondDir;
    local int p1, p2;

    pRotation = float(EAbstractGoggle(Owner).Epc.Rotation.Yaw & 65535) / 65535.0;

    // Hack for Defense Ministry
    // Joshua - This shifts the compass by 90 degrees so the East Wing of the map point towards East on the binoculars
	if (left(GetCurrentMapName(), 3) == "1_2")
		pRotation += 0.25;
	if (pRotation >= 1.0)
		pRotation -= 1.0;

	position = pRotation * 600;

    qPos = position / 75;
    rPos = position % 75;

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

	Canvas.Style = ERenderStyle.STY_Alpha;

    // Draw Compas Coordinates //
    Canvas.Font = Font'EHUDFont';
    Canvas.SetDrawColor(38, 81, 50);
	Canvas.DrawColor = NewTextColor;

    Canvas.SetPos(SCREEN_HALF_X - rPos - 8, SCREEN_HALF_Y - 14);
    //Canvas.DrawText("["$szFirstDir$"]");
	if ( rPos < 37 - 10)
		Canvas.DrawTextAligned(szFirstDir, TXT_CENTER);

	/*
    Canvas.SetPos(SCREEN_HALF_X - rPos + p1, SCREEN_HALF_Y + NOISE_BARS_VERT_DIST - 11);
    Canvas.DrawText(".");
    Canvas.SetPos(SCREEN_HALF_X - rPos + p1, SCREEN_HALF_Y + NOISE_BARS_VERT_DIST - 10);
    Canvas.DrawText(".");
	*/

    Canvas.SetPos(SCREEN_HALF_X + (75 - rPos) - 8, SCREEN_HALF_Y - 14);
    //Canvas.DrawText("["$szSecondDir$"]");
	if (rPos > 37 - 10)
		Canvas.DrawTextAligned(szSecondDir,TXT_CENTER);

	/*
    Canvas.SetPos(SCREEN_HALF_X + (630 - rPos) + p2, SCREEN_HALF_Y + NOISE_BARS_VERT_DIST-11);
    Canvas.DrawText(".");
    Canvas.SetPos(SCREEN_HALF_X + (630 - rPos) + p2, SCREEN_HALF_Y + NOISE_BARS_VERT_DIST-10);
    Canvas.DrawText(".");
	*/

    // Draw noise bars //
    DrawNoiseBar(25 - rPos % 25, Canvas);
}

//------------------------------------------------------------------------
// Description
//
//------------------------------------------------------------------------
function DrawNoiseBar(int OffsetX, ECanvas Canvas)
{
	local int xPos, yPos, width, height, i;

	xPos = 286;
	yPos = 238;
	width = 25;
	height = 11;

	Canvas.Style = ERenderStyle.STY_Alpha;
	Canvas.DrawLine(125, 240, 153, 2, NewTextColor, 128, eLevel.TGAME);
	Canvas.DrawLine(371, 240, 153, 2, NewTextColor, 128, eLevel.TGAME);

	Canvas.SetDrawColor(128, 128, 128, 256); // 256 opacity?
	Canvas.DrawColor = HUDColor;
	Canvas.SetPos(xPos, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.bino_bousole,
		OffsetX, height, width - OffsetX, 0, OffsetX, height);

	for (i = 0; i < 2; i++)
	{
		Canvas.SetPos(xPos + OffsetX + i * width, yPos);
		eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.bino_bousole,
			width, height, 0, 0, width, height);
	}

	//
	Canvas.SetPos(xPos + OffsetX + 2*width, yPos );
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.bino_bousole,
		width - OffsetX, height, 0, 0, width - OffsetX, height);

	//
	if (OffsetX == 0)
	{
		Canvas.SetPos(xPos + OffsetX + 3 * width, yPos);
		eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.bino_bousole,
			5, height, 0, 0, 5, height);
	}

	Canvas.Style = ERenderStyle.STY_Normal;
}

//------------------------------------------------------------------------
// Description
//
//------------------------------------------------------------------------
function DrawDistanceMeter(ECanvas Canvas)
{
    local   string  strFormattedDistance;
    local   string  strOutput;
    local   int     iDecimal;
	local	float   fDistDistance;
	local	EPlayerController Epc;

	//DrawLine(96, 0, 546, 45, EHC_ALPHA_GREEN, Canvas);
	//Canvas.DrawLine(50, 0, 540, 80, green, 64, elevel.TGAME);
	Canvas.SetDrawColor(128, 128, 128, 256); // 256 opacity?
	Canvas.DrawColor = NewTextColor;
	Canvas.SetPos(213, 256);
	Canvas.Style = ERenderStyle.STY_Alpha;
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.bino_distance, eLevel.TGAME.GetWidth(eLevel.TGAME.bino_distance),
			eLevel.TGAME.GetHeight(eLevel.TGAME.bino_distance), 0, 0, eLevel.TGAME.GetWidth(eLevel.TGAME.bino_distance),
			eLevel.TGAME.GetHeight(eLevel.TGAME.bino_distance));
	Canvas.DrawLine(324, 258, 2, 5, NewTextColor, 128, eLevel.TGAME);
	Canvas.DrawLine(324, 267, 2, 7, NewTextColor, 128, eLevel.TGAME);
	Canvas.DrawLine(324, 278, 2, 13, NewTextColor, 128, eLevel.TGAME);
	Canvas.DrawLine(324, 295, 2, 100, NewTextColor, 128, eLevel.TGAME);
	Canvas.Style = ERenderStyle.STY_Normal;

	Epc = EAbstractGoggle(Owner).Epc;

    // Fill
    Canvas.SetDrawColor(128, 128, 128);
	Canvas.Style = ERenderStyle.STY_Alpha;

    // Draw Distance
    Canvas.Font = Font'EHUDFont';
    Canvas.DrawColor = NewTextColor;

    // Only keep 4 numbers + '.'
	fDistDistance = VSize(Epc.m_targetLocation - Epc.Location);
    strFormattedDistance = string (fDistDistance / 100.0);
    iDecimal = InStr(strFormattedDistance, ".");
    strFormattedDistance = left(strFormattedDistance, iDecimal + 3);
    strFormattedDistance = strFormattedDistance $ "M";

    // If trace didnt return anything, just draw a dash.
    if (fDistDistance == 0.0 || Epc.m_targetActor == None)
    {
        strFormattedDistance = "  - "; // Joshua - 2 spaces then 1 space?
    }

    Canvas.SetPos(385, 300); // 375
    Canvas.DrawTextRightAligned(strFormattedDistance);
	Canvas.Style = ERenderStyle.STY_Normal;
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
	local int		xPos[5], yPos[5], iZoom;

	xPos[0] = 213;
	yPos[0] = 307;
	xPos[1] = 237;
	yPos[1] = 305;
	xPos[2] = 263;
	yPos[2] = 298;
	xPos[3] = 289;
	yPos[3] = 287;
	xPos[4] = 310;
	yPos[4] = 264;

    RADCurr = (EAbstractGoggle(Owner).current_fov / 180.0) * 3.1416;
    RADDef = (90.0/180.0) * 3.1416;

    fZoomRatio = tan(RADDef / 2.0) / tan(RADCurr / 2.0);

    if (fZoomRatio < 1.0)
        fZoomRatio = 1.0;
	else if (fZoomRatio > 5.0)
		fZoomRatio = 5.0;

	iZoom = int(fZoomRatio);

	Canvas.Style = ERenderStyle.STY_Alpha;
	Canvas.DrawLine(xPos[iZoom - 1], yPos[iZoom - 1], 3, 3, BrightGreenColor, 200, eLevel.TGAME);
	Canvas.Style = ERenderStyle.STY_Normal;

	/*
    strZoom = (int(fZoomRatio)$"X");

    Canvas.Font = Font'ETextFont';
    Canvas.DrawColor = Green;

    Canvas.TextSize(strZoom, xLen, yLen);
    Canvas.SetPos(150 + (25.0f - xLen/2.0f), 44);
    Canvas.DrawText(strZoom);
	*/
}

/*
function DrawUpDownPad(ECanvas Canvas)
{
	local float StrLen1, StrLen2, StrLen3, StrLen4, yLen, xPos, Length, yPos;

	Canvas.Style = ERenderStyle.STY_Normal;

	Canvas.DrawLine(50, 400, 540, 80, green, 64, eLevel.TGAME);
	Canvas.Font = Font'ETextFont';
	Canvas.DrawColor = ColorTextHUD;

	Canvas.TextSize(Canvas.LocalizeStr("ZoomPlus"), StrLen1, yLen);
	Canvas.TextSize(Canvas.LocalizeStr("ZoomMinus"), StrLen2, yLen);
	Canvas.TextSize(GetLocKeyNameByActionKey("ZoomIn"), StrLen3, yLen);
	Canvas.TextSize(GetLocKeyNameByActionKey("ZoomOut"), StrLen4, yLen);

	Length = Max(StrLen1,StrLen2) + Max(StrLen3,StrLen4) + 30;

	yPos = 405;
	Canvas.SetPos(300 - StrLen1, yPos);
	Canvas.DrawTextAligned(Canvas.LocalizeStr("ZoomPlus"), TXT_LEFT);
	Canvas.SetPos(340, yPos);
	Canvas.DrawTextAligned(GetLocKeyNameByActionKey("ZoomIn"), TXT_LEFT);


	yPos += 15;
	Canvas.SetPos(300 - StrLen1, yPos);
	Canvas.DrawTextAligned(Canvas.LocalizeStr("ZoomMinus"), TXT_LEFT);
	Canvas.SetPos(340, yPos);
	Canvas.DrawTextAligned(GetLocKeyNameByActionKey("ZoomOut"), TXT_LEFT );
}

// GetLocKeyNameByActionKey: Get the localization name of the key to display
function string GetLocKeyNameByActionKey( string _szActionKey)
{
	local EPlayerController	Epc;
    local ECanvas C;
    local string szTemp;
	local byte Key;

    Epc = EAbstractGoggle(Owner).Epc;
    C = ECanvas(class'Actor'.static.GetCanvas());
	Key = Epc.GetKey(_szActionKey, false);
	szTemp = Epc.GetEnumName(Key);

	//szTemp = Epc.Player.GUIController.ConvertKeyToLocalisation( Key, szTemp);

    // This will not work because EPCConsole is in EchelonMenus
    if (C.Viewport != None && C.Viewport.Console != None)
    {
        szTemp = EPCConsole(C.Viewport.Console).ConvertKeyToLocalisation(Key, szTemp);
    }

	return szTemp;
}
*/

function DrawGreenRing(ECanvas Canvas, optional color textureColor)
{
    local color ZeroColor; // Joshua - Converted to local

	Canvas.Style = ERenderStyle.STY_Alpha;
    
	if (textureColor != ZeroColor)
		Canvas.DrawColor = textureColor;
	else
		Canvas.DrawColor = ColorObjectHUD;

	Canvas.SetPos(0,0);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.border_binocular, GREEN_BORDER_TEXURE_SIZE_X ,GREEN_BORDER_TEXURE_SIZE_Y, 0, 0, eLevel.TGAME.GetWidth(eLevel.TGAME.border_binocular),  eLevel.TGAME.GetHeight(eLevel.TGAME.border_binocular));

	Canvas.SetPos(0, SCREEN_END_Y - GREEN_BORDER_TEXURE_SIZE_Y);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.border_binocular, GREEN_BORDER_TEXURE_SIZE_X ,GREEN_BORDER_TEXURE_SIZE_Y, 0, eLevel.TGAME.GetHeight(eLevel.TGAME.border_binocular), eLevel.TGAME.GetWidth(eLevel.TGAME.border_binocular),  -eLevel.TGAME.GetHeight(eLevel.TGAME.border_binocular));

	Canvas.SetPos(SCREEN_END_X - GREEN_BORDER_TEXURE_SIZE_X, 0);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.border_binocular, GREEN_BORDER_TEXURE_SIZE_X ,GREEN_BORDER_TEXURE_SIZE_Y, eLevel.TGAME.GetWidth(eLevel.TGAME.border_binocular), 0, -eLevel.TGAME.GetWidth(eLevel.TGAME.border_binocular),  eLevel.TGAME.GetHeight(eLevel.TGAME.border_binocular));

	Canvas.SetPos(SCREEN_END_X - GREEN_BORDER_TEXURE_SIZE_X, SCREEN_END_Y - GREEN_BORDER_TEXURE_SIZE_Y);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.border_binocular, GREEN_BORDER_TEXURE_SIZE_X ,GREEN_BORDER_TEXURE_SIZE_Y, eLevel.TGAME.GetWidth(eLevel.TGAME.border_binocular), eLevel.TGAME.GetHeight(eLevel.TGAME.border_binocular), -eLevel.TGAME.GetWidth(eLevel.TGAME.border_binocular),  -eLevel.TGAME.GetHeight(eLevel.TGAME.border_binocular));

	Canvas.Style = ERenderStyle.STY_Normal;
}

defaultproperties
{
    GreenColor=(R=61,G=82,B=47,A=0)
    BrightGreenColor=(R=70,G=90,B=55,A=0)
    ColorTextHUD=(R=73,G=85,B=66,A=255)
    ColorObjectHUD=(R=48,G=59,B=45,A=255)
    Green=(R=38,G=81,B=50,A=255)
    Gray=(R=80,G=80,B=80,A=255)
}
