//=============================================================================
//  EPCVideoMenus.uc : Video Menu Page
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/03 * Created by Cyrille Lauzon
//=============================================================================

class EPCVideoMenu extends EPCMenuPage
	  native;

var Canvas	PlayCanvas;
var bool	m_bFirstTime;
var string  m_VideoName;

function Created()
{
	SetAcceptsFocus();
	m_bFirstTime = true;
}

function Paint(Canvas C, float MouseX, float MouseY)
{
	if (m_bFirstTime)
	{
		PlayCanvas = C;
		PlayCanvas.RequestVideoPlay(m_VideoName);
		Root.bDisableMouseDisplay = true;
		EPCMainMenuRootWindow(Root).bSkipLaptopOverlay = true;
		m_bFirstTime = false;
	}
	else if (C.m_bPlaying)
	{
		C.DisplayFullScreenVideo();
	}
	else
	{
		EndVideo();
	}
	
}

function KeyDown(int Key, float X, float Y)
{
	EndVideo();
}

function LMouseDown(float X, float Y)
{
	EndVideo();
}

function RMouseDown(float X, float Y)
{
	EndVideo();
}

function EndVideo()
{
	m_bFirstTime = true;
	PlayCanvas.RequestVideoStop();
	Root.bDisableMouseDisplay = false;
	GetPlayerOwner().Player.Actor.PlaySound(EPCConsole(Root.Console).MenuMusic, SLOT_Music);
	Root.ChangeCurrentWidget(WidgetID_Previous);
}

