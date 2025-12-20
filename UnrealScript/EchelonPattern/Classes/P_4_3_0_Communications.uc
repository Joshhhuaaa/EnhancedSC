//=============================================================================
// P_4_3_0_Communications
//=============================================================================
class P_4_3_0_Communications extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_0Voice.uax
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
    local EVolume Volume;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
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

        // Joshua - Adjusted the EVolume on the Xbox version of the Chinese Embassy 2 map so that the player fails the mission if they fall beneath the zipline balcony
        ForEach AllActors(class'EVolume', Volume)
        {
            if (Volume.name == 'EVolume3')
            {
                Volume.SetLocation(Volume.Location + vect(-440, 0, 0));
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
LambertMapStartCom:
    Log("");
    CheckFlags(FirstLambertComDone,TRUE,'CommAlreadyDone');
    SetFlags(FirstLambertComDone,TRUE);
    AddGoal('FeirongData', "", 2, "", "P_4_3_0_Communications", "Goal_0030L", "Localization\\P_4_3_0ChineseEmbassy", "P_4_3_0_Communications", "Goal_0031L", "Localization\\P_4_3_0ChineseEmbassy");
    AddGoal('Infiltrate', "", 1, "", "P_4_3_0_Communications", "Goal_0037L", "Localization\\P_4_3_0ChineseEmbassy", "P_4_3_0_Communications", "Goal_0038L", "Localization\\P_4_3_0ChineseEmbassy");
    AddGoal('DeadFeirong', "", 6, "", "P_4_3_0_Communications", "Goal_0032L", "Localization\\P_4_3_0ChineseEmbassy", "P_4_3_0_Communications", "Goal_0033L", "Localization\\P_4_3_0ChineseEmbassy");
    Speech(Localize("P_4_3_0_Communications", "Speech_0001L", "Localization\\P_4_3_0ChineseEmbassy"), Sound'S4_3_0Voice.Play_43_05_01', 1, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_0_Communications", "Speech_0003L", "Localization\\P_4_3_0ChineseEmbassy"), Sound'S4_3_0Voice.Play_43_05_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_3_0_Communications", "Speech_0004L", "Localization\\P_4_3_0ChineseEmbassy"), Sound'S4_3_0Voice.Play_43_05_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
CommAlreadyDone:
    End();
ThermalKeypadExplanationA:
    Log("Communicator 43_09");
    Speech(Localize("P_4_3_0_Communications", "Speech_0023L", "Localization\\P_4_3_0ChineseEmbassy"), Sound'S4_3_0Voice.Play_43_09_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
GenericFail:
    Log("If Sam fails something");
    SetProfileDeletion();
    PlayerMove(false);
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_4_3_0_Communications", "Speech_0036L", "Localization\\P_4_3_0ChineseEmbassy"), Sound'Lambert.Play_41_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 0);
    End();

}

