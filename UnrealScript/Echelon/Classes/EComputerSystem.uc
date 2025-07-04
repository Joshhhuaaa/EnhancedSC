class EComputerSystem extends EGameplayObject;

var() EGameplayObject		Mouse;
var() EGameplayObject		Monitor;
var() EGameplayObject		Keyboard;
var() float					PowerSaveAfter;
var() Texture				ScreenSaver;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	if( Mouse != None )
		Mouse.SetOwner(self);

	if( Monitor != None )
		Monitor.SetOwner(self);

	if( Keyboard != None )
		Keyboard.SetOwner(self);
}

function Destructed()
{
	// Remove interaction from keyboard
	if( Keyboard != None )
		Keyboard.ResetInteraction();

	// Remove all skin reference
	WakeUp();
	// Turn off monitor
	if( Monitor != None && Monitor.IsA('EGameplayObjectLight') )
		EGameplayObjectLight(Monitor).TurnOff(CHANGE_LightTurnedOff);

	// Kill all link
	Keyboard = None;
	Monitor = None;
	Mouse = None;

	Super.Destructed();

	GotoState('s_Destructed');
}

function WakeUp()
{
	//Log("wake up");

	// Remove screen saver
	if( Monitor != None )
		Monitor.Skins.Remove(0, Monitor.Skins.Length);
}

function PowerSave()
{
	//Log("power save");

	// Activate screen saver
	if( Monitor != None )
		Monitor.Skins[1] = ScreenSaver;
}

function ReceiveMessage( EGameplayObject Sender, EGOMsgEvent Event )
{
	// If shooting monitor, wake me up
	if( Sender == Monitor && Event == GOEV_Destructed )
	{
		WakeUp();
		Monitor = None;

		// Disable interaction from keyboard
		if( Keyboard != None )
			Keyboard.ResetInteraction();
	}

	// Try to pass msg to owner
	Super.ReceiveMessage(Sender, Event);
}

state() s_Off
{
	function BeginState()
	{
		// Turn off monitor
		if( Monitor != None && Monitor.IsA('EGameplayObjectLight') )
			EGameplayObjectLight(Monitor).TurnOff(CHANGE_LightTurnedOff);

		// Disable interaction from keyboard
		if( Keyboard != None )
			Keyboard.Interaction.SetCollision(false);
	}
	function EndState()
	{
		// Turn off monitor
		if( Monitor != None && Monitor.IsA('EGameplayObjectLight') )
			EGameplayObjectLight(Monitor).TurnOn();

		// Disable interaction from keyboard
		if( Keyboard != None )
			Keyboard.Interaction.SetCollision(true);
	}

	function Trigger( Actor Other, Pawn EventInstigator, optional name InTag )
	{
		GotoState('s_Idle', 'Touch');
	}
}

state() s_InUse
{
	function Trigger( Actor Other, Pawn EventInstigator, optional name InTag )
	{
		GotoState('s_Idle', 'Touch');
	}

Begin:
	WakeUp();
}

auto state s_Idle
{
	function Trigger( Actor Other, Pawn EventInstigator, optional name InTag )
	{
		GotoState('s_InUse');
	}

	function ReceiveMessage( EGameplayObject Sender, EGOMsgEvent Event )
	{
		// If shooting mouse, wake me up
		if( Sender == Mouse && (Event == GOEV_TakeDamage || Event == GOEV_Destructed) )
			GotoState(,'Touch');

		// If interacting or shooting keyboard, wake me up
		if( Sender == Keyboard )
			GotoState(,'Touch');

		// Try to pass msg to owner
		Global.ReceiveMessage(Sender, Event);
	}

	function Timer()
	{
		PowerSave();
	}

Touch:
	WakeUp();
	SetTimer(PowerSaveAfter, false);
	Stop;

Begin:
	Timer();
}

defaultproperties
{
    PowerSaveAfter=15.000000
    ScreenSaver=EGlow'EGO_Tex.GenTexGO.GO_lcdfishGLW'
}