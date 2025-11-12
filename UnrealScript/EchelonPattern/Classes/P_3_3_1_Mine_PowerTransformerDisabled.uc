//=============================================================================
// P_3_3_1_Mine_PowerTransformerDisabled
//=============================================================================
class P_3_3_1_Mine_PowerTransformerDisabled extends EPattern;

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
Milestone:
    Log("Objective1done");
    Speech(Localize("P_3_3_1_Mine_PowerTransformerDisabled", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 1, 2, TR_CONSOLE, 0, false);
    Sleep(1);
    Close();
    GoalCompleted('3_3_1');
    End();

}

defaultproperties
{
}
