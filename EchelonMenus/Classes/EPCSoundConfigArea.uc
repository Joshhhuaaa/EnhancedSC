//=============================================================================
//  EPCSoundConfigArea.uc : Area containing controls for audio settings
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/24 * Created by Alexandre Dionne
//=============================================================================


class EPCSoundConfigArea extends UWindowDialogClientWindow;


var EPCHScrollBar           m_AmbiantSoundScroll, m_VoicesSoundScroll, m_LMusicSoundScroll, m_SFXSoundScroll;
var INT                     m_IFirstScrollyPos, m_IScrollyOffset, m_IScrollWidth;
var UWindowLabelControl     m_LAmbiantSound;
var UWindowLabelControl     m_LVoicesSound;
var UWindowLabelControl     m_LMusicSound;
var UWindowLabelControl     m_LSFXSound;
var INT                     m_ILabelXPos, m_ILabelWidth, m_ILabelHeight;

var UWindowLabelControl     m_LAudioVirt;
var EPCComboControl         m_AudioVirtCombo;
var INT                     m_IDropDownLabelYPos;


var EPCCheckBox             m_EaxButton,    m_3DAccButton;
var INT                     m_IButtonsYPos, m_IButtonsWidth;

//var UWindowLabelControl     m_LEax;       // Is now replaced by the EAX Logo
var UWindowLabelControl     m_L3DAcc;
var INT                     m_ILabel3DAccXPos, m_IButtonLabelWidth, m_IEaxYPos;

var Color                   m_TextColor;
var Color                   m_DisabledTextColor;

var bool                    m_bModified;    //A setting has changed
var bool					m_bFirstRefresh;

var UWindowBitmap           m_oEAXLogo;
var Texture                 m_oEAXTexture;
var Texture                 m_oEAXDisabledTexture;

var bool					m_SliderInitialized;


