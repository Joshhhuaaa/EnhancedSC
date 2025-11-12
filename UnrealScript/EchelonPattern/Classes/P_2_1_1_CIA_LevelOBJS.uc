//=============================================================================
// P_2_1_1_CIA_LevelOBJS
//=============================================================================
class P_2_1_1_CIA_LevelOBJS extends EPattern;

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
MilestoneObj:
    Log("MilestoneObj");
    AddGoal('GoalServer', "", 8, "", "P_2_1_1_CIA_LevelOBJS", "Goal_0001L", "Localization\\P_2_1_1CIA", "P_2_1_1_CIA_LevelOBJS", "Goal_0002L", "Localization\\P_2_1_1CIA");
    AddGoal('GoalFatality', "", 10, "", "P_2_1_1_CIA_LevelOBJS", "Goal_0003L", "Localization\\P_2_1_1CIA", "P_2_1_1_CIA_LevelOBJS", "Goal_0004L", "Localization\\P_2_1_1CIA");
    if (IsEliteMode()) // Joshua - Enhanced change: Removing the one alarm limit, player has accessed CIA central server
        AddGoal('GoalAlarm', "", 6, "", "P_2_1_1_CIA_LevelOBJS", "Goal_0005L", "Localization\\P_2_1_1CIA", "P_2_1_1_CIA_LevelOBJS", "Goal_0006L", "Localization\\P_2_1_1CIA");
    AddNote("", "P_2_1_1_CIA_LevelOBJS", "Note_0005L", "Localization\\P_2_1_1CIA");
    AddRecon(class 'EReconMapCIA1');
    End();

}

