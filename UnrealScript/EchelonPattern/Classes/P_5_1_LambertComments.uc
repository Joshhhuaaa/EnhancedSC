//=============================================================================
// P_5_1_LambertComments
//=============================================================================
class P_5_1_LambertComments extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S5_1_1Voice.uax

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
        if (P.name == 'EGeorgianPalaceGuard7')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
        }
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
Milestone:
    Log("Milestone");
    DisableMessages(TRUE, TRUE);
    SendPatternEvent('Lounge','PatrolNow');
    Sleep(1.25);
    Speech(Localize("P_5_1_LambertComments", "Speech_0001L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_10_01', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_5_1_LambertComments", "Speech_0002L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_10_02', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_5_1_LambertComments", "Speech_0003L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_10_03', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_5_1_LambertComments", "Speech_0004L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_10_04', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    SendPatternEvent('Lounge','Milestone'); // Joshua - Begin guard dialogue instead of using EEventTrigger5
End:
    End();

}

