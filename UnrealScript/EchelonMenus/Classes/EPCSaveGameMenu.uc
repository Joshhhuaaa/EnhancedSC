//=============================================================================
//  EPCSaveGameMenu.uc : Saves games and unlucked maps menu
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/17 * Created by Alexandre Dionne
//=============================================================================
class EPCSaveGameMenu extends EPCMenuPage
                    native; 

var EPCTextButton   m_Back;     // To return to main menu
var INT             m_IBackButtonsXPos, m_IBackButtonsHeight, m_IBackButtonsWidth, m_IBackButtonsYPos; 


var EPCTextButton   m_SaveGamesButton;
var EPCTextButton   m_LevelsButton;
var INT             m_iTopButtonsYPos, m_iFSaveGamesXPos, m_iLevelsXPos, m_iTopButtonsWidth;

var EPCTextButton   m_ConfirmationButton;
var INT             m_iConfirmationXPos;

var EPCLevelListBox m_ListBox;
var EPCFileListBox  m_FileListBox;

var INT             m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight;
var INT             m_ISaveListBoxYPos, m_ISaveListBoxHeight;

var UWindowLabelControl     m_LName;
var UWindowLabelControl     m_LDate;
var UWindowLabelControl     m_LTime;

var Color                   m_TextColor;
var INT                     m_ILabelHeight, m_NameWidth, m_LDateWidth;

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
var bool                    m_bPendingPrototypeMapLoad; // Joshua - For prototype map warning 


function Created()
{
    Super.Created();
	SetAcceptsFocus();

    m_Back           = EPCTextButton(CreateControl(class'EPCTextButton', m_IBackButtonsXPos, m_IBackButtonsYPos, m_IBackButtonsWidth, m_IBackButtonsHeight, self));
    m_ConfirmationButton = EPCTextButton(CreateControl(class'EPCTextButton', m_iConfirmationXPos, m_IBackButtonsYPos, m_IBackButtonsWidth, m_IBackButtonsHeight, self));
    m_SaveGamesButton    = EPCTextButton(CreateControl(class'EPCTextButton', m_iFSaveGamesXPos, m_iTopButtonsYPos, m_iTopButtonsWidth, m_IBackButtonsHeight, self));
    m_LevelsButton       = EPCTextButton(CreateControl(class'EPCTextButton', m_iLevelsXPos, m_iTopButtonsYPos, m_iTopButtonsWidth, m_IBackButtonsHeight, self));
    

    m_Back.SetButtonText(Caps(Localize("HUD","Back","Localization\\HUD"))      ,TXT_CENTER);    
    m_SaveGamesButton.SetButtonText(Localize("HUD","SAVES","Localization\\HUD")  ,TXT_CENTER);
    m_LevelsButton.SetButtonText(Localize("HUD","LEVELS","Localization\\HUD")    ,TXT_CENTER);
    m_ConfirmationButton.SetButtonText(Localize("HUD","START","Localization\\HUD"),TXT_CENTER);

    m_Back.Font                 = F_Normal;    
    m_SaveGamesButton.Font      = F_Normal;    
    m_LevelsButton.Font         = F_Normal;     
    m_ConfirmationButton.Font   = F_Normal;

    m_ListBox           = EPCLevelListBox(CreateControl(class'EPCLevelListBox', m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight, self));        
    m_ListBox.Font      = F_Normal;
    m_ListBox.Align     = TXT_CENTER;

    m_FileListBox           = EPCFileListBox(CreateControl(class'EPCFileListBox', m_IListBoxXPos, m_ISaveListBoxYPos, m_IListBoxWidth, m_ISaveListBoxHeight, self));        
    m_FileListBox.Font      = F_Normal;    
    m_FileListBox.NameWidth = m_NameWidth;
    m_FileListBox.DateWidth = m_LDateWidth;

    m_LName       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IListBoxXPos, m_IListBoxYPos, m_NameWidth, m_ILabelHeight, self));
    m_LName.SetLabelText(Localize("HUD","NAME","Localization\\HUD"),TXT_LEFT);
    m_LName.Font       = F_Normal;
    m_LName.TextColor  = m_TextColor;
    m_LName.m_fLMarge  = 2;
    
    m_LDate       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_LName.WinLeft + m_LName.WinWidth, m_IListBoxYPos, m_LDateWidth, m_ILabelHeight, self));
    m_LDate.SetLabelText(Localize("HUD","DATE","Localization\\HUD"),TXT_LEFT);
    m_LDate.Font       = F_Normal;
    m_LDate.TextColor  = m_TextColor;    
    m_LDate.m_fLMarge  = 2;

    m_LTime       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_LDate.WinLeft + m_LDate.WinWidth, m_IListBoxYPos, m_IListBoxWidth - m_LDateWidth - m_NameWidth, m_ILabelHeight, self));
    m_LTime.SetLabelText(Localize("HUD","TIME","Localization\\HUD"),TXT_LEFT);
    m_LTime.Font       = F_Normal;
    m_LTime.TextColor  = m_TextColor;    
    m_LTime.m_fLMarge  = 2;


    ChangeTopButtonSelection(m_SaveGamesButton);
 
}

