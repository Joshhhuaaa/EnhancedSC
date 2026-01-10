//=============================================================================
//  EPCTextButton.uc : Simple text button control
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/09 * Created by Alexandre Dionne
//=============================================================================
class EPCTextButton extends UWindowButton
                    native;

function Click(float X, float Y)
{
	Super.Click(X, Y);
	Root.PlayClickSound();
}

defaultproperties
{
    m_SelectedTextColor=(R=255,G=255,B=255,A=255)
    m_OverTextColor=(R=51,G=51,B=51,A=255)
    TextColor=(R=77,G=77,B=77,A=255)
}