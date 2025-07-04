//=============================================================================
// P_2_1_2_CIA_RainGuardPatrols
//=============================================================================
class P_2_1_2_CIA_RainGuardPatrols extends EPattern;

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
        if(P.name == 'ECIASecurity0')
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
Milestone:
    Log("Milestone");
    CheckFlags(V2_1_2CIA(Level.VarObject).MichWentHiding,FALSE,'End');
    ResetGoals(1);
    ChangeState(1,'s_investigate');
    Goal_Set(1,GOAL_MoveTo,9,,,,'FirstRainGuardE',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Default(1,GOAL_Patrol,8,,,,'FirstRainGuardE',,FALSE,,MOVE_Search,,MOVE_Search);
End:
    End();

}

