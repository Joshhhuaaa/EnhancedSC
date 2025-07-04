//=============================================================================
//  EPCInGameGoalsArea.uc : Area displaying the goals and notes
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/06 * Created by Alexandre Dionne
//=============================================================================


class EPCInGameGoalsArea extends UWindowDialogClientWindow
                    native;

var   EPCVScrollBar     m_ScrollBar;
var   BOOL              m_bGoals;

var   INT               m_IGoalCurScroll, m_IGoalNbScroll, m_INoteCurScroll, m_INoteNbScroll;

var   BOOL              m_bCompute; 

function Created()
{
    m_ScrollBar =  EPCVScrollBar(CreateWindow(class'EPCVScrollBar', WinWidth-LookAndFeel.Size_ScrollbarWidth, 0, LookAndFeel.Size_ScrollbarWidth, WinHeight));
}

function ShowGoals(Bool _ShoGoals)
{
    m_bGoals = _ShoGoals;

    if(_ShoGoals)    
    {
        m_INoteCurScroll = m_ScrollBar.Pos;       
        m_ScrollBar.SetRange(0, m_IGoalNbScroll,1);
        m_ScrollBar.Pos = m_IGoalCurScroll;
    }        
    else
    {
        m_IGoalCurScroll = m_ScrollBar.Pos;
        m_ScrollBar.SetRange(0, m_INoteNbScroll,1);
        m_ScrollBar.Pos = m_INoteCurScroll;
    }            
    
}


function MouseWheelDown(FLOAT X, FLOAT Y)
{
    if(m_ScrollBar != None)
	    m_ScrollBar.MouseWheelDown(X,Y);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
    if(m_ScrollBar != None)
        m_ScrollBar.MouseWheelUp(X,Y);
	    
}

function Init()
{
    m_bCompute = true;
    m_IGoalCurScroll = 0;
    m_INoteCurScroll = 0;
}

function Paint(Canvas C, FLOAT X, FLOAT Y)
{
    Render(C, X, Y);
    
    if(m_bCompute)
    {
        ShowGoals(m_bGoals);
        m_bCompute = false;
    }
 
}
