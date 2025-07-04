//=============================================================================
// P_2_2_3_Ktech_RoofAmbushB
//=============================================================================
class P_2_2_3_Ktech_RoofAmbushB extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('FireLikeMad');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('FireLikeMad');
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
        if(P.name == 'EMafiaMuscle5')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if(P.name == 'EMafiaMuscle6')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
            EAIController(Characters[2]).bBlockDetection = true;
            EAIController(Characters[2]).bWasFound = true;
        }
        if(P.name == 'EMafiaMuscle7')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
            EAIController(Characters[3]).bBlockDetection = true;
            EAIController(Characters[3]).bWasFound = true;
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
RoofAmbushB:
    Log("Ambush with the guy climbing the ladder");
    DisableMessages(TRUE, FALSE);
    Goal_Set(1,GOAL_MoveTo,9,,'PLAYER','PLAYER','AI303LadderNode09',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Action,8,,,,'RoofAmbushBGrenade1','SignStAlFd0',FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(2,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','RoofAmbushBNode01',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(3,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','AI303LadderNode05',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,'PLAYER','RoofAmbushBNode02',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_Attack,8,,,'PLAYER','RoofAmbushBNode03',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_Attack,8,,,'PLAYER','RoofAmbushBNode01',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(3,GOAL_Attack,8,,,'PLAYER','AI303LadderNode05',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    WaitForGoal(3,GOAL_MoveAndAttack,);
    DisableMessages(FALSE, FALSE);
    End();
FireLikeMad:
    Log("Fire Like Mad on the player");
    SetExclusivity(FALSE);
    End();

}

