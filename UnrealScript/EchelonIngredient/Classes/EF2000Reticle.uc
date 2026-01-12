/******************************************************************************

 Class:         EF2000Reticle

 Description:   -

 Reference:     -


******************************************************************************/
class EF2000Reticle extends EWeaponReticle;

/*-----------------------------------------------------------------------------
                      T Y P E   D E F I N I T I O N S
-----------------------------------------------------------------------------*/
// General screen Stuff
const   SCREEN_HALF_X               = 319;
const   SCREEN_HALF_Y               = 239;

// Stems const's
const STEMS_NORTH_START             = 0;
const STEMS_VERT_1ST_STOP           = 124;
const STEMS_VERT_END                = 192;

const STEMS_HORIZ_START             = 44;
const STEMS_HORIZ_1ST_STOP          = 176;
const STEMS_HORIZ_END               = 266;

const STEMS_DIST_BOX_START          = 61;
const STEMS_DIST_BOX_END            = 138;

const STEMS_QUICK_INV_START         = 50;
const STEMS_QUICK_INV_END           = 94;

// Distance Meter const's
const DIST_METER_START              = 138;
const DIST_METER_END                = 61;
const DIST_METER_VERT_SIZE          = 10;

// CrossHair const's
const CROSSHAIR_CORNERS_DIST           = 17;
const CROSSHAIR_CORNERS_LINE_LENGTH    = 12;
const CROSSHAIR_WIDTH                  = 17;    // Must be an odd number //
const CROSSHAIR_HEIGHT                 = 17;    // Must be an odd number //

const CROSSHAIR_WIDTH_SMALL            = 11;    // Must be an odd number //
const CROSSHAIR_HEIGHT_SMALL           = 11;    // Must be an odd number //


const MAX_CROSSHAIR_DEP_X              = 6;
const MAX_CROSSHAIR_DEP_Y              = 8;
const TIMERVALUE                    = 0.05;

// Noise Bars const's
const NOISE_BARS_VERT_DIST          = 200;
const NOISE_BARS_HORIZ_SIZE         = 400;
const NOISE_BARS_MAX_SPEED          = 100.0;

// Quick Inv. const's
const QUICK_INV_LEFT    = 277;
const QUICK_INV_TOP     = 386;
const QUICK_INV_RIGHT   = 362;
const QUICK_INV_BOTTOM  = 430;

// Green Ring const's
const GREEN_BORDER_TEXURE_SIZE_X    = 188;
const GREEN_BORDER_TEXURE_SIZE_Y    = 240;
const GREEN_BORDER_CORNER_X         = 177;
const GREEN_BORDER_CORNER_Y         = 125;
const GREEN_BORDER_CORNER_LENGTH    = 72;
const GREEN_BORDER_CORNER_HEIGHT    = 55;
const GREEN_BORDER_CORNER2_LENGTH   = 10;

// Crosshair Related //
const NB_TURN_VALUE   = 5;
const DELTA_TURN_AVERAGE = 600.0f;
const DELTA_LOOKUP_AVERAGE = 400.0f;

// Fatigue Related
const FATIGUEOFFSETX = 30;
const FATIGUEOFFSETY = 30;
const FATIGUEWIDTH = 20;
const FATIGUEHEIGHT = 70;
const FATIGUETHICK = 1;
const FATIGUEBARTHICK = 2;

/*-----------------------------------------------------------------------------
                        M E M B E R   V A R I A B L E S
-----------------------------------------------------------------------------*/

var EF2000			F2000;

// Distance Meter Related
var float           fDistDistance;
/*
// Crosshair Ralated //
var float           fTurn[NB_TURN_VALUE];
var float           fLookUp[NB_TURN_VALUE];
*/
var bool			bBlinkOff;

var color           green, gray;

/*-----------------------------------------------------------------------------
                                M E T H O D S
-----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
 Function:      PostBeginPlay

 Description:   -
-----------------------------------------------------------------------------*/
function PostBeginPlay()
{
    Super.PostBeginPlay();
	F2000 = EF2000(Weapon);
}

/*-----------------------------------------------------------------------------
 Function:      GetCrosshairMire

 Description:   Joshua - Returns the appropriate crosshair texture index based on
                the player's crosshair style preference
-----------------------------------------------------------------------------*/
function int GetCrosshairMire()
{
	switch (Epc.CrosshairStyle)
	{
        case CS_Beta:
            return eLevel.TGAME.svf2_mire_beta;
		case CS_PS2:
			return eLevel.TGAME.svf2_mire_PS2;
		case CS_PS3:
			return eLevel.TGAME.svf2_mire_PS3;
		case CS_SCCT:
			return eLevel.TGAME.svf2_mire_SCCT;
		default:
			return eLevel.TGAME.svf2_mire;
	}
}

/*-----------------------------------------------------------------------------
 Function:      GetCrosshairMireFond

 Description:   Joshua - Returns the appropriate crosshair background texture index
                based on the player's crosshair style preference
-----------------------------------------------------------------------------*/
function int GetCrosshairMireFond()
{
	switch (Epc.CrosshairStyle)
	{
		case CS_Beta:
			return eLevel.TGAME.svf2_mire_fond_beta;
		case CS_PS2:
			return eLevel.TGAME.svf2_mire_fond_PS2;
		case CS_PS3:
			return eLevel.TGAME.svf2_mire_fond_PS3;
		case CS_SCCT:
			return eLevel.TGAME.svf2_mire_fond_SCCT;
		default:
			return eLevel.TGAME.svf2_mire_fond;
	}
}

/*-----------------------------------------------------------------------------
 Function:      GetPistolMireTopBas

 Description:   Joshua - Returns the appropriate pistol crosshair top/bottom texture
                index based on the player's crosshair style preference
-----------------------------------------------------------------------------*/
function int GetPistolMireTopBas()
{
	switch (Epc.CrosshairStyle)
	{
		case CS_Beta:
			return eLevel.TGAME.pi_mire_top_bas_beta;
		case CS_PS2:
			return eLevel.TGAME.pi_mire_top_bas_PS2;
		case CS_PS3:
			return eLevel.TGAME.pi_mire_top_bas_PS3;
		case CS_SCCT:
			return eLevel.TGAME.pi_mire_top_bas_SCCT;
		default:
			return eLevel.TGAME.pi_mire_top_bas;
	}
}

/*-----------------------------------------------------------------------------
 Function:      GetPistolFondMire

 Description:   Joshua - Returns the appropriate pistol crosshair background texture
                index based on the player's crosshair style preference
-----------------------------------------------------------------------------*/
function int GetPistolFondMire()
{
	switch (Epc.CrosshairStyle)
	{
		case CS_Beta:
			return eLevel.TGAME.pi_fond_mire_beta;
		case CS_PS2:
			return eLevel.TGAME.pi_fond_mire_PS2;
		case CS_PS3:
			return eLevel.TGAME.pi_fond_mire_PS3;
		case CS_SCCT:
			return eLevel.TGAME.pi_fond_mire_SCCT;
		default:
			return eLevel.TGAME.pi_fond_mire;
	}
}

