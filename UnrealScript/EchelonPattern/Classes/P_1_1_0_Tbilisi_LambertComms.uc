//=============================================================================
// P_1_1_0_Tbilisi_LambertComms
//=============================================================================
class P_1_1_0_Tbilisi_LambertComms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_1_0Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S1_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int BigCollDone;
var int Civil01Dead;
var int Civil02Dead;


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

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if(P.name == 'ELambert0')
            Characters[1] = P.controller;
        if(P.name == 'EAnna0')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    BigCollDone=0;
    Civil01Dead=0;
    Civil02Dead=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This pattern deals with all of the Lambert Communications for the level.");
START:
    Log("Sam gets his very first order from Lambert.");
    SendPatternEvent('BGQBai','StartZone');
    Sleep(1);
    AddGoal('STREETS', "", 10, "", "P_1_1_0_Tbilisi_LambertComms", "Goal_0073L", "Localization\\P_1_1_0Tbilisi", "P_1_1_0_Tbilisi_LambertComms", "Goal_0086L", "Localization\\P_1_1_0Tbilisi");
    AddGoal('CONTACT', "", 8, "", "P_1_1_0_Tbilisi_LambertComms", "Goal_0074L", "Localization\\P_1_1_0Tbilisi", "P_1_1_0_Tbilisi_LambertComms", "Goal_0087L", "Localization\\P_1_1_0Tbilisi");
    AddGoal('CIVILS', "", 9, "", "P_1_1_0_Tbilisi_LambertComms", "Goal_0075L", "Localization\\P_1_1_0Tbilisi", "P_1_1_0_Tbilisi_LambertComms", "Goal_0088L", "Localization\\P_1_1_0Tbilisi");
    AddRecon(class 'EReconFullTextGugen');
    AddRecon(class 'EReconFullTextBlaust');
    AddRecon(class 'EReconFullTextMadison');
    AddRecon(class 'EReconMapTibilisi');
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0001L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_04_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0002L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_04_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0003L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_04_03', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    SendPatternEvent('AIAdamBG','AdamA');
    End();
ItsOnFire:
    Log("Lambert tells Sam the warehouse is on fire.");
    Sleep(5);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0009L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_08_01', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0010L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_08_02', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
Grim00Fire:
    Log("Grim tells Sam shes reeady to help him out.");
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0015L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_16_01', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
Grim01Fire:
    Log("After the ceiling collapses, grim tells Sam to use the stairs at the far end.");
    SendUnrealEvent('Big1Collapse');
    ShakeCamera(800, 20000, 1000);
    SetFlags(BigCollDone,TRUE);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0016L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_17_01', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
Grim04Fire:
    Log("Grim tells Sam to get to the other stairwell.");
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0018L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_18_02', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
Grim05Fire:
    Log("Grim tells Sam hes found the contact.");
    CheckFlags(BigCollDone,TRUE,'AlreadyCollapsed');
    SendUnrealEvent('Big1Collapse');
AlreadyCollapsed:
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0019L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_19_01', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
ContactDies:
    Log("Sam finds the contact as he is dying.");
    Sleep(1);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0089L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_20_01', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0090L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_20_02', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0024L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_20_03', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
Grim06Fire:
    Log("Grim tells Sam to shoot the windows.");
    Sleep(2);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0025L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_0Voice.Play_11_20_04', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
Grim06Abort:
    Log("This will prevent the smoke notice from being given if the window is already broken.");
    Close();
    SendUnrealEvent('BreakWindowVolume');
    End();
SamOnStreets:
    Log("Lambert pulls the plug because Sam went down to the streets.");
    SetProfileDeletion();
    SetExclusivity(TRUE);
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0045L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_Voice.Play_11_99_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    GameOver(false, 0);
    End();
BloodyMurder:
    Log("Sam is killing non-hostile civilians");
    CheckFlags(VGame(EchelonGameInfo(Level.Game).VarObject).GameVar1,TRUE,'StrikeTwo');
    SetFlags(VGame(EchelonGameInfo(Level.Game).VarObject).GameVar1,TRUE);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0083L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_Voice.Play_11_90_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
StrikeTwo:
    Log("Sam has killed 2 civilians");
    SetProfileDeletion();
    SetExclusivity(TRUE);
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Speech(Localize("P_1_1_0_Tbilisi_LambertComms", "Speech_0084L", "Localization\\P_1_1_0Tbilisi"), Sound'S1_1_Voice.Play_11_90_02', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    GameOver(false, 2);
    End();
DoNothing:
    Log("Doing Nothing");
    End();
LevelChange:
    Log("Going to 1_1_1");
    CheckFlags(V1_1_0Tbilisi(Level.VarObject).GoalContact,FALSE,'DoNothing');
    LevelChange("1_1_1Tbilisi.unr");
    End();

}

