class UDebugBlueLookAndFeel extends UWindowLookAndFeel;

#exec TEXTURE IMPORT NAME=BlueActiveFrame FILE=Textures\b_ActiveFrame.pcx GROUP="Icons" MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueInactiveFrame FILE=Textures\b_InactiveFrame.pcx GROUP="Icons" MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueActiveFrameS FILE=Textures\b_ActiveFrameS.pcx GROUP="Icons" MASKED=1 MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueInactiveFrameS FILE=Textures\b_InactiveFrameS.pcx GROUP="Icons" MASKED=1 MIPS=OFF

#exec TEXTURE IMPORT NAME=BlueMisc FILE=Textures\b_Misc.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueButton FILE=Textures\b_SmallButton.pcx GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=BlueMenuArea FILE=Textures\b_MenuArea.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueClientArea FILE=Textures\b_ClientArea.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuTL FILE=Textures\b_MenuTL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuT FILE=Textures\b_MenuT.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuTR FILE=Textures\b_MenuTR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuL FILE=Textures\b_MenuL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuR FILE=Textures\b_MenuR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuBL FILE=Textures\b_MenuBL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuB FILE=Textures\b_MenuB.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuBR FILE=Textures\b_MenuBR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuHL FILE=Textures\b_MenuHL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuHM FILE=Textures\b_MenuHM.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuHR FILE=Textures\b_MenuHR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueMenuLine FILE=Textures\b_MenuLine.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=BlueBarL FILE=Textures\b_BarL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarTile FILE=Textures\b_BarTile.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarMax FILE=Textures\b_BarMax.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarWin FILE=Textures\b_BarWin.bmp GROUP="Icons" MIPS=OFF


#exec TEXTURE IMPORT NAME=BlueBarInL FILE=Textures\b_BarInL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarInR FILE=Textures\b_BarInR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarInM FILE=Textures\b_BarInM.bmp GROUP="Icons" MIPS=OFF

#exec TEXTURE IMPORT NAME=BlueBarOutL FILE=Textures\b_BarOutL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarOutR FILE=Textures\b_BarOutR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BlueBarOutM FILE=Textures\b_BarOutM.bmp GROUP="Icons" MIPS=OFF

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

	C.SetDrawColor(255, 255, 255);

	T = W.GetLookAndFeelTexture();

	R = FrameTL;
	W.DrawStretchedTextureSegment(C, 0, 0, R.W, R.H, R.X, R.Y, R.W, R.H, T);

	R = FrameT;
	W.DrawStretchedTextureSegment(C, FrameTL.W, 0,
									W.WinWidth - FrameTL.W
									- FrameTR.W,
									R.H, R.X, R.Y, R.W, R.H, T);

	R = FrameTR;
	W.DrawStretchedTextureSegment(C, W.WinWidth - R.W, 0, R.W, R.H, R.X, R.Y, R.W, R.H, T);


	if (W.bStatusBar)
		Temp = FrameSBL;
	else
		Temp = FrameBL;


	R = FrameL;
	W.DrawStretchedTextureSegment(C, 0, FrameTL.H,
									R.W,
									W.WinHeight - FrameTL.H
									- Temp.H,
									R.X, R.Y, R.W, R.H, T);

	R = FrameR;
	W.DrawStretchedTextureSegment(C, W.WinWidth - R.W, FrameTL.H,
									R.W,
									W.WinHeight - FrameTL.H
									- Temp.H,
									R.X, R.Y, R.W, R.H, T);

	if (W.bStatusBar)
		R = FrameSBL;
	else
		R = FrameBL;
	W.DrawStretchedTextureSegment(C, 0, W.WinHeight - R.H, R.W, R.H, R.X, R.Y, R.W, R.H, T);

	if (W.bStatusBar)
	{
		R = FrameSB;
		W.DrawStretchedTextureSegment(C, FrameBL.W, W.WinHeight - R.H,
										W.WinWidth - FrameSBL.W
										- FrameSBR.W,
										R.H, R.X, R.Y, R.W, R.H, T);
	}
	else
	{
		R = FrameB;
		W.DrawStretchedTextureSegment(C, FrameBL.W, W.WinHeight - R.H,
										W.WinWidth - FrameBL.W
										- FrameBR.W,
										R.H, R.X, R.Y, R.W, R.H, T);
	}

	if (W.bStatusBar)
		R = FrameSBR;
	else
		R = FrameBR;
	W.DrawStretchedTextureSegment(C, W.WinWidth - R.W, W.WinHeight - R.H, R.W, R.H, R.X, R.Y,
									R.W, R.H, T);


	if (W.ParentWindow.ActiveWindow == W)
	{
		C.DrawColor = FrameActiveTitleColor;
		C.Font = W.Root.Fonts[W.F_Bold];
	}
	else
	{
		C.DrawColor = FrameInactiveTitleColor;
		C.Font = W.Root.Fonts[W.F_Normal];
	}


	W.ClipTextWidth(C, FrameTitleX, FrameTitleY,
					W.WindowTitle, W.WinWidth - 22);

	if (W.bStatusBar)
	{
		C.Font = W.Root.Fonts[W.F_Normal];
		C.SetDrawColor(0, 0, 0);

		W.ClipTextWidth(C, 6, W.WinHeight - 13, W.StatusBarText, W.WinWidth - 22);

		C.SetDrawColor(255, 255, 255);
	}
}

