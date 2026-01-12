//=============================================================================
//  EPCInGameDataDetailsMenu.uc : Full screen description of a recon
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/07 * Created by Alexandre Dionne
//=============================================================================
class EPCInGameDataDetailsMenu extends EPCMenuPage
			native;

#exec OBJ LOAD FILE=..\Textures\HUD_Enhanced.utx

var EPCTextButton   m_Return;
var INT             m_IReturnButtonsXPos, m_IReturnButtonsHeight, m_IReturnButtonsWidth, m_IReturnButtonsYPos;

var ERecon	        m_Recon;

var   EPCVScrollBar m_ScrollBar;
var   BOOL          m_BInitScrollBar;

var INT             m_INbScroll, m_INbLinesDisplayed;

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

// Joshua - Map coordinate navigation for controller
var int   m_currentMapCoordIndex;  // Current coordinate index when navigating maps with controller
var bool  m_bMapCursorInitialized; // Whether we've initialized cursor position for this map view

// Joshua - Track if we got here via QuickView (pressing pause while data notification showing)
var bool  m_bFromQuickView;

function Created()
{
	SetAcceptsFocus();
    m_Return  = EPCTextButton(CreateControl(class'EPCTextButton', m_IReturnButtonsXPos, m_IReturnButtonsYPos, m_IReturnButtonsWidth, m_IReturnButtonsHeight, self));
    m_Return.SetButtonText(Caps(Localize("HUD","BACK","Localization\\HUD")) ,TXT_CENTER);
    m_Return.Font = F_Normal;

    m_ScrollBar =  EPCVScrollBar(CreateWindow(class'EPCVScrollBar', 561, 95, LookAndFeel.Size_ScrollbarWidth, 244));

}

function SetDataInfo(ERecon Recon)
{
    m_Recon = Recon;

    // Joshua - Mark this recon as read when viewing details
    if (m_Recon != None)
        m_Recon.bIsRead = true;

    if (m_Recon.ReconType == 4 || m_Recon.ReconType == 5) //Text Full screen
	{
        m_BInitScrollBar = true;
		m_ScrollBar.pos = 0;
	}
    else
    {
        m_ScrollBar.HideWindow();
    }

    // Joshua - Reset map cursor state when new data is set
    m_currentMapCoordIndex = 0;
    m_bMapCursorInitialized = false;

    // Joshua - Reset QuickView flag (will be set to true by GoToDataDetails if applicable)
    m_bFromQuickView = false;
}

// Joshua - Override ShowWindow to initialize map cursor position for controller mode
function ShowWindow()
{
    Super.ShowWindow();

    // Reset initialization flag so cursor will be positioned when Paint is called
    m_bMapCursorInitialized = false;
}

function HideWindow()
{
    Super.HideWindow();
    m_Recon = None;
}

function EscapeMenu()
{
	// Joshua - Don't play click sound when returning to game from QuickView
	if (!m_bFromQuickView)
		Root.PlayClickSound();

	Notify(m_Return, DE_Click);
}

function Paint(Canvas C, float MouseX, float MouseY)
{
    Render(C , MouseX, MouseY);

    if (m_BInitScrollBar)
    {
        if (m_INbScroll > m_INbLinesDisplayed)
        {
            m_ScrollBar.ShowWindow();
            m_ScrollBar.SetRange(0, m_INbScroll,m_INbLinesDisplayed);
        }
        else
            m_ScrollBar.HideWindow();

        m_BInitScrollBar= false;
    }

    // Joshua - Draw controller prompts and hide PC button in controller mode
    if (EPCMainMenuRootWindow(Root).m_bControllerModeActive)
    {
        m_Return.HideWindow();
        DrawControllerPrompts(C);

        // Joshua - Initialize map cursor position when viewing a map in controller mode
        // Mouse cursor stays hidden, position it invisibly so the map locations work
        if (m_Recon != None && m_Recon.ReconType == 2 && m_Recon.NbrOfCoord > 0)
        {
            if (!m_bMapCursorInitialized)
            {
                // Restore last controller position (defaults to 0 if never used)
                MoveMouseToMapCoord(m_currentMapCoordIndex);
                m_bMapCursorInitialized = true;
            }
        }
    }
    else
    {
        m_Return.ShowWindow();
        // Joshua - Update button text based on whether we came from QuickView
        if (m_bFromQuickView)
            m_Return.SetButtonText(Caps(Localize("HUD","BACK_TO_GAME","Localization\\HUD")), TXT_CENTER);
        else
            m_Return.SetButtonText(Caps(Localize("HUD", "BACK", "Localization\\HUD")), TXT_CENTER);
        // Joshua - Reset initialization flag when leaving controller mode
        // so cursor will be repositioned when returning to controller
        m_bMapCursorInitialized = false;
    }
}

