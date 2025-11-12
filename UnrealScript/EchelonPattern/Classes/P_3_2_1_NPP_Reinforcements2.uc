//=============================================================================
// P_3_2_1_NPP_Reinforcements2
//=============================================================================
class P_3_2_1_NPP_Reinforcements2 extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_SEE_PLAYER_ALERT:
            EventJump('Exclu');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
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
        if (P.name == 'EFalseRussianSoldier8')
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
Send:
    Log("Second down, reinforcement 2 incoming.");
    SetExclusivity(FALSE);
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_Stop,9,,,,,,FALSE,2.22,,,);
    Goal_Set(1,GOAL_MoveTo,8,,,,'ReinforceNode3',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,7,,,,'RunLikeHell',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Patrol,4,,,,'Sifl_0',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    End();
Exclu:
    Log("Resets exclusivity of Reinforcement 2 guard.");
    SetExclusivity(FALSE);
    End();

}

defaultproperties
{
}