function FW_SetupFrameButtons(UWindowFramedWindow W, Canvas C)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();

	W.CloseBox.WinLeft = W.WinWidth - CloseBoxOffsetX - CloseBoxUp.W;
	W.CloseBox.WinTop = CloseBoxOffsetY;

	W.CloseBox.SetSize(CloseBoxUp.W, CloseBoxUp.H);
	W.CloseBox.bUseRegion = true;

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
	if (W.bStatusBar)
		R.H = W.WinHeight - (FrameT.H + FrameSB.H);
	else
		R.H = W.WinHeight - (FrameT.H + FrameB.H);

	return R;
}


function FrameHitTest FW_HitTest(UWindowFramedWindow W, float X, float Y)
{
	if ((X >= 3) && (X <= W.WinWidth - 3) && (Y >= 3) && (Y <= 14))
		return HT_TitleBar;
	if ((X < BRSIZEBORDER && Y < SIZEBORDER) || (X < SIZEBORDER && Y < BRSIZEBORDER))
		return HT_NW;
	if ((X > W.WinWidth - SIZEBORDER && Y < BRSIZEBORDER) || (X > W.WinWidth - BRSIZEBORDER && Y < SIZEBORDER))
		return HT_NE;
	if ((X < BRSIZEBORDER && Y > W.WinHeight - SIZEBORDER)|| (X < SIZEBORDER && Y > W.WinHeight - BRSIZEBORDER))
		return HT_SW;
	if ((X > W.WinWidth - BRSIZEBORDER) && (Y > W.WinHeight - BRSIZEBORDER))
		return HT_SE;
	if (Y < SIZEBORDER)
		return HT_N;
	if (Y > W.WinHeight - SIZEBORDER)
		return HT_S;
	if (X < SIZEBORDER)
		return HT_W;
	if (X > W.WinWidth - SIZEBORDER)
		return HT_E;

	return HT_None;
}

/* Client Area Drawing Functions */
function DrawClientArea(UWindowClientWindow W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'BlueMenuTL');
	W.DrawStretchedTexture(C, 2, 0, W.WinWidth - 4, 2, Texture'BlueMenuT');
	W.DrawClippedTexture(C, W.WinWidth - 2, 0, Texture'BlueMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight - 2, Texture'BlueMenuBL');
	W.DrawStretchedTexture(C, 2, W.WinHeight - 2, W.WinWidth - 4, 2, Texture'BlueMenuB');
	W.DrawClippedTexture(C, W.WinWidth - 2, W.WinHeight - 2, Texture'BlueMenuBR');

	W.DrawStretchedTexture(C, 0, 2, 2, W.WinHeight - 4, Texture'BlueMenuL');
	W.DrawStretchedTexture(C, W.WinWidth - 2, 2, 2, W.WinHeight - 4, Texture'BlueMenuR');

	W.DrawStretchedTexture(C, 2, 2, W.WinWidth - 4, W.WinHeight - 4, Texture'BlueClientArea');
}


/* Combo Drawing Functions */

