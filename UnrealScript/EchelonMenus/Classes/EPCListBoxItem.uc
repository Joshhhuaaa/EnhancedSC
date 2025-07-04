//=============================================================================
//  EPCListBoxItem.uc : (add small description)
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/10/16 * Created by Alexandre Dionne
//=============================================================================


class EPCListBoxItem extends UWindowListBoxItem
                native;

var string m_AltText;
var string szSortByToken;
var Object m_Object;        //This allow attaching what ever to a list item
var BOOL   m_bLocked;       //To display a lock on locked items
var BOOL   m_bReverseSort;

function int Compare(UWindowList T, UWindowList B)
{
	if(EPCListBoxItem(T).m_bReverseSort || EPCListBoxItem(B).m_bReverseSort)
	{
		if(Caps(EPCListBoxItem(T).szSortByToken) > Caps(EPCListBoxItem(B).szSortByToken))
			return -1;
		else if(Caps(EPCListBoxItem(T).szSortByToken) == Caps(EPCListBoxItem(B).szSortByToken))
			return 0;
	}
	else
	{
		if(Caps(EPCListBoxItem(T).szSortByToken) < Caps(EPCListBoxItem(B).szSortByToken))
			return -1;
		else if(Caps(EPCListBoxItem(T).szSortByToken) == Caps(EPCListBoxItem(B).szSortByToken))
			return 0;
	}

	return 1;
}
