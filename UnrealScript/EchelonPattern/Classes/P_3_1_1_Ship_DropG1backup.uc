//=============================================================================
// P_3_1_1_Ship_DropG1backup
//=============================================================================
class P_3_1_1_Ship_DropG1backup extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;
var int pass2;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('AlarmPpl');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('AlarmPpl');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('AlarmPpl');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('AlarmPpl');
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
        if(P.name == 'spetsnaz6')
            Characters[1] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    pass1=0;
    pass2=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
GoOut:
    Log("");
    CheckFlags(pass1,TRUE,'JumpFin');
    Sleep(5);
    Teleport(1, 'PathNode147');
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,,,'spetsnaz4_500',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,8,,'PathNode155',,'spetsnaz4_500',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    WaitForGoal(1,GOAL_MoveTo,);
    Sleep(2);
    Goal_Set(1,GOAL_MoveTo,7,,,,'spetsnaz4_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,6,,'EFocusPoint9',,'spetsnaz4_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
NoTeleport:
    Log("");
    SetFlags(pass1,TRUE);
JumpFin:
    Log("");
    End();
AlarmPpl:
    Log("");
    CheckFlags(pass2,TRUE,'JumpFin');
    SetFlags(pass2,TRUE);
    SendPatternEvent('EGroupAI23','OutsideOn');
    End();

}

defaultproperties
{
}
