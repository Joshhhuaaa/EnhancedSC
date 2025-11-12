//=============================================================================
// P_3_3_2_Mine_TempOutro
//=============================================================================
class P_3_3_2_Mine_TempOutro extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('WilkesKO');
            break;
        case AI_UNCONSCIOUS:
            EventJump('WilkesKO');
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
        if (P.name == 'EWilkes0')
            Characters[1] = P.controller;
        if (P.name == 'ELambert1')
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
WilkesKO:
    Log("WilkesKO");
    SetProfileDeletion();
    Speech(Localize("P_3_3_2_Mine_TempOutro", "Speech_0003L", "Localization\\P_3_3_2MiningTown"), None, 3, 0, TR_HEADQUARTER, 0, false);
    Sleep(3);
    Close();
    GameOver(false, 0);
    End();

}

defaultproperties
{
}
