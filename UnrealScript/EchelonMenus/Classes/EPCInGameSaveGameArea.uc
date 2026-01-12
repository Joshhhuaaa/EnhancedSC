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

// Controller navigation
var int                         m_SelectedButton; // 0 = OK, 1 = Cancel
var int                         m_SaveNameIndex;  // 1-10 for Save01-Save10
var bool                        m_bControllerMode; // True if opened via controller

// Joshua - Key repeat for auto-scrolling
var int m_heldKey;                  // Currently held key code
var float m_keyHoldTime;            // Time the key has been held
var float m_nextRepeatTime;         // Time for next repeat action
var const float m_initialDelay;     // Initial delay before repeat starts (0.5s)
var const float m_repeatRate;       // Time between repeats (0.1s)

function Created()
{
    // Joshua - Must accept focus for key events to propagate to us
    SetAcceptsFocus();

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
	// Joshua - Track key releases for auto-repeat
	if (Msg == WM_KeyUp)
	{
		if (Key == m_heldKey)
		{
			m_heldKey = 0;
			m_keyHoldTime = 0;
			m_nextRepeatTime = 0;
		}
		// Check for Enter KeyUp
		if (Key == GetPlayerOwner().Player.Console.EInputKey.IK_Enter)
			EPCInGameSaveLoadArea(OwnerWindow).Notify(m_OKButton, DE_Click);
		return;
	}

	if (Msg == WM_KeyDown && Key == GetPlayerOwner().Player.Console.EInputKey.IK_Escape)
	{
		EPCInGameSaveLoadArea(OwnerWindow).Notify(m_CancelButton, DE_Click);
		EPCInGameSaveLoadArea(OwnerWindow).m_bSkipOne = true;
	}
	// Joshua - Controller keys are now handled by parent EPCInGameSaveLoadArea.HandleKeyDown
	// which forwards them to HandleControllerInput. Don't process them here to avoid double input.
	// But only block keys when controller mode is active, otherwise let them pass through to parent
	// so B button can reach EPCInGameMenu to resume the game.
	else if (Msg == WM_KeyDown && Key >= 196 && Key <= 215 && m_bControllerMode)
	{
		return;
	}
	else
		Super.WindowEvent(Msg, C, X, Y, Key);
}

function HandleControllerInput(int Key)
{
	// A=200, B=201, X=202, Y=203
	// DPadUp=212, DPadDown=213, DPadLeft=214, DPadRight=215
	// AnalogUp=196, AnalogDown=197 AnalogLeft=198, AnalogRight=199

	switch (Key)
	{
		// A button - confirm selected button
		case 200:
			Root.PlayClickSound();
			EPCInGameSaveLoadArea(OwnerWindow).m_bSkipOne = true;
			if (m_SelectedButton == 0)
				EPCInGameSaveLoadArea(OwnerWindow).Notify(m_OKButton, DE_Click);
			else
				EPCInGameSaveLoadArea(OwnerWindow).Notify(m_CancelButton, DE_Click);
			break;

		// case 201: - removed, B is handled in EPCInGameSaveLoadArea.WindowEvent

		// Left - select OK button (wrap from OK to Cancel)
		case 214: // DPadLeft
		case 198: // AnalogLeft
			Root.PlayClickSound();
			if (m_SelectedButton == 0)
				m_SelectedButton = 1; // Wrap to Cancel
			else
				m_SelectedButton = 0;
			UpdateButtonSelection();
			break;

		// Right - select Cancel button (wrap from Cancel to OK)
		case 215: // DPadRight
		case 199: // AnalogRight
			Root.PlayClickSound();
			if (m_SelectedButton == 1)
				m_SelectedButton = 0; // Wrap to OK
			else
				m_SelectedButton = 1;
			UpdateButtonSelection();
			break;

		// Up - cycle save name up
		case 212: // DPadUp
		case 196: // AnalogUp
			Root.PlayClickSound();
			CycleSaveName(-1);
			break;

		// Down - cycle save name down
		case 213: // DPadDown
		case 197: // AnalogDown
			Root.PlayClickSound();
			CycleSaveName(1);
			break;
	}
}

function CycleSaveName(int Direction)
{
	// Cycle through 1-10
	m_SaveNameIndex = m_SaveNameIndex + Direction;
	if (m_SaveNameIndex > 10)
		m_SaveNameIndex = 1;
	else if (m_SaveNameIndex < 1)
		m_SaveNameIndex = 10;

	// Update the text field with localized Save01-Save10
	m_SaveGameName.SetValue(GetSaveNameString(m_SaveNameIndex));
	m_SaveGameName.EditBox.CaretOffset = Len(m_SaveGameName.EditBox.Value);
	m_SaveGameName.EditBox.bAllSelected = true;
}


function SelectButton(int Index)
{
	m_SelectedButton = Index;
	UpdateButtonSelection();
}

// Joshua - Tick function to handle auto-repeat for held keys
function Tick(float Delta)
{
	Super.Tick(Delta);

	// No key held, nothing to repeat
	if (m_heldKey == 0)
		return;

	m_keyHoldTime += Delta;

	// Check if it's time to repeat
	if (m_keyHoldTime >= m_nextRepeatTime)
	{
		// Repeat save name cycling (up/down)
		if (m_heldKey == 212 || m_heldKey == 196 || m_heldKey == 213 || m_heldKey == 197)
		{
			HandleControllerInput(m_heldKey);
		}

		// Schedule next repeat
		m_nextRepeatTime = m_keyHoldTime + m_repeatRate;
	}
}

