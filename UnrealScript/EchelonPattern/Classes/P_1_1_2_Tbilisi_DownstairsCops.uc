//=============================================================================
// P_1_1_2_Tbilisi_DownstairsCops
//=============================================================================
class P_1_1_2_Tbilisi_DownstairsCops extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int OneDown;
var int TwoDown;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('MEMCHECKDOWN');
            break;
        case AI_UNCONSCIOUS:
            EventJump('MEMCHECKDOWN');
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
        if (P.name == 'EGeorgianCop19')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    OneDown=0;
    TwoDown=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
DownAlarmSound:
    Log("The Downstairs cops respond to an alarm.");
    ChangeGroupState('s_alert');
    Goal_Default(1,GOAL_Guard,0,,'PLAYER','PLAYER','DenisDefend',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(1);
    End();
OpenArgh:
    Log("Player has opened the door to the broom closet");
    ChangeGroupState('s_alert');
    Goal_Default(1,GOAL_Guard,0,,,,'DenisDefend',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(1);
    End();
MEMCHECKDOWN:
    Log("Checking if members are dead so Alexei can be freed from his post");
    CheckFlags(OneDown,TRUE,'DoNothing');
    CheckIfIsUnconscious(1,'OneDown');
    CheckIfIsDead(1,'OneDown');
    End();
OneDown:
    Log("member one is dead or unconscious");
    SetFlags(OneDown,TRUE);
    SendPatternEvent('Basement','FreeAlex');
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