/*-----------------------------------------------------------------------------
 Function:      GetPistolMireCote

 Description:   Joshua - Returns the appropriate pistol crosshair side texture
                index based on the player's crosshair style preference
-----------------------------------------------------------------------------*/
function int GetPistolMireCote()
{
	switch (Epc.CrosshairStyle)
	{
		case CS_Beta:
			return eLevel.TGAME.pi_mire_cote_beta;
		case CS_PS2:
			return eLevel.TGAME.pi_mire_cote_PS2;
		case CS_PS3:
			return eLevel.TGAME.pi_mire_cote_PS3;
		case CS_SCCT:
			return eLevel.TGAME.pi_mire_cote_SCCT;
		default:
			return eLevel.TGAME.pi_mire_cote;
	}
}

/*-----------------------------------------------------------------------------
 Function:      PostBeginPlay

 Description:   -

 Be carefull so that any state ObjectHudTick are not declared in SuperClasses
-----------------------------------------------------------------------------*/
function ObjectHudTick(float DeltaTime)
{
    local int               i;

    if (Epc.m_useTarget)
    {
/*
        // Update Direction //
        for (i = NB_TURN_VALUE - 1; i > 0; i--)
            fTurn[i] = fTurn[i - 1];
        fTurn[0] = Epc.Rotation.Yaw;

        for (i = NB_TURN_VALUE - 1; i > 0; i--)
            fLookUp[i] = fLookUp[i - 1];
        fLookUp[0] = Epc.Rotation.Pitch;
*/
        // Update Target in sniper mode //
        if (F2000 != None && F2000.bSniperMode)
        {
			if (Epc.m_targetActor != None)
			{
				fDistDistance = VSize(Epc.m_targetLocation - Epc.Location);

				if (Epc.m_targetActor.bIsPawn && !EPawn(Epc.m_targetActor).bHostile)
					chStyle = CH_NONHOSTILE;
				else
					chStyle = CH_NONE;
			}
			else
			{
				fDistDistance = 0.0;
				chStyle = CH_NONE;
			}
        }

		// Joshua - SCPT zoom flash cycle animation
		if (F2000 != None && F2000.bStartFirstFlashCycle)
		{
			F2000.fCycleFlashTime += DeltaTime;
			if (F2000.fCycleFlashTime >= F2000.fCycleFlashDuration)
			{
				F2000.fCycleFlashTime = F2000.fCycleFlashDuration;
				F2000.bStartFirstFlashCycle = false;
			}
		}
		if (F2000 != None && F2000.bStartSecondFlashCycle)
		{
			F2000.fCycleFlashTime -= DeltaTime;
			if (F2000.fCycleFlashTime <= 0.0)
			{
				F2000.fCycleFlashTime = 0.0;
				F2000.bStartSecondFlashCycle = false;
			}
		}
    }
}

//------------------------------------------------------------------------
// Description
//------------------------------------------------------------------------
state s_Selected
{
	function ObjectHudTick(float DeltaTime)
	{
		Global.ObjectHudTick(DeltaTime);
        Super.ObjectHudTick(DeltaTime);
	}
}

state s_Blinking
{
	function BeginState()
	{
		SetTimer(0.2, true);
		bBlinkOff = true;
	}

	function EndState()
	{
		SetTimer(0.0, false);
		bBlinkOff = false;
	}

    function Timer()
    {
		bBlinkOff = !bBlinkOff;
		if (F2000 == None && !F2000.bSniperMode)
			GotoState('s_Selected');
    }
}

state s_Reloading
{
}

function DrawView(HUD Hud, ECanvas Canvas)
{
	Super.DrawView(Hud, Canvas);

	if (F2000 != None && F2000.bSniperMode && Epc.bShowScope && Epc.bShowHUD) // Joshua - Show scope toggle
	{
        DrawDistanceMeter(Canvas);
        DrawQuickInv(Canvas);
        DrawFlashCycle(Canvas); // Joshua - SCPT zoom flash cycle animation
		DrawStems(Canvas);
        DrawNoiseBars(Canvas);
        DrawGreenRing(Canvas);
        DrawSniperMask(Canvas);
		if (F2000.Sn != None)
			DrawFatigueMeter(Canvas, F2000.Sn.fatigueLevel);
	}
}

function DrawFatigueMeter(ECanvas Canvas, float fatigueLevel)
{
    // Fill
    Canvas.SetDrawColor(128, 128, 128);
	Canvas.Style = ERenderStyle.STY_Alpha;

	DrawLine(0 + DIST_METER_END + 1, SCREEN_HALF_Y - DIST_METER_VERT_SIZE + 1,
             0 + DIST_METER_START - 1  , SCREEN_HALF_Y + DIST_METER_VERT_SIZE    , EHC_ALPHA_GREEN, Canvas);

	DrawLine(0 + DIST_METER_END + 1 + 1, SCREEN_HALF_Y - DIST_METER_VERT_SIZE + 1,
             0 + DIST_METER_START - 1 - int(fatigueLevel * float(DIST_METER_START - DIST_METER_END)), SCREEN_HALF_Y + DIST_METER_VERT_SIZE, EHC_GREEN_PALE, Canvas);

    DrawRectangle(0 + DIST_METER_END    , SCREEN_HALF_Y - DIST_METER_VERT_SIZE    , 0 + DIST_METER_START    , SCREEN_HALF_Y + 1 + DIST_METER_VERT_SIZE, 1, EHC_GREEN, Canvas);
    DrawRectangle(0 + DIST_METER_END - 1, SCREEN_HALF_Y - DIST_METER_VERT_SIZE + 1, 0 + DIST_METER_START + 1, SCREEN_HALF_Y + DIST_METER_VERT_SIZE    , 1, EHC_BLACK, Canvas);

	Canvas.SetDrawColor(128, 128, 128);
	Canvas.Style = ERenderStyle.STY_Normal;
}


