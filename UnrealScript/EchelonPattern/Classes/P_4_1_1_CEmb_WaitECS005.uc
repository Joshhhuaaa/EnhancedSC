//=============================================================================
// P_4_1_1_CEmb_WaitECS005
//=============================================================================
class P_4_1_1_CEmb_WaitECS005 extends EPattern;

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
        if(P.name == 'EChineseSoldier21')
            Characters[1] = P.controller;
        if(P.name == 'EChineseSoldier13')
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
ECSWaitingA:
    Log("ECS005Waiting walking into the alley and ECSExtra02 walking down the street");
    Goal_Default(1,GOAL_Patrol,9,,,,'ECS411005_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Patrol,9,,,,'ECSExtra2_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

