//=============================================================================
// P_2_1_2_CIA_Mitch_Is_Nuts
//=============================================================================
class P_2_1_2_CIA_Mitch_Is_Nuts extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int coladone;
var int pass1;
var int pass2;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('WentHiding');
            break;
        case AI_DEAD:
            EventJump('Grab');
            break;
        case AI_GRABBED:
            EventJump('Grab');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('WentHiding');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('WentHiding');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('WentHiding');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('WentHiding');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('WentHiding');
            break;
        case AI_UNCONSCIOUS:
            EventJump('Grab');
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
        if (P.name == 'EMitch7')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
        if (P.name == 'ECIABureaucrat45')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    coladone=0;
    pass1=0;
    pass2=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
start2125:
    Log("Mitch gets up and walks to printer.");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'EMitch_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Patrol,8,,,,'EMitch_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
mitch_no_move:
    End();
ChatStart:
    Log("Don and Mitch start to chit-chat");
    CheckFlags(V2_1_2CIA(Level.VarObject).MichWentHiding,TRUE,'JumpFin');
    ResetGoals(1);
    Goal_Default(1,GOAL_Patrol,1,,,,'Mitch_two_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,'donwait','donwait','PathNode18',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Action,8,,'donwait','donwait',,'TalkStNmCC0',FALSE,,,,);
    Goal_Default(1,GOAL_Wait,7,,,,'donwait','LstnStNmBB0',FALSE,,,,);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,'PathNode18',,'donwait',,TRUE,,,,);
    Goal_Default(2,GOAL_Wait,8,,'EMitch7','EMitch7','donwait','TalkStNmAAC',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_40_01', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,'EMitch7','EMitch7',,'SpilStNmNtC',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_40_02', 2, , TRUE, 0);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,'donwait','donwait',,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_40_03', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,'EMitch7','EMitch7',,'TalkStNmBBC',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_40_04', 2, , TRUE, 0);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,'donwait','donwait',,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_40_05', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,'EMitch7','EMitch7',,'TalkStNmBBC',FALSE,,,,);
    Goal_Set(2,GOAL_Action,8,,'EMitch7','EMitch7',,'SpilStNmNtC',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_40_06', 2, , TRUE, 0);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,'donwait','donwait',,'TalkStNmBB0',FALSE,,,,);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,'EMitch7','EMitch7',,'DrnkStNmUpC',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_40_07', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,'EMitch7','EMitch7',,'TalkStNmBBC',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_40_08', 2, , TRUE, 0);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,'donwait','donwait',,'LstnStNmBB0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,8,,'donwait','donwait',,'LstnStNmBB0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,7,,'donwait','donwait',,'TalkStNmBB0',FALSE,,,,);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,'EMitch7','EMitch7',,'DrnkStNmUpC',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_40_09', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_40_10', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_40_11', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,'EMitch7','EMitch7',,'SpilStNmNtC',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_40_12', 2, , TRUE, 0);
    Close();
    ResetGoals(1);
    Goal_Default(1,GOAL_Patrol,9,,,,'Mitch_two_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(3);
    Goal_Set(2,GOAL_MoveTo,9,,,,'ToiletPAtrolH',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,8,,,,'BookLookA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Wait,7,,,,'EFocusPointBooks',,FALSE,,,,);
    End();
Grab:
    Log("");
    CheckIfIsDead(1,'DoughKilled');
    CheckIfGrabbed(1,'GrabContinue');
    CheckIfIsUnconscious(1,'GrabContinue');
    End();
GrabContinue:
    Log("GrabContinue");
    SetFlags(V2_1_2CIA(Level.VarObject).MichWentHiding,TRUE);
    CheckFlags(pass2,TRUE,'JumpFin');
    SetFlags(pass2,TRUE);
    SendPatternEvent('Comms','MitchKO');
    End();
JumpFin:
    Log("");
    End();
ColaWait:
    Log("");
    CheckFlags(V2_1_2CIA(Level.VarObject).MichWentHiding,TRUE,'JumpFin');
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode120',,FALSE,,,,);
    Goal_Set(1,GOAL_MoveTo,8,,,,'PathNode119',,FALSE,,,,);
    Goal_Set(1,GOAL_Action,7,,,,,'DispStNmBg0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,6,,,,,'DispStNmOn0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,5,,,,,'DispStNmEd0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,4,,,,,'DispStNmAA0',FALSE,,,,);
    Goal_Default(1,GOAL_Wait,3,,,,,'DispStNmBB0',FALSE,,,,);
    End();
ColaAction:
    Log("ColaAction");
    CheckFlags(V2_1_2CIA(Level.VarObject).MichWentHiding,TRUE,'JumpFin');
    CheckFlags(V2_1_2CIA(Level.VarObject).mitchcomp,FALSE,'JumpFin');
    CheckFlags(coladone,TRUE,'JumpFin');
    SetFlags(coladone,TRUE);
    SendUnrealEvent('DeleteVolumeCola');
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'EMitch_800',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Patrol,8,,,,'EMitch_800',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
WentHiding:
    Log("WentHiding");
    CheckFlags(V2_1_2CIA(Level.VarObject).MichWentHiding,TRUE,'JumpFin');
    SetFlags(V2_1_2CIA(Level.VarObject).MichWentHiding,TRUE);
    End();
DoughKilled:
    Log("DoughKilled");
    SendPatternEvent('Comms','FromWilkesAndBaxterKO');
    End();
InSmokingZone:
    Log("InSmokingZone");
    SetFlags(V2_1_2CIA(Level.VarObject).MitchReachSmoke,TRUE);
    End();
EarlyFudge:
    Log("EarlyFudge");
    CheckFlags(V2_1_2CIA(Level.VarObject).MichWentHiding,FALSE,'JumpFin');
    ePawn(Characters[1].Pawn).Bark_Type = BARK_BegForLife;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    SendPatternEvent('EGroupAI2','FromEarlyFudge');
    SendPatternEvent('StorageGroup','AlsoFromEarlyFudge');
    End();

}

