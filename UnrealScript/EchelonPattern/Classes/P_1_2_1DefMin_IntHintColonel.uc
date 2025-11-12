//=============================================================================
// P_1_2_1DefMin_IntHintColonel
//=============================================================================
class P_1_2_1DefMin_IntHintColonel extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
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
        if (P.name == 'EGeorgianCop7')
            Characters[1] = P.controller;
        if (P.name == 'ECook2')
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
TurnOn:
    Log("TurnOn");
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).CooksAlerted,TRUE,'GoTurnOn');
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).HallwayAlerted,TRUE,'GoTurnOn');
    End();
GoTurnOn:
    Log("GoTurnOn");
    Goal_Set(1,GOAL_MoveTo,9,,,,'InConfRoom',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_InteractWith,8,,,,'LonerTurnOn',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,7,,,,'Joey_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,6,,,,'Joey_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
SpiterStart:
    Log("SpiterStart");
    ResetGoals(1);
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).CooksAlerted,TRUE,'SkipSpitConv');
    Goal_Set(1,GOAL_MoveTo,9,,,,'SpitSpot',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Guard,8,,'SpitThis','SpitThis','SpitSpot',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Patrol,1,,,,'Joey_150',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).CooksAlerted,TRUE,'SkipSpitConv');
    Talk(Sound'S1_2_1Voice.Play_12_22_01', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_22_02', 2, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_22_03', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_22_04', 2, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_22_05', 1, , FALSE, 0);
    Sleep(0.15);
    Goal_Set(1,GOAL_Action,9,,,,,'CookStNmBB0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Talk(Sound'S1_2_1Voice.Play_12_22_06', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_22_07', 2, , TRUE, 0);
    Close();
    ResetGoals(1);
SkipSpitConv:
    Log("SkipSpitConv");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'Joey_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Patrol,8,,,,'Joey_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
End:
    End();

}

