//=============================================================================
// P_3_3_2_Mine_Maintenance
//=============================================================================
class P_3_3_2_Mine_Maintenance extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('DeadZone');
            break;
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
        if (P.name == 'EMercenaryTechnician0')
            Characters[1] = P.controller;
        if (P.name == 'spetsnaz0')
            Characters[2] = P.controller;
        if (P.name == 'spetsnaz2')
            Characters[3] = P.controller;
        if (P.name == 'ELambert1')
            Characters[4] = P.controller;
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
    Log("MilestoneMaintenance");
    Sleep(1);
addconversationsound:
    Talk(None, 3, , TRUE, 0);
    Talk(None, 2, , TRUE, 0);
    Sleep(1);
    Close();
    Goal_Default(3,GOAL_Patrol,9,,,,'HoledMaintNodeB',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    CheckFlags(V3_3_2MiningTown(Level.VarObject).GameplayOreBottomAlerted,TRUE,'NewPositionMT');
    End();
NewPositionMT:
    Log("NewPositionMT");
    Goal_Set(1,GOAL_MoveTo,9,,,,'PostInMaintA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,,,'PostInMaintA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
DeadZone:
    Log("DeadZone");
    CheckIfIsDead(1,'FirstDeath');
    End();
FirstDeath:
    Log("FirstDeath");
    CheckFlags(V3_3_2MiningTown(Level.VarObject).NoKillOneDone,TRUE,'SecondDeath');
    SetFlags(V3_3_2MiningTown(Level.VarObject).NoKillOneDone,TRUE);
    Speech(Localize("P_3_3_2_Mine_Maintenance", "Speech_0005L", "Localization\\P_3_3_2MiningTown"), None, 4, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    End();
SecondDeath:
    Log("SecondDeath");
    SetProfileDeletion();
    Speech(Localize("P_3_3_2_Mine_Maintenance", "Speech_0006L", "Localization\\P_3_3_2MiningTown"), None, 4, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    GameOver(false, 0);
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_2MiningTown(Level.VarObject).GameplayMaintenanceAlerted,TRUE);
    End();

}

defaultproperties
{
}
