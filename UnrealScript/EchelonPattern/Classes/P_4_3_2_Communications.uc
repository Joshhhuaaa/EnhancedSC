//=============================================================================
// P_4_3_2_Communications
//=============================================================================
class P_4_3_2_Communications extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S4_3_Voice.uax
#exec OBJ LOAD FILE=..\Sounds\Lambert.uax

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
        if (P.name == 'EAnna2')
            Characters[2] = P.controller;
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
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
TruckFailed:
    Log("Communicator 43_32");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_4_3_2_Communications", "Speech_0001L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_32_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
TruckDestroyed:
    Log("Communicator 43_35");
    GoalCompleted('WareHouseTrucks');
    AddNote("", "P_4_3_2_Communications", "Note_0022L", "Localization\\P_4_3_2ChineseEmbassy");
    AddGoal('FeirongComputer', "", 4, "", "P_4_3_2_Communications", "Goal_0003L", "Localization\\P_4_3_2ChineseEmbassy", "P_4_3_2_Communications", "Goal_0023L", "Localization\\P_4_3_2ChineseEmbassy");
    AddGoal('FeirongDeath', "", 7, "", "P_4_3_2_Communications", "Goal_0004L", "Localization\\P_4_3_2ChineseEmbassy", "P_4_3_2_Communications", "Goal_0024L", "Localization\\P_4_3_2ChineseEmbassy");
    Speech(Localize("P_4_3_2_Communications", "Speech_0005L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_35_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_2_Communications", "Speech_0006L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_35_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_2_Communications", "Speech_0007L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_35_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
FeirongFiles:
    Log("Communicator 43_50");
    SendUnrealEvent('ProbVolFei');
    GoalCompleted('FeirongComputer');
    GoalCompleted('FeirongDeath');
    GoalCompleted('DeadFeirong');
    AddGoal('Extraction', "", 5, "", "P_4_3_2_Communications", "Goal_0008L", "Localization\\P_4_3_2ChineseEmbassy", "P_4_3_2_Communications", "Goal_0025L", "Localization\\P_4_3_2ChineseEmbassy");
    Speech(Localize("P_4_3_2_Communications", "Speech_0009L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_50_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_2_Communications", "Speech_0010L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_50_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_2_Communications", "Speech_0011L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_50_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_2_Communications", "Speech_0012L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_50_04', 2, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_2_Communications", "Speech_0013L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_2Voice.Play_43_50_05', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
KeypadFailedA:
    Log("Communicator 43_53 'Thermal Murder Failure'");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_4_3_2_Communications", "Speech_0014L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_Voice.Play_43_53_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
KeypadFailedB:
    Log("Communicator 43_12");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_4_3_2_Communications", "Speech_0015L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'S4_3_Voice.Play_43_12_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();
GenericFail:
    Log("If Sam fails something");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_4_3_2_Communications", "Speech_0026L", "Localization\\P_4_3_2ChineseEmbassy"), Sound'Lambert.Play_41_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 6);
    End();

}

