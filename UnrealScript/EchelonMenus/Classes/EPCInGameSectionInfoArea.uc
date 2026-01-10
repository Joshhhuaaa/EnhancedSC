//=============================================================================
//  EPCInGameSectionInfoArea.uc : Area that gives info on a ingame menu section
//  Copyright 2002 Ubi Soft, Inc. All Rights Reserved.
//
//  Revision history:
//    2002/11/15 * Created by Alexandre Dionne
//=============================================================================
class EPCInGameSectionInfoArea extends UWindowWindow
					native;

var UWindowLabelControl     m_LHelpText;
var INT                     m_IXLabelPos, m_IYLabelPos, m_ILabelWidth, m_ILabelHeight;

var Color                   m_TextColor;

function Created()
{
    m_LHelpText       = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_IXLabelPos, m_IYLabelPos, m_ILabelWidth, m_ILabelHeight, self));
    m_LHelpText.Font        = F_Normal;
    m_LHelpText.TextColor   = m_TextColor;
}

function SetHelpText(string _szHelp)
{
    m_LHelpText.SetLabelText(_szHelp,TXT_CENTER);
}

function Paint(Canvas C, FLOAT X, FLOAT Y)
{
	Render(C, X, Y);
}

defaultproperties
{
    m_IYLabelPos=6
    m_ILabelWidth=200
    m_ILabelHeight=18
    m_TextColor=(R=51,G=51,B=51,A=255)
}