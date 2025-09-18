//=============================================================================
//  EPCCreatePlayerArea.uc : Area of control to create a player profile
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/15 * Created by Alexandre Dionne
//=============================================================================


class EPCCreatePlayerArea extends UWindowDialogClientWindow;


var EPCTextButton   m_ResetAllButton;     // To return to main menu
var INT             m_IResetAllXPos, m_IResetAllButtonsHeight, m_IResetAllButtonsWidth, m_IResetAllButtonsYPos; 


var UWindowLabelControl     m_LPlayerName;      //Title
var UWindowLabelControl     m_LDifficulty;      //Title
var UWindowLabelControl     m_LDifficultyNormal;
var UWindowLabelControl     m_LDifficultyHard;
var UWindowLabelControl     m_LDifficultyElite; // Joshua - Added Elite difficulty
var UWindowLabelControl     m_LPermadeathMode; // Joshua - Added Permadeath

var EPCMessageBox           m_PermadeathWarningBox; // Joshua - Added Permadeath
var bool                    bPermadeathPending; // Joshua - Added Permadeath

var EPCEditControl          m_EPlayerName;      //Value

var EPCCheckBox             m_DifficultyNormal, m_DifficultyHard, m_DifficultyElite; // Joshua - Added Elite difficulty
var EPCCheckBox             m_PermadeathMode;

var INT                     m_IXLabelPos, m_ILabelHeight, m_ILabelWidth;
var INT                     m_IPlayerNameYPos, m_IPlayerNameOffset, m_IPlayerNameWidth;
var INT                     m_IDifficultyXOffset, m_IDifficultyYPos, m_IDifficultyYOffset, m_IDifficultyRadioYPos, m_IRadioWidth;

var Color                   m_EditBorderColor;
var Color                   m_TextColor;



function Created()
{
    m_LPlayerName       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_IXLabelPos, m_IPlayerNameYPos, m_ILabelWidth, m_ILabelHeight, self));
    m_LDifficulty       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_IXLabelPos, m_IDifficultyYPos, m_ILabelWidth, m_ILabelHeight, self));
        
    m_EPlayerName       = EPCEditControl(CreateWindow( class'EPCEditControl', m_LPlayerName.WinLeft + m_LPlayerName.WinWidth + m_IPlayerNameOffset, m_IPlayerNameYPos, m_IPlayerNameWidth, m_ILabelHeight, self));	

    m_EPlayerName.SetBorderColor(m_EditBorderColor);
    m_EPlayerName.SetEditTextColor(m_EditBorderColor);

	// Set Profile name lenght to a maximum of 17 character
    m_EPlayerName.SetMaxLength(17);

    m_LDifficultyNormal = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_EPlayerName.WinLeft + m_IDifficultyXOffset, m_IDifficultyRadioYPos, m_ILabelWidth, m_ILabelHeight, self));
    m_LDifficultyHard   = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_EPlayerName.WinLeft + m_IDifficultyXOffset, m_IDifficultyRadioYPos + m_IDifficultyYOffset, m_ILabelWidth, m_ILabelHeight, self));
    m_LDifficultyElite   = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_EPlayerName.WinLeft + m_IDifficultyXOffset, m_IDifficultyRadioYPos + m_IDifficultyYOffset * 2, m_ILabelWidth, m_ILabelHeight, self));

    m_ResetAllButton  = EPCTextButton(CreateControl( class'EPCTextButton', m_IResetAllXPos, m_IResetAllButtonsYPos, m_IResetAllButtonsWidth, m_IResetAllButtonsHeight, self));

    m_DifficultyNormal  = EPCCheckBox(CreateControl( class'EPCCheckBox', m_EPlayerName.WinLeft, m_LDifficultyNormal.WinTop, m_IRadioWidth, m_ILabelHeight, self));
    m_DifficultyHard    = EPCCheckBox(CreateControl( class'EPCCheckBox', m_EPlayerName.WinLeft, m_LDifficultyHard.WinTop, m_IRadioWidth, m_ILabelHeight, self));
    m_DifficultyElite    = EPCCheckBox(CreateControl( class'EPCCheckBox', m_EPlayerName.WinLeft, m_LDifficultyElite.WinTop, m_IRadioWidth, m_ILabelHeight, self));
    m_DifficultyNormal.m_bSelected  = true;
    m_DifficultyNormal.ImageX       = 5;
    m_DifficultyNormal.ImageY       = 5;
    m_DifficultyHard.ImageX         = 5;
    m_DifficultyHard.ImageY         = 5;
    m_DifficultyElite.ImageX         = 5;
    m_DifficultyElite.ImageY         = 5;
 
    m_ResetAllButton.SetButtonText(Caps(Localize("HUD","CLEARALL","Localization\\HUD")) ,TXT_CENTER);    
    
    m_LPlayerName.SetLabelText(Localize("HUD","PLAYERNAME","Localization\\HUD"),TXT_LEFT);
    m_LDifficulty.SetLabelText(Localize("HUD","DIFFICULTY","Localization\\HUD"),TXT_LEFT);
    m_LDifficultyNormal.SetLabelText(Localize("HUD","Normal","Localization\\HUD"),TXT_LEFT);
    m_LDifficultyHard.SetLabelText(Localize("HUD","Hard","Localization\\HUD"),TXT_LEFT);
    m_LDifficultyElite.SetLabelText(Localize("Common","Elite","Localization\\Enhanced"),TXT_LEFT);
      

    m_ResetAllButton.Font     = F_Normal;    
    m_LPlayerName.Font        = F_Normal;
    m_LDifficulty.Font        = F_Normal;
    m_LDifficultyNormal.Font  = F_Normal;
    m_LDifficultyHard.Font    = F_Normal;
    m_LDifficultyElite.Font    = F_Normal;

    m_LPlayerName.TextColor         = m_TextColor;
    m_LDifficulty.TextColor         = m_TextColor;
    m_LDifficultyNormal.TextColor   = m_TextColor;
    m_LDifficultyHard.TextColor     = m_TextColor;
    m_LDifficultyElite.TextColor     = m_TextColor;

    // Joshua - Permadeath
    m_LPermadeathMode = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', 
        m_IXLabelPos,
        m_LDifficultyElite.WinTop + m_IDifficultyYOffset,
        m_ILabelWidth, m_ILabelHeight, self));
    
    m_PermadeathMode = EPCCheckBox(CreateControl(class'EPCCheckBox', 
        m_EPlayerName.WinLeft,
        m_LPermadeathMode.WinTop,
        m_IRadioWidth, m_ILabelHeight, self));

    m_PermadeathMode.ImageX = 5;
    m_PermadeathMode.ImageY = 5;
    m_PermadeathMode.bDisabled = true;
    
    m_LPermadeathMode.SetLabelText(Localize("Common", "PermadeathMode", "Localization\\Enhanced"), TXT_LEFT);
    m_LPermadeathMode.Font = F_Normal;
    m_LPermadeathMode.TextColor = m_TextColor;
}

