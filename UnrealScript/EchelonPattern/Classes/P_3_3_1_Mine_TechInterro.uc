//=============================================================================
// P_3_3_1_Mine_TechInterro
//=============================================================================
class P_3_3_1_Mine_TechInterro extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Visit1;
var int Visit2;
var int Visit3;
var int Visit4;


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
        if (P.name == 'EMercenaryTechnician0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Visit1=0;
    Visit2=0;
    Visit3=0;
    Visit4=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
StartConversation:
    Log("StartConversationTechInterro");
    CheckIfGrabbed(1,'Visit1');
    End();
Visit1:
    Log("Visit1TechInterro");
    CheckFlags(Visit1,TRUE,'Visit2');
    SetFlags(Visit1,TRUE);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0002L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0003L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0004L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0005L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0006L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0007L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0008L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(3);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0009L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0010L", "Localization\\P_3_3_1MiningTown"), None, 1, 1, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0012L", "Localization\\P_3_3_1MiningTown"), None, 0, 2, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    SendUnrealEvent('InvisiElevBlock');
    SetFlags(V3_3_1MiningTown(Level.VarObject).LeadTechDone,TRUE);
    SendPatternEvent('BogusStartComm','AfterInterro');
    End();
Visit2:
    Log("visit2");
    CheckFlags(Visit2,TRUE,'Visit3');
    SetFlags(Visit2,TRUE);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0014L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    End();
Visit3:
    Log("Visit3TechInterro");
    CheckFlags(Visit3,TRUE,'Visit4');
    SetFlags(Visit3,TRUE);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0015L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    End();
Visit4:
    Log("Visit4TechInterro");
    CheckFlags(Visit4,TRUE,'Visit5');
    SetFlags(Visit4,TRUE);
    Speech(Localize("P_3_3_1_Mine_TechInterro", "Speech_0016L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    End();
Visit5:
    Log("Visit5TechInterro");
addconversationsound:
    Talk(None, 1, , TRUE, 0);
    Close();
    End();

}

defaultproperties
{
}
