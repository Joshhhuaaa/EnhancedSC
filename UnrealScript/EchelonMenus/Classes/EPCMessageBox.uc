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

//=============================================================================
// Enhanced Variables
// Joshua - This is a native class. New variables must be added only after all original ones have been declared.
// Do NOT add variables if this class is inherited by another native class, it will shift memory and cause issues!
//=============================================================================
// Joshua - Controller navigation variables
var INT                 m_totalButton;
var INT                 m_selectedButton;
var MessageBoxButtons   m_buttonType;

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

function Created()
{
    //Creating All controls
    m_TitleLabel        =  UWindowLabelControl(CreateWindow(class'UWindowLabelControl', 0, 0, 0, 0, self));


    m_YesButton         = EPCTextButton(CreateControl(class'EPCTextButton', 0, 0, 0, 0, self));
    m_NoButton          = EPCTextButton(CreateControl(class'EPCTextButton', 0, 0, 0, 0, self));
    m_OKButton          = EPCTextButton(CreateControl(class'EPCTextButton', 0, 0, 0, 0, self));
    m_CancelButton      = EPCTextButton(CreateControl(class'EPCTextButton', 0, 0, 0, 0, self));
    m_YesButton.Text    = Localize("MESSAGEBOX","YES","Localization\\HUD");
    m_NoButton.Text     = Localize("MESSAGEBOX","NO","Localization\\HUD");
    m_OKButton.Text     = Localize("MESSAGEBOX","OK","Localization\\HUD");
    m_CancelButton.Text = Localize("MESSAGEBOX","CANCEL","Localization\\HUD");

    m_MessageArea       = UWindowWrappedTextArea(CreateWindow(class'UWindowWrappedTextArea', 0, 0, 0, 0, self));
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

    if (_SetScrollable)
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

// Joshua - Clear button selection bars when in mouse mode, restore when in controller mode
function BeforePaint(Canvas C, float X, float Y)
{
    Super.BeforePaint(C, X, Y);

    // In mouse mode, don't show selection bars - vanilla behavior shows them only when holding left click
    if (!Root.bDisableMouseDisplay)
    {
        m_YesButton.m_bSelected = false;
        m_NoButton.m_bSelected = false;
        m_OKButton.m_bSelected = false;
        m_CancelButton.m_bSelected = false;
    }
    else
    {
        // Controller mode - restore selection on the currently selected button
        UpdateButtonSelection();
    }
}

// Joshua - Update button selection state based on m_selectedButton
function UpdateButtonSelection()
{
    // Clear all first
    m_YesButton.m_bSelected = false;
    m_NoButton.m_bSelected = false;
    m_OKButton.m_bSelected = false;
    m_CancelButton.m_bSelected = false;

    // Set the correct button based on type and index
    switch (m_buttonType)
    {
        case MB_YesNoCancel:
            if (m_selectedButton == 0) m_YesButton.m_bSelected = true;
            else if (m_selectedButton == 1) m_NoButton.m_bSelected = true;
            else if (m_selectedButton == 2) m_CancelButton.m_bSelected = true;
            break;
        case MB_YesNo:
            if (m_selectedButton == 0) m_YesButton.m_bSelected = true;
            else if (m_selectedButton == 1) m_NoButton.m_bSelected = true;
            break;
        case MB_OKCancel:
            if (m_selectedButton == 0) m_OKButton.m_bSelected = true;
            else if (m_selectedButton == 1) m_CancelButton.m_bSelected = true;
            break;
        case MB_OK:
            m_OKButton.m_bSelected = true;
            break;
        case MB_Cancel:
            m_CancelButton.m_bSelected = true;
            break;
    }
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

    Left = _Left;
    Mid = _Mid;
    Right = _Right;

}

function CancelMouseFocus(BOOL _CancelMouseFocus)
{
    if (_CancelMouseFocus)
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

    // Joshua - Store button type for navigation
    m_buttonType = InButtons;

	// Create buttons
	switch (InButtons)
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
        // Joshua - Default to Cancel selected
        m_YesButton.m_bSelected = false;
        m_NoButton.m_bSelected = false;
        m_CancelButton.m_bSelected = true;
        m_totalButton = 3;
        m_selectedButton = 2;
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
        // Joshua - Default to No selected
        m_YesButton.m_bSelected = false;
        m_NoButton.m_bSelected = true;
        m_totalButton = 2;
        m_selectedButton = 1;
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
        // Joshua - Default to Cancel selected
        m_OKButton.m_bSelected = false;
        m_CancelButton.m_bSelected = true;
        m_totalButton = 2;
        m_selectedButton = 1;
		break;
	case MB_OK:
        m_YesButton.HideWindow();
        m_NoButton.HideWindow();
        m_OKButton.ShowWindow();
        m_OKButton.WinLeft = Mid.X;
        m_OKButton.WinTop  = Mid.Y;
        m_OKButton.SetSize(Mid.W, Mid.H);
        m_CancelButton.HideWindow();
        // Joshua - Only OK available
        m_OKButton.m_bSelected = true;
        m_totalButton = 1;
        m_selectedButton = 0;
		break;
    case MB_Cancel:
        m_YesButton.HideWindow();
        m_NoButton.HideWindow();
        m_OKButton.HideWindow();
        m_CancelButton.ShowWindow();
        m_CancelButton.WinLeft = Mid.X;
        m_CancelButton.WinTop  = Mid.Y;
        m_CancelButton.SetSize(Mid.W, Mid.H);
        // Joshua - Only Cancel available
        m_CancelButton.m_bSelected = true;
        m_totalButton = 1;
        m_selectedButton = 0;
		break;
	}
}

