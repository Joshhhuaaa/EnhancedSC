//=============================================================================
// P_3_1_2_Ship_HangarSniper
//=============================================================================
class P_3_1_2_Ship_HangarSniper extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int pass1;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
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
        if (P.name == 'spetsnaz15')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz20')
            Characters[2] = P.controller;
        if (P.name == 'spetsnaz16')
            Characters[3] = P.controller;
        if (P.name == 'spetsnaz17')
            Characters[4] = P.controller;
        if (P.name == 'spetsnaz19')
            Characters[5] = P.controller;
        if (P.name == 'spetsnaz14')
            Characters[6] = P.controller;
        if (P.name == 'spetsnaz18')
            Characters[7] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    pass1=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
SniperRdy:
    Log("");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode253',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Guard,8,,,,'PathNode253',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PathNode255',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(2,GOAL_Guard,8,,,,'PathNode255',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,,,'PathNode257',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(3,GOAL_Guard,8,,,,'PathNode257',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    ResetGoals(5);
    Goal_Set(5,GOAL_MoveTo,9,,,,'PathNode264',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(5,GOAL_Guard,8,,,,'PathNode264',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    ResetGoals(7);
    Goal_Set(7,GOAL_MoveTo,9,,,,'PathNode258',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(7,GOAL_Guard,8,,,,'PathNode258',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Snipe1:
    Log("Snipe1");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode254',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Goal_Default(1,GOAL_Guard,8,,'EMovableFocusPoint0',,'PathNode254',,FALSE,,MOVE_WalkNormal,,MOVE_CrouchWalk);
    Sleep(3);
    Goal_Default(1,GOAL_Attack,7,,'EMovableFocusPoint0','PLAYER',,,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Sleep(3);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,,,'PathNode3',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_MoveTo,8,,,,'PathNode4',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Attack,7,,'EMovableFocusPoint0','PLAYER','PathNode5',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
Snipe2:
    Log("Snipe2");
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'PathNode255',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,8,,,,'PathNode269',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,7,,'EMovableFocusPoint0','PLAYER','PathNode268',,FALSE,,MOVE_JogAlert,,MOVE_CrouchJog);
    ResetGoals(7);
    Goal_Set(7,GOAL_MoveTo,9,,,,'PathNode258',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(7,GOAL_MoveTo,8,,,,'PathNode271',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(7,GOAL_Attack,7,,'EMovableFocusPoint0','PLAYER','PathNode272',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
Snipe3:
    Log("Snipe3");
    ResetGoals(6);
    Goal_Set(6,GOAL_MoveTo,9,,,,'PathNode7',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(6,GOAL_MoveTo,8,,,,'PathNode276',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(6,GOAL_Attack,7,,'EMovableFocusPoint0','PLAYER','PathNode276',,TRUE,,MOVE_JogAlert,,MOVE_CrouchJog);
    Sleep(6);
    ResetGoals(4);
    Goal_Set(4,GOAL_MoveTo,9,,,,'PathNode34',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(4,GOAL_MoveTo,8,,,,'PathNode281',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveTo,7,,,,'PathNode38',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,6,,'EMovableFocusPoint0','PLAYER','PathNode275',,TRUE,,MOVE_WalkAlert,,MOVE_CrouchWalk);
    ResetGoals(5);
    Goal_Set(5,GOAL_MoveTo,9,,,,'PathNode264',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(5,GOAL_MoveTo,8,,,,'PathNode266',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(5,GOAL_Attack,7,,'EMovableFocusPoint0','PLAYER','PathNode266',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Sleep(10);
    ResetGoals(6);
    Goal_Set(6,GOAL_MoveTo,9,,,,'PathNode283',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(6,GOAL_MoveTo,8,,,,'PathNode285',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(6,GOAL_MoveTo,7,,,,'PathNode289',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(6,GOAL_MoveAndAttack,6,,,,'PathNode266',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(6,GOAL_Attack,5,,'PLAYER','PLAYER','PathNode266',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(10);
    ResetGoals(4);
    Goal_Set(4,GOAL_MoveTo,9,,,,'PathNode282',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(4,GOAL_MoveTo,8,,,,'PathNode37',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,7,,'EFocusPoint0','PLAYER','PathNode36',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
GoBack:
    Log("");
    ResetGoals(4);
    Goal_Default(4,GOAL_MoveAndAttack,9,,,,'PathNode283',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(4,GOAL_Attack,8,,'PLAYER','PLAYER','PathNode283',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();

}

defaultproperties
{
}
