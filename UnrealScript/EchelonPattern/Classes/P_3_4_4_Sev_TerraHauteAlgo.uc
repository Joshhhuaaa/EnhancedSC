//=============================================================================
// P_3_4_4_Sev_TerraHauteAlgo
//=============================================================================
class P_3_4_4_Sev_TerraHauteAlgo extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int CanGoDefault;
var int IndoorStarted;
var int LoopingAttack;
var int OutsideStarted;
var int TunnelDone;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('MEMCHECK');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('SeeSam');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('SeeSam');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('SeeSam');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('SeeSam');
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
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
        if (P.name == 'EAnna0')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    CanGoDefault=0;
    IndoorStarted=0;
    LoopingAttack=0;
    OutsideStarted=0;
    TunnelDone=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
LambertGrimOrders:
    Log("Initial communication to begin level.");
    DisableMessages(TRUE, TRUE);
    Sleep(1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0034L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_49_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0035L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_49_02', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0036L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_49_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0037L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_49_04', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0038L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_49_05', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    DisableMessages(TRUE, FALSE);
    End();
MasseForced:
    Log("Sam talks to Grimsdottir after forcing Masse to cooperate.");
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0001L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_61_06', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0002L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_61_07', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0003L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_61_08', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0032L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_61_09', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0042L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_61_10', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0033L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_61_11', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    DisableMessages(TRUE, FALSE);
    Log("Going to the combat pattern.");
    SendUnrealEvent('TerraZoneAI');
    SendPatternEvent('TerraHauteBGroup','BeginCombat');
    End();
AttackEnds:
    Log("Lambert tells Sam about Plan B");
    Sleep(3);
    SendUnrealEvent('StopFight');
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0010L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_64_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0012L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_64_02', 2, 2, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Speech(Localize("P_3_4_4_Sev_TerraHauteAlgo", "Speech_0013L", "Localization\\P_3_4_4Severonickel"), Sound'S3_4_3Voice.Play_34_64_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    AddGoal('SERVER', "", 2, "", "P_3_4_4_Sev_TerraHauteAlgo", "Goal_0039L", "Localization\\P_3_4_4Severonickel", "P_3_4_4_Sev_TerraHauteAlgo", "Goal_0041L", "Localization\\P_3_4_4Severonickel");
    AddNote("", "P_3_4_4_Sev_TerraHauteAlgo", "Note_0040L", "Localization\\P_3_4_4Severonickel");
    LockDoor('EDoorTerreHaute', FALSE, TRUE);
    End();
DoNothing:
    Log("Do Nothing");
    End();

}

defaultproperties
{
}
