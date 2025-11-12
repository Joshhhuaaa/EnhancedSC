//=============================================================================
// P_3_4_3_Sev_SniperSAM
//=============================================================================
class P_3_4_3_Sev_SniperSAM extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_3Voice.uax

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
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
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
SniperTower:
    Log("Sam intercepts a communication regarding snipers overlooking the SAM batteries.");
    Speech(Localize("P_3_4_3_Sev_SniperSAM", "Speech_0001L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_53_01', 1, 0, TR_NPCS, 0, false);
    Sleep(0.1);
    Close();
    Speech(Localize("P_3_4_3_Sev_SniperSAM", "Speech_0002L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_53_02', 1, 0, TR_NPCS, 0, false);
    Sleep(0.1);
    Close();
    Speech(Localize("P_3_4_3_Sev_SniperSAM", "Speech_0003L", "Localization\\P_3_4_3Severonickel"), Sound'S3_4_3Voice.Play_34_53_03', 1, 0, TR_NPCS, 0, false);
    Sleep(0.1);
    Close();
    SendPatternEvent('LambertAI','SabotageSAMs');
    End();

}

defaultproperties
{
}
