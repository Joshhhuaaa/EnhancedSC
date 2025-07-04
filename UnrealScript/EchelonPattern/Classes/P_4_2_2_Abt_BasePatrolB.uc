//=============================================================================
// P_4_2_2_Abt_BasePatrolB
//=============================================================================
class P_4_2_2_Abt_BasePatrolB extends EPattern;

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
        if(P.name == 'EGeorgianSoldier29')
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
BasePatrolB:
    Log("Basement patrol B");
    ResetGroupGoals();
    Goal_Default(1,GOAL_Patrol,9,,,,'EGeorgianSoldier29_100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

