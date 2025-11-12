//=============================================================================
// P_2_1_2_CIA_SittingG
//=============================================================================
class P_2_1_2_CIA_SittingG extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
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
        if (P.name == 'ECIASecurity15')
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
AlsoFromEarlyFudge:
    Log("AlsoFromEarlyFudge");
    ResetGoals(1);
    ChangeState(1,'s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'FaggyDudueChairPApatrolA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Patrol,8,,,,'FaggyDudueChairPApatrolA',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Sleep(3);
    ePawn(Characters[1].Pawn).Bark_Type = BARK_LookingForYou;
    Talk(ePawn(Characters[1].Pawn).Sounds_Barks, 1, 0, false);
    End();

}

