//=============================================================================
// P_1_3_3OilRig_MachiWater
//=============================================================================
class P_1_3_3OilRig_MachiWater extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\water.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Active;
var int CallGuards;


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
        if (A.name == 'EGameplayObject4')
            SoundActors[0] = A;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Active=0;
    CallGuards=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
SpewForth:
    Log("The water's a runnin'!!");
    CheckFlags(CallGuards,TRUE,'Nada');
    SetFlags(CallGuards,TRUE);
    SendPatternEvent('MachiDistractAI','Machi');
    SendUnrealEvent('MachiWater');
	SoundActors[0].PlaySound(Sound'water.Play_waterPump', SLOT_SFX);
    Log("Water is on.");
    ShakeCamera(20, 20000, 0);
    Sleep(8);
    SendUnrealEvent('MachiWaterOff');
    Sleep(2.5);
    SendUnrealEvent('MachiWater');
	SoundActors[0].PlaySound(Sound'water.Stop_waterPump', SLOT_SFX);
    Sleep(1);
    ShakeCamera(20, 20000, 1);
    Jump('Nada');
SettoFalse:
    SetFlags(Active,FALSE);
    Log("Water is off.");
Nada:
    End();
NoCall:
    Log("Initial time done, checking water state.");
    CheckFlags(Active,TRUE,'Off');
On:
    Log("Turnin it on..");
    SendUnrealEvent('MachiWater');
    Jump('CheckFlags');
Off:
    Log("Turnin it off..");
    SendUnrealEvent('MachiWaterOff');
    Sleep(3);
    SendUnrealEvent('MachiWater');
    Jump('CheckFlags');
    End();
InteractCheck:
    Log("Performs the interaction check, returning the machine state to the MachiDistract pattern.");
    CheckFlags(Active,FALSE,'Nada2');
    SendPatternEvent('MachiDistractAI','TurnItOff');
    End();
Nada2:
    Log("");
    SendPatternEvent('MachiDistractAI','MachiDefault');
    End();

}

