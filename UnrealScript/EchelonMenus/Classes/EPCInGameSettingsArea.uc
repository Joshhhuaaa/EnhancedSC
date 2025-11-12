//=============================================================================
//  EPCInGameSettingsArea.uc : In Game Options Area
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/06 * Created by Alexandre Dionne
//=============================================================================


class EPCInGameSettingsArea extends EPCOptionsMenu
                native;

function Created()
{    
    m_Controls    = EPCTextButton(CreateControl(class'EPCTextButton', m_iFirstSectionButtonsXPos, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    m_Graphics    = EPCTextButton(CreateControl(class'EPCTextButton', m_Controls.WinLeft + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    m_Sounds      = EPCTextButton(CreateControl(class'EPCTextButton', m_Graphics.WinLeft + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    // Joshua - Enhanced settings
    m_Enhanced    = EPCTextButton(CreateControl(class'EPCTextButton', m_Sounds.WinLeft + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
   
    m_Controls.SetButtonText(Caps(Localize("HUD","CONTROLS","Localization\\HUD")) ,TXT_CENTER);
    m_Graphics.SetButtonText(Caps(Localize("HUD","GRAPHICS","Localization\\HUD")) ,TXT_CENTER);
    m_Sounds.SetButtonText(Caps(Localize("HUD","SOUNDS","Localization\\HUD")) ,TXT_CENTER);
    // Joshua - Enhanced settings
    m_Enhanced.SetButtonText(Caps(Localize("HUD","Enhanced","Localization\\Enhanced")) ,TXT_CENTER);
    
    m_Controls.Font         = EPCMainMenuRootWindow(Root).TitleFont;    
    m_Graphics.Font         = EPCMainMenuRootWindow(Root).TitleFont;   
    m_Sounds.Font           = EPCMainMenuRootWindow(Root).TitleFont;
    m_Enhanced.Font         = EPCMainMenuRootWindow(Root).TitleFont;  // Joshua - Enhanced settings

    m_GraphicArea = EPCVideoConfigArea(CreateWindow(class'EPCInGameVideoConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_GraphicArea.HideWindow();

    m_SoundsArea = EPCSoundConfigArea(CreateWindow(class'EPCInGameSoundConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_SoundsArea.HideWindow();

    // Joshua - Enhanced settings
    m_EnhancedArea = EPCEnhancedConfigArea(CreateWindow(class'EPCInGameEnhancedConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_EnhancedArea.HideWindow();

    m_ControlsArea = EPCControlsConfigArea(CreateWindow(class'EPCInGameControlsConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_ControlsArea.HideWindow();

    ChangeTopButtonSelection(m_Controls);    

}

function ChangeTopButtonSelection(EPCTextButton _SelectMe)
{
    m_Controls.m_bSelected      =  false;
    m_Graphics.m_bSelected      =  false;
    m_Sounds.m_bSelected        =  false;
    m_Enhanced.m_bSelected      =  false;  // Joshua - Enhanced settings

    m_GraphicArea.HideWindow();
    m_SoundsArea.HideWindow();    
    m_ControlsArea.HideWindow();
    m_EnhancedArea.HideWindow();  // Joshua - Enhanced settings
    
    switch (_SelectMe)
    {
    case m_Controls:
        m_Controls.m_bSelected      =  true;
        m_ControlsArea.ShowWindow();        
        break;
    case m_Graphics:
        m_Graphics.m_bSelected      =  true;
        m_GraphicArea.ShowWindow();
        break;
    case m_Sounds:
        m_Sounds.m_bSelected        =  true;
        m_SoundsArea.ShowWindow();
        break;
    case m_Enhanced:  // Joshua - Enhanced settings
        m_Enhanced.m_bSelected      =  true;
        m_EnhancedArea.ShowWindow();
        break;
    }
}

function Reset()
{
    m_ControlsArea.Refresh();
    m_SoundsArea.Refresh();
    m_GraphicArea.Refresh(); 
    m_EnhancedArea.Refresh(); 

	if (m_Sounds.m_bSelected)
		ChangeTopButtonSelection(m_Sounds);    
	else if (m_Graphics.m_bSelected)
		ChangeTopButtonSelection(m_Graphics);    
	else if (m_Controls.m_bSelected)
		ChangeTopButtonSelection(m_Controls);
    else if (m_Enhanced.m_bSelected)
        ChangeTopButtonSelection(m_Enhanced);
}

function Paint(Canvas C, FLOAT X, FLOAT Y)
{
    Render(C, X, Y);
}

defaultproperties
{
    m_iSectionButtonsYPos=5
    m_iFirstSectionButtonsXPos=6
    m_iSectionButtonsXOffset=110 // Joshua - Reduced from 148 to fit "Enhanced" button in Settings
    m_iSectionButtonsWidth=108 // Joshua - Reduced from 144 to fit "Enhanced" button in Settings
    m_IAreaXPos=7
    m_IAreaYPos=37
    m_IAreaWidth=434
    m_IAreaHeight=206
}