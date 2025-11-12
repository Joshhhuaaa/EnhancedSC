//=============================================================================
// P_2_1_0_CIA_BasementTech
//=============================================================================
class P_2_1_0_CIA_BasementTech extends EPattern;

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
        if (P.name == 'ECIAMaintenance6')
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
StartBasementTech:
    Log("Tech goes to check panel in corridor");
    Goal_Set(1,GOAL_Patrol,9,,,,'Rammy_100',,FALSE,,,,);
    End();

}

