//=============================================================================
//  EPCInGameMissionInfoArea.uc : Area containing goals, data and notes
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/05 * Created by Alexandre Dionne
//=============================================================================


class EPCInGameMissionInfoArea extends UWindowDialogClientWindow;

var EPCTextButton   m_GoalsButton, m_NotesButton, m_DataButton;
var INT             m_IFirstButtonsXPos, m_IXButtonOffset, m_IButtonsHeight, m_IButtonsWidth, m_IButtonsYPos;


var EPCInGameGoalsArea m_GoalsArea;
var EPCInGameDataArea  m_DataArea;

var INT                   m_IAreaXPos, m_IAreaYPos,m_IAreaWidth,m_IAreaHeight;

function Created()
{
    
    m_GoalsButton = EPCTextButton(CreateControl(class'EPCTextButton', m_IFirstButtonsXPos, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_NotesButton = EPCTextButton(CreateControl(class'EPCTextButton', m_GoalsButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));
    m_DataButton  = EPCTextButton(CreateControl(class'EPCTextButton', m_NotesButton.WinLeft + m_IXButtonOffset, m_IButtonsYPos, m_IButtonsWidth, m_IButtonsHeight, self));

    m_GoalsButton.SetButtonText(Caps(Localize("HUD","GOALS","Localization\\HUD"))    ,TXT_CENTER);    
    m_NotesButton.SetButtonText(Caps(Localize("HUD","NOTES","Localization\\HUD"))    ,TXT_CENTER);
    m_DataButton.SetButtonText(Caps(Localize("HUD","RECONS","Localization\\HUD"))    ,TXT_CENTER);

    m_GoalsButton.Font      = EPCMainMenuRootWindow(Root).TitleFont;    
    m_NotesButton.Font      = EPCMainMenuRootWindow(Root).TitleFont;    
    m_DataButton.Font       = EPCMainMenuRootWindow(Root).TitleFont;     

    m_GoalsArea   = EPCInGameGoalsArea(CreateWindow(class'EPCInGameGoalsArea', m_IAreaXPos, m_IAreaYPos, m_IAreaWidth, m_IAreaHeight,self));
    m_DataArea    = EPCInGameDataArea(CreateWindow(class'EPCInGameDataArea', m_GoalsArea.WinLeft, m_GoalsArea.WinTop, m_GoalsArea.WinWidth, m_GoalsArea.WinHeight, self));

    ChangeMenuSection(m_GoalsButton);
}

function Paint(Canvas C, float X, float Y)
{
	local EPlayerController EPC;

	EPC = EPlayerController(GetPlayerOwner());

	if (EPC != None)
	{
		if (m_GoalsArea.WindowIsVisible() && m_GoalsArea.m_bGoals)
			EPC.bNewGoal = false;
		if (m_GoalsArea.WindowIsVisible() && !m_GoalsArea.m_bGoals)
			EPC.bNewNote = false;
		if (m_DataArea.WindowIsVisible())
			EPC.bNewRecon = false;
	}

	Super.Paint(C, X, Y);
}

function Notify(UWindowDialogControl C, byte E)
{

	if (E == DE_Click)
	{
        switch (C)
        {
        case m_GoalsButton:
        case m_NotesButton:
        case m_DataButton:                     
            ChangeMenuSection(UWindowButton(C));
            break;

        }
    }
}


function ChangeMenuSection(UWindowButton _SelectMe)
{
    m_GoalsButton.m_bSelected   =  false;
    m_NotesButton.m_bSelected   =  false;
    m_DataButton.m_bSelected    =  false;
    
    m_GoalsArea.HideWindow();    
    m_DataArea.HideWindow();

    switch (_SelectMe)
    {
    case m_GoalsButton:
        m_GoalsButton.m_bSelected    =  true;
        m_GoalsArea.ShowWindow();
        m_GoalsArea.ShowGoals(true);        
        break;    
    case m_NotesButton:
        m_NotesButton.m_bSelected     =  true;
        m_GoalsArea.ShowWindow();
        m_GoalsArea.ShowGoals(false);        
        
        break;
    case m_DataButton:
        m_DataButton.m_bSelected     =  true;
        m_DataArea.ShowWindow();
        break;
    }
}

function SelectArea(bool bNewGoal, bool bNewNote, bool bNewRecon)
{
	if (bNewGoal)
		ChangeMenuSection(m_GoalsButton);
	else if (bNewNote)
		ChangeMenuSection(m_NotesButton);
	else if (bNewRecon)
		ChangeMenuSection(m_DataButton);
}

function Reset()
{
    m_GoalsArea.Init();
    m_DataArea.FillListBox();

	// Reselect last selected
	if (m_DataButton.m_bSelected)
		ChangeMenuSection(m_DataButton);
	else if (m_NotesButton.m_bSelected)
		ChangeMenuSection(m_NotesButton);
	else
		ChangeMenuSection(m_GoalsButton);
}

defaultproperties
{
    m_IFirstButtonsXPos=6
    m_IXButtonOffset=148
    m_IButtonsHeight=18
    m_IButtonsWidth=144
    m_IButtonsYPos=5
    m_IAreaXPos=7
    m_IAreaYPos=37
    m_IAreaWidth=434
    m_IAreaHeight=206
}