//=============================================================================
//  EPCInGameControlsConfigArea.uc : In Game Version of controls settings area
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/06 * Created by Alexandre Dionne
//=============================================================================


class EPCInGameControlsConfigArea extends EPCControlsConfigArea;

var EPCTextButton m_ResetToDefault;
var INT m_IResetToDefaultXPos, m_IResetToDefaultYPos, m_IResetToDefaultWidth, m_IResetToDefaultHeight;

function Created()
{
    SetAcceptsFocus();

    m_ListBox = EPCOptionKeysListBox(CreateControl(class'EPCOptionKeysListBox', 0, 0, WinWidth, 176, self));            
    InitOptionControls();
    m_ListBox.TitleFont = F_Normal;

    m_ResetToDefault = EPCTextButton(CreateControl(class'EPCTextButton', m_IResetToDefaultXPos, m_IResetToDefaultYPos, m_IResetToDefaultWidth, m_IResetToDefaultHeight, self));
    m_ResetToDefault.SetButtonText(Caps(Localize("OPTIONS","RESETTODEFAULT","Localization\\HUD")) ,TXT_CENTER);
    m_ResetToDefault.Font = F_Normal;
}


function Notify(UWindowDialogControl C, byte E)
{    

    if (E == DE_Click && C == m_ResetToDefault)
	{
           ResetToDefault();            
	}
    else
        Super.Notify(C,E);
}

defaultproperties
{
    m_IResetToDefaultXPos=100
    m_IResetToDefaultYPos=186
    m_IResetToDefaultWidth=240
    m_IResetToDefaultHeight=18
}