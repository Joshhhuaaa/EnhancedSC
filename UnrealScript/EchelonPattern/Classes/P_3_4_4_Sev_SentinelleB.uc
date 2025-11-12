//=============================================================================
// P_3_4_4_Sev_SentinelleB
//=============================================================================
class P_3_4_4_Sev_SentinelleB extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('AttackSam');
            break;
        case AI_DEAD:
            EventJump('Dead');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('AttackSam');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('AttackSam');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('AttackSam');
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
        if (P.name == 'spetsnaz4')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
xAttackSamx:
    Log("Attack SAM");
    Log("All Labels in this pattern have been bracketted in xs to disable them.");
    SetExclusivity(TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER','SentinelleB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
xDoorOpenedx:
    Log("Door Opened");
    CheckFlags(V3_4_4Severonickel(Level.VarObject).AlarmStarted,TRUE,'Fin');
    SetFlags(V3_4_4Severonickel(Level.VarObject).AlarmStarted,TRUE);
    SetExclusivity(TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER','SentinelleB',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    SendPatternEvent('SentinelleC','DoorOpened');
    SendPatternEvent('SentinelleA','DoorOpened');
    SendPatternEvent('SentinelleD','DoorOpened');
    Sleep(3);
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER','SentinelleB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
xFinx:
    End();
xDeadx:
    Log("Dead ");
    SendPatternEvent('SentinelleA','StartAlarm');
    End();

}

defaultproperties
{
}