function UpdateButtonSelection()
{
	// Clear all first
	m_OKButton.m_bSelected = false;
	m_CancelButton.m_bSelected = false;

	// Update visual selection state
	if (m_SelectedButton == 0)
		m_OKButton.m_bSelected = true;
	else
		m_CancelButton.m_bSelected = true;
}

function String GetSaveName()
{
    return m_SaveGameName.GetValue();
}

// Get formatted save name string (Save01-Save10)
function string GetSaveNameString(int SaveNum)
{
    local string SaveText;

    SaveText = Localize("Common", "Save", "Localization\\Enhanced");

    if (SaveNum < 10)
        return SaveText $ "0" $ string(SaveNum);
    else
        return SaveText $ string(SaveNum);
}

function Clear()
{
    m_SaveGameName.Clear();
    m_bControllerMode = false;
    m_SaveNameIndex = 1;
    m_SelectedButton = 0; // Joshua - Reset to OK button when dialog closes
    // Joshua - Clear held key to prevent auto-scroll persisting
    m_heldKey = 0;
    m_keyHoldTime = 0;
    m_nextRepeatTime = 0;
}

// Call this when opening the dialog via controller to auto-fill Save01
function EnableControllerMode()
{
    m_bControllerMode = true;
    m_SaveNameIndex = 1;
    m_SaveGameName.SetValue(GetSaveNameString(m_SaveNameIndex));
    m_SaveGameName.EditBox.CaretOffset = Len(m_SaveGameName.EditBox.Value);
    m_SaveGameName.EditBox.bAllSelected = true;
    UpdateButtonSelection();
}

// Joshua - Call this when B is pressed to deactivate controller mode without closing
function DisableControllerMode()
{
    m_bControllerMode = false;
    // Clear held key to prevent auto-scroll persisting
    m_heldKey = 0;
    m_keyHoldTime = 0;
    m_nextRepeatTime = 0;
    // Clear button selections when deactivating
    m_OKButton.m_bSelected = false;
    m_CancelButton.m_bSelected = false;
}

// Joshua - Called when global controller mode changes (from EPCMainMenuRootWindow)
function OnControllerModeChanged(bool bControllerMode)
{
    local bool bWasControllerMode;

    bWasControllerMode = m_bControllerMode;
    m_bControllerMode = bControllerMode;

    if (bControllerMode && !bWasControllerMode)
    {
        // Switching TO controller mode (from mouse)
        // If the text box is empty, fill it with Save01 (but don't reset button selection)
        if (m_SaveGameName.GetValue() == "")
        {
            m_SaveNameIndex = 1;
            m_SaveGameName.SetValue(GetSaveNameString(m_SaveNameIndex));
            m_SaveGameName.EditBox.CaretOffset = Len(m_SaveGameName.EditBox.Value);
            m_SaveGameName.EditBox.bAllSelected = true;
        }
        // Do not reset m_SelectedButton here, keep the last selection
    }

    // Always update button selection to show/hide selector based on current mode
    UpdateButtonSelection();
}

// Joshua - Clear button selection bars when in mouse mode, restore when in controller mode
function BeforePaint(Canvas C, float X, float Y)
{
    Super.BeforePaint(C, X, Y);

    // In mouse mode, don't show selection bars
    if (!Root.bDisableMouseDisplay)
    {
        m_OKButton.m_bSelected = false;
        m_CancelButton.m_bSelected = false;
    }
    else
    {
        // Controller mode - only show selection if save area is activated (m_bControllerMode)
        if (m_bControllerMode)
            UpdateButtonSelection();
        else
        {
            m_OKButton.m_bSelected = false;
            m_CancelButton.m_bSelected = false;
        }
    }
}

function Paint(Canvas C, FLOAT X, FLOAT Y)
{
    Render(C, X, Y);
}

function Notify(UWindowDialogControl C, byte E)
{
    // Joshua - Update selection when mouse enters a button (hover)
    if (E == DE_MouseEnter || E == DE_Enter)
    {
        if (C == m_OKButton)
            m_SelectedButton = 0;
        else if (C == m_CancelButton)
            m_SelectedButton = 1;
    }

    EPCInGameSaveLoadArea(OwnerWindow).Notify(C, E);
}

defaultproperties
{
    // Joshua - Adjusted Y positions since save area now starts below tabs (Y=37 in parent)
    m_ITitleYPos=53
    m_ITitleXPos=122
    m_IButtonWidth=100
    m_IButtonsYPos=128
    m_IOKXPos=99
    m_ICancelXPos=229
    m_ISaveGameWidth=200
    m_ISaveGameYpos=83
    m_ITextHeight=18
    m_EditBorderColor=(R=51,G=51,B=51,A=255)
    // Joshua - Background box disabled (moved off-screen and set to 0 size), C++ hack
    m_IBGXPos=-16384
    m_IBGYPos=-16384
    m_IBGWidth=0
    m_IBGHeight=0
    m_BGTexture=Texture'UWindow.WhiteTexture'
    m_SelectedButton=0
    m_SaveNameIndex=1
    m_bControllerMode=false
    m_initialDelay=0.5
    m_repeatRate=0.1
}