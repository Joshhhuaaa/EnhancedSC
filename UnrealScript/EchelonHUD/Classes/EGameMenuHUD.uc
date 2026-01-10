 /******************************************************************************

 Class:         EGameMenuHUD

 Description:   Game Menu HUD

******************************************************************************/
class EGameMenuHUD extends EMenuHUD native;

/*-----------------------------------------------------------------------------
                        T Y P E   D E F I N I T I O N S
-----------------------------------------------------------------------------*/
const MAX_SECTION_TITLES = 4;
const NB_MISSION_NOISE_LINE = 6;

var int UCONST_NB_GAMEMENU_MAINMENU_SECTION;

/*-----------------------------------------------------------------------------
                        M E M B E R   V A R I A B L E S
-----------------------------------------------------------------------------*/
var int MenuSection;        // 0 = Inventory, 1 = Goals And Notes, 2 = MainMenu
var int TitleSection;
var int SubTitleSection;


// Main Menu //
var int MainMenuDepth;
var bool bGameMainMenu;
var bool bFinalMap;
var EGameMainMenuHUD GameMainMenuHUD;
var int TitleSectionMainMenu;

// GameInfo Menu //
var int GoalCurScroll;
var int GoalNbScroll;
var int NoteCurScroll;
var int NoteNbScroll;
var bool bComputeScroll;
var int TitleSectionGameInfo;

var string szSectionTitles[MAX_SECTION_TITLES];
var string szSubSectionTitles[MAX_SECTION_TITLES];

// Inventory Menu //
var	EInventory	 EpcInventory;
var eInvCategory CurrentCategory;
var int ItemPos;
var int InvMenuDepth;
var int TitleSectionInv;    // (Yanick Mimee) June-13-2002
var bool bCheckVideo;
var bool bErrorIsCatch;
var bool bShowDesc;
var int  HowToUseScrollPos;
var int  HowToUseScrollMaxPos;

// Mission Failed//
var int missionFilterAlpha;
var float missionFilterTimer;
var float missionNoiseLineX[NB_MISSION_NOISE_LINE];
var float missionNoiseLineY[NB_MISSION_NOISE_LINE];
var int missionLinesAlpha;
var float missionTextScale;
var float missionTextScaleX;
var float missionTextScaleY;

// Training Failed and Complete//
var int blackAlpha;
var float blackAlphaTimer;
var bool  bIncrease;
var bool bDrawSaveMission;
var bool bStartTimer;
var float fDisplayTime;
var bool bSkipFrame;

// training //
var int TrainingDepth;

// (Yanick Mimee) June-17-2002
var bool bGadgetVideoIsPlaying; // flag to know that a video is playing
var string sVideoName; // Name of the video currently playing
var EInventoryItem CurrentItem;

var int  iNbrOfRecon;          // Nbr of recon in the list
var int  iNbrOfReconSpot;      // How many recon name we can put in the box
var bool bNbrOfSpotIsFound;    // Flag (see line above)
var bool bNeedToDrawScrollBar; // Flag to determine if we draw the SB or not
var int  iIndexReconScroll;    // To display the cursor.
var int  iIndexRecon;          // To know where we are in the list of recon?
var bool bScrollUp;            // Scrolling up
var bool bScrollDown;          // Scrolling down
var int iStartPos;
var int iOldStartPos;
var int iEndPos;
var int iOldEndPos;
var bool bReconSelected;       // Player has selected a RECON from the list

var ERecon tCurrentRecon;   // To save the current Recon pic
var int iIndexCurRoom;
var int ReconDescScrollPos;
var int ReconDescMaxPos;

// Error messages
var int iErrorType;

// Mission Failed and Succeed
var bool bMissionFailedToMenu;
var int  iNbrOfLetter;
var bool bGameIsFinished;
var string MissionFailedMsg;

// GameInfo
var bool bInsideSubMenu;

/*-----------------------------------------------------------------------------
                                M E T H O D S
-----------------------------------------------------------------------------*/
native(1179) final function CheckFinalMap();

// s_QuickSave //
native(1751) final function BeginState_s_QuickSave();
native(1752) final function bool KeyEvent_s_QuickSave(string Key, EInputAction Action, FLOAT Delta);
native(1753) final function PostRender_s_QuickSave(ECanvas Canvas);

