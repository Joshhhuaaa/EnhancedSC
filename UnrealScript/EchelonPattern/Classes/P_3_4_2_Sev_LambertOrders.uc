//=============================================================================
// P_3_4_2_Sev_LambertOrders
//=============================================================================
class P_3_4_2_Sev_LambertOrders extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int UPSPlanPlayed;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        default:
            break;
        }
    }
}

function InitPattern()
{
    local Pawn P;
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
        if(P.name == 'EAnna0')
            Characters[2] = P.controller;
    }

    // Joshua - Adding textures to staticmeshes without any assigned
    ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'StaticMeshActor69')
            A.Skins[0] = Texture(DynamicLoadObject("EGO_Tex.GO_doorexplode", class'Texture'));
        if(A.name == 'StaticMeshActor306')
            A.Skins[0] = Texture(DynamicLoadObject("3_4_Severo_tex.Bathroom.Cabinet02_sev", class'Texture'));
        if(A.name == 'StaticMeshActor322')
            A.Skins[0] = Texture(DynamicLoadObject("3_4_Severo_tex.Bathroom.toilette_sev", class'Texture'));
    }

    // Joshua - Hiding staticmeshes that are clipping through the floor
        ForEach AllActors(class'Actor', A)
    {
        if(A.name == 'StaticMeshActor590' || A.name == 'StaticMeshActor591')
        {
            A.bHidden = true;
            A.SetCollision(false);
        }
    }

    if( !bInit )
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
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0062L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_01_01', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0063L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_01_02', 0, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0064L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_01_03', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0065L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_01_04', 0, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0066L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_01_05', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0067L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_01_06', 0, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0068L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_01_07', 1, 0, TR_CONVERSATION, 0, false);
    Sleep(0.1);
    Close();
    End();
InitGoals:
    Log("These are Sam's intital goals");
    SendPatternEvent('SatelliteTech','StartState');
    AddGoal('INTTECH', "", 1, "", "P_3_4_2_Sev_LambertOrders", "Goal_0037L", "Localization\\P_3_4_2Severonickel", "P_3_4_2_Sev_LambertOrders", "Goal_0049L", "Localization\\P_3_4_2Severonickel");
    AddGoal('ALARM', "", 4, "", "P_3_4_2_Sev_LambertOrders", "Goal_0033L", "Localization\\P_3_4_2Severonickel", "P_3_4_2_Sev_LambertOrders", "Goal_0050L", "Localization\\P_3_4_2Severonickel");
    AddGoal('MASSE', "", 8, "", "P_3_4_2_Sev_LambertOrders", "Goal_0034L", "Localization\\P_3_4_2Severonickel", "P_3_4_2_Sev_LambertOrders", "Goal_0051L", "Localization\\P_3_4_2Severonickel");
    Sleep(1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0022L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_07_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0023L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_07_02', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0024L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_07_03', 1, 2, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
SatelliteMethod:
    Log("");
    CheckFlags(UPSPlanPlayed,TRUE,'DoNothing');
    SetFlags(UPSPlanPlayed,TRUE);
    AddGoal('UPS', "", 3, "", "P_3_4_2_Sev_LambertOrders", "Goal_0035L", "Localization\\P_3_4_2Severonickel", "P_3_4_2_Sev_LambertOrders", "Goal_0052L", "Localization\\P_3_4_2Severonickel");
    AddGoal('GENNY', "", 2, "", "P_3_4_2_Sev_LambertOrders", "Goal_0036L", "Localization\\P_3_4_2Severonickel", "P_3_4_2_Sev_LambertOrders", "Goal_0053L", "Localization\\P_3_4_2Severonickel");
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0026L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_18_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0027L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_18_02', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0028L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_18_03', 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0029L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_18_04', 1, 2, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
AlexIsComing:
    Log("Lambert informs Sam that Alekseevich is en route.");
    AddGoal('ALEKS', "", 10, "", "P_3_4_2_Sev_LambertOrders", "Goal_0038L", "Localization\\P_3_4_2Severonickel", "P_3_4_2_Sev_LambertOrders", "Goal_0054L", "Localization\\P_3_4_2Severonickel");
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0039L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_22_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0040L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_22_02', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0041L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_22_03', 1, 2, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0042L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_22_04', 0, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0043L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_22_05', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    SendPatternEvent('Alekseevich','ColonelArrival');
    End();
JointChiefsB:
    Log("Lambert tells Sam they have the okay from the JCOS.");
    AddGoal('PICKETTGAP', "", 1, "", "P_3_4_2_Sev_LambertOrders", "Goal_0044L", "Localization\\P_3_4_2Severonickel", "P_3_4_2_Sev_LambertOrders", "Goal_0055L", "Localization\\P_3_4_2Severonickel");
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0045L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_34_01', 1, 0, TR_HEADQUARTER, 0, false);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0046L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_34_02', 0, 0, TR_HEADQUARTER, 0, false);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0047L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_34_03', 2, 2, TR_HEADQUARTER, 0, false);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0048L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_34_04', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
JointChiefsA:
    Log("lambert tells Sam they are looking for approval from the JCOS for Grims plan");
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0056L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_09_01', 1, 0, TR_HEADQUARTER, 0, false);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0057L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_09_02', 2, 0, TR_HEADQUARTER, 0, false);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0058L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_09_03', 0, 0, TR_HEADQUARTER, 0, false);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0059L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_09_04', 1, 0, TR_HEADQUARTER, 0, false);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0060L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_09_05', 0, 0, TR_HEADQUARTER, 0, false);
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0061L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_09_06', 1, 0, TR_HEADQUARTER, 0, false);
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
Spike:
    Log("Alekseevich head on a spike comm.");
    //Joshua - Temporarily removed until audio is restored:Speech(Localize("P_3_4_2_Sev_LambertOrders", "Speech_0069L", "Localization\\P_3_4_2Severonickel"), Sound'S3_4_2Voice.Play_34_42_01', 1, 0, TR_NPCS, 0, false);
    Close();
    End();
LevelEnd:
    Log("Punts to the infamous 3.4.3");
    LevelChange("3_4_3Severonickel.unr");
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

defaultproperties
{
}
