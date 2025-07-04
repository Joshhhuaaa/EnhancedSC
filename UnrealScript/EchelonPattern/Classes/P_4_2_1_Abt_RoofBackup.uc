//=============================================================================
// P_4_2_1_Abt_RoofBackup
//=============================================================================
class P_4_2_1_Abt_RoofBackup extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int DontStop;
var int LookBackSent;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('ManDown');
            break;
        case AI_UNCONSCIOUS:
            EventJump('ManDown');
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
        if(P.name == 'spetsnaz1')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz8')
            Characters[2] = P.controller;
    }

    if( !bInit )
    {
    bInit=TRUE;
    DontStop=0;
    LookBackSent=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("");
    SetFlags(V4_2_1_Abattoir(Level.VarObject).SpetzOnRoof,TRUE);
    SetFlags(V4_2_1_Abattoir(Level.VarObject).RoofLightPass,TRUE);
    Teleport(1, 'PathNode49');
    Goal_Default(1,GOAL_Guard,0,,'EFocusPoint36',,'PathNode469',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode469',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'PathNode294',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_MoveTo,7,,,,'PathNode46',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(1,GOAL_Action,4,,'EFocusPoint36',,'PathNode294','ReacStNmAA0',FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    WaitForGoal(1,GOAL_Action,);
    Goal_Default(1,GOAL_Guard,0,,'EFocusPoint36',,'PathNode469',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
LookBack:
    Log("");
    CheckFlags(LookBackSent,TRUE,'DoNothing');
    SetFlags(LookBackSent,TRUE);
    Goal_Default(2,GOAL_Guard,0,,'EFocusPoint36',,'PathNode83',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,9,,'PathNode254',,'PathNode253',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_Action,8,,,,,'LookStNmFd2',FALSE,,,,);
    Goal_Set(2,GOAL_MoveTo,7,,,,'PathNode248',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,6,,,,'PathNode246',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,5,,,,'EGeorgianSoldier13_100',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
ManDown:
    Log("One of them is down. If its the first guy, sending the second.");
    CheckIfIsDead(1,'LookBack');
    CheckIfIsUnconscious(1,'LookBack');
    End();
DoNothing:
    Log("Doing Nothing");
    End();

}