// s_QuickLoad //
native(1754) final function BeginState_s_QuickLoad();
native(1755) final function bool KeyEvent_s_QuickLoad(string Key, EInputAction Action, FLOAT Delta);
native(1756) final function PostRender_s_QuickLoad(ECanvas Canvas);

// s_Inventory //
native(2310) final function BeginState_s_Inventory();
native(2311) final function bool KeyEvent_s_Inventory(string Key, EInputAction Action, FLOAT Delta);
native(2312) final function PostRender_s_Inventory(ECanvas Canvas);
native(2400) final function EndState_s_Inventory();

// s_GameInfo //
native(2313) final function BeginState_s_GameInfo();
native(2314) final function bool KeyEvent_s_GameInfo(string Key, EInputAction Action, FLOAT Delta);
native(2315) final function PostRender_s_GameInfo(ECanvas Canvas);

// s_MainMenu //
native(2319) final function BeginState_s_MainMenu();
native(2320) final function bool KeyEvent_s_MainMenu(string Key, EInputAction Action, FLOAT Delta);
native(2321) final function PostRender_s_MainMenu(ECanvas Canvas);

// s_Training //
native(2337) final function BeginState_s_Training();
native(2336) final function bool KeyEvent_s_Training(string Key, EInputAction Action, FLOAT Delta);
native(2329) final function PostRender_s_Training(ECanvas Canvas);

// s_MissionFailed //
native(2330) final function BeginState_s_MissionFailed();
native(1780) final function bool KeyEvent_s_MissionFailed(string Key, EInputAction Action, FLOAT Delta);
native(2331) final function PostRender_s_MissionFailed(ECanvas Canvas);
native(2332) final function Tick_s_MissionFailed(float DeltaTime);

// s_MissionComplete //
native(2333) final function BeginState_s_MissionComplete();
native(1781) final function bool KeyEvent_s_MissionComplete(string Key, EInputAction Action, FLOAT Delta);
native(2334) final function PostRender_s_MissionComplete(ECanvas Canvas);
native(2335) final function Tick_s_MissionComplete(float DeltaTime);


/*-----------------------------------------------------------------------------
     Function:      PostBeginPlay

     Description:
-----------------------------------------------------------------------------*/
function PostBeginPlay()
{
    Super.PostBeginPlay();
    GameMainMenuHUD = spawn(class'EGameMainMenuHUD',self);

    EpcInventory = Epc.ePawn.FullInventory;
	if (EpcInventory == None)
		Log("Problem to get player inventory in Game Menu HUD.");
}

