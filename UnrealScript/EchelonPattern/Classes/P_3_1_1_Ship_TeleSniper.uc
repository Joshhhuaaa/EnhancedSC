//=============================================================================
// P_3_1_1_Ship_TeleSniper
//=============================================================================
class P_3_1_1_Ship_TeleSniper extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('TeleSniper');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('TeleSniper');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('TeleSniper');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('TeleSniper');
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
        if (P.name == 'spetsnaz3')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz2')
            Characters[2] = P.controller;
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
TeleSniper:
    Log("teleport new guard near the snipper guard");
    DisableMessages(TRUE, FALSE);
    Teleport(2, 'PathNode');
    Goal_Set(2,GOAL_MoveTo,9,,,,'spetsnaz1_275',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}
