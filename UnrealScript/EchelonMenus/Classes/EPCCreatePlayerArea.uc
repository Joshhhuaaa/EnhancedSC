//=============================================================================
//  EPCCreatePlayerArea.uc : Area of control to create a player profile
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/15 * Created by Alexandre Dionne
//=============================================================================
class EPCCreatePlayerArea extends UWindowDialogClientWindow
    config(Enhanced);

var EPCTextButton   m_ResetAllButton;     // To return to main menu
var INT             m_IResetAllXPos, m_IResetAllButtonsHeight, m_IResetAllButtonsWidth, m_IResetAllButtonsYPos; 


var UWindowLabelControl     m_LPlayerName;      //Title
var UWindowLabelControl     m_LDifficulty;      //Title
var UWindowLabelControl     m_LDifficultyNormal;
var UWindowLabelControl     m_LDifficultyHard;
var UWindowLabelControl     m_LDifficultyElite; // Joshua - Added Elite difficulty
var UWindowLabelControl     m_LPermadeathMode; // Joshua - Added Permadeath

var EPCEditControl          m_EPlayerName;      //Value

var EPCCheckBox             m_DifficultyNormal, m_DifficultyHard, m_DifficultyElite; // Joshua - Added Elite difficulty
var EPCCheckBox             m_PermadeathMode;

// Joshua - Info buttons for tooltips
var EPCInfoButton           m_EliteInfoButton;
var EPCInfoButton           m_PermadeathInfoButton;

// Joshua - Tooltip persistence
var config array<string>    ViewedTooltips;

// Joshua - Shared info button pulse animation state
var float InfoButtonPulseTimer;
var bool bInfoButtonPulseIncreasing;

var INT                     m_IXLabelPos, m_ILabelHeight, m_ILabelWidth;
var INT                     m_IPlayerNameYPos, m_IPlayerNameOffset, m_IPlayerNameWidth;
var INT                     m_IDifficultyXOffset, m_IDifficultyYPos, m_IDifficultyYOffset, m_IDifficultyRadioYPos, m_IRadioWidth;

var Color                   m_EditBorderColor;
var Color                   m_TextColor;



function Created()
{
    m_LPlayerName       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IXLabelPos, m_IPlayerNameYPos, m_ILabelWidth, m_ILabelHeight, self));
    m_LDifficulty       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IXLabelPos, m_IDifficultyYPos, m_ILabelWidth, m_ILabelHeight, self));
        
    m_EPlayerName       = EPCEditControl(CreateWindow(class'EPCEditControl', m_LPlayerName.WinLeft + m_LPlayerName.WinWidth + m_IPlayerNameOffset, m_IPlayerNameYPos, m_IPlayerNameWidth, m_ILabelHeight, self));	

    m_EPlayerName.SetBorderColor(m_EditBorderColor);
    m_EPlayerName.SetEditTextColor(m_EditBorderColor);

	// Set Profile name length to a maximum of 15 characters
    // Joshua - Reduced from 17 to 15 to match save games
    m_EPlayerName.SetMaxLength(15);

    m_LDifficultyNormal = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_EPlayerName.WinLeft + m_IDifficultyXOffset, m_IDifficultyRadioYPos, m_ILabelWidth, m_ILabelHeight, self));
    m_LDifficultyHard   = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_EPlayerName.WinLeft + m_IDifficultyXOffset, m_IDifficultyRadioYPos + m_IDifficultyYOffset, m_ILabelWidth, m_ILabelHeight, self));
    m_LDifficultyElite   = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_EPlayerName.WinLeft + m_IDifficultyXOffset, m_IDifficultyRadioYPos + m_IDifficultyYOffset * 2, m_ILabelWidth, m_ILabelHeight, self));

    m_ResetAllButton  = EPCTextButton(CreateControl(class'EPCTextButton', m_IResetAllXPos, m_IResetAllButtonsYPos, m_IResetAllButtonsWidth, m_IResetAllButtonsHeight, self));

    m_DifficultyNormal  = EPCCheckBox(CreateControl(class'EPCCheckBox', m_EPlayerName.WinLeft, m_LDifficultyNormal.WinTop, m_IRadioWidth, m_ILabelHeight, self));
    m_DifficultyHard    = EPCCheckBox(CreateControl(class'EPCCheckBox', m_EPlayerName.WinLeft, m_LDifficultyHard.WinTop, m_IRadioWidth, m_ILabelHeight, self));
    m_DifficultyElite    = EPCCheckBox(CreateControl(class'EPCCheckBox', m_EPlayerName.WinLeft, m_LDifficultyElite.WinTop, m_IRadioWidth, m_ILabelHeight, self));
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
    m_LDifficultyElite.bAcceptsMouseFocus = false; // Joshua - Don't let label interfere with info button clicks

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
    m_LPermadeathMode.bAcceptsMouseFocus = false; // Joshua - Don't let label interfere with info button clicks

    // Joshua - Initialize pulse animation
    InfoButtonPulseTimer = 0.0;
    bInfoButtonPulseIncreasing = true;

    // Joshua - Create info button for Elite difficulty (position set in BeforePaint)
    m_EliteInfoButton = EPCInfoButton(CreateControl(class'EPCInfoButton', 0, 0, 16, 16, self));
    m_EliteInfoButton.InfoText = Localize("Common", "Elite_Desc", "Localization\\Enhanced");
    m_EliteInfoButton.SettingName = Localize("Common", "Elite", "Localization\\Enhanced");
    m_EliteInfoButton.LocalizationKey = "Elite";
    m_EliteInfoButton.bStopPulsing = HasViewedTooltip("Elite");

    // Joshua - Create info button for Permadeath (position set in BeforePaint)
    m_PermadeathInfoButton = EPCInfoButton(CreateControl(class'EPCInfoButton', 0, 0, 16, 16, self));
    m_PermadeathInfoButton.InfoText = Localize("Common", "PermadeathMode_Desc", "Localization\\Enhanced");
    m_PermadeathInfoButton.SettingName = Localize("Common", "PermadeathMode", "Localization\\Enhanced");
    m_PermadeathInfoButton.LocalizationKey = "PermadeathMode";
    m_PermadeathInfoButton.bStopPulsing = HasViewedTooltip("PermadeathMode");
}