//------------------------------------------------------------------------
// Description
//
//------------------------------------------------------------------------
function DrawGreenRing(ECanvas Canvas)
{
	// (Yanick Mimee) July-04-2002
	// Green border
	Canvas.Style = ERenderStyle.STY_Alpha;
	Canvas.SetDrawColor(128, 128, 128);

    Canvas.SetPos(0,0);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_border, GREEN_BORDER_TEXURE_SIZE_X ,GREEN_BORDER_TEXURE_SIZE_Y, 0, 0, GREEN_BORDER_TEXURE_SIZE_X, GREEN_BORDER_TEXURE_SIZE_Y);

    Canvas.SetPos(0, SCREEN_END_Y - GREEN_BORDER_TEXURE_SIZE_Y);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_border, GREEN_BORDER_TEXURE_SIZE_X ,GREEN_BORDER_TEXURE_SIZE_Y, 0, GREEN_BORDER_TEXURE_SIZE_Y, GREEN_BORDER_TEXURE_SIZE_X, -GREEN_BORDER_TEXURE_SIZE_Y);

    Canvas.SetPos(SCREEN_END_X - GREEN_BORDER_TEXURE_SIZE_X, 0);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_border, GREEN_BORDER_TEXURE_SIZE_X ,GREEN_BORDER_TEXURE_SIZE_Y, GREEN_BORDER_TEXURE_SIZE_X, 0, -GREEN_BORDER_TEXURE_SIZE_X, GREEN_BORDER_TEXURE_SIZE_Y);

    Canvas.SetPos(SCREEN_END_X - GREEN_BORDER_TEXURE_SIZE_X, SCREEN_END_Y - GREEN_BORDER_TEXURE_SIZE_Y);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_border, GREEN_BORDER_TEXURE_SIZE_X ,GREEN_BORDER_TEXURE_SIZE_Y, GREEN_BORDER_TEXURE_SIZE_X, GREEN_BORDER_TEXURE_SIZE_Y, -GREEN_BORDER_TEXURE_SIZE_X, -GREEN_BORDER_TEXURE_SIZE_Y);


    // Corners //

    // Top Left Corner //
    Canvas.DrawLine(GREEN_BORDER_CORNER_X, GREEN_BORDER_CORNER_Y    , GREEN_BORDER_CORNER_LENGTH, 1, gray, -1, eLevel.TGAME);
    Canvas.DrawLine(GREEN_BORDER_CORNER_X, GREEN_BORDER_CORNER_Y + 1, 1, GREEN_BORDER_CORNER_HEIGHT, gray, -1, eLevel.TGAME);

    Canvas.DrawLine(GREEN_BORDER_CORNER_X    , GREEN_BORDER_CORNER_Y    , GREEN_BORDER_CORNER2_LENGTH, 1, green, -1, eLevel.TGAME);
    Canvas.DrawLine(GREEN_BORDER_CORNER_X + 1, GREEN_BORDER_CORNER_Y + 1, GREEN_BORDER_CORNER2_LENGTH, 1, Canvas.black, -1, eLevel.TGAME);

    Canvas.DrawLine(GREEN_BORDER_CORNER_X    , GREEN_BORDER_CORNER_Y + 1, 1, GREEN_BORDER_CORNER2_LENGTH, green, -1, eLevel.TGAME);
    Canvas.DrawLine(GREEN_BORDER_CORNER_X + 1, GREEN_BORDER_CORNER_Y + 1, 1, GREEN_BORDER_CORNER2_LENGTH, Canvas.black, -1, eLevel.TGAME);

    // Top Right Corner //
    Canvas.DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - GREEN_BORDER_CORNER_LENGTH - 1, GREEN_BORDER_CORNER_Y, GREEN_BORDER_CORNER_LENGTH, 1, gray, -1, eLevel.TGAME);
    Canvas.DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - 2, GREEN_BORDER_CORNER_Y + 1, 1, GREEN_BORDER_CORNER_HEIGHT - 1, gray, -1, eLevel.TGAME);

    Canvas.DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - GREEN_BORDER_CORNER2_LENGTH - 1, GREEN_BORDER_CORNER_Y    , GREEN_BORDER_CORNER2_LENGTH    , 1, green, -1, eLevel.TGAME);
    Canvas.DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - GREEN_BORDER_CORNER2_LENGTH - 1, GREEN_BORDER_CORNER_Y + 1, GREEN_BORDER_CORNER2_LENGTH - 1, 1, Canvas.black, -1, eLevel.TGAME);

    Canvas.DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - 2, GREEN_BORDER_CORNER_Y + 1, 1, GREEN_BORDER_CORNER2_LENGTH    , green, -1, eLevel.TGAME);
    Canvas.DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - 3, GREEN_BORDER_CORNER_Y + 2, 1, GREEN_BORDER_CORNER2_LENGTH - 1, Canvas.black, -1, eLevel.TGAME);

    // Bottom Left Corner //
    DrawLine(GREEN_BORDER_CORNER_X, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, GREEN_BORDER_CORNER_X + GREEN_BORDER_CORNER_LENGTH, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 1, EHC_GRAY, Canvas);
    DrawLine(GREEN_BORDER_CORNER_X, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - GREEN_BORDER_CORNER_HEIGHT - 2, GREEN_BORDER_CORNER_X + 1, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, EHC_GRAY, Canvas);

    DrawLine(GREEN_BORDER_CORNER_X    , SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, GREEN_BORDER_CORNER_X + GREEN_BORDER_CORNER2_LENGTH, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 1, EHC_GREEN, Canvas);
    DrawLine(GREEN_BORDER_CORNER_X + 1, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 3, GREEN_BORDER_CORNER_X + GREEN_BORDER_CORNER2_LENGTH, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, EHC_BLACK, Canvas);

    DrawLine(GREEN_BORDER_CORNER_X    , SCREEN_END_Y - GREEN_BORDER_CORNER_Y - GREEN_BORDER_CORNER2_LENGTH - 2, GREEN_BORDER_CORNER_X + 1 , SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, EHC_GREEN, Canvas);
    DrawLine(GREEN_BORDER_CORNER_X + 1, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - GREEN_BORDER_CORNER2_LENGTH - 2, GREEN_BORDER_CORNER_X + 2, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, EHC_BLACK, Canvas);

    // Bottom Right Corner //
    DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - GREEN_BORDER_CORNER_LENGTH - 1, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, SCREEN_END_X - GREEN_BORDER_CORNER_X - 1, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 1, EHC_GRAY, Canvas);
    DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - 2, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - GREEN_BORDER_CORNER_HEIGHT - 2, SCREEN_END_X - GREEN_BORDER_CORNER_X - 1, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, EHC_GRAY, Canvas);

    DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - GREEN_BORDER_CORNER2_LENGTH - 1, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, SCREEN_END_X - GREEN_BORDER_CORNER_X - 1, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 1, EHC_GREEN, Canvas);
    DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - GREEN_BORDER_CORNER2_LENGTH - 1, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 3, SCREEN_END_X - GREEN_BORDER_CORNER_X - 1, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, EHC_BLACK, Canvas);

    DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - 2, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - GREEN_BORDER_CORNER2_LENGTH - 2, SCREEN_END_X - GREEN_BORDER_CORNER_X - 1, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, EHC_GREEN, Canvas);
    DrawLine(SCREEN_END_X - GREEN_BORDER_CORNER_X - 3, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - GREEN_BORDER_CORNER2_LENGTH - 2, SCREEN_END_X - GREEN_BORDER_CORNER_X - 2, SCREEN_END_Y - GREEN_BORDER_CORNER_Y - 2, EHC_BLACK, Canvas);
	Canvas.Style = ERenderStyle.STY_Normal;
}

