//=============================================================================
// P_2_1_1_CIA_GuardPost
//=============================================================================
class P_2_1_1_CIA_GuardPost extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('Out');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('Out');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Out');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Out');
            break;
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
        if(P.name == 'ECIASecurity5')
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
Start:
    Log("");
    SetExclusivity(TRUE);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'PathNode82',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(3);
    SetExclusivity(FALSE);
    End();
Out:
    Log("");
    SetExclusivity(FALSE);
    End();

}

