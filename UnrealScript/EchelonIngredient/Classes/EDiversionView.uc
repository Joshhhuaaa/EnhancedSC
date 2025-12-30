 /*=============================================================================

 Class:         EDiversionView

 Description:   Diversion Camera HUD

 Reference:     -

=============================================================================*/
class EDiversionView extends ECameraView;

/*-----------------------------------------------------------------------------
                        T Y P E   D E F I N I T I O N S 
-----------------------------------------------------------------------------*/
const DIVERSION_ICON_LEFT   = 498;
const DIVERSION_ICON_TOP    = 306;

const BUTTON_BOX_WIDTH      = 19;
const BUTTON_BOX_HEIGHT     = 17;

const BUTTON_NOISE_TEXT_X   = 9;
const BUTTON_GAS_TEXT_X     = 85;
const BUTTON_EXIT_TEXT_X    = 67;

const BUTTON_NOISE_BOX_X    = 100;//148;
const BUTTON_GAS_BOX_X      = 280;//320;
const BUTTON_EXIT_BOX_X     = 29;

// Joshua - Controller support
const BUTTON_NOISE_BOX_X_XBOX    = 148;
const BUTTON_GAS_BOX_X_XBOX      = 320;


state s_Online
{
	function DrawView(HUD Hud,ECanvas Canvas)
	{
        local EPlayerController EPC; // Joshua - Show cam toggle
        EPC = EPlayerController(Camera.Owner);

		Super.DrawView(Hud, Canvas);

        if (EPC.bShowScope && EPC.bShowHUD)
            DrawPitchBars(Canvas);
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
    Canvas.SetDrawColor(128, 128, 128);

    Canvas.SetPos(DIVERSION_ICON_LEFT, DIVERSION_ICON_TOP);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.sc_ic_diversion, 75, 72, 0, 0, 75, 72);
}

