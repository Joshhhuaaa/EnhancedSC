//=============================================================================
//  EPCMainMenu.uc : MainMenu
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/03 * Created by Alexandre Dionne
//=============================================================================
class EPCMainMenu extends EPCMenuPage
        native;

#exec OBJ LOAD FILE=..\Textures\HUD_Enhanced.utx

var EPCTextButton   m_StarGame;
var EPCTextButton   m_Settings;
var EPCTextButton   m_PlayIntro;
var EPCTextButton   m_Credits;
var EPCTextButton   m_ExitGame;
var EPCTextButton   m_GoOnline;

var INT             m_IMainButtonsXPos, m_IMainButtonsHeight, m_IMainButtonsWidth, m_IMainButtonsFirstYPos, m_IMainButtonsYOffset;
var INT             m_IGoOnlineYPos, m_IGoOnlineWidth, m_IGoOnlineXPos;

var EPCMessageBox        m_MessageBox;

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
var INT             m_selectedItem;      // Joshua - Currently selected menu item index for controller navigation
var INT             m_totalItems;        // Joshua - Total selectable items
var UWindowLabelControl m_VersionLabel; // Enhanced version label
var INT             m_IVersionLabelXPos, m_IVersionLabelYPos; // Joshua - Enhanced version label

// Joshua - Discord logo
var UWindowLabelControl m_DiscordLabel;
var INT                 m_IDiscordLabelXPos, m_IDiscordLabelYPos;
var EPCImageButton      m_oDiscordLogo;
var INT                 m_IDiscordLogoXPos, m_IDiscordLogoYPos;

var EPCImageButton m_oQRTexture; // Joshua - QR code texture for GitHub/Discord on Steam Deck

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

