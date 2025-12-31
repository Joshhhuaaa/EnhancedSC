//=============================================================================
//  EPCPlayerMenu.uc : START GAME MENU
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/10 * Created by Alexandre Dionne
//=============================================================================
class EPCPlayerMenu extends EPCMenuPage
                    native;
			
var EPCTextButton   m_MainMenu;     // To return to main menu
var INT             m_IMainButtonsXPos, m_IMainButtonsHeight, m_IMainButtonsWidth, m_IMainButtonsYPos; 


var EPCTextButton   m_LoadButton;
var EPCTextButton   m_CreateButton;
var INT             m_iTopButtonsYPos, m_iLoadXPos, m_iCreateButtonXPos, m_iTopButtonsWidth;

var EPCTextButton   m_ConfirmationButton;
var INT             m_iConfirmationXPos;

var EPCCreatePlayerArea     m_CreateArea;
var EPCLoadDelPlayerArea    m_LoadDelArea;
var INT             m_iCreateXPos, m_iCreateYPos, m_iCreateWidth, m_iCreateHeight;


function Created()
{
    Super.Created();

    m_MainMenu  = EPCTextButton(CreateControl(class'EPCTextButton', m_IMainButtonsXPos, m_IMainButtonsYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_ConfirmationButton = EPCTextButton(CreateControl(class'EPCTextButton', m_iConfirmationXPos, m_IMainButtonsYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));

    m_LoadButton    = EPCTextButton(CreateControl(class'EPCTextButton', m_iLoadXPos, m_iTopButtonsYPos, m_iTopButtonsWidth, m_IMainButtonsHeight, self));
    m_CreateButton  = EPCTextButton(CreateControl(class'EPCTextButton', m_iCreateButtonXPos, m_iTopButtonsYPos, m_iTopButtonsWidth, m_IMainButtonsHeight, self));    

    m_CreateArea    = EPCCreatePlayerArea(CreateWindow(class'EPCCreatePlayerArea', m_iCreateXPos, m_iCreateYPos, m_iCreateWidth, m_iCreateHeight, self));
    m_CreateArea.HideWindow();

    m_LoadDelArea   = EPCLoadDelPlayerArea(CreateWindow(class'EPCLoadDelPlayerArea', m_iCreateXPos, m_iCreateYPos, m_iCreateWidth, m_iCreateHeight, self));
    m_LoadDelArea.HideWindow();

    m_MainMenu.SetButtonText(Caps(Localize("HUD","MAINMENU","Localization\\HUD"))         ,TXT_CENTER);    
    m_LoadButton.SetButtonText(Caps(Localize("HUD","LOADPROFILE","Localization\\HUD"))      ,TXT_CENTER);
    m_LoadButton.HelpText   = Caps(Localize("HUD","LOAD","Localization\\HUD"));
    m_CreateButton.SetButtonText(Caps(Localize("HUD","CREATEPROFILE","Localization\\HUD"))    ,TXT_CENTER);    
    m_CreateButton.HelpText = Caps(Localize("HUD","Create","Localization\\HUD"));

    m_MainMenu.Font             = F_Normal;    
    m_LoadButton.Font           = F_Normal;    
    m_CreateButton.Font         = F_Normal;       
    m_ConfirmationButton.Font   = F_Normal;
 
}

function ShowWindow()
{
    Super.ShowWindow();
    ChangeTopButtonSelection(m_LoadButton);
}


function Paint(Canvas C, float MouseX, float MouseY)
{
    Render(C , MouseX, MouseY);	
}


function Notify(UWindowDialogControl C, byte E)
{

	if (E == DE_Click)
	{
        switch (C)
        {
        case m_MainMenu:            
            Root.ChangeCurrentWidget(WidgetID_MainMenu);
            break;
            
        case m_CreateButton:                        
        case m_LoadButton:                          
            ChangeTopButtonSelection(EPCTextButton(C));
            break;
            
        case m_ConfirmationButton:
            ConfirmButtonPressed();
            break;
        }
    }
}

function EscapeMenu()
{
	if (!EPCConsole(Root.Console).bInGameMenuActive)
	{
		Root.PlayClickSound();
		Notify(m_MainMenu, DE_Click);
	}
}

function ConfirmButtonPressed()
{    
    local String Error;

    // Joshua - Added for Elite mode
    local EPlayerController EPC;

    EPC = EPlayerController(GetPlayerOwner());

    ///////////////////////////////////////////////////////////////////////////////////
    //                  CREATE A PROFILE
    /////////////////////////////////////////////////////////////////////////////////
    if ((m_CreateButton.m_bSelected == true))
    {
		if (m_CreateArea.GetProfileName() != "")
		{
			//Saving desired difficulty level
			GetPlayerOwner().playerInfo.Difficulty = m_CreateArea.GetDifficulty();       

			// No map completed yet, we just created a profile.
			GetPlayerOwner().playerInfo.MapCompleted = 0;

            if (EPC.playerInfo.Difficulty == 2 || EPC.playerInfo.Difficulty == 4) // Elite or Elite Permadeath
                EPC.eGame.bEliteMode = true;
            else
                EPC.eGame.bEliteMode = false;

            if (EPC.playerInfo.Difficulty > 2) // Permadeath toggle
                EPC.eGame.bPermadeathMode = true;
            else
                EPC.eGame.bPermadeathMode = false;

            EPC.eGame.SaveEnhancedOptions();

			Error = GetPlayerOwner().ConsoleCommand("SAVEPROFILE NAME="$m_CreateArea.GetProfileName());

			if (Error == "")
			{            
				GetLevel().ConsoleCommand("Open "$GetPlayerOwner().playerInfo.UnlockedMap[0]);
				EPCConsole(Root.Console).LaunchGame();        
				m_CreateArea.Reset();            
			}
			else if (Error == "ALREADY_EXIST")
			{
				EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("OPTIONS","PROFILEEXISTS","Localization\\HUD"), Localize("OPTIONS","PROFILEEXISTSMESSAGE","Localization\\HUD"), MB_OK, MR_OK, MR_OK);
			}
			else if (Error == "INVALID_NAME")
			{
				EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, "Error, invalid file name", "Bad File Name", MB_OK, MR_OK, MR_OK);
			}					
			else    ///////////////////error///////////////////////////
				log("Create Profile Impossible"@Error);
		}        
    }
    ///////////////////////////////////////////////////////////////////////////////////
    //                  LOAD A PROFILE
    /////////////////////////////////////////////////////////////////////////////////
    else //Load Profile
    {
        if (m_LoadDelArea.m_ListBox.SelectedItem != None)
        {
            //We should only have valid profiles listed so we can't load a wrong profile
            GetPlayerOwner().ConsoleCommand("LOADPROFILE NAME="$EPCListBoxItem(m_LoadDelArea.m_ListBox.SelectedItem).Caption);
            if (EPC.playerInfo.Difficulty == 2 || EPC.playerInfo.Difficulty == 4) // Elite or Elite Permadeath
                EPC.eGame.bEliteMode = true;
            else
                EPC.eGame.bEliteMode = false;

            if (EPC.playerInfo.Difficulty > 2) // Permadeath toggle
                EPC.eGame.bPermadeathMode = true;
            else
                EPC.eGame.bPermadeathMode = false;

            EPC.eGame.SaveEnhancedOptions();
            Root.ChangeCurrentWidget(WidgetID_SaveGames);
        }        
    }
}

function ChangeTopButtonSelection(EPCTextButton _SelectMe)
{
    
    m_LoadButton.m_bSelected    =  false;
    m_CreateButton.m_bSelected  =  false;    

    _SelectMe.m_bSelected       =  true;

    m_ConfirmationButton.SetButtonText(_SelectMe.HelpText, TXT_CENTER);

    if (_SelectMe == m_LoadButton)
    {
        m_LoadDelArea.ShowWindow();
        m_CreateArea.HideWindow();
    }
    else
    {
        m_LoadDelArea.HideWindow();
        m_CreateArea.ShowWindow();
    }

}

defaultproperties
{
    m_IMainButtonsXPos=68
    m_IMainButtonsHeight=18
    m_IMainButtonsWidth=240
    m_IMainButtonsYPos=353
    m_iTopButtonsYPos=143
    m_iLoadXPos=85
    m_iCreateButtonXPos=323
    m_iTopButtonsWidth=230
    m_iConfirmationXPos=330
    m_iCreateXPos=83
    m_iCreateYPos=175
    m_iCreateWidth=475
    m_iCreateHeight=155
}