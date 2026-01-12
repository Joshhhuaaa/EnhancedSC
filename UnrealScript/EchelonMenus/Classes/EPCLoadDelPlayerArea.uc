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

// Joshua - Controller navigation
var bool    m_bEnableArea;       // True when area is active for controller navigation
var int     m_selectedIndex;     // Index of currently selected profile in the list

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

function Created()
{
    SetAcceptsFocus();

    m_LDifficulty       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IDifficultyXPos, m_IDifficultyYPos, m_IDifficultyWidth, m_IDifficultyHeight, self));
    m_LDifficultyValue  = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IDifficultyXPos, m_IDifficultyYPos + m_IDifficultyYOffset, m_IDifficultyWidth, m_IDifficultyHeight, self));

    m_LDifficulty.SetLabelText(Caps(Localize("HUD","DIFFICULTY","Localization\\HUD")),TXT_CENTER);
    m_LDifficultyValue.Text = "";

    m_LDifficulty.Font          = F_Normal;
    m_LDifficultyValue.Font     = F_Normal;

    m_LDifficulty.TextColor         = m_TextColor;
    m_LDifficultyValue.TextColor    = m_TextColor;

    m_ListBox           = EPCListBox(CreateControl(class'EPCListBox', m_IListBoxXPos, m_IListBoxYPos, m_IListBoxWidth, m_IListBoxHeight, self));
    m_ListBox.Font      = F_Normal;
    m_ListBox.Align     = TXT_CENTER;

    m_DeleteButton  = EPCTextButton(CreateControl(class'EPCTextButton', m_IDeleteXPos, m_IDeleteButtonYPos, m_IDeleteButtonWidth, m_IDeleteButtonHeight, self));
    m_DeleteButton.SetButtonText(Caps(Localize("HUD","DELETEPROFILE","Localization\\HUD")) ,TXT_CENTER);
    m_DeleteButton.Font             = F_Normal;

    // Joshua - Initialize controller navigation
    m_bEnableArea = false;
    m_selectedIndex = 0;

    // Joshua - Initialize auto-scroll variables
    m_heldKey = 0;
    m_keyHoldTime = 0.0;
    m_nextRepeatTime = 0.0;
}

