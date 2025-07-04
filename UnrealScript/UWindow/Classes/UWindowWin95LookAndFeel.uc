class UWindowWin95LookAndFeel extends UWindowLookAndFeel;

#exec TEXTURE IMPORT NAME=ActiveFrame FILE=Textures\ActiveFrame.bmp GROUP="Icons" MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=InactiveFrame FILE=Textures\InactiveFrame.bmp GROUP="Icons" MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=ActiveFrameS FILE=Textures\ActiveFrameS.bmp GROUP="Icons" MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=InactiveFrameS FILE=Textures\InactiveFrameS.bmp GROUP="Icons" MASKED=1 MIPS=OFF

#exec TEXTURE IMPORT NAME=Misc FILE=Textures\Misc.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=ChkChecked FILE=Textures\ChkChecked.bmp GROUP="Icons" MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=ChkUnchecked FILE=Textures\ChkUnchecked.bmp GROUP="Icons" MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=ChkCheckedDisabled FILE=Textures\ChkCheckedDisabled.bmp GROUP="Icons" MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=ChkUncheckedDisabled FILE=Textures\ChkUncheckedDisabled.bmp GROUP="Icons" MASKED=1 MIPS=OFF

#exec TEXTURE IMPORT NAME=MenuBar FILE=Textures\MenuBar.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuHighlightL FILE=Textures\MenuHighlightL.bmp MASKED=1 GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuHighlightM FILE=Textures\MenuHighlightM.bmp MASKED=1 GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuHighlightR FILE=Textures\MenuHighlightR.bmp MASKED=1 GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=MenuArea FILE=Textures\MenuArea.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuTL FILE=Textures\MenuTL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuT FILE=Textures\MenuT.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuTR FILE=Textures\MenuTR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuL FILE=Textures\MenuL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuR FILE=Textures\MenuR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuBL FILE=Textures\MenuBL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuB FILE=Textures\MenuB.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuBR FILE=Textures\MenuBR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuHighlight FILE=Textures\MenuHighlight.bmp GROUP="Icons" MIPS=OFF

var() Region	SBUpUp;
var() Region	SBUpDown;
var() Region	SBUpDisabled;

var() Region	SBDownUp;
var() Region	SBDownDown;
var() Region	SBDownDisabled;

var() Region	SBLeftUp;
var() Region	SBLeftDown;
var() Region	SBLeftDisabled;

var() Region	SBRightUp;
var() Region	SBRightDown;
var() Region	SBRightDisabled;

var() Region	SBBackground;

var() Region	FrameSBL;
var() Region	FrameSB;
var() Region	FrameSBR;

var() Region	CloseBoxUp;
var() Region	CloseBoxDown;
var() int		CloseBoxOffsetX;
var() int		CloseBoxOffsetY;


const SIZEBORDER = 3;
const BRSIZEBORDER = 15;

