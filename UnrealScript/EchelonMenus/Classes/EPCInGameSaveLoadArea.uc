//=============================================================================
//  EPCInGameSaveLoadArea.uc : InGame menu allowing loading a saved game an unlocked level or saving a game
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/08 * Created by Alexandre Dionne
//=============================================================================


class EPCInGameSaveLoadArea extends UWindowDialogClientWindow
			native;

var EPCTextButton   m_LoadGameButton, m_LoadLevelButton, m_SaveGameButton, m_LoadConfirmationButton;
var INT             m_IFirstButtonsXPos, m_IXButtonOffset, m_IButtonsHeight, m_IButtonsWidth, m_IButtonsYPos;
var INT             m_ILoadXPos, m_ILoadYPos, m_ILoadWidth, m_ILoadHeight;

var EPCLevelListBox              m_ListBox;
var EPCFileListBox          m_FileListBox;

var INT                     m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight;
var INT                     m_ISaveListBoxYPos, m_ISaveListBoxHeight;

var EPCInGameSaveGameArea m_SaveArea;

var UWindowLabelControl     m_LName;
var UWindowLabelControl     m_LDate;
var UWindowLabelControl     m_LTime;

var Color                   m_TextColor;
var INT                     m_ILabelHeight, m_NameWidth, m_LDateWidth; 

var EPCMessageBox        m_MessageBox;
var EPCMessageBox        m_SavingLoadingMessageBox;
var BOOL                 m_bSkipOne;

function Created()
{
    
    m_SaveArea = EPCInGameSaveGameArea(CreateWindow( class'EPCInGameSaveGameArea', 0, 0, WinWidth, WinHeight, self));
    m_SaveArea.HideWindow();

    m_LoadGameButton = EPCTextButton(CreateControl( class'EPCTextButton', m_IFirstButtonsXPos, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_LoadLevelButton = EPCTextButton(CreateControl( class'EPCTextButton', m_LoadGameButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_SaveGameButton  = EPCTextButton(CreateControl( class'EPCTextButton', m_LoadLevelButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_LoadConfirmationButton= EPCTextButton(CreateControl( class'EPCTextButton',m_ILoadXPos, m_ILoadYPos, m_ILoadWidth, m_ILoadHeight, self));

    m_LoadGameButton.SetButtonText( Caps(Localize("HUD","LOADGAME","Localization\\HUD"))    ,TXT_CENTER);    
    m_LoadLevelButton.SetButtonText( Caps(Localize("HUD","LEVELS_TITLE","Localization\\HUD"))    ,TXT_CENTER);
    m_SaveGameButton.SetButtonText( Caps(Localize("HUD","SAVE","Localization\\HUD"))    ,TXT_CENTER);
    m_LoadConfirmationButton.SetButtonText( Caps(Localize("HUD","LOAD","Localization\\HUD"))    ,TXT_CENTER);

    m_LoadGameButton.Font       = EPCMainMenuRootWindow(Root).TitleFont;    
    m_LoadLevelButton.Font      = EPCMainMenuRootWindow(Root).TitleFont;    
    m_SaveGameButton.Font       = EPCMainMenuRootWindow(Root).TitleFont;     
    m_LoadConfirmationButton.Font       = F_Normal;     

    m_ListBox           = EPCLevelListBox(CreateControl( class'EPCLevelListBox', m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight, self));        
    m_ListBox.Font      = F_Normal;
    m_ListBox.Align     = TXT_CENTER;   

    m_FileListBox           = EPCFileListBox(CreateControl( class'EPCFileListBox', m_IListBoxXPos, m_ISaveListBoxYPos, m_IListBoxWidth, m_ISaveListBoxHeight, self));        
    m_FileListBox.Font      = F_Normal; 
    m_FileListBox.NameWidth = m_NameWidth;
    m_FileListBox.DateWidth = m_LDateWidth;

    m_LName       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_IListBoxXPos, m_IListBoxYPos, m_NameWidth, m_ILabelHeight, self));
    m_LName.SetLabelText(Caps(Localize("HUD","NAME","Localization\\HUD")),TXT_LEFT);
    m_LName.Font       = F_Normal;
    m_LName.TextColor  = m_TextColor;   
    m_LName.m_fLMarge  = 2;

    m_LDate       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_LName.WinLeft + m_LName.WinWidth, m_IListBoxYPos, m_LDateWidth, m_ILabelHeight, self));
    m_LDate.SetLabelText(Caps(Localize("HUD","DATE","Localization\\HUD")),TXT_LEFT);
    m_LDate.Font       = F_Normal;
    m_LDate.TextColor  = m_TextColor;    
    m_LDate.m_fLMarge  = 2;

    m_LTime       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_LDate.WinLeft + m_LDate.WinWidth, m_IListBoxYPos, m_IListBoxWidth - m_LDateWidth - m_NameWidth, m_ILabelHeight, self));
    m_LTime.SetLabelText(Caps(Localize("HUD","TIME","Localization\\HUD")),TXT_LEFT);
    m_LTime.Font       = F_Normal;
    m_LTime.TextColor  = m_TextColor;    
    m_LTime.m_fLMarge  = 2;

    ChangeMenuSection(m_LoadGameButton);

}

