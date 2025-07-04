//=============================================================================
// P_3_1_2_Ship_GuardINsub
//=============================================================================
class P_3_1_2_Ship_GuardINsub extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if(P.name == 'spetsnaz21')
            Characters[1] = P.controller;
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
Go:
    Log("Teleport and start guard in sub corridor");
    ResetGoals(1);
    Teleport(1, 'PathNode300');
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'PathNode28',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'PLAYER','PLAYER','PathNode28',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();

}

defaultproperties
{
}
