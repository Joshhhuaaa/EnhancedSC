//=============================================================================
// P_5_1_IntroCall
//=============================================================================
class P_5_1_IntroCall extends EPattern;

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
    Sleep(2);
    Speech(Localize("P_5_1_IntroCall", "Speech_0001L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_05_01', 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('5_1_1', "", 10, "", "P_5_1_IntroCall", "Goal_0011L", "Localization\\P_5_1_1_PresidentialPalace", "P_5_1_IntroCall", "Goal_0012L", "Localization\\P_5_1_1_PresidentialPalace");
    Speech(Localize("P_5_1_IntroCall", "Speech_0006L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_05_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_5_1_IntroCall", "Speech_0007L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_05_03', 1, 1, TR_HEADQUARTER, 0, false);
    AddNote("", "P_5_1_IntroCall", "Note_0013L", "Localization\\P_5_1_1_PresidentialPalace");
    AddRecon(class 'EReconPicCritavi');
    AddRecon(class 'EReconFullText5_1AF_A');
    Close();
    End();

}

