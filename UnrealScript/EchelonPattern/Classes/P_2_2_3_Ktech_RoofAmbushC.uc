//=============================================================================
// P_2_2_3_Ktech_RoofAmbushC
//=============================================================================
class P_2_2_3_Ktech_RoofAmbushC extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('AISeePlayer');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('AISeePlayer');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('AISeePlayer');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('AISeePlayer');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('AISeePlayer');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('AISeePlayer');
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
        if (P.name == 'EMafiaMuscle10')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bBlockDetection = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if (P.name == 'EMafiaMuscle9')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
            EAIController(Characters[2]).bBlockDetection = true;
            EAIController(Characters[2]).bWasFound = true;
        }
        if (P.name == 'EMafiaMuscle8')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
            EAIController(Characters[3]).bBlockDetection = true;
            EAIController(Characters[3]).bWasFound = true;
        }
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
RoofAmbushC:
    Log("Ambush behind the pillars (Matrix Style)");
    Goal_Set(1,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','RoofAmbushCNode01',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','RoofAmbushCNode02',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(3,GOAL_MoveAndAttack,9,,'PLAYER','PLAYER','RoofAmbushCNode05',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,8,,,'PLAYER','RoofAmbushCNode01',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_Attack,8,,,'PLAYER','RoofAmbushCNode02',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(3,GOAL_Attack,8,,,'PLAYER','RoofAmbushCNode05',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
AISeePlayer:
    Log("AISeePlayer");
    SetExclusivity(FALSE);
    End();
DestroyDefendRadius:
    Log("DestroyDefendRadius");
    SendUnrealEvent('RemoveDefendRadiusA');
    SendUnrealEvent('RemoveDefendRadiusB');
    SendUnrealEvent('AI304Mafioso3');
    End();

}