// Joshua - Permadeath warning
function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{
    if(W == m_PermadeathWarningBox)
    {
        m_PermadeathWarningBox = None;
        if(Result == MR_Yes)
        {
            m_PermadeathMode.m_bSelected = true;
        }
        else
        {
            m_PermadeathMode.m_bSelected = false;
        }
        bPermadeathPending = false;
    }
}

function String GetProfileName()
{
    return m_EPlayerName.GetValue();
}

function INT GetDifficulty()
{
    local EPlayerController EPC;
    local int baseDifficulty;
    EPC = EPlayerController(GetPlayerOwner());

    if(m_DifficultyNormal.m_bSelected)
        baseDifficulty = 0;
    else if(m_DifficultyHard.m_bSelected)
        baseDifficulty = 1;
    else if(m_DifficultyElite.m_bSelected)
        baseDifficulty = 2;

    // Add permadeath offset (2) if enabled and not Normal difficulty
    if(m_PermadeathMode.m_bSelected && !m_DifficultyNormal.m_bSelected)
        return baseDifficulty + 2;
    else 
        return baseDifficulty;
}

function Reset()
{
    m_EPlayerName.Clear();
    m_DifficultyNormal.m_bSelected  = true;
    m_DifficultyHard.m_bSelected    = false;
    m_DifficultyElite.m_bSelected    = false;
    m_PermadeathMode.m_bSelected = false;
}

function Notify(UWindowDialogControl C, byte E)
{
	if(E == DE_Click)
	{
        switch(C)
        {
        case m_DifficultyNormal:
            m_DifficultyNormal.m_bSelected = true;
            m_DifficultyHard.m_bSelected = false;
            m_DifficultyElite.m_bSelected = false;
            m_PermadeathMode.m_bSelected = false; // Force disable permadeath
            m_PermadeathMode.bDisabled = true;    // Gray out permadeath option
            break;
        case m_DifficultyHard:
            m_DifficultyHard.m_bSelected = true;
            m_DifficultyNormal.m_bSelected = false;
            m_DifficultyElite.m_bSelected = false;
            m_PermadeathMode.bDisabled = false; // Enable permadeath option
            break;
        case m_DifficultyElite:
            m_DifficultyElite.m_bSelected = true;
            m_DifficultyNormal.m_bSelected = false;
            m_DifficultyHard.m_bSelected = false;
            m_PermadeathMode.bDisabled = false; // Enable permadeath option
            break;
        case m_PermadeathMode:
                if(m_PermadeathMode.m_bSelected)
                {
                    bPermadeathPending = true;
                    m_PermadeathMode.m_bSelected = true;
                    m_PermadeathWarningBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("Common","PermadeathMode","Localization\\Enhanced"),
                        Localize("Common","PermadeathModeWarning","Localization\\Enhanced"), MB_YesNo, MR_No, MR_No);
                }
                break;
        case m_ResetAllButton:
            Reset();
            break;
        }
    }   
}

defaultproperties
{
    m_IResetAllXPos=150
    m_IResetAllButtonsHeight=18
    m_IResetAllButtonsWidth=200
    m_IResetAllButtonsYPos=136
    m_IXLabelPos=20
    m_ILabelHeight=18
    m_ILabelWidth=190
    m_IPlayerNameYPos=10        // Joshua - Modified from 30 to fit Elite/Permadeath
    m_IPlayerNameOffset=25
    m_IPlayerNameWidth=200
    m_IDifficultyXOffset=30
    m_IDifficultyYPos=45        // Joshua - Modified from 70 to fit Elite/Permadeath
    m_IDifficultyYOffset=20     // Joshua - Modified from 25 to fit Elite/Permadeath
    m_IDifficultyRadioYPos=45   // Joshua - Modified from 70 to fit Elite/Permadeath
    m_IRadioWidth=20
    m_EditBorderColor=(R=51,G=51,B=51,A=255)
    m_TextColor=(R=51,G=51,B=51,A=255)
}