//==============================================================================
// Created - Called on window creation
//==============================================================================
function Created()
{	
    local Region EAXRegion;

    // ***********************************************************************************************
    // * Sroll Bars
    // ***********************************************************************************************
		
	// Set color values (YM)
	m_TextColor.R = 71;
	m_TextColor.G = 71;
	m_TextColor.B = 71;
	m_TextColor.A = 255;

    m_DisabledTextColor.R = 128;
	m_DisabledTextColor.G = 128;
	m_DisabledTextColor.B = 128;
	m_DisabledTextColor.A = 255;
	

    m_AmbiantSoundScroll   = EPCHScrollBar(CreateControl( class'EPCHScrollBar', m_ILabelXPos + m_ILabelWidth, m_IFirstScrollyPos, m_IScrollWidth, LookAndFeel.Size_HScrollbarHeight, self));
    m_AmbiantSoundScroll.SetScrollHeight(12);
    m_AmbiantSoundScroll.SetRange(0, 100, 1);

    m_VoicesSoundScroll   = EPCHScrollBar(CreateControl( class'EPCHScrollBar', m_ILabelXPos + m_ILabelWidth, m_AmbiantSoundScroll.WinTop + m_IScrollyOffset, m_IScrollWidth, LookAndFeel.Size_HScrollbarHeight, self));
    m_VoicesSoundScroll.SetScrollHeight(12);
    m_VoicesSoundScroll.SetRange(0, 100, 1);

    m_LMusicSoundScroll   = EPCHScrollBar(CreateControl( class'EPCHScrollBar', m_ILabelXPos + m_ILabelWidth, m_VoicesSoundScroll.WinTop + m_IScrollyOffset, m_IScrollWidth, LookAndFeel.Size_HScrollbarHeight, self));
    m_LMusicSoundScroll.SetScrollHeight(12);
    m_LMusicSoundScroll.SetRange(0, 100, 1);   

    m_SFXSoundScroll   = EPCHScrollBar(CreateControl( class'EPCHScrollBar', m_ILabelXPos + m_ILabelWidth, m_LMusicSoundScroll.WinTop + m_IScrollyOffset, m_IScrollWidth, LookAndFeel.Size_HScrollbarHeight, self));
    m_SFXSoundScroll.SetScrollHeight(12);
    m_SFXSoundScroll.SetRange(0, 100, 1);
    
    m_LAmbiantSound       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabelXPos, m_AmbiantSoundScroll.WinTop, m_ILabelWidth, m_ILabelHeight, self));
    m_LAmbiantSound.SetLabelText(Localize("HUD","AMBIENTVOLUME","Localization\\HUD"),TXT_LEFT);
    m_LAmbiantSound.Font      = F_Normal;
    m_LAmbiantSound.TextColor = m_TextColor;

    m_LVoicesSound       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabelXPos, m_VoicesSoundScroll.WinTop, m_ILabelWidth, m_ILabelHeight, self));
    m_LVoicesSound.SetLabelText(Localize("HUD","VOICEVOLUME","Localization\\HUD"),TXT_LEFT);
    m_LVoicesSound.Font       = F_Normal;
    m_LVoicesSound.TextColor  = m_TextColor;

    m_LMusicSound       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabelXPos, m_LMusicSoundScroll.WinTop, m_ILabelWidth, m_ILabelHeight, self));
    m_LMusicSound.SetLabelText(Localize("HUD","MUSICVOLUME","Localization\\HUD"),TXT_LEFT);
    m_LMusicSound.Font        = F_Normal;
    m_LMusicSound.TextColor   = m_TextColor;

    m_LSFXSound       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabelXPos, m_SFXSoundScroll.WinTop, m_ILabelWidth, m_ILabelHeight, self));
    m_LSFXSound.SetLabelText(Localize("HUD","SFXVOLUME","Localization\\HUD"),TXT_LEFT);
    m_LSFXSound.Font        = F_Normal;
    m_LSFXSound.TextColor   = m_TextColor;

    // ***********************************************************************************************
    // * Drop Down
    // ***********************************************************************************************

    m_LAudioVirt       = UWindowLabelControl(CreateControl( class'UWindowLabelControl', m_ILabelXPos, m_IDropDownLabelYPos - 3, m_ILabelWidth, m_ILabelHeight, self));
    m_LAudioVirt.SetLabelText(Localize("HUD","AUDIOVIRT","Localization\\HUD"),TXT_LEFT);
    m_LAudioVirt.Font        = F_Normal;
    m_LAudioVirt.TextColor   = m_TextColor;

    m_AudioVirtCombo   = EPCComboControl(CreateControl(class'EPCComboControl',m_ILabelXPos + m_ILabelWidth, m_IDropDownLabelYPos - 2, 150, m_ILabelHeight));	
	m_AudioVirtCombo.SetFont(F_Normal);
	m_AudioVirtCombo.SetEditable(False);
    m_AudioVirtCombo.AddItem(Localize("HUD","LOW","Localization\\HUD"));
	m_AudioVirtCombo.AddItem(Localize("HUD","MEDIUM","Localization\\HUD"));
    m_AudioVirtCombo.AddItem(Localize("HUD","HIGH","Localization\\HUD"));
	m_AudioVirtCombo.SetSelectedIndex(0);


    // ***********************************************************************************************
    // * Check Boxes
    // ***********************************************************************************************
    
    m_L3DAcc       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabelXPos, m_IButtonsYPos, m_IButtonLabelWidth, m_ILabelHeight, self));
    m_L3DAcc.SetLabelText(Caps(Localize("HUD","AUDIO3D","Localization\\HUD")),TXT_LEFT);
    m_L3DAcc.Font        = F_Normal;
    m_L3DAcc.TextColor   = m_TextColor;

    /*m_LEax       = UWindowLabelControl(CreateWindow( class'UWindowLabelControl', m_ILabel3DAccXPos, m_IButtonsYPos, m_IButtonLabelWidth, m_ILabelHeight, self));
    m_LEax.SetLabelText("",TXT_LEFT);
    m_LEax.Font       = F_Normal;
    m_LEax.TextColor  = m_TextColor;*/


    m_EaxButton      = EPCCheckBox(CreateControl( class'EPCCheckBox', m_ILabel3DAccXPos + m_IButtonLabelWidth - 64, m_IButtonsYPos, m_IButtonsWidth, m_ILabelHeight, self));
    m_3DAccButton    = EPCCheckBox(CreateControl( class'EPCCheckBox', m_L3DAcc.WinLeft + m_L3DAcc.WinWidth, m_IButtonsYPos, m_IButtonsWidth, m_ILabelHeight, self));    

    m_EaxButton.ImageX      = 5;
    m_EaxButton.ImageY      = 5;
    m_3DAccButton.ImageX    = 5;
    m_3DAccButton.ImageY    = 5;

    m_oEAXLogo = UWindowBitmap(CreateWindow(class'UWindowBitmap', m_ILabel3DAccXPos, m_IEaxYPos, 64, 32));
    EAXRegion.X = 0;
    EAXRegion.Y = 0;
    EAXRegion.W = 64;
    EAXRegion.H = 32;
    m_oEAXLogo.T = m_oEAXTexture;
    m_oEAXLogo.R = EAXRegion;
    m_oEAXLogo.bStretch = true;
    m_oEAXLogo.bCenter = true;
    m_oEAXLogo.ShowWindow();
}

//==============================================================================
// ResetToDefault
//==============================================================================
function ResetToDefault()
{
   local EPCGameOptions GO;   

   GO = class'Actor'.static.GetGameOptions();
   GO.ResetSoundToDefault();
   Refresh();
   Verify3DSound();
   GO.oldResolution = GO.Resolution;
   GO.oldEffectsQuality = GO.EffectsQuality;
   GO.oldShadowResolution = GO.ShadowResolution;
   GO.UpdateEngineSettings();    
}

