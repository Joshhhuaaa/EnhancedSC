//=============================================================================
// P_3_3_2_Mine_ElevIntro
//=============================================================================
class P_3_3_2_Mine_ElevIntro extends EPattern;

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

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("MilestoneElevIntro");
    CinCamera(0, 'minetwoStartPosition', 'minetwoStartFocus',);
    Sleep(3.75);
    CinCamera(1, 'minetwoStartPosition', 'minetwoStartFocus',);
    AddGoal('3_3_1', "", 7, "", "P_3_3_2_Mine_ElevIntro", "Goal_0001L", "Localization\\P_3_3_2MiningTown", "P_3_3_2_Mine_ElevIntro", "Goal_0007L", "Localization\\P_3_3_2MiningTown");
    AddGoal('3_3_2', "", 8, "", "P_3_3_2_Mine_ElevIntro", "Goal_0002L", "Localization\\P_3_3_2MiningTown", "P_3_3_2_Mine_ElevIntro", "Goal_0008L", "Localization\\P_3_3_2MiningTown");
    AddGoal('3_3_7', "", 9, "", "P_3_3_2_Mine_ElevIntro", "Goal_0003L", "Localization\\P_3_3_2MiningTown", "P_3_3_2_Mine_ElevIntro", "Goal_0009L", "Localization\\P_3_3_2MiningTown");
    AddGoal('3_3_3', "", 6, "", "P_3_3_2_Mine_ElevIntro", "Goal_0004L", "Localization\\P_3_3_2MiningTown", "P_3_3_2_Mine_ElevIntro", "Goal_0010L", "Localization\\P_3_3_2MiningTown");
    GoalCompleted('3_3_1');
    GoalCompleted('3_3_2');
    GoalCompleted('3_3_7');
    GoalCompleted('3_3_3');
    AddGoal('3_3_4', "", 1, "", "P_3_3_2_Mine_ElevIntro", "Goal_0005L", "Localization\\P_3_3_2MiningTown", "P_3_3_2_Mine_ElevIntro", "Goal_0011L", "Localization\\P_3_3_2MiningTown");
    End();

}

defaultproperties
{
}
