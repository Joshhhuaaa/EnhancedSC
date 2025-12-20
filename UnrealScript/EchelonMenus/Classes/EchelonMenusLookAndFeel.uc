//=============================================================================
//  EchelonMenusLookAndFeel.uc : (add small description)
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/11 * Created by Alexandre Dionne
//=============================================================================


class EchelonMenusLookAndFeel extends UWindowLookAndFeel;

#exec TEXTURE IMPORT NAME=ActiveFrame FILE=..\UWindow\Textures\ActiveFrame.bmp GROUP="Icons" MASKED=1 MIPS=OFF

var Color   SelectedTextColor;

var() Region	FrameSBL;
var() Region	FrameSB;
var() Region	FrameSBR;

var() Region	CloseBoxUp;
var() Region	CloseBoxDown;
var() int		CloseBoxOffsetX;
var() int		CloseBoxOffsetY;


const SIZEBORDER = 3;
const BRSIZEBORDER = 15;

/* Combo Drawing Functions */
function Combo_SetupSizes(UWindowComboControl W, Canvas C)
{
  	
    W.EditAreaDrawX = 0;
    W.EditBoxWidth = W.WinWidth;

}


function ComboList_DrawItem(UWindowComboList Combo, Canvas C, float X, float Y, float W, float H, string Text, bool bSelected)
{
	if (bSelected)
	{
	    C.DrawColor = EditBoxTextColor;
	}
    else
        C.DrawColor = SelectedTextColor;
        
    
	Combo.ClipText(C, X + Combo.TextBorder + 2, Y + 3, Text);
}

 


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


	C.Font = W.Root.Fonts[W.F_Normal];
	if (W.ParentWindow.ActiveWindow == W)
		C.DrawColor = FrameActiveTitleColor;
	else
		C.DrawColor = FrameInactiveTitleColor;


	W.ClipTextWidth(C, FrameTitleX, FrameTitleY, 
					W.WindowTitle, W.WinWidth - 22);

	if (W.bStatusBar) 
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
//	if ((X >= 3) && (X <= W.WinWidth - 3) && (Y >= 3) && (Y <= 14))
//		return HT_TitleBar;
//	if ((X < BRSIZEBORDER && Y < SIZEBORDER) || (X < SIZEBORDER && Y < BRSIZEBORDER)) 
//		return HT_NW;
//	if ((X > W.WinWidth - SIZEBORDER && Y < BRSIZEBORDER) || (X > W.WinWidth - BRSIZEBORDER && Y < SIZEBORDER))
//		return HT_NE;
//	if ((X < BRSIZEBORDER && Y > W.WinHeight - SIZEBORDER)|| (X < SIZEBORDER && Y > W.WinHeight - BRSIZEBORDER)) 
//		return HT_SW;
//	if ((X > W.WinWidth - BRSIZEBORDER) && (Y > W.WinHeight - BRSIZEBORDER))
//		return HT_SE;
//	if (Y < SIZEBORDER)
//		return HT_N;
//	if (Y > W.WinHeight - SIZEBORDER)
//		return HT_S;
//	if (X < SIZEBORDER)
//		return HT_W;
//	if (X > W.WinWidth - SIZEBORDER)	
//		return HT_E;


	return HT_None;	
}

/* Client Area Drawing Functions */
function DrawClientArea(UWindowClientWindow W, Canvas C)
{
	W.DrawStretchedTexture(C, 0, 0, W.WinWidth, W.WinHeight, Texture'BlackTexture');
}

defaultproperties
{
    SelectedTextColor=(R=77,G=77,B=77,A=255)
	FrameSBL=(X=0,Y=112,W=2,H=16)
    FrameSB=(X=32,Y=112,W=1,H=16)
    FrameSBR=(X=112,Y=112,W=16,H=16)
    CloseBoxUp=(X=4,Y=32,W=11,H=11)
    CloseBoxDown=(X=4,Y=43,W=11,H=11)
    CloseBoxOffsetX=3
    CloseBoxOffsetY=5
    Active=Texture'Icons.ActiveFrame'
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
    EditBoxTextColor=(R=51,G=51,B=51,A=255)
    Size_ComboButtonWidth=16.000000
    Size_ComboButtonHeight=10.000000
    Size_ScrollbarWidth=11.000000
    Size_ScrollbarButtonHeight=10.000000
    Size_MinScrollbarHeight=6.000000
    Size_HMinScrollbarWidth=6.000000
    Size_HScrollbarHeight=18.000000
    Size_HScrollbarButtonWidth=12.000000
}