/* Framed Window Drawing Functions */
function FW_DrawWindowFrame(UWindowFramedWindow W, Canvas C)
{
	local Texture T;
	local Region R, Temp;

	C.DrawColor.r = 255;
	C.DrawColor.g = 255;
	C.DrawColor.b = 255;

	T = W.GetLookAndFeelTexture();

	R = FrameTL;
	W.DrawStretchedTextureSegment( C, 0, 0, R.W, R.H, R.X, R.Y, R.W, R.H, T );

	R = FrameT;
	W.DrawStretchedTextureSegment( C, FrameTL.W, 0, 
									W.WinWidth - FrameTL.W
									- FrameTR.W,
									R.H, R.X, R.Y, R.W, R.H, T );

	R = FrameTR;
	W.DrawStretchedTextureSegment( C, W.WinWidth - R.W, 0, R.W, R.H, R.X, R.Y, R.W, R.H, T );
	

	if(W.bStatusBar)
		Temp = FrameSBL;
	else
		Temp = FrameBL;
	
	R = FrameL;
	W.DrawStretchedTextureSegment( C, 0, FrameTL.H,
									R.W,  
									W.WinHeight - FrameTL.H
									- Temp.H,
									R.X, R.Y, R.W, R.H, T );

	R = FrameR;
	W.DrawStretchedTextureSegment( C, W.WinWidth - R.W, FrameTL.H,
									R.W,  
									W.WinHeight - FrameTL.H
									- Temp.H,
									R.X, R.Y, R.W, R.H, T );

	if(W.bStatusBar)
		R = FrameSBL;
	else
		R = FrameBL;
	W.DrawStretchedTextureSegment( C, 0, W.WinHeight - R.H, R.W, R.H, R.X, R.Y, R.W, R.H, T );

	if(W.bStatusBar)
	{
		R = FrameSB;
		W.DrawStretchedTextureSegment( C, FrameBL.W, W.WinHeight - R.H, 
										W.WinWidth - FrameSBL.W
										- FrameSBR.W,
										R.H, R.X, R.Y, R.W, R.H, T );
	}
	else
	{
		R = FrameB;
		W.DrawStretchedTextureSegment( C, FrameBL.W, W.WinHeight - R.H, 
										W.WinWidth - FrameBL.W
										- FrameBR.W,
										R.H, R.X, R.Y, R.W, R.H, T );
	}

	if(W.bStatusBar)
		R = FrameSBR;
	else
		R = FrameBR;
	W.DrawStretchedTextureSegment( C, W.WinWidth - R.W, W.WinHeight - R.H, R.W, R.H, R.X, R.Y, 
									R.W, R.H, T );


	C.Font = W.Root.Fonts[W.F_Normal];
	if(W.ParentWindow.ActiveWindow == W)
		C.DrawColor = FrameActiveTitleColor;
	else
		C.DrawColor = FrameInactiveTitleColor;


	W.ClipTextWidth(C, FrameTitleX, FrameTitleY, 
					W.WindowTitle, W.WinWidth - 22);

	if(W.bStatusBar) 
	{
		C.DrawColor.r = 0;
		C.DrawColor.g = 0;
		C.DrawColor.b = 0;

		W.ClipTextWidth(C, 6, W.WinHeight - 13, W.StatusBarText, W.WinWidth - 22);

		C.DrawColor.r = 255;
		C.DrawColor.g = 255;
		C.DrawColor.b = 255;
	}
}

function FW_SetupFrameButtons(UWindowFramedWindow W, Canvas C)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();

	W.CloseBox.WinLeft = W.WinWidth - CloseBoxOffsetX - CloseBoxUp.W;
	W.CloseBox.WinTop = CloseBoxOffsetY;

	W.CloseBox.SetSize(CloseBoxUp.W, CloseBoxUp.H);
	W.CloseBox.bUseRegion = True;

	W.CloseBox.UpTexture = T;
	W.CloseBox.DownTexture = T;
	W.CloseBox.OverTexture = T;
	W.CloseBox.DisabledTexture = T;

	W.CloseBox.UpRegion = CloseBoxUp;
	W.CloseBox.DownRegion = CloseBoxDown;
	W.CloseBox.OverRegion = CloseBoxUp;
	W.CloseBox.DisabledRegion = CloseBoxUp;
}

function Region FW_GetClientArea(UWindowFramedWindow W)
{
	local Region R;

	R.X = FrameL.W;
	R.Y	= FrameT.H;
	R.W = W.WinWidth - (FrameL.W + FrameR.W);
	if(W.bStatusBar) 
		R.H = W.WinHeight - (FrameT.H + FrameSB.H);
	else
		R.H = W.WinHeight - (FrameT.H + FrameB.H);

	return R;
}


function FrameHitTest FW_HitTest(UWindowFramedWindow W, float X, float Y)
{
	if((X >= 3) && (X <= W.WinWidth-3) && (Y >= 3) && (Y <= 14))
		return HT_TitleBar;
	if((X < BRSIZEBORDER && Y < SIZEBORDER) || (X < SIZEBORDER && Y < BRSIZEBORDER)) 
		return HT_NW;
	if((X > W.WinWidth - SIZEBORDER && Y < BRSIZEBORDER) || (X > W.WinWidth - BRSIZEBORDER && Y < SIZEBORDER))
		return HT_NE;
	if((X < BRSIZEBORDER && Y > W.WinHeight - SIZEBORDER)|| (X < SIZEBORDER && Y > W.WinHeight - BRSIZEBORDER)) 
		return HT_SW;
	if((X > W.WinWidth - BRSIZEBORDER) && (Y > W.WinHeight - BRSIZEBORDER))
		return HT_SE;
	if(Y < SIZEBORDER)
		return HT_N;
	if(Y > W.WinHeight - SIZEBORDER)
		return HT_S;
	if(X < SIZEBORDER)
		return HT_W;
	if(X > W.WinWidth - SIZEBORDER)	
		return HT_E;

	return HT_None;	
}

