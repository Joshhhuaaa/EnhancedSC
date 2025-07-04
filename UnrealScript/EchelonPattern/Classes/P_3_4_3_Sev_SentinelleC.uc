//=============================================================================
// P_3_4_3_Sev_SentinelleC
//=============================================================================
class P_3_4_3_Sev_SentinelleC extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('Dead');
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
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
xAttackSAMx:
    Log("Attack sam");
    Log("All Labels in this pattern have been bracketted in xs to disable them.");
    SetExclusivity(TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,8,,'PLAYER','PLAYER','RovingKillHere',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','RovingKillHere',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
xDoorOpenedx:
    Log("Door Opened");
    SetExclusivity(TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','CoverASentC',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_Attack,8,,'PLAYER','PLAYER','CoverASentC',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    End();
xDeadx:
    Log("Dead");
    SendPatternEvent('SentinelleA','StartAlarm');
    End();

}

defaultproperties
{
}