function Created()
{
    Super.Created();

    // Joshua - Enable controller focus for this menu
    SetAcceptsFocus();
    m_totalItems = 6;  // StartGame, Settings, PlayIntro, Credits, ExitGame, Website
    m_selectedItem = 0;

    m_StarGame  = EPCTextButton(CreateControl(class'EPCTextButton', m_IMainButtonsXPos, m_IMainButtonsFirstYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_Settings  = EPCTextButton(CreateControl(class'EPCTextButton', m_IMainButtonsXPos, m_StarGame.WinTop + m_StarGame.WinHeight + m_IMainButtonsYOffset, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_PlayIntro = EPCTextButton(CreateControl(class'EPCTextButton', m_IMainButtonsXPos, m_Settings.WinTop + m_Settings.WinHeight + m_IMainButtonsYOffset, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_Credits   = EPCTextButton(CreateControl(class'EPCTextButton', m_IMainButtonsXPos, m_PlayIntro.WinTop + m_PlayIntro.WinHeight + m_IMainButtonsYOffset, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_ExitGame  = EPCTextButton(CreateControl(class'EPCTextButton', m_IMainButtonsXPos, m_Credits.WinTop + m_Credits.WinHeight + m_IMainButtonsYOffset, m_IMainButtonsWidth, m_IMainButtonsHeight, self));

    m_GoOnline  = EPCTextButton(CreateControl(class'EPCTextButton', m_IGoOnlineXPos, m_IGoOnlineYPos, m_IGoOnlineWidth, m_IMainButtonsHeight, self));
    m_VersionLabel = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IVersionLabelXPos, m_IVersionLabelYPos, 200, 18, self)); // Joshua - Enhanced version label
    m_DiscordLabel = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IDiscordLabelXPos, m_IDiscordLabelYPos, 200, 18, self)); // Joshua - Discord label

    //Buttons will have Root.Font[0] as default font wich is what we want
    m_StarGame.SetButtonText(Localize("HUD","START","Localization\\HUD") ,TXT_CENTER);
    m_Settings.SetButtonText(Localize("HUD","SETTINGSMENU","Localization\\HUD") ,TXT_CENTER);
    m_PlayIntro.SetButtonText(Localize("HUD","PLAYINTRO","Localization\\HUD") ,TXT_CENTER);
    m_Credits.SetButtonText(Localize("HUD","CREDIT","Localization\\HUD") ,TXT_CENTER);
    m_ExitGame.SetButtonText(Localize("HUD","EXIT","Localization\\HUD") ,TXT_CENTER);
    // Joshua - Replaced website with Enhanced
    //m_GoOnline.SetButtonText(Localize("HUD","WEBSITE","Localization\\HUD") ,TXT_CENTER);
    m_GoOnline.SetButtonText(Localize("Common","Website","Localization\\Enhanced") ,TXT_CENTER);
    m_VersionLabel.SetLabelText("Enhanced v1.4a", TXT_RIGHT); // Joshua - Enhanced version label
    m_DiscordLabel.SetLabelText("Discord", TXT_LEFT); // Joshua - Discord label

    m_StarGame.Font = F_Large;
    m_Settings.Font = F_Large;
    m_PlayIntro.Font = F_Large;
    m_Credits.Font = F_Large;
    m_ExitGame.Font = F_Large;
    m_GoOnline.Font = F_Large;
    m_VersionLabel.Font = F_Normal; // Joshua - Enhanced version label
    m_DiscordLabel.Font = F_Normal; // Joshua - Discord label

    m_VersionLabel.TextColor.R = 51;
    m_VersionLabel.TextColor.G = 51;
    m_VersionLabel.TextColor.B = 51;
    m_VersionLabel.TextColor.A = 255;

    m_DiscordLabel.TextColor.R = 51;
    m_DiscordLabel.TextColor.G = 51;
    m_DiscordLabel.TextColor.B = 51;
    m_DiscordLabel.TextColor.A = 255;

    // Joshua - Discord logo
    m_oDiscordLogo = EPCImageButton(CreateControl(class'EPCImageButton', m_IDiscordLogoXPos, m_IDiscordLogoYPos, 16, 16, self));
    m_oDiscordLogo.NormalTexture = Texture'HUD_Enhanced.HUD.Discord_dis';
    m_oDiscordLogo.HoverTexture = Texture'HUD_Enhanced.HUD.Discord';
    m_oDiscordLogo.PressedTexture = Texture'HUD_Enhanced.HUD.Discord';
    m_oDiscordLogo.bNoKeyboard = true;

    // Joshua - Initialize first menu item as selected
    m_StarGame.m_bSelected = true;

    // Joshua - Initialize auto-scroll variables
    m_heldKey = 0;
    m_keyHoldTime = 0.0;
    m_nextRepeatTime = 0.0;
}

// Joshua - Clear button selection when in mouse mode, restore when in controller mode
function BeforePaint(Canvas C, float X, float Y)
{
    Super.BeforePaint(C, X, Y);

    // In mouse mode, don't show selection bars
    if (!Root.bDisableMouseDisplay)
    {
        m_StarGame.m_bSelected = false;
        m_Settings.m_bSelected = false;
        m_PlayIntro.m_bSelected = false;
        m_Credits.m_bSelected = false;
        m_ExitGame.m_bSelected = false;
        m_GoOnline.m_bSelected = false;
    }
    else
    {
        // Controller mode - restore selection on the currently selected item
        HighlightSelectedItem(m_selectedItem);
    }
}

function Paint(Canvas C, float MouseX, float MouseY)
{
    Render(C, MouseX, MouseY);

    // Joshua - Draw controller button prompts when in controller mode
    if (EPCMainMenuRootWindow(Root).m_bControllerModeActive)
    {
        DrawControllerPrompts(C);
    }
}

// Joshua - Draw controller button prompts at the bottom
function DrawControllerPrompts(Canvas C)
{
    local EchelonLevelInfo eLevel;
    local EPlayerController EPC;
    local float PromptX, PromptY;
    local float IconSize;
    local float TextWidth, TextHeight;
    local string PromptText;
    local Color IconColor;
    local Color TextColor;

    eLevel = EchelonLevelInfo(GetLevel());
    if (eLevel == None || eLevel.TMENU == None)
        return;

    EPC = EPlayerController(GetPlayerOwner());

    IconSize = 22;
    PromptY = 351; // Same Y as other menus' bottom buttons
    PromptX = 68; // Start from left

    IconColor.R = 128;
    IconColor.G = 128;
    IconColor.B = 128;
    IconColor.A = 255;

    TextColor.R = 71;
    TextColor.G = 71;
    TextColor.B = 71;
    TextColor.A = 255;

    C.Font = Root.Fonts[F_Normal];

    // (A) Select - always shown
    C.DrawColor = IconColor;
    C.SetPos(PromptX, PromptY);
    switch (EPC.ControllerIcon)
    {
        case CI_PlayStation:
            C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.PS2_Cross', IconSize, IconSize, 3, 3, 26, 26);
            break;
        case CI_GameCube:
            C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.GameCube_A', IconSize, IconSize, 3, 3, 26, 26);
            break;
        default: // CI_Xbox or CI_None
            C.DrawTile(eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_a].TextureOwner, IconSize, IconSize,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_a].Origin.X,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_a].Origin.Y,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_a].Size.X,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_a].Size.Y);
            break;
    }
    PromptX += IconSize + 8;
    C.DrawColor = TextColor;
    C.SetPos(PromptX, PromptY + 3);
    PromptText = Caps(Localize("HUD", "Select", "Localization\\HUD"));
    C.DrawText(PromptText);
    C.TextSize(PromptText, TextWidth, TextHeight);
    PromptX += TextWidth + 15;

    // (B) Back - always shown
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
            C.DrawTile(eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_b].TextureOwner, IconSize, IconSize,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_b].Origin.X,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_b].Origin.Y,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_b].Size.X,
                eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_b].Size.Y);
            break;
    }
    PromptX += IconSize + 8;
    C.DrawColor = TextColor;
    C.SetPos(PromptX, PromptY + 3);
    PromptText = Caps(Localize("HUD", "Back", "Localization\\HUD"));
    C.DrawText(PromptText);

    // (Y) Discord - only shown when Website is selected
    if (m_selectedItem == 5)
    {
        PromptX = 330; // Same position as Y button in settings page
        C.DrawColor = IconColor;
        C.SetPos(PromptX, PromptY);
        switch (EPC.ControllerIcon)
        {
            case CI_PlayStation:
                C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.PS2_Triangle', IconSize, IconSize, 3, 3, 26, 26);
                break;
            case CI_GameCube:
                C.SetPos(PromptX, PromptY + 3); // Center the 15-tall icon in 22-tall space
                C.DrawTile(Texture'HUD_Enhanced.ControllerIcons.GameCube_Y', IconSize, 15, 14, 4, 37, 26);
                break;
            default: // CI_Xbox or CI_None
                C.DrawTile(eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_y].TextureOwner, IconSize, IconSize,
                    eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_y].Origin.X,
                    eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_y].Origin.Y,
                    eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_y].Size.X,
                    eLevel.TMENU.ArrayTexture[eLevel.TMENU.but_s_y].Size.Y);
                break;
        }
        PromptX += IconSize + 8;
        C.DrawColor = TextColor;
        C.SetPos(PromptX, PromptY + 3);
        PromptText = "DISCORD";
        C.DrawText(PromptText);
    }
}