function Combo_SetupSizes(UWindowComboControl W, Canvas C)
{
	local float TW, TH;

	C.Font = W.Root.Fonts[W.Font];
	W.TextSize(C, W.Text, TW, TH);

	W.WinHeight = 12 + MiscBevelT[2].H + MiscBevelB[2].H;

	switch (W.Align)
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

	if (W.bButtons)
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

	if (W.Text != "")
	{
		C.DrawColor = W.TextColor;
		W.ClipText(C, W.TextX, W.TextY, W.Text);
		C.SetDrawColor(255, 255, 255);
	}
}

function ComboList_DrawBackground(UWindowComboList W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'BlueMenuTL');
	W.DrawStretchedTexture(C, 4, 0, W.WinWidth - 8, 4, Texture'BlueMenuT');
	W.DrawClippedTexture(C, W.WinWidth - 4, 0, Texture'BlueMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight - 4, Texture'BlueMenuBL');
	W.DrawStretchedTexture(C, 4, W.WinHeight - 4, W.WinWidth - 8, 4, Texture'BlueMenuB');
	W.DrawClippedTexture(C, W.WinWidth - 4, W.WinHeight - 4, Texture'BlueMenuBR');

	W.DrawStretchedTexture(C, 0, 4, 4, W.WinHeight - 8, Texture'BlueMenuL');
	W.DrawStretchedTexture(C, W.WinWidth - 4, 4, 4, W.WinHeight - 8, Texture'BlueMenuR');

	W.DrawStretchedTexture(C, 4, 4, W.WinWidth - 8, W.WinHeight - 8, Texture'BlueMenuArea');
}

function ComboList_DrawItem(UWindowComboList Combo, Canvas C, float X, float Y, float W, float H, string Text, bool bSelected)
{
	C.SetDrawColor(255, 255, 255);

	if (bSelected)
	{
		Combo.DrawClippedTexture(C, X, Y, Texture'BlueMenuHL');
		Combo.DrawStretchedTexture(C, X + 4, Y, W - 8, 16, Texture'BlueMenuHM');
		Combo.DrawClippedTexture(C, X + W - 4, Y, Texture'BlueMenuHR');
		C.SetDrawColor(0, 0, 0);
	}
	else
	{
		C.SetDrawColor(0, 0, 0);
	}

	Combo.ClipText(C, X + Combo.TextBorder + 2, Y + 3, Text);
}



function Combo_GetButtonBitmaps(UWindowComboButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();

	W.bUseRegion = true;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = ComboBtnUp;
	W.DownRegion = ComboBtnDown;
	W.OverRegion = ComboBtnUp;
	W.DisabledRegion = ComboBtnDisabled;
}

function Combo_SetupLeftButton(UWindowComboLeftButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();

	W.bUseRegion = true;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = SBLeftUp;
	W.DownRegion = SBLeftDown;
	W.OverRegion = SBLeftUp;
	W.DisabledRegion = SBLeftDisabled;
}

function Combo_SetupRightButton(UWindowComboRightButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();

	W.bUseRegion = true;

	W.UpTexture = T;
	W.DownTexture = T;
	W.OverTexture = T;
	W.DisabledTexture = T;

	W.UpRegion = SBRightUp;
	W.DownRegion = SBRightDown;
	W.OverRegion = SBRightUp;
	W.DisabledRegion = SBRightDisabled;
}



function Editbox_SetupSizes(UWindowEditControl W, Canvas C)
{
	local float TW, TH;
	local int B;

	B = EditBoxBevel;

	C.Font = W.Root.Fonts[W.Font];
	W.TextSize(C, W.Text, TW, TH);

	W.WinHeight = 12 + MiscBevelT[B].H + MiscBevelB[B].H;

	switch (W.Align)
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

	if (W.Text != "")
	{
		C.DrawColor = W.TextColor;
		W.ClipText(C, W.TextX, W.TextY, W.Text);
		C.SetDrawColor(255, 255, 255);
	}
}

function ControlFrame_SetupSizes(UWindowControlFrame W, Canvas C)
{
	local int B;

	B = EditBoxBevel;

	W.Framed.WinLeft = MiscBevelL[B].W;
	W.Framed.WinTop = MiscBevelT[B].H;
	W.Framed.SetSize(W.WinWidth - MiscBevelL[B].W - MiscBevelR[B].W, W.WinHeight - MiscBevelT[B].H - MiscBevelB[B].H);
}