/*-----------------------------------------------------------------------------
 Function:      DrawConfirmationBox

 Description:   Joshua - Draws a wider confirmation dialog box with Yes/No options
-----------------------------------------------------------------------------*/
function DrawConfirmationBox(ECanvas Canvas, string sMessage)
{
	local int xPos, yPos, iNbrOfLine, iBoxHeight, iBoxWidth;
	local float xLen, yLen;
	local int yesX, yesY, yesW, yesH;
	local int noX, noY, noW, noH;
	local int oldSelection;

	iBoxWidth = 400;

	Canvas.Font = Canvas.ETextFont;
	Canvas.SetClip(iBoxWidth - 100, yLen);
	Canvas.SetPos(0, 0);
	Canvas.TextSize(sMessage, xLen, yLen);
	iNbrOfLine = Canvas.GetNbStringLines(sMessage, 1.0f);
	Canvas.SetClip(640, 480);

	iBoxHeight = (iNbrOfLine * yLen) + 80; // Extra space for Yes/No buttons

	xPos = 320 - iBoxWidth / 2;
	yPos = 240 - iBoxHeight / 2;

	// Yes/No button regions
	yesX = xPos + (iBoxWidth / 4) - 50;
	yesY = yPos + iBoxHeight - 40;
	yesW = 100;
	yesH = 40;

	noX = xPos + (iBoxWidth * 3 / 4) - 50;
	noY = yPos + iBoxHeight - 40;
	noW = 100;
	noH = 40;

	// Check mouse hover for Yes/No buttons
	if (!Epc.eGame.bUseController)
	{
		oldSelection = int(Epc.bMissionFailedConfirmYes);

		if (Epc.m_FakeMouseX > yesX && Epc.m_FakeMouseX < yesX + yesW &&
			Epc.m_FakeMouseY > yesY && Epc.m_FakeMouseY < yesY + yesH)
		{
			if (!Epc.bMissionFailedConfirmYes)
				Epc.Pawn.PlaySound(Sound'Interface.Play_ActionChoice', SLOT_Interface);
			Epc.bMissionFailedConfirmYes = true;
		}
		else if (Epc.m_FakeMouseX > noX && Epc.m_FakeMouseX < noX + noW &&
				 Epc.m_FakeMouseY > noY && Epc.m_FakeMouseY < noY + noH)
		{
			if (Epc.bMissionFailedConfirmYes)
				Epc.Pawn.PlaySound(Sound'Interface.Play_ActionChoice', SLOT_Interface);
			Epc.bMissionFailedConfirmYes = false;
		}
	}

	Canvas.Style = ERenderStyle.STY_Alpha;

    // FILL BACKGROUND //
    Canvas.DrawLine(xPos + 2, yPos + 2, iBoxWidth - 4, iBoxHeight - 4, Canvas.white, -1, eLevel.TGAME);

    Canvas.SetDrawColor(128, 128, 128);

    // CORNERS //
    // TOP LEFT CORNER //
    Canvas.SetPos(xPos, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin1, 8, 7, 0, 7, 8, -7);

    // BOTTOM LEFT CORNER //
    Canvas.SetPos(xPos, yPos + iBoxHeight - 7);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin1, 8, 7, 0, 0, 8, 7);

    // TOP RIGHT CORNER //
    Canvas.SetPos(xPos + iBoxWidth - 8, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin1, 8, 7, 8, 7, -8, -7);

    // BOTTOM RIGHT CORNER //
    Canvas.SetPos(xPos + iBoxWidth - 8, yPos + iBoxHeight - 7);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_coin1, 8, 7, 8, 0, -8, 7);

    // OUTSIDE BORDERS //

    // TOP BORDER //
    Canvas.SetPos(xPos + 8, yPos);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_h, iBoxWidth - 16, 6, 0, 6, 1, -6);

    // BOTTOM BORDER //
    Canvas.SetPos(xPos + 8, yPos + iBoxHeight - 6);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_h, iBoxWidth - 16, 6, 0, 0, 1, 6);

    // LEFT BORDER //
    Canvas.SetPos(xPos, yPos + 7);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_v, 5, iBoxHeight - 14, 0, 0, 5, 1);

    // RIGHT BORDER //
    Canvas.SetPos(xPos + iBoxWidth - 5, yPos + 7);
    eLevel.TGAME.DrawTileFromManager(Canvas, eLevel.TGAME.qi_bord_v, 5, iBoxHeight - 14, 5, 0, -5, 1);

    // INSIDE BORDERS //
    Canvas.DrawRectangle(xPos + 5, yPos + 6, iBoxWidth - 10, iBoxHeight - 12, 1, Canvas.black, 77, eLevel.TGAME);

	Canvas.SetDrawColor(64, 64, 64, 255);
    Canvas.Style = ERenderStyle.STY_Modulated;

    Canvas.SetPos(xPos + 5, yPos + 6);
    Canvas.DrawTile(Texture'HUD.HUD.ETMenuBar', iBoxWidth - 10, iBoxHeight - 12, 0, 0, 128, 2);

	// Draw message text
	Canvas.SetDrawColor(128, 128, 128, 255);
	Canvas.DrawColor = Canvas.TextBlack;
	Canvas.SetClip(iBoxWidth - 100, yLen);
	Canvas.SetPos(xPos + (iBoxWidth / 2), yPos + 25);
	Canvas.DrawTextAligned(sMessage, TXT_CENTER);
	Canvas.SetClip(640, 480);

	// Draw Yes/No options
	Canvas.Font = Canvas.ETextFont;

	// Yes option
	Canvas.SetPos(xPos + (iBoxWidth / 4), yPos + iBoxHeight - 30);
	if (Epc.bMissionFailedConfirmYes)
		Canvas.SetDrawColor(92, 109, 76, 255); // Highlighted green
	else
		Canvas.SetDrawColor(64, 64, 64, 255); // Darker gray
	Canvas.DrawTextAligned(Localize("HUD", "Yes", "Localization\\HUD"), TXT_CENTER);

	// No option
	Canvas.SetPos(xPos + (iBoxWidth * 3 / 4), yPos + iBoxHeight - 30);
	if (!Epc.bMissionFailedConfirmYes)
		Canvas.SetDrawColor(92, 109, 76, 255); // Highlighted green
	else
		Canvas.SetDrawColor(64, 64, 64, 255); // Darker gray
	Canvas.DrawTextAligned(Localize("HUD", "No", "Localization\\HUD"), TXT_CENTER);

	Canvas.Style = ERenderStyle.STY_Normal;
}

