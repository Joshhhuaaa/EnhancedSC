//=============================================================================
// P_3_4_4_Sev_SentinelleD
//=============================================================================
class P_3_4_4_Sev_SentinelleD extends EPattern;

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
xAttackSAMx:
    Log("Attack SAM");
    Log("All Labels in this pattern have been bracketted in xs to disable them.");
    SetExclusivity(TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER','SnipeASentD',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
xDoorOpenedx:
    Log("Door Opened");
    SetExclusivity(TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_Attack,9,,'PLAYER','PLAYER','SnipeBSentD',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();

}

defaultproperties
{
}