function ControlFrame_Draw(UWindowControlFrame W, Canvas C)
{
	C.SetDrawColor(255, 255, 255);

	W.DrawStretchedTexture(C, 0, 0, W.WinWidth, W.WinHeight, Texture'WhiteTexture');
	W.DrawMiscBevel(C, 0, 0, W.WinWidth, W.WinHeight, Misc, EditBoxBevel);
}

function Tab_DrawTab(UWindowTabControlTabArea Tab, Canvas C, bool bActiveTab, bool bLeftmostTab, float X, float Y, float W, float H, string Text, bool bShowText)
{
	local Region R;
	local Texture T;
	local float TW, TH;

	C.SetDrawColor(255, 255, 255);

	T = Tab.GetLookAndFeelTexture();

	if (bActiveTab)
	{
		R = TabSelectedL;
		Tab.DrawStretchedTextureSegment(C, X, Y, R.W, R.H, R.X, R.Y, R.W, R.H, T);

		R = TabSelectedM;
		Tab.DrawStretchedTextureSegment(C, X + TabSelectedL.W, Y,
										W - TabSelectedL.W
										- TabSelectedR.W,
										R.H, R.X, R.Y, R.W, R.H, T);

		R = TabSelectedR;
		Tab.DrawStretchedTextureSegment(C, X + W - R.W, Y, R.W, R.H, R.X, R.Y, R.W, R.H, T);

		C.Font = Tab.Root.Fonts[Tab.F_Bold];
		C.SetDrawColor(0, 0, 0);

		if (bShowText)
		{
			Tab.TextSize(C, Text, TW, TH);
			Tab.ClipText(C, X + (W - TW) / 2, Y + 3, Text, True);
		}
	}
	else
	{
		R = TabUnselectedL;
		Tab.DrawStretchedTextureSegment(C, X, Y, R.W, R.H, R.X, R.Y, R.W, R.H, T);

		R = TabUnselectedM;
		Tab.DrawStretchedTextureSegment(C, X + TabUnselectedL.W, Y,
										W - TabUnselectedL.W
										- TabUnselectedR.W,
										R.H, R.X, R.Y, R.W, R.H, T);

		R = TabUnselectedR;
		Tab.DrawStretchedTextureSegment(C, X + W - R.W, Y, R.W, R.H, R.X, R.Y, R.W, R.H, T);

		C.Font = Tab.Root.Fonts[Tab.F_Normal];
		C.SetDrawColor(0, 0, 0);

		if (bShowText)
		{
			Tab.TextSize(C, Text, TW, TH);
			Tab.ClipText(C, X + (W - TW) / 2, Y + 4, Text, True);
		}
	}
}

function SB_SetupUpButton(UWindowSBUpButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();

	W.bUseRegion = true;

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

	W.bUseRegion = true;

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

	W.bUseRegion = true;

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

	W.bUseRegion = true;

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
	W.DrawStretchedTextureSegment(C, 0, 0, W.WinWidth, W.WinHeight, R.X, R.Y, R.W, R.H, T);

	if (!W.bDisabled)
	{
		W.DrawUpBevel(C, 0, W.ThumbStart, Size_ScrollbarWidth,	W.ThumbHeight, T);
	}
}

function SB_HDraw(UWindowHScrollbar W, Canvas C)
{
	local Region R;
	local Texture T;

	T = W.GetLookAndFeelTexture();

	R = SBBackground;
	W.DrawStretchedTextureSegment(C, 0, 0, W.WinWidth, W.WinHeight, R.X, R.Y, R.W, R.H, T);

	if (!W.bDisabled)
	{
		W.DrawUpBevel(C, W.ThumbStart, 0, W.ThumbWidth, Size_ScrollbarWidth, T);
	}
}

