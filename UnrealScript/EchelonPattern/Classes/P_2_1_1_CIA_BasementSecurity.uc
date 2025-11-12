//=============================================================================
// P_2_1_1_CIA_BasementSecurity
//=============================================================================
class P_2_1_1_CIA_BasementSecurity extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



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
        if (P.name == 'ECIASecurity3')
            Characters[1] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
StartBasementSecurity:
    Log("Start Basement Secuirty Patrol");
    Goal_Default(1,GOAL_Patrol,9,,,,'Joechin_900',,FALSE,,,,);
    End();

}

