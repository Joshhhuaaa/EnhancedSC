//=============================================================================
// P_2_2_2_Ktech_MapStartGoals
//=============================================================================
class P_2_2_2_Ktech_MapStartGoals extends EPattern;

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
GoalsUpdates:
    Log("Update the goals and notes for 2.2.2");
    AddGoal('FindIvan', "", 6, "", "P_2_2_2_Ktech_MapStartGoals", "Goal_0001L", "Localization\\P_2_2_2_Kalinatek", "P_2_2_2_Ktech_MapStartGoals", "Goal_0002L", "Localization\\P_2_2_2_Kalinatek");
    AddGoal('FireAlarm', "", 5, "", "P_2_2_2_Ktech_MapStartGoals", "Goal_0003L", "Localization\\P_2_2_2_Kalinatek", "P_2_2_2_Ktech_MapStartGoals", "Goal_0004L", "Localization\\P_2_2_2_Kalinatek");
    AddGoal('Hostages', "", 2, "", "P_2_2_2_Ktech_MapStartGoals", "Goal_0005L", "Localization\\P_2_2_2_Kalinatek", "P_2_2_2_Ktech_MapStartGoals", "Goal_0006L", "Localization\\P_2_2_2_Kalinatek");
    AddGoal('Infiltrate', "", 1, "", "P_2_2_2_Ktech_MapStartGoals", "Goal_0007L", "Localization\\P_2_2_2_Kalinatek", "P_2_2_2_Ktech_MapStartGoals", "Goal_0008L", "Localization\\P_2_2_2_Kalinatek");
    AddGoal('HostagesAlive', "", 10, "", "P_2_2_2_Ktech_MapStartGoals", "Goal_0009L", "Localization\\P_2_2_2_Kalinatek", "P_2_2_2_Ktech_MapStartGoals", "Goal_0010L", "Localization\\P_2_2_2_Kalinatek");
    GoalCompleted('Infiltrate');
    AddNote("", "P_2_2_2_Ktech_MapStartGoals", "Note_0011L", "Localization\\P_2_2_2_Kalinatek");
    AddRecon(class 'EReconFullTextCall911');
    AddRecon(class 'EReconMapKalinatek');
    End();

}