/*-----------------------------------------------------------------------------
 Function:      IsMouseInConfirmButton

 Description:   Joshua - Checks if mouse is within Yes or No button region
-----------------------------------------------------------------------------*/
function int IsMouseInConfirmButton(ECanvas Canvas)
{
	local int iBoxWidth, iBoxHeight, iNbrOfLine;
	local int xPos, yPos;
	local int yesX, yesY, yesW, yesH;
	local int noX, noY, noW, noH;
	local float xLen, yLen;
	local string sMessage;

	iBoxWidth = 400;

	// Get the message text to calculate height
	if (Epc.iMissionFailedConfirmAction == 1)
		sMessage = Localize("MissionFailed", "RestartMission_Confirm", "Localization\\Enhanced");
	else
		sMessage = Localize("MissionFailed", "Quit_Confirm", "Localization\\Enhanced");

	// Calculate box height
	Canvas.Font = Canvas.ETextFont;
	Canvas.SetClip(iBoxWidth - 100, yLen);
	Canvas.SetPos(0, 0);
	Canvas.TextSize(sMessage, xLen, yLen);
	iNbrOfLine = Canvas.GetNbStringLines(sMessage, 1.0f);
	Canvas.SetClip(640, 480);

	iBoxHeight = (iNbrOfLine * yLen) + 80;

	xPos = 320 - iBoxWidth / 2;
	yPos = 240 - iBoxHeight / 2;

	// Calculate button regions
	yesX = xPos + (iBoxWidth / 4) - 50;
	yesY = yPos + iBoxHeight - 40;
	yesW = 100;
	yesH = 40;

	noX = xPos + (iBoxWidth * 3 / 4) - 50;
	noY = yPos + iBoxHeight - 40;
	noW = 100;
	noH = 40;

	// Check if mouse is in Yes button
	if (Epc.m_FakeMouseX > yesX && Epc.m_FakeMouseX < yesX + yesW &&
		Epc.m_FakeMouseY > yesY && Epc.m_FakeMouseY < yesY + yesH)
	{
		return 1; // Yes button
	}
	// Check if mouse is in No button
	else if (Epc.m_FakeMouseX > noX && Epc.m_FakeMouseX < noX + noW &&
			 Epc.m_FakeMouseY > noY && Epc.m_FakeMouseY < noY + noH)
	{
		return 2; // No button
	}

	return 0; // None
}

/*-----------------------------------------------------------------------------
 Function:      GetInputPrompt

 Description:   Joshua - Returns localized input prompt string for keyboard or controller
-----------------------------------------------------------------------------*/
function string GetInputPrompt(int ButtonType)
{
	local string ButtonName;

    // Chr(0xFD) = Square
    // Chr(0xDA) = Cross
    // Chr(0xD9) = Circle
    // Chr(0xDB) = Triangle

	if (Epc.eGame.bUseController)
	{
		// Controller - use button names based on controller type
		switch (ButtonType)
		{
			case 0: // Cross / A
				if (Epc.ControllerIcon == CI_PlayStation)
					ButtonName = Chr(0xDA);
				else // Xbox, GameCube
					ButtonName = "A";
				break;
			case 1: // Triangle / Y
				if (Epc.ControllerIcon == CI_PlayStation)
					ButtonName = Chr(0xDB);
				else // Xbox, GameCube
					ButtonName = "Y";
				break;
			case 2: // Circle / B
				if (Epc.ControllerIcon == CI_PlayStation)
					ButtonName = Chr(0xD9);
				else // Xbox, GameCube
					ButtonName = "B";
				break;
			case 3: // Square / X
				if (Epc.ControllerIcon == CI_PlayStation)
					ButtonName = Chr(0xFD);
				else // Xbox, GameCube
					ButtonName = "X";
				break;
		}
	}
	else
	{
		// Keyboard - use localized key names
		switch (ButtonType)
		{
			case 0: // Space
				ButtonName = Caps(Localize("Interactions", "IK_Space", "Localization\\HUD"));
				break;
			case 1: // LeftMouse
				ButtonName = Caps(Localize("Interactions", "IK_LeftMouse", "Localization\\HUD"));
				break;
			case 2: // Escape
				ButtonName = Caps(Localize("Interactions", "IK_Escape", "Localization\\HUD"));
				break;
			case 3: // Enter
				ButtonName = Caps(Localize("Interactions", "IK_Enter", "Localization\\HUD"));
				break;
		}
	}

	return ButtonName;
}

