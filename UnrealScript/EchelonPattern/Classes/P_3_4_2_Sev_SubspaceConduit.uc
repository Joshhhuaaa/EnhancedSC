//=============================================================================
// P_3_4_2_Sev_SubspaceConduit
//=============================================================================
class P_3_4_2_Sev_SubspaceConduit extends EPattern;

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
    Log("This is the travelling without moving data, folding space if you will.");
    AddGoal('MASSE', "", 2, "", "P_3_4_2_Sev_SubspaceConduit", "Goal_0001L", "Localization\\P_3_4_2Severonickel", "P_3_4_2_Sev_SubspaceConduit", "Goal_0002L", "Localization\\P_3_4_2Severonickel");
    AddGoal('ALARM', "", 6, "", "P_3_4_2_Sev_SubspaceConduit", "Goal_0003L", "Localization\\P_3_4_2Severonickel", "P_3_4_2_Sev_SubspaceConduit", "Goal_0004L", "Localization\\P_3_4_2Severonickel");
    GoalCompleted('ALARM');
    AddGoal('INTTECH', "", 9, "", "P_3_4_2_Sev_SubspaceConduit", "Goal_0005L", "Localization\\P_3_4_2Severonickel", "P_3_4_2_Sev_SubspaceConduit", "Goal_0006L", "Localization\\P_3_4_2Severonickel");
    GoalCompleted('INTTECH');
    End();

}

defaultproperties
{
}