/* Client Area Drawing Functions */
function DrawClientArea(UWindowClientWindow W, Canvas C)
{
	W.DrawStretchedTexture(C, 0, 0, W.WinWidth, W.WinHeight, Texture'BlackTexture');
}


/* Combo Drawing Functions */
function Combo_SetupSizes(UWindowComboControl W, Canvas C)
{
	local float TW, TH;

	C.Font = W.Root.Fonts[W.Font];
	W.TextSize(C, W.Text, TW, TH);
	
	W.WinHeight = 12 + MiscBevelT[2].H + MiscBevelB[2].H;
	
	switch(W.Align)
	{
	case TXT_LEFT:
		W.EditAreaDrawX = W.WinWidth - W.EditBoxWidth;
		W.TextX = 0;
		break;
	case TXT_RIGHT:
		W.EditAreaDrawX = 0;	
		W.TextX = W.WinWidth - TW;
		break;
	case TXT_CENTER:
		W.EditAreaDrawX = (W.WinWidth - W.EditBoxWidth) / 2;
		W.TextX = (W.WinWidth - TW) / 2;
		break;
	}

	W.EditAreaDrawY = (W.WinHeight - 2) / 2;
	W.TextY = (W.WinHeight - TH) / 2;

	W.EditBox.WinLeft = W.EditAreaDrawX + MiscBevelL[2].W;
	W.EditBox.WinTop = MiscBevelT[2].H;
	W.Button.WinWidth = ComboBtnUp.W;

	if(W.bButtons)
	{
		W.EditBox.WinWidth = W.EditBoxWidth - MiscBevelL[2].W - MiscBevelR[2].W - ComboBtnUp.W - SBLeftUp.W - SBRightUp.W;
		W.EditBox.WinHeight = W.WinHeight - MiscBevelT[2].H - MiscBevelB[2].H;
		W.Button.WinLeft = W.WinWidth - ComboBtnUp.W - MiscBevelR[2].W - SBLeftUp.W - SBRightUp.W;
		W.Button.WinTop = W.EditBox.WinTop;

		W.LeftButton.WinLeft = W.WinWidth - MiscBevelR[2].W - SBLeftUp.W - SBRightUp.W;
		W.LeftButton.WinTop = W.EditBox.WinTop;
		W.RightButton.WinLeft = W.WinWidth - MiscBevelR[2].W - SBRightUp.W;
		W.RightButton.WinTop = W.EditBox.WinTop;

		W.LeftButton.WinWidth = SBLeftUp.W;
		W.LeftButton.WinHeight = SBLeftUp.H;
		W.RightButton.WinWidth = SBRightUp.W;
		W.RightButton.WinHeight = SBRightUp.H;
	}
	else
	{
		W.EditBox.WinWidth = W.EditBoxWidth - MiscBevelL[2].W - MiscBevelR[2].W - ComboBtnUp.W;
		W.EditBox.WinHeight = W.WinHeight - MiscBevelT[2].H - MiscBevelB[2].H;
		W.Button.WinLeft = W.WinWidth - ComboBtnUp.W - MiscBevelR[2].W;
		W.Button.WinTop = W.EditBox.WinTop;
	}
	W.Button.WinHeight = W.EditBox.WinHeight;
}

function Combo_Draw(UWindowComboControl W, Canvas C)
{
	W.DrawMiscBevel(C, W.EditAreaDrawX, 0, W.EditBoxWidth, W.WinHeight, Misc, 2);

	if(W.Text != "")
	{
		C.DrawColor = W.TextColor;
		W.ClipText(C, W.TextX, W.TextY, W.Text);
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}
}

