 /*=============================================================================

 Class:         ECameraJammerView

 Description:   Camera Jammer HUD

 Reference:     -

=============================================================================*/
class ECameraJammerView extends EObjectHud;

/*-----------------------------------------------------------------------------
                        T Y P E   D E F I N I T I O N S 
-----------------------------------------------------------------------------*/
const CAMJAM_WIDTH      = 142;
const CAMJAM_HEIGHT     = 75;

const LIFEBAR_WIDTH        = 17;

const BATTERY_WIDTH     = 84;
const BATTERY_HEIGHT    = 9;

const NB_ANIMBARS       = 4;

const SCREEN_HALF_X     = 319;
const SCREEN_HALF_Y     = 239;

const ANIM_SPEED        = 0.5f;

/*-----------------------------------------------------------------------------
                        M E M B E R   V A R I A B L E S 
-----------------------------------------------------------------------------*/
var color lightgreen;
var color darkgreen;

var int barOffset[NB_ANIMBARS];

var ECameraJammer camjam;

var float animTimer;
var bool  bBlink;

/*-----------------------------------------------------------------------------
                                M E T H O D S
-----------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------
     Function:      PostBeginPlay

     Description:   
-----------------------------------------------------------------------------*/
function PostBeginPlay()
{
    Super.PostBeginPlay();

    camjam = ECameraJammer(owner);
    if(camjam == None)
        log("CAMERAJAMMERVIEW WITHOUT A CAMERAJAMMER");
}

/*-----------------------------------------------------------------------------
     Function:      DrawView

     Description:   
-----------------------------------------------------------------------------*/
function DrawView(HUD Hud,ECanvas Canvas)
{
    local int xPos, yPos;
    local EPlayerController EPC; // Joshua - Show crosshair toggle

    EPC = EPlayerController(camjam.Owner);

    if(EPC.bShowInventory && EPC.bShowHUD) // Joshua - Show Camera Jammer info only if inventory enabled
    {
        xPos = 640 - eGame.HUD_OFFSET_X - CAMJAM_WIDTH - LIFEBAR_WIDTH;
        yPos = eGame.HUD_OFFSET_Y;

        DrawBorders(Canvas, xPos, yPos, CAMJAM_WIDTH, CAMJAM_HEIGHT);

        Canvas.DrawRectangle(xPos + 9, yPos + 9, CAMJAM_WIDTH - 18, CAMJAM_HEIGHT - 18, 2, darkgreen, -1, eLevel.TGAME);

        Canvas.DrawRectangle(xPos + 12, yPos + 12, CAMJAM_WIDTH - 24, CAMJAM_HEIGHT - 24, 1, lightgreen, -1, eLevel.TGAME);

        Canvas.DrawLine(xPos + 13, yPos + 22, CAMJAM_WIDTH - 26, 1, lightgreen, -1, eLevel.TGAME);
        Canvas.DrawLine(xPos + 13, yPos + 38, CAMJAM_WIDTH - 26, 1, lightgreen, -1, eLevel.TGAME);
        Canvas.DrawLine(xPos + 13, yPos + 47, CAMJAM_WIDTH - 26, 1, lightgreen, -1, eLevel.TGAME);


        DrawBatteryMeter(Canvas, xPos + (CAMJAM_WIDTH - BATTERY_WIDTH)/2, yPos + 47 - BATTERY_HEIGHT/2);
        DrawCamJamInfo(Canvas, xPos + 14, yPos + 27, CAMJAM_WIDTH - 28);
    }

    if(camjam != None && camjam.GetStateName() == 's_Jamming' && EPC.bShowCrosshair && EPC.bShowHUD) // Joshua - Show crosshair toggle
        DrawCrosshair(Canvas);
}

/*-----------------------------------------------------------------------------
     Function:      DrawBorders

     Description:   
-----------------------------------------------------------------------------*/
function DrawBorders(ECanvas Canvas, int xPos, int yPos, int width, int height)
{
    // FILL BACKGROUND IN BLACK //
    Canvas.DrawLine(xPos + 5, yPos + 5, width - 10, height - 10, Canvas.black, -1, eLevel.TGAME);

    // BORDERS //

    Canvas.SetDrawColor(128,128,128);
	Canvas.Style = ERenderStyle.STY_Alpha;

    // TOP LEFT CORNER //
    Canvas.SetPos(xPos, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sw_coin, 6, 6, 0, 6, 6, -6);

    // TOP RIGHT CORNER //
    Canvas.SetPos(xPos + width - 6, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sw_coin, 6, 6, 6, 6, -6, -6);

    // BOTTOM LEFT CORNER //
    Canvas.SetPos(xPos, yPos + height - 6);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sw_coin, 6, 6, 0, 0, 6, 6);

    // BOTTOM RIGHT CORNER //
    Canvas.SetPos(xPos + width - 6, yPos + height - 6);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sw_coin, 6, 6, 6, 0, -6, 6);

    // TOP BORDER //
    Canvas.SetPos(xPos + 6, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sw_border_h, width - 2*6, 5, 0, 5, 1, -5);

    // BOTTOM BORDER //
    Canvas.SetPos(xPos + 6, yPos + height - 5);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sw_border_h, width - 2*6, 5, 0, 0, 1, 5);

    // LEFT BORDER //
    Canvas.SetPos(xPos, yPos + 6);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sw_border_v, 5, height - 2*6, 0, 0, 5, 1);

    // RIGHT BORDER //
    Canvas.SetPos(xPos + width - 5, yPos + 6);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sw_border_v, 5, height - 2*6, 5, 0, -5, 1);

	Canvas.Style = ERenderStyle.STY_Normal;
}