function ShowWindow()
{
    Super.ShowWindow();
    FillListBox();
}
 

function FillListBox()
{
    local int i;
    local EPCListBoxItem L;
    local EPCFileManager FileManager;
    local EPlayerInfo    PlayerInfo;
    local String         Path;    //Do something
	local String         Name;
    local array<string>  AllParts; // Joshua - Mission unlocked mode 

    // Joshua - Added to check for Elite mode
    local EPlayerController EPC;
    
    PlayerInfo = GetPlayerOwner().playerInfo;
    EPC = EPlayerController(GetPlayerOwner());
    
    m_FileListBox.Clear();
    //Filling Save Games
    FileManager = EPCMainMenuRootWindow(Root).m_FileManager;
    Path = "..\\Save\\"$PlayerInfo.PlayerName$"\\*.en3"; // Joshua - Enhanced save games are not compatible, changing extension to avoid confusion
    FileManager.DetailedFindFiles(Path);

    for (i = 0; i < FileManager.m_pDetailedFileList.Length; i++)
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

	// Joshua - Store the newest save game filename in EPlayerController
	if (m_FileListBox.Items.Next != None)
		EPC.LastSaveName = EPCListBoxItem(m_FileListBox.Items.Next).Caption;
	else
		EPC.LastSaveName = "";

    m_ListBox.Clear();

    //Filling Unlocked Levels
    i = 0;
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
        while (PlayerInfo.UnlockedMap[i] != "")
        {        
            // Joshua - Unlisting Vselka Submarine as it has been merged into Vselka Infiltration
            if (i == 12) 
            {
                i++;
                continue;
            }        
            L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
            L.Caption = PlayerInfo.UnlockedMap[i];

            // Original Maps
            if (i < 10)
            {
                if (PlayerInfo.LevelUnlock == LU_Enabled && !EPC.eGame.bEliteMode && !EPC.eGame.bPermadeathMode) // Joshua - Unlocks all levels, bypassing profile progression
                    L.m_bLocked = false;
                else
                    L.m_bLocked = (i > PlayerInfo.MapCompleted);
            }
            
            // Joshua - Police Station is automatically unlocked on Elite difficulty or Permadeath mode
            if (i == 1 && (EPC.eGame.bEliteMode || EPC.eGame.bPermadeathMode))
            {
               L.m_bLocked = false;
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
        if (PlayerInfo.LevelUnlock == LU_Enabled && !EPC.eGame.bEliteMode && !EPC.eGame.bPermadeathMode)
            L.m_bLocked = false;
        else
            L.m_bLocked = (PlayerInfo.MapCompleted < 9);

        L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
        L.Caption = "3_4_2Severonickel";
        if (PlayerInfo.LevelUnlock == LU_Enabled && !EPC.eGame.bEliteMode && !EPC.eGame.bPermadeathMode)
            L.m_bLocked = false;
        else
            L.m_bLocked = (PlayerInfo.MapCompleted < 9);
    }
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
        case m_Back:            
            Root.ChangeCurrentWidget(WidgetID_Previous);
            break;            
        case m_LevelsButton:            
            ChangeTopButtonSelection(EPCTextButton(C));
            break;
        case m_SaveGamesButton:                
            ChangeTopButtonSelection(EPCTextButton(C));
            break;            
        case m_ConfirmationButton:
            ConfirmButtonPressed();
            break;
        }
    }
    if ((E == DE_DoubleClick) && ((C == m_ListBox) || (C == m_FileListBox)))
    {
        ConfirmButtonPressed();
    }
}

//------------------------------------------------------------------------
// Joshua - Prototype map warning
//------------------------------------------------------------------------
function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{
    if (Result == MR_OK && m_bPendingPrototypeMapLoad)
    {
        m_bPendingPrototypeMapLoad = false;
        LoadSelectedMap();
    }
}

