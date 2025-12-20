//=============================================================================
// P_1_3_2OilRig_LambertComm
//=============================================================================
class P_1_3_2OilRig_LambertComm extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_3_2Voice.uax

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

    // Joshua - Replace NPC skins for variety
    if (!bInit)
    {
        ForEach DynamicActors(class'Pawn', P)
        {
            if (P.name == 'EGeorgianSoldier1')
            {
                P.Skins[0] = Texture(DynamicLoadObject("ETexCharacter.GESoldier.GESoldierA", class'Texture'));
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
Insertion:
    Log("Headquarters communications, initiating map 1.3.");
    IgnoreAlarmStage(TRUE); // Joshua - Level has no alarms, added to hide alarm HUD icon
    Speech(Localize("P_1_3_2OilRig_LambertComm", "Speech_0007L", "Localization\\P_1_3_2CaspianOilRefinery"), Sound'S1_3_2Voice.Play_13_10_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_3_2OilRig_LambertComm", "Speech_0008L", "Localization\\P_1_3_2CaspianOilRefinery"), Sound'S1_3_2Voice.Play_13_10_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_3_2OilRig_LambertComm", "Speech_0009L", "Localization\\P_1_3_2CaspianOilRefinery"), Sound'S1_3_2Voice.Play_13_10_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    AddGoal('1_3_1', "", 7, "", "P_1_3_2OilRig_LambertComm", "Goal_0004L", "Localization\\P_1_3_2CaspianOilRefinery", "P_1_3_2OilRig_LambertComm", "Goal_0013L", "Localization\\P_1_3_2CaspianOilRefinery");
    AddGoal('1_3_2', "", 9, "", "P_1_3_2OilRig_LambertComm", "Goal_0005L", "Localization\\P_1_3_2CaspianOilRefinery", "P_1_3_2OilRig_LambertComm", "Goal_0014L", "Localization\\P_1_3_2CaspianOilRefinery");
    AddNote("", "P_1_3_2OilRig_LambertComm", "Note_0006L", "Localization\\P_1_3_2CaspianOilRefinery");
    End();
Bumped:
    Log("Communicator 13_10 - Find the Technician");
    Speech(Localize("P_1_3_2OilRig_LambertComm", "Speech_0010L", "Localization\\P_1_3_2CaspianOilRefinery"), Sound'S1_3_2Voice.Play_13_20_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_3_2OilRig_LambertComm", "Speech_0011L", "Localization\\P_1_3_2CaspianOilRefinery"), Sound'S1_3_2Voice.Play_13_20_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_3_2OilRig_LambertComm", "Speech_0012L", "Localization\\P_1_3_2CaspianOilRefinery"), Sound'S1_3_2Voice.Play_13_20_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
LevelChange:
    Log("Change the level.");
    LevelChange("1_3_3CaspianOilRefinery");
    End();

}

