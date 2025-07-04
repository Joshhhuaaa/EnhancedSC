class UWindowPageControl extends UWindowTabControl;

function ResolutionChanged(float W, float H)
{
	local UWindowPageControlPage I;

	for(I = UWindowPageControlPage(Items.Next); I != None; I = UWindowPageControlPage(I.Next))
		if(I.Page != None && I != SelectedTab )
			I.Page.ResolutionChanged(W, H);
	
	if(SelectedTab != None)
		UWindowPageControlPage(SelectedTab).Page.ResolutionChanged(W, H);
}

function NotifyQuitUnreal()
{
	local UWindowPageControlPage I;

	for(I = UWindowPageControlPage(Items.Next); I != None; I = UWindowPageControlPage(I.Next))
		if(I.Page != None)
			I.Page.NotifyQuitUnreal();
}

function NotifyBeforeLevelChange()
{
	local UWindowPageControlPage I;

	for(I = UWindowPageControlPage(Items.Next); I != None; I = UWindowPageControlPage(I.Next))
		if(I.Page != None)
			I.Page.NotifyBeforeLevelChange();
}

function NotifyAfterLevelChange()
{
	local UWindowPageControlPage I;

	for(I = UWindowPageControlPage(Items.Next); I != None; I = UWindowPageControlPage(I.Next))
		if(I.Page != None)
			I.Page.NotifyAfterLevelChange();
}

function GetDesiredDimensions(out float W, out float H)
{
	local float MaxW, MaxH, TW, TH;
	local UWindowPageControlPage I;
	
	MaxW = 0;
	MaxH = 0;

	for(I = UWindowPageControlPage(Items.Next); I != None; I = UWindowPageControlPage(I.Next))
	{
		if(I.Page != None)
			I.Page.GetDesiredDimensions(TW, TH);

		if(TW > MaxW) MaxW = TW;
		if(TH > MaxH) MaxH = TH;
	}
	W = MaxW;
	H = MaxH + TabArea.WinHeight;
}


function BeforePaint(Canvas C, float X, float Y)
{
	local float OldWinHeight;
	local UWindowPageControlPage I;

	OldWinHeight = WinHeight;
	Super.BeforePaint(C, X, Y);
	WinHeight = OldWinHeight;

	for(I = UWindowPageControlPage(Items.Next); I != None; I = UWindowPageControlPage(I.Next))
		LookAndFeel.Tab_SetTabPageSize(Self, I.Page);
}

function Paint(Canvas C, float X, float Y)
{
	Super.Paint(C, X, Y);
	LookAndFeel.Tab_DrawTabPageArea(Self, C, UWindowPageControlPage(SelectedTab).Page);
}

function UWindowPageControlPage AddPage(string Caption, class<UWindowPageWindow> PageClass, optional name ObjectName)
{
	local UWindowPageControlPage P;
	P = UWindowPageControlPage(AddTab(Caption));
	P.Page = UWindowPageWindow(CreateWindow(PageClass, 0, 
				TabArea.WinHeight-(LookAndFeel.TabSelectedM.H-LookAndFeel.TabUnselectedM.H), 
				WinWidth, WinHeight-(TabArea.WinHeight-(LookAndFeel.TabSelectedM.H-LookAndFeel.TabUnselectedM.H)),,,ObjectName));
	P.Page.OwnerTab = P;

	if(P != SelectedTab) 
		P.Page.HideWindow();
	else
	if(UWindowPageControlPage(SelectedTab) != None && WindowIsVisible())
	{
		UWindowPageControlPage(SelectedTab).Page.ShowWindow();
		UWindowPageControlPage(SelectedTab).Page.BringToFront();
	}

	return P;
}

function UWindowPageControlPage InsertPage(UWindowPageControlPage BeforePage, string Caption, class<UWindowPageWindow> PageClass, optional name ObjectName)
{
	local UWindowPageControlPage P;

	if(BeforePage == None)
		return AddPage(Caption, PageClass);

	P = UWindowPageControlPage(InsertTab(BeforePage, Caption));
	P.Page = UWindowPageWindow(CreateWindow(PageClass, 0, 
				TabArea.WinHeight-(LookAndFeel.TabSelectedM.H-LookAndFeel.TabUnselectedM.H), 
				WinWidth, WinHeight-(TabArea.WinHeight-(LookAndFeel.TabSelectedM.H-LookAndFeel.TabUnselectedM.H)),,,ObjectName));
	P.Page.OwnerTab = P;

	if(P != SelectedTab) 
		P.Page.HideWindow();
	else
	if(UWindowPageControlPage(SelectedTab) != None && WindowIsVisible())
	{
		UWindowPageControlPage(SelectedTab).Page.ShowWindow();
		UWindowPageControlPage(SelectedTab).Page.BringToFront();
	}

	return P;
}

function UWindowPageControlPage GetPage(string Caption)
{
	return UWindowPageControlPage(GetTab(Caption));
}

function DeletePage(UWindowPageControlPage P)
{
	P.Page.Close(True);
	P.Page.HideWindow();
	DeleteTab(P);
}

function Close(optional bool bByParent)
{
	local UWindowPageControlPage I;

	for(I = UWindowPageControlPage(Items.Next); I != None; I = UWindowPageControlPage(I.Next))
		if(I.Page != None)
			I.Page.Close(True);

	Super.Close(bByParent);
}

function GotoTab(UWindowTabControlItem NewSelected, optional bool bByUser)
{
	local UWindowPageControlPage I;

	Super.GotoTab(NewSelected, bByUser);

	for(I = UWindowPageControlPage(Items.Next);I != None;I = UWindowPageControlPage(I.Next))
	{
		if(I != NewSelected)
			I.Page.HideWindow();			
	}

	if(UWindowPageControlPage(NewSelected) != None)
		UWindowPageControlPage(NewSelected).Page.ShowWindow();
}

function UWindowPageControlPage FirstPage()
{
	return UWindowPageControlPage(Items.Next);
}

defaultproperties
{
    ListClass=Class'UWindowPageControlPage'
}