function HideWindow()
{
    Super.HideWindow();
    m_SaveArea.HideWindow();
}

function Paint(Canvas C, FLOAT X, FLOAT Y)
{
    Render(C, X, Y);
}

function FillListBox()
{
    local int i;
    local EPCListBoxItem L;
    local EPCFileManager FileManager;
    local EPlayerInfo    PlayerInfo;
    local String         Path;    //Do something
	local String		 Name;
    local array<string>  AllParts; // Joshua - Mission unlocked mode 

    // Joshua - Added to check for Elite mode
    local EPlayerController EPC;
    
    PlayerInfo = GetPlayerOwner().playerInfo;
    EPC = EPlayerController(GetPlayerOwner());

    m_FileListBox.Clear();
    //Filling Save Games
    FileManager = EPCMainMenuRootWindow(Root).m_FileManager;
    Path = "..\\Save\\"$PlayerInfo.PlayerName$"\\*.en1"; // Joshua - Enhanced save games are not compatible, changing extension to avoid confusion
    FileManager.DetailedFindFiles(Path);

    for(i=0; i< FileManager.m_pDetailedFileList.Length ; i++)
    {        
        L = EPCListBoxItem(m_FileListBox.Items.Append(class'EPCListBoxItem'));

		// Remove the extension (YM)
		Name = FileManager.m_pDetailedFileList[i].Filename;					   
		Name = Left(Name, Len(Name) - 4);
		L.Caption = Name;

        L.HelpText = FileManager.m_pDetailedFileList[i].FileDate;
        L.m_AltText = FileManager.m_pDetailedFileList[i].FileTime;
		L.szSortByToken = FileManager.m_pDetailedFileList[i].FileCompletTime;
		L.m_bReverseSort = true;
    }
	m_FileListBox.Sort();

    m_ListBox.Clear();

    //Filling Unlocked Levels
    i=0;
    if (PlayerInfo.LevelUnlock == LU_AllParts && !EPC.eGame.bEliteMode && !EPC.eGame.bPermadeathMode)
    {
        AllParts.Length = 31;
        AllParts[0] = "0_0_2_Training";
        AllParts[1] = "0_0_3_Training";
        AllParts[2] = "1_1_0Tbilisi";
        AllParts[3] = "1_1_1Tbilisi";
        AllParts[4] = "1_1_2Tbilisi";
        AllParts[5] = "1_2_1DefenseMinistry";
        AllParts[6] = "1_2_2DefenseMinistry";
        AllParts[7] = "1_3_2CaspianOilRefinery";
        AllParts[8] = "1_3_3CaspianOilRefinery";
        AllParts[9] = "2_1_0CIA";
        AllParts[10] = "2_1_1CIA";
        AllParts[11] = "2_1_2CIA";
        AllParts[12] = "2_2_1_Kalinatek";
        AllParts[13] = "2_2_2_Kalinatek";
        AllParts[14] = "2_2_3_Kalinatek";
        AllParts[15] = "4_1_1ChineseEmbassy";
        AllParts[16] = "4_1_2ChineseEmbassy";
        AllParts[17] = "4_2_1_Abattoir";
        AllParts[18] = "4_2_2_Abattoir";
        AllParts[19] = "4_3_0ChineseEmbassy";
        AllParts[20] = "4_3_1ChineseEmbassy";
        AllParts[21] = "4_3_2ChineseEmbassy";
        AllParts[22] = "5_1_1_PresidentialPalace";
        AllParts[23] = "5_1_2_PresidentialPalace";
        AllParts[24] = "1_6_1_1KolaCell";
        AllParts[25] = "1_7_1_1VselkaInfiltration";
        AllParts[26] = "1_7_1_2Vselka";
        AllParts[27] = "3_2_1_PowerPlant";
        AllParts[28] = "3_2_2_PowerPlant";
        AllParts[29] = "3_4_2Severonickel";
        AllParts[30] = "3_4_3Severonickel";

        for (i = 0; i < AllParts.Length; ++i)
        {
            L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
            L.Caption = AllParts[i];
            L.m_bLocked = false;
        }
    }
    else
    {
        while(PlayerInfo.UnlockedMap[i] != "")
        {        
            // Joshua - Unlisting Vselka Submarine as it has been merged into Vselka Infiltration
            if(i == 12) 
            {
                i++;
                continue;
            }        
            L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
            L.Caption = PlayerInfo.UnlockedMap[i];
            
            // Original Maps
            if (i<10)
            {
                if (PlayerInfo.LevelUnlock == LU_Enabled && !EPC.eGame.bEliteMode && !EPC.eGame.bPermadeathMode) // Joshua - Unlocks all levels, bypassing profile progression
                    L.m_bLocked = false;
                else
                    L.m_bLocked = (i > PlayerInfo.MapCompleted);
            }
            // Joshua - Downloadable maps require Presidential Palace to be unlocked in Enhanced
            else if (i >= 10 && i <= 12) // Kola Cell, Vselka
            {
                if (PlayerInfo.LevelUnlock == LU_Enabled && !EPC.eGame.bEliteMode && !EPC.eGame.bPermadeathMode) // Joshua - Unlocks all levels, bypassing profile progression
                    L.m_bLocked = false;
                else
                    L.m_bLocked = (PlayerInfo.MapCompleted < 9);
            }
            
            i++;
        }
        // Joshua - Adding cut levels to end of list
        L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
        L.Caption = "3_2_1_PowerPlant";
        L.m_bLocked = false;

        L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
        L.Caption = "3_4_2Severonickel";
        L.m_bLocked = false;
    }
}

