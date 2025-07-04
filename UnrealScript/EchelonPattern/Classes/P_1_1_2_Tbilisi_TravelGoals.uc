//=============================================================================
// P_1_1_2_Tbilisi_TravelGoals
//=============================================================================
class P_1_1_2_Tbilisi_TravelGoals extends EPattern;

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
    Log("These are the travelling goals and notes from parts 110 and 111");
    AddNote("", "P_1_1_2_Tbilisi_TravelGoals", "Note_0001L", "Localization\\P_1_1_2Tbilisi");
    AddGoal('STREETS', "", 10, "", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0002L", "Localization\\P_1_1_2Tbilisi", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0003L", "Localization\\P_1_1_2Tbilisi");
    AddGoal('CIVIL', "", 9, "", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0004L", "Localization\\P_1_1_2Tbilisi", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0005L", "Localization\\P_1_1_2Tbilisi");
    AddGoal('CONTACT', "", 8, "", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0006L", "Localization\\P_1_1_2Tbilisi", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0007L", "Localization\\P_1_1_2Tbilisi");
    AddGoal('BLACKBOX', "", 7, "", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0008L", "Localization\\P_1_1_2Tbilisi", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0009L", "Localization\\P_1_1_2Tbilisi");
    AddGoal('DEADDROP', "", 6, "", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0012L", "Localization\\P_1_1_2Tbilisi", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0013L", "Localization\\P_1_1_2Tbilisi");
    AddGoal('PRECINCT', "", 5, "", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0014L", "Localization\\P_1_1_2Tbilisi", "P_1_1_2_Tbilisi_TravelGoals", "Goal_0015L", "Localization\\P_1_1_2Tbilisi");
    GoalCompleted('STREETS');
    GoalCompleted('CONTACT');
    GoalCompleted('BLACKBOX');
    GoalCompleted('DEADDROP');
    AddRecon(class 'EReconFullTextMadison');
    AddRecon(class 'EReconFullTextBlaust');
    AddRecon(class 'EReconFullTextGugen');
    AddRecon(class 'EReconMapTibilisi');
    End();

}

