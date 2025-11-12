class EKeyButton extends EGameplayObject
	notplaceable;

var Vector			RelativeOffset;
var String			Value;
var StaticMesh		TextMesh;
var bool			bFading;

function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetBase(Owner);
}

function Tick(float DeltaTime)
{
	if (!bFading) 
		return;

	HeatIntensity -= DeltaTime / 5;

	if (HeatIntensity > 0) 
		return;

	HeatIntensity = 0;
	bFading = false;
}

function SetRelativeOffset(Vector Offset)
{
	RelativeOffset = Offset;
	SetRelativeLocation(RelativeOffset);
}

function Push(bool bShouldFade)
{
	HeatIntensity = 1;
	bFading = bShouldFade;

	GotoState('Pushed');
}

auto state Released
{
	function BeginState()
	{
		SetRelativeLocation(RelativeOffset);
	}
}

state Pushed
{
	function BeginState()
	{
		SetRelativeLocation(RelativeOffset + Vect(-0.22,0,0));
		SetTimer(0.2, false);
	}

	function Timer()
	{
		GotoState('Released');
	}
}

defaultproperties
{
    bDamageable=false
    bCollideActors=false
    bSideFadeEffect=false
}