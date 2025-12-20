//=============================================================================
// P_1_1_1_Tbilisi_DrunkTicker
//=============================================================================
class P_1_1_1_Tbilisi_DrunkTicker extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int AlreadyDown;
var int DrunkCounted;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('Killed');
            break;
        case AI_UNCONSCIOUS:
            EventJump('Knocked');
            break;
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'ERussianCivilian1')
        {
            Characters[1] = P.controller;
             // Joshua - Blocking this drunk to prevent an additional "intruder" stat if the cops see you
            EAIController(Characters[1]).bBlockDetection = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    AlreadyDown=0;
    DrunkCounted=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This is the pattern that kills or knocks out the drunk and determines the police repsonse");
Knocked:
    Log("The drunk is Unconscious.");
    CheckFlags(AlreadyDown,TRUE,'DoNothing');
    SetFlags(AlreadyDown,TRUE);
    ResetGoals(1);
    CheckFlags(V1_1_1Tbilisi(Level.VarObject).OKtoKODrunk,TRUE,'LiquoredUp');
    KillNPC(1, TRUE, FALSE);
    End();
LiquoredUp:
    Log("He's been knocked by the liquor");
    SendPatternEvent('CopsAndDrunk','CopsReportDrunk');
    KillNPC(1, TRUE, TRUE);
    End();
Killed:
    Log("The drunk is going down because Sam attacked him.");
    CheckFlags(AlreadyDown,TRUE,'Murder');
    SetFlags(AlreadyDown,TRUE);
    ResetGoals(1);
Murder:
    Log("The drunk is dead because of Sam, informing Lambert AI");
    CheckFlags(DrunkCounted,TRUE,'DoNothing');
    SetFlags(DrunkCounted,TRUE);
    SendPatternEvent('LambertAI','BloodyMurder');
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

