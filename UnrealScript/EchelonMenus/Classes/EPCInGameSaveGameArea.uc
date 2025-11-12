class EPCInGameSaveGameArea extends EPCMenuPage
		native;

var UWindowLabelControl         m_TitleLabel;
var INT                         m_ITitleYPos, m_ITitleXPos;

var EPCTextButton               m_OKButton, m_CancelButton;
var INT                         m_IButtonWidth, m_IButtonsYPos, m_IOKXPos, m_ICancelXPos;


var EPCEditControl              m_SaveGameName;
var INT                         m_ISaveGameWidth, m_ISaveGameYpos;

var INT                         m_ITextHeight;

var Color                       m_EditBorderColor;

var INT                         m_IBGXPos, m_IBGYPos, m_IBGWidth, m_IBGHeight;
var Texture                     m_BGTexture;

function Created()
{
    m_TitleLabel = UWindowLabelControl(CreateWindow(class'UWindowLabelControl', m_ITitleXPos, m_ITitleYPos, m_ISaveGameWidth, m_ITextHeight, self));
    m_TitleLabel.SetLabelText(Localize("HUD","SAVE","Localization\\HUD"),TXT_CENTER);
    m_TitleLabel.Font        = F_Normal;
    m_TitleLabel.TextColor   = m_EditBorderColor;
		
    m_SaveGameName       = EPCEditControl(CreateWindow(class'EPCEditControl', m_ITitleXPos, m_ISaveGameYpos, m_ISaveGameWidth, m_ITextHeight, self));
    m_SaveGameName.SetBorderColor(m_EditBorderColor);
    m_SaveGameName.SetEditTextColor(m_EditBorderColor);
    m_SaveGameName.SetMaxLength(15);
    
    m_OKButton          = EPCTextButton(CreateControl(class'EPCTextButton', m_IOKXPos, m_IButtonsYPos, m_IButtonWidth, m_ITextHeight, self));
    m_CancelButton      = EPCTextButton(CreateControl(class'EPCTextButton', m_ICancelXPos, m_IButtonsYPos, m_IButtonWidth, m_ITextHeight, self));    
    m_OKButton.SetButtonText(Caps(Localize("MESSAGEBOX","OK","Localization\\HUD")),TXT_CENTER);
    m_CancelButton.SetButtonText(Caps(Localize("MESSAGEBOX","CANCEL","Localization\\HUD")),TXT_CENTER);

}

function WindowEvent(WinMessage Msg, Canvas C, float X, float Y, int Key) 
{
	// Check for Enter KeyUp
	if (Msg == WM_KeyUp && Key == GetPlayerOwner().Player.Console.EInputKey.IK_Enter)
		EPCInGameSaveLoadArea(OwnerWindow).Notify(m_OKButton, DE_Click);
	else if (Msg == WM_KeyDown && Key == GetPlayerOwner().Player.Console.EInputKey.IK_Escape)
	{
		EPCInGameSaveLoadArea(OwnerWindow).Notify(m_CancelButton, DE_Click);
		EPCInGameSaveLoadArea(OwnerWindow).m_bSkipOne = true;
	}
	else
		Super.WindowEvent(Msg, C, X, Y, Key);
}

function String GetSaveName()
{
    return m_SaveGameName.GetValue();
}

function Clear()
{
    m_SaveGameName.Clear();
}
    
function Paint(Canvas C, FLOAT X, FLOAT Y)
{   
    Render(C, X, Y);
}

function Notify(UWindowDialogControl C, byte E)
{
    EPCInGameSaveLoadArea(OwnerWindow).Notify(C, E);	    
}

defaultproperties
{
    m_ITitleYPos=90
    m_ITitleXPos=122
    m_IButtonWidth=100
    m_IButtonsYPos=165
    m_IOKXPos=99
    m_ICancelXPos=229
    m_ISaveGameWidth=200
    m_ISaveGameYpos=120
    m_ITextHeight=18
    m_EditBorderColor=(R=51,G=51,B=51,A=255)
    m_IBGXPos=160
    m_IBGYPos=160
    m_IBGWidth=375
    m_IBGHeight=140
    m_BGTexture=Texture'UWindow.WhiteTexture'
}