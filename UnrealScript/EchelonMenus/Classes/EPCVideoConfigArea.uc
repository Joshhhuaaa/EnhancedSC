//=============================================================================
//  EPCVideoConfigArea.uc : Area containing controls for video settings
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/25 * Created by Alexandre Dionne
//=============================================================================


class EPCVideoConfigArea extends UWindowDialogClientWindow;

var EPCHScrollBar       m_GammaScroll, m_BrightnessScroll;

var EPCComboControl     m_ComboResolution;
var EPCComboControl     m_ComboShadowResolution;
var EPCComboControl     m_ComboShadow;
var EPCComboControl     m_ComboTerrain;
var EPCComboControl     m_ComboEffectsQuality;

var UWindowLabelControl     m_LResolution;
var UWindowLabelControl     m_LShadowResolution;
var UWindowLabelControl     m_LShadow;

var UWindowLabelControl     m_LGamma;
var UWindowLabelControl     m_LBrightness;
var UWindowLabelControl     m_LEffectsQuality;

var INT                     m_ILabelXPos, m_ILabelWidth, m_ILabelHeight, m_IControlXPos, m_IComboWidth;
var INT                     m_IFirstYPos, m_IYOffset, m_IButtonsWidth;
var INT                     m_IScrollyOffset, m_IScrollWidth;

var Color                   m_TextColor;

var bool                    m_bModified;    //A setting has changed
var bool					m_bFirstRefresh;

function Created()
{
	local EPCGameOptions GO;  
	
    GO = class'Actor'.static.GetGameOptions();

    m_LResolution = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabelXPos, m_IFirstYPos, m_ILabelWidth, m_ILabelHeight, self));
    m_LResolution.SetLabelText(Localize("HUD","RESOLUTION","Localization\\HUD"),TXT_LEFT);
    m_LResolution.Font       = F_Normal;
    m_LResolution.TextColor  = m_TextColor;

    m_ComboResolution   = EPCComboControl(CreateControl(class'EPCComboControl',m_ILabelXPos + m_ILabelWidth, m_LResolution.WinTop, m_IComboWidth ,m_ILabelHeight));	
	m_ComboResolution.SetFont(F_Normal);
	m_ComboResolution.SetEditable(False);
    m_ComboResolution.AddItem("640x480");
	if (GO.VidMem != 0)
	{
		m_ComboResolution.AddItem("800x600");
		m_ComboResolution.AddItem("1024x768");
		m_ComboResolution.AddItem("1280x1024");
	}
	if (GO.VidMem == 2)
	{
		m_ComboResolution.AddItem("1600x1200");
	}
	m_ComboResolution.SetValue(GetPlayerOwner().ConsoleCommand("GetCurrentRes"));
	

    m_LShadowResolution = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabelXPos, m_LResolution.WinTop + m_IYOffset, m_ILabelWidth, m_ILabelHeight, self));
    m_LShadowResolution.SetLabelText(Localize("HUD","SHADOWRES","Localization\\HUD"),TXT_LEFT);
    m_LShadowResolution.Font       = F_Normal;
    m_LShadowResolution.TextColor  = m_TextColor;

    m_ComboShadowResolution   = EPCComboControl(CreateControl(class'EPCComboControl',m_ILabelXPos + m_ILabelWidth,m_LShadowResolution.WinTop,m_IComboWidth,m_ILabelHeight));	
	m_ComboShadowResolution.SetFont(F_Normal);
	m_ComboShadowResolution.SetEditable(False);
    m_ComboShadowResolution.AddItem(Localize("HUD","LOW","Localization\\HUD"));
	m_ComboShadowResolution.AddItem(Localize("HUD","MEDIUM","Localization\\HUD"));

	if (GO.VidMem == 2)
	{
		m_ComboShadowResolution.AddItem(Localize("HUD","HIGH","Localization\\HUD"));
	}
	m_ComboShadowResolution.SetSelectedIndex(0);    

    m_LShadow     = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabelXPos, m_LShadowResolution.WinTop + m_IYOffset, m_ILabelWidth, m_ILabelHeight, self));
    m_LShadow.SetLabelText(Localize("HUD","SHADOWS","Localization\\HUD"),TXT_LEFT);
    m_LShadow.Font       = F_Normal;
    m_LShadow.TextColor  = m_TextColor;

    m_ComboShadow = EPCComboControl(CreateControl(class'EPCComboControl',m_ILabelXPos + m_ILabelWidth, m_LShadow.WinTop,m_IComboWidth,m_ILabelHeight));	
	m_ComboShadow.SetFont(F_Normal);
	m_ComboShadow.SetEditable(False);
    m_ComboShadow.AddItem(Localize("HUD","LOW","Localization\\HUD"));
	m_ComboShadow.AddItem(Localize("HUD","MEDIUM","Localization\\HUD"));
    m_ComboShadow.AddItem(Localize("HUD","HIGH","Localization\\HUD"));     
	m_ComboShadow.SetSelectedIndex(0);        

    m_LEffectsQuality     = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabelXPos, m_LShadow.WinTop + m_IYOffset, m_ILabelWidth, m_ILabelHeight, self));
    m_LEffectsQuality.SetLabelText(Localize("HUD","EFFECTSQUALITY","Localization\\HUD"),TXT_LEFT);
    m_LEffectsQuality.Font       = F_Normal;
    m_LEffectsQuality.TextColor  = m_TextColor;

    m_ComboEffectsQuality = EPCComboControl(CreateControl(class'EPCComboControl',m_ILabelXPos + m_ILabelWidth, m_LEffectsQuality.WinTop,m_IComboWidth,m_ILabelHeight));	
	m_ComboEffectsQuality.SetFont(F_Normal);
	m_ComboEffectsQuality.SetEditable(False);
    m_ComboEffectsQuality.AddItem(Localize("HUD","LOW","Localization\\HUD"));
	m_ComboEffectsQuality.AddItem(Localize("HUD","MEDIUM","Localization\\HUD"));
	if (GO.VidMem != 0)
	{
		m_ComboEffectsQuality.AddItem(Localize("HUD","HIGH","Localization\\HUD")); 
	}
	if (GO.VidMem == 2)
	{    
		m_ComboEffectsQuality.AddItem(Localize("HUD","VERYHIGH","Localization\\HUD"));  
	}   
	m_ComboEffectsQuality.SetSelectedIndex(0);  

	m_LGamma      = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabelXPos, m_LEffectsQuality.WinTop + m_IYOffset, m_ILabelWidth, m_ILabelHeight, self));
    m_LGamma.SetLabelText(Localize("HUD","GAMMA","Localization\\HUD"),TXT_LEFT);
    m_LGamma.Font       = F_Normal;
    m_LGamma.TextColor  = m_TextColor;

	m_GammaScroll = EPCHScrollBar(CreateControl( class'EPCHScrollBar', m_ILabelXPos + m_ILabelWidth, m_LEffectsQuality.WinTop + m_IScrollyOffset, m_IScrollWidth, LookAndFeel.Size_HScrollbarHeight, self));
    m_GammaScroll.SetScrollHeight(12);
    m_GammaScroll.SetRange(0, 100, 1);   
	
	m_LBrightness = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabelXPos, m_LGamma.WinTop + m_IYOffset, m_ILabelWidth, m_ILabelHeight, self));
    m_LBrightness.SetLabelText(Localize("HUD","BRIGHTNESS","Localization\\HUD"),TXT_LEFT);
    m_LBrightness.Font       = F_Normal;
    m_LBrightness.TextColor  = m_TextColor;

	m_BrightnessScroll = EPCHScrollBar(CreateControl( class'EPCHScrollBar', m_ILabelXPos + m_ILabelWidth, m_LGamma.WinTop + m_IScrollyOffset, m_IScrollWidth, LookAndFeel.Size_HScrollbarHeight, self));
    m_BrightnessScroll.SetScrollHeight(12);
    m_BrightnessScroll.SetRange(0, 100, 1);        
  
}

