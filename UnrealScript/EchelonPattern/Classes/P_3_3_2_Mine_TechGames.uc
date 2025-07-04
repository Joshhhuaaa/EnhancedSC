//=============================================================================
// P_3_3_2_Mine_TechGames
//=============================================================================
class P_3_3_2_Mine_TechGames extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
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
        if(P.name == 'EMercenaryTechnician3')
            Characters[1] = P.controller;
        if(P.name == 'EMercenaryTechnician5')
            Characters[2] = P.controller;
        if(P.name == 'EMercenaryTechnician4')
            Characters[3] = P.controller;
        if(P.name == 'ELambert1')
            Characters[4] = P.controller;
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
ActionOne:
    Log("ActionOneTechGames");
    Goal_Set(3,GOAL_MoveTo,9,,,,'TechGames1',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_Guard,8,,'TechGamesFocus4','TechGamesFocus4','TechGames1',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(10);
    ResetGoals(3);
    Goal_Default(3,GOAL_Wait,7,,,,,'KbrdAsNmNt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
ActionTwo:
    Log("ActionTwoTechGames");
    CheckFlags(V3_3_2MiningTown(Level.VarObject).GameplayMineFirstAlerted,FALSE,'End');
    Sleep(2);
    Goal_Set(3,GOAL_MoveTo,9,,,,'TechGames1',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_Guard,8,,'TechGamesFocus4','TechGamesFocus4','TechGames1',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,,,'TechGames2',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_Guard,8,,'TechGamesFocus1','TechGamesFocus1','TechGames2',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(15);
    ResetGoals(3);
    Goal_Set(3,GOAL_Wait,7,,,,,'KbrdAsNmNt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    ResetGoals(1);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ThreeMTGuardFokus',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,8,,,,'TechGames3',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Wait,7,,'EFocusPointLastTechFoc','EFocusPointLastTechFoc','TechGames3','KbrdAsNmNt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
DeadZone:
    Log("DeadZone");
    CheckFlags(V3_3_2MiningTown(Level.VarObject).NoKillOneDone,TRUE,'TooMuchDead');
    SetFlags(V3_3_2MiningTown(Level.VarObject).NoKillOneDone,TRUE);
    Speech(Localize("P_3_3_2_Mine_TechGames", "Speech_0001L", "Localization\\P_3_3_2MiningTown"), None, 4, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    End();
TooMuchDead:
    Log("TooMuchDead");
    SetProfileDeletion();
    Speech(Localize("P_3_3_2_Mine_TechGames", "Speech_0002L", "Localization\\P_3_3_2MiningTown"), None, 4, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    GameOver(false, 0);
End:
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_2MiningTown(Level.VarObject).GameplayServersAlerted,TRUE);
    SendPatternEvent('Ore','Milestone');
    End();

}

defaultproperties
{
}
