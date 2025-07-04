//=============================================================================
// P_3_3_2_Mine_LonerStartPatrol
//=============================================================================
class P_3_3_2_Mine_LonerStartPatrol extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
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
Milestone:
    Log("Milestone");
addconversationsound:
    Talk(None, 1, , TRUE, 0);
    Sleep(1);
    Close();
    Goal_Set(1,GOAL_MoveTo,9,,,,'spetsnazloner_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Patrol,8,,,,'spetsnazloner_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_2MiningTown(Level.VarObject).GameplayServersAlerted,TRUE);
    SendPatternEvent('Ore','Milestone');
    End();

}

defaultproperties
{
}
