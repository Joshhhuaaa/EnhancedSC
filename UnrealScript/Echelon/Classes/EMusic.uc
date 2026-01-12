class EMusic extends Actor
		native;

#exec OBJ LOAD FILE=..\Sounds\CommonMusic.uax

// Music struct
struct SMusicRequest
{
	var Actor	RequestOwner;
	var int		RequestType;
};

var int CurrentMusicType;
var Actor CurrentOwner;
var int	MaxMusicRequest;

var int CombatMusicType;  //0 - no music 1 - Combat Music 2 - Fisher Music

var bool PlayPunch;

var Sound CombatA;
var Sound CombatB;
var Sound CombatC;
var Sound CombatD;

var Sound StressA;
var Sound StressB;
var Sound StressC;
var Sound StressD;

var Sound FisherA;
var Sound FisherB;
var Sound FisherC;
var Sound FisherD;

var SMusicRequest MusicR[20];

function EvaluateRequest();

function PostBeginPlay()
{
	local int i;

	CombatMusicType = 0;

	log("---------------------- Object EMusic was spawned ------------------------------");

	for (i = 0; i < MaxMusicRequest; i++)
	{
		MusicR[i].RequestOwner=  None;
		MusicR[i].RequestType = -1;
	}

    SetTimer(5, true);
}

//--------------------------------[Matthew Clarke - August 20th 2002]-----
//
// Description
//
//------------------------------------------------------------------------
function Timer()
{
    Level.Timer();
}

function PlayMusic(Sound _S, bool Stream)
{
	if (Stream)
		PlaySound(_S, SLOT_Music);
	else
		PlaySound(_S, SLOT_Interface);
}


//---------------------------------------[Frederic Blais - 27 Feb 2002]-----
//
// Description
//
// _Type
// 0 = Stress Music
// 1 = Combat Music
//
// _bPlay
// false = stop
// true = play
//
//------------------------------------------------------------------------
function SendMusicRequest(int _Type, bool _bPlay, Actor _Instigator, optional bool DontPlayPunch)
{
	local int i;
	local int RequestType;
	local bool bInstigatorFound;

	RequestType=-1;

	//log("SendMusicRequest    Type: "$_Type$"  Play: "$_bPlay$" Instigator: "$_Instigator);
	//log(EPattern(_Instigator).Characters[1].Pawn);

	if (_Instigator == None)
		return;

	if (_bPlay)
	{
		//look if the instigator is already on a request
		for (i = 0; i < MaxMusicRequest; i++)
		{
			if (MusicR[i].RequestOwner ==  _Instigator)
			{
				bInstigatorFound = true;

				//if (MusicR[i].RequestType < _Type)
				//{
					MusicR[i].RequestType = _Type;
					RequestType = _Type;
				//}

				break;
			}
		}

		if (!bInstigatorFound)
		{
			//try to find an empty slot
			for (i = 0; i < MaxMusicRequest; i++)
			{
				if (MusicR[i].RequestOwner == None)
				{
					MusicR[i].RequestOwner = _Instigator;
					MusicR[i].RequestType = _Type;
					RequestType = _Type;

					break;
				}
			}
		}

		if (RequestType > CurrentMusicType)
		{
			CurrentOwner = _Instigator;
			CurrentMusicType = RequestType;
			PlayPunch = !DontPlayPunch;
		}


	}
	else
	{
		//look if the instigator is in our list
		for (i = 0; i < MaxMusicRequest; i++)
		{
			if (MusicR[i].RequestOwner ==  _Instigator)
			{
				if (MusicR[i].RequestType == _Type)
				{
					bInstigatorFound = true;

					MusicR[i].RequestOwner=  None;
					MusicR[i].RequestType = -1;
				}

				break;
			}
		}

		RequestType=-1;

		if (bInstigatorFound)
		{
			//check
			for (i = 0; i < MaxMusicRequest; i++)
			{
				if (RequestType < MusicR[i].RequestType)
				{
					RequestType = MusicR[i].RequestType;
				}
			}

			CurrentOwner = _Instigator;
			CurrentMusicType= RequestType;
			PlayPunch = !DontPlayPunch;
		}
	}

	//evaluate the new request
	EvaluateRequest();

}


