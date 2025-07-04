//=============================================================================
// P_3_3_1_Mine_PowerHouseOut
//=============================================================================
class P_3_3_1_Mine_PowerHouseOut extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
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
        if(P.name == 'spetsnaz9')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz8')
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
    Log("MilestonePowerHouseOut");
    ChangeGroupState('s_alert');
    SetFlashLight(1, TRUE);
    SetFlashLight(2, TRUE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'SpKefka_0',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(1,GOAL_Patrol,8,,,,'SpKefka_0',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_MoveTo,9,,,,'AFBlackout1',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(2,GOAL_Patrol,8,,,,'AFBlackout1',,FALSE,,MOVE_Search,,MOVE_Search);
    End();
StressIfAlerted:
    Log("StressIfAlerted");
    CheckFlags(V3_3_1MiningTown(Level.VarObject).GhettoAlerted,TRUE,'EasyPatrol');
    End();
EasyPatrol:
    Log("EasyPatrol");
    ResetGoals(2);
    SetFlashLight(2, TRUE);
    ChangeState(2,'s_alert');
    Goal_Set(2,GOAL_MoveTo,9,,,,'WestSearch',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,8,,,,'WestSearch',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_1MiningTown(Level.VarObject).PowerHouseAlerted,TRUE);
    End();

}

defaultproperties
{
}
