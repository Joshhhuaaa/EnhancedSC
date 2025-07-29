//=============================================================================
// P_4_1_1_CEmb_TempIntro
//=============================================================================
class P_4_1_1_CEmb_TempIntro extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_TAKE_DAMAGE:
            EventJump('DeadRinger');
            break;
        case AI_UNCONSCIOUS:
            EventJump('DeadRinger');
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
        if(P.name == 'EFrances0')
            Characters[1] = P.controller;
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
DeadRinger:
    Log("DeadRinger");
    SendPatternEvent('GameOverBogus','MissionFailed');
    End();
Teleport:
    Log("Teleport France.");
    Teleport(1, 'TeleportFrance');
    // Joshua - Lambert dialogue will begin when leaving Frances
    Speech(Localize("P_4_1_1_CEmb_Lambert1", "Speech_0003L", "Localization\\P_4_1_1ChineseEmbassy"), Sound'S4_1_1Voice.Play_41_16_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_1_CEmb_Lambert1", "Speech_0005L", "Localization\\P_4_1_1ChineseEmbassy"), Sound'S4_1_1Voice.Play_41_16_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_4_1_1_CEmb_Lambert1", "Speech_0007L", "Localization\\P_4_1_1ChineseEmbassy"), Sound'S4_1_1Voice.Play_41_16_03', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    // Joshua - Adding delay for Lambert to update OPSAT like the Shanghai version
    Sleep(3.0);
    AddNote("", "P_4_1_1_CEmb_Lambert1", "Note_0027L", "Localization\\P_4_1_1ChineseEmbassy");
    AddGoal('4_1_1', "", 1, "", "P_4_1_1_CEmb_Lambert1", "Goal_0028L", "Localization\\P_4_1_1ChineseEmbassy", "P_4_1_1_CEmb_Lambert1", "Goal_0029L", "Localization\\P_4_1_1ChineseEmbassy");
    AddGoal('4_1_2', "", 3, "", "P_4_1_1_CEmb_Lambert1", "Goal_0030L", "Localization\\P_4_1_1ChineseEmbassy", "P_4_1_1_CEmb_Lambert1", "Goal_0031L", "Localization\\P_4_1_1ChineseEmbassy");
    AddGoal('4_1_11', "", 4, "", "P_4_1_1_CEmb_Lambert1", "Goal_0032L", "Localization\\P_4_1_1ChineseEmbassy", "P_4_1_1_CEmb_Lambert1", "Goal_0033L", "Localization\\P_4_1_1ChineseEmbassy");
    Speech(Localize("P_4_1_1_CEmb_Lambert1", "Speech_0011L", "Localization\\P_4_1_1ChineseEmbassy"), Sound'S4_1_1Voice.Play_41_15_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_1_1_CEmb_Lambert1", "Speech_0017L", "Localization\\P_4_1_1ChineseEmbassy"), Sound'S4_1_1Voice.Play_41_15_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_4_1_1_CEmb_Lambert1", "Speech_0018L", "Localization\\P_4_1_1ChineseEmbassy"), Sound'S4_1_1Voice.Play_41_15_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();

}

