//=============================================================================
//  EPCInGameSoundConfigArea.uc : In Game Version of Sound display Area
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/06 * Created by Alexandre Dionne
//=============================================================================


class EPCInGameSoundConfigArea extends EPCSoundConfigArea;

var EPCTextButton m_ResetToDefault;
var INT m_IResetToDefaultXPos, m_IResetToDefaultYPos, m_IResetToDefaultWidth, m_IResetToDefaultHeight;

function Created()
{
    Super.Created();
    
    m_ResetToDefault = EPCTextButton(CreateControl( class'EPCTextButton', m_IResetToDefaultXPos, m_IResetToDefaultYPos, m_IResetToDefaultWidth, m_IResetToDefaultHeight, self));
    m_ResetToDefault.SetButtonText(Caps(Localize("OPTIONS","RESETTODEFAULT","Localization\\HUD")) ,TXT_CENTER);
    m_ResetToDefault.Font = F_Normal;
}

function Notify(UWindowDialogControl C, byte E)
{		
    
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
    m_IScrollWidth=130 // Joshua - Reduced from 150 to fit the new label
    m_IDropDownLabelYPos=110
    m_ILabel3DAccXPos=250
    m_IEaxYPos=135
    m_TextColor=(R=51,G=51,B=51,A=255)
    m_BorderColor=(R=0,G=0,B=0,A=255)
}