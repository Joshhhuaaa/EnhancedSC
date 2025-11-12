//=============================================================================
// P_5_2_GoalUpdate
//=============================================================================
class P_5_2_GoalUpdate extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S5_1_2Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S5_1_Voice.uax

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

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
UnrealElevOff:
    Log("UnrealElevOff");
    SendUnrealEvent('EElevatorPanelBroked');
    End();
NikoKillOrder:
    Log("NikoKillOrder");
    DisableMessages(TRUE, TRUE);
    SetFlags(V5_1_2_PresidentialPalace(Level.VarObject).ArkObtained,TRUE);
    SendUnrealEvent('BustedDoor1');
    SendUnrealEvent('BustedDoor2');
    GoalCompleted('NoKill');
    AddGoal('5_1_6', "", 1, "", "P_5_2_GoalUpdate", "Goal_0023L", "Localization\\P_5_1_2_PresidentialPalace", "P_5_2_GoalUpdate", "Goal_0024L", "Localization\\P_5_1_2_PresidentialPalace");
    Speech(Localize("P_5_2_GoalUpdate", "Speech_0008L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_60_01', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_5_2_GoalUpdate", "Speech_0009L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_60_02', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_5_2_GoalUpdate", "Speech_0010L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_2Voice.Play_51_60_03', 1, 0, TR_HEADQUARTER, 0, false);
    Close();
    Sleep(1);
    SendPatternEvent('Emi1','Milestone');
    DisableMessages(FALSE, FALSE);
    End();
PureMadness:
    Log("PureMadness");
    CheckFlags(V5_1_2_PresidentialPalace(Level.VarObject).NikoDEAD,TRUE,'End');
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    PlayerMove(false);
    Speech(Localize("P_5_2_GoalUpdate", "Speech_0014L", "Localization\\P_5_1_2_PresidentialPalace"), Sound'S5_1_Voice.Play_51_95_01', 1, 0, TR_HEADQUARTER, 0, true);
    Close();
fallingMissedJump:
    SetProfileDeletion();
    GameOver(false, 0);
End:
    End();

}

