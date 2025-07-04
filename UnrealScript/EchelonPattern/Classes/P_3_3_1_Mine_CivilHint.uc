//=============================================================================
// P_3_3_1_Mine_CivilHint
//=============================================================================
class P_3_3_1_Mine_CivilHint extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Visit1;
var int Visit2;
var int Visit3;


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
        if(P.name == 'EAlison0')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    Visit1=0;
    Visit2=0;
    Visit3=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Visit1:
    Log("Visit1CivilHint");
    CheckFlags(Visit1,TRUE,'Visit2');
    SetFlags(Visit1,TRUE);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0002L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0003L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0004L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0005L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0006L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0007L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0008L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0009L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0010L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0011L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0012L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0013L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0014L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    AddNote("", "P_3_3_1_Mine_CivilHint", "Note_0017L", "Localization\\P_3_3_1MiningTown");
    AddNote("", "P_3_3_1_Mine_CivilHint", "Note_0024L", "Localization\\P_3_3_1MiningTown");
    Close();
    End();
Visit2:
    Log("Visit2CivilHint");
    CheckFlags(Visit2,TRUE,'Visit3');
    SetFlags(Visit2,TRUE);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0021L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    End();
Visit3:
    Log("Visit3CivilHint");
    CheckFlags(Visit3,TRUE,'Visit4');
    SetFlags(Visit3,TRUE);
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0022L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    End();
Visit4:
    Log("Visit4CivilHint");
    Speech(Localize("P_3_3_1_Mine_CivilHint", "Speech_0023L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    End();

}

defaultproperties
{
}
