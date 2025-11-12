//=============================================================================
// P_3_1_1_Ship_Bobrov
//=============================================================================
class P_3_1_1_Ship_Bobrov extends EPattern;

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
        if (P.name == 'EBobrov0')
            Characters[1] = P.controller;
        if (P.name == 'ELambert2')
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
Start:
    Log("");
loop:
    Log("");
    CheckIfIsDead(1,'GameOverMan');
    Sleep(1.5);
    Jump('loop');
Out:
    Log("");
    End();
GameOverMan:
    Log("");
    CheckFlags(V3_1_1_ShipYard(Level.VarObject).BobrovHadTalk,TRUE,'NotOver');
    SetProfileDeletion();
    SendPatternEvent('LambertComm','nothing');
    Speech(Localize("P_3_1_1_Ship_Bobrov", "Speech_0001L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(5);
    Close();
    GameOver(false, 0);
    End();
NotOver:
    Log("");
    Speech(Localize("P_3_1_1_Ship_Bobrov", "Speech_0002L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Speech(Localize("P_3_1_1_Ship_Bobrov", "Speech_0003L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_Bobrov", "Speech_0004L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(1);
    Speech(Localize("P_3_1_1_Ship_Bobrov", "Speech_0005L", "Localization\\P_3_1_1_ShipYard"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_1_1_Ship_Bobrov", "Speech_0006L", "Localization\\P_3_1_1_ShipYard"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(7);
    Close();
    End();

}

defaultproperties
{
}
