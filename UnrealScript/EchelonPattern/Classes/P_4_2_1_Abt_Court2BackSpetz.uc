//=============================================================================
// P_4_2_1_Abt_Court2BackSpetz
//=============================================================================
class P_4_2_1_Abt_Court2BackSpetz extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Active;
var int FrontBack;


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
        if (P.name == 'spetsnaz5')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Active=0;
    FrontBack=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Start:
    Log("");
    SetFlags(Active,TRUE);
    SendUnrealEvent('EVolume41');
    CheckFlags(FrontBack,FALSE,'Front');
    CheckFlags(FrontBack,TRUE,'Back');
    End();
Front:
    Log("");
    SetFlags(FrontBack,FALSE);
    CheckFlags(Active,FALSE,'JumpFin');
    DisableMessages(FALSE, TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode462',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_ThrowGrenade,8,,'PLAYER','PLAYER',,,FALSE,0.75,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_ThrowGrenade,);
    Goal_Default(1,GOAL_Attack,7,,,'PLAYER','PathNode461',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Sleep(5);
    DisableMessages(FALSE, FALSE);
    SetExclusivity(FALSE);
    End();
Back:
    Log("");
    SetFlags(FrontBack,TRUE);
    CheckFlags(Active,FALSE,'JumpFin');
    DisableMessages(FALSE, TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode461',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_ThrowGrenade,8,,'PLAYER','PLAYER',,,FALSE,0.75,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_ThrowGrenade,);
    Goal_Default(1,GOAL_Attack,7,,,'PLAYER','PathNode461',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Sleep(5);
    DisableMessages(FALSE, FALSE);
    SetExclusivity(FALSE);
    End();
JumpFin:
    Log("");
    End();
SpawnSpets:
    Log("");
    DisableMessages(FALSE, TRUE);
    SendUnrealEvent('EVolume41');
    CheckFlags(V4_2_1_Abattoir(Level.VarObject).TowerTeleported,TRUE,'SkipTeleport');
    SetFlags(V4_2_1_Abattoir(Level.VarObject).TowerTeleported,TRUE);
    Teleport(1, 'PathNode307');
SkipTeleport:
    Log("He has already been teleported, so it won't happen twice");
    Goal_Default(1,GOAL_Guard,0,,'EAmmoFn7',,'PathNode306',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    SetExclusivity(FALSE);
    End();

}

