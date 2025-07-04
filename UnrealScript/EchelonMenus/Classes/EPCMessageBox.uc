//=============================================================================
//  EPCMessageBox.uc : Message Box it's Self
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/29 * Created by Alexandre Dionne
//=============================================================================


class EPCMessageBox extends EPCMenuPage
                    native;

var UWindowLabelControl         m_TitleLabel;
var EPCTextButton               m_YesButton, m_NoButton, m_OKButton, m_CancelButton;
var UWindowWrappedTextArea      m_MessageArea;

var Region Left, Mid, Right;    //Buttons Size and Pos

var MessageBoxResult EnterResult;

var Font    m_TextAreaFont;
var Color  m_TextAreaColor;

function Created()
{
    //Creating All controls   
    m_TitleLabel        =  UWindowLabelControl(CreateWindow( class'UWindowLabelControl', 0, 0, 0, 0, self)); 


    m_YesButton         = EPCTextButton(CreateControl( class'EPCTextButton', 0, 0, 0, 0, self));    
    m_NoButton          = EPCTextButton(CreateControl( class'EPCTextButton', 0, 0, 0, 0, self));
    m_OKButton          = EPCTextButton(CreateControl( class'EPCTextButton', 0, 0, 0, 0, self));
    m_CancelButton      = EPCTextButton(CreateControl( class'EPCTextButton', 0, 0, 0, 0, self));
    m_YesButton.Text    = Localize("MESSAGEBOX","YES","Localization\\HUD");
    m_NoButton.Text     = Localize("MESSAGEBOX","NO","Localization\\HUD");
    m_OKButton.Text     = Localize("MESSAGEBOX","OK","Localization\\HUD");
    m_CancelButton.Text = Localize("MESSAGEBOX","CANCEL","Localization\\HUD");

    m_MessageArea       = UWindowWrappedTextArea(CreateWindow( class'UWindowWrappedTextArea', 0, 0, 0, 0, self));     
}


function SetupLabel(INT X, INT Y, INT W, INT H, INT _FONT, ECanvas.ETextAligned _Align, Color _TextColor)
{
    m_TitleLabel.Wintop =   Y;
    m_TitleLabel.WinLeft =  X;
    m_TitleLabel.SetSize(W,H);
    m_TitleLabel.SetFont(_FONT);
    m_TitleLabel.Align = _Align; 
}

function SetupMessageArea(INT X, INT Y, INT W, INT H, INT TextXOffset, INT TextYOffset , INT _FONT, BOOL _SetScrollable, BOOL _HideScrollWhenDisable , Color _TextColor)
{
    m_MessageArea.Wintop =   Y;
    m_MessageArea.WinLeft =  X;
    m_MessageArea.SetSize(W,H);
    m_TextAreaFont = Root.Fonts[_FONT];
    m_MessageArea.SBVClass = class'EPCVScrollBar';
    m_MessageArea.SetScrollable(_SetScrollable);
 
    if(_SetScrollable)
        m_MessageArea.VertSB.SetHideWhenDisable(_HideScrollWhenDisable);
    
    m_MessageArea.m_fXOffset = TextXOffset;
    m_MessageArea.m_fYOffset = TextYOffset;
    
    m_TextAreaColor = _TextColor;
    //m_MessageArea.bDrawBorder= true;
    m_MessageArea.m_BorderColor= m_BorderColor;    
}

function SetupText(string InMessage)
{
    m_MessageArea.Clear(true, true);
    m_MessageArea.AddText(InMessage, m_TextAreaColor, m_TextAreaFont);
}

function SetupForSave()
{
	m_OKButton.HideWindow();
	WinLeft = EPCMainMenuRootWindow(Root).m_MessageBoxCW.m_IMessageBoxXpos + 75;
	WinTop = EPCMainMenuRootWindow(Root).m_MessageBoxCW.m_IMessageBoxYpos + 30;
	SetSize(280, 55);
	m_MessageArea.WinLeft = 10;
	m_MessageArea.WinTop = 10;
	m_MessageArea.SetSize(WinWidth - 20, WinHeight - 20);
}

function RestoreFromSave()
{
	m_OKButton.ShowWindow();
	WinLeft = EPCMainMenuRootWindow(Root).m_MessageBoxCW.m_IMessageBoxXpos;
	WinTop = EPCMainMenuRootWindow(Root).m_MessageBoxCW.m_IMessageBoxYpos;
	SetSize(EPCMainMenuRootWindow(Root).m_MessageBoxCW.m_IMessageBoxWidth, EPCMainMenuRootWindow(Root).m_MessageBoxCW.m_IMessageBoxHeight);
	m_MessageArea.WinLeft = EPCMainMenuRootWindow(Root).m_MessageBoxCW.m_IMessageAreaXpos;
	m_MessageArea.WinTop = EPCMainMenuRootWindow(Root).m_MessageBoxCW.m_IMessageAreaYpos;
	m_MessageArea.SetSize(EPCMainMenuRootWindow(Root).m_MessageBoxCW.m_IMessageAreaWidth, EPCMainMenuRootWindow(Root).m_MessageBoxCW.m_IMessageAreaHeight);
}

function SetupButtons(Region _Left, Region _Mid, Region _Right, INT _FONT, ECanvas.ETextAligned _Align, Color _TextColor)
{    
    m_YesButton.SetFont(_FONT);
    m_YesButton.Align = _Align;
    m_YesButton.TextColor = _TextColor;    

    m_NoButton.SetFont(_FONT);
    m_NoButton.Align = _Align;
    m_NoButton.TextColor = _TextColor;

    m_OKButton.SetFont(_FONT);
    m_OKButton.Align = _Align;
    m_OKButton.TextColor = _TextColor;

    m_CancelButton.SetFont(_FONT);
    m_CancelButton.Align = _Align;
    m_CancelButton.TextColor = _TextColor;

    Left=_Left;
    Mid=_Mid;
    Right=_Right;

}

