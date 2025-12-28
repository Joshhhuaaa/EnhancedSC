//=============================================================================
// P_3_2_2_NPP_TurretDetector
//=============================================================================
class P_3_2_2_NPP_TurretDetector extends EPattern;

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
WhatWasThatHUH:
    Log("Like oh my god, some guy like just came through the door!");
    Goal_Set(1,GOAL_Action,9,,,,,'RdioStInNt2',FALSE,1.5,,,);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_2_NPP_TurretDetector", "Speech_0001L", "Localization\\P_3_2_2_PowerPlant"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1.5);
    Close();
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,,,,);
    End();

}

defaultproperties
{
}
