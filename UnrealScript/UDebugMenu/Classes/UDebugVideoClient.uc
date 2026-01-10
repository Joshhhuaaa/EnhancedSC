class UDebugVideoClient extends UWindowDialogClientWindow;

// Resolution
var UWindowComboControl ResolutionCombo;
var localized string ResolutionText;
var localized string ResolutionHelp;

// Brightness
var UWindowHSliderControl BrightnessSlider;
var localized string BrightnessText;
var localized string BrightnessHelp;

// Confirm message box

var UWindowMessageBox ConfirmSettings, ConfirmDriver, ConfirmWorldTextureDetail, ConfirmSkinTextureDetail;
var localized string ConfirmSettingsTitle;
var localized string ConfirmSettingsText;
var localized string ConfirmSettingsCancelTitle;
var localized string ConfirmSettingsCancelText;
var localized string ConfirmTextureDetailTitle;
var localized string ConfirmTextureDetailText;
var localized string ConfirmDriverTitle;
var localized string ConfirmDriverText;


var string OldSettings;
var bool bInitialized;
var float ControlOffset;

function Created()
{
	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos;

	Super.Created();

	ControlWidth = WinWidth / 2.5;
	ControlLeft = (WinWidth / 2 - ControlWidth) / 2;
	ControlRight = WinWidth / 2 + ControlLeft;

	CenterWidth = (WinWidth / 4) * 3;
	CenterPos = (WinWidth - CenterWidth) / 2;


	// Resolution
	ResolutionCombo = UWindowComboControl(CreateControl(class'UWindowComboControl', CenterPos, ControlOffset, CenterWidth, 1));
	ResolutionCombo.SetText(ResolutionText);
	ResolutionCombo.SetHelpText(ResolutionHelp);
	ResolutionCombo.SetFont(F_Normal);
	ResolutionCombo.SetEditable(False);
	ControlOffset += 25;

	// Brightness
	BrightnessSlider = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', CenterPos, ControlOffset, CenterWidth, 1));
	BrightnessSlider.bNoSlidingNotify = true;
	BrightnessSlider.SetRange(2, 10, 1);
	BrightnessSlider.SetText(BrightnessText);
	BrightnessSlider.SetHelpText(BrightnessHelp);
	BrightnessSlider.SetFont(F_Normal);

	LoadAvailableSettings();
}

function AfterCreate()
{
	Super.AfterCreate();

	DesiredWidth = 220;
	DesiredHeight = ControlOffset;
}

function LoadAvailableSettings()
{
	local float Brightness;
	local int P;
	local string CurrentDepth;
	local string ParseString;

	bInitialized = false;

	// Load available video drivers and current video driver here.

	ResolutionCombo.Clear();

/* - GetRes isn't working
	ParseString = GetPlayerOwner().ConsoleCommand("GetRes");
	P = InStr(ParseString, " ");
	while (P != -1)
	{
		ResolutionCombo.AddItem(Left(ParseString, P));
		ParseString = Mid(ParseString, P + 1);
		P = InStr(ParseString, " ");
	}
	ResolutionCombo.AddItem(ParseString);
	ResolutionCombo.SetValue(GetPlayerOwner().ConsoleCommand("GetCurrentRes"));
*/

	ResolutionCombo.AddItem("640x480");
	ResolutionCombo.AddItem("800x600");
	ResolutionCombo.AddItem("1024x768");
	ResolutionCombo.AddItem("1280x1024");
	ResolutionCombo.AddItem("1600x1200");
	ResolutionCombo.SetValue(GetPlayerOwner().ConsoleCommand("GetCurrentRes"));


	Brightness = int(float(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager Brightness")) * 10);
	BrightnessSlider.SetValue(Brightness);

	bInitialized = true;
}

function ResolutionChanged(float W, float H)
{
	Super.ResolutionChanged(H, H);
	if (GetPlayerOwner().ConsoleCommand("GetCurrentRes") != ResolutionCombo.GetValue())
		LoadAvailableSettings();
}

function BeforePaint(Canvas C, float X, float Y)
{
	local int ControlWidth, ControlLeft, ControlRight;
	local int CenterWidth, CenterPos;

	Super.BeforePaint(C, X, Y);

	ControlWidth = WinWidth / 2.5;
	ControlLeft = (WinWidth / 2 - ControlWidth) / 2;
	ControlRight = WinWidth / 2 + ControlLeft;

	CenterWidth = (WinWidth / 4) * 3;
	CenterPos = (WinWidth - CenterWidth) / 2;

	ResolutionCombo.SetSize(CenterWidth, 1);
	ResolutionCombo.WinLeft = CenterPos;
	ResolutionCombo.EditBoxWidth = 100;

	BrightnessSlider.SetSize(CenterWidth, 1);
	BrightnessSlider.SliderWidth = 100;
	BrightnessSlider.WinLeft = CenterPos;
}

function Notify(UWindowDialogControl C, byte E)
{
	Super.Notify(C, E);

	switch (E)
	{
	case DE_Change:
		switch (C)
		{
		case ResolutionCombo:
			SettingsChanged();
			break;
		case BrightnessSlider:
			BrightnessChanged();
			break;
		}
		break;
	}
}

function SettingsChanged()
{
	local string NewSettings;

	if (bInitialized)
	{
		OldSettings = GetPlayerOwner().ConsoleCommand("GetCurrentRes");

		NewSettings = ResolutionCombo.GetValue();

		if (NewSettings != OldSettings)
		{
			GetPlayerOwner().ConsoleCommand("SetRes "$NewSettings);
			LoadAvailableSettings();
			ConfirmSettings = MessageBox(ConfirmSettingsTitle, ConfirmSettingsText, MB_YesNo, MR_No, MR_None, 10);
		}
	}
}

function MessageBoxDone(UWindowWindow W, MessageBoxResult Result)
{
	if (W == ConfirmSettings)
	{
		ConfirmSettings = None;
		if (Result != MR_Yes)
		{
			GetPlayerOwner().ConsoleCommand("SetRes "$OldSettings);
			LoadAvailableSettings();
			MessageBox(ConfirmSettingsCancelTitle, ConfirmSettingsCancelText, MB_OK, MR_OK, MR_OK);
		}
	}
}

function BrightnessChanged()
{
	if (bInitialized)
	{
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$(BrightnessSlider.Value / 10));
		GetPlayerOwner().ConsoleCommand("Brightness "$(BrightnessSlider.Value / 10));
		GetPlayerOwner().ConsoleCommand("FLUSH");
	}
}

defaultproperties
{
    ResolutionText="Resolution"
    ResolutionHelp="Select a new screen resolution."
    BrightnessText="Brightness"
    BrightnessHelp="Adjust display brightness."
    ConfirmSettingsTitle="Confirm Video Settings Change"
    ConfirmSettingsText="Are you sure you wish to keep these new video settings?"
    ConfirmSettingsCancelTitle="Video Settings Change"
    ConfirmSettingsCancelText="Your previous video settings have been restored."
    ConfirmTextureDetailTitle="Confirm Texture Detail"
    ConfirmTextureDetailText="Increasing texture detail above its default value may degrade performance on some machines.\\n\\nAre you sure you want to make this change?"
    ConfirmDriverTitle="Change Video Driver"
    ConfirmDriverText="This option will restart Unreal now, and enable you to change your video driver.  Do you want to do this?"
    ControlOffset=20.000000
}