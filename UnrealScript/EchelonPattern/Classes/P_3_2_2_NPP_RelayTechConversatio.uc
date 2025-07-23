//=============================================================================
// P_3_2_2_NPP_RelayTechConversatio
//=============================================================================
class P_3_2_2_NPP_RelayTechConversatio extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int One;
var int Three;
var int Two;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_GRABBED:
            EventJump('SpillIt');
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

    if( !bInit )
    {
    bInit=TRUE;
    One=0;
    Three=0;
    Two=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
SpillIt:
    Log("Interrogation dialog for Merc Tech at relay.");
    CheckIfGrabbed(1,'Go');
    End();
Go:
    Log("");
    CheckFlags(One,TRUE,'Twice');
    SetFlags(One,TRUE);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0001L", "Localization\\P_3_2_2_PowerPlant"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0002L", "Localization\\P_3_2_2_PowerPlant"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0003L", "Localization\\P_3_2_2_PowerPlant"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1.6);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0004L", "Localization\\P_3_2_2_PowerPlant"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0005L", "Localization\\P_3_2_2_PowerPlant"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(4);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0006L", "Localization\\P_3_2_2_PowerPlant"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0007L", "Localization\\P_3_2_2_PowerPlant"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1.25);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0008L", "Localization\\P_3_2_2_PowerPlant"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(6);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0009L", "Localization\\P_3_2_2_PowerPlant"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1.2);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0010L", "Localization\\P_3_2_2_PowerPlant"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1.25);
    Close();
    End();
Twice:
    Log("");
    CheckFlags(Two,TRUE,'Thrice');
    SetFlags(Two,TRUE);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0011L", "Localization\\P_3_2_2_PowerPlant"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2.5);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0012L", "Localization\\P_3_2_2_PowerPlant"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(8);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0013L", "Localization\\P_3_2_2_PowerPlant"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1.2);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0014L", "Localization\\P_3_2_2_PowerPlant"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Close();
    End();
Thrice:
    Log("");
    CheckFlags(Three,TRUE,'Foursies');
    SetFlags(Three,TRUE);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0015L", "Localization\\P_3_2_2_PowerPlant"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Close();
    End();
Foursies:
    Log("");
    SetFlags(Three,FALSE);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_2_2_NPP_RelayTechConversatio", "Speech_0016L", "Localization\\P_3_2_2_PowerPlant"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1.5);
    Close();
    End();

}

defaultproperties
{
}
