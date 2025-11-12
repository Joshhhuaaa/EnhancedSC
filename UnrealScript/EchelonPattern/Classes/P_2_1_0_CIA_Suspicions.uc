//=============================================================================
// P_2_1_0_CIA_Suspicions
//=============================================================================
class P_2_1_0_CIA_Suspicions extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_0Voice.uax

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
        if (P.name == 'ECIABureaucrat8')
            Characters[1] = P.controller;
        if (P.name == 'ECIASecurity2')
            Characters[2] = P.controller;
        if (P.name == 'ECIASecurity8')
            Characters[3] = P.controller;
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
start_suspicions:
    Log("Start cops profiling");
    Talk(Sound'S2_1_0Voice.Play_21_21_01', 2, , TRUE, 0);
    Close();
    Goal_Set(1,GOAL_MoveTo,9,,,,'FouilleVictim',,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,7,,'FouillePainLook','FouillePainLook','FouilleVictim',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(4);
    Goal_Set(2,GOAL_MoveTo,9,,,,'FouilleCriminal',,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(2,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Action,8,,,,'FouillePainLook','SrchStNmFd0',FALSE,,,,);
    Goal_Set(2,GOAL_Action,8,,,,'FouillePainLook','SrchStNmBk0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    ResetGoals(1);
    Goal_Default(1,GOAL_Guard,9,,'FouilleCriminal','FouilleCriminal','FouilleVictim',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S2_1_0Voice.Play_21_21_02', 1, , TRUE, 0);
    Talk(Sound'S2_1_0Voice.Play_21_21_03', 3, , TRUE, 0);
    Talk(Sound'S2_1_0Voice.Play_21_21_04', 1, , TRUE, 0);
    Talk(Sound'S2_1_0Voice.Play_21_21_05', 2, , TRUE, 0);
    Talk(Sound'S2_1_0Voice.Play_21_21_06', 1, , TRUE, 0);
    Talk(Sound'S2_1_0Voice.Play_21_21_07', 3, , TRUE, 0);
    Talk(Sound'S2_1_0Voice.Play_21_21_08', 1, , TRUE, 0);
    Talk(Sound'S2_1_0Voice.Play_21_21_09', 2, , TRUE, 0);
    Talk(Sound'S2_1_0Voice.Play_21_21_10', 1, , TRUE, 0);
    Talk(Sound'S2_1_0Voice.Play_21_21_11', 3, , TRUE, 0);
    Talk(Sound'S2_1_0Voice.Play_21_21_12', 1, , TRUE, 0);
    Close();
    End();

}

