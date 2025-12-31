//=============================================================================
//  EPCFileListBox.uc : File ListBox
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/27 * Created by Alexandre Dionne
//=============================================================================
class EPCFileListBox extends EPCListBox
				native;

var INT     NameWidth, DateWidth; //To allow fields clipping

function Created()
{
    Super.Created();
    NameWidth = WinWidth / 3;
    DateWidth = WinWidth / 3;
}
