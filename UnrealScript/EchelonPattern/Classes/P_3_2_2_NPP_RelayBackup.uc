//=============================================================================
// P_3_2_2_NPP_RelayBackup
//=============================================================================
class P_3_2_2_NPP_RelayBackup extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Initial;
var int InitialTwo;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('Backup');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Backup');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Backup');
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
        if (P.name == 'EFalseRussianSoldier12')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Initial=1;
    InitialTwo=1;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Backup:
    Log("The beginning of the Duck Hunt.");
    GoalCompleted('3');
    CheckFlags(Initial,FALSE,'Nada');
    SetFlags(Initial,FALSE);
    SendPatternEvent('DummyGroupAI','Timer');
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER',,,FALSE,1,,,);
    Goal_Set(1,GOAL_MoveTo,8,,'PLAYER','PLAYER','SassPoint',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,7,,'PLAYER','PLAYER',,,FALSE,,,,);
    End();
Release:
    Log("Exclusivity set to false.");
    ResetGoals(1);
    SetExclusivity(FALSE);
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'AttackPoint',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Set(1,GOAL_Attack,8,,'PLAYER','PLAYER','AttackPoint',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
Nada:
    End();

}

defaultproperties
{
}