/*-----------------------------------------------------------------------------
 Function:      FormatPromptString

 Description:   Replaces {0} in localized string with the button/key name
-----------------------------------------------------------------------------*/
function string FormatPromptString(string LocalizedString, string ButtonName)
{
	local int pos;

	pos = InStr(LocalizedString, "{0}");
	if (pos >= 0)
		return Left(LocalizedString, pos) $ ButtonName $ Mid(LocalizedString, pos + 3);

	return LocalizedString;
}

/*-----------------------------------------------------------------------------
 Function:      OwnerGotoStateSafe

 Description:   Be able to switch owner state in c++
-----------------------------------------------------------------------------*/
event OwnerGotoStateSafe(name newState)
{
	if (newState == '')
		newState = EchelonMainHUD(owner).RestoreState();
    EchelonMainHUD(owner).GotoState(newState);
}


/*=============================================================================
 State :        s_QuickSave
=============================================================================*/

state s_QuickSave
{
    function bool KeyEvent(string Key, EInputAction Action, FLOAT Delta) {return KeyEvent_s_QuickSave(Key, Action, Delta);}

	function PostRender(ECanvas Canvas)	{PostRender_s_QuickSave(Canvas);}

    function BeginState() {BeginState_s_QuickSave();}
}

/*=============================================================================
 State :        s_QuickLoad
=============================================================================*/

state s_QuickLoad
{
    function bool KeyEvent(string Key, EInputAction Action, FLOAT Delta) {return KeyEvent_s_QuickLoad(Key, Action, Delta);}

	function PostRender(ECanvas Canvas)	{PostRender_s_QuickLoad(Canvas);}

    function BeginState() {BeginState_s_QuickLoad();}
}


/*=============================================================================
 State :        s_Inventory
=============================================================================*/
auto state s_Inventory
{
/*
	function PostRender(ECanvas Canvas)	{PostRender_s_Inventory(Canvas);}

    function bool KeyEvent(string Key, EInputAction Action, FLOAT Delta) {return KeyEvent_s_Inventory(Key, Action, Delta);}

    function BeginState() {BeginState_s_Inventory();}

	function EndState() {EndState_s_Inventory();}
*/
}

/*=============================================================================
 State :        s_GameInfo
=============================================================================*/
state s_GameInfo
{
    function bool KeyEvent(string Key, EInputAction Action, FLOAT Delta) {return KeyEvent_s_GameInfo(Key, Action, Delta);}

	function PostRender(ECanvas Canvas)	{PostRender_s_GameInfo(Canvas);}

    function BeginState() {BeginState_s_GameInfo();}
}

/*=============================================================================
 State :        s_MainMenu
=============================================================================*/
state s_MainMenu
{
    function bool KeyEvent(string Key, EInputAction Action, FLOAT Delta) {return KeyEvent_s_MainMenu(Key, Action, Delta);}

	function PostRender(ECanvas Canvas)	{PostRender_s_MainMenu(Canvas);}

    function BeginState() {BeginState_s_MainMenu();}
}

/*=============================================================================
 State :        s_Training
=============================================================================*/
state s_Training
{
    function bool KeyEvent(string Key, EInputAction Action, FLOAT Delta) {return KeyEvent_s_Training(Key, Action, Delta);}

	function PostRender(ECanvas Canvas)	{PostRender_s_Training(Canvas);}

    function BeginState() {BeginState_s_Training();}
}

