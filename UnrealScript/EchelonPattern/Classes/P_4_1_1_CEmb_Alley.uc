//=============================================================================
// P_4_1_1_CEmb_Alley
//=============================================================================
class P_4_1_1_CEmb_Alley extends EPattern;

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
        if(P.name == 'EChineseSoldier14')
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
AlleyGuards:
    Log("This pattern controls the 2 soldiers at the end of the map.");
ECS020:
    Log("");
    Goal_Default(1,GOAL_Patrol,9,,,,'ECS411020_100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

