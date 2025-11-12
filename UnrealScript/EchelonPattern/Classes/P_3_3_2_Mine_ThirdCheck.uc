//=============================================================================
// P_3_3_2_Mine_ThirdCheck
//=============================================================================
class P_3_3_2_Mine_ThirdCheck extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
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
        if (P.name == 'spetsnaz24')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz36')
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
Milestone2:
    Log("Milestone2ThirdCheck");
    ResetGroupGoals();
    ChangeGroupState('s_alert');
    SetFlashLight(1, TRUE);
    SetFlashLight(2, TRUE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'Smallelev',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_MoveTo,9,,,,'Smallelev2',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Guard,8,,'focuselevvvv',,'Smallelev2',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Guard,8,,'focuselevvvv',,'Smallelev',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
addconversationsound:
    Talk(None, 1, , TRUE, 0);
    Talk(None, 2, , TRUE, 0);
    Talk(None, 1, , TRUE, 0);
    Talk(None, 2, , TRUE, 0);
    Sleep(2);
    ResetGroupGoals();
    ChangeGroupState('s_investigate');
    SetFlashLight(1, TRUE);
    SetFlashLight(2, TRUE);
    Talk(None, 1, , TRUE, 0);
    Talk(None, 2, , TRUE, 0);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ThirdCover2',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_MoveTo,9,,,,'RockyPathsecnd1',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,'OreHiddenFocusA','OreHiddenFocusA','ThirdCover2',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Patrol,8,,,,'RockyPathsecnd1',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
CheckCargo:
    Log("CheckCargo");
    ResetGoals(1);
    ChangeState(1,'s_alert');
    SetFlashLight(1, TRUE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ElevFocusA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Guard,8,,'Incargogogo',,'ElevFocusA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    WaitForGoal(1,GOAL_MoveTo,);
    Sleep(5);
    ResetGoals(1);
    ChangeState(1,'s_default');
    SetFlashLight(1, FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ThirdCover2',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,'OreHiddenFocusA',,'ThirdCover2',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_2MiningTown(Level.VarObject).GameplayMineFirstAlerted,TRUE);
    End();

}

defaultproperties
{
}
