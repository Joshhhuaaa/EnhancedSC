class UWindowTabControlTabArea extends UWindowWindow;

var int TabOffset;
var bool bShowSelected;
var UWindowTabControlItem FirstShown;
var bool bDragging;
var UWindowTabControlItem DragTab;
var int TabRows;
var globalconfig bool bArrangeRowsLikeTimHates;
var float UnFlashTime;
var bool bFlashShown;

function Created()
{
	TabOffset = 0;
	Super.Created();
}

function SizeTabsSingleLine(Canvas C)
{
	local UWindowTabControlItem I, Selected, LastHidden;
	local int Count, TabCount;
	local float ItemX, W, H;
	local bool bHaveMore;

	ItemX = LookAndFeel.Size_TabXOffset;
	TabCount = 0;
	for (
			I = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
			I != None;
			I = UWindowTabControlItem(I.Next)
)
	{
		LookAndFeel.Tab_GetTabSize(Self, C, RemoveAmpersand(I.Caption), W, H);
		I.TabWidth = W;
		I.TabHeight = H + 1;
		I.TabTop = 0;
		I.RowNumber = 0;
		TabCount++;
	}

	Selected = UWindowTabControl(ParentWindow).SelectedTab;

	while (True)
	{
		ItemX = LookAndFeel.Size_TabXOffset;
		Count = 0;
		LastHidden = None;
		FirstShown = None;
		for (
				I = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
				I != None;
				I = UWindowTabControlItem(I.Next)
)
		{
			if (Count < TabOffset)
			{
				I.TabLeft = -1;
				LastHidden = I;
			}
			else
			{
				if (FirstShown == None) FirstShown = I;
				I.TabLeft = ItemX;
				if (I.TabLeft + I.TabWidth >= WinWidth + 5) bHaveMore = true;
				ItemX += I.TabWidth;
			}
			Count++;

		}

		if (TabOffset > 0 && LastHidden != None && LastHidden.TabWidth + 5 < WinWidth - ItemX)
			TabOffset--;
		else
		if (bShowSelected && TabOffset < TabCount - 1
			&&	Selected != None &&	Selected != FirstShown
			&& Selected.TabLeft + Selected.TabWidth > WinWidth - 5
)
			TabOffset++;
		else
			break;
	}
	bShowSelected = false;

	UWindowTabControl(ParentWindow).LeftButton.bDisabled = TabOffset <= 0;
	UWindowTabControl(ParentWindow).RightButton.bDisabled = !bHaveMore;
	TabRows = 1;
}

function SizeTabsMultiLine(Canvas C)
{
	local UWindowTabControlItem I, Selected;
	local float W, H;
	local int MinRow;
	local float RowWidths[10];
	local int TabCounts[10];
	local int j;
	local bool bTryAnotherRow;

	TabOffset = 0;
	FirstShown = None;

	TabRows = 1;
	bTryAnotherRow = true;

	while (bTryAnotherRow && TabRows <= 10)
	{
		bTryAnotherRow = false;
		for (j = 0; j < TabRows; j++)
		{
			RowWidths[j] = 0;
			TabCounts[j] = 0;
		}

		for (
				I = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
				I != None;
				I = UWindowTabControlItem(I.Next)
)
		{
			LookAndFeel.Tab_GetTabSize(Self, C, RemoveAmpersand(I.Caption), W, H);
			I.TabWidth = W;
			I.TabHeight = H;

			// find the best row for this tab
			MinRow = 0;
			for (j = 1; j < TabRows; j++)
				if (RowWidths[j] < RowWidths[MinRow])
					MinRow = j;

			if (RowWidths[MinRow] + W > WinWidth)
			{
				TabRows++;
				bTryAnotherRow = true;
				break;
			}
			else
			{
				RowWidths[MinRow] += W;
				TabCounts[MinRow]++;
				I.RowNumber = MinRow;
			}
		}
	}

	Selected = UWindowTabControl(ParentWindow).SelectedTab;

	if (TabRows > 1)
	{
		for (
				I = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
				I != None;
				I = UWindowTabControlItem(I.Next)
)
		{
			I.TabWidth += (WinWidth - RowWidths[I.RowNumber]) / TabCounts[I.RowNumber];
		}
	}

	for (j = 0; j < TabRows; j++)
		RowWidths[j] = 0;

	for (
			I = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
			I != None;
			I = UWindowTabControlItem(I.Next)
)
	{
		I.TabLeft = RowWidths[I.RowNumber];

		if (bArrangeRowsLikeTimHates)
			I.TabTop = ((I.RowNumber + ((TabRows - 1) - Selected.RowNumber)) % TabRows) * I.TabHeight;
		else
			I.TabTop = I.RowNumber * I.TabHeight;

		RowWidths[I.RowNumber] += I.TabWidth;
	}
}