//------------------------------------------------------------------------
// Description
//
//------------------------------------------------------------------------
function DrawStems(ECanvas Canvas)
{
    Canvas.SetDrawColor(128, 128, 128);
	Canvas.Style = ERenderStyle.STY_Alpha;

    // North Stem //
    DrawLine(SCREEN_HALF_X - 1, STEMS_NORTH_START, SCREEN_HALF_X    , STEMS_VERT_1ST_STOP, EHC_GREEN, Canvas);
    DrawLine(SCREEN_HALF_X    , STEMS_NORTH_START, SCREEN_HALF_X + 1, STEMS_VERT_1ST_STOP, EHC_BLACK, Canvas);
    DrawLine(SCREEN_HALF_X + 1, STEMS_NORTH_START, SCREEN_HALF_X + 2, STEMS_VERT_1ST_STOP, EHC_GREEN, Canvas);

    DrawLine(SCREEN_HALF_X - 2, STEMS_VERT_1ST_STOP    , SCREEN_HALF_X + 3, STEMS_VERT_1ST_STOP + 1, EHC_GREEN, Canvas);
    DrawLine(SCREEN_HALF_X - 2, STEMS_VERT_1ST_STOP + 1, SCREEN_HALF_X + 3, STEMS_VERT_1ST_STOP + 2, EHC_BLACK, Canvas);

    DrawLine(SCREEN_HALF_X - 1, STEMS_VERT_1ST_STOP + 2, SCREEN_HALF_X    , STEMS_VERT_END, EHC_GREEN, Canvas);
    DrawLine(SCREEN_HALF_X    , STEMS_VERT_1ST_STOP + 2, SCREEN_HALF_X + 1, STEMS_VERT_END, EHC_BLACK, Canvas);
    DrawLine(SCREEN_HALF_X + 1, STEMS_VERT_1ST_STOP + 2, SCREEN_HALF_X + 2, STEMS_VERT_END, EHC_GREEN, Canvas);

    DrawLine(SCREEN_HALF_X - 2, STEMS_VERT_END    , SCREEN_HALF_X + 3, STEMS_VERT_END + 1, EHC_GREEN, Canvas);
    DrawLine(SCREEN_HALF_X - 2, STEMS_VERT_END + 1, SCREEN_HALF_X + 3, STEMS_VERT_END + 2, EHC_BLACK, Canvas);

    // South Stem //
    DrawLine(SCREEN_HALF_X - 1, SCREEN_END_Y, SCREEN_HALF_X    , SCREEN_END_Y - STEMS_QUICK_INV_START    , EHC_GREEN, Canvas);
    DrawLine(SCREEN_HALF_X    , SCREEN_END_Y, SCREEN_HALF_X + 1, SCREEN_END_Y - STEMS_QUICK_INV_START - 1, EHC_BLACK, Canvas);
    DrawLine(SCREEN_HALF_X + 1, SCREEN_END_Y, SCREEN_HALF_X + 2, SCREEN_END_Y - STEMS_QUICK_INV_START    , EHC_GREEN, Canvas);

    DrawLine(SCREEN_HALF_X - 1, SCREEN_END_Y - STEMS_QUICK_INV_END    , SCREEN_HALF_X    , SCREEN_END_Y - STEMS_VERT_1ST_STOP - 1, EHC_GREEN, Canvas);
    DrawLine(SCREEN_HALF_X    , SCREEN_END_Y - STEMS_QUICK_INV_END + 1, SCREEN_HALF_X + 1, SCREEN_END_Y - STEMS_VERT_1ST_STOP - 1, EHC_BLACK, Canvas);
    DrawLine(SCREEN_HALF_X + 1, SCREEN_END_Y - STEMS_QUICK_INV_END    , SCREEN_HALF_X + 2, SCREEN_END_Y - STEMS_VERT_1ST_STOP - 1, EHC_GREEN, Canvas);

    DrawLine(SCREEN_HALF_X - 2, SCREEN_END_Y - STEMS_VERT_1ST_STOP - 2, SCREEN_HALF_X + 3, SCREEN_END_Y - STEMS_VERT_1ST_STOP - 1, EHC_GREEN, Canvas);
    DrawLine(SCREEN_HALF_X - 2, SCREEN_END_Y - STEMS_VERT_1ST_STOP - 3, SCREEN_HALF_X + 3, SCREEN_END_Y - STEMS_VERT_1ST_STOP - 2, EHC_BLACK, Canvas);

    DrawLine(SCREEN_HALF_X - 1, SCREEN_END_Y - STEMS_VERT_1ST_STOP - 3, SCREEN_HALF_X    , SCREEN_END_Y - STEMS_VERT_END - 1, EHC_GREEN, Canvas);
    DrawLine(SCREEN_HALF_X    , SCREEN_END_Y - STEMS_VERT_1ST_STOP - 3, SCREEN_HALF_X + 1, SCREEN_END_Y - STEMS_VERT_END - 1, EHC_BLACK, Canvas);
    DrawLine(SCREEN_HALF_X + 1, SCREEN_END_Y - STEMS_VERT_1ST_STOP - 3, SCREEN_HALF_X + 2, SCREEN_END_Y - STEMS_VERT_END - 1, EHC_GREEN, Canvas);

    DrawLine(SCREEN_HALF_X - 2, SCREEN_END_Y - STEMS_VERT_END - 2, SCREEN_HALF_X + 3, SCREEN_END_Y - STEMS_VERT_END - 1, EHC_GREEN, Canvas);
    DrawLine(SCREEN_HALF_X - 2, SCREEN_END_Y - STEMS_VERT_END - 3, SCREEN_HALF_X + 3, SCREEN_END_Y - STEMS_VERT_END - 2, EHC_BLACK, Canvas);

    // West Stem //


    DrawLine(STEMS_HORIZ_START, SCREEN_HALF_Y - 1, DIST_METER_END - 1, SCREEN_HALF_Y    , EHC_GREEN, Canvas);
    DrawLine(STEMS_HORIZ_START, SCREEN_HALF_Y    , DIST_METER_END - 1, SCREEN_HALF_Y + 1, EHC_BLACK, Canvas);
    DrawLine(STEMS_HORIZ_START, SCREEN_HALF_Y + 1, DIST_METER_END - 1, SCREEN_HALF_Y + 2, EHC_GREEN, Canvas);

	DrawLine(DIST_METER_START + 1, SCREEN_HALF_Y - 1, STEMS_HORIZ_1ST_STOP, SCREEN_HALF_Y    , EHC_GREEN, Canvas);
    DrawLine(DIST_METER_START + 1, SCREEN_HALF_Y    , STEMS_HORIZ_1ST_STOP, SCREEN_HALF_Y + 1, EHC_BLACK, Canvas);
    DrawLine(DIST_METER_START + 1, SCREEN_HALF_Y + 1, STEMS_HORIZ_1ST_STOP, SCREEN_HALF_Y + 2, EHC_GREEN, Canvas);


    DrawLine(STEMS_HORIZ_1ST_STOP    , SCREEN_HALF_Y - 2, STEMS_HORIZ_1ST_STOP + 1, SCREEN_HALF_Y + 3, EHC_GREEN, Canvas);
    DrawLine(STEMS_HORIZ_1ST_STOP + 1, SCREEN_HALF_Y - 2, STEMS_HORIZ_1ST_STOP + 2, SCREEN_HALF_Y + 3, EHC_BLACK, Canvas);


    DrawLine(STEMS_HORIZ_1ST_STOP + 2, SCREEN_HALF_Y - 1, STEMS_HORIZ_END, SCREEN_HALF_Y    , EHC_GREEN, Canvas);
    DrawLine(STEMS_HORIZ_1ST_STOP + 2, SCREEN_HALF_Y    , STEMS_HORIZ_END, SCREEN_HALF_Y + 1, EHC_BLACK, Canvas);
    DrawLine(STEMS_HORIZ_1ST_STOP + 2, SCREEN_HALF_Y + 1, STEMS_HORIZ_END, SCREEN_HALF_Y + 2, EHC_GREEN, Canvas);

    DrawLine(STEMS_HORIZ_END    , SCREEN_HALF_Y - 2, STEMS_HORIZ_END + 1, SCREEN_HALF_Y + 3, EHC_GREEN, Canvas);
    DrawLine(STEMS_HORIZ_END + 1, SCREEN_HALF_Y - 2, STEMS_HORIZ_END + 2, SCREEN_HALF_Y + 3, EHC_BLACK, Canvas);



    // East Stem //
    DrawLine(SCREEN_END_X - STEMS_HORIZ_START, SCREEN_HALF_Y - 1, SCREEN_END_X - STEMS_DIST_BOX_START    , SCREEN_HALF_Y    , EHC_GREEN, Canvas);
    DrawLine(SCREEN_END_X - STEMS_HORIZ_START, SCREEN_HALF_Y    , SCREEN_END_X - STEMS_DIST_BOX_START - 1, SCREEN_HALF_Y + 1, EHC_BLACK, Canvas);
    DrawLine(SCREEN_END_X - STEMS_HORIZ_START, SCREEN_HALF_Y + 1, SCREEN_END_X - STEMS_DIST_BOX_START    , SCREEN_HALF_Y + 2, EHC_GREEN, Canvas);

    DrawLine(SCREEN_END_X - STEMS_DIST_BOX_END    , SCREEN_HALF_Y - 1, SCREEN_END_X - STEMS_HORIZ_1ST_STOP - 1, SCREEN_HALF_Y    , EHC_GREEN, Canvas);
    DrawLine(SCREEN_END_X - STEMS_DIST_BOX_END + 1, SCREEN_HALF_Y    , SCREEN_END_X - STEMS_HORIZ_1ST_STOP - 1, SCREEN_HALF_Y + 1, EHC_BLACK, Canvas);
    DrawLine(SCREEN_END_X - STEMS_DIST_BOX_END   , SCREEN_HALF_Y + 1, SCREEN_END_X - STEMS_HORIZ_1ST_STOP - 1, SCREEN_HALF_Y + 2, EHC_GREEN, Canvas);

    DrawLine(SCREEN_END_X - STEMS_HORIZ_1ST_STOP - 2, SCREEN_HALF_Y - 2, SCREEN_END_X - STEMS_HORIZ_1ST_STOP - 1, SCREEN_HALF_Y + 3, EHC_GREEN, Canvas);
    DrawLine(SCREEN_END_X - STEMS_HORIZ_1ST_STOP - 3, SCREEN_HALF_Y - 2, SCREEN_END_X - STEMS_HORIZ_1ST_STOP - 2, SCREEN_HALF_Y + 3, EHC_BLACK, Canvas);

    DrawLine(SCREEN_END_X - STEMS_HORIZ_1ST_STOP - 3, SCREEN_HALF_Y - 1, SCREEN_END_X - STEMS_HORIZ_END - 1, SCREEN_HALF_Y    , EHC_GREEN, Canvas);
    DrawLine(SCREEN_END_X - STEMS_HORIZ_1ST_STOP - 3, SCREEN_HALF_Y    , SCREEN_END_X - STEMS_HORIZ_END - 1, SCREEN_HALF_Y + 1, EHC_BLACK, Canvas);
    DrawLine(SCREEN_END_X - STEMS_HORIZ_1ST_STOP - 3, SCREEN_HALF_Y + 1, SCREEN_END_X - STEMS_HORIZ_END - 1, SCREEN_HALF_Y + 2, EHC_GREEN, Canvas);

    DrawLine(SCREEN_END_X - STEMS_HORIZ_END - 2, SCREEN_HALF_Y - 2, SCREEN_END_X - STEMS_HORIZ_END - 1, SCREEN_HALF_Y + 3, EHC_GREEN, Canvas);
    DrawLine(SCREEN_END_X - STEMS_HORIZ_END - 3, SCREEN_HALF_Y - 2, SCREEN_END_X - STEMS_HORIZ_END - 2, SCREEN_HALF_Y + 3, EHC_BLACK, Canvas);

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

    // Fill
    Canvas.SetDrawColor(128, 128, 128);
	Canvas.Style = ERenderStyle.STY_Alpha;

    DrawLine(SCREEN_END_X - DIST_METER_START + 1, SCREEN_HALF_Y - DIST_METER_VERT_SIZE + 1,
             SCREEN_END_X - DIST_METER_END - 1  , SCREEN_HALF_Y + DIST_METER_VERT_SIZE    , EHC_ALPHA_GREEN, Canvas);

    DrawRectangle(SCREEN_END_X - DIST_METER_START    , SCREEN_HALF_Y - DIST_METER_VERT_SIZE    , SCREEN_END_X - DIST_METER_END    , SCREEN_HALF_Y + 1 + DIST_METER_VERT_SIZE, 1, EHC_GREEN, Canvas);
    DrawRectangle(SCREEN_END_X - DIST_METER_START + 1, SCREEN_HALF_Y - DIST_METER_VERT_SIZE + 1, SCREEN_END_X - DIST_METER_END - 1, SCREEN_HALF_Y + DIST_METER_VERT_SIZE    , 1, EHC_BLACK, Canvas);

    // Draw Distance
    Canvas.Font = Font'EHUDFont';
    Canvas.DrawColor = Green;

    // Only keep 4 numbers + '.'
    strFormattedDistance = string (fDistDistance / 100.0);
    iDecimal = InStr(strFormattedDistance, ".");
    strFormattedDistance = Left(strFormattedDistance, iDecimal + 3);
    strFormattedDistance = strFormattedDistance $ " M";

    // If trace didnt return anything, just draw a dash.
    if (fDistDistance == 0.0)
    {
        strFormattedDistance = "  - ";
    }

    Canvas.SetPos(SCREEN_END_X - DIST_METER_END - 5, SCREEN_HALF_Y - DIST_METER_VERT_SIZE + 4);
    Canvas.DrawTextRightAligned(strFormattedDistance);
	Canvas.Style = ERenderStyle.STY_Normal;
}

