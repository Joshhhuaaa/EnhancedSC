//=============================================================================
// P_1_2_1DefMin_PostElevLambert
//=============================================================================
class P_1_2_1DefMin_PostElevLambert extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_1Voice.uax

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
Milestone:
    Log("MilestonePostElevLambert");
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).LaserMicDone,TRUE);
    //SetAlarmStage(0); // Joshua - Using new bOneAlarmLevel flag instead
    EchelonLevelInfo(Level).bOneAlarmLevel = false;
    Sleep(1);
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).TooFastLaserMic,FALSE,'NotAlreadyInNorth');
AlreadyInNorth:
    Log("AlreadyInNorth");
    PlayerMove(false);
NotAlreadyInNorth:
    Log("NotAlreadyInNorth");
    GoalCompleted('1_2_11');
    AddGoal('North', "", 3, "", "P_1_2_1DefMin_PostElevLambert", "Goal_0010L", "Localization\\P_1_2_1DefenseMinistry", "P_1_2_1DefMin_PostElevLambert", "Goal_0011L", "Localization\\P_1_2_1DefenseMinistry");
    AddGoal('1_2_6', "", 4, "", "P_1_2_1DefMin_PostElevLambert", "Goal_0012L", "Localization\\P_1_2_1DefenseMinistry", "P_1_2_1DefMin_PostElevLambert", "Goal_0013L", "Localization\\P_1_2_1DefenseMinistry");
    Speech(Localize("P_1_2_1DefMin_PostElevLambert", "Speech_0001L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_35_01', 1, 1, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_2_1DefMin_PostElevLambert", "Speech_0004L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_35_02', 0, 0, TR_CONVERSATION, 0, false);
    SendPatternEvent('CourtyardTeam','MilestoneCourtPatrols');
    Speech(Localize("P_1_2_1DefMin_PostElevLambert", "Speech_0005L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_35_03', 1, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_2_1DefMin_PostElevLambert", "Speech_0006L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_35_04', 0, 0, TR_CONVERSATION, 0, false);
    Speech(Localize("P_1_2_1DefMin_PostElevLambert", "Speech_0007L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_35_05', 1, 2, TR_HEADQUARTER, 0, false);
    Close();
    SetFlags(V1_2_1DefenseMinistry(Level.VarObject).LambertPostLaserSpoken,TRUE);
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).TooFastLaserMic,TRUE,'JumpEarlyNextLevelDamm');
    End();
JumpEarlyNextLevelDamm:
    Log("JumpEarlyNextLevelDamm");
    LevelChange("1_2_2DefenseMinistry");
    End();

}