// Joshua - Check for mouse mode switch and ensure a profile is selected
function BeforePaint(Canvas C, float X, float Y)
{
    Super.BeforePaint(C, X, Y);

    // If we switched to mouse mode and no profile is selected, select the first one
    if (!Root.bDisableMouseDisplay && m_ListBox.SelectedItem == None && m_ListBox.Items.Count() > 0)
    {
        m_ListBox.SetSelectedItem(UWindowListBoxItem(m_ListBox.Items.Next));
        if (m_ListBox.SelectedItem != None)
            m_LDifficultyValue.SetLabelText(EPCListBoxItem(m_ListBox.SelectedItem).HelpText, TXT_CENTER);
    }
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

    for (i = 0; i < FileManager.m_pFileList.Length; i++)
    {
        if (GetPlayerOwner().ConsoleCommand("LOADPROFILE Name="$FileManager.m_pFileList[i]) != "INVALID_PROFILE")
        {
            L = EPCListBoxItem(m_ListBox.Items.Append(class'EPCListBoxItem'));
            L.Caption = FileManager.m_pFileList[i];
            if (GetPlayerOwner().playerInfo.Difficulty == 0)
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
    // Joshua - Only auto-select in mouse mode or if controller is actively in the list
    if (m_ListBox.Items.Count() > 0)
    {
        if (!Root.bDisableMouseDisplay || m_bEnableArea)
        {
            // Mouse mode or controller actively in list - select first item
            m_ListBox.SetSelectedItem(UWindowListBoxItem(m_ListBox.Items.Next));
            m_ListBox.MakeSelectedVisible();
        }
        else
        {
            // Controller mode but not in list - don't select anything until user enters list
            ClearSelectionHighlight();
        }
    }
}

function EmptyListBox()
{
    m_ListBox.Clear();
}

function Notify(UWindowDialogControl C, byte E)
{

	if ((E == DE_DoubleClick) && (C == m_ListBox))
	{
        if ((m_ListBox.SelectedItem != None) && (EPCPlayerMenu(OwnerWindow) != None))
            EPCPlayerMenu(OwnerWindow).ConfirmButtonPressed();

    }

    if ((E == DE_Click) && (m_ListBox.SelectedItem != None))
    {
        //log("m_ListBox.SelectedItem "@m_ListBox.SelectedItem);

        switch (C)
        {
        case m_ListBox:
            m_LDifficultyValue.SetLabelText(EPCListBoxItem(m_ListBox.SelectedItem).HelpText, TXT_CENTER);
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
    local int OldIndex;
    local int NewCount;

    if (m_MessageBox == W)
    {
        m_MessageBox = None;

        if (Result == MR_Yes)
        {
             ///////////////////////////////////////////////////////////////////////////////////
            //                  DELETE A PROFILE
            /////////////////////////////////////////////////////////////////////////////////

            FileManager = EPCMainMenuRootWindow(Root).m_FileManager;

            // Joshua - Remember current index before deletion
            OldIndex = m_selectedIndex;

            Path = "..\\Save\\"$EPCListBoxItem(m_ListBox.SelectedItem).Caption;
            FileManager.DeleteDirectory(Path, true);
            FillListBox();

            // Joshua - If we're still in controller mode and area is enabled, select previous item
            if (m_bEnableArea)
            {
                NewCount = GetProfileCount();
                if (NewCount > 0)
                {
                    // Move to previous index, or last item if we deleted the last one
                    if (OldIndex >= NewCount)
                        m_selectedIndex = NewCount - 1;
                    else if (OldIndex > 0)
                        m_selectedIndex = OldIndex - 1;
                    else
                        m_selectedIndex = 0;

                    SelectProfileAtIndex(m_selectedIndex);
                }
                else
                {
                    // No profiles left - exit the area back to tab selection
                    EnableArea(false);
                    EPCPlayerMenu(OwnerWindow).AreaExited();
                }
            }
        }

    }

}

// Joshua - Enable/disable this area for controller navigation
function EnableArea(bool bEnable)
{
    m_bEnableArea = bEnable;

    if (bEnable)
    {
        // Select first profile if available
        m_selectedIndex = 0;
        SelectProfileAtIndex(m_selectedIndex);
    }
    else
    {
        // In controller mode, clear selection highlight when leaving the list
        // Mouse users will naturally reselect by clicking
        ClearSelectionHighlight();
    }
}

// Joshua - Clear selection highlight from all items (for controller mode when not in list)
function ClearSelectionHighlight()
{
    local UWindowList CurItem;
    local UWindowListBoxItem ListItem;

    for (CurItem = m_ListBox.Items.Next; CurItem != None; CurItem = CurItem.Next)
    {
        ListItem = UWindowListBoxItem(CurItem);
        if (ListItem != None)
            ListItem.bSelected = false;
    }

    // Also clear the SelectedItem reference so SetSelectedItem will work when re-entering
    m_ListBox.SelectedItem = None;

    // Clear the difficulty text since no profile is selected
    m_LDifficultyValue.SetLabelText("", TXT_CENTER);
}

// Joshua - Get the number of profiles in the list
function int GetProfileCount()
{
    return m_ListBox.Items.Count();
}

// Joshua - Get the profile item at the specified index
function UWindowListBoxItem GetProfileAtIndex(int Index)
{
    return UWindowListBoxItem(m_ListBox.Items.FindEntry(Index));
}

// Joshua - Select a profile at the specified index
function SelectProfileAtIndex(int Index)
{
    local UWindowListBoxItem Item;
    local int Count;

    Count = GetProfileCount();
    if (Count == 0)
        return;

    // Clamp index
    if (Index < 0)
        Index = 0;
    if (Index >= Count)
        Index = Count - 1;

    m_selectedIndex = Index;

    Item = GetProfileAtIndex(Index);
    if (Item != None)
    {
        m_ListBox.SetSelectedItem(Item);
        m_ListBox.MakeSelectedVisible();
        // Update difficulty display
        m_LDifficultyValue.SetLabelText(EPCListBoxItem(Item).HelpText, TXT_CENTER);
    }
}

// Joshua - Handle controller input
// A=200, B=201, X=202, Y=203
// DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
// AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    local int ProfileCount;

    Super.WindowEvent(Msg, C, X, Y, Key);

    if (!m_bEnableArea)
        return;

    if (Msg == WM_KeyDown)
    {
        ProfileCount = GetProfileCount();

        // Track held key for auto-repeat
        if (Key == 213 || Key == 197 || Key == 212 || Key == 196)
        {
            if (m_heldKey != Key)
            {
                m_heldKey = Key;
                m_keyHoldTime = 0.0;
                m_nextRepeatTime = m_initialDelay;
            }
        }

        // Navigate down - DPadDown (213) or AnalogDown (197) - NO wrap around
        if (Key == 213 || Key == 197)
        {
            if (ProfileCount > 0 && m_selectedIndex < ProfileCount - 1)
            {
                Root.PlayClickSound();
                m_selectedIndex = m_selectedIndex + 1;
                SelectProfileAtIndex(m_selectedIndex);
            }
        }
        // Navigate up - DPadUp (212) or AnalogUp (196) - NO wrap around
        else if (Key == 212 || Key == 196)
        {
            if (ProfileCount > 0 && m_selectedIndex > 0)
            {
                Root.PlayClickSound();
                m_selectedIndex = m_selectedIndex - 1;
                SelectProfileAtIndex(m_selectedIndex);
            }
        }
        // A button - select profile (load it) (200)
        else if (Key == 200)
        {
            if (m_ListBox.SelectedItem != None && EPCPlayerMenu(OwnerWindow) != None)
            {
                Root.PlayClickSound();
                EPCPlayerMenu(OwnerWindow).ConfirmButtonPressed();
            }
        }
        // X button - delete profile (202)
        else if (Key == 202)
        {
            if (m_ListBox.SelectedItem != None)
            {
                // Clear held key state to stop auto-scroll when message box opens
                m_heldKey = 0;
                m_keyHoldTime = 0;
                Root.PlayClickSound();
                Notify(m_DeleteButton, DE_Click);
            }
        }
        // B button - exit area back to tab selection (201)
        else if (Key == 201)
        {
            // Clear held key state to stop auto-scroll when exiting
            m_heldKey = 0;
            m_keyHoldTime = 0;
            Root.PlayClickSound();
            EnableArea(false);
            EPCPlayerMenu(OwnerWindow).AreaExited();
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
    local int ProfileCount;

    Super.Tick(DeltaTime);

    if (!m_bEnableArea || m_heldKey == 0)
        return;

    m_keyHoldTime += DeltaTime;

    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        ProfileCount = GetProfileCount();

        // Navigate down - DPadDown (213) or AnalogDown (197)
        if (m_heldKey == 213 || m_heldKey == 197)
        {
            if (ProfileCount > 0 && m_selectedIndex < ProfileCount - 1)
            {
                Root.PlayClickSound();
                m_selectedIndex = m_selectedIndex + 1;
                SelectProfileAtIndex(m_selectedIndex);
            }
        }
        // Navigate up - DPadUp (212) or AnalogUp (196)
        else if (m_heldKey == 212 || m_heldKey == 196)
        {
            if (ProfileCount > 0 && m_selectedIndex > 0)
            {
                Root.PlayClickSound();
                m_selectedIndex = m_selectedIndex - 1;
                SelectProfileAtIndex(m_selectedIndex);
            }
        }

        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
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
    m_initialDelay=0.5
    m_repeatRate=0.1
}