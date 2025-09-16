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

var UWindowLabelControl m_VersionLabel; // Enhanced version label
var INT             m_IVersionLabelXPos, m_IVersionLabelYPos; // Joshua - Enhanced version label

// Discord logo
var UWindowLabelControl m_DiscordLabel;
var INT                 m_IDiscordLabelXPos, m_IDiscordLabelYPos;
var EPCImageButton      m_oDiscordLogo;
var INT                 m_IDiscordLogoXPos, m_IDiscordLogoYPos;

function Created()
{
    local Region DiscordRegion;
    
    Super.Created();

    m_StarGame  = EPCTextButton(CreateControl( class'EPCTextButton', m_IMainButtonsXPos, m_IMainButtonsFirstYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_Settings  = EPCTextButton(CreateControl( class'EPCTextButton', m_IMainButtonsXPos, m_StarGame.WinTop + m_StarGame.WinHeight + m_IMainButtonsYOffset, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_PlayIntro = EPCTextButton(CreateControl( class'EPCTextButton', m_IMainButtonsXPos, m_Settings.WinTop + m_Settings.WinHeight + m_IMainButtonsYOffset, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_Credits   = EPCTextButton(CreateControl( class'EPCTextButton', m_IMainButtonsXPos, m_PlayIntro.WinTop + m_PlayIntro.WinHeight + m_IMainButtonsYOffset, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_ExitGame  = EPCTextButton(CreateControl( class'EPCTextButton', m_IMainButtonsXPos, m_Credits.WinTop + m_Credits.WinHeight + m_IMainButtonsYOffset, m_IMainButtonsWidth, m_IMainButtonsHeight, self));

    m_GoOnline  = EPCTextButton(CreateControl( class'EPCTextButton', m_IGoOnlineXPos, m_IGoOnlineYPos, m_IGoOnlineWidth, m_IMainButtonsHeight, self));
    m_VersionLabel = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_IVersionLabelXPos, m_IVersionLabelYPos, 200, 18, self)); // Joshua - Enhanced version label
    m_DiscordLabel = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_IDiscordLabelXPos, m_IDiscordLabelYPos, 200, 18, self)); // Joshua - Discord label

    //Buttons will have Root.Font[0] as default font wich is what we want
    m_StarGame.SetButtonText(Localize("HUD","START","Localization\\HUD") ,TXT_CENTER);
    m_Settings.SetButtonText(Localize("HUD","SETTINGSMENU","Localization\\HUD") ,TXT_CENTER);
    m_PlayIntro.SetButtonText(Localize("HUD","PLAYINTRO","Localization\\HUD") ,TXT_CENTER);
    m_Credits.SetButtonText(Localize("HUD","CREDIT","Localization\\HUD") ,TXT_CENTER);
    m_ExitGame.SetButtonText(Localize("HUD","EXIT","Localization\\HUD") ,TXT_CENTER);
    // Joshua - Replaced website with Enhanced
    //m_GoOnline.SetButtonText(Localize("HUD","WEBSITE","Localization\\HUD") ,TXT_CENTER);
    m_GoOnline.SetButtonText(Localize("Common","Website","Localization\\Enhanced") ,TXT_CENTER);
    m_VersionLabel.SetLabelText("Enhanced v1.3a", TXT_CENTER); // Joshua - Enhanced version label
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

    // Joshua - Setup Discord logo
    m_oDiscordLogo = EPCImageButton(CreateControl(class'EPCImageButton', m_IDiscordLogoXPos, m_IDiscordLogoYPos, 16, 16, self));
    m_oDiscordLogo.NormalTexture = Texture'HUD_Enhanced.HUD.Discord_dis';
    m_oDiscordLogo.HoverTexture = Texture'HUD_Enhanced.HUD.Discord';
    m_oDiscordLogo.PressedTexture = Texture'HUD_Enhanced.HUD.Discord';
    m_oDiscordLogo.bNoKeyboard = true;
}

function Paint(Canvas C, float MouseX, float MouseY)
{    
    Render(C, MouseX, MouseY);
}

function Notify(UWindowDialogControl C, byte E)
{
	if(E == DE_Click)
	{
        switch(C)
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
            // Joshua - Block opening links on Steam Deck as it will crash the game
            if (!EPlayerController(GetPlayerOwner()).eGame.bSteamDeckMode)
                GetLevel().ConsoleCommand("startminimized "@"https://github.com/Joshhhuaaa/EnhancedSC");
            break;
        case m_ExitGame:            
            m_MessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("OPTIONS","QUITSPLINTER","Localization\\HUD"), Localize("OPTIONS","QUITSPLINTERMESSAGE","Localization\\HUD"), MB_YesNo, MR_No, MR_No);
            break;
        case m_oDiscordLogo:
            // Joshua - Block opening links on Steam Deck as it will crash the game
            if (!EPlayerController(GetPlayerOwner()).eGame.bSteamDeckMode)
                GetLevel().ConsoleCommand("startminimized "@"https://discord.gg/k6mZJcfjSh");
            break;
        }
    }
}

function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{   
    if(m_MessageBox == W)
    {
        m_MessageBox = None;

        if(Result == MR_Yes)
        {
            Root.DoQuitGame();
        }
            
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
    m_IVersionLabelXPos=429 //435 //429
    m_IVersionLabelYPos=395 //393 breaks widescreen fix?
    m_IDiscordLabelXPos=85
    m_IDiscordLabelYPos=395 //393 breaks widescreen fix?
    m_IDiscordLogoXPos=65
    m_IDiscordLogoYPos=398
}