//=============================================================================
// P_4_3_1_MapStartGoals
//=============================================================================
class P_4_3_1_MapStartGoals extends EPattern;

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
MapStartGoals:
    Log("Update goals, notes and recon for 4.3.1");
    AddGoal('FeirongData', "", 2, "", "P_4_3_1_MapStartGoals", "Goal_0001L", "Localization\\P_4_3_1ChineseEmbassy", "P_4_3_1_MapStartGoals", "Goal_0002L", "Localization\\P_4_3_1ChineseEmbassy");
    AddGoal('DeadFeirong', "", 6, "", "P_4_3_1_MapStartGoals", "Goal_0003L", "Localization\\P_4_3_1ChineseEmbassy", "P_4_3_1_MapStartGoals", "Goal_0004L", "Localization\\P_4_3_1ChineseEmbassy");
    AddGoal('Infiltrate', "", 1, "", "P_4_3_1_MapStartGoals", "Goal_0005L", "Localization\\P_4_3_1ChineseEmbassy", "P_4_3_1_MapStartGoals", "Goal_0006L", "Localization\\P_4_3_1ChineseEmbassy");
    GoalCompleted('Infiltrate');
    End();

}

