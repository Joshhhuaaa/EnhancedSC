//=============================================================================
//  EPCIngameFakeWindow.uc : Fake window that ingame keypad and quickInvemtory will use
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/25 * Created by Alexandre Dionne
//=============================================================================
class EPCIngameFakeWindow extends UWindowWindow;

function ShowWindow()
{
    Super.ShowWindow();
    EPCMainMenuRootWindow(Root).bSkipLaptopOverlay = true;
}

function HideWindow()
{
    Super.HideWindow();
    EPCMainMenuRootWindow(Root).bSkipLaptopOverlay = false;
}

function MouseMove(float X, float Y)
{
	EPlayerController(GetPlayerOwner()).MouseMove(X, Y);
}

function Click(float X, float Y)
{
	EPlayerController(GetPlayerOwner()).MouseClick(X, Y);
}
