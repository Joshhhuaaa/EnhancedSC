// UWindowEditBox - simple edit box, for use in other controls such as 
// UWindowComboxBoxControl, UWindowEditBoxControl etc.

class UWindowEditBox extends UWindowDialogControl;

var string		Value;
var string		Value2;
var string                  OldValue;
var int			CaretOffset;
var int			MaxLength;
var float		LastDrawTime;
var bool		bShowCaret;
var float		Offset;
var UWindowDialogControl	NotifyOwner;
var bool		bNumericOnly;
var bool		bNumericFloat;
var bool		bCanEdit;
var bool		bAllSelected;
var bool		bDelayedNotify;
var bool		bChangePending;
var bool		bControlDown;
var bool		bShiftDown;
var bool		bHistory;
var bool		bKeyDown;
var bool					m_bMouseOn;			// the mouse is over the window edit box
var BOOL					m_bDrawEditBorders;
var BOOL					m_bUseNewPaint;
var BOOL                    m_CurrentlyEditing;
var bool		            bSelectOnFocus;
var BOOL					bPassword;
var BOOL					m_bDrawEditBoxBG;	// draw the edit box background
var UWindowEditBoxHistory	HistoryList;
var UWindowEditBoxHistory	CurrentHistory;

var INT                     m_ILeftBorderOffset;

var BOOL                    bShowLog;


function Created()
{
	Super.Created();	

	LastDrawTime = GetTime();
}

function SetHistory(bool bInHistory)
{
	bHistory = bInHistory;

	if (bHistory && HistoryList == None)
	{
		HistoryList = new(None) class'UWindowEditBoxHistory';
		HistoryList.SetupSentinel();
		CurrentHistory = None;
	}
	else
	if (!bHistory && HistoryList != None)
	{
		HistoryList = None;
		CurrentHistory = None;
	}
  
 
}

function SetEditable(bool bEditable)
{
	bCanEdit = bEditable;
}

function SetValue(string NewValue, optional string NewValue2, optional bool noUpdateHistory)
{
	Value = NewValue;
	Value2 = NewValue2;

	if (CaretOffset > Len(Value))
		CaretOffset = Len(Value);		

    if (!bHistory)
    {
        OldValue = Value;
    }    
    else  if (!noUpdateHistory)
	{
		if (Value != "")
		{
			CurrentHistory = UWindowEditBoxHistory(HistoryList.Insert(class'UWindowEditBoxHistory'));
			CurrentHistory.HistoryText = Value;
            if (bShowLog)log("Set value CurrentHistory.HistoryText"@CurrentHistory.HistoryText);

		}
		CurrentHistory = HistoryList;
	}
	Notify(DE_Change);
}

function Clear()
{
	CaretOffset = 0;
	Value="";
	Value2="";
	bAllSelected = False;
	if (bDelayedNotify)
		bChangePending = True;
	else
		Notify(DE_Change);
}

//This is the default function for enabling editing
function SelectAll()
{
    if (bShowLog)log("SelectAll");
	
    if (bCanEdit)
    {
        m_CurrentlyEditing = true;
    }

    if (Value != "")
	{
		CaretOffset = Len(Value);
		bAllSelected = !bAllSelected;
	}
}

function string GetValue()
{
	return Value;
}

function string GetValue2()
{
	return Value2;
}

function Notify(byte E)
{
	if (NotifyOwner != None)
	{
		NotifyOwner.Notify(E);
	} else {
		Super.Notify(E);
	}
}

function InsertText(string Text)
{
	local int i;

	for (i = 0; i < Len(Text); i++)
		Insert(Asc(Mid(Text,i,1)));
}

// Inserts a character at the current caret position
function bool Insert(byte C)
{
	local string	NewValue;

	NewValue = Left(Value, CaretOffset) $ Chr(C) $ Mid(Value, CaretOffset);

	if (Len(NewValue) > MaxLength) 
		return False;

	CaretOffset++;

	Value = NewValue;
	if (bDelayedNotify)
		bChangePending = True;
	else
		Notify(DE_Change);
	return True;
}

function bool Backspace()
{
	local string	NewValue;

	if (CaretOffset == 0) return False;

	NewValue = Left(Value, CaretOffset - 1) $ Mid(Value, CaretOffset);
	CaretOffset--;

	Value = NewValue;
	if (bDelayedNotify)
		bChangePending = True;
	else
		Notify(DE_Change);
	return True;
}

function bool Delete()
{
	local string	NewValue;

	if (CaretOffset == Len(Value)) return False;

	NewValue = Left(Value, CaretOffset) $ Mid(Value, CaretOffset + 1);

	Value = NewValue;
	Notify(DE_Change);
	return True;
}

