//=============================================================================
// P_5_1_LaptopUsed
//=============================================================================
class P_5_1_LaptopUsed extends EPattern;

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
    SetFlags(V5_1_1_PresidentialPalace(Level.VarObject).LaptopAccessed,TRUE);
    GoalCompleted('5_1_1');
    AddRecon(class 'EReconFullText5_1AF_B');
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0006L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_30_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0007L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_30_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0008L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_30_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0009L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_30_04', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0010L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_30_05', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0011L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_30_06', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0012L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_30_07', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0013L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_30_08', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0014L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_30_09', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    DisableMessages(TRUE, TRUE);
    Sleep(8);
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0015L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_32_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0016L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_32_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_5_1_LaptopUsed", "Speech_0017L", "Localization\\P_5_1_1_PresidentialPalace"), Sound'S5_1_1Voice.Play_51_32_03', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    AddGoal('Retinal', "", 6, "", "P_5_1_LaptopUsed", "Goal_0003L", "Localization\\P_5_1_1_PresidentialPalace", "P_5_1_LaptopUsed", "Goal_0020L", "Localization\\P_5_1_1_PresidentialPalace");
    AddGoal('Ark', "", 7, "", "P_5_1_LaptopUsed", "Goal_0004L", "Localization\\P_5_1_1_PresidentialPalace", "P_5_1_LaptopUsed", "Goal_0021L", "Localization\\P_5_1_1_PresidentialPalace");
    AddGoal('NoKill', "", 9, "", "P_5_1_LaptopUsed", "Goal_0018L", "Localization\\P_5_1_1_PresidentialPalace", "P_5_1_LaptopUsed", "Goal_0022L", "Localization\\P_5_1_1_PresidentialPalace");
    End();

}

