//=============================================================================
// P_1_2_2DefMin_SecondPossAlarm
//=============================================================================
class P_1_2_2DefMin_SecondPossAlarm extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Milestone');
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
        if(P.name == 'EGeorgianSoldier11')
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
Milestone:
    Log("MilestoneSecondPossibleAlarm");
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).AlarmSentByWindow,TRUE,'End');
    SetExclusivity(TRUE);
    ResetGroupGoals();
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'NodeInCPUroom',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Search,8,,,,,,FALSE,,MOVE_Search,,MOVE_Search);
    Sleep(0);
    SetExclusivity(FALSE);
    End();
AlarmEndLevel:
    Log("AlarmEndLevel");
    SetExclusivity(TRUE);
    ResetGroupGoals();
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'BackFirstTelThree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,8,,'ESlidingDoorElevLastFaaaa','ESlidingDoorElevLastFaaaa','BackFirstTelThree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(0);
    SetExclusivity(FALSE);
End:
    End();

}

