//=============================================================================
// P_3_2_1_NPP_CameraAscension
//=============================================================================
class P_3_2_1_NPP_CameraAscension extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Spot');
            break;
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
        if (P.name == 'EFalseRussianSoldier12')
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
Spot:
    Log("Sam has been spotted by the ascension cameras.");
    SendUnrealEvent('JammerDoor');
    Speech(Localize("P_3_2_1_NPP_CameraAscension", "Speech_0001L", "Localization\\P_3_2_1_PowerPlant"), None, 1, 0, TR_NPCS, 0, false);
    Sleep(6);
    Close();
    End();
Reset:
    Log("Resets the jammer door.");
    SendUnrealEvent('JammerDoor');
    End();

}

defaultproperties
{
}
