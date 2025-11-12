//=============================================================================
// P_2_1_2_CIA_EndingP3
//=============================================================================
class P_2_1_2_CIA_EndingP3 extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int MitchThere;
var int Pass1;
var int RunningToIt;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_GRABBED:
            EventJump('GrabbedBarks');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('StopConveration');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('StopConveration');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('StopConveration');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
            break;
        case AI_UNCONSCIOUS:
            EventJump('CopDown');
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
        if (P.name == 'ECIASecurity14')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
        }
        if (P.name == 'EMitch7')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    MitchThere=0;
    Pass1=0;
    RunningToIt=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Grabbed:
    Log("Grabbed");
    CheckFlags(V2_1_2CIA(Level.VarObject).SamThere,FALSE,'JumpFin');
    CheckFlags(V2_1_2CIA(Level.VarObject).InWelcome,TRUE,'JumpFin');
    SendPatternEvent('Van_conversation','CopGrabbed');
    End();
CopDown:
    Log("CopDown");
    GoalCompleted('GoalCop');
    SetFlags(V2_1_2CIA(Level.VarObject).CopOut,TRUE);
    CheckFlags(V2_1_2CIA(Level.VarObject).SamThere,FALSE,'StopConv');
    CheckFlags(V2_1_2CIA(Level.VarObject).InWelcome,TRUE,'StopConv');
    SendPatternEvent('Van_conversation','CopGrabbed');
    End();
StopConv:
    Log("Be sure to stop the conversation with the COP.");
    SendPatternEvent('Van_Conversation','JumpFin');
    Jump('JumpFin');
    End();
Alerted:
    Log("Alerted");
    CheckFlags(RunningToIt,TRUE,'JumpFin');
    SetFlags(V2_1_2CIA(Level.VarObject).DickIsAlert,TRUE);
    SetExclusivity(TRUE);
    SendPatternEvent('Van_conversation','IfHearBefore');
RunToIT:
    Log("RunToIT");
    SetFlags(RunningToIt,TRUE);
    ResetGoals(1);
    ChangeState(1,'s_alert');
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode67',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_InteractWith,8,,,,'EAlarmPanel2',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Attack,7,,'targetfordick','PLAYER',,,FALSE,,,,);
    End();
StopConveration:
    Log("StopConveration");
    CheckFlags(RunningToIt,TRUE,'JumpFin');
    CheckFlags(V2_1_2CIA(Level.VarObject).CopOut,TRUE,'JumpFin');
    SendPatternEvent('Van_conversation','CopAlerted');
    End();
SamNotThere:
    Log("SamNotThere");
    SetFlags(V2_1_2CIA(Level.VarObject).SamThere,FALSE);
    End();
SamBehind:
    Log("SamBehind");
    SetFlags(V2_1_2CIA(Level.VarObject).SamThere,TRUE);
    CheckFlags(V2_1_2CIA(Level.VarObject).WelcomeDone,TRUE,'JumpFin');
    CheckFlags(V2_1_2CIA(Level.VarObject).InWelcome,TRUE,'JumpFin');
    CheckFlags(V2_1_2CIA(Level.VarObject).CopOut,TRUE,'with');
    CheckFlags(V2_1_2CIA(Level.VarObject).ConversationOver,FALSE,'JumpFin');
with:
    Log("with");
    SendPatternEvent('Van_conversation','SamThere');
    End();
JumpFin:
    Log("JumpFin");
    End();
MitchThere:
    Log("MitchThere");
    SetFlags(V2_1_2CIA(Level.VarObject).MitchThere,TRUE);
    End();
MitchIN:
    Log("MitchIN");
    CheckFlags(V2_1_2CIA(Level.VarObject).CopOut,FALSE,'JumpFin');
    SendPatternEvent('Van_conversation','FinalFin');
    End();
SamIN:
    Log("SamIN");
    CheckFlags(V2_1_2CIA(Level.VarObject).CopOut,FALSE,'JumpFin');
    CheckFlags(V2_1_2CIA(Level.VarObject).InWelcome,TRUE,'INafterWELCOME');
    SendPatternEvent('Van_conversation','DropMitch');
    End();
INafterWELCOME:
    Log("INafterWELCOME");
    SetFlags(V2_1_2CIA(Level.VarObject).PutINafterWelcome,TRUE);
    End();
DickTel:
    Log("DickTel");
    Teleport(1, 'CIAdickPos');
    SetFlags(V2_1_2CIA(Level.VarObject).DickIsTeled,TRUE);
    End();
GrabbedBarks:
    Log("GrabbedBarks");
    SendPatternEvent('Van_conversation','OnlyGrabbed');
    End();

}

