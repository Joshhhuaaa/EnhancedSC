//=============================================================================
// P_3_3_2_Mine_WilkesOut
//=============================================================================
class P_3_3_2_Mine_WilkesOut extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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
        if(P.name == 'EWilkes0')
            Characters[1] = P.controller;
    }

    if( !bInit )
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
    Speech(Localize("P_3_3_2_Mine_WilkesOut", "Speech_0001L", "Localization\\P_3_3_2MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_2_Mine_WilkesOut", "Speech_0002L", "Localization\\P_3_3_2MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    GameOver(true, 0);
    End();

}

defaultproperties
{
}
