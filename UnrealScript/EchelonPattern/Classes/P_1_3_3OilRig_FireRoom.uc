//=============================================================================
// P_1_3_3OilRig_FireRoom
//=============================================================================
class P_1_3_3OilRig_FireRoom extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\FireSound.uax
#exec OBJ LOAD FILE=..\Sounds\water.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Fire1Out;
var int Fire2Out;
var int Flame2;
var int FootDoor;
var int Ignition;
var int Set;
var int Shot;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;
    local Actor A;

    Super.InitPattern();

    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'ESoundTrigger20')
            SoundActors[0] = A;
        if (A.name == 'ESoundTrigger21')
            SoundActors[1] = A;
        if (A.name == 'ESoundTrigger22')
            SoundActors[2] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Fire1Out=0;
    Fire2Out=0;
    Flame2=0;
    FootDoor=0;
    Ignition=0;
    Set=0;
    Shot=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
FlameOn:
    Log("We didn't start this fire.");
    CheckFlags(Set,FALSE,'Nada');
    CheckFlags(Ignition,TRUE,'Nada');
    SetFlags(Ignition,TRUE);
    SendPatternEvent('Merctech2AI','FireComplete');
    JumpRandom('SOne', 0.33, 'STwo', 0.67, 'SThree', 1.00, , , ,);
SOne:
    Sleep(0.1667);
    Jump('SleepDone');
STwo:
    Sleep(0.325);
    Jump('SleepDone');
SThree:
    Sleep(0.5);
SleepDone:
    SendPatternEvent('Fire2AI','FlameOn');
    ShakeCamera(1400, 13000, 3000);
    SendUnrealEvent('Fire1');
	SoundActors[0].PlaySound(Sound'FireSound.Play_BigFire2', SLOT_SFX);
	SoundActors[1].PlaySound(Sound'FireSound.Play_BigFire1', SLOT_SFX);
    SendUnrealEvent('FP1');
    SendUnrealEvent('FP2');
    SendPatternEvent('TopDudes','JerkOff');
    SendPatternEvent('escort2v2AI','JerkOff');
    SendPatternEvent('LastHurdleAI','JerkOff');
    CheckFlags(Shot,TRUE,'PutItOut');
    End();
Faucet1:
    Log("Seeing this?");
    CheckFlags(Shot,TRUE,'Nada');
    SetFlags(Shot,TRUE);
    SendUnrealEvent('SupahSpray');
	SoundActors[2].PlaySound(Sound'water.Play_waterPump', SLOT_SFX);
    CheckFlags(Ignition,TRUE,'PutItOut');
    End();
PutItOut:
    SendUnrealEvent('Smoke1');
	SoundActors[0].PlaySound(Sound'FireSound.Stop_BigFire2', SLOT_SFX);
	SoundActors[1].PlaySound(Sound'FireSound.Stop_BigFire1', SLOT_SFX);
    Sleep(3.3);
    SendUnrealEvent('Fire1');
    End();
Flame2:
    Log("");
    CheckFlags(Flame2,TRUE,'Nada');
    SetFlags(Flame2,TRUE);
    SendUnrealEvent('Fire3');
    SetFlags(Set,TRUE);
    End();
Faucet3:
    Log("");
    CheckFlags(Flame2,FALSE,'Nada');
    SendUnrealEvent('Smoke3');
    Sleep(3.3);
    SendUnrealEvent('Fire3');
    End();
Nada:
    End();
ActivateFireRoom:
    Log("Um, fire room activated.");
    SetFlags(Set,TRUE);
    End();
OpenSesame:
    Log("Magically opens the door when Sam hits this trigger, provided the chopper has exploded.");
    CheckFlags(Set,FALSE,'Nada');
    CheckFlags(FootDoor,TRUE,'Nada');
    SetFlags(FootDoor,TRUE);
    SendUnrealEvent('FP1');
    SendPatternEvent('Merctech2AI','Tease');
    End();
LeetDoor:
    Log("Door");
    CheckFlags(Ignition,FALSE,'Nada');
    SendPatternEvent('Merctech2AI','LeetDoor');
    End();

}

