//=============================================================================
// P_4_3_2_FeirongEnding
//=============================================================================
class P_4_3_2_FeirongEnding extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int BarkA;
var int BarkB;
var int BarkC;
var int BarkD;
var int BarkE;
var int FeinrongTalksDone;
var int FeirongTalkOver;
var int FeirongTalksBDone;
var int FeirongTalksCDone;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('FeirongDied');
            break;
        case AI_UNCONSCIOUS:
            EventJump('FeirongDied');
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
        if (P.name == 'EFeirong0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    BarkA=0;
    BarkB=0;
    BarkC=0;
    BarkD=0;
    BarkE=0;
    FeinrongTalksDone=0;
    FeirongTalkOver=0;
    FeirongTalksBDone=0;
    FeirongTalksCDone=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
SamInTheHouse:
    Log("When Sam approaches Feirong");
    PlayerMove(false);
    CinCamera(0, 'FeirongEndingPosition01', 'FeirongEndingTarget01',);
    Talk(Sound'S4_3_2Voice.Play_43_44_01', 1, , TRUE, 0);
    CinCamera(1, , ,);
    CinCamera(0, 'FeirongEndingPosition02', 'FeirongEndingTarget01',);
    Talk(Sound'S4_3_2Voice.Play_43_44_02', 0, , TRUE, 0);
    Goal_Set(1,GOAL_Wait,9,,'PLAYER','PLAYER','FeirongChair','FeirAsNmAA0',FALSE,3.5,MOVE_WalkRelaxed,,MOVE_Sit);
    Talk(Sound'S4_3_2Voice.Play_43_45_01', 1, , TRUE, 0);
    ResetGoals(1);
    Close();
    CinCamera(1, , ,);
    PlayerMove(true);
    Goal_Set(1,GOAL_MoveTo,9,,,,'FeirongEndingNode04',,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,'FeirStNmSh0',FALSE,3,,,);
    WaitForGoal(1,GOAL_Attack,);
    Goal_Set(1,GOAL_Action,9,,,,,'FeirStNmDk0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Default(1,GOAL_Guard,9,,'PLAYER','PLAYER','FeirongEndingNode04',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S4_3_2Voice.Play_43_45_02', 1, , TRUE, 0);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,'FeirStNmSh0',FALSE,3,,,);
    WaitForGoal(1,GOAL_Attack,);
    Goal_Set(1,GOAL_Action,9,,,,,'FeirStNmDk0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Talk(Sound'S4_3_2Voice.Play_43_45_03', 1, , TRUE, 0);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,'FeirStNmSh0',FALSE,3,,,);
    WaitForGoal(1,GOAL_Attack,);
    Goal_Set(1,GOAL_Action,9,,,,,'FeirStNmDk0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Talk(Sound'S4_3_2Voice.Play_43_45_04', 1, , TRUE, 0);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,'FeirStNmSh0',FALSE,3,,,);
    WaitForGoal(1,GOAL_Attack,);
    Goal_Set(1,GOAL_Action,9,,,,,'FeirStNmDk0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Talk(Sound'S4_3_2Voice.Play_43_45_05', 1, , TRUE, 0);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,'FeirStNmSh0',FALSE,3,,,);
    WaitForGoal(1,GOAL_Attack,);
    Goal_Set(1,GOAL_Action,9,,,,,'FeirStNmDk0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Talk(Sound'S4_3_2Voice.Play_43_45_06', 1, , TRUE, 0);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,'FeirStNmSh0',FALSE,3,,,);
    WaitForGoal(1,GOAL_Attack,);
    Goal_Set(1,GOAL_Action,9,,,,,'FeirStNmDk0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Talk(Sound'S4_3_2Voice.Play_43_45_07', 1, , TRUE, 0);
    Close();
    Jump('FeirongBarks');
    End();
FeirongCycle:
    Log("Cycles a few anims after Feirong finishes talking");
    Goal_Set(1,GOAL_Action,9,,'PLAYER','PLAYER',,'4360fei6',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,9,,,,,'4360fei5',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Jump('FeirongCycle');
    End();
FeirongOnTheKeyboard:
    Log("FeirongOnTheKeyboard");
    Sleep(5);
    SendUnrealEvent('ESam');
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).FeirongObjectiveDone,TRUE);
    SetFlags(V4_3_2ChineseEmbassy(Level.VarObject).FeirongCanDie,TRUE);
    DisableMessages(TRUE, TRUE);
    KillNPC(1, FALSE, FALSE);
    Sleep(3);
    SendPatternEvent('LambertComms','FeirongFiles');
    End();
FeirongBarks:
    Log("FeirongBarks");
BarkA:
    Log("BarkA");
    CheckFlags(BarkA,TRUE,'BarkB');
    Talk(Sound'S4_3_2Voice.Play_43_45_08', 1, , TRUE, 0);
    Close();
    SetFlags(BarkA,TRUE);
    End();
BarkB:
    Log("BarkB");
    CheckFlags(BarkB,TRUE,'BarkC');
    Talk(Sound'S4_3_2Voice.Play_43_45_09', 1, , TRUE, 0);
    Close();
    SetFlags(BarkB,TRUE);
    End();
BarkC:
    Log("BarkC");
    CheckFlags(BarkC,TRUE,'BarkD');
    Talk(Sound'S4_3_2Voice.Play_43_45_10', 1, , TRUE, 0);
    Close();
    SetFlags(BarkC,TRUE);
    End();
BarkD:
    Log("BarkD");
    CheckFlags(BarkD,TRUE,'BarkE');
    Talk(Sound'S4_3_2Voice.Play_43_45_11', 1, , TRUE, 0);
    Close();
    SetFlags(BarkD,TRUE);
    End();
BarkE:
    Log("BarkE");
    CheckFlags(BarkE,TRUE,'BarkF');
    Talk(Sound'S4_3_2Voice.Play_43_45_12', 1, , TRUE, 0);
    Close();
    SetFlags(BarkE,TRUE);
    End();
BarkF:
    Log("BarkF");
    Talk(Sound'S4_3_2Voice.Play_43_45_13', 1, , TRUE, 0);
    Close();
    Jump('FeirongCycle');
    End();
FeirongDied:
    Log("Check if Feirong can die, if not, Game over");
    CheckFlags(V4_3_2ChineseEmbassy(Level.VarObject).FeirongCanDie,TRUE,'EndAll');
    SendPatternEvent('LambertComms','GenericFail');
EndAll:
    End();

}