function LayoutTabs(Canvas C)
{
	if (UWindowTabControl(ParentWindow).bMultiLine)
		SizeTabsMultiLine(C);
	else
		SizeTabsSingleLine(C);
}

function Paint(Canvas C, float X, float Y)
{
	local UWindowTabControlItem I;
	local int Count;
	local int Row;
	local float T;

	T = GetEntryLevel().TimeSeconds;

	if (UnFlashTime < T)
	{
		bFlashShown = !bFlashShown;

		if (bFlashShown)
			UnFlashTime = T + 0.5;
		else
			UnFlashTime = T + 0.3;
	}

	for (Row = 0; Row < TabRows; Row++)
	{
		Count = 0;
		for (
				I = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
				I != None;
				I = UWindowTabControlItem(I.Next)
)
		{
			if (Count < TabOffset)
			{
				Count++;
				continue;
			}
			if (I.RowNumber == Row)
				DrawItem(C, I, I.TabLeft, I.TabTop, I.TabWidth, I.TabHeight, (!I.bFlash) || bFlashShown);
		}
	}
}

function LMouseDown(float X, float Y)
{
	local UWindowTabControlItem I;
	local int Count;

	Super.LMouseDown(X, Y);

	Count = 0;
	for (
			I = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
			I != None;
			I = UWindowTabControlItem(I.Next)
)
	{
		if (Count < TabOffset)
		{
			Count++;
			continue;
		}
		if (X >= I.TabLeft && X <= I.TabLeft + I.TabWidth && (TabRows == 1 || (Y >= I.TabTop && Y <= I.TabTop + I.TabHeight)))
		{
			if (!UWindowTabControl(ParentWindow).bMultiLine)
			{
				bDragging = true;
				DragTab = I;
				Root.CaptureMouse();
			}
			UWindowTabControl(ParentWindow).GotoTab(I, True);
		}
	}
}

function MouseMove(float X, float Y)
{
	if (bDragging && bMouseDown)
	{
		if (X < DragTab.TabLeft)
			TabOffset++;

		if (X > DragTab.TabLeft + DragTab.TabWidth && TabOffset > 0)
			TabOffset--;
	}
	else
		bDragging = false;
}

function RMouseDown(float X, float Y)
{
	local UWindowTabControlItem I;
	local int Count;

	Super.LMouseDown(X, Y);

	Count = 0;
	for (
			I = UWindowTabControlItem(UWindowTabControl(ParentWindow).Items.Next);
			I != None;
			I = UWindowTabControlItem(I.Next)
)
	{
		if (Count < TabOffset)
		{
			Count++;
			continue;
		}
		if (X >= I.TabLeft && X <= I.TabLeft + I.TabWidth)
		{
			I.RightClickTab();
		}
	}
}

function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H, bool bShowText)
{
	if (Item == UWindowTabControl(ParentWindow).SelectedTab)
		LookAndFeel.Tab_DrawTab(Self, C, True, FirstShown == Item, X, Y, W, H, UWindowTabControlItem(Item).Caption, bShowText);
	else
		LookAndFeel.Tab_DrawTab(Self, C, False, FirstShown == Item, X, Y, W, H, UWindowTabControlItem(Item).Caption, bShowText);
}

function bool CheckMousePassThrough(float X, float Y)
{
	return Y >= LookAndFeel.Size_TabAreaHeight * TabRows;
}