function ComboList_DrawBackground(UWindowComboList W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'UWindow.MenuTL');
	W.DrawStretchedTexture(C, 4, 0, W.WinWidth-8, 4, Texture'UWindow.MenuT');
	W.DrawClippedTexture(C, W.WinWidth-4, 0, Texture'UWindow.MenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight-4, Texture'UWindow.MenuBL');
	W.DrawStretchedTexture(C, 4, W.WinHeight-4, W.WinWidth-8, 4, Texture'UWindow.MenuB');
	W.DrawClippedTexture(C, W.WinWidth-4, W.WinHeight-4, Texture'UWindow.MenuBR');

	W.DrawStretchedTexture(C, 0, 4, 4, W.WinHeight-8, Texture'UWindow.MenuL');
	W.DrawStretchedTexture(C, W.WinWidth-4, 4, 4, W.WinHeight-8, Texture'UWindow.MenuR');

	W.DrawStretchedTexture(C, 4, 4, W.WinWidth-8, W.WinHeight-8, Texture'UWindow.MenuArea');
}

function ComboList_DrawItem(UWindowComboList Combo, Canvas C, float X, float Y, float W, float H, string Text, bool bSelected)
{
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	if(bSelected)
	{
		Combo.DrawStretchedTexture(C, X, Y, W, H, Texture'UWindow.MenuHighlight');
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}
	else
	{
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}

	Combo.ClipText(C, X + Combo.TextBorder + 2, Y + 3, Text);
}


function Combo_GetButtonBitmaps(UWindowComboButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();
	
	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = ComboBtnUp;
	W.DownRegion = ComboBtnDown;
	W.OverRegion = ComboBtnUp;
	W.DisabledRegion = ComboBtnDisabled;
}

function Editbox_SetupSizes(UWindowEditControl W, Canvas C)
{
	local float TW, TH;
	local int B;

	B = EditBoxBevel;
		
	C.Font = W.Root.Fonts[W.Font];
	W.TextSize(C, W.Text, TW, TH);
	
	W.WinHeight = 12 + MiscBevelT[B].H + MiscBevelB[B].H;
	
	switch(W.Align)
	{
	case TXT_LEFT:
		W.EditAreaDrawX = W.WinWidth - W.EditBoxWidth;
		W.TextX = 0;
		break;
	case TXT_RIGHT:
		W.EditAreaDrawX = 0;	
		W.TextX = W.WinWidth - TW;
		break;
	case TXT_CENTER:
		W.EditAreaDrawX = (W.WinWidth - W.EditBoxWidth) / 2;
		W.TextX = (W.WinWidth - TW) / 2;
		break;
	}

	W.EditAreaDrawY = (W.WinHeight - 2) / 2;
	W.TextY = (W.WinHeight - TH) / 2;

	W.EditBox.WinLeft = W.EditAreaDrawX + MiscBevelL[B].W;
	W.EditBox.WinTop = MiscBevelT[B].H;
	W.EditBox.WinWidth = W.EditBoxWidth - MiscBevelL[B].W - MiscBevelR[B].W;
	W.EditBox.WinHeight = W.WinHeight - MiscBevelT[B].H - MiscBevelB[B].H;
}

function Editbox_Draw(UWindowEditControl W, Canvas C)
{
	W.DrawMiscBevel(C, W.EditAreaDrawX, 0, W.EditBoxWidth, W.WinHeight, Misc, EditBoxBevel);

	if(W.Text != "")
	{
		C.DrawColor = W.TextColor;
		W.ClipText(C, W.TextX, W.TextY, W.Text);
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
	}
}

