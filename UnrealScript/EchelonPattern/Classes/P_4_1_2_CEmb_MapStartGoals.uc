//=============================================================================
// P_4_1_2_CEmb_MapStartGoals
//=============================================================================
class P_4_1_2_CEmb_MapStartGoals extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MapStartGoals:
    Log("Set the goals, notes and recons for 4.1.2");
    AddGoal('4_1_3', "", 1, "", "P_4_1_2_CEmb_MapStartGoals", "Goal_0001L", "Localization\\P_4_1_2ChineseEmbassy", "P_4_1_2_CEmb_MapStartGoals", "Goal_0002L", "Localization\\P_4_1_2ChineseEmbassy");
    AddGoal('4_1_1', "", 10, "", "P_4_1_2_CEmb_MapStartGoals", "Goal_0003L", "Localization\\P_4_1_2ChineseEmbassy", "P_4_1_2_CEmb_MapStartGoals", "Goal_0004L", "Localization\\P_4_1_2ChineseEmbassy");
    AddGoal('4_1_2', "", 2, "", "P_4_1_2_CEmb_MapStartGoals", "Goal_0005L", "Localization\\P_4_1_2ChineseEmbassy", "P_4_1_2_CEmb_MapStartGoals", "Goal_0006L", "Localization\\P_4_1_2ChineseEmbassy");
    AddGoal('4_1_11', "", 6, "", "P_4_1_2_CEmb_MapStartGoals", "Goal_0007L", "Localization\\P_4_1_2ChineseEmbassy", "P_4_1_2_CEmb_MapStartGoals", "Goal_0008L", "Localization\\P_4_1_2ChineseEmbassy");
    AddNote("", "P_4_1_2_CEmb_MapStartGoals", "Note_0009L", "Localization\\P_4_1_2ChineseEmbassy");
    GoalCompleted('4_1_1');
    AddRecon(class 'EReconMap4_1');
    End();

}

