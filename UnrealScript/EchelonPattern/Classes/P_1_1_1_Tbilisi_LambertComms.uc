//=============================================================================
// P_1_1_1_Tbilisi_LambertComms
//=============================================================================
class P_1_1_1_Tbilisi_LambertComms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_1_1Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S1_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Civil01Dead;
var int Civil02Dead;
var int Civil03Dead;
var int WindowBroken;


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
    Civil01Dead=0;
    Civil02Dead=0;
    Civil03Dead=0;
    WindowBroken=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This pattern deals with all of the Lambert Communications for the level.");
FindBox:
    Log("Lambert tells Sam to locate Blausteins apartment and find the black box.");
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0026L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_1Voice.Play_11_11_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0027L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_1Voice.Play_11_11_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0028L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_1Voice.Play_11_11_03', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    End();
BoxFound:
    Log("Sam finds Blausteins black box");
    Sleep(3);
    LockDoor('BlausteinsBalcony', FALSE, TRUE);
    GoalCompleted('BLACKBOX');
    SetFlags(V1_1_1Tbilisi(Level.VarObject).GoalBlackBox,TRUE);
    AddGoal('DEADDROP', "", 6, "", "P_1_1_1_Tbilisi_LambertComms", "Goal_0079L", "Localization\\P_1_1_1Tbilisi", "P_1_1_1_Tbilisi_LambertComms", "Goal_0092L", "Localization\\P_1_1_1Tbilisi");
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0036L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_1Voice.Play_11_25_01', 1, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0038L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_1Voice.Play_11_25_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0039L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_1Voice.Play_11_25_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0067L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_1Voice.Play_11_25_04', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0068L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_1Voice.Play_11_25_05', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0069L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_1Voice.Play_11_25_06', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0070L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_1Voice.Play_11_25_07', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
SafeStreets:
    Log("Lambert tells Sam its okay to go down to street level.");
    SetFlags(V1_1_1Tbilisi(Level.VarObject).GoalStreets,TRUE);
    GoalCompleted('STREETS');
    SendUnrealEvent('BackStreetColWall');
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0040L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_1Voice.Play_11_12_01', 1, 0, TR_HEADQUARTER, 0, false);
    Sleep(0.1);
    Close();
    End();
SamOnStreets:
    Log("Lambert pulls the plug because Sam went down to the streets.");
    CheckFlags(V1_1_1Tbilisi(Level.VarObject).GoalStreets,TRUE,'DoNothing');
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    SetExclusivity(TRUE);
    PlayerMove(false);
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0045L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_Voice.Play_11_99_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    GameOver(false, 0);
    End();
DeadDrop:
    Log("Sam has found Gurgenidze's Dead Drop.");
    GoalCompleted('DEADDROP');
    AddGoal('PRECINCT', "", 5, "", "P_1_1_1_Tbilisi_LambertComms", "Goal_0082L", "Localization\\P_1_1_1Tbilisi", "P_1_1_1_Tbilisi_LambertComms", "Goal_0093L", "Localization\\P_1_1_1Tbilisi");
    End();
BloodyMurder:
    Log("Sam is killing non-hostile civilians");
    SetExclusivity(TRUE);
    CheckFlags(VGame(EchelonGameInfo(Level.Game).VarObject).GameVar1,TRUE,'StrikeTwo');
    SetFlags(VGame(EchelonGameInfo(Level.Game).VarObject).GameVar1,TRUE);
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0083L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_Voice.Play_11_90_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    SetExclusivity(FALSE);
    End();
StrikeTwo:
    Log("Sam has killed two civilians. Launching Game Over");
    SetProfileDeletion();
    SetExclusivity(TRUE);
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    Speech(Localize("P_1_1_1_Tbilisi_LambertComms", "Speech_0084L", "Localization\\P_1_1_1Tbilisi"), Sound'S1_1_Voice.Play_11_90_02', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    GameOver(false, 2);
    End();
DoNothing:
    Log("Doing Nothing");
    End();
LevelChange:
    Log("Going to 1_1_2");
    CheckFlags(V1_1_1Tbilisi(Level.VarObject).GoalBlackBox,FALSE,'DoNothing');
    CheckFlags(V1_1_1Tbilisi(Level.VarObject).GoalStreets,FALSE,'DoNothing');
    LevelChange("1_1_2Tbilisi.unr");
    End();

}

