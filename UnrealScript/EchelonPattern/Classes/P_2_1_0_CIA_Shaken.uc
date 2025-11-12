//=============================================================================
// P_2_1_0_CIA_Shaken
//=============================================================================
class P_2_1_0_CIA_Shaken extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S2_1_0Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Alert;
var int PlayerIn;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_ALARM_ON_PRIMARY:
            EventJump('Alerted');
            break;
        case AI_DEAD:
            EventJump('Alerted');
            break;
        case AI_GRABBED:
            EventJump('Alerted');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('Alerted');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('Alerted');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('Alerted');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
            break;
        case AI_UNCONSCIOUS:
            EventJump('Alerted');
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
        if (P.name == 'ECIAAgent0')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Alert=0;
    PlayerIn=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("Start Crisi_Shaken scripted event");
    Goal_Set(1,GOAL_Wait,9,,,,,'CellStNmBB0',FALSE,,,,);
    Goal_Default(1,GOAL_Patrol,1,,,,'PatrDuoTwoA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Talk(Sound'S2_1_0Voice.Play_21_07_01', 1, , TRUE, 0);
    Close();
    Sleep(2);
    Talk(Sound'S2_1_0Voice.Play_21_07_03', 1, , FALSE, 0);
    Close();
    Sleep(2);
    Talk(Sound'S2_1_0Voice.Play_21_07_05', 1, , TRUE, 0);
    Close();
    Sleep(3);
    Goal_Set(1,GOAL_Action,9,,,,,'CellStNmAA0',FALSE,,,,);
    Talk(Sound'S2_1_0Voice.Play_21_07_07', 1, , TRUE, 0);
    Close();
    Sleep(2);
    Talk(Sound'S2_1_0Voice.Play_21_07_09', 1, , TRUE, 0);
    Close();
    ResetGoals(1);
    Goal_Set(1,GOAL_InteractWith,9,,,,'EElevatorButton7',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_InteractWith,);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode275',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Set(1,GOAL_MoveTo,8,,'EFocusPoint49','EFocusPoint49','PathNode283',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,7,,'EFocusPoint49','EFocusPoint49','PathNode283',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Sleep(1);
    SendUnrealEvent('EElevatorButton4');
    End();
TelElevGuy:
    Log("TelElevGuy");
    CheckFlags(Alert,TRUE,'TestPlayer');
TelNPC:
    Teleport(1, 'TelHereA');
    KillNPC(1, TRUE, FALSE);
    End();
TestPlayer:
    Log("Testing to see if th eplayer is in the elevator...");
    CheckFlags(PlayerIn,FALSE,'TelNPC');
    End();
Alerted:
    Log("Alerted");
    Close();
    SetFlags(Alert,TRUE);
    SetExclusivity(FALSE);
    End();
End:
    Log("End");
    End();
PlayerIn:
    Log("Player is in the elevator");
    SetFlags(PlayerIn,TRUE);
    End();
PlayerOut:
    Log("Player is out of the elevator.");
    SetFlags(PlayerIn,FALSE);
    End();

}