function Tab_DrawTab(UWindowTabControlTabArea Tab, Canvas C, bool bActiveTab, bool bLeftmostTab, float X, float Y, float W, float H, string Text, bool bShowText)
{
	local Region R;
	local Texture T;
	local float TW, TH;

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	T = Tab.GetLookAndFeelTexture();
	
	if(bActiveTab)
	{
		R = TabSelectedL;
		Tab.DrawStretchedTextureSegment( C, X, Y, R.W, R.H, R.X, R.Y, R.W, R.H, T );

		R = TabSelectedM;
		Tab.DrawStretchedTextureSegment( C, X+TabSelectedL.W, Y, 
										W - TabSelectedL.W
										- TabSelectedR.W,
										R.H, R.X, R.Y, R.W, R.H, T );

		R = TabSelectedR;
		Tab.DrawStretchedTextureSegment( C, X + W - R.W, Y, R.W, R.H, R.X, R.Y, R.W, R.H, T );

		C.Font = Tab.Root.Fonts[Tab.F_Bold];
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;

		if(bShowText)
		{
			Tab.TextSize(C, Text, TW, TH);
			Tab.ClipText(C, X + (W-TW)/2, Y + 3, Text, True);
		}
	}
	else
	{
		R = TabUnselectedL;
		Tab.DrawStretchedTextureSegment( C, X, Y, R.W, R.H, R.X, R.Y, R.W, R.H, T );

		R = TabUnselectedM;
		Tab.DrawStretchedTextureSegment( C, X+TabUnselectedL.W, Y, 
										W - TabUnselectedL.W
										- TabUnselectedR.W,
										R.H, R.X, R.Y, R.W, R.H, T );

		R = TabUnselectedR;
		Tab.DrawStretchedTextureSegment( C, X + W - R.W, Y, R.W, R.H, R.X, R.Y, R.W, R.H, T );

		C.Font = Tab.Root.Fonts[Tab.F_Normal];
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;

		if(bShowText)
		{
			Tab.TextSize(C, Text, TW, TH);
			Tab.ClipText(C, X + (W-TW)/2, Y + 4, Text, True);
		}
	}
}

function SB_SetupUpButton(UWindowSBUpButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = SBUpUp;
	W.DownRegion = SBUpDown;
	W.OverRegion = SBUpUp;
	W.DisabledRegion = SBUpDisabled;
}

function SB_SetupDownButton(UWindowSBDownButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = SBDownUp;
	W.DownRegion = SBDownDown;
	W.OverRegion = SBDownUp;
	W.DisabledRegion = SBDownDisabled;
}



function SB_SetupLeftButton(UWindowSBLeftButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = SBLeftUp;
	W.DownRegion = SBLeftDown;
	W.OverRegion = SBLeftUp;
	W.DisabledRegion = SBLeftDisabled;
}

function SB_SetupRightButton(UWindowSBRightButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = SBRightUp;
	W.DownRegion = SBRightDown;
	W.OverRegion = SBRightUp;
	W.DisabledRegion = SBRightDisabled;
}

function SB_VDraw(UWindowVScrollbar W, Canvas C)
{
	local Region R;
	local Texture T;

	T = W.GetLookAndFeelTexture();

	R = SBBackground;
	W.DrawStretchedTextureSegment( C, 0, 0, W.WinWidth, W.WinHeight, R.X, R.Y, R.W, R.H, T);
	
	if(!W.bDisabled)
	{
		W.DrawUpBevel( C, 0, W.ThumbStart, Size_ScrollbarWidth,	W.ThumbHeight, T);
	}
}

function SB_HDraw(UWindowHScrollbar W, Canvas C)
{
	local Region R;
	local Texture T;

	T = W.GetLookAndFeelTexture();

	R = SBBackground;
	W.DrawStretchedTextureSegment( C, 0, 0, W.WinWidth, W.WinHeight, R.X, R.Y, R.W, R.H, T);
	
	if(!W.bDisabled) 
	{
		W.DrawUpBevel( C, W.ThumbStart, 0, W.ThumbWidth, Size_ScrollbarWidth, T);
	}
}

function Tab_SetupLeftButton(UWindowTabControlLeftButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();


	W.WinWidth = Size_ScrollbarButtonHeight;
	W.WinHeight = Size_ScrollbarWidth;
	W.WinTop = Size_TabAreaHeight - W.WinHeight;
	W.WinLeft = W.ParentWindow.WinWidth - 2*W.WinWidth;

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = SBLeftUp;
	W.DownRegion = SBLeftDown;
	W.OverRegion = SBLeftUp;
	W.DisabledRegion = SBLeftDisabled;
}

