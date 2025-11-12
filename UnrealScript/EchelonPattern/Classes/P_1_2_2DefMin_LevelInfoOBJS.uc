//=============================================================================
// P_1_2_2DefMin_LevelInfoOBJS
//=============================================================================
class P_1_2_2DefMin_LevelInfoOBJS extends EPattern;

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
MilestoneInfo:
    Log("MilestoneInfo");
    AddGoal('North', "", 4, "", "P_1_2_2DefMin_LevelInfoOBJS", "Goal_0003L", "Localization\\P_1_2_2DefenseMinistry", "P_1_2_2DefMin_LevelInfoOBJS", "Goal_0004L", "Localization\\P_1_2_2DefenseMinistry");
    AddGoal('1_2_6', "", 5, "", "P_1_2_2DefMin_LevelInfoOBJS", "Goal_0001L", "Localization\\P_1_2_2DefenseMinistry", "P_1_2_2DefMin_LevelInfoOBJS", "Goal_0002L", "Localization\\P_1_2_2DefenseMinistry");
    AddRecon(class 'EReconMapMinistry');
    AddRecon(class 'EReconPicGrinko');
    AddRecon(class 'EReconFullTextGrinko');
    AddRecon(class 'EReconPicMasse');
    AddRecon(class 'EReconFullTextMasse');
    End();

}

