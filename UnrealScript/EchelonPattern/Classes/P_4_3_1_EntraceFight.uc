//=============================================================================
// P_4_3_1_EntraceFight
//=============================================================================
class P_4_3_1_EntraceFight extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int AlreadyTriggered;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('EntraceFight');
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
        if(P.name == 'EChineseSoldier17')
            Characters[1] = P.controller;
        if(P.name == 'EChineseSoldier3')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    AlreadyTriggered=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
EntraceFight:
    Log("EntraceFight");
    CheckFlags(AlreadyTriggered,TRUE,'NoTrigger');
    SetFlags(AlreadyTriggered,TRUE);
    Teleport(1, 'EntraceSoldiersBackupASpawnA');
    Teleport(2, 'EntraceSoldiersBackupASpawnB');
    ResetGroupGoals();
    Goal_Default(1,GOAL_Guard,9,,'EntraceFightPostAttackFocus',,'EntraceSquadPostAttackA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,9,,'EntraceFightPostAttackFocus',,'EntraceSquadPostAttackB',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,9,,,,'EntraceSquadPostAttackA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'EntraceSquadPostAttackB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    SetExclusivity(FALSE);
NoTrigger:
    End();

}

