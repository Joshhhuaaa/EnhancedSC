//=============================================================================
// P_3_2_2_NPP_SassyPrimate
//=============================================================================
class P_3_2_2_NPP_SassyPrimate extends EPattern;

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
        if(P.name == 'EFalseRussianSoldier4')
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
Patrol:
    Log("Starts the NPC patrolling when Sam crosses the threshhold.");
    Goal_Set(1,GOAL_MoveTo,9,,,,'TedTheodoreLogan_100',,FALSE,,,,);
    Goal_Default(1,GOAL_Patrol,6,,,,'TedTheodoreLogan_100',,FALSE,,,,);
    End();

}

defaultproperties
{
}
