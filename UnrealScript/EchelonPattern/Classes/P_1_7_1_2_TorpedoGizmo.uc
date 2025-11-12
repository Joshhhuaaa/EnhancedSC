//=============================================================================
// P_1_7_1_2_TorpedoGizmo
//=============================================================================
class P_1_7_1_2_TorpedoGizmo extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_3Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S5_1_2Voice.uax

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
        if (P.name == 'EFalseRussianSoldier1')
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
InTorpedoGizmo:
    Log("InTorpedoGizmo");
    SendUnrealEvent('TorpedoCriticalHatch');
    SendUnrealEvent('TorpedoLaunch');
    SendPatternEvent('LambertGoals','CompleteLambertGoals');
    End();
DoorEventTorpedoGizmo:
    Log("DoorEventTorpedoGizmo");
    SendUnrealEvent('DoorClosesOnYouA');
    End();
SpeechTorpedoGizmo:
    Log("SpeechTorpedoGizmo");
    SendUnrealEvent('TorpedoLaunch');
    SendPatternEvent('BreachTeam','MilestoneBreachTeam');
    Speech(Localize("P_1_7_1_2_TorpedoGizmo", "Speech_0001L", "Localization\\P_1_7_1_2Vselka"), Sound'S3_4_3Voice.Play_34_61_11', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_7_1_2_TorpedoGizmo", "Speech_0002L", "Localization\\P_1_7_1_2Vselka"), Sound'S5_1_2Voice.Play_51_85_02', 0, 0, TR_CONVERSATION, 0, false);
    Close();
    End();
DoorEventBTorpedoGizmo:
    Log("DoorEventBTorpedoGizmo");
    SendUnrealEvent('DoorClosesOnYouB');
    End();
GoalOneTorpedoGizmo:
    Log("GoalOneTorpedoGizmo");
    GoalCompleted('LOCK');
    SendUnrealEvent('LowerDecksDoor');
    End();

}

defaultproperties
{
}
