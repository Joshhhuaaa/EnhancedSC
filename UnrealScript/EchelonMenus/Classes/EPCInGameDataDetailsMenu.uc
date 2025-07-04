//=============================================================================
//  EPCInGameDataDetailsMenu.uc : Full screen description of a recon
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/07 * Created by Alexandre Dionne
//=============================================================================


class EPCInGameDataDetailsMenu extends EPCMenuPage
			native;

var EPCTextButton   m_Return;
var INT             m_IReturnButtonsXPos, m_IReturnButtonsHeight, m_IReturnButtonsWidth, m_IReturnButtonsYPos; 

var ERecon	        m_Recon;

var   EPCVScrollBar     m_ScrollBar;
var   BOOL              m_BInitScrollBar;

var INT             m_INbScroll, m_INbLinesDisplayed;
  
function Created()
{
 
	SetAcceptsFocus();
    m_Return  = EPCTextButton(CreateControl( class'EPCTextButton', m_IReturnButtonsXPos, m_IReturnButtonsYPos, m_IReturnButtonsWidth, m_IReturnButtonsHeight, self));
    m_Return.SetButtonText(Caps(Localize("HUD","BACK","Localization\\HUD")) ,TXT_CENTER);
    m_Return.Font = F_Normal;

    m_ScrollBar =  EPCVScrollBar(CreateWindow(class'EPCVScrollBar', 561, 95, LookAndFeel.Size_ScrollbarWidth, 244));	
 
}

function SetDataInfo(ERecon Recon)
{
    m_Recon = Recon;

    if(m_Recon.ReconType == 4 || m_Recon.ReconType == 5 ) //Text Full screen    
	{
        m_BInitScrollBar = true;		
		m_ScrollBar.pos = 0;
	}
    else
        m_ScrollBar.HideWindow();
    
}

function HideWindow()
{
    Super.HideWindow();
    m_Recon = None;
}

function EscapeMenu()
{
	Root.PlayClickSound();

	Notify(m_Return, DE_Click);
}

function Paint(Canvas C, float MouseX, float MouseY)
{
    Render( C , MouseX, MouseY);

    if(m_BInitScrollBar)
    {
        if(m_INbScroll > m_INbLinesDisplayed )
        {
            m_ScrollBar.ShowWindow();
            m_ScrollBar.SetRange(0, m_INbScroll,m_INbLinesDisplayed);
        }
        else    
            m_ScrollBar.HideWindow();

        m_BInitScrollBar= false;
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

function Notify(UWindowDialogControl C, byte E)
{

	if(E == DE_Click)
	{
        switch(C)
        {
        case m_Return:            
            Root.ChangeCurrentWidget(WidgetID_Previous);    //So reset function is not called on the ingame menu
            break;   
        }
    }
}

defaultproperties
{
    m_IReturnButtonsXPos=80
    m_IReturnButtonsHeight=18
    m_IReturnButtonsWidth=150
    m_IReturnButtonsYPos=353
}