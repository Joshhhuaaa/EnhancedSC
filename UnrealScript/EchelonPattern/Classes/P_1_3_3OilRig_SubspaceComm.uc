//=============================================================================
// P_1_3_3OilRig_SubspaceComm
//=============================================================================
class P_1_3_3OilRig_SubspaceComm extends EPattern;

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
    Log("This is the submap goal assigning mojo, like a space monkey forging the final frontier.");
    AddGoal('1_3_1', "", 7, "", "P_1_3_3OilRig_SubspaceComm", "Goal_0001L", "Localization\\P_1_3_3CaspianOilRefinery", "P_1_3_3OilRig_SubspaceComm", "Goal_0002L", "Localization\\P_1_3_3CaspianOilRefinery");
    AddGoal('1_3_2', "", 9, "", "P_1_3_3OilRig_SubspaceComm", "Goal_0003L", "Localization\\P_1_3_3CaspianOilRefinery", "P_1_3_3OilRig_SubspaceComm", "Goal_0004L", "Localization\\P_1_3_3CaspianOilRefinery");
    GoalCompleted('1_3_1');
    AddNote("", "P_1_3_3OilRig_SubspaceComm", "Note_0005L", "Localization\\P_1_3_3CaspianOilRefinery");
    End();

}

