//=============================================================================
// P_2_1_0_CIA_Comms
//=============================================================================
class P_2_1_0_CIA_Comms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_0Voice.uax

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
    local EGroupAI GroupAI;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'ELambert1')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
        // Joshua - Moved fan logic to P_2_1_0_CIA_Fan to avoid a bug where early events could lock the dialogue box
        GroupAI = Spawn(class'EGroupAI', , , vect(0, 0, 0), rot(0, 0, 0));
        GroupAI.ScriptedPatternClass = Class'EchelonPattern.P_2_1_0_CIA_Fan';
        GroupAI.bAlwaysKeepScriptedPattern = True;
        GroupAI.Tag = 'FanSystem';
        GroupAI.SendJumpEvent('Begin', false, false);
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
Start:
    // Joshua - Enhanced change: CIA HQ is a one alarm level until accessing the central server (Elite difficulty)
    if (IsEliteMode())
        EchelonLevelInfo(Level).bOneAlarmLevel = true;
    Log("");
    Sleep(2.5);
    SendUnrealEvent('VentFan5');
    SendUnrealEvent('CleanMover');
    SendUnrealEvent('EElevatorButton7');
    Speech(Localize("P_2_1_0_CIA_Comms", "Speech_0045L", "Localization\\P_2_1_0CIA"), Sound'S2_1_0Voice.Play_21_05_01', 1, 2, TR_HEADQUARTER, 0, false);
    AddGoal('GoalServer', "", 8, "", "P_2_1_0_CIA_Comms", "Goal_0046L", "Localization\\P_2_1_0CIA", "P_2_1_0_CIA_Comms", "Goal_0047L", "Localization\\P_2_1_0CIA");
    AddGoal('GoalFatality', "", 10, "", "P_2_1_0_CIA_Comms", "Goal_0048L", "Localization\\P_2_1_0CIA", "P_2_1_0_CIA_Comms", "Goal_0049L", "Localization\\P_2_1_0CIA");
    if (IsEliteMode()) // Joshua - Enhanced change: Removing the one alarm limit, player has accessed CIA central server
        AddGoal('GoalAlarm', "", 6, "", "P_2_1_0_CIA_Comms", "Goal_0050L", "Localization\\P_2_1_0CIA", "P_2_1_0_CIA_Comms", "Goal_0051L", "Localization\\P_2_1_0CIA");
    AddNote("", "P_2_1_0_CIA_Comms", "Note_0050L", "Localization\\P_2_1_0CIA");
    AddNote("", "P_2_1_0_CIA_Comms", "Note_0068L", "Localization\\P_2_1_0CIA"); // Joshua - Thermal vision note (PC version only)
    AddRecon(class 'EReconMapCIA1');
    Speech(Localize("P_2_1_0_CIA_Comms", "Speech_0002L", "Localization\\P_2_1_0CIA"), Sound'S2_1_0Voice.Play_21_05_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_0_CIA_Comms", "Speech_0003L", "Localization\\P_2_1_0CIA"), Sound'S2_1_0Voice.Play_21_05_03', 1, 1, TR_HEADQUARTER, 0, false);
    Close();
    // Joshua – Moved fan logic to P_2_1_0_CIA_Fan to avoid a bug where early events could lock the dialogue box
    SetFlags(V2_1_0CIA(Level.VarObject).LambertIntroDone,TRUE);
    End();
StopItsOver:
    Log("StopItsOver");
    Close();
    DisableMessages(TRUE, TRUE);
    End();
}