function Refresh()
{
    local EPCGameOptions GO;  
	
    GO = class'Actor'.static.GetGameOptions();

	m_GammaScroll.Pos = Clamp(GO.Gamma,0,99);	
	m_BrightnessScroll.Pos = Clamp(GO.Brightness,0,99);    
	
    m_ComboResolution.SetValue(GetPlayerOwner().ConsoleCommand("GetCurrentRes"));
    m_ComboShadowResolution.SetSelectedIndex(Clamp(GO.ShadowResolution,0,m_ComboShadowResolution.List.Items.Count()));    
    m_ComboShadow.SetSelectedIndex(Clamp(GO.ShadowLevel,0,m_ComboShadow.List.Items.Count() -1));        
    m_ComboEffectsQuality.SetSelectedIndex(Clamp(GO.EffectsQuality,0,m_ComboEffectsQuality.List.Items.Count() -1));            

	m_bModified     = false;
	m_bFirstRefresh = false;
}

function ResetToDefault()
{
    local EPCGameOptions GO; 
    local string oldRes;

	GO = class'Actor'.static.GetGameOptions();
	GO.oldResolution = GO.Resolution;
	GO.oldEffectsQuality = GO.EffectsQuality;
	GO.oldShadowResolution = GO.ShadowResolution;

	GO.ResetGraphicsToDefault();
	GO.UpdateEngineSettings();   

	Refresh(); 
}

function SaveOptions()
{
    local EPCGameOptions GO;    
	
    GO = class'Actor'.static.GetGameOptions();

    GO.Resolution = m_ComboResolution.GetValue();
    GO.ShadowResolution = m_ComboShadowResolution.GetSelectedIndex();    
    GO.ShadowLevel = m_ComboShadow.GetSelectedIndex();        
    GO.EffectsQuality = m_ComboEffectsQuality.GetSelectedIndex();        

	GO.Brightness = m_BrightnessScroll.Pos;
	GO.Gamma   = m_GammaScroll.Pos;
	
}

function Notify(UWindowDialogControl C, byte E)
{
    if(E == DE_Change)
    {
        switch(C)
        {
        case m_ComboResolution: 
        case m_ComboShadowResolution:        
        case m_ComboShadow:
		case m_GammaScroll:
		case m_BrightnessScroll:
		case m_ComboEffectsQuality:
            m_bModified = true;
            break;
        }
    }
}

defaultproperties
{
    m_ILabelXPos=15
    m_ILabelWidth=250
    m_ILabelHeight=18
    m_IControlXPos=285
    m_IComboWidth=150
    m_IFirstYPos=5
    m_IYOffset=25
    m_IButtonsWidth=20
    m_IScrollyOffset=25
    m_IScrollWidth=200
    m_TextColor=(R=71,G=71,B=71,A=255)
}