//==============================================================================
// Refresh
//==============================================================================
function Refresh()
{
    local EPCGameOptions GO;   
	
    GO = class'Actor'.static.GetGameOptions();

    m_AmbiantSoundScroll.Pos = Clamp(GO.AmbiantVolume,0,99);
    m_VoicesSoundScroll.Pos  = Clamp(GO.VoicesVolume, 0,99);
    m_LMusicSoundScroll.Pos  = Clamp(GO.MusicVolume,0,99);
    m_SFXSoundScroll.Pos  = Clamp(GO.SFXVolume,0,99);

    m_AudioVirtCombo.SetSelectedIndex(Clamp(GO.AudioVirt,0,m_AudioVirtCombo.List.Items.Count() -1));    
    m_EaxButton.m_bSelected = GO.EAX;
    m_3DAccButton.m_bSelected = GO.Sound3DAcc;

    if(m_bFirstRefresh)
    {
        Verify3DSound();  
    }

	m_bModified = false;
	m_bFirstRefresh = false;
}

//==============================================================================
// SaveOptions
//==============================================================================
function SaveOptions()
{
    local EPCGameOptions GO;   
	
    GO = class'Actor'.static.GetGameOptions();

    GO.AmbiantVolume = m_AmbiantSoundScroll.Pos;
    GO.VoicesVolume = m_VoicesSoundScroll.Pos;
    GO.MusicVolume = m_LMusicSoundScroll.Pos;
    GO.SFXVolume = m_SFXSoundScroll.Pos;

    GO.AudioVirt = m_AudioVirtCombo.GetSelectedIndex();
    GO.EAX = m_EaxButton.m_bSelected;
    GO.Sound3DAcc = m_3DAccButton.m_bSelected;
}

//==============================================================================
// Notify - Message Passing
//==============================================================================
function Notify(UWindowDialogControl C, byte E)
{
	local EPCGameOptions GO;   
	
    GO = class'Actor'.static.GetGameOptions();

	if (m_AmbiantSoundScroll.Pos == Clamp(GO.AmbiantVolume,0,99) &&
		m_VoicesSoundScroll.Pos  == Clamp(GO.VoicesVolume, 0,99) &&
		m_LMusicSoundScroll.Pos  == Clamp(GO.MusicVolume,0,99)   &&
		m_SFXSoundScroll.Pos     == Clamp(GO.SFXVolume,0,99))
	{
		m_SliderInitialized = true;
	}

    if(E == DE_Click)
    {
        switch(C)
        {   
        case m_3DAccButton:
            Verify3DSound();
        case m_EaxButton:
            log("EAX");
            m_bModified = true;
            break;  
        }
    }
    if(E == DE_Change)
    {
        switch(C)
        {
        case m_AmbiantSoundScroll: 
        case m_VoicesSoundScroll:
        case m_LMusicSoundScroll:
        case m_SFXSoundScroll:
        case m_AudioVirtCombo:
            m_bModified = true;
			if (m_SliderInitialized)
			{
				GO.RTAmbiantVolume = m_AmbiantSoundScroll.Pos;
				GO.RTVoicesVolume = m_VoicesSoundScroll.Pos;
				GO.RTMusicVolume = m_LMusicSoundScroll.Pos;
				GO.RTSFXVolume = m_SFXSoundScroll.Pos;
				GO.UpdateEngineSettings(true);
			}
            break;
        }
    }
}

//==============================================================================
// Verify3DSound - Checks whether 3D sound is ON before giving the EAX option
//==============================================================================
function Verify3DSound()
{
    if(m_3DAccButton.m_bSelected && IsEAXCapable())   // 3D SOUND was just ENABLED
    {
        // Enable EAX
        m_EaxButton.bDisabled = false;

        // Put enabled texture
        m_oEAXLogo.T = m_oEAXTexture; 
    }
    else                            // 3D SOUND was just DISABLED
    {
        // De-check EAX
        m_EaxButton.m_bSelected = false;

        // Disable EAX
        m_EaxButton.bDisabled = true;

        // Put Disabled Texture on EAX Logo
        m_oEAXLogo.T = m_oEAXDisabledTexture;
    }
}

//==============================================================================
// IsEAXCapable - Checks whether sound card is EAX capable
//==============================================================================
function bool IsEAXCapable()
{
    local EPCGameOptions GO;   
	
    GO = class'Actor'.static.GetGameOptions();

    return GO.EAX_Capable;
}

defaultproperties
{
    m_IFirstScrollyPos=5
    m_IScrollyOffset=25
    m_IScrollWidth=200
    m_ILabelXPos=15
    m_ILabelWidth=250
    m_ILabelHeight=18
    m_IDropDownLabelYPos=105
    m_IButtonsYPos=135
    m_IButtonsWidth=20
    m_ILabel3DAccXPos=280
    m_IButtonLabelWidth=150
    m_IEaxYPos=123
    m_TextColor=(R=71,G=71,B=71,A=255)
    m_oEAXTexture=Texture'HUD.HUD.EAX'
    m_oEAXDisabledTexture=Texture'HUD.HUD.eax_dis'
}