/*=============================================================================
 State :        s_MissionFailed
=============================================================================*/
state s_MissionFailed
{
	function bool KeyEvent(string Key, EInputAction Action, FLOAT Delta) {return KeyEvent_s_MissionFailed(Key, Action, Delta);}

	function PostRender(ECanvas Canvas)
    {
        local float yPos, lineHeight;
        local float xOffset;
        local string CurrentRes;
        local int i, ResX, ResY;
        local float AspectRatio;
        local string PromptText;
        local string ConfirmMsg;
        local float boxWidth, boxHeight, boxX, boxY;

        PostRender_s_MissionFailed(Canvas);

        if (Epc.bMissionFailedQuickMenu && !Epc.eGame.bPermadeathMode && Epc.MissionQuickMenuAlpha > 0)
        {
            // Joshua - Draw controller prompt options at bottom of screen
            lineHeight = 16;
            yPos = 390;

            // Joshua - For wider aspect ratios, we need to draw into negative X space
            xOffset = 0;
            CurrentRes = Epc.ConsoleCommand("GETCURRENTRES");
            i = InStr(CurrentRes, "x");
            if (i > 0)
            {
                ResX = int(Left(CurrentRes, i));
                ResY = int(Mid(CurrentRes, i + 1));
                AspectRatio = float(ResX) / float(ResY);
                // Joshua - 4:3 = 1.333
                if (AspectRatio > 1.334)
                    xOffset = -((AspectRatio - 1.333) * 480.0 / 2.0);
            }

            Canvas.DrawLine(xOffset - 1, yPos - 3, Canvas.SizeX + 1, (lineHeight * 4) + 6, Canvas.black, int(100.0 * (Epc.MissionQuickMenuAlpha / 255.0)), eLevel.TMENU);

            Canvas.Font = Canvas.ETextFont;
            Canvas.SetDrawColor(255, 255, 255, Epc.MissionQuickMenuAlpha);

            Canvas.SetPos(320, yPos);
            if (Epc.LastSaveName == (Localize("Common", "CheckpointName", "Localization\\Enhanced") $ "1") ||
                Epc.LastSaveName == (Localize("Common", "CheckpointName", "Localization\\Enhanced") $ "2") ||
                Epc.LastSaveName == (Localize("Common", "CheckpointName", "Localization\\Enhanced") $ "3"))
                PromptText = FormatPromptString(Localize("HUD", "LoadLastCheckpoint", "Localization\\Enhanced"), GetInputPrompt(0));
            else
                PromptText = FormatPromptString(Localize("HUD", "LoadLastSave", "Localization\\Enhanced"), GetInputPrompt(0));
            Canvas.DrawTextAligned(PromptText, TXT_CENTER);

            Canvas.SetPos(320, yPos + lineHeight);
            PromptText = FormatPromptString(Localize("HUD", "LoadGame", "Localization\\Enhanced"), GetInputPrompt(1));
            Canvas.DrawTextAligned(PromptText, TXT_CENTER);

            Canvas.SetPos(320, yPos + (lineHeight * 2));
            PromptText = FormatPromptString(Localize("HUD", "RestartMission", "Localization\\Enhanced"), GetInputPrompt(3));
            Canvas.DrawTextAligned(PromptText, TXT_CENTER);

            Canvas.SetPos(320, yPos + (lineHeight * 3));
            PromptText = FormatPromptString(Localize("HUD", "Quit", "Localization\\Enhanced"), GetInputPrompt(2));
            Canvas.DrawTextAligned(PromptText, TXT_CENTER);

            // Joshua - Draw confirmation overlay if needed
            if (Epc.bMissionFailedShowConfirmation)
            {
                // Joshua - Dim background
                Canvas.DrawLine(xOffset - 1, 0, Canvas.SizeX + 1, 480, Canvas.black, 150, eLevel.TMENU);

                if (Epc.iMissionFailedConfirmAction == 1)
                    ConfirmMsg = Localize("HUD", "ConfirmRestart", "Localization\\Enhanced");
                else if (Epc.iMissionFailedConfirmAction == 2)
                    ConfirmMsg = Localize("HUD", "ConfirmQuit", "Localization\\Enhanced");

                // Joshua - Draw the custom confirmation box with Yes/No options
                DrawConfirmationBox(Canvas, ConfirmMsg);
            }
        }
    }

    function BeginState()
    {
        Epc.MissionQuickMenuTimer = 0.0;
        Epc.MissionQuickMenuAlpha = 0;
        BeginState_s_MissionFailed();
    }

    function Tick(float DeltaTime)
    {
        local int buttonRegion;
        local ECanvas Canvas;

        Canvas = ECanvas(class'Actor'.static.GetCanvas());

        // Joshua - Update quick menu timer and alpha for fade-in effect
        if (Epc.bMissionFailedQuickMenu)
        {
            Epc.MissionQuickMenuTimer += DeltaTime;

            if (Epc.MissionQuickMenuTimer < 2.0)
            {
                // Joshua - Still in the 2 second delay, keep alpha at 0
                Epc.MissionQuickMenuAlpha = 0;
            }
            else if (Epc.MissionQuickMenuTimer < 2.5)
            {
                // Joshua - Fade in over 0.5 seconds (from 2.0 to 2.5)
                Epc.MissionQuickMenuAlpha = int(((Epc.MissionQuickMenuTimer - 2.0) / 0.5) * 255.0);
            }
            else
            {
                Epc.MissionQuickMenuAlpha = 255;
            }
        }

        // Joshua - Handle mouse clicks in confirmation dialog
        if (Epc.bMissionFailedShowConfirmation && Epc.m_FakeMouseClicked)
        {
            // Joshua - Check which button the mouse is actually clicking on
            buttonRegion = IsMouseInConfirmButton(Canvas);

            if (buttonRegion == 1)
            {
                // Clicked Yes button
                Epc.FakeMouseToggle(false);
                Epc.EPawn.PlaySound(Sound'Interface.Play_ActionChoice', SLOT_Interface);

                if (Epc.iMissionFailedConfirmAction == 1)
                {
                    Epc.bMissionFailedQuickMenu = false;
                    Epc.RestartMission();
                }
                else if (Epc.iMissionFailedConfirmAction == 2)
                {
                    Epc.bMissionFailedQuickMenu = false;
                    Epc.QuitToMainMenu();
                }
            }
            else if (buttonRegion == 2)
            {
                // Clicked No button
                Epc.FakeMouseToggle(false);
                Epc.EPawn.PlaySound(Sound'Interface.Play_ActionChoice', SLOT_Interface);
                Epc.bMissionFailedShowConfirmation = false;
                Epc.iMissionFailedConfirmAction = 0;
            }

            Epc.m_FakeMouseClicked = false;
        }

        Tick_s_MissionFailed(DeltaTime);
    }

// Joshua - s_MissionFailed is handled in C++, so its behavior can't be changed in UnrealScript.
// The game transitions to the menus after 13 seconds, so we reset the timer to allow the player to make a choice.
Begin:
    if (Epc.bMissionFailedQuickMenu && !Epc.eGame.bPermadeathMode)
    {
        while (true)
        {
            Sleep(12.9);
            missionFilterTimer = 0;
        }
    }
    Stop;

// Joshua - Load last save
LoadLastSave:
    Epc.bLoadingTraining = true; // Display QuickLoad box
    Sleep(0.1);
    Epc.LoadLastSave();
    Stop;
}