auto state Idle
{
	function beginState()
	{
		log(" -- Music Idle -- ");
		CombatMusicType = 0;
	}

	function EvaluateRequest()
	{
		switch (CurrentMusicType)
		{
			case 0:
				if (CanPlayMusic())
				{
					//play stress intro
					if (PlayPunch && !EchelonGameInfo(Level.Game).bDisableAlertSound) // Joshua - Added option to disable alert sound
						PlayMusic(Sound'CommonMusic.Play_PunchStress', false);

					if (EPattern(CurrentOwner).Characters[1].Pawn.Region.Zone.PlayStressMusic)
					{
						PlayMusic(StressA, true);
						GotoState('StressIntro');
					}
				}
				break;
			case 1:
				if (CanPlayMusic())
				{
					//play combat intro
					if (EPattern(CurrentOwner).Characters[1].Pawn.Region.Zone.PlayFisherMusic && EGroupAI(CurrentOwner.Owner).PlayFisherMusic)
					{
						CombatMusicType = 2;
						PlayMusic(FisherA, true);
						GotoState('CombatIntro');
					}
					else
					{
						if (PlayPunch && !EchelonGameInfo(Level.Game).bDisableAlertSound) // Joshua - Added option to disable alert sound
							PlayMusic(Sound'CommonMusic.Play_PunchCombat', false);

						if (EPattern(CurrentOwner).Characters[1].Pawn.Region.Zone.PlayFightMusic)
						{
							CombatMusicType = 1;
							PlayMusic(CombatA, true);
							GotoState('CombatIntro');
						}
					}
				}
				break;
			default:
				break;
		}
	}
}

state StressIntro
{
	function beginState()
	{
		log(" -- StressIntro -- ");
	}

	function EvaluateRequest()
	{
		switch (CurrentMusicType)
		{
		case -1:
			//play end of stress intro
			if (EPattern(CurrentOwner).Characters[1].Pawn.Region.Zone.PlayStressMusic)
				PlayMusic(StressD, true);
			GotoState('Idle');
			break;
		case 1:
			//play combat loop
			if (EPattern(CurrentOwner).Characters[1].Pawn.Region.Zone.PlayFisherMusic && EGroupAI(CurrentOwner.Owner).PlayFisherMusic)
			{
				StopSound(StressA);
				//Start the new one with a delay
				CombatMusicType = 2;
				PlayMusic(FisherB, true);
				GotoState('CombatLoop');
			}
			else
			{
				if (PlayPunch && !EchelonGameInfo(Level.Game).bDisableAlertSound) // Joshua - Added option to disable alert sound
					PlayMusic(Sound'CommonMusic.Play_PunchCombat', false);

				if (EPattern(CurrentOwner).Characters[1].Pawn.Region.Zone.PlayFightMusic)
				{
					//Stop previous music with a fade
					StopSound(StressA);
					//Start the new one with a delay
					CombatMusicType = 1;
					PlayMusic(CombatB, true);
					GotoState('CombatLoop');
				}
				else
					GotoState('Idle');
			}

			break;
		default:
			break;
		}
	}

	function Tick(float DeltaTime)
	{
		if (((GetSoundDuration(StressA) - GetSoundPosition(StressA)) < 1.5f) || !IsPlaying(StressA))
		{
			PlayMusic(StressB, true);
			GotoState('StressLoop');
		}
	}

}