// Joshua - Activate the currently selected button
function NotifySelectedOptions()
{
    switch (m_buttonType)
    {
    case MB_YesNoCancel:
        if (m_selectedButton == 0)
            Notify(m_YesButton, DE_Click);
        else if (m_selectedButton == 1)
            Notify(m_NoButton, DE_Click);
        else if (m_selectedButton == 2)
            Notify(m_CancelButton, DE_Click);
        break;
    case MB_YesNo:
        if (m_selectedButton == 0)
            Notify(m_YesButton, DE_Click);
        else if (m_selectedButton == 1)
            Notify(m_NoButton, DE_Click);
        break;
    case MB_OKCancel:
        if (m_selectedButton == 0)
            Notify(m_OKButton, DE_Click);
        else if (m_selectedButton == 1)
            Notify(m_CancelButton, DE_Click);
        break;
    case MB_OK:
        if (m_selectedButton == 0)
            Notify(m_OKButton, DE_Click);
        break;
    case MB_Cancel:
        if (m_selectedButton == 0)
            Notify(m_CancelButton, DE_Click);
        break;
    }
}

// Joshua - Highlight the selected button and unhighlight others
function HighlightSelectedItem(INT selectedItem_)
{
    switch (m_buttonType)
    {
    case MB_YesNoCancel:
        m_YesButton.m_bSelected = false;
        m_NoButton.m_bSelected = false;
        m_CancelButton.m_bSelected = false;
        if (selectedItem_ == 0)
            m_YesButton.m_bSelected = true;
        else if (selectedItem_ == 1)
            m_NoButton.m_bSelected = true;
        else if (selectedItem_ == 2)
            m_CancelButton.m_bSelected = true;
        break;
    case MB_YesNo:
        m_YesButton.m_bSelected = false;
        m_NoButton.m_bSelected = false;
        if (selectedItem_ == 0)
            m_YesButton.m_bSelected = true;
        else if (selectedItem_ == 1)
            m_NoButton.m_bSelected = true;
        break;
    case MB_OKCancel:
        m_OKButton.m_bSelected = false;
        m_CancelButton.m_bSelected = false;
        if (selectedItem_ == 0)
            m_OKButton.m_bSelected = true;
        else if (selectedItem_ == 1)
            m_CancelButton.m_bSelected = true;
        break;
    case MB_OK:
        m_OKButton.m_bSelected = true;
        break;
    case MB_Cancel:
        m_CancelButton.m_bSelected = true;
        break;
    }
}

// Joshua - Update selection when mouse hovers over a button
function UpdateSelectionFromMouse(UWindowDialogControl C)
{
    switch (m_buttonType)
    {
    case MB_YesNoCancel:
        if (C == m_YesButton)
            m_selectedButton = 0;
        else if (C == m_NoButton)
            m_selectedButton = 1;
        else if (C == m_CancelButton)
            m_selectedButton = 2;
        break;
    case MB_YesNo:
        if (C == m_YesButton)
            m_selectedButton = 0;
        else if (C == m_NoButton)
            m_selectedButton = 1;
        break;
    case MB_OKCancel:
        if (C == m_OKButton)
            m_selectedButton = 0;
        else if (C == m_CancelButton)
            m_selectedButton = 1;
        break;
    case MB_OK:
        m_selectedButton = 0;
        break;
    case MB_Cancel:
        m_selectedButton = 0;
        break;
    }
    HighlightSelectedItem(m_selectedButton);
}

