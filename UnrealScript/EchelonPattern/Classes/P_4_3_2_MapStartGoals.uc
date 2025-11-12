//=============================================================================
// P_4_3_2_MapStartGoals
//=============================================================================
class P_4_3_2_MapStartGoals extends EPattern;

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
    Log("Set the goals, notes and recon for 4.3.2");
    AddGoal('FeirongData', "", 2, "", "P_4_3_2_MapStartGoals", "Goal_0001L", "Localization\\P_4_3_2ChineseEmbassy", "P_4_3_2_MapStartGoals", "Goal_0002L", "Localization\\P_4_3_2ChineseEmbassy");
    AddGoal('DeadFeirong', "", 6, "", "P_4_3_2_MapStartGoals", "Goal_0003L", "Localization\\P_4_3_2ChineseEmbassy", "P_4_3_2_MapStartGoals", "Goal_0004L", "Localization\\P_4_3_2ChineseEmbassy");
    AddGoal('WareHouseTrucks', "", 3, "", "P_4_3_2_MapStartGoals", "Goal_0005L", "Localization\\P_4_3_2ChineseEmbassy", "P_4_3_2_MapStartGoals", "Goal_0006L", "Localization\\P_4_3_2ChineseEmbassy");
    AddGoal('Infiltrate', "", 1, "", "P_4_3_2_MapStartGoals", "Goal_0008L", "Localization\\P_4_3_2ChineseEmbassy", "P_4_3_2_MapStartGoals", "Goal_0009L", "Localization\\P_4_3_2ChineseEmbassy");
    AddNote("", "P_4_3_2_MapStartGoals", "Note_0007L", "Localization\\P_4_3_2ChineseEmbassy");
    AddNote("", "P_4_3_2_MapStartGoals", "Note_0010L", "Localization\\P_4_3_2ChineseEmbassy");
    GoalCompleted('Infiltrate');
    GoalCompleted('FeirongData');
    End();

}

