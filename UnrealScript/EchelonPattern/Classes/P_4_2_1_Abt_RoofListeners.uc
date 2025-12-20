//=============================================================================
// P_4_2_1_Abt_RoofListeners
//=============================================================================
class P_4_2_1_Abt_RoofListeners extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_SOMETHING:
            EventJump('HeardPlayer');
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
        if (P.name == 'EAIPawn0')
            Characters[1] = P.controller;
        if (P.name == 'EAIPawn1')
            Characters[2] = P.controller;
        if (P.name == 'EAIPawn2')
            Characters[3] = P.controller;
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
    Log("This is the pattern for the invisible NPC's listening for Sam on the roof");
HeardPlayer:
    Log("One of the NPC's heard something");
    DisableMessages(TRUE, TRUE);
    SendPatternEvent('EGroupAI18','RoofNoise');
    Sleep(2);
    DisableMessages(FALSE, FALSE);
    End();
KillListeners:
    Log("Killing the NPC's who are listening");
    KillNPC(1, FALSE, TRUE);
    KillNPC(2, FALSE, TRUE);
    KillNPC(3, FALSE, TRUE);
    SendUnrealEvent('RoofListenEnd');
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