//------------------------------------------------------------------------
// Description
//
//------------------------------------------------------------------------
function DrawQuickInv(ECanvas Canvas)
{
    local int				iPrimAmmoClipNb;
    local String			strPrimAmmoNb;
    local String            strZoomLevel; // Joshua - Display zoom level in SC-20K scope
	local ESecondaryAmmo	SecAmmo;
    local float             xLen, yLen; // Joshua - Display zoom level in SC-20K scope

    Canvas.SetDrawColor(128, 128, 128);
    Canvas.Style = ERenderStyle.STY_Alpha;
    // Fond Vert Transparent
    DrawLine(QUICK_INV_LEFT + 2, QUICK_INV_TOP + 2, QUICK_INV_RIGHT - 2, QUICK_INV_BOTTOM - 2, EHC_ALPHA_GREEN, Canvas);

    // Square perimeter (NSEW)
    // Green
    DrawRectangle(QUICK_INV_LEFT    , QUICK_INV_TOP    , QUICK_INV_RIGHT    , QUICK_INV_BOTTOM    , 1, EHC_GREEN, Canvas);
    DrawRectangle(QUICK_INV_LEFT + 1, QUICK_INV_TOP + 1, QUICK_INV_RIGHT - 1, QUICK_INV_BOTTOM - 1, 1, EHC_BLACK, Canvas);

    // Three strokes
    DrawLine(QUICK_INV_LEFT + 57, QUICK_INV_TOP + 1, QUICK_INV_LEFT + 58, QUICK_INV_BOTTOM - 1, EHC_BLACK, Canvas);
    DrawLine(QUICK_INV_LEFT + 58, QUICK_INV_TOP + 1, QUICK_INV_LEFT + 59, QUICK_INV_BOTTOM - 1, EHC_GREEN, Canvas);
    DrawLine(QUICK_INV_LEFT + 59, QUICK_INV_TOP + 1, QUICK_INV_LEFT + 60, QUICK_INV_BOTTOM - 1, EHC_BLACK, Canvas);

    // Gun Icon
    Canvas.SetPos(QUICK_INV_LEFT - 14, QUICK_INV_TOP + 2);

    Canvas.SetDrawColor(64, 64, 64);
    Canvas.Style = ERenderStyle.STY_Modulated;
    eLevel.TICON.DrawTileFromManager(Canvas, Weapon.HUDTex, eLevel.TICON.GetWidth(Weapon.HUDTex), eLevel.TICON.GetHeight(Weapon.HUDTex), 0, 0, eLevel.TICON.GetWidth(Weapon.HUDTex), eLevel.TICON.GetHeight(Weapon.HUDTex));
    Canvas.Style = ERenderStyle.STY_Normal;

    Canvas.SetDrawColor(128, 128, 128);
	Canvas.Style = ERenderStyle.STY_Alpha;

    // Primary ammo qty
    Canvas.SetPos(QUICK_INV_LEFT + 50, QUICK_INV_TOP + 27);
    Canvas.Font = Font'EHUDFont';
    Canvas.DrawColor = Green;
    strPrimAmmoNb = String(Weapon.Ammo);
    iPrimAmmoClipNb = Weapon.Ammo / Weapon.ClipMaxAmmo;
    strPrimAmmoNb = strPrimAmmoNb $ "/" $ iPrimAmmoClipNb;
    //Canvas.DrawText(strPrimAmmoNb);
    Canvas.DrawTextRightAligned(strPrimAmmoNb);

    // Joshua - Display zoom level in SC-20K scope
    if (F2000 != None && Epc.bF2000ZoomLevels)
    {
        switch (F2000.FOVIndex)
        {
        case 0: // 2x Zoom
            strZoomLevel = "2X";
            break;
        case 1: // 4x Zoom
            strZoomLevel = "4X";
            break;
        case 2: // 6x Zoom
            strZoomLevel = "6X";
            break;
        }

        Canvas.Font = Font'EHUDFont';
        Canvas.SetDrawColor(128, 128, 128);
        Canvas.DrawColor = Green;
        Canvas.Style = ERenderStyle.STY_Alpha;

        Canvas.TextSize(strZoomLevel, xLen, yLen);

        Canvas.SetPos(QUICK_INV_LEFT + 60 + (23 - xLen) / 2, QUICK_INV_TOP + 10 + (25 - yLen) / 2);
        Canvas.DrawText(strZoomLevel);

        Canvas.Style = ERenderStyle.STY_Normal;
    }

    // Secondary Ammo, if any
	if (F2000 == None)
		return;

	SecAmmo = ESecondaryAmmo(F2000.SecondaryAmmo);
    if (SecAmmo != None && !Epc.bF2000ZoomLevels)
    {
        // Secondary Ammo Icon
        Canvas.SetPos(QUICK_INV_LEFT + 62, QUICK_INV_TOP + 2);
        Canvas.SetDrawColor(64, 64, 64);
        Canvas.Style = ERenderStyle.STY_Modulated;
        eLevel.TICON.DrawTileFromManager(Canvas, SecAmmo.HUDTexSD, eLevel.TICON.GetWidth(SecAmmo.HUDTexSD), eLevel.TICON.GetHeight(SecAmmo.HUDTexSD), 0, 0, eLevel.TICON.GetWidth(SecAmmo.HUDTexSD), eLevel.TICON.GetHeight(SecAmmo.HUDTexSD));
        Canvas.Style = ERenderStyle.STY_Normal;

        Canvas.DrawColor = Green;

        // Secondary Ammo qty
        if (SecAmmo.Quantity < 10)
            Canvas.SetPos(QUICK_INV_LEFT + 76, QUICK_INV_TOP + 27);
        else
            Canvas.SetPos(QUICK_INV_LEFT + 81, QUICK_INV_TOP + 27);

        //Canvas.DrawColor = Green;
        Canvas.DrawTextRightAligned(String(SecAmmo.Quantity));
    }
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

    pRotation = float(F2000.SniperNoisedRotation.Yaw & 65535) / 65535.0f;

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

	Canvas.Style = ERenderStyle.STY_Alpha;

    // Draw Compas Coordinates //
    Canvas.Font = Font'EHUDFont';
    Canvas.SetDrawColor(38, 81, 50);

    Canvas.SetPos(SCREEN_HALF_X - rPos, SCREEN_HALF_Y - NOISE_BARS_VERT_DIST + 4);
    Canvas.DrawText("["$szFirstDir$"]");

    Canvas.SetPos(SCREEN_HALF_X - rPos + p1, SCREEN_HALF_Y - NOISE_BARS_VERT_DIST - 11);
    Canvas.DrawText(".");
    Canvas.SetPos(SCREEN_HALF_X - rPos + p1, SCREEN_HALF_Y - NOISE_BARS_VERT_DIST - 10);
    Canvas.DrawText(".");

    Canvas.SetPos(SCREEN_HALF_X + (630 - rPos), SCREEN_HALF_Y - NOISE_BARS_VERT_DIST + 4);
    Canvas.DrawText("["$szSecondDir$"]");

    Canvas.SetPos(SCREEN_HALF_X + (630 - rPos) + p2, SCREEN_HALF_Y - NOISE_BARS_VERT_DIST - 11);
    Canvas.DrawText(".");
    Canvas.SetPos(SCREEN_HALF_X + (630 - rPos) + p2, SCREEN_HALF_Y - NOISE_BARS_VERT_DIST - 10);
    Canvas.DrawText(".");

    // Draw noise bars //
    DrawNoiseBar(SCREEN_HALF_X - NOISE_BARS_HORIZ_SIZE, SCREEN_HALF_Y - NOISE_BARS_VERT_DIST - 6,
                 SCREEN_HALF_X + NOISE_BARS_HORIZ_SIZE, SCREEN_HALF_Y - NOISE_BARS_VERT_DIST - 2,
                 -rPos % 126, Canvas);
    DrawNoiseBar(SCREEN_HALF_X - NOISE_BARS_HORIZ_SIZE, SCREEN_HALF_Y - NOISE_BARS_VERT_DIST,
                 SCREEN_HALF_X + NOISE_BARS_HORIZ_SIZE, SCREEN_HALF_Y - NOISE_BARS_VERT_DIST + 4,
                 rPos % 126, Canvas);

    DrawNoiseBar(SCREEN_HALF_X - NOISE_BARS_HORIZ_SIZE, SCREEN_HALF_Y + NOISE_BARS_VERT_DIST - 4,
                 SCREEN_HALF_X + NOISE_BARS_HORIZ_SIZE, SCREEN_HALF_Y + NOISE_BARS_VERT_DIST,
                 rPos % 126, Canvas);
    DrawNoiseBar(SCREEN_HALF_X - NOISE_BARS_HORIZ_SIZE, SCREEN_HALF_Y + NOISE_BARS_VERT_DIST + 2,
                 SCREEN_HALF_X + NOISE_BARS_HORIZ_SIZE, SCREEN_HALF_Y + NOISE_BARS_VERT_DIST + 6,
                 -rPos % 126, Canvas);
	Canvas.Style = ERenderStyle.STY_Normal;
}