// Joshua - Select and activate the option at the given index
function SelectedOption(INT selectedItem_)
{
    // Joshua - Clear held key state when navigating to prevent auto-scroll persisting on return
    m_heldKey = 0;
    m_keyHoldTime = 0;

    switch(selectedItem_)
    {
        case 0:
            Notify(m_StarGame, DE_Click);
            break;
        case 1:
            Notify(m_Settings, DE_Click);
            break;
        case 2:
            Notify(m_PlayIntro, DE_Click);
            break;
        case 3:
            Notify(m_Credits, DE_Click);
            break;
        case 4:
            Notify(m_ExitGame, DE_Click);
            break;
        case 5:
            Notify(m_GoOnline, DE_Click);
            break;
    }
}

// Joshua - Highlight the menu item at the given index and unhighlight others
function HighlightSelectedItem(INT selectedItem_)
{
    m_StarGame.m_bSelected = false;
    m_Settings.m_bSelected = false;
    m_PlayIntro.m_bSelected = false;
    m_Credits.m_bSelected = false;
    m_ExitGame.m_bSelected = false;
    m_GoOnline.m_bSelected = false;

    switch(selectedItem_)
    {
        case 0:
            m_StarGame.m_bSelected = true;
            break;
        case 1:
            m_Settings.m_bSelected = true;
            break;
        case 2:
            m_PlayIntro.m_bSelected = true;
            break;
        case 3:
            m_Credits.m_bSelected = true;
            break;
        case 4:
            m_ExitGame.m_bSelected = true;
            break;
        case 5:
            m_GoOnline.m_bSelected = true;
            break;
    }
}

