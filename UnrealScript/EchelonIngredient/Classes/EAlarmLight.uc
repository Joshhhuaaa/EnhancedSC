class EAlarmLight extends EGameplayObject;

var()	Sound	AlertSound;		// Sound it produces in alarm mode

#exec OBJ LOAD FILE=..\StaticMeshes\LightGenOBJ.usx

function PostBeginPlay()
{
	Super.PostBeginPlay();

	Skins[1] = Material'LightGenTex.LightGen.red_glow'; // Joshua - Fixing an issue where alarm lights always appeared lit when inactive
	LightType = LT_None;
}

//------------------------------------------------------------------------
// Description		
//		Valid from EAlarm only
//------------------------------------------------------------------------
event Trigger( Actor Other, Pawn EventInstigator, optional name InTag )
{
	//log(self@"IM TRIGGERED");

	// Special case where we only want to trigger the light to be blinking not from an Alarm
	if( EPattern(Other) != None )
	{
		GotoState('s_Alert');
		return;
	}

	if( Other != Alarm )
		return;

	//log(alarm@alarm.event);

	Switch( Alarm.Event )
	{
	case AE_ENABLE_ALARM : 
		if( GetStateName() != 's_Alert' )
			GotoState('s_Alert');
		else
			BeginState();
		break;

	case AE_DISABLE_ALARM :
		GotoState('');
		break;
	}
}

state s_Alert
{
	function BeginState()
	{
		LightType = default.LightType;
		LastTimeChange	= Level.TimeSeconds;

		Skins[1] = None; // Joshua - Removing the skin so the light appears lit

		bGlowDisplay = true;

		Timer();
		SetTimer(GetSoundDuration(AlertSound)+0.5, true);
	}

	function EndState()
	{
		LightType = LT_None;
		LastTimeChange	= Level.TimeSeconds;

		Skins[1] = Material'LightGenTex.LightGen.red_glow'; // Joshua - Restoring the skin so the light turns off

		bGlowDisplay = false;

		LightBrightness = default.LightBrightness;
		HeatIntensity	= 0;
	}

	function Timer()
	{
		// Blast light
		Enable('Tick');
		
		LightBrightness = 255;
		HeatIntensity	= 1;
		LastTimeChange	= Level.TimeSeconds;

        if(!((EchelonLevelInfo(Level)).bIgnoreAlarmStage))
        {
		    PlaySound(AlertSound, SLOT_Ambient);
        }
	}

	function Tick( float DeltaTime )
	{
		local int b;
		b = LightBrightness - 128 * DeltaTime;

		if( b >= default.LightBrightness )
			LightBrightness = b;
		else
		{
			LightBrightness = default.LightBrightness;
			Disable('Tick');
		}

		HeatIntensity	= float(LightBrightness)/255;
		LastTimeChange	= Level.TimeSeconds;
	}
}

defaultproperties
{
    AlertSound=Sound'Electronic.Play_AlarmSeveronickel'
    bDamageable=false
    AlarmLinkType=EAlarm_Object
    StaticMesh=StaticMesh'LightGenOBJ.UnbreakableLight.LIG_Alarm_red'
    SoundRadiusSaturation=1000.000000
    LightType=LT_Steady
    LightEffect=LE_EOmniAtten // Joshua - Restoring Xbox light effect, PC originally just used LE_None
    bGlowDisplay=false
    MaxDistance=250.000000
    bAffectOwnZoneOnly=true
}