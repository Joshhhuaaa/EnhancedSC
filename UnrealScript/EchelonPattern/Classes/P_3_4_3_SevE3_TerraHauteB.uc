//=============================================================================
// P_3_4_3_SevE3_TerraHauteB
//=============================================================================
class P_3_4_3_SevE3_TerraHauteB extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('StartDefault');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('StartDefault');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('StartDefault');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('StartDefault');
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
        if(P.name == 'spetsnaz16')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if(P.name == 'spetsnaz19')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
            EAIController(Characters[2]).bBlockDetection = true;
            EAIController(Characters[2]).bWasFound = true;
        }
    }

    if( !bInit )
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
    Log("This is NOT AN E3 Eclusive pattern. DO NOT DELETE");
BeginCombat:
    Log("The guards come through the door and attack");
    SendPatternEvent('E3OfficeAssistant','OCDisable');
    SendPatternEvent('BodyCount','Checking');
    CinCamera(0, 'FocusCamSource', 'FocusCamTarget',);
    Sleep(1.5);
    DisableMessages(TRUE, TRUE);
    SendUnrealEvent('DoorGoBoom');
    Sleep(0.5);
    SendUnrealEvent('StartFight');
    Goal_Set(2,GOAL_MoveTo,9,,'PLAYER','PLAYER','middlegrenadeb',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(0.5);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','SmallBalcR',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_Attack,8,,'PLAYER','PLAYER','SmallBalcR',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_ThrowGrenade,8,,'PLAYER','PLAYER','GrenadeTarget',,FALSE,2.5,MOVE_CrouchJog,,MOVE_CrouchJog);
    WaitForGoal(2,GOAL_ThrowGrenade,);
    ChangeGroupState('s_alert');
    CinCamera(1, , ,);
    Goal_Set(2,GOAL_Attack,9,,'PLAYER','PLAYER','MiddleBalcony',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(1,GOAL_MoveAndAttack,);
AttackLoopA:
    Log("This is the primary attack loop from the first position");
    UpdateGoal(2,,TRUE,MOVE_JogAlert);
    UpdateGoal(1,,FALSE,MOVE_CrouchJog);
    Sleep(4);
    UpdateGoal(1,,TRUE,MOVE_JogAlert);
    UpdateGoal(2,,FALSE,MOVE_CrouchJog);
    Sleep(4);
    UpdateGoal(1,,FALSE,MOVE_CrouchJog);
    UpdateGoal(2,,TRUE,MOVE_JogAlert);
    Sleep(4);
    UpdateGoal(1,,TRUE,MOVE_JogAlert);
    UpdateGoal(2,'SmallBalcL',FALSE,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','SmallBalcL',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    WaitForGoal(2,GOAL_MoveAndAttack,);
    UpdateGoal(1,,FALSE,MOVE_CrouchJog);
    UpdateGoal(2,,TRUE,MOVE_JogAlert);
    Sleep(4);
    UpdateGoal(1,,TRUE,MOVE_JogAlert);
    UpdateGoal(2,,FALSE,MOVE_CrouchJog);
    Sleep(4);
    UpdateGoal(2,,TRUE,MOVE_JogAlert);
    UpdateGoal(1,'MiddleGuyFloorA',FALSE,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','MiddleGuyFloorA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveAndAttack,);
    UpdateGoal(2,'SmallBalcR',FALSE,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','SmallBalcR',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(2,GOAL_MoveAndAttack,);
    DisableMessages(FALSE, FALSE);
    End();
Upstairs:
    Log("Sam went upstairs");
    End();
DoNothing:
    Log("Doing nothing");
    End();
StartDefault:
    Log("Start Default");
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}
