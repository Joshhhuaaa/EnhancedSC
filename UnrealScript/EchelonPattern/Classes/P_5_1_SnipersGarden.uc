//=============================================================================
// P_5_1_SnipersGarden
//=============================================================================
class P_5_1_SnipersGarden extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S5_1_1Voice.uax

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
        if(P.name == 'EGeorgianPalaceGuard17')
            Characters[1] = P.controller;
        if(P.name == 'EGeorgianPalaceGuard5')
            Characters[2] = P.controller;
        if(P.name == 'EGeorgianPalaceGuard6')
            Characters[3] = P.controller;
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
    Log("MilestoneComm");
    Speech(Localize("P_5_1_SnipersGarden", "Speech_0001L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_08_01', 1, 0, TR_NPCS, 0, false);
    Sleep(0.10);
    Speech(Localize("P_5_1_SnipersGarden", "Speech_0002L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_08_02', 2, 0, TR_NPCS, 0, false);
    Sleep(0.10);
    Speech(Localize("P_5_1_SnipersGarden", "Speech_0003L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_08_03', 3, 0, TR_NPCS, 0, false);
    Sleep(0.10);
    Speech(Localize("P_5_1_SnipersGarden", "Speech_0004L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_08_04', 1, 0, TR_NPCS, 0, false);
    Sleep(0.10);
    Speech(Localize("P_5_1_SnipersGarden", "Speech_0005L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_08_05', 2, 0, TR_NPCS, 0, false);
    Sleep(0.10);
    Close();
    End();
GateOpen:
    Log("GateOpen");
    SendUnrealEvent('GateGarden');
    End();

}

