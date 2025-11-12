//=============================================================================
// P_4_1_1_CEmb_ContactLeaving
//=============================================================================
class P_4_1_1_CEmb_ContactLeaving extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_PLAYER_VERYCLOSE:
            EventJump('PlayerIsClose');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('KnockedEtc');
            break;
        case AI_UNCONSCIOUS:
            EventJump('KnockedEtc');
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
        if (P.name == 'ECIABureaucrat0')
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
Milestone:
    Log("Milestone");
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'WaitHere',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(1,GOAL_Guard,8,,'BarilCheckA',,'WaitHere',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
KnockedEtc:
    Log("DontDoIt");
    SendPatternEvent('GameOverBogus','MissionFailed');
    End();
PlayerIsClose:
    Log("PlayerIsClose");
    Goal_Default(1,GOAL_Wait,9,,'PLAYER','PLAYER',,,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();

}

