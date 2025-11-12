//=============================================================================
// P_3_3_2_Mine_MinerFirst
//=============================================================================
class P_3_3_2_Mine_MinerFirst extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////

var int Underway;


// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('Milestone');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('SpottedAlarmBound');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('SpottedAlarmBound');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('SpottedAlarmBound');
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
        if (P.name == 'ERussianMiner0')
            Characters[1] = P.controller;
        if (P.name == 'ELambert1')
            Characters[2] = P.controller;
    }

    if (!bInit)
    {
    bInit=TRUE;
    Underway=0;
    }

}


// PATTERN /////////////////////////////////////////////////////////////////////

state Pattern
{

Begin:
Milestone:
    Log("Milestone");
    CheckFlags(V3_3_2MiningTown(Level.VarObject).NoKillOneDone,TRUE,'LastKill');
    SetFlags(V3_3_2MiningTown(Level.VarObject).NoKillOneDone,TRUE);
    Speech(Localize("P_3_3_2_Mine_MinerFirst", "Speech_0001L", "Localization\\P_3_3_2MiningTown"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    End();
LastKill:
    Log("LastKill");
    SetProfileDeletion();
    Speech(Localize("P_3_3_2_Mine_MinerFirst", "Speech_0002L", "Localization\\P_3_3_2MiningTown"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    GameOver(false, 0);
    End();
SpottedAlarmBound:
    Log("SpottedAlarmBound");
    SetFlags(V3_3_2MiningTown(Level.VarObject).GameplayServersAlerted,TRUE);
    CheckFlags(Underway,TRUE,'End');
    SetFlags(Underway,TRUE);
    SendPatternEvent('Ore','Milestone');
    DisableMessages(TRUE, FALSE);
    Goal_Set(1,GOAL_Action,9,,,,,'3335min2',TRUE,,,,);
    WaitForGoal(1,GOAL_Action,);
    DisableMessages(FALSE, FALSE);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'Mineralarm',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_InteractWith,8,,,,'EAlarmPanelForMiners',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_InteractWith,);
    SetExclusivity(FALSE);
End:
    End();

}

defaultproperties
{
}
