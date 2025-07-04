//=============================================================================
// P_3_1_2_Ship_WilkesZodiac
//=============================================================================
class P_3_1_2_Ship_WilkesZodiac extends EPattern;

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
GetOut:
    Log("");
CineOut:
    Log("Cine of sam geting in the ofsprey");
WilkesTalk:
    Log("");
    GoalCompleted('ExtractSam');
    Speech(Localize("P_3_1_2_Ship_WilkesZodiac", "Speech_0003L", "Localization\\P_3_1_2_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Speech(Localize("P_3_1_2_Ship_WilkesZodiac", "Speech_0004L", "Localization\\P_3_1_2_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    Speech(Localize("P_3_1_2_Ship_WilkesZodiac", "Speech_0005L", "Localization\\P_3_1_2_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_2_Ship_WilkesZodiac", "Speech_0006L", "Localization\\P_3_1_2_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_2_Ship_WilkesZodiac", "Speech_0007L", "Localization\\P_3_1_2_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_2_Ship_WilkesZodiac", "Speech_0008L", "Localization\\P_3_1_2_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_2_Ship_WilkesZodiac", "Speech_0009L", "Localization\\P_3_1_2_ShipYard"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(6);
    Close();
MissCompleted:
    Log("Mission completed");
    GameOver(true, 0);
    End();

}

defaultproperties
{
}
