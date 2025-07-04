//=============================================================================
//  EPCSBUpButton.uc : Scroll Bar Button Echelon style
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/13 * Created by Alexandre Dionne
//=============================================================================


class EPCSBUpButton extends UWindowSBUpButton
		native;

function Created(){}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);
	if(!bDisabled)
		Root.PlayClickSound();
}
