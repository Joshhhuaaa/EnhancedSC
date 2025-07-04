//=============================================================================
// P_3_1_2_Ship_SubEnterCine
//=============================================================================
class P_3_1_2_Ship_SubEnterCine extends EPattern;

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
        if(P.name == 'spetsnaz4')
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
GoUp:
    Log("");
    Goal_Set(1,GOAL_MoveTo,8,,,,'PathNode3',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Wait,7,,,,'PathNode3',,FALSE,,,,);
    Sleep(1);
    CinCamera(0, 'EFocusPoint33', 'EFocusPoint34',);
    Sleep(5);
    CinCamera(1, , ,);
    End();
GoDown:
    Log("");
    Goal_Set(1,GOAL_MoveTo,8,,,,'PathNode6',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Wait,7,,,,'PathNode6',,FALSE,,,,);
    Sleep(1);
    CinCamera(0, 'EFocusPoint31', 'EFocusPoint32',);
    Sleep(5);
    CinCamera(1, , ,);
    End();

}

defaultproperties
{
}