function Notify(UWindowDialogControl C, byte E)
{
	local EPCPopUpController P;

	P = EPCPopUpController(OwnerWindow);

    // Joshua - Update selection when mouse enters a button (hover)
    if (E == DE_MouseEnter || E == DE_Enter)
    {
        UpdateSelectionFromMouse(C);
    }

	if (E == DE_Click)
	{
		switch (C)
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

    // Joshua - Handle controller input
    // A=200, B=201, X=202, Y=203
    // DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
    // AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199

    // Track repeatable keys (directional keys only)
    if (Key == 212 || Key == 196 || Key == 213 || Key == 197)
    {
        // New key press - reset repeat timing
        if (Key != m_heldKey)
        {
            m_heldKey = Key;
            m_keyHoldTime = 0;
            m_nextRepeatTime = m_initialDelay;
        }
    }

    // Process the key action
    HandleKeyAction(Key);
}

// Joshua - Process a key action (called on initial press and during auto-repeat)
function HandleKeyAction(int Key)
{
	local EPCPopUpController P;

	P = EPCPopUpController(OwnerWindow);

    // Joshua - Handle scrolling in message area if scrollbar is visible
    // DPadUp (212) or AnalogUp (196)
    if (Key == 212 || Key == 196)
    {
        if (m_MessageArea != None && m_MessageArea.VertSB != None && m_MessageArea.VertSB.bWindowVisible)
        {
            // Only scroll and play sound if we can actually scroll up
            if (m_MessageArea.VertSB.Pos > 0)
            {
                m_MessageArea.VertSB.Scroll(-1);
                Root.PlayClickSound();
            }
            return;
        }
    }
    // DPadDown (213) or AnalogDown (197)
    else if (Key == 213 || Key == 197)
    {
        if (m_MessageArea != None && m_MessageArea.VertSB != None && m_MessageArea.VertSB.bWindowVisible)
        {
            // Only scroll and play sound if we can actually scroll down
            if (m_MessageArea.VertSB.Pos < m_MessageArea.VertSB.MaxPos)
            {
                m_MessageArea.VertSB.Scroll(1);
                Root.PlayClickSound();
            }
            return;
        }
    }

    // Navigate left - DPadLeft (214) or AnalogLeft (198)
    if (Key == 214 || Key == 198)
    {
        // Joshua - Only navigate if there's more than one button
        if (m_totalButton > 1)
        {
            Root.PlayClickSound();
            m_selectedButton = (m_selectedButton - 1 + m_totalButton) % m_totalButton;
            HighlightSelectedItem(m_selectedButton);
        }
    }
    // Navigate right - DPadRight (215) or AnalogRight (199)
    else if (Key == 215 || Key == 199)
    {
        // Joshua - Only navigate if there's more than one button
        if (m_totalButton > 1)
        {
            Root.PlayClickSound();
            m_selectedButton = (m_selectedButton + 1) % m_totalButton;
            HighlightSelectedItem(m_selectedButton);
        }
    }
    // Confirm selection - A button (200)
    else if (Key == 200)
    {
        Root.PlayClickSound();
        NotifySelectedOptions();
    }
    // Cancel/Back - close with negative result - B button (201)
    else if (Key == 201)
    {
        Root.PlayClickSound();
        switch (m_buttonType)
        {
        case MB_YesNoCancel:
            P.Result = MR_Cancel;
            break;
        case MB_YesNo:
            P.Result = MR_No;
            break;
        case MB_OKCancel:
            P.Result = MR_Cancel;
            break;
        case MB_OK:
            P.Result = MR_OK;
            break;
        case MB_Cancel:
            P.Result = MR_Cancel;
            break;
        }
        P.Close();
    }
    // Keep original Enter key support
    else if (Key == GetPlayerOwner().Player.Console.EInputKey.IK_Enter && EnterResult != MR_None)
	{
		P.Result = EnterResult;
		P.Close();
	}
    // Keep original Escape key support
    else if (Key == GetPlayerOwner().Player.Console.EInputKey.IK_Escape && P.Result != MR_None)
    {
        P.Close();
    }
}

// Joshua - WindowEvent to track key releases for auto-repeat
function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key)
{
    Super.WindowEvent(Msg, C, X, Y, Key);

    // Track key releases for auto-repeat
    if (Msg == WM_KeyUp)
    {
        if (Key == m_heldKey)
        {
            m_heldKey = 0;
            m_keyHoldTime = 0;
            m_nextRepeatTime = 0;
        }
    }
}

// Joshua - Tick function to handle auto-repeat for held keys
function Tick(float Delta)
{
    Super.Tick(Delta);

    if (m_heldKey == 0)
        return;

    m_keyHoldTime += Delta;

    // Check if it's time to repeat
    if (m_keyHoldTime >= m_nextRepeatTime)
    {
        // Execute the held key's action
        HandleKeyAction(m_heldKey);

        // Schedule next repeat
        m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
    }
}

function Paint(Canvas C, FLOAT X, FLOAT Y)
{
    Render(C,X,Y);
}

defaultproperties
{
    m_BorderColor=(R=51,G=51,B=51,A=255)
    m_initialDelay=0.5
    m_repeatRate=0.1
}