/*-----------------------------------------------------------------------------
    Function :      DrawButtons  

    Description:    -
-----------------------------------------------------------------------------*/
function DrawButtons(ECanvas Canvas)
{
    local int xPos, yPos;
	local float xLen, yLen;
    local EPlayerController EPC; // Joshua - PlayStation controller prompts
	
    EPC = EPlayerController(Camera.Owner);

    Super.DrawButtons(Canvas);
	
    //// Text Stuff //
	Canvas.Font = Font'EHUDFont';
	yPos = SCREEN_END_Y - BOTTOM_CAM_Y - (BUTTONBAR_HEIGHT - BUTTON_BOX_HEIGHT) / 2;
	xPos = CAM_X + SIDEBAR_WIDTH;

    if (eGame.bUseController) 
    {
        Canvas.DrawLine(xPos + BUTTON_NOISE_BOX_X_XBOX, yPos - BUTTON_BOX_HEIGHT, BUTTON_BOX_WIDTH, BUTTON_BOX_HEIGHT, Canvas.black, -1, eLevel.TGAME);
        Canvas.DrawRectangle(xPos + BUTTON_NOISE_BOX_X_XBOX + 1, yPos - BUTTON_BOX_HEIGHT + 1, BUTTON_BOX_WIDTH - 2, BUTTON_BOX_HEIGHT - 2, 1, Green, -1, eLevel.TGAME);


        Canvas.DrawLine(xPos + BUTTON_GAS_BOX_X_XBOX, yPos - BUTTON_BOX_HEIGHT, BUTTON_BOX_WIDTH, BUTTON_BOX_HEIGHT, Canvas.black, -1, eLevel.TGAME);
        Canvas.DrawRectangle(xPos + BUTTON_GAS_BOX_X_XBOX + 1, yPos - BUTTON_BOX_HEIGHT + 1, BUTTON_BOX_WIDTH - 2, BUTTON_BOX_HEIGHT - 2, 1, Green, -1, eLevel.TGAME);

        xPos = SCREEN_END_X - CAM_X - SIDEBAR_WIDTH;

        Canvas.DrawLine(xPos - BUTTON_EXIT_BOX_X, yPos - BUTTON_BOX_HEIGHT, BUTTON_BOX_WIDTH, BUTTON_BOX_HEIGHT, Canvas.black, -1, eLevel.TGAME);
        Canvas.DrawRectangle(xPos - BUTTON_EXIT_BOX_X + 1, yPos - BUTTON_BOX_HEIGHT + 1, BUTTON_BOX_WIDTH - 2, BUTTON_BOX_HEIGHT - 2, 1, Green, -1, eLevel.TGAME);

        Canvas.DrawColor = Green;
        xPos = CAM_X + SIDEBAR_WIDTH;

        // Draw B button (NOISE)
        Canvas.DrawColor = Green;
        if (EPC.ControllerIcon == CI_PlayStation) // Joshua - PlayStation controller prompts
        {
            Canvas.SetPos(xPos + BUTTON_NOISE_BOX_X_XBOX + 5 - 1, yPos - BUTTON_BOX_HEIGHT + 2 - 1);
            Canvas.Font = Font'ETextFontPS2';
            // Joshua - Default controller sceheme uses X/Square to make noise
            if (Epc.ControllerScheme == CS_Default)
                Canvas.DrawText(Chr(0xFD));
            else
                Canvas.DrawText(Chr(0xD9));
            Canvas.Font = Font'EHUDFont';
        }
        else
        {
            Canvas.SetPos(xPos + BUTTON_NOISE_BOX_X_XBOX + 5, yPos - BUTTON_BOX_HEIGHT + 2);
            // Joshua - Default controller sceheme uses X/Square to make noise
            if (Epc.ControllerScheme == CS_Default)
                Canvas.DrawText("X");
            else
                Canvas.DrawText("B");
        }

        // Draw B button text
        Canvas.DrawColor = Black;
        Canvas.TextSize(Canvas.LocalizeStr("NOISE"), xLen, yLen);
        Canvas.SetPos(xPos + BUTTON_NOISE_BOX_X_XBOX  - xLen - 10, SCREEN_END_Y - BOTTOM_CAM_Y - (BUTTONBAR_HEIGHT / 2) - 6);
        Canvas.DrawText(Canvas.LocalizeStr("NOISE"));

        // Draw Y button (GAZ)
        Canvas.DrawColor = Green;
        if (EPC.ControllerIcon == CI_PlayStation) // Joshua - PlayStation controller prompts
        {
            Canvas.SetPos(xPos + BUTTON_GAS_BOX_X_XBOX + 5 - 2, yPos - BUTTON_BOX_HEIGHT + 2 - 1);
            Canvas.Font = Font'ETextFontPS2';
            Canvas.DrawText(Chr(0xDB));
            Canvas.Font = Font'EHUDFont';
        }
        else
        {
            Canvas.SetPos(xPos + BUTTON_GAS_BOX_X_XBOX + 5, yPos - BUTTON_BOX_HEIGHT + 2);
            Canvas.DrawText("Y");
        }

        // Draw Y button text
        Canvas.DrawColor = Black;
        Canvas.TextSize(Canvas.LocalizeStr("GAS"), xLen, yLen);
        Canvas.SetPos(xPos + BUTTON_GAS_BOX_X_XBOX - xLen - 10, SCREEN_END_Y - BOTTOM_CAM_Y - (BUTTONBAR_HEIGHT / 2) - 6);
        Canvas.DrawText(Canvas.LocalizeStr("GAS"));
        

        xPos = SCREEN_END_X - CAM_X - SIDEBAR_WIDTH;

        // Draw EXIT button
        Canvas.DrawColor = Green;
        Canvas.SetPos(xPos - BUTTON_EXIT_BOX_X + 5, yPos - BUTTON_BOX_HEIGHT + 2);
        // Joshua - Default controller sceheme allows B to exit
        if (EPC.ControllerScheme == CS_Default)
            Canvas.DrawText("B");
        else
            Canvas.DrawText("R");

        // Right EXIT text
        Canvas.DrawColor = Black;
        Canvas.TextSize(Canvas.LocalizeStr("EXIT"), xLen, yLen);	
        Canvas.SetPos(xPos - BUTTON_EXIT_BOX_X - xLen - 10, SCREEN_END_Y - BOTTOM_CAM_Y - (BUTTONBAR_HEIGHT / 2) - 6);
        Canvas.DrawText(Canvas.LocalizeStr("EXIT"));
    }
    else
    {
        // NOISE
        Canvas.DrawColor = Black;
        Canvas.TextSize(Canvas.LocalizeStr("NOISE"), xLen, yLen);
        Canvas.SetPos(xPos + BUTTON_NOISE_BOX_X - xLen, SCREEN_END_Y - BOTTOM_CAM_Y - (BUTTONBAR_HEIGHT / 2) - 6);
        Canvas.DrawText(Canvas.LocalizeStr("NOISE"));

        Canvas.DrawColor = Green;
        Canvas.SetPos(xPos + BUTTON_NOISE_BOX_X + 5, yPos - BUTTON_BOX_HEIGHT + 2);
        Canvas.DrawText("[" $ Caps(Localize("Keys","K_Interaction","Localization\\HUD")) $ "]");

        // GAZ
        Canvas.DrawColor = Black;
        Canvas.TextSize(Canvas.LocalizeStr("GAS"), xLen, yLen);
        Canvas.SetPos(xPos + BUTTON_GAS_BOX_X - xLen, SCREEN_END_Y - BOTTOM_CAM_Y - (BUTTONBAR_HEIGHT / 2) - 6);
        Canvas.DrawText(Canvas.LocalizeStr("GAS"));

        Canvas.DrawColor = Green;
        Canvas.SetPos(xPos + BUTTON_GAS_BOX_X + 5, yPos - BUTTON_BOX_HEIGHT + 2);
        Canvas.DrawText("[" $ Caps(Localize("Keys","K_AltFire","Localization\\HUD")) $ "]");

        xPos = SCREEN_END_X - CAM_X - SIDEBAR_WIDTH;

        // EXIT
        Canvas.DrawColor = Black;
        Canvas.TextSize(Canvas.LocalizeStr("EXIT"), xLen, yLen);	
        Canvas.SetPos(xPos - BUTTON_EXIT_BOX_X - xLen - 10, SCREEN_END_Y - BOTTOM_CAM_Y - (BUTTONBAR_HEIGHT / 2) - 6);
        Canvas.DrawText(Canvas.LocalizeStr("EXIT"));
        /*
        Canvas.DrawColor = Green;
        Canvas.TextSize(Localize("Keys","K_Fire","Localization\\HUD"), xLen, yLen);
        
        // Joshua - PS3 used this
        Canvas.SetPos(xPos - 20 + BUTTON_EXIT_BOX_X + 5, yPos - BUTTON_BOX_HEIGHT + 2);
        
        // PS3 removed this
        xPos = xPos - xLen - 5;
        Canvas.SetPos(xPos, yPos - BUTTON_BOX_HEIGHT + 2);
        

        Canvas.DrawText("[" $ Caps(Localize("Keys","K_Fire","Localization\\HUD")) $ "]");
        */
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

    TraceEnd = Location + (vector(Rotation) * 5000);
        
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

