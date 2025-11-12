//=============================================================================
// P_2_1_1_CIA_Comms
//=============================================================================
class P_2_1_1_CIA_Comms extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int FanSuccess;


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
        if (P.name == 'ELambert1')
            Characters[1] = P.controller;
        if (P.name == 'EAnna0')
            Characters[2] = P.controller;
        if (P.name == 'ECIAAgent2')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    FanSuccess=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("");
    Sleep(1);
FGun:
    Log("Lambert tell sam his gun in place");
    AddGoal('GoalF2000', "", 6, "", "P_2_1_1_CIA_Comms", "Goal_0069L", "Localization\\P_2_1_1CIA", "P_2_1_1_CIA_Comms", "Goal_0070L", "Localization\\P_2_1_1CIA");
    Speech(Localize("P_2_1_1_CIA_Comms", "Speech_0053L", "Localization\\P_2_1_1CIA"), Sound'S2_1_1Voice.Play_21_09_01', 1, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_1_CIA_Comms", "Speech_0054L", "Localization\\P_2_1_1CIA"), Sound'S2_1_1Voice.Play_21_09_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_1_CIA_Comms", "Speech_0055L", "Localization\\P_2_1_1CIA"), Sound'S2_1_1Voice.Play_21_09_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
CloseToServer:
    Log("CloseToServer");
    SendPatternEvent('Breakroom','DropAllBreaked');
    Sleep(2);
    Speech(Localize("P_2_1_1_CIA_Comms", "Speech_0058L", "Localization\\P_2_1_1CIA"), Sound'S2_1_1Voice.Play_21_17_01', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    End();
comm2120:
    Log("CPUaccessed");
    SetFlags(V2_1_1CIA(Level.VarObject).ServerDone,TRUE);
    GoalCompleted('GoalServer');
    // Joshua - Enhanced change: Removing the one alarm limit, player has accessed CIA central server
    if (IsEliteMode()) 
    {
        GoalCompleted('GoalAlarm');
        EchelonLevelInfo(Level).bOneAlarmLevel = false;
    }
    AddGoal('GoalPC', "", 4, "", "P_2_1_1_CIA_Comms", "Goal_0066L", "Localization\\P_2_1_1CIA", "P_2_1_1_CIA_Comms", "Goal_0067L", "Localization\\P_2_1_1CIA");
    AddNote("", "P_2_1_1_CIA_Comms", "Note_0068L", "Localization\\P_2_1_1CIA");
    Speech(Localize("P_2_1_1_CIA_Comms", "Speech_0024L", "Localization\\P_2_1_1CIA"), Sound'S2_1_1Voice.Play_21_20_01', 0, 2, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_1_CIA_Comms", "Speech_0059L", "Localization\\P_2_1_1CIA"), Sound'S2_1_1Voice.Play_21_20_02', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_1_CIA_Comms", "Speech_0063L", "Localization\\P_2_1_1CIA"), Sound'S2_1_1Voice.Play_21_20_03', 2, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_2_1_1_CIA_Comms", "Speech_0064L", "Localization\\P_2_1_1CIA"), Sound'S2_1_1Voice.Play_21_20_04', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    CheckFlags(V2_1_1CIA(Level.VarObject).F2000get,FALSE,'End');
    SendUnrealEvent('PanelToNextStage');
    End();
GunGet:
    Log("GunGet");
    SetFlags(V2_1_1CIA(Level.VarObject).F2000get,TRUE);
    GoalCompleted('GoalF2000');
    CheckFlags(V2_1_1CIA(Level.VarObject).ServerDone,FALSE,'End');
    SendUnrealEvent('PanelToNextStage');
End:
    End();

}