function Notify(UWindowDialogControl C, byte E)
{
    local String Error;    

	if(E == DE_Click)
	{
        switch(C)
        {
        case m_LoadGameButton:
        case m_LoadLevelButton:
			ChangeMenuSection(UWindowButton(C));
			break;
        case m_SaveGameButton:                     
			if(GetPlayerOwner().CanSaveGame())
			{
				ChangeMenuSection(UWindowButton(C));
			}
            break;
        case m_SaveArea.m_OKButton:
            if(m_SaveArea.GetSaveName() != "")
            {
                SaveGame();
                m_SaveArea.HideWindow();                
            }                
            break;
        case m_SaveArea.m_CancelButton:
            m_SaveArea.Clear();
            m_SaveArea.HideWindow();
            break;
        case m_LoadConfirmationButton:
            Load();
            break;
        }
    }
    if( (E == DE_DoubleClick) && ( (C == m_ListBox) || (C == m_FileListBox) ) )
    {     
        Load();
    }
}

function Load()
{
	local String Error;
	local bool noLoadMap;
    
	// Check valid CD in
	if( !EPCMainMenuRootWindow(Root).CheckCD() )
		return;
	
    if(m_LoadGameButton.m_bSelected)
    {        
        if(m_FileListBox.SelectedItem != None)
        {
			// Added extension (.sav ) (YM)
            Error = GetPlayerOwner().ConsoleCommand("LoadGame Filename="$EPCListBoxItem(m_FileListBox.SelectedItem).Caption$".en1"); // Joshua - Enhanced save games are not compatible, changing extension to avoid confusion
			noLoadMap = true;
        }
        else
            return;
        
    }
    else
    {
        if((EPCListBoxItem(m_ListBox.SelectedItem) != None) && (!EPCListBoxItem(m_ListBox.SelectedItem).m_bLocked))
        {
			Error = GetPlayerOwner().ConsoleCommand("Open "$EPCListBoxItem(m_ListBox.SelectedItem).Caption);
        }
        else
            return;        
    }
    
    
    if(Error == "")
	{
		if(noLoadMap)
			MakeSaveLoadMessageBox(false);
	}
    else
        log("Load Error:"@Error);   
}

function GameSaved(bool success)
{
	if(m_SavingLoadingMessageBox != None)
		m_SavingLoadingMessageBox.RestoreFromSave();

	if(success)
	{
	    FillListBox();
		// Close de messagebox
		if(m_SavingLoadingMessageBox != None)
		{
			m_SavingLoadingMessageBox.Notify(m_SavingLoadingMessageBox.m_OKButton, DE_Click);
			EPCConsole(Root.Console).ReturnToGame();
		}
	}
	else
	{
		// Show error message
		if(m_SavingLoadingMessageBox != None)
			m_SavingLoadingMessageBox.SetupText(Localize("HUD", "SAVEFAILED", "Localization\\HUD"));
	}
}

