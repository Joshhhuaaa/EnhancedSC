//=============================================================================
// P_3_3_2_Mine_ExtractionComm
//=============================================================================
class P_3_3_2_Mine_ExtractionComm extends EPattern;

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
        if (P.name == 'EAnna0')
            Characters[2] = P.controller;
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
    Log("Milestone");
    GoalCompleted('3_3_4');
    Speech(Localize("P_3_3_2_Mine_ExtractionComm", "Speech_0001L", "Localization\\P_3_3_2MiningTown"), None, 1, 0, TR_CONSOLE, 0, false);
    Sleep(1);
    Close();
    Sleep(1);
    Speech(Localize("P_3_3_2_Mine_ExtractionComm", "Speech_0002L", "Localization\\P_3_3_2MiningTown"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_2_Mine_ExtractionComm", "Speech_0008L", "Localization\\P_3_3_2MiningTown"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_2_Mine_ExtractionComm", "Speech_0003L", "Localization\\P_3_3_2MiningTown"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(2);
    Close();
    AddGoal('3_3_5', "", 10, "", "P_3_3_2_Mine_ExtractionComm", "Goal_0007L", "Localization\\P_3_3_2MiningTown", "P_3_3_2_Mine_ExtractionComm", "Goal_0012L", "Localization\\P_3_3_2MiningTown");
    SendUnrealEvent('LastDoorStanding');
    SendPatternEvent('QuarryGuys','Milestone');
    Sleep(5);
    Speech(Localize("P_3_3_2_Mine_ExtractionComm", "Speech_0009L", "Localization\\P_3_3_2MiningTown"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(3);
    Speech(Localize("P_3_3_2_Mine_ExtractionComm", "Speech_0010L", "Localization\\P_3_3_2MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_2_Mine_ExtractionComm", "Speech_0011L", "Localization\\P_3_3_2MiningTown"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(2);
    Close();
    End();

}

defaultproperties
{
}