function Tab_SetupRightButton(UWindowTabControlRightButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();

	W.WinWidth = Size_ScrollbarButtonHeight;
	W.WinHeight = Size_ScrollbarWidth;
	W.WinTop = Size_TabAreaHeight - W.WinHeight;
	W.WinLeft = W.ParentWindow.WinWidth - W.WinWidth;

	W.bUseRegion = True;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = SBRightUp;
	W.DownRegion = SBRightDown;
	W.OverRegion = SBRightUp;
	W.DisabledRegion = SBRightDisabled;
}

function Tab_SetTabPageSize(UWindowPageControl W, UWindowPageWindow P)
{
	P.WinLeft = 2;
	P.WinTop = W.TabArea.WinHeight-(TabSelectedM.H-TabUnselectedM.H) + 3;
	P.SetSize(W.WinWidth - 4, W.WinHeight-(W.TabArea.WinHeight-(TabSelectedM.H-TabUnselectedM.H)) - 6);
}

function Tab_DrawTabPageArea(UWindowPageControl W, Canvas C, UWindowPageWindow P)
{
	W.DrawUpBevel( C, 0, Size_TabAreaHeight, W.WinWidth, W.WinHeight-Size_TabAreaHeight, W.GetLookAndFeelTexture());
}

function Tab_GetTabSize(UWindowTabControlTabArea Tab, Canvas C, string Text, out float W, out float H)
{
	local float TW, TH;

	C.Font = Tab.Root.Fonts[Tab.F_Normal];

	Tab.TextSize( C, Text, TW, TH );
	W = TW + Size_TabSpacing;
	H = TH;
}

function Menu_DrawMenuBar(UWindowMenuBar W, Canvas C)
{
	W.DrawStretchedTexture( C, 16, 0, W.WinWidth - 32, 16, Texture'UWindow.MenuBar');
}

function Menu_DrawMenuBarItem(UWindowMenuBar B, UWindowMenuBarItem I, float X, float Y, float W, float H, Canvas C)
{
	if(B.Selected == I)
	{
		B.DrawClippedTexture(C, X, 1, Texture'MenuHighlightL');
		B.DrawClippedTexture(C, X+W-1, 1, Texture'MenuHighlightR');
		B.DrawStretchedTexture(C, X+1, 1, W-2, 16, Texture'MenuHighlightM');
	}

	C.Font = B.Root.Fonts[F_Normal];
	C.DrawColor.R = 0;
	C.DrawColor.G = 0;
	C.DrawColor.B = 0;

	B.ClipText(C, X + B.Spacing / 2, 2, I.Caption, True);
}

function Menu_DrawPulldownMenuBackground(UWindowPulldownMenu W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'UWindow.MenuTL');
	W.DrawStretchedTexture(C, 2, 0, W.WinWidth-4, 2, Texture'UWindow.MenuT');
	W.DrawClippedTexture(C, W.WinWidth-2, 0, Texture'UWindow.MenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight-2, Texture'UWindow.MenuBL');
	W.DrawStretchedTexture(C, 2, W.WinHeight-2, W.WinWidth-4, 2, Texture'UWindow.MenuB');
	W.DrawClippedTexture(C, W.WinWidth-2, W.WinHeight-2, Texture'UWindow.MenuBR');

	W.DrawStretchedTexture(C, 0, 2, 2, W.WinHeight-4, Texture'UWindow.MenuL');
	W.DrawStretchedTexture(C, W.WinWidth-2, 2, 2, W.WinHeight-4, Texture'UWindow.MenuR');
	W.DrawStretchedTexture(C, 2, 2, W.WinWidth-4, W.WinHeight-4, Texture'UWindow.MenuArea');
}