// Joshua - Update selection when mouse hovers over a button
function UpdateSelectionFromMouse(UWindowDialogControl C)
{
    if (C == m_StarGame)
    {
        m_selectedItem = 0;
        HighlightSelectedItem(m_selectedItem);
    }
    else if (C == m_Settings)
    {
        m_selectedItem = 1;
        HighlightSelectedItem(m_selectedItem);
    }
    else if (C == m_PlayIntro)
    {
        m_selectedItem = 2;
        HighlightSelectedItem(m_selectedItem);
    }
    else if (C == m_Credits)
    {
        m_selectedItem = 3;
        HighlightSelectedItem(m_selectedItem);
    }
    else if (C == m_ExitGame)
    {
        m_selectedItem = 4;
        HighlightSelectedItem(m_selectedItem);
    }
    else if (C == m_GoOnline)
    {
        m_selectedItem = 5;
        HighlightSelectedItem(m_selectedItem);
    }
}

function Notify(UWindowDialogControl C, byte E)
{
    // Joshua - Update selection when mouse enters a button (hover)
    if (E == DE_MouseEnter || E == DE_Enter)
    {
        UpdateSelectionFromMouse(C);
    }

	if (E == DE_Click)
	{
        switch (C)
        {
        case m_StarGame:
            Root.ChangeCurrentWidget(WidgetID_Player);
            break;
        case m_Settings:
            Root.ChangeCurrentWidget(WidgetID_Options);
            break;
        case m_PlayIntro:
            Root.ChangeCurrentWidget(WidgetID_Intro);
            break;
        case m_Credits:
            Root.ChangeCurrentWidget(WidgetID_Credits);
            break;
        case m_GoOnline:
            // Joshua - Show QR code instead of opening the link on Steam Deck
            if (EPlayerController(GetPlayerOwner()).eGame.bSteamDeckMode)
            {
                m_MessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("Common","Website","Localization\\Enhanced"), "", MB_OK, MR_OK, MR_OK);
                m_oQRTexture = EPCImageButton(m_MessageBox.CreateControl(class'EPCImageButton', 140, 26, 96, 96));
                m_oQRTexture.NormalTexture = Texture'HUD_Enhanced.HUD.QR_GitHub';
                m_oQRTexture.HoverTexture = Texture'HUD_Enhanced.HUD.QR_GitHub';
                m_oQRTexture.PressedTexture = Texture'HUD_Enhanced.HUD.QR_GitHub';
                m_oQRTexture.bNoKeyboard = true;
            }
            else
                GetLevel().ConsoleCommand("startminimized "@"https://github.com/Joshhhuaaa/EnhancedSC");
            break;
        case m_ExitGame:
            m_MessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("OPTIONS","QUITSPLINTER","Localization\\HUD"), Localize("OPTIONS","QUITSPLINTERMESSAGE","Localization\\HUD"), MB_YesNo, MR_No, MR_No);
            break;
        case m_oDiscordLogo:
            // Joshua - Show QR code instead of opening the link on Steam Deck
            if (EPlayerController(GetPlayerOwner()).eGame.bSteamDeckMode)
            {
                m_MessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("Common","DiscordServer","Localization\\Enhanced"), "", MB_OK, MR_OK, MR_OK);
                m_oQRTexture = EPCImageButton(m_MessageBox.CreateControl(class'EPCImageButton', 140, 26, 96, 96));
                m_oQRTexture.NormalTexture = Texture'HUD_Enhanced.HUD.QR_Discord';
                m_oQRTexture.HoverTexture = Texture'HUD_Enhanced.HUD.QR_Discord';
                m_oQRTexture.PressedTexture = Texture'HUD_Enhanced.HUD.QR_Discord';
                m_oQRTexture.bNoKeyboard = true;
            }
            else
                GetLevel().ConsoleCommand("startminimized "@"https://discord.gg/k6mZJcfjSh");
            break;
        }
    }
}