// Joshua - Draw controller button prompts (B Back only on detail pages)
function DrawControllerPrompts(Canvas C)
{
    local EchelonLevelInfo eLevel;
    local EPlayerController EPC;
    local float PromptX, PromptY;
    local float IconSize;
    local string PromptText;
    local Color IconColor;
    local Color TextColor;

    eLevel = EchelonLevelInfo(GetLevel());
    if (eLevel == None || eLevel.TMENU == None)
        return;

    EPC = EPlayerController(GetPlayerOwner());

    IconSize = 22;
    PromptY = m_IReturnButtonsYPos - 2;
    PromptX = 68;

    IconColor.R = 128;
    IconColor.G = 128;
    IconColor.B = 128;
    IconColor.A = 255;

    TextColor.R = 71;
    TextColor.G = 71;
    TextColor.B = 71;
    TextColor.A = 255;

    C.Font = Root.Fonts[F_Normal];

    // (B) Back
    C.DrawColor = IconColor;
    C.SetPos(PromptX, PromptY);
    switch (EPC.ControllerIcon)
    {
        case CI_PlayStation:
            C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.PS2_Circle', IconSize, IconSize, 3, 3, 26, 26);
            break;
        case CI_GameCube:
            C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.GameCube_B', IconSize, IconSize, 3, 3, 26, 26);
            break;
        default: // CI_Xbox or CI_None
            C.DrawTile(Texture'HUD.HUD.ETMENU', IconSize, IconSize, 139, 0, 22, 22);
            break;
    }
    PromptX += IconSize + 8;
    C.DrawColor = TextColor;
    C.SetPos(PromptX, PromptY + 3);
    // Joshua - Show "Back to Game" when from QuickView, otherwise just "Back"
    //if (m_bFromQuickView)
       //m_Return.SetButtonText(Caps(Localize("HUD","BACK_TO_GAME","Localization\\HUD")), TXT_CENTER);
    //else
        PromptText = Caps(Localize("HUD", "Back", "Localization\\HUD"));
    C.DrawText(PromptText);
}

function MouseWheelDown(FLOAT X, FLOAT Y)
{
    if (m_ScrollBar != None)
	    m_ScrollBar.MouseWheelDown(X,Y);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
    if (m_ScrollBar != None)
        m_ScrollBar.MouseWheelUp(X,Y);
}

