//=============================================================================
// P_1_3_3OilRig_LambertComm
//=============================================================================
class P_1_3_3OilRig_LambertComm extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_3_3Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S1_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Over;
var int WackyOccasion;


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

    // Joshua - Replace NPC skins for variety
    if (!bInit)
    {
        ForEach DynamicActors(class'Pawn', P)
        {
            if (P.name == 'EGeorgianSoldier0' || P.name == 'EGeorgianSoldier5' || P.name == 'EGeorgianSoldier16' ||
                P.name == 'EGeorgianSoldier10' || P.name == 'EGeorgianSoldier9' || P.name == 'EGeorgianSoldier6')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.GESoldier.GESoldierA", class'Texture'));
            }
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    Over=0;
    WackyOccasion=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("Lamberto speaketh prophecy.");
    IgnoreAlarmStage(TRUE); // Joshua - Level has no alarms, added to hide alarm HUD icon
Hurry:
    Log("If Sam is dilly-dallying.");
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0015L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_26_01', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
HurryDeux:
    Log("Like beating a dead horse here.");
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0016L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_27_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
Attack:
    Log("Communicator 13_36, Attack Confirmation");
    Sleep(2);
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0002L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_36_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    Sleep(4);
    AddRecon(class 'EReconInfCrudeOilCircuit');
    AddRecon(class 'EReconInfCrudeOilRegulator');
    AddRecon(class 'EReconInfPetrolRes');
    Sleep(4);
    SendPatternEvent('TopDudes','AttackDeux');
    End();
GroundTroops:
    Log("Communicator 13_38 - Ground Troops");
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0004L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_38_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0005L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_38_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0006L", "Localization\\P_1_3_3CaspianOilRefinery"), None, 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
TechniCase:
    Log("Communicator 13_50, The Technician's Case");
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0007L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_50_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0008L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_50_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0009L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_50_03', 1, 0, TR_HEADQUARTER, 0, false);
    AddRecon(class 'EReconFullTextUSAF');
    AddGoal('1_3_3', "", 10, "", "P_1_3_3OilRig_LambertComm", "Goal_0010L", "Localization\\P_1_3_3CaspianOilRefinery", "P_1_3_3OilRig_LambertComm", "Goal_0021L", "Localization\\P_1_3_3CaspianOilRefinery");
    GoalCompleted('1_3_2');
    Close();
    End();
Over:
    Log("This is the end.  My only friend, the end.  Strange scenes inside the goldmine..");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0014L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_1_Voice.Play_11_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    GameOver(false, 0);
    End();
LevelSwitch:
    Log("1.3.3 is done, 1.3.4 is next.");
    LevelChange("1_3_4CaspianOilRefinery");
    End();
TimeOut:
    Log("See you at the party Richter!");
    SetProfileDeletion();
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0017L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_28_01', 1, 0, TR_HEADQUARTER, 0, true);
    GameOver(false, 0);
    End();
Wack:
    Log("Wig wig wig wack.");
    SetFlags(WackyOccasion,TRUE);
    End();
GetOut:
    Log("Communicator 13_60 -  Get out of there");
    PlayerMove(false);
    Speech(Localize("P_1_3_3OilRig_LambertComm", "Speech_0018L", "Localization\\P_1_3_3CaspianOilRefinery"), Sound'S1_3_3Voice.Play_13_60_01', 1, 0, TR_HEADQUARTER, 0, true);
    Sleep(0.1);
    GameOver(true, 0);
Nada:
    End();

}

