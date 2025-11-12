//=============================================================================
// P_3_2_1_NPP_MeltdownRoomAlarm
//=============================================================================
class P_3_2_1_NPP_MeltdownRoomAlarm extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('MeltdownRoomAlert');
            break;
        case AI_DEAD:
            EventJump('Failed');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Failed');
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
        if (P.name == 'EFalseRussianSoldier13')
            Characters[1] = P.controller;
        if (P.name == 'EFalseRussianSoldier14')
            Characters[2] = P.controller;
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
MeltdownRoomAlert:
    Log("Sam has tripped security in the cooling rod room.");
    ChangeGroupState('s_alert');
    Teleport(1, 'MeltdownAlarmTele1');
    Teleport(2, 'MeltdownAlarmTele2');
    Goal_Set(1,GOAL_MoveTo,9,,,,'midmidway',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,7,,,,'RunEnd1',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Stop,9,,,,,,FALSE,0.69,,,);
    Goal_Set(2,GOAL_MoveTo,8,,,,'Midway',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,7,,,,'RunEnd2',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveTo,'Failed');
    WaitForGoal(2,GOAL_MoveTo,'Failed');
    WaitForGoal(1,GOAL_MoveTo,'Failed');
Failed:
    Log("Wait For Goal failed, chaos ensuing.");
    SetExclusivity(FALSE);
    Goal_Default(1,GOAL_Patrol,1,,,,'Maynard_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Patrol,1,,,,'Adam_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();

}

defaultproperties
{
}