function Menu_DrawPulldownMenuItem(UWindowPulldownMenu M, UWindowPulldownMenuItem Item, Canvas C, float X, float Y, float W, float H, bool bSelected)
{
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	Item.ItemTop = Y + M.WinTop;

	if(Item.Caption == "-")
	{
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
		M.DrawStretchedTexture(C, X, Y+5, W, 2, Texture'UWindow.MenuDivider');
		return;
	}

	C.Font = M.Root.Fonts[F_Normal];

	if(bSelected)
		M.DrawStretchedTexture(C, X, Y, W, H, Texture'UWindow.MenuHighlight');

	if(Item.bDisabled) 
	{
		// Black Shadow
		C.DrawColor.R = 96;
		C.DrawColor.G = 96;
		C.DrawColor.B = 96;
	}
	else
	{
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}

	// DrawColor will render the tick black white or gray.
	if(Item.bChecked)
		M.DrawClippedTexture(C, X + 1, Y + 3, Texture'MenuTick');

	if(Item.SubMenu != None)
		M.DrawClippedTexture(C, X + W - 9, Y + 3, Texture'MenuSubArrow');

	M.ClipText(C, X + M.TextBorder + 2, Y + 3, Item.Caption, True);	
}

defaultproperties
{
    SBUpUp=(X=20,Y=16,W=12,H=10)
    SBUpDown=(X=32,Y=16,W=12,H=10)
    SBUpDisabled=(X=44,Y=16,W=12,H=10)
    SBDownUp=(X=20,Y=26,W=12,H=10)
    SBDownDown=(X=32,Y=26,W=12,H=10)
    SBDownDisabled=(X=44,Y=26,W=12,H=10)
    SBLeftUp=(X=20,Y=48,W=10,H=12)
    SBLeftDown=(X=30,Y=48,W=10,H=12)
    SBLeftDisabled=(X=40,Y=48,W=10,H=12)
    SBRightUp=(X=20,Y=36,W=10,H=12)
    SBRightDown=(X=30,Y=36,W=10,H=12)
    SBRightDisabled=(X=40,Y=36,W=10,H=12)
    SBBackground=(X=4,Y=79,W=1,H=1)
    FrameSBL=(X=0,Y=112,W=2,H=16)
    FrameSB=(X=32,Y=112,W=1,H=16)
    FrameSBR=(X=112,Y=112,W=16,H=16)
    CloseBoxUp=(X=4,Y=32,W=11,H=11)
    CloseBoxDown=(X=4,Y=43,W=11,H=11)
    CloseBoxOffsetX=3
    CloseBoxOffsetY=5
    Active=Texture'Icons.ActiveFrame'
    Inactive=Texture'Icons.InactiveFrame'
    ActiveS=Texture'Icons.ActiveFrameS'
    InactiveS=Texture'Icons.InactiveFrameS'
    Misc=Texture'Icons.Misc'
	FrameTL=(X=0,Y=0,W=2,H=16)
    FrameT=(X=32,Y=0,W=1,H=16)
    FrameTR=(X=126,Y=0,W=2,H=16)
    FrameL=(X=0,Y=32,W=2,H=1)
    FrameR=(X=126,Y=32,W=2,H=1)
    FrameBL=(X=0,Y=125,W=2,H=3)
    FrameB=(X=32,Y=125,W=1,H=3)
    FrameBR=(X=126,Y=125,W=2,H=3)
    FrameActiveTitleColor=(R=255,G=255,B=255,A=255)
    FrameInactiveTitleColor=(R=255,G=255,B=255,A=255)
    FrameTitleX=6
    FrameTitleY=4
    BevelUpTL=(X=4,Y=16,W=2,H=2)
    BevelUpT=(X=10,Y=16,W=1,H=2)
    BevelUpTR=(X=18,Y=16,W=2,H=2)
    BevelUpL=(X=4,Y=20,W=2,H=1)
    BevelUpR=(X=18,Y=20,W=2,H=1)
    BevelUpBL=(X=4,Y=30,W=2,H=2)
    BevelUpB=(X=10,Y=30,W=1,H=2)
    BevelUpBR=(X=18,Y=30,W=2,H=2)
    BevelUpArea=(X=8,Y=20,W=1,H=1)
    MiscBevelTL(0)=(X=0,Y=17,W=3,H=3)
    MiscBevelTL(1)=(X=0,Y=0,W=3,H=3)
    MiscBevelTL(2)=(X=0,Y=33,W=2,H=2)
    MiscBevelTL(3)=(X=0,Y=0,W=0,H=0)
    MiscBevelT(0)=(X=3,Y=17,W=116,H=3)
    MiscBevelT(1)=(X=3,Y=0,W=116,H=3)
    MiscBevelT(2)=(X=2,Y=33,W=1,H=2)
    MiscBevelT(3)=(X=0,Y=0,W=0,H=0)
    MiscBevelTR(0)=(X=119,Y=17,W=3,H=3)
    MiscBevelTR(1)=(X=119,Y=0,W=3,H=3)
    MiscBevelTR(2)=(X=11,Y=33,W=2,H=2)
    MiscBevelTR(3)=(X=0,Y=0,W=0,H=0)
    MiscBevelL(0)=(X=0,Y=20,W=3,H=10)
    MiscBevelL(1)=(X=0,Y=3,W=3,H=10)
    MiscBevelL(2)=(X=0,Y=36,W=2,H=1)
    MiscBevelL(3)=(X=0,Y=0,W=0,H=0)
    MiscBevelR(0)=(X=119,Y=20,W=3,H=10)
    MiscBevelR(1)=(X=119,Y=3,W=3,H=10)
    MiscBevelR(2)=(X=11,Y=36,W=2,H=1)
    MiscBevelR(3)=(X=0,Y=0,W=0,H=0)
    MiscBevelBL(0)=(X=0,Y=30,W=3,H=3)
    MiscBevelBL(1)=(X=0,Y=14,W=3,H=3)
    MiscBevelBL(2)=(X=0,Y=44,W=2,H=2)
    MiscBevelBL(3)=(X=0,Y=0,W=0,H=0)
    MiscBevelB(0)=(X=3,Y=30,W=116,H=3)
    MiscBevelB(1)=(X=3,Y=14,W=116,H=3)
    MiscBevelB(2)=(X=2,Y=44,W=1,H=2)
    MiscBevelB(3)=(X=0,Y=0,W=0,H=0)
    MiscBevelBR(0)=(X=119,Y=30,W=3,H=3)
    MiscBevelBR(1)=(X=119,Y=14,W=3,H=3)
    MiscBevelBR(2)=(X=11,Y=44,W=2,H=2)
    MiscBevelBR(3)=(X=0,Y=0,W=0,H=0)
    MiscBevelArea(0)=(X=3,Y=20,W=116,H=10)
    MiscBevelArea(1)=(X=3,Y=3,W=116,H=10)
    MiscBevelArea(2)=(X=2,Y=35,W=9,H=9)
    MiscBevelArea(3)=(X=0,Y=0,W=0,H=0)
    ComboBtnUp=(X=20,Y=60,W=12,H=12)
    ComboBtnDown=(X=32,Y=60,W=12,H=12)
    ComboBtnDisabled=(X=44,Y=60,W=12,H=12)
    ColumnHeadingHeight=13
    HLine=(X=5,Y=78,W=1,H=2)
    EditBoxBevel=2
    TabSelectedL=(X=4,Y=80,W=3,H=17)
    TabSelectedM=(X=7,Y=80,W=1,H=17)
    TabSelectedR=(X=55,Y=80,W=2,H=17)
    TabUnselectedL=(X=57,Y=80,W=3,H=15)
    TabUnselectedM=(X=60,Y=80,W=1,H=15)
    TabUnselectedR=(X=109,Y=80,W=2,H=15)
    TabBackground=(X=4,Y=79,W=1,H=1)
    Size_ComboButtonWidth=12.000000
    Size_ComboButtonHeight=10.000000
    Size_ScrollbarWidth=12.000000
    Size_ScrollbarButtonHeight=10.000000
    Size_MinScrollbarHeight=6.000000
    Size_HMinScrollbarWidth=6.000000
    Size_HScrollbarHeight=12.000000
    Size_HScrollbarButtonWidth=10.000000
    Size_TabAreaHeight=15.000000
    Size_TabAreaOverhangHeight=2.000000
    Size_TabSpacing=20.000000
    Size_TabXOffset=1.000000
    Pulldown_ItemHeight=15.000000
    Pulldown_VBorder=3.000000
    Pulldown_HBorder=3.000000
    Pulldown_TextBorder=9.000000
}