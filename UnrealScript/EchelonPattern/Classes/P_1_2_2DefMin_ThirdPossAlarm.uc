//=============================================================================
// P_1_2_2DefMin_ThirdPossAlarm
//=============================================================================
class P_1_2_2DefMin_ThirdPossAlarm extends EPattern;

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
        if(P.name == 'EGeorgianSoldier12')
            Characters[1] = P.controller;
        if(P.name == 'EGeorgianSoldier13')
            Characters[2] = P.controller;
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
    Log("MilestoneThirdPossAlarm");
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).AlarmSentByWindow,TRUE,'End');
    SetExclusivity(TRUE);
    ResetGroupGoals();
    ChangeGroupState('s_alert');
    Goal_Set(2,GOAL_MoveTo,9,,,,'PatrolNearNikoOff_0',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,8,,,,'ThirdAlarmPointA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Search,7,,,,,,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_MoveTo,9,,,,'BackFirstTelThree',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'ThirdAlarmPointB',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Search,7,,,,,,FALSE,,MOVE_Search,,MOVE_Search);
    Sleep(0);
    SetExclusivity(FALSE);
    End();
AlarmEndLevel:
    Log("AlarmEndLevel");
    Sleep(10);
    SetExclusivity(TRUE);
    ResetGroupGoals();
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'StratThirdA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Search,8,,,,'StratThirdA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_Search,7,,,,'UnreachableA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_Search,6,,,,'StratThirdA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_Search,5,,,,'UnreachableA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_Search,4,,,,'StratThirdA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_Search,3,,,,'UnreachableA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_Search,2,,,,'StratThirdA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_MoveTo,1,,,,'NodeInCPUroom',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(1,GOAL_Guard,0,,'EFocusPointvent','EFocusPointvent','NodeInCPUroom',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'NodeInCPUroom',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Search,8,,,,'NodeInCPUroom',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_Search,7,,,,'UnreachableC',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_Search,6,,,,'NodeInCPUroom',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_Search,5,,,,'UnreachableC',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_Search,4,,,,'NodeInCPUroom',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_Search,3,,,,'UnreachableC',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_Search,2,,,,'NodeInCPUroom',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_MoveTo,1,,,,'UnreachableB',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_Guard,0,,'InImpossibleVent','InImpossibleVent','UnreachableB',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(0);
    SetExclusivity(FALSE);
End:
    End();

}

