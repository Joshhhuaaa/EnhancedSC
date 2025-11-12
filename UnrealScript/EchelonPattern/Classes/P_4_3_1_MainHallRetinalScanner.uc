//=============================================================================
// P_4_3_1_MainHallRetinalScanner
//=============================================================================
class P_4_3_1_MainHallRetinalScanner extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_3_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int AlreadyTiggered;
var int CanKillColonel;
var int SpeechAlreadyDone;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('ColonelNeutralized');
            break;
        case AI_UNCONSCIOUS:
            EventJump('ColonelNeutralized');
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
        if (P.name == 'EChineseSoldier2')
            Characters[1] = P.controller;
        if (P.name == 'EAzeriColonel0')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    AlreadyTiggered=0;
    CanKillColonel=0;
    SpeechAlreadyDone=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MainHallScan:
    Log("Main Hall Retinal Scanner");
    SendPatternEvent('SwitchDummyC','EndLoop');
    CheckFlags(V4_3_1ChineseEmbassy(Level.VarObject).BasementDataDone,FALSE,'NoMoreTrigger');
    LockDoor('HallDoor', FALSE, TRUE);
    SendUnrealEvent('PlaqueA');
    SendUnrealEvent('RetinalScanVolume');
    SendUnrealEvent('RetinalScanVolumeB');
    Teleport(1, 'HallScannerSpawn02');
    Teleport(2, 'HallScannerSpawn01');
    ResetGroupGoals();
    Goal_Set(2,GOAL_MoveTo,9,,,,'HallScannerNode04',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,8,,'HallScannerFocus01',,'HallScannerNode04',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,9,,,,'HallScannerNode03',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,'HallScanner',,'HallScannerNode03',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    SetExclusivity(FALSE);
    SendPatternEvent('DummyA','CheckTriggers');
    Sleep(8);
    Talk(Sound'S4_3_1Voice.Play_43_26_01', 2, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_26_02', 1, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_26_03', 2, , TRUE, 0);
    Close();
    End();
TriggerRetinalScanner:
    Log("TriggerRetinalScanner (Pawn Triggered)");
    ResetGroupGoals();
    Goal_Default(1,GOAL_Guard,9,,'HallScanner',,'HallScannerNode03',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(2,GOAL_InteractWith,9,,,,'HallScanner',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(2,GOAL_InteractWith,);
    SetFlags(CanKillColonel,TRUE);
    CheckFlags(SpeechAlreadyDone,TRUE,'IfSpeechDone');
    SetFlags(SpeechAlreadyDone,TRUE);
    Talk(Sound'S4_3_1Voice.Play_43_26_04', 1, , TRUE, 0);
    Talk(Sound'S4_3_1Voice.Play_43_26_05', 2, , TRUE, 0);
    Close();
IfSpeechDone:
    Log("If the speech was already done");
    Goal_Set(1,GOAL_MoveTo,9,,,,'HallScannerNode01',,TRUE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_Action,8,,,,'MainHallRetinalScannerFocusComputer','KbrdStNmBg0',FALSE,,,,);
    Goal_Set(1,GOAL_Wait,7,,,,'MainHallRetinalScannerFocusComputer','KbrdStNmNt0',FALSE,,,,);
    Goal_Default(2,GOAL_Guard,9,,'HallScannerFocus01',,'HallScannerNode04',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    SendUnrealEvent('MemoryStickComputer');
NoMoreTrigger:
    End();
DoorClosing:
    Log("When the door close");
    CheckFlags(V4_3_1ChineseEmbassy(Level.VarObject).ColonelOnRetinal,TRUE,'NoMoreTrigger');
    CheckIfIsDead(2,'DoorClosed');
    CheckIfIsUnconscious(2,'DoorClosed');
    End();
DoorClosed:
    Log("When the door is closed");
    CheckFlags(V4_3_1ChineseEmbassy(Level.VarObject).DoorPassed,TRUE,'NoMoreTrigger');
    SendPatternEvent('LambertComms','GenericFail');
    End();
ColonelNeutralized:
    Log("Check If Sam can kill the colonel, if not, GameOver, if yes, check if Sam has passed the door");
    CheckFlags(V4_3_1ChineseEmbassy(Level.VarObject).ColonelOnRetinal,TRUE,'NoMoreTrigger');
    CheckIfIsDead(2,'DoorClosing');
    CheckIfIsUnconscious(2,'DoorClosing');
    Jump('SetColonelPatrol');
    End();
SetColonelPatrol:
    Log("SetColonelPatrol");
    Goal_Default(2,GOAL_Patrol,9,,,,'HallRetScanColonel_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

