class UWindowTabControl extends UWindowListControl;

var UWindowTabControlLeftButton		LeftButton;
var UWindowTabControlRightButton	RightButton;
var UWindowTabControlTabArea		TabArea;
var UWindowTabControlItem			SelectedTab;

var bool							bMultiLine;
var bool							bSelectNearestTabOnRemove;

function Created()
{
	Super.Created();

	SelectedTab = None;

	TabArea = UWindowTabControlTabArea(CreateWindow(class'UWindowTabControlTabArea', 
					0, 0, WinWidth - LookAndFeel.Size_ScrollbarWidth 
						- LookAndFeel.Size_ScrollbarWidth - 10,
					 LookAndFeel.Size_TabAreaHeight + LookAndFeel.Size_TabAreaOverhangHeight));

	TabArea.bAlwaysOnTop = true;

	LeftButton = UWindowTabControlLeftButton(CreateWindow(class'UWindowTabControlLeftButton', WinWidth - 20, 0, 10, 12));
	RightButton = UWindowTabControlRightButton(CreateWindow(class'UWindowTabControlRightButton', WinWidth - 10, 0, 10, 12));
}

function BeforePaint(Canvas C, float X, float Y)
{
	TabArea.WinTop = 0;
	TabArea.WinLeft = 0;

	if (bMultiLine)
		TabArea.WinWidth = WinWidth;
	else
		TabArea.WinWidth = WinWidth - LookAndFeel.Size_ScrollbarWidth - LookAndFeel.Size_ScrollbarWidth - 10;

	TabArea.LayoutTabs(C);
	WinHeight = (LookAndFeel.Size_TabAreaHeight * TabArea.TabRows) + LookAndFeel.Size_TabAreaOverhangHeight;
	TabArea.WinHeight = WinHeight;

	Super.BeforePaint(C, X, Y);
}

function SetMultiLine(bool InMultiLine)
{
	bMultiLine = InMultiLine;

	if (bMultiLine)
	{	
		LeftButton.HideWindow();
		RightButton.HideWindow();
	}
	else
	{
		LeftButton.ShowWindow();
		RightButton.ShowWindow();
	}
}

function Paint(Canvas C, float X, float Y)
{
	local Region R;
	local Texture T;

	T = GetLookAndFeelTexture();
	R = LookAndFeel.TabBackground;
	DrawStretchedTextureSegment(C, 0, 0, WinWidth, LookAndFeel.Size_TabAreaHeight * TabArea.TabRows, R.X, R.Y, R.W, R.H, T);
}

function UWindowTabControlItem AddTab(string Caption)
{
	local UWindowTabControlItem I;

	I = UWindowTabControlItem(Items.Append(ListClass));

	I.Owner = Self;
	I.SetCaption(Caption);

	if (SelectedTab == None) 
		SelectedTab = I;
	
	return I;
}

function UWindowTabControlItem InsertTab(UWindowTabControlItem BeforeTab, string Caption)
{
	local UWindowTabControlItem I;

	I = UWindowTabControlItem(BeforeTab.InsertBefore(ListClass));

	I.Owner = Self;
	I.SetCaption(Caption);

	if (SelectedTab == None) 
		SelectedTab = I;
	
	return I;
}

function GotoTab(UWindowTabControlItem NewSelected, optional bool bByUser)
{
	if (SelectedTab != NewSelected && bByUser)
		LookAndFeel.PlayMenuSound(Self, MS_ChangeTab);
	SelectedTab = NewSelected;
	TabArea.bShowSelected = true;
}

function UWindowTabControlItem GetTab(string Caption)
{
	local UWindowTabControlItem I;
	for (I = UWindowTabControlItem(Items.Next); I != None; I = UWindowTabControlItem(I.Next))
	{
		if (I.Caption == Caption) return I;
	}

	return None;		
}

function DeleteTab(UWindowTabControlItem Tab)
{
	local UWindowTabControlItem NextTab;
	local UWindowTabControlItem PrevTab;
	
	NextTab = UWindowTabControlItem(Tab.Next);
	PrevTab = UWindowTabControlItem(Tab.Prev);
	Tab.Remove();

	if (SelectedTab == Tab)
	{
		if (bSelectNearestTabOnRemove)
		{
			Tab = NextTab;
			if (Tab == None)
				Tab = PrevTab;
			
			GotoTab(Tab);
		}
		else
			GotoTab(UWindowTabControlItem(Items.Next));
	}
}

defaultproperties
{
    ListClass=Class'UWindowTabControlItem'
}