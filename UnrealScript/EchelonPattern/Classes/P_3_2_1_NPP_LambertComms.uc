//=============================================================================
// P_3_2_1_NPP_LambertComms
//=============================================================================
class P_3_2_1_NPP_LambertComms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Code;
var int Molestered;


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
    local EPawn EP;
    local Actor A;
    local EGameplayObject EGO;
    //local EAlarm Alarm;
    //local int i;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
        if (P.Name == 'EPowerPlantEmployee14') // Joshua - Killing conflicting NPC
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bNotInStats = true;
        }
        if (P.Name == 'ECIABureaucratF0')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bNotInStats = true;
        }
    }

    if (!bInit)
    {
        
        ForEach DynamicActors(class'EGameplayObject', EGO)
        {
            // Joshua - Disposable pick was assigned the incorrect mesh
            if (EGO.name == 'EDisposablePick0')
            {
                EGO.SetStaticMesh(StaticMesh'EMeshIngredient.Item.DisposablePick');
                EGO.SetLocation(EGO.Location + vect(0, 0, -22));
            }

            // Joshua - EGameplayObjectLight missing ObjectLight
            if (EGO.name == 'ELgt2Flurescent0')
            {
                EGO.ObjectLights[2] = ELight(DynamicLoadObject("3_2_1_PowerPlant.ELight51", class'ELight'));
            }

            // Joshua - EGameplayObjectLight missing ObjectLight
            if (EGO.name == 'ELgt2Flurescent2')
            {
                EGO.ObjectLights[2] = ELight(DynamicLoadObject("3_2_1_PowerPlant.ELight45", class'ELight'));
            }

            // Joshua - Keypad sliding door glass should not be destructible
            if (EGO.name == 'EGameplayObject20' || EGO.name == 'EGameplayObject21')
                EGO.bDamageable = false;

            // Joshua - Lowered ceiling camera that was sticking in the ceiling
            if (EGO.name == 'ECeilingCamera0')
            {
                EGO.SetLocation(EGO.Location + vect(0, 0, -14.5));
            }
        }

        // Joshua - Disabling collision on these two vent frames as it was preventing the player from progressing
        ForEach AllActors(class'Actor', A)
        {
            if (A.name == 'StaticMeshActor706')
                A.SetCollision(false);

            if (A.name == 'StaticMeshActor821')
                A.SetCollision(false);
        }

        // Joshua - Removing EGroupAI20 from the PrimaryGroups (killing the NPC instead for now)
        /*ForEach AllActors(class'EAlarm', Alarm)
        {
            if (Alarm.name == 'EAlarm5')
            {
                for (i = 0; i < Alarm.PrimaryGroups.Length; i++)
                {
                    if (Alarm.PrimaryGroups[i] == EGroupAI(DynamicLoadObject("3_2_1_PowerPlant.EGroupAI20", class'EGroupAI')))
                    {
                        Alarm.PrimaryGroups.Remove(i, 1);
                        break;
                    }
                }
            }
        }*/

        // Joshua - Destroying the hat from the NPC that we teleport / kill
        ForEach DynamicActors(class'EPawn', EP)
        {
            if (EP.Name == 'EPowerPlantEmployee14')
            {
                EP.Hat = None;
                EP.HatMesh = None;
            }
        }

        if (!bInit)
        {
        bInit=TRUE;
        Code=0;
        Molestered=0;
        }

    }
}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Comm1:
    Log("Communicator 32_20- Russian Soldiers");
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0001L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_20_01', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0002L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_20_02', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0003L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_20_03', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0004L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_20_04', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
Init:
    Log("Communicator 32_10 -  Trigger meltdown alarm");
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0027L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_10_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    AddGoal('1', "", 3, "", "P_3_2_1_NPP_LambertComms", "Goal_0020L", "Localization\\P_3_2_1_PowerPlant", "P_3_2_1_NPP_LambertComms", "Goal_0024L", "Localization\\P_3_2_1_PowerPlant");
    AddGoal('3', "", 8, "", "P_3_2_1_NPP_LambertComms", "Goal_0021L", "Localization\\P_3_2_1_PowerPlant", "P_3_2_1_NPP_LambertComms", "Goal_0025L", "Localization\\P_3_2_1_PowerPlant");
    AddGoal('4', "", 9, "", "P_3_2_1_NPP_LambertComms", "Goal_0022L", "Localization\\P_3_2_1_PowerPlant", "P_3_2_1_NPP_LambertComms", "Goal_0026L", "Localization\\P_3_2_1_PowerPlant");
    AddNote("", "P_3_2_1_NPP_LambertComms", "Note_0023L", "Localization\\P_3_2_1_PowerPlant");
    AddRecon(class 'EReconFullText3_2AF_B');
    Teleport(2, 'ELambert'); // Joshua - Teleport conflicting NPC
    Sleep(0.1);
    KillNPC(2, TRUE, FALSE); // Joshua - Killing conflicting NPC
    Close();
    End();
Collaterals:
    Log("Communicator 32_12- No Collateral");
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0007L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_12_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0008L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_12_02', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0009L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_12_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    AddNote("", "P_3_2_1_NPP_LambertComms", "Note_0011L", "Localization\\P_3_2_1_PowerPlant");
    End();
EmployeeHurt:
    Log("Sam has killed a power plant employee.");
    CheckFlags(Molestered,TRUE,'SecondTime');
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0006L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_90_01', 1, 0, TR_HEADQUARTER, 0, false);
    SetFlags(Molestered,TRUE);
    Sleep(0.1);
    Close();
    End();
SecondTime:
    Log("2 strikes, you're out Sam.");
    SetProfileDeletion();
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0005L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_90_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(2.5);
    Close();
    Sleep(0.5);
    GameOver(false, 0);
    End();
AlertCompleted:
    Log("Communicator 32_26: Alert Completed");
    SendUnrealEvent('TheLights');
    SendUnrealEvent('MeltdownLights');
    Sleep(3);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0014L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_26_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    Sleep(69);
RussiansRemain:
    Log("Communicator 32_27- Russians Remain");
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0015L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_27_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0016L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_27_02', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0017L", "Localization\\P_3_2_1_PowerPlant"), Sound'S3_2_1Voice.Play_32_27_03', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
Load322:
    Log("Loads 3.2.2.");
    LevelChange("3_2_2_PowerPlant");
    End();
Screwed:
    Log("Generic Mission Over.");
    SetProfileDeletion();
    //Joshua - Temporarily removed until audio is restored: Speech(Localize("P_3_2_1_NPP_LambertComms", "Speech_0018L", "Localization\\P_3_2_1_PowerPlant"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    GameOver(false, 0);
    End();
Coded:
    Log("Code has been aquired.");
    SetFlags(Code,TRUE);
    End();
CodeCheck:
    Log("If code is acquired, do nothing.  If the player has cheated to get the door code or already knows it, set the goal accomplished.");
    CheckFlags(Code,TRUE,'Nada');
    Log("CHEATER!!!  :P  :P  :P");
    GoalCompleted('5');
Nada:
    End();

}

defaultproperties
{
}
