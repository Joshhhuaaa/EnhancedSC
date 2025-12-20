//=============================================================================
// P_1_2_2DefMin_ParkingRush
//=============================================================================
class P_1_2_2DefMin_ParkingRush extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('DeadFlag');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('KillNPC');
            break;
        case AI_UNCONSCIOUS:
            EventJump('DeadFlag');
            break;
        case AI_GRABBED: // Joshua - If player grabs the guard, Wilkes can stop shooting
            EventJump('DeadFlag');
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
        if (P.name == 'EGeorgianSoldier10')
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
    Log("MilestoneParkingRush");
    ChangeGroupState('s_alert');
    Goal_Set(1,GOAL_MoveTo,9,,,,'NearFarthestPoint',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'AttackWilkes',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Default(1,GOAL_Attack,7,,'EGarbageBinBB','EGarbageBinBB','AttackWilkes',,TRUE,,MOVE_JogAlert,,MOVE_JogAlert);
    End();
KillNPC:
    Log("KillNPC");
    CheckFlags(V1_2_2DefenseMinistry(Level.VarObject).WilkesKikinAss,FALSE,'PlayerSeen');
    KillNPC(1, FALSE, FALSE);
    End();
DeadFlag:
    Log("DeadFlag");
    SetFlags(V1_2_2DefenseMinistry(Level.VarObject).LastParkingGuyState,TRUE);
    SendPatternEvent('OutroAI','relax');
    End();

}

