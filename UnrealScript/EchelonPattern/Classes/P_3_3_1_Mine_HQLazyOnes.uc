//=============================================================================
// P_3_3_1_Mine_HQLazyOnes
//=============================================================================
class P_3_3_1_Mine_HQLazyOnes extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
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
        if (P.name == 'spetsnaz18')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz19')
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
Alerted:
    Log("Alerted");
    SetFlags(V3_3_1MiningTown(Level.VarObject).InsideHQAlerted,TRUE);
    End();
WasNotStealthOutside:
    Log("WasNotStealthOutside");
    CheckFlags(V3_3_1MiningTown(Level.VarObject).OutsideHQAlerted,TRUE,'GoCheck');
    End();
GoCheck:
    Log("GoCheck");
    Goal_Set(2,GOAL_MoveTo,9,,,,'PostPatrolBTMC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(2,GOAL_MoveTo,);
    Goal_Default(2,GOAL_Guard,8,,'ELightToLookAA','ELightToLookAA','PostPatrolBTMC',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(4);
    ResetGoals(2);
    Goal_Set(2,GOAL_MoveTo,9,,,,'HQLazyAAAA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,8,,'Build3','Build3','HQLazyAAAA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();

}

defaultproperties
{
}
