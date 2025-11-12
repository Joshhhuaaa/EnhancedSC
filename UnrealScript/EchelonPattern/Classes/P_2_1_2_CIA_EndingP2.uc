//=============================================================================
// P_2_1_2_CIA_EndingP2
//=============================================================================
class P_2_1_2_CIA_EndingP2 extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int HearAlerted;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('ShootAt');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('ShootAt');
            break;
        case AI_UNCONSCIOUS:
            EventJump('ShootAt');
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
        if (P.name == 'EWilkes0')
            Characters[1] = P.controller;
        if (P.name == 'EBaxter2')
            Characters[2] = P.controller;
        if (P.name == 'ECIASecurity14')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    HearAlerted=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
PlayDum:
    Log("PlayDum");
    ResetGroupGoals();
    Goal_Default(1,GOAL_Wait,9,,,,,,FALSE,,,,);
    Goal_Default(2,GOAL_Wait,9,,,,,,FALSE,,,,);
    End();
ShootAt:
    Log("ShootAt");
    Close();
    SendPatternEvent('Comms','FromWilkesAndBaxterKO');
    SetExclusivity(FALSE);
    ResetGoals(1);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'baxterpanikA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Guard,8,,,,'baxterpanikA',,FALSE,,,,);
    Goal_Set(1,GOAL_MoveTo,9,,,,'wilkespanikA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Guard,8,,,,'wilkespanikA',,FALSE,,,,);
    End();
SamThere:
    Log("SamThere");
    CheckFlags(V2_1_2CIA(Level.VarObject).CopOut,FALSE,'JumpFin');
CopGrabbed:
    Log("CopGrabbed");
    CheckFlags(V2_1_2CIA(Level.VarObject).WelcomeDone,TRUE,'JumpFin');
    SetFlags(V2_1_2CIA(Level.VarObject).WelcomeDone,TRUE);
    CheckFlags(V2_1_2CIA(Level.VarObject).MitchThere,TRUE,'with');
without:
    Log("Flag  without Dough");
    SetFlags(V2_1_2CIA(Level.VarObject).InWelcome,TRUE);
    ResetGoals(1);
    ChangeState(1,'s_default');
    Goal_Set(1,GOAL_Action,9,,,,,'OpenStNmUp0',FALSE,,,,);
    SendUnrealEvent('UPS1');
    Goal_Set(1,GOAL_MoveTo,8,,,,'PathNode65',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,7,,'PLAYER','PLAYER','PathNode65',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S2_1_2Voice.Play_21_45_20', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_21', 2, , TRUE, 0);
    ResetGoals(2);
    ChangeState(2,'s_default');
    Goal_Set(2,GOAL_MoveTo,9,,'EFocusPoint4',,'PathNode64',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'PLAYER',,'PathNode64',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S2_1_2Voice.Play_21_45_22', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_23', 0, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_24', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_25', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_26', 0, , TRUE, 0);
    Close();
    Goal_Default(1,GOAL_Wait,5,,,,,,FALSE,,,,);
    SetFlags(V2_1_2CIA(Level.VarObject).InWelcome,FALSE);
    CheckFlags(V2_1_2CIA(Level.VarObject).PutINafterWelcome,TRUE,'DropMitch');
    End();
with:
    Log("flag with Dough");
    SetFlags(V2_1_2CIA(Level.VarObject).InWelcome,TRUE);
    ResetGoals(1);
    ChangeState(1,'s_default');
    Goal_Set(1,GOAL_Action,9,,,,,'OpenStNmUp0',FALSE,,,,);
    SendUnrealEvent('UPS1');
    Goal_Set(1,GOAL_MoveTo,8,,,,'PathNode65',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Guard,7,,'PLAYER','PLAYER','PathNode65',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S2_1_2Voice.Play_21_45_27', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_28', 2, , TRUE, 0);
    ResetGoals(2);
    ChangeState(2,'s_default');
    Goal_Set(2,GOAL_MoveTo,9,,'EFocusPoint4',,'PathNode64',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'PLAYER',,'PathNode64',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S2_1_2Voice.Play_21_45_29', 1, , TRUE, 0);
    SendUnrealEvent('UPS1');
    Talk(Sound'S2_1_2Voice.Play_21_45_30', 0, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_31', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_32', 0, , TRUE, 0);
    Close();
    SetFlags(V2_1_2CIA(Level.VarObject).InWelcome,FALSE);
    CheckFlags(V2_1_2CIA(Level.VarObject).PutINafterWelcome,TRUE,'DropMitch');
    End();
JumpFin:
    Log("JumpFin");
    End();
ChatChat:
    Log("ChatChat");
    CheckFlags(V2_1_2CIA(Level.VarObject).DickIsTeled,FALSE,'JumpFin');
    CheckFlags(V2_1_2CIA(Level.VarObject).DickIsAlert,TRUE,'JumpFin');
    CheckFlags(V2_1_2CIA(Level.VarObject).CopOut,TRUE,'JumpFin');
    CheckFlags(V2_1_2CIA(Level.VarObject).ConversationOver,TRUE,'JumpFin');
    Talk(Sound'S2_1_2Voice.Play_21_45_01', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmCC0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_45_02', 1, , TRUE, 0);
    ResetGoals(3);
    Goal_Set(3,GOAL_Action,9,,,,,'TalkStNmDD0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_45_03', 3, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_04', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_05', 3, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_06', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_07', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,,,,'LstnStNmAA0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_45_08', 3, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_09', 2, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_10', 1, , TRUE, 0);
    ResetGoals(2);
    Goal_Set(2,GOAL_Action,9,,,,,'TalkStNmBB0',FALSE,,,,);
    Goal_Set(1,GOAL_Action,8,,,,,'TalkStNmCC0',FALSE,,,,);
    ResetGoals(3);
    Goal_Default(3,GOAL_Wait,9,,,,,'LstnStNmBB0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_45_11', 2, , TRUE, 0);
    ResetGoals(3);
    Goal_Set(3,GOAL_Action,9,,,,,'TalkStNmAA0',FALSE,,,,);
    Talk(Sound'S2_1_2Voice.Play_21_45_12', 3, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_13', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_45_14', 2, , TRUE, 0);
    SetFlags(V2_1_2CIA(Level.VarObject).ConversationOver,TRUE);
    Close();
    End();
CopAlerted:
    Log("CopAlerted");
    Close();
    SetFlags(V2_1_2CIA(Level.VarObject).ConversationOver,TRUE);
    CheckFlags(HearAlerted,TRUE,'DoNothing');
    SetFlags(HearAlerted,TRUE);
    Talk(Sound'S2_1_2Voice.Play_21_44_01', 3, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_44_02', 1, , TRUE, 0);
    Close();
IfHearBefore:
    Log("IfHearBefore");
    DisableMessages(FALSE, TRUE);
    Close();
    SendPatternEvent('EGroupAI1','RunToIT');
    Goal_Set(1,GOAL_Wait,9,,,,,'PrsoCrAlCC0',FALSE,,,,);
    Goal_Set(2,GOAL_Wait,9,,,,,'PrsoCrAlBB0',FALSE,,,,);
    Sleep(1);
    Talk(Sound'S2_1_2Voice.Play_21_44_04', 1, , TRUE, 0);
    Close();
    DisableMessages(FALSE, FALSE);
    End();
DoNothing:
    Log("Do Nothing");
    End();
FinalFin:
    Log("FinalFin");
    DisableMessages(TRUE, TRUE);
    PlayerMove(false);
    ResetGoals(1);
    Goal_Default(1,GOAL_Wait,9,,'PLAYER','PLAYER',,'LstnStNmAA0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Talk(Sound'S2_1_2Voice.Play_21_60_01', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_60_02', 0, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_60_03', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_60_04', 0, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_60_05', 1, , TRUE, 0);
    Talk(Sound'S2_1_2Voice.Play_21_60_06', 0, , TRUE, 0);
    Close();
    GameOver(true, 0);
    End();
DropMitch:
    Log("DropMitch");
    Talk(Sound'S2_1_2Voice.Play_21_46_01', 2, , TRUE, 0);
    Close();
    End();
StopPatternItsOver:
    Log("StopPatternItsOver");
    Close();
    DisableMessages(TRUE, TRUE);
    End();
TelGuys:
    Log("TelGuys");
    Teleport(1, 'Wilksyway');
    Teleport(2, 'Baxterway');
    ResetGoals(1);
    ResetGoals(2);
    Goal_Default(1,GOAL_Wait,9,,,,'CIAdickPos','LeanStNmAA0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,9,,'CIAdickPos','CIAdickPos','Baxterway',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
OnlyGrabbed:
    Log("OnlyGrabbed");
    ePawn(Characters[2].Pawn).Bark_Type = BARK_NormalGreeting;
    Talk(ePawn(Characters[2].Pawn).Sounds_Barks, 2, 0, false);
    End();

}