//------------------------------------------------------------------------
// Description
//
//------------------------------------------------------------------------
function DrawCrosshair(ECanvas Canvas)
{
    local int CROSSHAIR_CENTER_X, CROSSHAIR_CENTER_Y, i;
    local int TOPLEFT_DEP_X, TOPLEFT_DEP_Y, TOPRIGHT_DEP_X, TOPRIGHT_DEP_Y;
    local int BOTTOMLEFT_DEP_X, BOTTOMLEFT_DEP_Y, BOTTOMRIGHT_DEP_X, BOTTOMRIGHT_DEP_Y;
    local color chColor;

	local float CENTERSCALE;
//    local float turn, lookUp, turnValue, lookUpValue;
/*
    turnValue = 0;
    lookUpValue = 0;
    for (i = NB_TURN_VALUE - 1; i > 0; i--)
    {
        turn = fTurn[i - 1] - fTurn[i];
        if (turn > DELTA_TURN_AVERAGE)
            turn = DELTA_TURN_AVERAGE;
        else if (turn < -DELTA_TURN_AVERAGE)
            turn = -DELTA_TURN_AVERAGE;

        lookUp = fLookUp[i] - fLookUp[i - 1];
        if (lookUp > DELTA_LOOKUP_AVERAGE)
            lookUp= DELTA_LOOKUP_AVERAGE;
        else if (lookUp < -DELTA_LOOKUP_AVERAGE)
            lookUp = -DELTA_LOOKUP_AVERAGE;

        turnValue   += turn   / DELTA_TURN_AVERAGE   * (1.0f / (NB_TURN_VALUE - 1));
        lookUpValue += lookUp / DELTA_LOOKUP_AVERAGE * (1.0f / (NB_TURN_VALUE - 1));
    }
*/
    // Calculate Crosshair Position //
	CROSSHAIR_CENTER_X = SCREEN_HALF_X;
	CROSSHAIR_CENTER_Y = SCREEN_HALF_Y;
	if (F2000 != None && F2000.bSniperMode)
	{
		CENTERSCALE = 0.5;
	}
	else
	{
		CENTERSCALE = Weapon.Accuracy;
	}

	TOPLEFT_DEP_X = - (8 + MAX_CROSSHAIR_DEP_X * CENTERSCALE);
	TOPLEFT_DEP_Y = - (8 + MAX_CROSSHAIR_DEP_X * CENTERSCALE);
	TOPRIGHT_DEP_X = 4 + MAX_CROSSHAIR_DEP_X * CENTERSCALE;
	TOPRIGHT_DEP_Y = - (8 + MAX_CROSSHAIR_DEP_X * CENTERSCALE);
	BOTTOMLEFT_DEP_X = -(8 + MAX_CROSSHAIR_DEP_X * CENTERSCALE);
	BOTTOMLEFT_DEP_Y = 4 + MAX_CROSSHAIR_DEP_X * CENTERSCALE;
	BOTTOMRIGHT_DEP_X = 4 + MAX_CROSSHAIR_DEP_X * CENTERSCALE;
	BOTTOMRIGHT_DEP_Y = 4 + MAX_CROSSHAIR_DEP_X * CENTERSCALE;

    switch (chStyle)
    {
        case CH_NONE:
            chColor = Canvas.MakeColor(38,81,50);
            break;
        case CH_NONHOSTILE:
            chColor = Canvas.MakeColor(27,70,122);
            break;
    }

	Canvas.Style = ERenderStyle.STY_Alpha;

	// Joshua - Draw outer box in sniper mode for CS_Beta crosshair style
	if (F2000 == None || !F2000.bSniperMode || Epc.CrosshairStyle == CS_Beta)
	{
		if (F2000 != None)
		{
			// Top Right Corner
			Canvas.SetPos(CROSSHAIR_CENTER_X + TOPRIGHT_DEP_X - 3, CROSSHAIR_CENTER_Y + TOPRIGHT_DEP_Y + 1);
			eLevel.TGAME.DrawTileFromManager(Canvas, GetCrosshairMire(), 7, 7, 0, 0, 7, 7);

			// Top Left Corner
			Canvas.SetPos(CROSSHAIR_CENTER_X + TOPLEFT_DEP_X + 1, CROSSHAIR_CENTER_Y + TOPLEFT_DEP_Y + 1);
			eLevel.TGAME.DrawTileFromManager(Canvas, GetCrosshairMire(), 7, 7, 7, 0, -7, 7);

			// Bottom Right Corner
			Canvas.SetPos(CROSSHAIR_CENTER_X + BOTTOMRIGHT_DEP_X - 3,CROSSHAIR_CENTER_Y + BOTTOMRIGHT_DEP_Y - 3);
			eLevel.TGAME.DrawTileFromManager(Canvas, GetCrosshairMire(), 7, 7, 0, 7, 7, -7);

			// Bottom Left Corner
			Canvas.SetPos(CROSSHAIR_CENTER_X + BOTTOMLEFT_DEP_X + 1, CROSSHAIR_CENTER_Y + BOTTOMLEFT_DEP_Y - 3);
			eLevel.TGAME.DrawTileFromManager(Canvas, GetCrosshairMire(), 7, 7, 7, 7, -7, -7);
		}
		else
		{
			// Top
			Canvas.SetPos(CROSSHAIR_CENTER_X - 2, CROSSHAIR_CENTER_Y - (MAX_CROSSHAIR_DEP_X * CENTERSCALE) - 10);
			eLevel.TGAME.DrawTileFromManager(Canvas, GetPistolMireTopBas(), 5, 6, 0, 0, 5, 6);

			// Right
			Canvas.SetPos(CROSSHAIR_CENTER_X + (MAX_CROSSHAIR_DEP_X * CENTERSCALE) + 5, CROSSHAIR_CENTER_Y - 2);
			eLevel.TGAME.DrawTileFromManager(Canvas, GetPistolMireCote(), 6, 5, 0, 0, 6, 5);

			// Bottom
			Canvas.SetPos(CROSSHAIR_CENTER_X - 2, CROSSHAIR_CENTER_Y + (MAX_CROSSHAIR_DEP_X * CENTERSCALE) + 5);
			eLevel.TGAME.DrawTileFromManager(Canvas, GetPistolMireTopBas(), 5, 6, 5, 6, -5, -6);

			// Left
			Canvas.SetPos(CROSSHAIR_CENTER_X - (MAX_CROSSHAIR_DEP_X * CENTERSCALE) - 5 - 5, CROSSHAIR_CENTER_Y - 2);
			eLevel.TGAME.DrawTileFromManager(Canvas, GetPistolMireCote(), 6, 5, 6, 5, -6, -5);
		}
	}

    // crosshair dot //
	if (!bBlinkOff)
	{
		//Canvas.DrawLine(CROSSHAIR_CENTER_X - CROSSHAIR_WIDTH / 2, CROSSHAIR_CENTER_Y - CROSSHAIR_HEIGHT / 2, CROSSHAIR_WIDTH, CROSSHAIR_HEIGHT, chColor, -1, eLevel.TGAME);
		// (Yanick Mimee) July-05-2002
		// New aim
		if (F2000 != None)
		{
			Canvas.SetPos(CROSSHAIR_CENTER_X - CROSSHAIR_WIDTH / 2, CROSSHAIR_CENTER_Y - CROSSHAIR_HEIGHT / 2);
			eLevel.TGAME.DrawTileFromManager(Canvas, GetCrosshairMireFond(), CROSSHAIR_WIDTH, CROSSHAIR_HEIGHT, 0, 0, 17, 17);
		}
		else
		{
			Canvas.SetPos(CROSSHAIR_CENTER_X - CROSSHAIR_WIDTH_SMALL / 2, CROSSHAIR_CENTER_Y - CROSSHAIR_HEIGHT_SMALL / 2);
			eLevel.TGAME.DrawTileFromManager(Canvas, GetPistolFondMire(), CROSSHAIR_WIDTH_SMALL, CROSSHAIR_HEIGHT_SMALL, 0, 0, 11, 11);
		}
	}

	/* REMOVE THE DOUBLE CIRCLE THING - KEEP THE CODE IN CASE THEY WANT IT BACK (Yanick Mimee)
    // Corners around crosshair thinggy
    if (!bBlinkOff && (chStyle != CH_NONE || (F2000 != None && F2000.bSniperMode)))
    {
        // Top Left Corner
		Canvas.SetPos(CROSSHAIR_CENTER_X + TOPLEFT_DEP_X,
			           CROSSHAIR_CENTER_Y + TOPLEFT_DEP_Y);
		eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_mire,
			                              9,
										  9,
										  0, 0, 9, 9);

		// Top Right Corner
		Canvas.SetPos(CROSSHAIR_CENTER_X + TOPRIGHT_DEP_X - 4,
					   CROSSHAIR_CENTER_Y + TOPRIGHT_DEP_Y);
		eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_mire,
			                              9,
										  9,
										  9, 0, -9, 9);

		// Bottom Left Corner
		Canvas.SetPos(CROSSHAIR_CENTER_X + BOTTOMLEFT_DEP_X,
					   CROSSHAIR_CENTER_Y + BOTTOMLEFT_DEP_Y - 4);
		eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_mire,
			                              9,
										  9,
										  0, 9, 9, -9);

		// Bottom right Corner //
		Canvas.SetPos(CROSSHAIR_CENTER_X + BOTTOMRIGHT_DEP_X - 4,
			           CROSSHAIR_CENTER_Y + BOTTOMRIGHT_DEP_Y - 4);
		eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.svf2_mire,
			                              9,
										  9,
										  9, 9, -9, -9);
    }*/
	Canvas.Style = ERenderStyle.STY_Normal;
}

