//=============================================================================
// P_3_3_1_Mine_WilkesIn
//=============================================================================
class P_3_3_1_Mine_WilkesIn extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int PreVisit;
var int Visit1;
var int Visit2;
var int Visit3;
var int Visit5;
var int Visit6;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('Death');
            break;
        case AI_UNCONSCIOUS:
            EventJump('Death');
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
        if(P.name == 'EWilkes0')
            Characters[1] = P.controller;
        if(P.name == 'ELambert1')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    PreVisit=0;
    Visit1=0;
    Visit2=0;
    Visit3=0;
    Visit5=0;
    Visit6=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("MilestoneWilkesIn");
    CheckFlags(PreVisit,TRUE,'Visit1');
    SetFlags(PreVisit,TRUE);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0002L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0003L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0004L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0011L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0012L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0013L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(1);
    Close();
    End();
Visit1:
    Log("Visit1");
    CheckFlags(Visit1,TRUE,'Visit2');
    SetFlags(Visit1,TRUE);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0014L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0015L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0016L", "Localization\\P_3_3_1MiningTown"), None, 0, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0017L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Close();
    End();
Visit2:
    Log("Visit2WilkesIn");
    CheckFlags(Visit2,TRUE,'Visit3');
    SetFlags(Visit2,TRUE);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0005L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Close();
    End();
Visit3:
    Log("Visit3WilkesIn");
    CheckFlags(Visit3,TRUE,'Visit5');
    SetFlags(Visit3,TRUE);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0006L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Close();
    End();
Visit5:
    Log("Visit5WilkesIn");
    CheckFlags(Visit5,TRUE,'Visit6');
    SetFlags(Visit5,TRUE);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0008L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Close();
    End();
Visit6:
    Log("Visit6WilkesIn");
    CheckFlags(Visit6,TRUE,'End');
    SetFlags(Visit6,TRUE);
    Speech(Localize("P_3_3_1_Mine_WilkesIn", "Speech_0009L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_CONVERSATION, 0, false);
    Sleep(2);
    Close();
End:
    End();

}

defaultproperties
{
}