function bool WordLeft()
{
	while (CaretOffset > 0 && Mid(Value, CaretOffset - 1, 1) == " ")
		CaretOffset--;
	while (CaretOffset > 0 && Mid(Value, CaretOffset - 1, 1) != " ")
		CaretOffset--;

	LastDrawTime = GetTime();
	bShowCaret = True;

	return True;	
}

function bool MoveLeft()
{
	if (CaretOffset == 0) return False;
	CaretOffset--;

	LastDrawTime = GetTime();
	bShowCaret = True;

	return True;	
}

function bool MoveRight()
{
	if (CaretOffset == Len(Value)) return False;
	CaretOffset++;

	LastDrawTime = GetTime();
	bShowCaret = True;

	return True;	
}

function bool WordRight()
{
	while (CaretOffset < Len(Value) && Mid(Value, CaretOffset, 1) != " ")
		CaretOffset++;
	while (CaretOffset < Len(Value) && Mid(Value, CaretOffset, 1) == " ")
		CaretOffset++;

	LastDrawTime = GetTime();
	bShowCaret = True;

	return True;	
}

function bool MoveHome()
{
	CaretOffset = 0;

	LastDrawTime = GetTime();
	bShowCaret = True;

	return True;	
}

function bool MoveEnd()
{
	CaretOffset = Len(Value);

	LastDrawTime = GetTime();
	bShowCaret = True;

	return True;	
}

function EditCopy()
{
	if ((bAllSelected || !bCanEdit) && m_CurrentlyEditing)
		GetPlayerOwner().CopyToClipboard(Value);
}

function EditPaste()
{
	if (bCanEdit && m_CurrentlyEditing)
	{
		if (bAllSelected)
			Clear();
		InsertText(GetPlayerOwner().PasteFromClipboard());
	}
}

function EditCut()
{
	if (bCanEdit && m_CurrentlyEditing)
	{
		if (bAllSelected)
		{
			GetPlayerOwner().CopyToClipboard(Value);
			bAllSelected = False;
			Clear();
		}
	}
	else
		EditCopy();
}

function KeyType(int Key, float MouseX, float MouseY)
{
	local string result;
	result = "";

    if (bShowLog)log("UWindowEditBox::KeyType bCanEdit"@bCanEdit@"bKeyDown"@bKeyDown@"m_CurrentlyEditing"@m_CurrentlyEditing);

        
    if (bCanEdit && bKeyDown && m_CurrentlyEditing)
	{
		if (!bControlDown)
		{
			if (bAllSelected)
				Clear();

			bAllSelected = False;

			if (bNumericOnly)
			{
				if (Key >= 0x30 && Key <= 0x39)  
				{
					Insert(Key);
				}
			}
			else
			{
				//clauzon 11/29/2002, validate aditional characters
				result = GetPlayerOwner().ConsoleCommand("VALIDATECHAR CHAR=" $ Key);
					
				if (Key >= 0x20 && Key < 0x80 && result=="TRUE")
				{
					Insert(Key);
				}
			}
		}
	}
}

function KeyUp(int Key, float X, float Y)
{
	bKeyDown = False;

	switch (Key)
	{
	case Root.Console.EInputKey.IK_Ctrl:
		bControlDown = False;
		break;
	case Root.Console.EInputKey.IK_Shift:
		bShiftDown = False;
		break;
	}
}

