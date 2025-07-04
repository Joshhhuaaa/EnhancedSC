//=============================================================================
//  EPCLoadDelPlayerArea.uc : List box and detail of existing profiles
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/15 * Created by Alexandre Dionne
//=============================================================================


class EPCLoadDelPlayerArea extends UWindowDialogClientWindow;

var UWindowLabelControl     m_LDifficulty;      //Title
var UWindowLabelControl     m_LDifficultyValue;
var Color                   m_TextColor;

var INT                     m_IDifficultyXPos, m_IDifficultyYPos, m_IDifficultyWidth, m_IDifficultyHeight, m_IDifficultyYOffset;

var EPCListBox              m_ListBox;
var INT                     m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight;

var EPCTextButton   m_DeleteButton;     // To return to main menu
var INT             m_IDeleteXPos, m_IDeleteButtonHeight, m_IDeleteButtonWidth, m_IDeleteButtonYPos; 

var EPCMessageBox        m_MessageBox;

function Created()
{
    m_LDifficulty       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_IDifficultyXPos, m_IDifficultyYPos, m_IDifficultyWidth, m_IDifficultyHeight, self));    
    m_LDifficultyValue  = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_IDifficultyXPos, m_IDifficultyYPos + m_IDifficultyYOffset, m_IDifficultyWidth, m_IDifficultyHeight, self));    
    
    m_LDifficulty.SetLabelText(Caps(Localize("HUD","DIFFICULTY","Localization\\HUD")),TXT_CENTER);    
    m_LDifficultyValue.Text = "";

    m_LDifficulty.Font          = F_Normal;
    m_LDifficultyValue.Font     = F_Normal;

    m_LDifficulty.TextColor         = m_TextColor;    
    m_LDifficultyValue.TextColor    = m_TextColor;    

    m_ListBox           = EPCListBox(CreateControl( class'EPCListBox', m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight, self));        
    m_ListBox.Font      = F_Normal;
    m_ListBox.Align     = TXT_CENTER;   

    m_DeleteButton  = EPCTextButton(CreateControl( class'EPCTextButton', m_IDeleteXPos, m_IDeleteButtonYPos, m_IDeleteButtonWidth, m_IDeleteButtonHeight, self));
    m_DeleteButton.SetButtonText(Caps(Localize("HUD","DELETEPROFILE","Localization\\HUD")) ,TXT_CENTER);    
    m_DeleteButton.Font             = F_Normal;    
}

function ShowWindow()
{
    Super.ShowWindow();    
    FillListBox();
}

function FillListBox()
{
    //Load valid Profiles

    local int i;
    local EPCListBoxItem L;
    local EPCFileManager FileManager;

    m_ListBox.Clear();
    m_LDifficultyValue.Text = "";   

    FileManager = EPCMainMenuRootWindow(Root).m_FileManager;
   
    FileManager.FindFiles("..\\Save\\*.*", false, true);    
    
    for(i=0; i< FileManager.m_pFileList.Length ; i++)
    {   
        if( GetPlayerOwner().ConsoleCommand("LOADPROFILE Name="$FileManager.m_pFileList[i]) != "INVALID_PROFILE")
        {            
            L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
            L.Caption = FileManager.m_pFileList[i];
            if( GetPlayerOwner().playerInfo.Difficulty == 0)
                L.HelpText = Localize("HUD","Normal","Localization\\HUD");
            else if (GetPlayerOwner().playerInfo.Difficulty == 1)
                L.HelpText = Localize("HUD","Hard","Localization\\HUD");
            // Joshua - Adding Elite difficulty and permadeath mode
            else if (GetPlayerOwner().playerInfo.Difficulty == 2)
                L.HelpText = Localize("Common","Elite","Localization\\Enhanced");
            else if (GetPlayerOwner().playerInfo.Difficulty == 3)
                L.HelpText = Localize("Common","HardPermadeath","Localization\\Enhanced");
            else if (GetPlayerOwner().playerInfo.Difficulty == 4)
                L.HelpText = Localize("Common","ElitePermadeath","Localization\\Enhanced");
        }        
        //else this is not a valid profile
        else
            log("Invalid profile");
    }

    //Selects first element of the list box
    if(m_ListBox.Items.Count() > 0)
    {
        m_ListBox.SetSelectedItem(UWindowListBoxItem(m_ListBox.Items.Next));
        m_ListBox.MakeSelectedVisible(); 
    }
        


}

function EmptyListBox()
{
    m_ListBox.Clear();
}

function Notify(UWindowDialogControl C, byte E)
{    

	if( (E == DE_DoubleClick) && (C == m_ListBox))
	{        
        if( (m_ListBox.SelectedItem != None) && (EPCPlayerMenu(OwnerWindow) != None) )
            EPCPlayerMenu(OwnerWindow).ConfirmButtonPressed();        
        
    }
    
    if( (E == DE_Click) && (m_ListBox.SelectedItem != None))
    {
        //log("m_ListBox.SelectedItem "@m_ListBox.SelectedItem);

        switch(C)
        {
        case m_ListBox:
            m_LDifficultyValue.SetLabelText( EPCListBoxItem(m_ListBox.SelectedItem).HelpText, TXT_CENTER);    
            break;
        case m_DeleteButton:
            m_MessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("OPTIONS","DELETEPROFILE","Localization\\HUD"), Localize("OPTIONS","DELETEPROFILEMESSAGE","Localization\\HUD"), MB_YesNo, MR_No, MR_No);
           
            break;

        }
        
    }
    
    
}

function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{
    local EPCFileManager FileManager;
    local String Path;

    if(m_MessageBox == W)
    {
        m_MessageBox = None;

        if(Result == MR_Yes)
        {
             ///////////////////////////////////////////////////////////////////////////////////
            //                  DELETE A PROFILE
            /////////////////////////////////////////////////////////////////////////////////
    
            FileManager = EPCMainMenuRootWindow(Root).m_FileManager;             

            Path = "..\\Save\\"$EPCListBoxItem(m_ListBox.SelectedItem).Caption;
            FileManager.DeleteDirectory(Path, true);
            FillListBox();    
        }
            
    }    

}

defaultproperties
{
    m_TextColor=(R=71,G=71,B=71,A=255)
    m_IDifficultyXPos=255
    m_IDifficultyYPos=40
    m_IDifficultyWidth=210
    m_IDifficultyHeight=18
    m_IDifficultyYOffset=20
    m_IListBoxXPos=14
    m_IListBoxYPos=20
    m_IListBoxWidth=215
    m_IListBoxHeight=86
    m_IDeleteXPos=130
    m_IDeleteButtonHeight=18
    m_IDeleteButtonWidth=240
    m_IDeleteButtonYPos=136
}