function Tab_SetupLeftButton(UWindowTabControlLeftButton W)
{
	local Texture T;

	T = W.GetLookAndFeelTexture();


	W.WinWidth = Size_ScrollbarButtonHeight;
	W.WinHeight = Size_ScrollbarWidth;
	W.WinTop = Size_TabAreaHeight - W.WinHeight;
	W.WinLeft = W.ParentWindow.WinWidth - 2 * W.WinWidth;

	W.bUseRegion = true;

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

	W.bUseRegion = true;

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
	P.WinTop = W.TabArea.WinHeight - (TabSelectedM.H - TabUnselectedM.H) + 3;
	P.SetSize(W.WinWidth - 4, W.WinHeight - (W.TabArea.WinHeight - (TabSelectedM.H - TabUnselectedM.H)) - 6);
}

function Tab_DrawTabPageArea(UWindowPageControl W, Canvas C, UWindowPageWindow P)
{
	W.DrawUpBevel(C, 0, W.TabArea.WinHeight - (TabSelectedM.H - TabUnselectedM.H), W.WinWidth, W.WinHeight - (W.TabArea.WinHeight - (TabSelectedM.H - TabUnselectedM.H)), W.GetLookAndFeelTexture());
}

function Tab_GetTabSize(UWindowTabControlTabArea Tab, Canvas C, string Text, out float W, out float H)
{
	local float TW, TH;

	C.Font = Tab.Root.Fonts[Tab.F_Bold];

	Tab.TextSize(C, Text, TW, TH);
	W = TW + Size_TabSpacing;
	H = Size_TabAreaHeight;
}

function Menu_DrawMenuBar(UWindowMenuBar W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'BlueBarL');
	W.DrawStretchedTexture(C, 16, 0, W.WinWidth - 32, 16, Texture'BlueBarTile');
	W.DrawClippedTexture(C, W.WinWidth - 16, 0, Texture'BlueBarWin');
}

function Menu_DrawMenuBarItem(UWindowMenuBar B, UWindowMenuBarItem I, float X, float Y, float W, float H, Canvas C)
{
	if (B.Selected == I)
	{
		B.DrawClippedTexture(C, X, 0, Texture'BlueBarInL');
		B.DrawClippedTexture(C, X + W - 1, 0, Texture'BlueBarInR');
		B.DrawStretchedTexture(C, X + 1, 0, W - 2, 16, Texture'BlueBarInM');
	}
	else
	if (B.Over == I)
	{
		B.DrawClippedTexture(C, X, 0, Texture'BlueBarOutL');
		B.DrawClippedTexture(C, X + W - 1, 0, Texture'BlueBarOutR');
		B.DrawStretchedTexture(C, X + 1, 0, W - 2, 16, Texture'BlueBarOutM');
	}

	C.Font = B.Root.Fonts[F_Normal];
	C.SetDrawColor(0, 0, 0);

	B.ClipText(C, X + B.SPACING / 2, 3, I.Caption, True);
}

function Menu_DrawPulldownMenuBackground(UWindowPulldownMenu W, Canvas C)
{
	W.DrawClippedTexture(C, 0, 0, Texture'BlueMenuTL');
	W.DrawStretchedTexture(C, 4, 0, W.WinWidth - 8, 4, Texture'BlueMenuT');
	W.DrawClippedTexture(C, W.WinWidth - 4, 0, Texture'BlueMenuTR');

	W.DrawClippedTexture(C, 0, W.WinHeight - 4, Texture'BlueMenuBL');
	W.DrawStretchedTexture(C, 4, W.WinHeight - 4, W.WinWidth - 8, 4, Texture'BlueMenuB');
	W.DrawClippedTexture(C, W.WinWidth - 4, W.WinHeight - 4, Texture'BlueMenuBR');

	W.DrawStretchedTexture(C, 0, 4, 4, W.WinHeight - 8, Texture'BlueMenuL');
	W.DrawStretchedTexture(C, W.WinWidth - 4, 4, 4, W.WinHeight - 8, Texture'BlueMenuR');
	W.DrawStretchedTexture(C, 4, 4, W.WinWidth - 8, W.WinHeight - 8, Texture'BlueMenuArea');
}