/*=============================================================================
 State :        s_MissionComplete
=============================================================================*/
state s_MissionComplete
{
	function bool KeyEvent(string Key, EInputAction Action, FLOAT Delta) {return KeyEvent_s_MissionComplete(Key, Action, Delta);}

	function PostRender(ECanvas Canvas)	{PostRender_s_MissionComplete(Canvas);}

    function BeginState() {BeginState_s_MissionComplete();}

    function Tick(float DeltaTime) { Tick_s_MissionComplete(DeltaTime);}

// Joshua - s_MissionComplete is handled in C++, so its behavior can't be changed in UnrealScript.
// The game transitions to the next level after 13 seconds, so we reset the timer to allow the player to view their Player Statistics until a key press.
Begin:
    if (Epc.PlayerStatsMode != SM_Disabled)
    {
        while (true)
        {
            Sleep(12.9);
            missionFilterTimer = 0;
        }
    }
}

/*=============================================================================
 State :        s_TrainingFailed
=============================================================================*/
state s_TrainingFailed
{
	function PostRender(ECanvas Canvas)
    {
        Canvas.DrawLine(0, 0, 640, 480, Canvas.black, blackAlpha, TGAME);
    }

    function BeginState()
    {
        bIncrease = true;
        blackAlpha = 0;
        blackAlphaTimer = 0.0f;
    }

    function Tick(float DeltaTime)
    {
        blackAlphaTimer += DeltaTime;

        if (bIncrease)
        {
            if (blackAlphaTimer < 1.5f)
            {
                blackAlpha = 255.0f * (blackAlphaTimer / 1.5f);
            }
            else if (blackAlphaTimer > 2.5f)
            {
                bIncrease = false;
                blackAlphaTimer = 0.0f;
            }
            else
            {
                blackAlpha = 255.0f;
            }
        }
        else
        {
            if (blackAlphaTimer < 1.5)
            {
                blackAlpha = 255.0f * (1.0f - (blackAlphaTimer / 1.5f));
            }
            else
            {
                blackAlpha = 0.0f;
                OwnerGotoStateSafe('MainHUD');
            }
        }
    }
}


