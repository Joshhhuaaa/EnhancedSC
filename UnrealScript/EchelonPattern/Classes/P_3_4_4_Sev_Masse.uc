//=============================================================================
// P_3_4_4_Sev_Masse
//=============================================================================
class P_3_4_4_Sev_Masse extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S3_4_3Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int HeardOnce;
var int HeardThrice;
var int HeardTwice;
var int MasseKilled;
var int StopHearing;
var int TimerStarted;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('SAMKilledMasse');
            break;
        case AI_GRABBED:
            EventJump('ManGrabbed');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('HeardIt');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('SeeSAM');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('SeeSAM');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('SeeSAM');
            break;
        case AI_UNCONSCIOUS:
            EventJump('SAMKilledMasse');
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
        if(P.name == 'EMasse0')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKill = true;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bWasFound = true;
        }
    }

    if( !bInit )
    {
    bInit=TRUE;
    HeardOnce=0;
    HeardThrice=0;
    HeardTwice=0;
    MasseKilled=0;
    StopHearing=0;
    TimerStarted=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
ManGrabbed:
    Log("Man was grabbed");
    CheckIfGrabbed(1,'MasseGrabbed');
    End();
MasseGrabbed:
    Log("Masse was grabbed");
    Jump('TimerOff');
    End();
TimerBypass:
    Log("Bypassing the timer.");
    End();
InteractComp:
    Log("Sam has forced Masse to use his computer.");
    Talk(Sound'S3_4_3Voice.Play_34_61_01', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_4_3Voice.Play_34_61_02', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_4_3Voice.Play_34_61_03', 1, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_4_3Voice.Play_34_61_04', 0, , TRUE, 0);
    Sleep(0.1);
    Talk(Sound'S3_4_3Voice.Play_34_61_05', 1, , TRUE, 0);
    GoalCompleted('COOPMASSE');
    SetFlags(V3_4_4Severonickel(Level.VarObject).SafeToKillMasse,TRUE);
    Sleep(0.1);
    Close();
    SendUnrealEvent('ESam');
    SendPatternEvent('TerraHaute','MasseForced');
    End();
HeardIt:
    Log("Masse is hearing Sam");
    CheckFlags(StopHearing,TRUE,'DoNothing');
    CheckFlags(HeardOnce,FALSE,'FirstHear');
    CheckFlags(HeardTwice,FALSE,'SecondHear');
    CheckFlags(HeardThrice,FALSE,'ThirdHear');
    End();
FirstHear:
    Log("First time Masse Hears Sam");
    SetFlags(HeardOnce,TRUE);
    Goal_Set(1,GOAL_Action,9,,,,,'LookStNmUp0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S3_4_3Voice.Play_34_50_01', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
SecondHear:
    Log("Second time Masse heard Sam");
    SetFlags(HeardTwice,TRUE);
    Goal_Set(1,GOAL_Action,9,,,,,'LookStNmBk0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_Action,);
    Talk(Sound'S3_4_3Voice.Play_34_50_02', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    End();
ThirdHear:
    Log("Third time Masse heard Sam, same as being seen");
    SetFlags(HeardThrice,TRUE);
    Jump('SeeSAM');
    End();
SeeSAM:
    Log("Saw or Heard the player");
    SetFlags(StopHearing,TRUE);
    CheckFlags(TimerStarted,TRUE,'DoNothing');
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,'focusMasseA','MasseKeyboard','EMasse_0',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Action,8,,,,'focusMasseA','ReacStNmBB0',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Talk(Sound'S3_4_3Voice.Play_34_50_04', 1, , TRUE, 0);
    Sleep(0.1);
    Close();
    Goal_Set(1,GOAL_Wait,7,,,,'focusMasseA','KbrdStNmNt0',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Jump('TimerOn');
DoNothing:
    End();
TimerEnded:
    Log("Timer Ended");
    CheckFlags(V3_4_4Severonickel(Level.VarObject).SafeToKillMasse,TRUE,'DoNothing');
    SendPatternEvent('LambertAI','TimerFailed');
    End();
SAMKilledMasse:
    Log("SAM killed Masse");
    CheckFlags(V3_4_4Severonickel(Level.VarObject).SafeToKillMasse,TRUE,'DoNothing');
    SendPatternEvent('LambertAI','Executed');
    Jump('TimerOff');
    End();
KeyBoard:
    Log("This is Masse' behaviour at the keyboard");
    Goal_Set(1,GOAL_Action,9,,'focusMasseA',,'focusMasseA','KbrdStNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Stop,8,,'focusMasseA',,'focusMasseA','KbrdStNmNt0',FALSE,9,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,7,,'focusMasseA',,'focusMasseA','KbrdStNmEd0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
StandServer:
    Log("This is Masse' behaviour at the first server");
    Goal_Set(1,GOAL_Action,9,,'Stander',,'Stander','MineStNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Stop,8,,'Stander',,'Stander','MineStNmNt0',FALSE,5,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,7,,'Stander',,'Stander','MineStNmEd0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
CrouchServer:
    Log("This is Masse' behaviour at the second server");
    Goal_Set(1,GOAL_Action,9,,'Croucher',,'Croucher','MineCrNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Stop,8,,'Croucher',,'Croucher','MineCrNmNt0',FALSE,7,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,7,,'Croucher',,'Croucher','MineCrNmEd0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
WaitForever:
    Log("Once this is triggered, Masse will move to the keyboard and wait forever.");
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,'focusMasseA','PLAYER','EMasse_0',,TRUE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Action,8,,'focusMasseA',,,'KbrdStNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Wait,9,,'focusMasseA',,'focusMasseA','KbrdStNmNt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
TimerOn:
    Log("Start that timer!");
    CheckFlags(TimerStarted,TRUE,'DoNothing');
    SetFlags(TimerStarted,TRUE);
    SendUnrealEvent('MasseTimer');
    SendPatternEvent('LambertAI','TimerWarning');
    End();
TimerOff:
    Log("Kill the timer by sending an event -- only if the timer has already started.");
    CheckFlags(TimerStarted,FALSE,'DoNothing');
    SetFlags(TimerStarted,FALSE);
    SendUnrealEvent('MasseTimer');
    End();

}

defaultproperties
{
}
