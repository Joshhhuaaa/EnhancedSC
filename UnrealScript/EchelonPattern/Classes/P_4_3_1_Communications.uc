//=============================================================================
// P_4_3_1_Communications
//=============================================================================
class P_4_3_1_Communications extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_1Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S4_3_Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Lambert.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int FirstLambertComDone;


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
        if (P.name == 'EAnna1')
            Characters[2] = P.controller;
        if (P.name == 'EAzeriColonel1')
            Characters[3] = P.controller;
        if (P.name == 'EChineseSoldier0')
            Characters[4] = P.controller;
    }

    if (!bInit)
    {
        // Joshua - Chinese Embassy 2 requires 2 bullets to shoot lights to avoid detection for Elite mode
        if (EchelonGameInfo(Level.Game).bEliteMode && EPlayerController(Characters[0]) != None && EPlayerController(Characters[0]).HandGun != None)
        {
            if (EPlayerController(Characters[0]).HandGun.Ammo == 0 && EPlayerController(Characters[0]).HandGun.ClipAmmo == 0)
            {
                if (EPlayerController(Characters[0]).playerStats.BulletFired == 0)
                {
                    // No bullets fired, give 2
                    EPlayerController(Characters[0]).HandGun.Ammo = 2;
                    EPlayerController(Characters[0]).HandGun.ClipAmmo = 2;
                }
                else if (EPlayerController(Characters[0]).playerStats.BulletFired == 1)
                {
                    // 1 bullet fired, give 1
                    EPlayerController(Characters[0]).HandGun.Ammo = 1;
                    EPlayerController(Characters[0]).HandGun.ClipAmmo = 1;
                }
            }
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    FirstLambertComDone=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
BasementDataRetrieveSuccess:
    Log("BasementDataRetrieveSuccess");
    GoalCompleted('FeirongData');
    SetFlags(V4_3_1ChineseEmbassy(Level.VarObject).BasementDataDone,TRUE);
    Speech(Localize("P_4_3_1_Communications", "Speech_0012L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_25_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_1_Communications", "Speech_0013L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_25_02', 2, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_1_Communications", "Speech_0014L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_25_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    Sleep(4);
    AddGoal('WareHouseTrucks', "", 3, "", "P_4_3_1_Communications", "Goal_0034L", "Localization\\P_4_3_1ChineseEmbassy", "P_4_3_1_Communications", "Goal_0035L", "Localization\\P_4_3_1ChineseEmbassy");
    Speech(Localize("P_4_3_1_Communications", "Speech_0015L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_28_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_1_Communications", "Speech_0016L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_28_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_1_Communications", "Speech_0017L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_28_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    Sleep(3);
    SendPatternEvent('ICommsGroup','Icomm4307');
    End();
BasementDataRetrieveFailed:
    Log("BasementDataRetrieveFailed");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(FALSE, TRUE);
    Speech(Localize("P_4_3_1_Communications", "Speech_0011L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_21_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
KeypadFailedA:
    Log("Communicator 43_53 'Thermal Murder Failure'");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_4_3_1_Communications", "Speech_0021L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_Voice.Play_43_53_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
KeypadFailedB:
    Log("Communicator 43_12");
    CheckFlags(V4_3_1ChineseEmbassy(Level.VarObject).BothKeypadADied,TRUE,'KeypadFailedA');
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_4_3_1_Communications", "Speech_0022L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_Voice.Play_43_12_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
SamWentThrough:
    End();
ThermalKeypadExplanationB:
    Log("Communicator 43_10");
    Sleep(1.50);
    AddNote("", "P_4_3_1_Communications", "Note_0024L", "Localization\\P_4_3_1ChineseEmbassy");
    GoalCompleted('Infiltrate');
    Speech(Localize("P_4_3_1_Communications", "Speech_0025L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_10_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_1_Communications", "Speech_0026L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_10_02', 2, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_1_Communications", "Speech_0027L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_10_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
ThermalKeypadExplanationC:
    Log("Communicator 43_11");
    AddNote("", "P_4_3_1_Communications", "Note_0028L", "Localization\\P_4_3_1ChineseEmbassy");
    Speech(Localize("P_4_3_1_Communications", "Speech_0029L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'S4_3_1Voice.Play_43_11_01', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
GenericFail:
    Log("Generic Fail for Sam");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(FALSE, TRUE);
    Speech(Localize("P_4_3_1_Communications", "Speech_0036L", "Localization\\P_4_3_1ChineseEmbassy"), Sound'Lambert.Play_41_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();

}

