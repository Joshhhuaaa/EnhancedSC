//=============================================================================
//  UWindowLabelControl.uc : Text Label almost same code as uwindowbutton
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/11 * Created by Alexandre Dionne
//=============================================================================


class UWindowLabelControl extends UWindowDialogControl
            native;

var BOOL		    m_bDrawButtonBorders;
var FLOAT			m_fLMarge;
var FLOAT			m_fFontSpacing;


function SetLabelText(string _Text, ECanvas.ETextAligned _Align)
{
    text = _Text;    
    Align = _Align;    
}


function Paint(Canvas C, float X, float Y)
{
    
    Render(C , X, Y);        

    if (m_bDrawButtonBorders)
	{
		DrawSimpleBorder(C);
	}
}

defaultproperties
{
    bNoKeyboard=True
    m_BorderColor=(R=51,G=51,B=51,A=255)
}