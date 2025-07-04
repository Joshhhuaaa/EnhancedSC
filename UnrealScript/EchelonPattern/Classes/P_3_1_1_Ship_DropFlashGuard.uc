//=============================================================================
// P_3_1_1_Ship_DropFlashGuard
//=============================================================================
class P_3_1_1_Ship_DropFlashGuard extends EPattern;

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
DropFlashGuard:
    Log("Dropoint Flashlight guard");
    CheckFlags(pass1,TRUE,'JumpEnd');
    SetFlags(pass1,TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,'EFocusPoint86',,'PathNode155',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,8,,'EFocusPoint86',,'PathNode155',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(3);
    Goal_Set(1,GOAL_MoveTo,7,,'EFocusPoint87',,'PathNode77',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,6,,'EFocusPoint87',,'PathNode77',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(2);
    Goal_Set(1,GOAL_MoveTo,5,,'EFocusPoint88',,'PathNode164',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Guard,4,,'EFocusPoint88',,'PathNode164',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(2);
    ResetGoals(1);
    Goal_Default(1,GOAL_Patrol,9,,,,'spetsnaz4_500',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
JumpEnd:
    Log("jump");
    End();
ResetPass1:
    Log("");
    SetFlags(pass1,FALSE);
    End();
OutsideOn:
    Log("Outside light on");
    CheckFlags(pass2,TRUE,'JumpEnd');
    SetFlags(pass2,TRUE);
    SendPatternEvent('EGroupAI23','OutsideOn');
    End();
Dead:
    Log("dead");
    SendPatternEvent('EGroupAI25','GoOut');
    End();

}

defaultproperties
{
}
