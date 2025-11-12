//=============================================================================
// P_3_3_1_Mine_LambertStartComm
//=============================================================================
class P_3_3_1_Mine_LambertStartComm extends EPattern;

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

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'ELambert1')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("LambertStartCommunication");
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_LambertStartComm", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 1, 2, TR_HEADQUARTER, 0, false);
    Sleep(4);
    AddGoal('3_3_1', "", 7, "", "P_3_3_1_Mine_LambertStartComm", "Goal_0013L", "Localization\\P_3_3_1MiningTown", "P_3_3_1_Mine_LambertStartComm", "Goal_0021L", "Localization\\P_3_3_1MiningTown");
    AddGoal('3_3_2', "", 9, "", "P_3_3_1_Mine_LambertStartComm", "Goal_0014L", "Localization\\P_3_3_1MiningTown", "P_3_3_1_Mine_LambertStartComm", "Goal_0022L", "Localization\\P_3_3_1MiningTown");
    AddGoal('3_3_7', "", 10, "", "P_3_3_1_Mine_LambertStartComm", "Goal_0015L", "Localization\\P_3_3_1MiningTown", "P_3_3_1_Mine_LambertStartComm", "Goal_0023L", "Localization\\P_3_3_1MiningTown");
    Speech(Localize("P_3_3_1_Mine_LambertStartComm", "Speech_0018L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    SendPatternEvent('FirstGuys1','Milestone');
    End();
AfterInterro:
    Log("AfterInterro");
    Speech(Localize("P_3_3_1_Mine_LambertStartComm", "Speech_0019L", "Localization\\P_3_3_1MiningTown"), None, 1, 2, TR_CONSOLE, 0, false);
    Sleep(1);
    Close();
    GoalCompleted('3_3_3');
    GoalCompleted('3_3_7');
    AddGoal('3_3_4', "", 10, "", "P_3_3_1_Mine_LambertStartComm", "Goal_0020L", "Localization\\P_3_3_1MiningTown", "P_3_3_1_Mine_LambertStartComm", "Goal_0024L", "Localization\\P_3_3_1MiningTown");
    End();

}

defaultproperties
{
}
