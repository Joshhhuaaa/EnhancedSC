//=============================================================================
// P_2_1_2_CIA_EndingP1
//=============================================================================
class P_2_1_2_CIA_EndingP1 extends EPattern;

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
LevOBJnoTravel:
    Log("LevOBJnoTravel");
    AddGoal('GoalPC', "", 5, "", "P_2_1_2_CIA_EndingP1", "Goal_0001L", "Localization\\P_2_1_2CIA", "P_2_1_2_CIA_EndingP1", "Goal_0002L", "Localization\\P_2_1_2CIA");
    AddRecon(class 'EReconMapCIA1');
    AddRecon(class 'EReconMapCIA2');
    AddGoal('GoalFatality', "", 10, "", "P_2_1_2_CIA_EndingP1", "Goal_0003L", "Localization\\P_2_1_2CIA", "P_2_1_2_CIA_EndingP1", "Goal_0004L", "Localization\\P_2_1_2CIA");
    End();

}

