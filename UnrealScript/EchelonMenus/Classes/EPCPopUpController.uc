//=============================================================================
//  EPCPopUpController.uc : Class Managing the Message Box
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/29 * Created by Alexandre Dionne
//=============================================================================


class EPCPopUpController extends UWindowWindow;

//Window we will send the result too
var UWindowWindow NotifyWindow;

//Returned Result
var MessageBoxResult Result;

//MessageBox it self
var EPCMessageBox MessageBox;

//GENERAL:Message Box Size and Pos
var INT m_IMessageBoxXpos, m_IMessageBoxYpos, m_IMessageBoxWidth, m_IMessageBoxHeight;

var BOOL    m_CancelMouseFocus; //This allows mouse input to be redirected to the window that created the message box
                                //usefull for the key mapping message box


// *******************************************************************************
// *                  Message Box Controls Size and Positions
// *******************************************************************************

//Button Size and Position
var Region m_RButtonLeft, m_RButtonMid, m_RButtonRight;

//Label Size and Position
var INT m_ILabelXpos, m_ILabelYpos, m_ILabelWidth, m_ILabelHeight;

//MessageArea Size and Position
var INT m_IMessageAreaXpos, m_IMessageAreaYpos, m_IMessageAreaWidth, m_IMessageAreaHeight;
var INT m_IMessageAreaXTextOffset, m_IMessageAreaYTextOffset;

//Controls Text Color And Fonts
var Color m_TitleTextColor, m_ButtonTextColor, m_MessageTextColor;
var INT   m_ITitleTextFont, m_IButtonTextFont, m_IMessageTextFont;


// *******************************************************************************
// *
// *******************************************************************************

function Created()
{
    //Create Message Box
	MessageBox = EPCMessageBox(CreateWindow(class'EPCMessageBox', m_IMessageBoxXpos, m_IMessageBoxYpos, m_IMessageBoxWidth, m_IMessageBoxHeight, Self));	
    //MessageBox.bAlwaysOnTop = true;    

    //Setup Size and positions
    MessageBox.SetupLabel(m_ILabelXpos, m_ILabelYpos, m_ILabelWidth, m_ILabelHeight, m_ITitleTextFont, TXT_CENTER, m_TitleTextColor);
    MessageBox.SetupMessageArea(m_IMessageAreaXpos, m_IMessageAreaYpos, m_IMessageAreaWidth, m_IMessageAreaHeight,m_IMessageAreaXTextOffset, m_IMessageAreaYTextOffset, m_IMessageTextFont, true, true,m_MessageTextColor);
    MessageBox.SetupButtons(m_RButtonLeft, m_RButtonMid, m_RButtonRight, m_IButtonTextFont, TXT_CENTER, m_ButtonTextColor);    
    
}

function AfterCreate()
{
    HideWindow();
}

function LMouseDown(float X, float Y)
{
    if (m_CancelMouseFocus)
        NotifyWindow.LMouseDown(X, Y);
}

function MMouseDown(float X, float Y) 
{
    if (m_CancelMouseFocus)
        NotifyWindow.MMouseDown(X, Y);
}

function RMouseDown(float X, float Y) 
{
	if (m_CancelMouseFocus)
        NotifyWindow.RMouseDown(X, Y);
}

function MouseWheelDown(FLOAT X, FLOAT Y)
{
	if (m_CancelMouseFocus)
        NotifyWindow.MouseWheelDown(X, Y);
}

function MouseWheelUp(FLOAT X, FLOAT Y)
{
	if (m_CancelMouseFocus)
        NotifyWindow.MouseWheelUp(X, Y);
}


function EPCMessageBox CreateMessageBox(UWindowWindow _NotifyWindow, string Title, string Message, MessageBoxButtons Buttons, MessageBoxResult ESCResult, optional MessageBoxResult EnterResult, optional BOOL cancelMouseFocus)
{
	NotifyWindow = _NotifyWindow;
    MessageBox.Setup(Title, Message, Buttons, EnterResult);        
    
    Result = ESCResult;

    if (EnterResult == MR_None)
        CancelAcceptsFocus();
    else
        MessageBox.SetAcceptsFocus();

    MessageBox.CancelMouseFocus(cancelMouseFocus);
    m_CancelMouseFocus = cancelMouseFocus;

	Root.PlayClickSound();
    ShowWindow();

	return MessageBox;
}

function Close(optional bool bByParent)
{
	local UWindowWindow tmpNotifyWindow;
	Super.Close(bByParent);
	if (NotifyWindow != None)
	{
		tmpNotifyWindow = NotifyWindow;
		NotifyWindow = None;
		tmpNotifyWindow.MessageBoxDone(MessageBox, Result);
	}
}

defaultproperties
{
    m_IMessageBoxXpos=132
    m_IMessageBoxYpos=160
    m_IMessageBoxWidth=375
    m_IMessageBoxHeight=160
    m_RButtonLeft=(X=92,Y=128,W=100,H=20)
    m_RButtonMid=(X=112,Y=128,W=150,H=20)
    m_RButtonRight=(X=207,Y=128,W=100,H=20)
    m_ILabelWidth=375
    m_ILabelHeight=25
    m_IMessageAreaXpos=20 // Joshua - Reduced from 40, increasing message area to fit more text
    m_IMessageAreaYpos=25
    m_IMessageAreaWidth=335 // Joshua - Increased from 295, increasing message area to fit more text
    m_IMessageAreaHeight=100
    m_IMessageAreaXTextOffset=5 // Joshua - Reduced from 10, increasing message area to fit more text
    m_IMessageAreaYTextOffset=10
    m_TitleTextColor=(R=51,G=51,B=51,A=255)
    m_ButtonTextColor=(R=71,G=71,B=71,A=255)
    m_MessageTextColor=(R=51,G=51,B=51,A=255)
}