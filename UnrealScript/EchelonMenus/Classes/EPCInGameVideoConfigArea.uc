//=============================================================================
//  EPCInGameVideoConfigArea.uc : InGame Version of video config Area
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/06 * Created by Alexandre Dionne
//=============================================================================


class EPCInGameVideoConfigArea extends EPCVideoConfigArea;

var EPCTextButton m_ResetToDefault;
var INT m_IResetToDefaultXPos, m_IResetToDefaultYPos, m_IResetToDefaultWidth, m_IResetToDefaultHeight;

function Created()
{
    SetAcceptsFocus();

    m_ListBox = EPCOptionsListBoxEnhanced(CreateWindow(class'EPCOptionsListBoxEnhanced', 0, 0, WinWidth, 176));
    m_ListBox.SetAcceptsFocus();
    m_ListBox.bAlwaysBehind = true;
    m_ListBox.m_ILabelXPos = m_ILabelXPos;
    m_ListBox.m_ILabelWidth = m_ILabelWidth;
    m_ListBox.m_ILineItemHeight = m_ILineItemHeight;
    m_ListBox.m_ITitleLineItemHeight = m_ITitleLineItemHeight;
    
    InitVideoOptions();
    m_ListBox.TitleFont=F_Normal;
    
    m_ResetToDefault = EPCTextButton(CreateControl( class'EPCTextButton', m_IResetToDefaultXPos, m_IResetToDefaultYPos, m_IResetToDefaultWidth, m_IResetToDefaultHeight, self));
    m_ResetToDefault.SetButtonText(Caps(Localize("OPTIONS","RESETTODEFAULT","Localization\\HUD")) ,TXT_CENTER);
    m_ResetToDefault.Font = F_Normal;
}


function Notify(UWindowDialogControl C, byte E)
{	
    local EPCGameOptions GO;
    
	if(E == DE_Click && C == m_ResetToDefault)
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
    m_ILabelWidth=225
    m_IScrollWidth=150
    m_BorderColor=(R=0,G=0,B=0,A=255)
}