//==============================================================================
// BeforePaint - Update pulse animation for info buttons and position them
// Created by Joshua
//==============================================================================
function BeforePaint(Canvas C, float X, float Y)
{
    local float TextWidth, TextHeight;
    
    Super.BeforePaint(C, X, Y);
    
    // Position info buttons 5 pixels after their label text
    C.Font = Root.Fonts[F_Normal];
    
    // Elite info button
    TextSize(C, m_LDifficultyElite.Text, TextWidth, TextHeight);
    m_EliteInfoButton.WinLeft = m_LDifficultyElite.WinLeft + TextWidth + 5;
    m_EliteInfoButton.WinTop = m_LDifficultyElite.WinTop + (m_LDifficultyElite.WinHeight - 16) / 2;
    
    // Permadeath info button
    TextSize(C, m_LPermadeathMode.Text, TextWidth, TextHeight);
    m_PermadeathInfoButton.WinLeft = m_LPermadeathMode.WinLeft + TextWidth + 5;
    m_PermadeathInfoButton.WinTop = m_LPermadeathMode.WinTop + (m_LPermadeathMode.WinHeight - 16) / 2;
    
    // Update pulse timer for info button animation
    if (bInfoButtonPulseIncreasing)
    {
        InfoButtonPulseTimer += 0.02;
        if (InfoButtonPulseTimer >= 1.0)
        {
            InfoButtonPulseTimer = 1.0;
            bInfoButtonPulseIncreasing = false;
        }
    }
    else
    {
        InfoButtonPulseTimer -= 0.02;
        if (InfoButtonPulseTimer <= 0.0)
        {
            InfoButtonPulseTimer = 0.0;
            bInfoButtonPulseIncreasing = true;
        }
    }
}

//==============================================================================
// HasViewedTooltip - Check if a tooltip has been viewed before
// Created by Joshua
//==============================================================================
function bool HasViewedTooltip(string TooltipKey)
{
    local int i;
    
    for (i = 0; i < ViewedTooltips.Length; i++)
    {
        if (ViewedTooltips[i] == TooltipKey)
            return true;
    }
    
    return false;
}

//==============================================================================
// MarkTooltipViewed - Mark a tooltip as viewed and save config
// Created by Joshua
//==============================================================================
function MarkTooltipViewed(string TooltipKey)
{
    if (!HasViewedTooltip(TooltipKey))
    {
        ViewedTooltips[ViewedTooltips.Length] = TooltipKey;
        SaveConfig();
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

    if (m_DifficultyNormal.m_bSelected)
        baseDifficulty = 0;
    else if (m_DifficultyHard.m_bSelected)
        baseDifficulty = 1;
    else if (m_DifficultyElite.m_bSelected)
        baseDifficulty = 2;

    // Add permadeath offset (2) if enabled and not Normal difficulty
    if (m_PermadeathMode.m_bSelected && !m_DifficultyNormal.m_bSelected)
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
	if (E == DE_Click)
	{
        switch (C)
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