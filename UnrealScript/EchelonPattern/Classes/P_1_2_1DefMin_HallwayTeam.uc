//=============================================================================
// P_1_2_1DefMin_HallwayTeam
//=============================================================================
class P_1_2_1DefMin_HallwayTeam extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
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
        if(P.name == 'EGeorgianCop0')
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
    Log("Milestone");
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).FirstNPCAlerted,FALSE,'End');
    ChangeGroupState('s_investigate');
    Goal_Set(1,GOAL_MoveTo,9,,,,'FirstPatrolCarpet_300',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Patrol,8,,,,'FirstPatrolCarpet_300',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
ToCar:
    Log("ToCar");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'MilestoneTelStairRush',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_MoveTo,8,,,,'ToTelEndOne',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,7,,,,'ScriptToGateTwo_500',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,6,,,,'PathNodeGuardParkingA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,5,,'PissFocuss','PissFocuss','PathNodeGuardParkingA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).HallwayAlerted,TRUE);
End:
    End();

}