// Joshua - Move mouse cursor to a specific map coordinate index
function MoveMouseToMapCoord(int CoordIndex)
{
    local float TargetX, TargetY;

    if (m_Recon == None || m_Recon.ReconType != 2)
        return;
    if (CoordIndex < 0 || CoordIndex >= m_Recon.NbrOfCoord)
        return;

    // Get the coordinate position from the recon data
    TargetX = m_Recon.ReconDynMapArray[CoordIndex].x;
    TargetY = m_Recon.ReconDynMapArray[CoordIndex].y;

    // Use SetMousePos which sets Console.MouseX/MouseY
    Root.SetMousePos(TargetX, TargetY);
    // Update Root's MouseX/MouseY to stay in sync
    Root.MouseX = TargetX;
    Root.MouseY = TargetY;
}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    Super.WindowEvent(Msg, C, X, Y, Key);

    // Track key releases for auto-repeat
    if (Msg == WM_KeyUp)
    {
        if (Key == m_heldKey)
        {
            m_heldKey = 0;
            m_keyHoldTime = 0;
            m_nextRepeatTime = 0;
        }
        return;
    }

    if (Msg == WM_KeyDown)
    {
        // B button
        if (Key == 201)
        {
            // Joshua - Don't play click sound when returning to game from QuickView
            if (!m_bFromQuickView)
                Root.PlayClickSound();
            Notify(m_Return, DE_Click);
            return;
        }

        // Track repeatable keys (directional keys only)
        if (Key == 212 || Key == 196 || Key == 213 || Key == 197 ||
            Key == 214 || Key == 198 || Key == 215 || Key == 199)
        {
            if (Key != m_heldKey)
            {
                m_heldKey = Key;
                m_keyHoldTime = 0;
                m_nextRepeatTime = m_initialDelay;
            }
        }

        HandleKeyAction(Key);
    }
}

// Joshua - Process a key action (called on initial press and during auto-repeat)
function HandleKeyAction(int Key)
{
    // Check if this is a text/datastick (scroll up/down)
    if (m_Recon != None && (m_Recon.ReconType == 4 || m_Recon.ReconType == 5))
    {
        // Text/Datastick - scroll up/down
        // Up
        if (Key == 212 || Key == 196)
        {
            if (m_ScrollBar != None && m_ScrollBar.bWindowVisible && m_ScrollBar.Pos > m_ScrollBar.MinPos)
            {
                m_ScrollBar.Scroll(-1);
                Root.PlayClickSound();
            }
        }
        // Down
        else if (Key == 213 || Key == 197)
        {
            if (m_ScrollBar != None && m_ScrollBar.bWindowVisible && m_ScrollBar.Pos < m_ScrollBar.MaxPos)
            {
                m_ScrollBar.Scroll(1);
                Root.PlayClickSound();
            }
        }
    }
    // Joshua - Map coordinate navigation (ReconType == 2)
    else if (m_Recon != None && m_Recon.ReconType == 2 && m_Recon.NbrOfCoord > 0)
    {
        // Right - move to next coordinate
        if (Key == 215 || Key == 199)
        {
            if (m_currentMapCoordIndex < m_Recon.NbrOfCoord - 1)
            {
                m_currentMapCoordIndex++;
                MoveMouseToMapCoord(m_currentMapCoordIndex);
                Root.PlayClickSound();
            }
        }
        // Left - move to previous coordinate
        else if (Key == 214 || Key == 198)
        {
            if (m_currentMapCoordIndex > 0)
            {
                m_currentMapCoordIndex--;
                MoveMouseToMapCoord(m_currentMapCoordIndex);
                Root.PlayClickSound();
            }
        }
    }
}

// Joshua - Tick function for auto-repeat scrolling
function Tick(float Delta)
{
    Super.Tick(Delta);

    if (m_heldKey == 0)
        return;

    m_keyHoldTime += Delta;

    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        HandleKeyAction(m_heldKey);
        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

function Notify(UWindowDialogControl C, byte E)
{

	if (E == DE_Click)
	{
        switch (C)
        {
        case m_Return:
            // Joshua - If we came from QuickView, return to game directly instead of going back one page
            if (m_bFromQuickView)
            {
                m_bFromQuickView = false;
                EPCConsole(Root.Console).LaunchGame();
            }
            else
            {
                Root.ChangeCurrentWidget(WidgetID_Previous);    //So reset function is not called on the ingame menu
            }
            break;
        }
    }
}

defaultproperties
{
    m_IReturnButtonsXPos=68 //80 // Joshua - Fixed the "Back" button size/location
    m_IReturnButtonsHeight=18
    m_IReturnButtonsWidth=240 //150 // Joshua - Fixed the "Back" button size/location
    m_IReturnButtonsYPos=353
    m_initialDelay=0.5
    m_repeatRate=0.1
}
