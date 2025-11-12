//=============================================================================
// P_2_2_2_Ktech_MainServerRoom
//=============================================================================
class P_2_2_2_Ktech_MainServerRoom extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_2_2Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int FireDoorsHaveBeenOpened;
var int PatrolAlreadyTriggered;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('IdleComputer');
            break;
        case AI_UNCONSCIOUS:
            EventJump('IdleComputer');
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
        if (P.name == 'EMafiaMuscle14')
            Characters[1] = P.controller;
        if (P.name == 'EMafiaMuscle13')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    FireDoorsHaveBeenOpened=0;
    PatrolAlreadyTriggered=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
MainServerRoom:
    Log("Main Server Room Script Starts");
    SendUnrealEvent('FireDoorServer');
    Goal_Set(1,GOAL_Action,9,,'ServerRoomFocus01',,'ServerRoomFocus01','KbrdStNmBg0',FALSE,-1,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,9,,'ServerRoomFocus01',,'ServerRoomFocus01','RdioStNmNt0',FALSE,,,,);
    Talk(Sound'S2_2_2Voice.Play_22_33_01', 1, , TRUE, 0);
    Sleep(7);
    Close();
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,9,,,,'ServerRoomFocus01','RdioStNmEd0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,9,,,,'ServerRoomFocus01','KbrdStNmBg0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Wait,9,,,,'ServerRoomFocus01','KbrdStNmNt0',FALSE,,,,);
    End();
ServerInteraction:
    Log("Server Interaction");
    CheckFlags(V2_2_2_Kalinatek(Level.VarObject).FuseBoxDone,FALSE,'ComputerNotWorking');
    CheckFlags(FireDoorsHaveBeenOpened,TRUE,'DoNothing');
    SetFlags(FireDoorsHaveBeenOpened,TRUE);
    CinCamera(0, 'FireDoorOpenPosition01', 'FireDoorOpenTarget01',);
    Sleep(2);
    LockDoor('FireDoorA', FALSE, TRUE);
    SendUnrealEvent('FireDoorA');
    Sleep(3);
    CinCamera(1, , ,);
    Sleep(1);
    SendPatternEvent('LambertComms','FireDoorOpen');
ComputerNotWorking:
    End();
ServerRoomPatrol:
    Log("Start Patrol");
    CheckFlags(PatrolAlreadyTriggered,TRUE,'JumpToComputerGuard');
    SetFlags(PatrolAlreadyTriggered,TRUE);
    Goal_Default(2,GOAL_Patrol,9,,,,'ServerRoomPatrol_0',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
JumpToComputerGuard:
    Log("JumpToComputerGuard");
    CheckFlags(V2_2_2_Kalinatek(Level.VarObject).FuseBoxDone,FALSE,'ComputerNotWorking');
    SendUnrealEvent('ServerRoomVolume');
    Teleport(1, 'MainServerRoomNode01');
    ResetGoals(1);
    Goal_Default(1,GOAL_Wait,9,,'ServerRoomFocus01',,,'KbrdStNmNt0',FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
IdleComputer:
    Log("If Sam kills the Mafioso, the computer will turn to Idle state");
    CheckIfIsDead(1,'CloseComputer');
    CheckIfIsUnconscious(1,'CloseComputer');
    End();
CloseComputer:
    Log("CloseComputer");
    SendUnrealEvent('FireDoorServer');
    End();
ComputerDestroyed:
    Log("If the Server is destroyed");
    SetProfileDeletion();
    DisableMessages(TRUE, TRUE);
    Sleep(2);
    GameOver(false, 6);
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