//------------------------------------------------------------------------
// Joshua - Check if selected map is a prototype map
//------------------------------------------------------------------------
function bool IsPrototypeMap(string MapName)
{
    return (MapName == "3_2_1_PowerPlant" || 
            MapName == "3_2_2_PowerPlant" || 
            MapName == "3_4_2Severonickel" || 
            MapName == "3_4_3Severonickel");
}

function EscapeMenu()
{
	if (!EPCConsole(Root.Console).bInGameMenuActive)
	{
		Root.PlayClickSound();
		Notify(m_Back, DE_Click);
	}
}

function ConfirmButtonPressed()
{
    // Joshua - Check if this is a prototype map that needs a warning
    if (!m_SaveGamesButton.m_bSelected && 
        EPCListBoxItem(m_ListBox.SelectedItem) != None && 
        !EPCListBoxItem(m_ListBox.SelectedItem).m_bLocked &&
        IsPrototypeMap(EPCListBoxItem(m_ListBox.SelectedItem).Caption))
    {
        m_bPendingPrototypeMapLoad = true;
        EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("Common", "PrototypeMap", "Localization\\Enhanced"), Localize("Common", "PrototypeMapWarning", "Localization\\Enhanced"), MB_OK, MR_OK, MR_OK, false);
        return;
    }

    LoadSelectedMap();
}

//------------------------------------------------------------------------
// Joshua - Converted to load selected map
//------------------------------------------------------------------------
function LoadSelectedMap()
{
    local String Error;    
    local EPlayerController EPC; // Joshua - For LastSaveName
    
	// Check valid CD in
	if (!EPCMainMenuRootWindow(Root).CheckCD())
		return;

    EPC = EPlayerController(GetPlayerOwner()); // Joshua - For LastSaveName

    if (m_SaveGamesButton.m_bSelected)
    {        
        if (m_FileListBox.SelectedItem != None)
        {
			// Joshua - Store pending load name in Console (survives load) to restore after
			EPCConsole(Root.Console).PendingLoadSaveName = EPCListBoxItem(m_FileListBox.SelectedItem).Caption;
			// Added extension (.sav) (YM)
            Error = GetPlayerOwner().ConsoleCommand("LoadGame Filename="$EPCListBoxItem(m_FileListBox.SelectedItem).Caption$".en3"); // Joshua - Enhanced save games are not compatible, changing extension to avoid confusion       
        }
        else
            return;
    }
    else
    {
        if ((EPCListBoxItem(m_ListBox.SelectedItem) != None) && (!EPCListBoxItem(m_ListBox.SelectedItem).m_bLocked))
        {
			Error = GetPlayerOwner().ConsoleCommand("Open "$EPCListBoxItem(m_ListBox.SelectedItem).Caption);
			EPCConsole(Root.Console).ReturnToGame();
        }
        else
            return;        
    }
    
    if (Error == "")
        EPCConsole(Root.Console).LaunchGame();
    else
        log("Load Error:"@Error);   
}

function ChangeTopButtonSelection(EPCTextButton _SelectMe)
{
    m_SaveGamesButton.m_bSelected    =  false;
    m_LevelsButton.m_bSelected       =  false;    

    _SelectMe.m_bSelected            =  true;
    
    switch (_SelectMe)
    {
    case m_SaveGamesButton:
        m_ListBox.HideWindow();
        m_FileListBox.ShowWindow();        
        m_LName.ShowWindow();
        m_LDate.ShowWindow();
        m_LTime.ShowWindow();
        break;
    case m_LevelsButton:        
        m_ListBox.ShowWindow();
        m_FileListBox.HideWindow();
        m_LName.HideWindow();
        m_LDate.HideWindow();
        m_LTime.HideWindow();
        break;
    }    
}

defaultproperties
{
    m_IBackButtonsXPos=68
    m_IBackButtonsHeight=18
    m_IBackButtonsWidth=240
    m_IBackButtonsYPos=353
    m_iTopButtonsYPos=143
    m_iFSaveGamesXPos=85
    m_iLevelsXPos=323
    m_iTopButtonsWidth=230
    m_iConfirmationXPos=330
    m_IListBoxXPos=83
    m_IListBoxYPos=175
    m_IListBoxWidth=475
    m_IListBoxHeight=155
    m_ISaveListBoxYPos=193
    m_ISaveListBoxHeight=137
    m_TextColor=(R=51,G=51,B=51,A=255)
    m_ILabelHeight=18
    m_NameWidth=224
    m_LDateWidth=135
}