function CancelMouseFocus(BOOL _CancelMouseFocus)
{
    if(_CancelMouseFocus)
    {
        m_TitleLabel.bAcceptsMouseFocus = false;
        m_MessageArea.bAcceptsMouseFocus = false;
    }
    else
    {
        m_TitleLabel.bAcceptsMouseFocus = true;
        m_MessageArea.bAcceptsMouseFocus = true;
    }
        
}


function Setup(string InTitle, string InMessage, MessageBoxButtons InButtons, MessageBoxResult InEnterResult)
{

    m_TitleLabel.Text = InTitle;
    m_MessageArea.Clear(true, true);
    m_MessageArea.AddText(InMessage, m_TextAreaColor, m_TextAreaFont);

	EnterResult = InEnterResult;


	// Create buttons
	switch(InButtons)
	{
	case MB_YesNoCancel:
        m_OKButton.HideWindow();        
        m_YesButton.ShowWindow();
        m_YesButton.WinLeft = Left.X;
        m_YesButton.WinTop  = Left.Y;
        m_YesButton.SetSize(Left.W, Left.H);
        m_NoButton.ShowWindow();
        m_NoButton.WinLeft = Mid.X;
        m_NoButton.WinTop  = Mid.Y;
        m_NoButton.SetSize(Mid.W, Mid.H);
        m_CancelButton.ShowWindow();
        m_CancelButton.WinLeft = Right.X;
        m_CancelButton.WinTop  = Right.Y;
        m_CancelButton.SetSize(Right.W, Right.H);
		break;
	case MB_YesNo:		
        m_YesButton.ShowWindow();
        m_YesButton.WinLeft = Left.X;
        m_YesButton.WinTop  = Left.Y;
        m_YesButton.SetSize(Left.W, Left.H);
        m_NoButton.ShowWindow();
        m_NoButton.WinLeft = Right.X;
        m_NoButton.WinTop  = Right.Y;
        m_NoButton.SetSize(Right.W, Right.H);
        m_OKButton.HideWindow();
        m_CancelButton.HideWindow();
		break;
	case MB_OKCancel:		
        m_YesButton.HideWindow();
        m_NoButton.HideWindow();        
        m_OKButton.ShowWindow();
        m_OKButton.WinLeft = Left.X;
        m_OKButton.WinTop  = Left.Y;
        m_OKButton.SetSize(Left.W, Left.H);
        m_CancelButton.ShowWindow();
        m_CancelButton.WinLeft = Right.X;
        m_CancelButton.WinTop  = Right.Y;
        m_CancelButton.SetSize(Right.W, Right.H);
		break;
	case MB_OK:		
        m_YesButton.HideWindow();
        m_NoButton.HideWindow();
        m_OKButton.ShowWindow();
        m_OKButton.WinLeft = Mid.X;
        m_OKButton.WinTop  = Mid.Y;
        m_OKButton.SetSize(Mid.W, Mid.H);
        m_CancelButton.HideWindow();
		break;
    case MB_Cancel:		
        m_YesButton.HideWindow();
        m_NoButton.HideWindow();
        m_OKButton.HideWindow();        
        m_CancelButton.ShowWindow();
        m_CancelButton.WinLeft = Mid.X;
        m_CancelButton.WinTop  = Mid.Y;
        m_CancelButton.SetSize(Mid.W, Mid.H);
		break;
	}
}




function Notify(UWindowDialogControl C, byte E)
{
	local EPCPopUpController P;

	P = EPCPopUpController(OwnerWindow);

	if(E == DE_Click)
	{
		switch(C)
		{
		case m_YesButton:
			P.Result = MR_Yes;
			P.Close();			
			break;
		case m_NoButton:
			P.Result = MR_No;
			P.Close();
			break;
		case m_OKButton:
			P.Result = MR_OK;
			P.Close();
			break;
		case m_CancelButton:
			P.Result = MR_Cancel;
			P.Close();
			break;
		}
	}
}

function LMouseDown(float X, float Y)
{
	OwnerWindow.LMouseDown(X,Y);
}

function MMouseDown(float X, float Y) 
{
    OwnerWindow.MMouseDown(X,Y);
}

function RMouseDown(float X, float Y) 
{
	OwnerWindow.RMouseDown(X,Y);
}

function MouseWheelDown(FLOAT X, FLOAT Y)
{
	OwnerWindow.MouseWheelDown(X,Y);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
	OwnerWindow.MouseWheelUp(X,Y);
}


function KeyDown(int Key, float X, float Y)
{
	local EPCPopUpController P;

	P = EPCPopUpController(OwnerWindow);
    
	if(Key == GetPlayerOwner().Player.Console.EInputKey.IK_Enter && EnterResult != MR_None)
	{        
		P = EPCPopUpController(OwnerWindow);
		P.Result = EnterResult;
		P.Close();
	}
    else if(Key == GetPlayerOwner().Player.Console.EInputKey.IK_Escape && P.Result != MR_None)
    {
        P.Close();
    }
}

function Paint(Canvas C, FLOAT X, FLOAT Y)
{    
    Render(C,X,Y);
}

defaultproperties
{
    m_BorderColor=(R=51,G=51,B=51,A=255)
}