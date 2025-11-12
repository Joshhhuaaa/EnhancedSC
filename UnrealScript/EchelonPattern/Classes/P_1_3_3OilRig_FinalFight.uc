//=============================================================================
// P_1_3_3OilRig_FinalFight
//=============================================================================
class P_1_3_3OilRig_FinalFight extends EPattern;

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
        if (P.name == 'EGeorgianSoldier18')
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
Fight:
    Log("Teleport the last dude in and start him a' firin'.");
    SendUnrealEvent('LastHurdleEnable');
    ChangeState(1,'s_alert');
    Teleport(1, 'Blitzkrieg');
    Goal_Set(1,GOAL_MoveTo,9,,,,'BlitzkriegTwo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,6,,'FinalTargetOne','FinalTargetOne',,'PeekStNtLt2',TRUE,15,,,);
    Goal_Default(1,GOAL_Patrol,2,,,,'TotallyOnBroadway',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
JerkOff:
    Log("Punishment is cure for those who dare to cross the line but it must not be true for jerk-offs just like you.");
    KillNPC(1);
    End();

}

