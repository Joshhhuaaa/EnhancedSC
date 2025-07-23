//=============================================================================
//  EPCOptionsMenu.uc : User option menu
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/10 * Created by Alexandre Dionne
//=============================================================================


class EPCOptionsMenu extends EPCMenuPage
                    native;

var EPCTextButton   m_MainMenu, m_ResetToDefault;
var INT             m_IMainButtonsXPos, m_IMainButtonsHeight, m_IMainButtonsWidth, m_IMainButtonsYPos; 
var INT             m_IResetToDefaultXPos;

var EPCTextButton   m_Controls;
var EPCTextButton   m_Graphics;
var EPCTextButton   m_Sounds;
var INT             m_iSectionButtonsYPos, m_iFirstSectionButtonsXPos, m_iSectionButtonsXOffset, m_iSectionButtonsWidth;


var EPCVideoConfigArea      m_GraphicArea;
var EPCSoundConfigArea      m_SoundsArea;
var EPCControlsConfigArea   m_ControlsArea;


var INT                  m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight;

var EPCMessageBox        m_MessageBox;

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================

var EPCTextButton   m_Enhanced; // Joshua - Enhanced settings
var EPCEnhancedConfigArea   m_EnhancedArea; // Joshua - Enhanced settings

function Created()
{
	SetAcceptsFocus();
    m_MainMenu  = EPCTextButton(CreateControl(class'EPCTextButton', m_IMainButtonsXPos, m_IMainButtonsYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_MainMenu.SetButtonText(Caps(Localize("HUD","MAINMENU","Localization\\HUD")) ,TXT_CENTER);
    m_MainMenu.Font = F_Normal;

    m_ResetToDefault = EPCTextButton(CreateControl(class'EPCTextButton', m_IResetToDefaultXPos, m_IMainButtonsYPos, m_IMainButtonsWidth, m_IMainButtonsHeight, self));
    m_ResetToDefault.SetButtonText(Caps(Localize("OPTIONS","RESETTODEFAULT","Localization\\HUD")) ,TXT_CENTER);
    m_ResetToDefault.Font = F_Normal;

    
    m_Controls    = EPCTextButton(CreateControl(class'EPCTextButton', m_iFirstSectionButtonsXPos, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    m_Graphics    = EPCTextButton(CreateControl(class'EPCTextButton', m_Controls.WinLeft + m_iSectionButtonsWidth + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    m_Sounds      = EPCTextButton(CreateControl(class'EPCTextButton', m_Graphics.WinLeft + m_iSectionButtonsWidth + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
    // Joshua - Enhanced settings
    m_Enhanced    = EPCTextButton(CreateControl(class'EPCTextButton', m_Sounds.WinLeft + m_iSectionButtonsWidth + m_iSectionButtonsXOffset, m_iSectionButtonsYPos, m_iSectionButtonsWidth, m_IMainButtonsHeight, self));
   
    m_Controls.SetButtonText(Caps(Localize("HUD","CONTROLS","Localization\\HUD")) ,TXT_CENTER);
    m_Graphics.SetButtonText(Caps(Localize("HUD","GRAPHICS","Localization\\HUD")) ,TXT_CENTER);
    m_Sounds.SetButtonText(Caps(Localize("HUD","SOUNDS","Localization\\HUD")) ,TXT_CENTER);
    // Joshua - Enhanced settings
    m_Enhanced.SetButtonText(Caps(Localize("HUD","Enhanced","Localization\\Enhanced")) ,TXT_CENTER);
    
    m_Controls.Font         = F_Normal;
    m_Graphics.Font         = F_Normal;
    m_Sounds.Font           = F_Normal;
    m_Enhanced.Font         = F_Normal;  // Joshua - Enhanced settings

    m_GraphicArea = EPCVideoConfigArea(CreateWindow(class'EPCVideoConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));
    m_GraphicArea.HideWindow();

    m_SoundsArea = EPCSoundConfigArea(CreateWindow(class'EPCSoundConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));    
    m_SoundsArea.HideWindow();

    m_ControlsArea = EPCControlsConfigArea(CreateWindow(class'EPCControlsConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));    
    m_ControlsArea.HideWindow();

    // Joshua - Enhanced settings
    m_EnhancedArea = EPCEnhancedConfigArea(CreateWindow(class'EPCEnhancedConfigArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight, self));    
    m_EnhancedArea.HideWindow();


    ChangeTopButtonSelection(m_Controls);    
 
}

function ChangeTopButtonSelection( EPCTextButton _SelectMe)
{
    m_Controls.m_bSelected      =  false;
    m_Graphics.m_bSelected      =  false;
    m_Sounds.m_bSelected        =  false;
    m_Enhanced.m_bSelected      =  false;  // Joshua - Enhanced settings

    m_GraphicArea.HideWindow();
    m_SoundsArea.HideWindow();    
    m_ControlsArea.HideWindow();
    m_EnhancedArea.HideWindow();  // Joshua - Enhanced settings
    
    switch(_SelectMe)
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
        m_Sounds.m_bSelected      =  true;
        m_SoundsArea.ShowWindow();
        break;
    case m_Enhanced:  // Joshua - Enhanced settings
        m_Enhanced.m_bSelected      =  true;
        m_EnhancedArea.ShowWindow();
        break;
    }
}


function Paint(Canvas C, float MouseX, float MouseY)
{
    Render( C , MouseX, MouseY);
}

function ShowWindow()
{
    Super.ShowWindow();

	if(m_ControlsArea.m_bFirstRefresh)
		m_ControlsArea.Refresh();
	if(m_SoundsArea.m_bFirstRefresh)
		m_SoundsArea.Refresh();
    if(m_GraphicArea.m_bFirstRefresh)
		m_GraphicArea.Refresh();    
    if(m_EnhancedArea.m_bFirstRefresh)  // Joshua - Enhanced settings
		m_EnhancedArea.Refresh();    
}


function Notify(UWindowDialogControl C, byte E)
{    
    
    if(E == DE_Click)
    {
        switch(C)
        {
        case m_MainMenu:
            if(m_SoundsArea.m_bModified || m_GraphicArea.m_bModified || m_ControlsArea.m_bModified || m_EnhancedArea.m_bModified)
                m_MessageBox = EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, Localize("OPTIONS","SETTINGSCHANGE","Localization\\HUD"), Localize("OPTIONS","SETTINGSCHANGEMESSAGE","Localization\\HUD"), MB_YesNo, MR_No, MR_No);
            else
                Root.ChangeCurrentWidget(WidgetID_MainMenu);
            break;  
            
        case m_Controls:
        case m_Graphics:
        case m_Sounds:
        case m_Enhanced:  // Joshua - Enhanced settings
            ChangeTopButtonSelection( EPCTextButton(C));
            break;
        case m_ResetToDefault:               
            if(m_Controls.m_bSelected)
            {
                m_ControlsArea.ResetToDefault();
            }              
            else if(m_Graphics.m_bSelected)
            {                
                m_GraphicArea.ResetToDefault();
            }
            else if(m_Sounds.m_bSelected)
            {                
                m_SoundsArea.ResetToDefault();
            }
            else if(m_Enhanced.m_bSelected)
            {
                m_EnhancedArea.ResetToDefault();
            }
            break;
        }
    }
}

//Go Back to main menu with escape:
function EscapeMenu()
{
	if(!EPCConsole(Root.Console).bInGameMenuActive &&
	   m_ControlsArea.m_MessageBox == none)
	{
		Root.PlayClickSound();
		Notify(m_MainMenu, DE_Click);
	}
}

function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{  
    local EPCGameOptions GO;

    if(m_MessageBox == W)
    {
        m_MessageBox = None;

        if(Result == MR_Yes)
        {
			GO = class'Actor'.static.GetGameOptions();
			GO.oldResolution = GO.Resolution;
			GO.oldEffectsQuality = GO.EffectsQuality;
			GO.oldShadowResolution = GO.ShadowResolution;

            //We chose to accept Settings Change
            m_GraphicArea.SaveOptions();
            m_SoundsArea.SaveOptions();
            m_ControlsArea.SaveOptions();
            m_EnhancedArea.SaveOptions();
            			
            GO.UpdateEngineSettings();
        }
        else
        {
            //We chose to deny settings change
            GetPlayerOwner().LoadKeyboard();    //We make sure we don't take any keyboard modification in consideration
        }

        Root.ChangeCurrentWidget(WidgetID_MainMenu);   
    }    

}

defaultproperties
{
    m_IMainButtonsXPos=68
    m_IMainButtonsHeight=18
    m_IMainButtonsWidth=240
    m_IMainButtonsYPos=353
    m_IResetToDefaultXPos=330
    m_iSectionButtonsYPos=143
    m_iFirstSectionButtonsXPos=86
    m_iSectionButtonsXOffset=5
    m_iSectionButtonsWidth=113 // Joshua - Reduced from 153 to fit "Enhanced" button in Settings
    m_IAreaXPos=83
    m_IAreaYPos=175
    m_IAreaWidth=475
    m_IAreaHeight=155
}