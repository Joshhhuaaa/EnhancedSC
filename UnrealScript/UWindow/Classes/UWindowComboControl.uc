class UWindowComboControl extends UWindowDialogControl
                    native;

var	float				EditBoxWidth;
var float				EditAreaDrawX, EditAreaDrawY;

var UWindowEditBox		EditBox;
var UWindowComboButton	Button;
var UWindowComboLeftButton LeftButton;
var UWindowComboRightButton RightButton;

var class<UWindowComboList>	ListClass;
var UWindowComboList	List;

var bool				bListVisible;
var bool				bCanEdit;
var bool				bButtons;    
var bool                bSetupSize;

function Created()
{
	Super.Created();
	
	EditBox = UWindowEditBox(CreateWindow(class'UWindowEditBox', 0, 0, WinWidth - LookAndFeel.Size_ComboButtonWidth, WinHeight, self)); 
	EditBox.NotifyOwner = Self;
	EditBoxWidth = WinWidth / 2;
	EditBox.bTransient = True;

	Button = UWindowComboButton(CreateWindow(class'UWindowComboButton', WinWidth - LookAndFeel.Size_ComboButtonWidth, 0, LookAndFeel.Size_ComboButtonWidth, WinHeight, self)); 
	Button.Owner = Self;
	
	List = UWindowComboList(Root.CreateWindow(ListClass, 0, 0, 100, 100)); 
	List.LookAndFeel = LookAndFeel;
	List.Owner = Self;
	List.Setup();
	
	List.HideWindow();
	bListVisible = False;

	SetEditTextColor(LookAndFeel.EditBoxTextColor);

    bSetupSize = true;
}

function SetButtons(bool bInButtons)
{
	bButtons = bInButtons;
	if (bInButtons)
	{
		LeftButton = UWindowComboLeftButton(CreateWindow(class'UWindowComboLeftButton', WinWidth - LookAndFeel.Size_ComboButtonWidth, 0, LookAndFeel.Size_ComboButtonWidth, LookAndFeel.Size_ComboButtonHeight, self));
		RightButton = UWindowComboRightButton(CreateWindow(class'UWindowComboRightButton', WinWidth - LookAndFeel.Size_ComboButtonWidth, 0, LookAndFeel.Size_ComboButtonWidth, LookAndFeel.Size_ComboButtonHeight, self));
	}
	else
	{
		LeftButton = None;
		RightButton = None;
	}

    bSetupSize = true;
}

function Notify(byte E)
{
	Super.Notify(E);

	if (E == DE_LMouseDown)
	{
		if (!bListVisible)
		{
			if (!bCanEdit)
			{
				DropDown();
				Root.CaptureMouse(List);
			}
		}
		else
			CloseUp();
	}
}

function int FindItemIndex(string V, optional bool bIgnoreCase)
{
	return List.FindItemIndex(V, bIgnoreCase);
}

function RemoveItem(int Index)
{
	List.RemoveItem(Index);
}

function int FindItemIndex2(string V2, optional bool bIgnoreCase)
{
	return List.FindItemIndex2(V2, bIgnoreCase);
}

function Close(optional bool bByParent)
{
	if (bByParent && bListVisible)
		CloseUp();

	Super.Close(bByParent);
}

function SetNumericOnly(bool bNumericOnly)
{
	EditBox.bNumericOnly = bNumericOnly;
}

function SetNumericFloat(bool bNumericFloat)
{
	EditBox.bNumericFloat = bNumericFloat;
}

function SetFont(int NewFont)
{
	Super.SetFont(NewFont);
	EditBox.SetFont(NewFont);
}

function SetEditTextColor(Color NewColor)
{
	EditBox.SetTextColor(NewColor);
}

function SetEditable(bool bNewCanEdit)
{
	bCanEdit = bNewCanEdit;
	EditBox.SetEditable(bCanEdit);
}

function int GetSelectedIndex()
{
	return List.FindItemIndex(GetValue());
}

function SetSelectedIndex(int Index)
{
	SetValue(List.GetItemValue(Index), List.GetItemValue2(Index));
}

function string GetValue()
{
	return EditBox.GetValue();
}

function string GetValue2()
{
	return EditBox.GetValue2();
}

function SetValue(string NewValue, optional string NewValue2)
{
	EditBox.SetValue(NewValue, NewValue2);
	UWindowDialogClientWindow(OwnerWindow).Notify(self, DE_Change);
}

function SetMaxLength(int MaxLength)
{
	EditBox.MaxLength = MaxLength;
}

function Paint(Canvas C, float X, float Y)
{
	LookAndFeel.Combo_Draw(Self, C);
	Super.Paint(C, X, Y);
}

function AddItem(string S, optional string S2, optional int SortWeight)
{
	List.AddItem(S, S2, SortWeight);
}

function InsertItem(string S, optional string S2, optional int SortWeight)
{
	List.InsertItem(S, S2, SortWeight);
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);

    if (bSetupSize == true)
    {
        LookAndFeel.Combo_SetupSizes(Self, C);
        bSetupSize = false;
    }
	
	List.bLeaveOnscreen = bListVisible && bLeaveOnscreen;
}

function CloseUp()
{
	bListVisible = False;
	EditBox.SetEditable(bCanEdit);
	EditBox.SelectAll();
	List.HideWindow();
}

function DropDown()
{
	bListVisible = True;
	EditBox.SetEditable(False);
	List.ShowWindow();
}

function Sort()
{
	List.Sort();
}

function ClearValue()
{
	EditBox.Clear();
}

function Clear()
{
	List.Clear();
	EditBox.Clear();
}

function FocusOtherWindow(UWindowWindow W)
{
	Super.FocusOtherWindow(W);

	if (bListVisible && W.ParentWindow != Self && W != List && W.ParentWindow != List)
		CloseUp();
}

defaultproperties
{
    ListClass=Class'UWindowComboList'
    bNoKeyboard=true
    m_BorderColor=(R=51,G=51,B=51,A=255)
}