//=============================================================================
// P_3_2_1_NPP_StairCrash
//=============================================================================
class P_3_2_1_NPP_StairCrash extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('Exclu');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Exclu');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Exclu');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Exclu');
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
        if(P.name == 'EFalseRussianSoldier11')
            Characters[1] = P.controller;
        if(P.name == 'EFalseRussianSoldier7')
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
ComingDown:
    Log("Sam has passed the threshold of the stairs, send the two guys down.");
    Goal_Set(1,GOAL_MoveTo,9,,,,'TopOStairsNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'BottomOStairsNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,7,,,,'LobbyNode2',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Patrol,6,,,,'Dave_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,7,,,,'LobbyNode1',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'TopOStairsNode',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Set(2,GOAL_MoveTo,8,,,,'BottomOStairsNode',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,6,,,,'BathroomNode1',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(2,GOAL_Patrol,5,,,,'Nate_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
Exclu:
    Log("Staircrash exclusivity reset.");
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}
