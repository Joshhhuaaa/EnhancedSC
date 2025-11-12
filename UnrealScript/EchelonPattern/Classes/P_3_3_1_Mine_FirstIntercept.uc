//=============================================================================
// P_3_3_1_Mine_FirstIntercept
//=============================================================================
class P_3_3_1_Mine_FirstIntercept extends EPattern;

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
        if (P.name == 'spetsnaz0')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz35')
            Characters[2] = P.controller;
        if (P.name == 'spetsnaz23')
            Characters[3] = P.controller;
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
    Log("MilestoneFirstIntercept");
    Speech(Localize("P_3_3_1_Mine_FirstIntercept", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_NPCS, 0, false);
    Sleep(2);
    Speech(Localize("P_3_3_1_Mine_FirstIntercept", "Speech_0002L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_NPCS, 0, false);
    Sleep(1);
    Close();
StartScriptSniper:
    Log("StartScriptSniper");
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,,,'SniperScriptOne',,FALSE,,MOVE_CrouchJog,,MOVE_JogAlert);
    Goal_Default(3,GOAL_Guard,8,,'EFocusPointSnipe1B','EFocusPointSnipe1B','SniperScriptOne',,FALSE,,MOVE_CrouchJog,,MOVE_JogAlert);
    Sleep(12);
    ResetGoals(3);
    Goal_Set(3,GOAL_MoveTo,9,,,,'SniperScriptTwo',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Goal_Default(3,GOAL_Guard,8,,'CloserSnipePoint','CloserSnipePoint','SniperScriptTwo',,FALSE,,MOVE_CrouchJog,,MOVE_CrouchJog);
    Sleep(8);
    Jump('StartScriptSniper');
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_1MiningTown(Level.VarObject).FirstHousesAlerted,TRUE);
    End();

}

defaultproperties
{
}