state StressLoop
{
	function beginState()
	{
		log(" -- StressLoop -- ");
	}

	function EvaluateRequest()
	{
		switch (CurrentMusicType)
		{
		case -1:
			//play end of stress loop
			if (EPattern(CurrentOwner).Characters[1].Pawn.Region.Zone.PlayStressMusic)
				PlayMusic(StressC, true);
			GotoState('Idle');
			break;
		case 1:
			//play transition stress-combat
			if (EPattern(CurrentOwner).Characters[1].Pawn.Region.Zone.PlayFisherMusic && EGroupAI(CurrentOwner.Owner).PlayFisherMusic)
			{
				//Stop previous music with a fade
				StopSound(StressB);
				//Start the new one with a delay
				CombatMusicType = 2;
				PlayMusic(FisherB, true);
				GotoState('CombatLoop');
			}
			else
			{
				if (PlayPunch && !EchelonGameInfo(Level.Game).bDisableAlertSound) // Joshua - Added option to disable alert sound
					PlayMusic(Sound'CommonMusic. Play_PunchCombat', false);

				if (EPattern(CurrentOwner).Characters[1].Pawn.Region.Zone.PlayFightMusic)
				{
					//Stop previous music with a fade
					StopSound(StressB);
					//Start the new one with a delay
					CombatMusicType = 1;
					PlayMusic(CombatB, true);
					GotoState('CombatLoop');
				}
				else
					GotoState('Idle');
			}

			break;
		default:
			break;
		}
	}
}


state CombatIntro
{
	function beginState()
	{
		log(" -- CombatIntro -- ");
	}

	function EvaluateRequest()
	{
		switch (CurrentMusicType)
		{
		case -1:
			//play end of combat intro
			if (CombatMusicType == 2)
				PlayMusic(FisherD, true);
			else if (CombatMusicType == 1)
				PlayMusic(CombatD, true);

			GotoState('Idle');
			break;
		case 0:
			//play stress loop
			if (EPattern(CurrentOwner).Characters[1].Pawn.Region.Zone.PlayStressMusic)
			{
				CombatMusicType = 0;
				PlaySound(StressB, SLOT_Music);
				GotoState('StressLoop');
			}
			else
				GotoState('Idle');
		default:
			break;
		}
	}

	function Tick(float DeltaTime)
	{
		if (CombatMusicType == 2)
		{
			if (((GetSoundDuration(FisherA) - GetSoundPosition(FisherA)) < 1.5f) || !IsPlaying(FisherA))
			{
				PlayMusic(FisherB, true);
				GotoState('CombatLoop');
			}
		}
		else if (CombatMusicType == 1)
		{
			if (((GetSoundDuration(CombatA) - GetSoundPosition(CombatA)) < 1.5f) || !IsPlaying(CombatA))
			{
				PlayMusic(CombatB, true);
				GotoState('CombatLoop');
			}
		}
	}
}


state CombatLoop
{
	function beginState()
	{
		log(" -- CombatLoop -- ");
	}

	function EvaluateRequest()
	{
		switch (CurrentMusicType)
		{
		case -1:
			//play end of combat loop
			if (CombatMusicType == 2)
				PlayMusic(FisherC, true);
			else if (CombatMusicType == 1)
				PlayMusic(CombatC, true);

			GotoState('Idle');
			break;
		case 0:
			//play stress loop
			if (EPattern(CurrentOwner).Characters[1].Pawn.Region.Zone.PlayStressMusic)
			{
				CombatMusicType = 0;
				PlaySound(StressB, SLOT_Music);
				GotoState('StressLoop');
			}
			else
				GotoState('Idle');
			break;
		default:
			break;
		}
	}
}

defaultproperties
{
    CurrentMusicType=-1
    MaxMusicRequest=20
    FisherA=Sound'CommonMusic.Play_theme_FisherPartA'
    FisherB=Sound'CommonMusic.Play_theme_FisherPartB'
    FisherC=Sound'CommonMusic.Play_theme_FisherPartC'
    FisherD=Sound'CommonMusic.Play_theme_FisherPartD'
    bHidden=True
}