//=============================================================================
//  EPCComboList.uc : Combo drop down list with echelon art style
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/22 * Created by Alexandre Dionne
//=============================================================================


class EPCComboList extends UWindowComboList
			native;


function Paint(Canvas C, float X, float Y)
{
	local int Count;
	local UWindowComboListItem I;    

    
    C.SetDrawColor(255,255,255);
    C.Style = GetLevel().ERenderStyle.STY_Normal;
    DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'WhiteTexture');
	Render(C, X, Y);
	
	Count = 0;

	for( I = UWindowComboListItem(Items.Next);I != None; I = UWindowComboListItem(I.Next) )
	{
		if(VertSB.bWindowVisible)
		{
			if(Count >= VertSB.Pos)
				DrawItem(C, I, HBorder, VBorder + (ItemHeight * (Count - VertSB.Pos)), WinWidth - (2 * HBorder) - VertSB.WinWidth, ItemHeight);
		}
		else
			DrawItem(C, I, HBorder, VBorder + (ItemHeight * Count), WinWidth - (2 * HBorder), ItemHeight);
		Count++;
	}
}
