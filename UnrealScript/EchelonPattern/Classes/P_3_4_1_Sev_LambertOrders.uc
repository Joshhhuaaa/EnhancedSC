//=============================================================================
// P_3_4_1_Sev_LambertOrders
//=============================================================================
class P_3_4_1_Sev_LambertOrders extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int UPSPlanPlayed;


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
        if (P.name == 'EAnna0')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    UPSPlanPlayed=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This pattern controls all of Sam's orders for the level.");
TempWilkes:
    Log("This pattern is not yet built. The missing member is Wilkes.");
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0062L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_01_01', 1, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0063L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_01_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0064L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_01_03', 1, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0065L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_01_04', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0066L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_01_05', 1, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0067L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_01_06', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0068L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_01_07', 1, 0, TR_CONVERSATION, 0, false);
    Close();
    End();
InitGoals:
    Log("These are Sam's intital goals");
    SendPatternEvent('SatelliteTech','StartState');
    AddGoal('INTTECH', "", 7, "", "P_3_4_1_Sev_LambertOrders", "Goal_0037L", "Localization\\P_3_4_1Severonickel", "P_3_4_1_Sev_LambertOrders", "Goal_0049L", "Localization\\P_3_4_1Severonickel");
    AddGoal('ALARM', "", 1, "", "P_3_4_1_Sev_LambertOrders", "Goal_0033L", "Localization\\P_3_4_1Severonickel", "P_3_4_1_Sev_LambertOrders", "Goal_0050L", "Localization\\P_3_4_1Severonickel");
    AddGoal('MASSE', "", 2, "", "P_3_4_1_Sev_LambertOrders", "Goal_0034L", "Localization\\P_3_4_1Severonickel", "P_3_4_1_Sev_LambertOrders", "Goal_0051L", "Localization\\P_3_4_1Severonickel");
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0022L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_07_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0023L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_07_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0024L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_07_03', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    End();
SatelliteMethod:
    Log("");
    CheckFlags(UPSPlanPlayed,TRUE,'DoNothing');
    SetFlags(UPSPlanPlayed,TRUE);
    AddGoal('UPS', "", 8, "", "P_3_4_1_Sev_LambertOrders", "Goal_0035L", "Localization\\P_3_4_1Severonickel", "P_3_4_1_Sev_LambertOrders", "Goal_0052L", "Localization\\P_3_4_1Severonickel");
    AddGoal('GENNY', "", 9, "", "P_3_4_1_Sev_LambertOrders", "Goal_0036L", "Localization\\P_3_4_1Severonickel", "P_3_4_1_Sev_LambertOrders", "Goal_0053L", "Localization\\P_3_4_1Severonickel");
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0026L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_18_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0027L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_18_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0028L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_18_03', 2, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0029L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_18_04', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    End();
AlexIsComing:
    Log("Lambert informs Sam that Alekseevich is en route.");
    AddGoal('ALEKS', "", 1, "", "P_3_4_1_Sev_LambertOrders", "Goal_0038L", "Localization\\P_3_4_1Severonickel", "P_3_4_1_Sev_LambertOrders", "Goal_0054L", "Localization\\P_3_4_1Severonickel");
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0039L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_22_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0040L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_22_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0041L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_22_03', 1, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0042L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_22_04', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0043L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_22_05', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
JointChiefsB:
    Log("Lambert tells Sam they have the okay from the JCOS.");
    AddGoal('PICKETTGAP', "", 9, "", "P_3_4_1_Sev_LambertOrders", "Goal_0044L", "Localization\\P_3_4_1Severonickel", "P_3_4_1_Sev_LambertOrders", "Goal_0055L", "Localization\\P_3_4_1Severonickel");
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0045L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_34_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0046L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_34_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0047L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_34_03', 2, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0048L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_34_04', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
JointChiefsA:
    Log("lambert tells Sam they are looking for approval from the JCOS for Grims plan");
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0056L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_09_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0057L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_09_02', 2, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0058L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_09_03', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0059L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_09_04', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0060L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_09_05', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0061L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_09_06', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    SendPatternEvent('MercLife','MercLifeStart');
    End();
AlexDeathFail:
    Log("Sam killed Alekseevich, this is a Game Over Condition");
    SetProfileDeletion();
    GameOver(false, 0);
    End();
MasseDeathFail:
    Log("Sam has killed Phillip Masse, this is a Game Over Condition");
    SetProfileDeletion();
    GameOver(false, 0);
    End();
LevelEnd:
    Log("Checking if its okay to go to 343");
    CheckFlags(V3_4_1Severonickel(Level.VarObject).DishDone,FALSE,'DoNothing');
    Speech(Localize("P_3_4_1_Sev_LambertOrders", "Speech_0069L", "Localization\\P_3_4_1Severonickel"), Sound'S3_4_2Voice.Play_34_42_01', 1, 0, TR_NPCS, 0, false);
    Close();
    LevelChange("3_4_3Severonickel.unr");
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

defaultproperties
{
}
