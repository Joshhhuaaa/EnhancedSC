//=============================================================================
// P_5_2_LevelOBJS
//=============================================================================
class P_5_2_LevelOBJS extends EPattern;

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
MileOBJS:
    Log("MileOBJS");
    AddGoal('5_1_1', "", 10, "", "P_5_2_LevelOBJS", "Goal_0001L", "Localization\\P_5_1_2_PresidentialPalace", "P_5_2_LevelOBJS", "Goal_0002L", "Localization\\P_5_1_2_PresidentialPalace");
    GoalCompleted('5_1_1');
    AddGoal('Retinal', "", 7, "", "P_5_2_LevelOBJS", "Goal_0003L", "Localization\\P_5_1_2_PresidentialPalace", "P_5_2_LevelOBJS", "Goal_0004L", "Localization\\P_5_1_2_PresidentialPalace");
    AddGoal('Ark', "", 8, "", "P_5_2_LevelOBJS", "Goal_0005L", "Localization\\P_5_1_2_PresidentialPalace", "P_5_2_LevelOBJS", "Goal_0006L", "Localization\\P_5_1_2_PresidentialPalace");
    AddGoal('NoKill', "", 9, "", "P_5_2_LevelOBJS", "Goal_0007L", "Localization\\P_5_1_2_PresidentialPalace", "P_5_2_LevelOBJS", "Goal_0008L", "Localization\\P_5_1_2_PresidentialPalace");
    AddNote("", "P_5_2_LevelOBJS", "Note_0009L", "Localization\\P_5_1_2_PresidentialPalace");
    AddNote("", "P_5_2_LevelOBJS", "Note_0010L", "Localization\\P_5_1_2_PresidentialPalace");
    AddRecon(class 'EReconFullText5_1AF_A');
    AddRecon(class 'EReconFullText5_1AF_B');
    AddRecon(class 'EReconPicCritavi');
    End();

}

