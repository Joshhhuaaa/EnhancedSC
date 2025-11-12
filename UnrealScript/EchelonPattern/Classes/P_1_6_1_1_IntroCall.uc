//=============================================================================
// P_1_6_1_1_IntroCall
//=============================================================================
class P_1_6_1_1_IntroCall extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_2Voice.uax

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
    local Actor A;

    Super.InitPattern();

    ForEach DynamicActors(class'Pawn', P)
    {
        if (P.name == 'EMasse0')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKill = true;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if (P.name == 'EAleksee0')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
        }
    }

    // Joshua - Fixing collision on some pipes that were not set correctly
    ForEach AllActors(class'Actor', A)
    {
        if (A.name == 'StaticMeshActor128')
            A.SetCollisionPrim(StaticMesh(DynamicLoadObject("6_1_1KolaMesh.Collision.pipes_sk2_COL", class'StaticMesh')));
        if (A.name == 'StaticMeshActor180')
            A.SetCollisionPrim(StaticMesh(DynamicLoadObject("6_1_1KolaMesh.Collision.pipes_sk2_COL", class'StaticMesh')));
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
MilestoneIntroCall:
    Log("MilestoneIntroCall");
    Speech(Localize("P_1_6_1_1_IntroCall", "Speech_0007L", "Localization\\P_1_6_1_1KolaCell"), Sound'S3_4_2Voice.Play_34_34_01', 2, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_6_1_1_IntroCall", "Speech_0008L", "Localization\\P_1_6_1_1KolaCell"), Sound'S3_4_2Voice.Play_34_34_02', 0, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_6_1_1_IntroCall", "Speech_0009L", "Localization\\P_1_6_1_1KolaCell"), Sound'S3_4_2Voice.Play_34_34_03', 2, 0, TR_HEADQUARTER, 0, false);
    Close();
    AddRecon(class 'EReconPicMasse');
    AddRecon(class 'EReconFullTextMasse');
    AddGoal('Server', "", 5, "", "P_1_6_1_1_IntroCall", "Goal_0003L", "Localization\\P_1_6_1_1KolaCell", "P_1_6_1_1_IntroCall", "Goal_0004L", "Localization\\P_1_6_1_1KolaCell");
    AddGoal('PC', "", 6, "", "P_1_6_1_1_IntroCall", "Goal_0010L", "Localization\\P_1_6_1_1KolaCell", "P_1_6_1_1_IntroCall", "Goal_0011L", "Localization\\P_1_6_1_1KolaCell");
    AddGoal('Kill', "", 7, "", "P_1_6_1_1_IntroCall", "Goal_0012L", "Localization\\P_1_6_1_1KolaCell", "P_1_6_1_1_IntroCall", "Goal_0013L", "Localization\\P_1_6_1_1KolaCell");
    AddNote("", "P_1_6_1_1_IntroCall", "Note_0014L", "Localization\\P_1_6_1_1KolaCell");
    Sleep(5);
    SendPatternEvent('GroupServerSweep','IntroOn');
    End();
FunkLights:
    Log("FunkLights");
    SendUnrealEvent('FunkA');
    Sleep(0.25);
    SendUnrealEvent('FunkB');
    Sleep(0.25);
    SendUnrealEvent('FunkC');
    Sleep(0.25);
    SendUnrealEvent('FunkD');
    Sleep(0.25);
    SendUnrealEvent('FunkE');
    Sleep(0.25);
    SendUnrealEvent('FunkF');
    Sleep(0.25);
    SendUnrealEvent('FunkG');
    Sleep(0.25);
    SendUnrealEvent('FunkH');
    End();
RetinalDone:
    Log("RetinalDone");
    GoalCompleted('Retinal');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).RetinalObj,TRUE);
    End();
CodeDone:
    Log("CodeDone");
    CheckIfGrabbed(1,'CodeReallyDone');
nobugthere:
    Log("nobugthere");
    Sleep(2);
    SendUnrealEvent('ESam');
    End();
CodeReallyDone:
    Log("CodeReallyDone");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).PCObj,TRUE,'nobugthere');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).PCObj,TRUE);
    SendPatternEvent('MasseGroup','Bark');
    GoalCompleted('PC');
    SendPatternEvent('BallroomFight','MilestoneBallroom');
    Sleep(2);
    SendPatternEvent('MasseGroup','NikolaiAttack');
    SendUnrealEvent('ESam');
    End();
ExtractionGoal:
    Log("ExtractionGoal");
    AddGoal('Exit', "", 1, "", "P_1_6_1_1_IntroCall", "Goal_0005L", "Localization\\P_1_6_1_1KolaCell", "P_1_6_1_1_IntroCall", "Goal_0006L", "Localization\\P_1_6_1_1KolaCell");
    IgnoreAlarmStage(TRUE);
    SendUnrealEvent('extractmover');
    SendPatternEvent('Last','MilestoneLast');
    SendPatternEvent('BeforeLast','MilestoneBeforeLast');
    End();
YouMadeIt:
    Log("YouMadeIt");
    GameOver(true, 0);
    End();
PreServerAlarmFromLaser:
    Log("PreServerAlarmFromLaser");
    SendUnrealEvent('Vanish');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).PreServerLazer,FALSE);
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).ServerObj,TRUE,'End');
    StartAlarm('thealarm',1);
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).ServerDoorClosed,TRUE,'End');
    SendUnrealEvent('servertrapdoor');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).ServerDoorClosed,TRUE);
    End();
LazerzDoor:
    Log("LazerzDoor");
    SendUnrealEvent('FirstLazerz');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).FirstLazer,FALSE);
    Sleep(1);
    SendUnrealEvent('BigDoorsTest');
    SendUnrealEvent('InDoorLight');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).BigDoorInOpen,FALSE);
    SendPatternEvent('Last','BigDoorInSound');
    End();
Lazerz:
    Log("Lazerz");
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).Lazerz,FALSE);
    SendUnrealEvent('ImpossibleLazerz');
    SendPatternEvent('GroupBasementAmbush','MilestoneBasementAmbush');
    End();
OutDoorKbrd:
    Log("OutDoorKbrd");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).BigDoorOutOpen,TRUE,'End');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).BigDoorOutOpen,TRUE);
    SendUnrealEvent('BigDoorsTestOut');
    SendUnrealEvent('OutDoorLight');
    SendPatternEvent('BeforeLast','BigDoorOutSound');
    End();
PreServerAlarm:
    Log("PreServerAlarm");
    CheckFlags(V1_6_1_1KolaCell(Level.VarObject).ServerDoorClosed,TRUE,'End');
    SendUnrealEvent('servertrapdoor');
    SetFlags(V1_6_1_1KolaCell(Level.VarObject).ServerDoorClosed,TRUE);
End:
    End();

}

defaultproperties
{
}
