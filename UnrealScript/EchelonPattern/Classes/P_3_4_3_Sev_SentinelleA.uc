//=============================================================================
// P_3_4_3_Sev_SentinelleA
//=============================================================================
class P_3_4_3_Sev_SentinelleA extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int AlreadyStarted;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('StartAlarm');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('StartProjector');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('StartAlarm');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('StartAlarm');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('StartAlarm');
            break;
        case AI_UNCONSCIOUS:
            EventJump('StartAlarm');
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
        if(P.name == 'spetsnaz4')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    AlreadyStarted=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
xStartProjectorx:
    Log("Start the search projector");
    Log("All Labels in this pattern have been bracketted in xs to disable them.");
    CheckFlags(AlreadyStarted,TRUE,'Fin');
    SetFlags(AlreadyStarted,TRUE);
    SendUnrealEvent('SearchSpotA');
xFinx:
    End();
xTakeCoverx:
    Log("Sentinelle A is taking cover");
    SetExclusivity(TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,8,,'PLAYER','PLAYER','CoverSentA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','CoverSentA',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    End();
xStartAlarmx:
    Log("Start alarm");
    CheckFlags(V3_4_3Severonickel(Level.VarObject).AlarmStarted,TRUE,'Fin');
    SetFlags(V3_4_3Severonickel(Level.VarObject).AlarmStarted,TRUE);
    SendPatternEvent('SentinelleB','AttackSam');
    SendPatternEvent('SentinelleD','AttackSam');
    Jump('StartProjector');
xDoorOpenedx:
    Log("Door Opened");
    SetExclusivity(TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','CoverSentA',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_Attack,8,,'PLAYER','PLAYER','CoverSentA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();

}

defaultproperties
{
}
