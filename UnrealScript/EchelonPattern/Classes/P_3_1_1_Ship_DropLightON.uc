//=============================================================================
// P_3_1_1_Ship_DropLightON
//=============================================================================
class P_3_1_1_Ship_DropLightON extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('OutsideOn');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('OutsideOn');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('OutsideOn');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('OutsideOn');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('OutsideOn');
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
        if(P.name == 'EMafiaMuscle1')
            Characters[1] = P.controller;
        if(P.name == 'EMafiaMuscle2')
            Characters[2] = P.controller;
        if(P.name == 'EMafiaMuscle7')
            Characters[3] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
OutsideOn:
    Log("Outside light on");
    CheckFlags(pass1,TRUE,'JumpEnd');
    SetFlags(pass1,TRUE);
    ResetGroupGoals();
    SendPatternEvent('EGroupAI25','NoTeleport');
    Goal_Set(1,GOAL_InteractWith,9,,,,'ELightSwitch10',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveAndAttack,8,,,,'PathNode147',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Attack,7,,'PLAYER','PLAYER','PathNode147',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'PathNode100',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Attack,8,,'PLAYER','PLAYER','PathNode100',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(3,GOAL_MoveAndAttack,9,,,,'EMafiaMuscle_400',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(3,GOAL_MoveAndAttack,8,,,,'spetsnaz4_400',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(3,GOAL_Search,7,,,,'spetsnaz4_500',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
JumpEnd:
    Log("");
    End();
BackBase:
    Log("back to basic combat");
    SetExclusivity(FALSE);
    SetFlags(pass1,TRUE);
    End();

}

defaultproperties
{
}