function Menu_DrawPulldownMenuItem(UWindowPulldownMenu M, UWindowPulldownMenuItem Item, Canvas C, float X, float Y, float W, float H, bool bSelected)
{
	C.SetDrawColor(255, 255, 255);
	Item.ItemTop = Y + M.WinTop;

	if (Item.Caption == "-")
	{
		M.DrawStretchedTexture(C, X, Y + 5, W, 2, Texture'BlueMenuLine');
		return;
	}

	C.Font = M.Root.Fonts[F_Normal];

	if (bSelected)
	{
		M.DrawClippedTexture(C, X, Y, Texture'BlueMenuHL');
		M.DrawStretchedTexture(C, X + 4, Y, W - 8, 16, Texture'BlueMenuHM');
		M.DrawClippedTexture(C, X + W - 4, Y, Texture'BlueMenuHR');
	}

	if (Item.bDisabled)
	{
		// Black Shadow
		C.SetDrawColor(96, 96, 96);
	}
	else
	{
		C.SetDrawColor(0, 0, 0);
	}

	// DrawColor will render the tick black white or gray.
	if (Item.bChecked)
		M.DrawClippedTexture(C, X + 1, Y + 3, Texture'MenuTick');

	if (Item.SubMenu != None)
		M.DrawClippedTexture(C, X + W - 9, Y + 3, Texture'MenuSubArrow');

	M.ClipText(C, X + M.TextBorder + 2, Y + 3, Item.Caption, True);
}

function Button_DrawSmallButton(UWindowSmallButton B, Canvas C)
{
	local float Y;

	if (B.bDisabled)
		Y = 34;
	else
	if (B.bMouseDown)
		Y = 17;
	else
		Y = 0;

	B.DrawStretchedTextureSegment(C, 0, 0, 3, 16, 0, Y, 3, 16, Texture'BlueButton');
	B.DrawStretchedTextureSegment(C, B.WinWidth - 3, 0, 3, 16, 45, Y, 3, 16, Texture'BlueButton');
	B.DrawStretchedTextureSegment(C, 3, 0, B.WinWidth - 6, 16, 3, Y, 42, 16, Texture'BlueButton');
}

function PlayMenuSound(UWindowWindow W, MenuSound S)
{
	switch (S)
	{
	case MS_MenuPullDown:
//		W.GetPlayerOwner().PlaySound(sound'WindowOpen', SLOT_Interface);
		break;
	case MS_MenuCloseUp:
		break;
	case MS_MenuItem:
//		W.GetPlayerOwner().PlaySound(sound'LittleSelect', SLOT_Interface);
		break;
	case MS_WindowOpen:
//		W.GetPlayerOwner().PlaySound(sound'BigSelect', SLOT_Interface);
		break;
	case MS_WindowClose:
		break;
	case MS_ChangeTab:
//		W.GetPlayerOwner().PlaySound(sound'LittleSelect', SLOT_Interface);
		break;

	}
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
    CloseBoxOffsetX=2
    CloseBoxOffsetY=2
    Active=Texture'Icons.BlueActiveFrame'
    Inactive=Texture'Icons.BlueInactiveFrame'
    ActiveS=Texture'Icons.BlueActiveFrameS'
    InactiveS=Texture'Icons.BlueInactiveFrameS'
    Misc=Texture'Icons.BlueMisc'
    FrameTL=(X=0,Y=0,W=2,H=16)
    FrameT=(X=32,Y=0,W=1,H=16)
    FrameTR=(X=126,Y=0,W=2,H=16)
    FrameL=(X=0,Y=32,W=2,H=1)
    FrameR=(X=126,Y=32,W=2,H=1)
    FrameBL=(X=0,Y=125,W=2,H=3)
    FrameB=(X=32,Y=125,W=1,H=3)
    FrameBR=(X=126,Y=125,W=2,H=3)
    FrameActiveTitleColor=(R=0,G=0,B=0,A=255)
    FrameInactiveTitleColor=(R=255,G=255,B=255,A=255)
    HeadingActiveTitleColor=(R=0,G=0,B=0,A=255)
    HeadingInActiveTitleColor=(R=255,G=255,B=255,A=255)
    FrameTitleX=6
    FrameTitleY=2
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
    EditBoxTextColor=(R=0,G=0,B=0,A=255)
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
    Pulldown_ItemHeight=16.000000
    Pulldown_VBorder=4.000000
    Pulldown_HBorder=3.000000
    Pulldown_TextBorder=9.000000
}