/*-----------------------------------------------------------------------------
     Function:      DrawBatteryMeter

     Description:   
-----------------------------------------------------------------------------*/
function DrawBatteryMeter(ECanvas Canvas, int xPos, int yPos)
{
    local float e;
    
	Canvas.Style = ERenderStyle.STY_Alpha;
    // FILL BACKGROUND //
    Canvas.DrawLine(xPos, yPos, BATTERY_WIDTH, BATTERY_HEIGHT, Canvas.black, -1, eLevel.TGAME);

    // DRAW BATTERY //
    Canvas.DrawRectangle(xPos + 1, yPos, BATTERY_WIDTH - 1, BATTERY_HEIGHT, 1, lightgreen, -1, eLevel.TGAME);

    Canvas.DrawLine(xPos, yPos + 2, 1, BATTERY_HEIGHT - 4, lightgreen, -1, eLevel.TGAME);
    Canvas.DrawLine(xPos + BATTERY_WIDTH - 2, yPos + 2, 1, BATTERY_HEIGHT - 4, lightgreen, -1, eLevel.TGAME);

    Canvas.DrawLine(xPos + BATTERY_WIDTH - 1, yPos + BATTERY_HEIGHT/2 - 1, 1, 1, Canvas.black, -1, eLevel.TGAME);
    Canvas.DrawLine(xPos + BATTERY_WIDTH - 1, yPos + BATTERY_HEIGHT - BATTERY_HEIGHT/2, 1, 1, Canvas.black, -1, eLevel.TGAME);

    // DRAW + AND - //
    Canvas.DrawLine(xPos + 1, yPos + BATTERY_HEIGHT + 4, 5, 1, lightgreen, -1, eLevel.TGAME);

    Canvas.DrawLine(xPos + BATTERY_WIDTH - 6, yPos + BATTERY_HEIGHT + 4, 5, 1, lightgreen, -1, eLevel.TGAME);
    Canvas.DrawLine(xPos + BATTERY_WIDTH - 3, yPos + BATTERY_HEIGHT + 2, 1, 5, lightgreen, -1, eLevel.TGAME);

    // DRAW METER //
    if(camjam != None)
    {
        e = camjam.CurrentCharge / camjam.BatteryCharge;
        Canvas.DrawLine(xPos + 3, yPos + 2, e * float(BATTERY_WIDTH - 6), BATTERY_HEIGHT - 4, darkgreen, -1, eLevel.TGAME);
    }

	Canvas.Style = ERenderStyle.STY_Normal;
}

/*-----------------------------------------------------------------------------
     Function:      DrawCamJamInfo

     Description:   
-----------------------------------------------------------------------------*/
function DrawCamJamInfo(ECanvas Canvas, int xPos, int yPos, int width)
{
    local float xLen, yLen;
    local string szText;
    local int i;

	Canvas.Style = ERenderStyle.STY_Alpha;

    if(camjam == None)
        return;

    Canvas.DrawColor = darkgreen;

    if(camjam.JammedCamera != None)
    {
        szText = Canvas.LocalizeStr("JAMMING");
        Canvas.DrawColor.A = 192;
    }   
    else if(camjam.GetStateName() != 's_Jamming' && camjam.CurrentCharge < camjam.BatteryCharge)
        szText = Canvas.LocalizeStr("RECHARGING");

    for(i = 0; i < NB_ANIMBARS; i++)
    {
        Canvas.SetPos(xPos, yPos + i*2);
        eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.cj_communication, width, 1, barOffset[i], 0, width, 1);
    }

    if(szText != "" && bBlink)
    {
        Canvas.Font = font'EHUDFont';
        Canvas.DrawColor = lightgreen;

        Canvas.Textsize(szText, xLen, yLen);
        Canvas.SetPos(xPos + (width - xLen) / 2, yPos - 3);
        Canvas.DrawText(szText);
    }

	Canvas.Style = ERenderStyle.STY_Normal;

}

/*-----------------------------------------------------------------------------
     Function:      DrawCrosshair

     Description:   
-----------------------------------------------------------------------------*/
function DrawCrosshair(ECanvas Canvas)
{
    local int width, height;

	Canvas.Style = ERenderStyle.STY_Alpha;

    width = eLevel.TGAME.GetWidth(eLevel.TGAME.cj_mire);
    height = eLevel.TGAME.GetHeight(eLevel.TGAME.cj_mire);

    if(camjam.JammedCamera != None)
        Canvas.SetDrawColor(79,8,8);
    else        
        Canvas.SetDrawColor(38,81,50);

    Canvas.SetPos(SCREEN_HALF_X - width/2, SCREEN_HALF_Y - height/2);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.cj_mire, width, height, 0, 0, width, height);

	Canvas.Style = ERenderStyle.STY_Normal;
}

state s_Selected
{
    function Tick(float DeltaTime)
    {
        local int i;

        animTimer += DeltaTime;
        if(animTimer > ANIM_SPEED)
        {
            for(i = 0; i < NB_ANIMBARS; i++)
            {
                if(i%2 == 0)
                {
                    barOffset[i] += 5;
                    if(barOffset[i] > 64)
                        barOffset[i] -= 64;
                }
                else
                {
                    barOffset[i] -= 5;
                    if(barOffset[i] < 0)
                        barOffset[i] += 64;
                }
            }

            if(camjam.JammedCamera != None)
                bBlink = !bBlink;
            else
                bBlink = true;
        }
    }

    function BeginState()
    {
        animTimer = 0.0f;
    }
}

defaultproperties
{
    lightgreen=(R=38,G=81,B=50,A=255)
    darkgreen=(R=19,G=41,B=25,A=255)
    bBlink=true
}