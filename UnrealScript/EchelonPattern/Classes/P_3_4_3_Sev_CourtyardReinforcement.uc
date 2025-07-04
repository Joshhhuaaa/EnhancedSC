//=============================================================================
// P_3_4_3_Sev_CourtyardReinforcement
//=============================================================================
class P_3_4_3_Sev_CourtyardReinforcement extends EPattern;

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
        if(P.name == 'spetsnaz6')
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
    Log("This pattern is for the extra sniper over the courtyard");
StartWarrenPatrol:
    Log("Warren enters the courtyard");
    Goal_Set(1,GOAL_MoveTo,9,,,'PLAYER','PathNode',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,0,,,'PLAYER','WSpecter_100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

defaultproperties
{
}