//------------------------------------------------------------------------
// Description
//
//------------------------------------------------------------------------
function DrawNoiseBar(int AX, int AY, int BX, int BY, int OffsetX, ECanvas Canvas)
{
    Canvas.DrawColor.R = 128;
    Canvas.DrawColor.G = 128;
    Canvas.DrawColor.B = 128;
    Canvas.DrawColor.A = 255;

    Canvas.SetPos(AX, AY);
	Canvas.Style = ERenderStyle.STY_Alpha;
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_anim_border, 630, abs(BY - AY), OffsetX, 0, 630, 4);
	Canvas.Style = ERenderStyle.STY_Normal;
}

// Joshua - SCPT zoom flash cycle animation
function DrawFlashCycle(ECanvas Canvas)
{
	local int textureRadius, minRadius, maxRadius;
	local float	flashRadius;

	if (!F2000.bStartFirstFlashCycle && !F2000.bStartSecondFlashCycle)
		return;

	textureRadius = eLevel.TGAME.GetWidth(eLevel.TGAME.cycle_flash);

	// Fill
	Canvas.SetDrawColor(128,128,128,128);
	Canvas.DrawColor = Green;
	Canvas.Style = ERenderStyle.STY_Alpha;

	minRadius = SCREEN_HALF_Y - STEMS_VERT_END;
	maxRadius = textureRadius;

	flashRadius = minRadius + (maxRadius-minRadius) * (F2000.fCycleFlashTime / F2000.fCycleFlashDuration);

	//Canvas.SetPos(SCREEN_HALF_X - flashRadius, SCREEN_HALF_Y - flashRadius);
	//eLevel.TGAME.DrawTileFromManager( Canvas, eLevel.TGAME.cycle_flash, flashRadius, flashRadius, 0, 0, textureRadius, textureRadius);

	//flashRadius = 48;
	Canvas.SetPos(SCREEN_HALF_X - flashRadius, SCREEN_HALF_Y - flashRadius);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.cycle_flash, flashRadius, flashRadius, 0, 0, textureRadius, textureRadius);

	Canvas.SetPos(SCREEN_HALF_X - flashRadius, SCREEN_HALF_Y);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.cycle_flash, flashRadius, flashRadius, 0, textureRadius, textureRadius, -textureRadius);

	Canvas.SetPos(SCREEN_HALF_X, SCREEN_HALF_Y - flashRadius);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.cycle_flash, flashRadius, flashRadius, textureRadius, 0, -textureRadius, textureRadius);

	Canvas.SetPos(SCREEN_HALF_X, SCREEN_HALF_Y);
	eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.cycle_flash, flashRadius, flashRadius, textureRadius, textureRadius, -textureRadius, -textureRadius);

	Canvas.Style = ERenderStyle.STY_Normal;
}

defaultproperties
{
    Green=(R=38,G=81,B=50,A=255)
    gray=(R=80,G=80,B=80,A=255)
}