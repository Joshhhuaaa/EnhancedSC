//=============================================================================
// P_1_2_1DefMin_GrinkoMasse
//=============================================================================
class P_1_2_1DefMin_GrinkoMasse extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S1_2_1Voice.uax
#exec OBJ LOAD FILE=..\Sounds\S1_1_Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int ElevLaserMicUnderway;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('TheyDetectYouSomehow');
            break;
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
        if (P.name == 'EGrinko0')
            Characters[1] = P.controller;
        if (P.name == 'EMasse0')
            Characters[2] = P.controller;
        if (P.name == 'ELambert0')
            Characters[3] = P.controller;
        if (P.name == 'EAnna0')
            Characters[4] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    ElevLaserMicUnderway=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("MilestoneGrinkoMasse");
    CheckFlags(V1_2_1DefenseMinistry(Level.VarObject).LaserDown,FALSE,'End');
    Teleport(1, 'PathNodeGTel');
    Teleport(2, 'PathNodeMTel');
    Sleep(0.50);
    SendPatternEvent('CoutyardTeam','BustsIn');
    CinCamera(0, 'GMpos', 'GMfoc',);
    SendUnrealEvent('DoorToGlass');
    Goal_Set(1,GOAL_MoveTo,9,,,,'ElevOne',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Guard,8,,'ElevTwo','ElevTwo','ElevOne',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_MoveTo,9,,,,'ElevTwo',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_Guard,8,,'ElevOne','ElevOne','ElevTwo',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(6);
    SendUnrealEvent('GlassElevGO');
    SendUnrealEvent('GlassElevGOHidden');
    ResetGoals(1);
    Goal_Default(1,GOAL_Wait,9,,'ElevTwo','ElevTwo',,'LstnStNmAA0',FALSE,,,,);
    Sleep(1.50);
    ResetGoals(2);
    Goal_Default(2,GOAL_Wait,9,,'ElevOne','ElevOne',,'TalkStNmBB0',FALSE,,,,);
    Sleep(2);
    CinCamera(1, 'GMpos', 'GMfoc',);
    Sleep(1);
    Speech(Localize("P_1_2_1DefMin_GrinkoMasse", "Speech_0009L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_26_01', 4, 0, TR_HEADQUARTER, 0, false);
    Speech(Localize("P_1_2_1DefMin_GrinkoMasse", "Speech_0010L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_2_1Voice.Play_12_26_02', 3, 0, TR_HEADQUARTER, 0, false);
    Close();
    Sleep(1);
    LaserMicSession(0,'GlassElevGO',0,'');
    Talk(Sound'S1_2_1Voice.Play_12_30_01', 2, , TRUE, 5);
    Talk(Sound'S1_2_1Voice.Play_12_30_02', 1, , TRUE, 5);
    Talk(Sound'S1_2_1Voice.Play_12_30_03', 2, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_30_04', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_30_05', 2, , TRUE, 10);
    Talk(Sound'S1_2_1Voice.Play_12_30_06', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_30_07', 2, , TRUE, 10);
    Talk(Sound'S1_2_1Voice.Play_12_30_08', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_30_09', 2, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_30_10', 1, , TRUE, 0);
    Talk(Sound'S1_2_1Voice.Play_12_30_11', 2, , TRUE, 70);
    SendUnrealEvent('DoorFromGlass');
    Goal_Set(1,GOAL_MoveTo,9,,,,'GMEnd',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,,,'GMEnd',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,,,'GMEnd',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,,,'GMEnd',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
JumpHereLaserMicFuck:
    Log("JumpHereLaserMicFuck");
    Close();
    LaserMicSession(1,,70,'LambertProud');
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    IgnoreAlarmStage(TRUE);
    ResetGoals(1);
    ResetGoals(2);
    Goal_Default(1,GOAL_Wait,9,,'PLAYER','PLAYER',,'ReacStAlFd0',FALSE,,,,);
    Goal_Default(2,GOAL_Wait,9,,'PLAYER','PLAYER',,'PrsoCrAlBB0',FALSE,,,,);
    PlayerMove(false);
    Speech(Localize("P_1_2_1DefMin_GrinkoMasse", "Speech_0001L", "Localization\\P_1_2_1DefenseMinistry"), Sound'S1_1_Voice.Play_11_95_01', 3, 0, TR_HEADQUARTER, 0, true);
    Close();
    GameOver(false, 6);
    End();
LambertProud:
    Log("LambertProud");
    DisableMessages(TRUE, TRUE);
    SendPatternEvent('PostElevLamb','Milestone');
    AddNote("", "P_1_2_1DefMin_GrinkoMasse", "Note_0011L", "Localization\\P_1_2_1DefenseMinistry");
    GoalCompleted('1_2_4');
    End();
TheyDetectYouSomehow:
    Log("TheyDetectYouSomehow");
    Jump('JumpHereLaserMicFuck');
End:
    End();

}