function GameLoaded(bool success)
{
	if(m_SavingLoadingMessageBox != None)
		m_SavingLoadingMessageBox.RestoreFromSave();

	if(success)
	{
		// Close de messagebox
		if(m_SavingLoadingMessageBox != None)
		{
			m_SavingLoadingMessageBox.Notify(m_SavingLoadingMessageBox.m_OKButton, DE_Click);
			EPCConsole(Root.Console).ReturnToGame();
		}
	}
	else
	{
		// Show error message
		if(m_SavingLoadingMessageBox != None)
			m_SavingLoadingMessageBox.SetupText(Localize("HUD", "LOADFAILED", "Localization\\HUD"));
	}
}

function MakeSaveLoadMessageBox(bool saving)
{
	m_SavingLoadingMessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, "", "", MB_OK, MR_OK, MR_OK);

	if(saving)
		m_SavingLoadingMessageBox.SetupText(Localize("HUD", "SAVING", "Localization\\HUD"));
	else
		m_SavingLoadingMessageBox.SetupText(Localize("HUD", "LOADING", "Localization\\HUD"));

	m_SavingLoadingMessageBox.SetupForSave();
}

function ChangeMenuSection( UWindowButton _SelectMe)
{ 
    
    switch(_SelectMe)
    {
    case m_LoadGameButton:        
        m_LoadGameButton.m_bSelected    =  true;
        m_LoadLevelButton.m_bSelected   =  false;  
        m_ListBox.HideWindow();
        m_FileListBox.ShowWindow();         
        m_LName.ShowWindow();
        m_LDate.ShowWindow();
        m_LTime.ShowWindow();
        break;
    case m_LoadLevelButton:
        m_LoadGameButton.m_bSelected    =  false;
        m_LoadLevelButton.m_bSelected   =  true;               
        m_ListBox.ShowWindow();
        m_FileListBox.HideWindow();        
        m_LName.HideWindow();
        m_LDate.HideWindow();
        m_LTime.HideWindow();
        break;
    case m_SaveGameButton:
        m_SaveArea.Clear();
        m_SaveArea.ShowWindow();
        break;    
    }
    
}

function SaveGame()
{
    local String Error;    
	local String saveName;	

	Error = "";
	saveName = m_SaveArea.GetSaveName();
	if(saveName!="")
	{
		Error = GetPlayerOwner().ConsoleCommand("SAVEGAME FILENAME="$saveName);
	}
   
    if(Error == "ALREADY_EXIST")
    {
        m_MessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Caps(Localize("OPTIONS","SAVEGAMEEXISTS","Localization\\HUD")), Caps(Localize("OPTIONS","SAVEGAMEEXISTSMESSAGE","Localization\\HUD")), MB_YesNo, MR_No, MR_No);
    }
	else if(Error == "INVALID_NAME")
	{
		EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, "Error, invalid file name", "Bad File Name", MB_OK, MR_OK, MR_OK);
	}
    else if( (Error != "") )
    {            
        log("Save File Impossible"@Error);       
    }
	else
	{
		MakeSaveLoadMessageBox(true);
	}
}

function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{
    if(W == m_MessageBox)
    {        
        m_MessageBox = None;

        if(Result == MR_Yes)
        {
            GetPlayerOwner().ConsoleCommand("SAVEGAME FILENAME="$m_SaveArea.GetSaveName()@"OVERWRITE=TRUE");
			MakeSaveLoadMessageBox(true);
        }
    }
}

function Reset()
{
    local EPlayerController EPC;
    local EPCFileManager FileManager;
    local String ProfilePath;

    EPC = EPlayerController(GetPlayerOwner());

    if (EPC.eGame.bPermadeathMode && EPC.bProfileDeletionPending)
    {
        FileManager = EPCMainMenuRootWindow(Root).m_FileManager;
        if(FileManager != None)
        {
            ProfilePath = "..\\Save\\"$EPC.playerInfo.PlayerName;
            FileManager.DeleteDirectory(ProfilePath, true);
            
            GetLevel().ConsoleCommand("Open menu\\menu");
            return;
        }
    }        

	if(m_LoadLevelButton.m_bSelected)
		ChangeMenuSection(m_LoadLevelButton);
	else
		ChangeMenuSection(m_LoadGameButton);

    FillListBox();
}

defaultproperties
{
    m_IFirstButtonsXPos=6
    m_IXButtonOffset=148
    m_IButtonsHeight=18
    m_IButtonsWidth=144
    m_IButtonsYPos=5
    m_iLoadXPos=120
    m_ILoadYPos=223
    m_ILoadWidth=200
    m_ILoadHeight=18
    m_IListBoxXPos=8
    m_IListBoxYPos=37
    m_IListBoxWidth=432
    m_IListBoxHeight=175
    m_ISaveListBoxYPos=55
    m_ISaveListBoxHeight=157
    m_TextColor=(R=51,G=51,B=51,A=255)
    m_ILabelHeight=18
    m_NameWidth=210
    m_LDateWidth=128
}