//=============================================================================
//  EPCCheckBox.uc : CheckBox or Radio Button
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/15 * Created by Alexandre Dionne
//=============================================================================

class EPCCheckBox extends UWindowButton
				native;

function Click(float X, float Y) 
{
    if(bDisabled)
        return;

    m_bSelected = !m_bSelected;
    
	Notify(DE_Click);

	Root.PlayClickSound();
}
