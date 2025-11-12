//=============================================================================
// P_1_1_1_Tbilisi_TravelGoals
//=============================================================================
class P_1_1_1_Tbilisi_TravelGoals extends EPattern;

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
    Log("these are the travelling goals, notes and recons from the first part.");
    AddGoal('STREETS', "", 10, "", "P_1_1_1_Tbilisi_TravelGoals", "Goal_0001L", "Localization\\P_1_1_1Tbilisi", "P_1_1_1_Tbilisi_TravelGoals", "Goal_0002L", "Localization\\P_1_1_1Tbilisi");
    AddGoal('CIVILS', "", 9, "", "P_1_1_1_Tbilisi_TravelGoals", "Goal_0003L", "Localization\\P_1_1_1Tbilisi", "P_1_1_1_Tbilisi_TravelGoals", "Goal_0004L", "Localization\\P_1_1_1Tbilisi");
    AddGoal('BLACKBOX', "", 7, "", "P_1_1_1_Tbilisi_TravelGoals", "Goal_0005L", "Localization\\P_1_1_1Tbilisi", "P_1_1_1_Tbilisi_TravelGoals", "Goal_0006L", "Localization\\P_1_1_1Tbilisi");
    AddGoal('CONTACT', "", 8, "", "P_1_1_1_Tbilisi_TravelGoals", "Goal_0007L", "Localization\\P_1_1_1Tbilisi", "P_1_1_1_Tbilisi_TravelGoals", "Goal_0008L", "Localization\\P_1_1_1Tbilisi");
    GoalCompleted('CONTACT');
    AddNote("", "P_1_1_1_Tbilisi_TravelGoals", "Note_0009L", "Localization\\P_1_1_1Tbilisi");
    AddRecon(class 'EReconFullTextGugen');
    AddRecon(class 'EReconFullTextMadison');
    AddRecon(class 'EReconFullTextBlaust');
    AddRecon(class 'EReconMapTibilisi');
    End();

}

