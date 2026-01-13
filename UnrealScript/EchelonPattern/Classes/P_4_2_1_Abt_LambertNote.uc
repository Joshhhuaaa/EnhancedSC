//=============================================================================
// P_4_2_1_Abt_LambertNote
//=============================================================================
class P_4_2_1_Abt_LambertNote extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int LongDanPass1;
var int pass1;


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
    local Light L;
    local EZoneAI ZoneAI;
    local ELaptop Laptop;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'ELambert0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
        // Joshua - Replace NPC skins for variety
        ForEach DynamicActors(class'Pawn', P)
        {
            if (P.name == 'EGeorgianSoldier2' || P.name == 'EGeorgianSoldier3' || P.name == 'EGeorgianSoldier6' ||
                P.name == 'EGeorgianSoldier13' || P.name == 'EGeorgianSoldier14' || P.name == 'EGeorgianSoldier16' ||
                P.name == 'EGeorgianSoldier21' || P.name == 'EGeorgianSoldier31' || P.name == 'EGeorgianSoldier33' ||
                P.name == 'EGeorgianSoldier37')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.GESoldier.GESoldierA", class'Texture'));
            }

        // Joshua - Removing HeatRadius from all light actors
        ForEach AllActors(Class'Light', L)
        {
            if (L.name == 'ELight60' || L.name == 'ELight57' || L.name == 'ELight69' ||
                L.name == 'ELight58' || L.name == 'ELight11' || L.name == 'ELight29' ||
                L.name == 'ELight70' || L.name == 'Light34' || L.name == 'ELight3' ||
                L.name == 'ELight59')
            {
                L.HeatRadius = 0;
            }
        }

        // Joshua - Fixes some body checks
        ForEach AllActors(Class'EZoneAI', ZoneAI)
        {
            if (ZoneAI.name == 'EZoneAI8')
            {
                ZoneAI.DisableGroupTags.Length = 0;
            }

            if (ZoneAI.name == 'EZoneAI5')
            {
                ZoneAI.DisableGroupTags[6] = 'EGroupAI2';
                ZoneAI.DisableGroupTags[7] = 'EGroupAI6';
                ZoneAI.DisableGroupTags[8] = 'EGroupAI27';
            }
        }

        // Joshua - Make laptop destructible on Xbox version of Abattoir
        ForEach AllActors(class'ELaptop', Laptop)
        {
            if (Laptop.name == 'ELaptop0')
            {
                Laptop.bDamageable = true;
            }
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    LongDanPass1=0;
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
JumpLongDanMove:
    Log("");
    CheckFlags(LongDanPass1,TRUE,'Fin');
    Jump('MeetLongDan');
LambertStart:
    Log("Lambert comm while in the van in the begining.");
    AddRecon(class 'EReconPicGrinko');
    AddRecon(class 'EReconFullTextGrinko');
    AddGoal('DestroyAntenna', "", 8, "", "P_4_2_1_Abt_LambertNote", "Goal_0052L", "Localization\\P_4_2_1_Abattoir", "P_4_2_1_Abt_LambertNote", "Goal_0053L", "Localization\\P_4_2_1_Abattoir");
    Sleep(1.5);
    Speech(Localize("P_4_2_1_Abt_LambertNote", "Speech_0035L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_03_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_1_Abt_LambertNote", "Speech_0036L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_03_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_1_Abt_LambertNote", "Speech_0037L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_03_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_1_Abt_LambertNote", "Speech_0003L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_05_01', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    End();
LambertAntenna:
    Log("Lambert comm after Sam sabotage the antenna");
    LockDoor('ESwingingDoor10', FALSE, TRUE);
    Sleep(1);
    GoalCompleted('DestroyAntenna');
    SendPatternEvent('RoofListeners','KillListeners');
    SendUnrealEvent('EVolume9');
    AddGoal('LocateSoldier', "", 6, "", "P_4_2_1_Abt_LambertNote", "Goal_0054L", "Localization\\P_4_2_1_Abattoir", "P_4_2_1_Abt_LambertNote", "Goal_0055L", "Localization\\P_4_2_1_Abattoir");
    Speech(Localize("P_4_2_1_Abt_LambertNote", "Speech_0011L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_15_01', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    Sleep(1);
    SendPatternEvent('EGroupAI13','Start');
    End();
StopSoldier:
    Log("");
    AddGoal('StopSoldier', "", 4, "", "P_4_2_1_Abt_LambertNote", "Goal_0056L", "Localization\\P_4_2_1_Abattoir", "P_4_2_1_Abt_LambertNote", "Goal_0057L", "Localization\\P_4_2_1_Abattoir");
    Speech(Localize("P_4_2_1_Abt_LambertNote", "Speech_0041L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_32_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_1_Abt_LambertNote", "Speech_0042L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_32_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_4_2_1_Abt_LambertNote", "Speech_0043L", "Localization\\P_4_2_1_Abattoir"), Sound'S4_2_1Voice.Play_42_32_03', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    End();
Fin:
    Log("");
    End();
ChangeLevel:
    Log("");
    GoalCompleted('StopSoldier');
    LevelChange("4_2_2_Abattoir");
    End();

}

