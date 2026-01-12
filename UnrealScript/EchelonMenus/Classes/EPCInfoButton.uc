//=============================================================================
//  EPCInfoButton.uc : A small "?" button that shows info when clicked
//  Created by Joshua
//=============================================================================
class EPCInfoButton extends UWindowButton;

var string InfoText; // The description text to show
var string SettingName; // The name of the setting for the title
var string LocalizationKey; // The localization key for persistence
var Color TextColor;
var Color HoverTextColor;

// Pulsing alpha animation (will be synced)
var float PulseTimer;
var bool bPulseIncreasing;
var bool bStopPulsing; // Stop pulsing for this button only

function BeforePaint(Canvas C, float X, float Y)
{
    local EPCEnhancedConfigArea EnhancedConfigArea;
    local EPCControlsConfigArea ControlsConfigArea;
    local EPCCreatePlayerArea CreatePlayerArea;
    local EPCSoundConfigArea SoundConfigArea;

    Super.BeforePaint(C, X, Y);

    // Get parent config area to sync pulse values - try all supported types
    EnhancedConfigArea = EPCEnhancedConfigArea(ParentWindow);
    if (EnhancedConfigArea != None)
    {
        // Sync pulse values from parent
        PulseTimer = EnhancedConfigArea.InfoButtonPulseTimer;
        bPulseIncreasing = EnhancedConfigArea.bInfoButtonPulseIncreasing;
    }
    else
    {
        ControlsConfigArea = EPCControlsConfigArea(ParentWindow);
        if (ControlsConfigArea != None)
        {
            // Sync pulse values from parent
            PulseTimer = ControlsConfigArea.InfoButtonPulseTimer;
            bPulseIncreasing = ControlsConfigArea.bInfoButtonPulseIncreasing;
        }
        else
        {
            CreatePlayerArea = EPCCreatePlayerArea(ParentWindow);
            if (CreatePlayerArea != None)
            {
                // Sync pulse values from parent
                PulseTimer = CreatePlayerArea.InfoButtonPulseTimer;
                bPulseIncreasing = CreatePlayerArea.bInfoButtonPulseIncreasing;
            }
            else
            {
                SoundConfigArea = EPCSoundConfigArea(ParentWindow);
                if (SoundConfigArea != None)
                {
                    // Sync pulse values from parent
                    PulseTimer = SoundConfigArea.InfoButtonPulseTimer;
                    bPulseIncreasing = SoundConfigArea.bInfoButtonPulseIncreasing;
                }
            }
        }
    }
}

function Click(float X, float Y)
{
    local EPCEnhancedConfigArea EnhancedConfigArea;
    local EPCControlsConfigArea ControlsConfigArea;
    local EPCCreatePlayerArea CreatePlayerArea;
    local EPCSoundConfigArea SoundConfigArea;

    Super.Click(X, Y);

    if (InfoText != "")
    {
        ShowInfoMessage();
        bStopPulsing = true; // Stop pulsing for this button after showing the message

        // Mark this tooltip as viewed for persistence, try all config area types
        EnhancedConfigArea = EPCEnhancedConfigArea(ParentWindow);
        if (EnhancedConfigArea != None && LocalizationKey != "")
        {
            EnhancedConfigArea.MarkTooltipViewed(LocalizationKey);
        }
        else
        {
            ControlsConfigArea = EPCControlsConfigArea(ParentWindow);
            if (ControlsConfigArea != None && LocalizationKey != "")
            {
                ControlsConfigArea.MarkTooltipViewed(LocalizationKey);
            }
            else
            {
                CreatePlayerArea = EPCCreatePlayerArea(ParentWindow);
                if (CreatePlayerArea != None && LocalizationKey != "")
                {
                    CreatePlayerArea.MarkTooltipViewed(LocalizationKey);
                }
                else
                {
                    SoundConfigArea = EPCSoundConfigArea(ParentWindow);
                    if (SoundConfigArea != None && LocalizationKey != "")
                    {
                        SoundConfigArea.MarkTooltipViewed(LocalizationKey);
                    }
                }
            }
        }
    }
}

function ShowInfoMessage()
{
    // Get the root window and show a message box with the info text
    if (Root != None && Root.IsA('EPCMainMenuRootWindow'))
    {
        // Use the setting name as title
        EPCMainMenuRootWindow(Root).m_MessageBoxCW.CreateMessageBox(Self, SettingName, InfoText, MB_OK, MR_OK, MR_OK, false);
    }
}

function Paint(Canvas C, float X, float Y)
{
    local float W, H;
    local Color DrawColor;

    C.Style = 5; // Alpha

    if (bMouseDown || MouseIsOver())
        DrawColor = HoverTextColor;
    else
        DrawColor = TextColor;

    if (bStopPulsing)
        DrawColor.A = 255;
    else
        DrawColor.A = int(PulseTimer * 255);

    C.DrawColor = DrawColor;

    C.Font = Root.Fonts[F_Normal];

    TextSize(C, "(?)", W, H);
    ClipText(C, (WinWidth - W) / 2, (WinHeight - H) / 2, "(?)");

    C.Style = 1; // Normal
}

// Allow page scrolling when mouse is over info button
function MouseWheelDown(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;

	// Find the listbox in our owner window and pass the scroll event to it
	if (NotifyWindow != None)
	{
		W = NotifyWindow.FirstChildWindow;
		while (W != None)
		{
			if (UWindowListBox(W) != None)
			{
				W.MouseWheelDown(X, Y);
				return;
			}
			W = W.NextSiblingWindow;
		}
	}
}

// Allow page scrolling when mouse is over info button
function MouseWheelUp(FLOAT X, FLOAT Y)
{
	local UWindowWindow W;

	// Find the listbox in our owner window and pass the scroll event to it
	if (NotifyWindow != None)
	{
		W = NotifyWindow.FirstChildWindow;
		while (W != None)
		{
			if (UWindowListBox(W) != None)
			{
				W.MouseWheelUp(X, Y);
				return;
			}
			W = W.NextSiblingWindow;
		}
	}
}

defaultproperties
{
    TextColor=(R=91,G=91,B=91,A=255)
    HoverTextColor=(R=71,G=71,B=71,A=255)
    PulseTimer=1.0
    bPulseIncreasing=False
}
