//=============================================================================
//  EPCInGameEnhancedConfigArea.uc : In-game version of Enhanced settings area
//  Created by Joshua
//=============================================================================
class EPCInGameEnhancedConfigArea extends EPCEnhancedConfigArea;

var EPCTextButton m_ResetToDefault;
var INT m_IResetToDefaultXPos, m_IResetToDefaultYPos, m_IResetToDefaultWidth, m_IResetToDefaultHeight;

function Created()
{    
    SetAcceptsFocus();

    m_ListBox = EPCEnhancedListBox(CreateWindow(class'EPCEnhancedListBox', 0, 0, WinWidth, 176));
    m_ListBox.SetAcceptsFocus();
    m_ListBox.TitleFont = F_Normal;
    
    InitEnhancedSettings();

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
        Super.Notify(C, E);
}

defaultproperties
{
    m_IResetToDefaultXPos=100
    m_IResetToDefaultYPos=186
    m_IResetToDefaultWidth=240
    m_IResetToDefaultHeight=18
}