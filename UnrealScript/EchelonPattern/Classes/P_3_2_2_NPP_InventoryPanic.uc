//=============================================================================
// P_3_2_2_NPP_InventoryPanic
//=============================================================================
class P_3_2_2_NPP_InventoryPanic extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('OhNo');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('OhNo');
            break;
        case AI_PLAYER_CLOSE:
            EventJump('OhNo');
            break;
        case AI_PLAYER_FAR:
            EventJump('OhNo');
            break;
        case AI_PLAYER_VERYCLOSE:
            EventJump('OhNo');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('OhNo');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('OhNo');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('OhNo');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('OhNo');
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
        if (P.name == 'EMercenaryTechnician0')
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
OhNo:
    Log("The mercenary technician is shitting a baby.");
    Goal_Set(1,GOAL_MoveTo,9,,'InvTechFocus','InvTechFocus','InventoryTechCowerPoint',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Stop,7,,'InvTechFocus','InvTechFocus',,'PrsoCrAlBB0',FALSE,9999999,,,);
    End();

}

defaultproperties
{
}
