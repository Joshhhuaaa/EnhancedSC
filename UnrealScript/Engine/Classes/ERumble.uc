class ERumble extends Object native;

var	float heavyRumble;
var	float heavyDuration;

var	float lightRumble;
var	float lightDuration;

var bool lightSet;
var bool heavySet;

function Shake(float Duration, float Strenth)
{
	if(heavySet)
	{
		heavyRumble = FMax(heavyRumble, FClamp(Strenth, 0.0, 1.0));
	}
	else
	{
		heavyRumble = FClamp(Strenth, 0.0, 1.0);
		heavySet = true;
	}
	heavyDuration = Duration;
}

function Vibrate(float Duration, float Strenth)
{
	if(lightSet)
	{
		lightRumble = FMax(lightRumble, FClamp(Strenth, 0.0, 1.0));
	}
	else
	{
		lightRumble = FClamp(Strenth, 0.0, 1.0);
		lightSet = true;
	}
	lightDuration = Duration;
}

function Reset()
{
	heavyRumble = 0.0;
	heavyDuration = 0.0;
	lightRumble = 0.0;
	lightDuration = 0.0;
}

// Called every frame in APlayerController::Tick
event Update(float deltaTime, out float lRumble, out float hRumble)
{
	lRumble = lightRumble;
	hRumble = heavyRumble;

	lightDuration -= deltaTime;
	if(lightDuration <= 0.0)
	{
		lightDuration = 0.0;
		lightRumble = 0.0;
	}

	heavyDuration -= deltaTime;
	if(heavyDuration <= 0.0)
	{
		heavyDuration = 0.0;
		heavyRumble = 0.0;
	}
	lightSet = false;
	heavySet = false;
}

