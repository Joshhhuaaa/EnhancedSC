//=============================================================================
// P_3_1_1_Ship_LightMercCR
//=============================================================================
class P_3_1_1_Ship_LightMercCR extends EPattern;

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
        if(P.name == 'spetsnaz26')
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
OpenLight:
    Log("Open Light");
    Goal_Set(1,GOAL_InteractWith,9,,,'ELightSwitch',,,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_InteractWith,);
    Goal_Set(1,GOAL_MoveTo,9,,,,'EMercenaryTechnician3_600',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,,,'EMercenaryTechnician3_400',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();

}

defaultproperties
{
}