function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{
    if (m_MessageBox == W)
    {
        m_MessageBox = None;

        // Joshua - Clear QR texture when message box closes
        if (m_oQRTexture != None)
        {
            m_oQRTexture.HideWindow();
            m_oQRTexture = None;
        }

        if (Result == MR_Yes)
        {
            Root.DoQuitGame();
        }

    }
}

// Joshua - Handle controller input
// A=200, B=201, X=202, Y=203
// DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
// AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    super.WindowEvent(Msg, C, X, Y, Key);

    if (Msg == WM_KeyDown)
    {
        // Track held key for auto-repeat (only for navigation keys)
        if (Key == 212 || Key == 196 || Key == 213 || Key == 197)
        {
            if (m_heldKey != Key)
            {
                m_heldKey = Key;
                m_keyHoldTime = 0.0;
                m_nextRepeatTime = m_initialDelay;
            }
        }

        // Navigate up - DPadUp (212) or AnalogUp (196)
        if (Key == 212 || Key == 196)
        {
            Root.PlayClickSound();
            m_selectedItem = (m_selectedItem - 1 + m_totalItems) % m_totalItems;
            HighlightSelectedItem(m_selectedItem);
        }
        // Navigate down - DPadDown (213) or AnalogDown (197)
        else if (Key == 213 || Key == 197)
        {
            Root.PlayClickSound();
            m_selectedItem = (m_selectedItem + 1) % m_totalItems;
            HighlightSelectedItem(m_selectedItem);
        }
        // A button - select
        else if (Key == 200)
        {
            Root.PlayClickSound();
            SelectedOption(m_selectedItem);
        }
        // B button - exit
        else if (Key == 201)
        {
            m_heldKey = 0;
            m_keyHoldTime = 0;
            Root.PlayClickSound();
            Notify(m_ExitGame, DE_Click);
        }
        // Y button - Discord (only when Website is selected)
        else if (Key == 203 && m_selectedItem == 5)
        {
            Root.PlayClickSound();
            Notify(m_oDiscordLogo, DE_Click);
        }
    }
    else if (Msg == WM_KeyUp)
    {
        // Clear held key on release
        if (Key == m_heldKey)
        {
            m_heldKey = 0;
            m_keyHoldTime = 0.0;
        }
    }
}

// Joshua - Tick function for auto-repeat navigation
function Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);

    if (m_heldKey == 0)
        return;

    m_keyHoldTime += DeltaTime;

    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        // Navigate up - DPadUp (212) or AnalogUp (196)
        if (m_heldKey == 212 || m_heldKey == 196)
        {
            Root.PlayClickSound();
            m_selectedItem = (m_selectedItem - 1 + m_totalItems) % m_totalItems;
            HighlightSelectedItem(m_selectedItem);
        }
        // Navigate down - DPadDown (213) or AnalogDown (197)
        else if (m_heldKey == 213 || m_heldKey == 197)
        {
            Root.PlayClickSound();
            m_selectedItem = (m_selectedItem + 1) % m_totalItems;
            HighlightSelectedItem(m_selectedItem);
        }

        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

defaultproperties
{
    m_IMainButtonsXPos=200
    m_IMainButtonsHeight=18
    m_IMainButtonsWidth=230
    m_IMainButtonsFirstYPos=160
    m_IMainButtonsYOffset=3
    m_IGoOnlineYPos=295
    m_IGoOnlineWidth=300
    m_IGoOnlineXPos=180
	//=============================================================================
	// Enhanced Variables
	//=============================================================================
    m_IVersionLabelXPos=381
    m_IVersionLabelYPos=393
    m_IDiscordLabelXPos=80
    m_IDiscordLabelYPos=393
    m_IDiscordLogoXPos=60
    m_IDiscordLogoYPos=396
    m_initialDelay=0.5
    m_repeatRate=0.1
}