function KeyDown(int Key, float X, float Y)
{

	
	bKeyDown = True;
	
	switch (Key)
	{
	case Root.Console.EInputKey.IK_Ctrl:
		bControlDown = True;
		break;
	case Root.Console.EInputKey.IK_Shift:
		bShiftDown = True;
		break;
	case Root.Console.EInputKey.IK_Escape:
        if (bCanEdit && m_CurrentlyEditing)
		{			
            if (bShowLog)log("Escape pressed");

            if (!bHistory)
            {
                SetValue(OldValue, "",true);	                                
            }
			else if (CurrentHistory != None && CurrentHistory.Next != None)
			{
                if (bShowLog)log("CurrentHistory.HistoryText"@CurrentHistory.HistoryText);
                if (bShowLog)log("CurrentHistory.Next.HistoryText"@UWindowEditBoxHistory(CurrentHistory.Next).HistoryText);

				SetValue(UWindowEditBoxHistory(CurrentHistory.Next).HistoryText, "",true);	                
			}            
            MoveEnd();                
            DropSelection();
		}         
		break;
	case Root.Console.EInputKey.IK_Enter:
		if (bCanEdit && m_CurrentlyEditing)
		{
            if (!bHistory)
		{
               OldValue = Value;
            }
			else
			{
				if (Value != "")
				{
					CurrentHistory = UWindowEditBoxHistory(HistoryList.Insert(class'UWindowEditBoxHistory'));
					CurrentHistory.HistoryText = Value;
                    if (bShowLog)log("Set value CurrentHistory.HistoryText"@CurrentHistory.HistoryText);
				}
				CurrentHistory = HistoryList;
			}
            MoveEnd();                
            DropSelection();
			Notify(DE_EnterPressed);
		}
		break;
	case Root.Console.EInputKey.IK_MouseWheelUp:
		if (bCanEdit)
			Notify(DE_WheelUpPressed);
		break;
	case Root.Console.EInputKey.IK_MouseWheelDown:
		if (bCanEdit)
			Notify(DE_WheelDownPressed);
		break;

	case Root.Console.EInputKey.IK_Right:
		if (bCanEdit && m_CurrentlyEditing) 
		{
			if (bControlDown)
				WordRight();
			else
				MoveRight();
            

            bAllSelected = False;
		}
		
		break;
	case Root.Console.EInputKey.IK_Left:
		if (bCanEdit && m_CurrentlyEditing)
		{
			if (bControlDown)
				WordLeft();
			else
				MoveLeft();


            bAllSelected = False;
		}

		break;
	case Root.Console.EInputKey.IK_Up:
		if (bCanEdit && bHistory && m_CurrentlyEditing)
		{
			bAllSelected = False;
			if (CurrentHistory != None && CurrentHistory.Next != None)
			{
				CurrentHistory = UWindowEditBoxHistory(CurrentHistory.Next);
				SetValue(CurrentHistory.HistoryText,"",true);	                
				MoveEnd();
			}
		}
		break;
	case Root.Console.EInputKey.IK_Down:
		if (bCanEdit && bHistory && m_CurrentlyEditing)
		{
			bAllSelected = False;
			if (CurrentHistory != None && CurrentHistory.Prev != None)
			{
				CurrentHistory = UWindowEditBoxHistory(CurrentHistory.Prev);
				SetValue(CurrentHistory.HistoryText,"",true);	                
				MoveEnd();
			}
		}
		break;
	case Root.Console.EInputKey.IK_Home:
		if (bCanEdit && m_CurrentlyEditing)
        {
			MoveHome();
		bAllSelected = False;
        }			
		break;
	case Root.Console.EInputKey.IK_End:
		if (bCanEdit && m_CurrentlyEditing)
        {
			MoveEnd();
		bAllSelected = False;
        }			
		break;
	case Root.Console.EInputKey.IK_Backspace:
		if (bCanEdit && m_CurrentlyEditing)
		{
			if (bAllSelected)
				Clear();
			else
				Backspace();

            bAllSelected = False;
		}

		break;
	case Root.Console.EInputKey.IK_Delete:
		if (bCanEdit && m_CurrentlyEditing)
		{
			if (bAllSelected)
				Clear();
			else
				Delete();


            bAllSelected = False;
		}

		break;
	case Root.Console.EInputKey.IK_Period:
	case Root.Console.EInputKey.IK_NumPadPeriod:
		if (bNumericFloat)
			Insert(Asc("."));
		break;
	default:
		if (bControlDown)
		{
			if (Key == Asc("c") || Key == Asc("C"))
				EditCopy();

			if (Key == Asc("v") || Key == Asc("V"))
				EditPaste();

			if (Key == Asc("x") || Key == Asc("X"))
				EditCut();
		}
		else
		{
			if (NotifyOwner != None)
				NotifyOwner.KeyDown(Key, X, Y);
			else
				Super.KeyDown(Key, X, Y);
		}
	
		break;
	}
}

function Click(float X, float Y)
{
	Notify(DE_Click);
    if (bShowLog)log("UWindowEditBox::Click");
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);
    SelectAll();
	Notify(DE_LMouseDown);
    if (bShowLog)log("UWindowEditBox::LMouseDown");
}

