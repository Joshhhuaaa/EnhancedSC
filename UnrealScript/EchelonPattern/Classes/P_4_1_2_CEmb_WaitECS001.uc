//=============================================================================
// P_4_1_2_CEmb_WaitECS001
//=============================================================================
class P_4_1_2_CEmb_WaitECS001 extends EPattern;

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
        if(P.name == 'EChineseSoldier23')
            Characters[1] = P.controller;
        if(P.name == 'EChineseSoldier3')
            Characters[2] = P.controller;
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
ECS004Looking:
    Log("ECS004Looking");
    Goal_Set(2,GOAL_MoveTo,9,,,,'ECS412004_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,8,,,,'ECS412004_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

