//=============================================================================
// P_1_7_1_2_TorpedoDefendA
//=============================================================================
class P_1_7_1_2_TorpedoDefendA extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('GoFalseTorpedoDefendA');
            break;
        case AI_SEE_INTERROGATION:
            EventJump('GoFalseTorpedoDefendA');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('GoFalseTorpedoDefendA');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('GoFalseTorpedoDefendA');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('GoFalseTorpedoDefendA');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('GoFalseTorpedoDefendA');
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
        if(P.name == 'spetsnaz11')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz13')
            Characters[2] = P.controller;
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
MilestoneTorpedoDefendA:
    Log("MilestoneTorpedoDefendA");
    ToggleGroupAI(TRUE, 'TorpedoDefendA', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__', 'UNUSED_GROUP_TAG__');
    End();
ChargeTorpedoDefendA:
    Log("ChargeTorpedoDefendA");
    Sleep(1.5);
    SendPatternEvent('TorpedoDefendC','CommTorpedoDefendC');
    Goal_Set(1,GOAL_MoveAndAttack,9,,,,'GreNodeA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,8,,'GreT','GreT','GreNodeA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveAndAttack,9,,,,'BreachTeamTelA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(2,GOAL_Attack,8,,'GreT','GreT','BreachTeamTelA',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
GoFalseTorpedoDefendA:
    Log("GoFalseTorpedoDefendA");
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}