function Paint(Canvas C, float X, float Y)
{
	local float W, H;
	local float TextY;
    local float fCurrentTime;
	
	C.Font = Root.Fonts[Font];	

	if (m_bUseNewPaint)
	{
		TextSize(C, Value, W, H);
		TextY = (WinHeight - H) / 2;

		switch (Align)
		{
	//		case TA_Left:
	//			Offset = Offset + 1;
	//			break;
	//		case TA_Right:
	//			TextX = WinWidth - W - (Len(Text) * m_fFontSpacing) -m_fVBorderWidth;
	//			break;
			case TXT_CENTER:
				Offset = (WinWidth - W - 14) / 2; // 14 is the button size
				break;
			default:
				Offset = Offset + 1;
				break;
		}

		C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);

		if (m_CurrentlyEditing && bAllSelected)
		{
			DrawStretchedTexture(C, Offset, TextY, W, H, Texture'UWindow.WhiteTexture');

			// Invert Colors
			C.SetDrawColor(255 ^ C.DrawColor.R,255 ^ C.DrawColor.G,255 ^ C.DrawColor.B);
		}

		// display the text
		ClipText(C, Offset, TextY,  Value);
	}
	else
	{
	    TextSize(C, "A", W, H);
	    TextY = (WinHeight - H) / 2;

	    TextSize(C, Left(Value, CaretOffset), W, H);
	    
	    if (W + Offset < 0)
		    Offset = -W;

	    if (W + Offset > (WinWidth - 2))
	    {
		    Offset = (WinWidth - 2) - W;
		    if (Offset > 0) Offset = 0;
	    }

	    C.SetDrawColor(TextColor.R,TextColor.G,TextColor.B);

	    if (m_CurrentlyEditing && bAllSelected)
	    {
		    DrawStretchedTexture(C, Offset + 1, TextY, W, H, Texture'UWindow.WhiteTexture');

		    // Invert Colors
		    C.SetDrawColor(255 ^ C.DrawColor.R, 255 ^ C.DrawColor.G, 255 ^ C.DrawColor.B);
	    }

		    // display the text
	    ClipText(C, m_ILeftBorderOffset + Offset + 1, TextY,  Value);
	}

    fCurrentTime = GetTime();
	// show the caret
	if ((!m_CurrentlyEditing) || (!bHasKeyboardFocus) || (!bCanEdit))
    {        
        bShowCaret = False;
    }		
	else
	{       
		if ((fCurrentTime > LastDrawTime + 0.3) || (fCurrentTime < LastDrawTime))
		{
        	LastDrawTime = fCurrentTime;
			bShowCaret = !bShowCaret;
		}
	}

	if (bShowCaret)
    {        
        ClipText(C, m_ILeftBorderOffset + Offset + W - 1, TextY, "|");
    }       
		

	// draw the editbox border
	if (m_bDrawEditBorders)
		DrawSimpleBorder(C);
}

function Close(optional bool bByParent)
{
    DropSelection();
	Super.Close(bByParent);
}

function FocusOtherWindow(UWindowWindow W)
{
    if (bShowLog)log("FocusOtherWindow");
	DropSelection();

	if (NotifyOwner != None)
		NotifyOwner.FocusOtherWindow(W);
	else
		Super.FocusOtherWindow(W);
}


function DoubleClick(float X, float Y)
{
	Super.DoubleClick(X, Y);
	SelectAll();    
}

function KeyFocusEnter()
{
   if (bShowLog)log("UWindowEditBox::KeyFocusEnter");
    
	if (bSelectOnFocus && !bHasKeyboardFocus)
		SelectAll();

	Super.KeyFocusEnter();
}

function KeyFocusExit()
{
    if (bShowLog)log("KeyFocusExit");
    if (bCanEdit && m_CurrentlyEditing)
	{        
        if (!bHistory)
        {            
            OldValue = Value;
        }    
        else
		{
			if (Value != "")
{
				CurrentHistory = UWindowEditBoxHistory(HistoryList.Insert(class'UWindowEditBoxHistory'));
				CurrentHistory.HistoryText = Value;
                if (bShowLog)log("Set value CurrentHistory.HistoryText"@CurrentHistory.HistoryText);
			}
			CurrentHistory = HistoryList;
		}
    }
	DropSelection();
	Super.KeyFocusExit();
}

function DropSelection()
{    
    if (m_CurrentlyEditing)
    {
        if (bChangePending)
{
		    bChangePending = False;
		    Notify(DE_Change);
	    }     
    }   
	bAllSelected = False;
    m_CurrentlyEditing = False;
    bKeyDown = False;
}

function MouseEnter()
{
	Super.MouseEnter();
	m_bMouseOn = true;
}

function MouseLeave()
{
	Super.MouseLeave();
	m_bMouseOn = false;
}

defaultproperties
{
    MaxLength=255
    bCanEdit=true
    m_ILeftBorderOffset=2
    TextColor=(R=255,G=255,B=255,A=255)
}