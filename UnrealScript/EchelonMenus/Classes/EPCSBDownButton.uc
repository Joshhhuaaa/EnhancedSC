//=============================================================================
//  EPCSBDownButton.uc : ScrollBar Echelon Style Button
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/13 * Created by Alexandre Dionne
//=============================================================================


class EPCSBDownButton extends UWindowSBDownButton
		native;

function Created(){}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);
	if(!bDisabled)
		Root.PlayClickSound();
}
