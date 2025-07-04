//=============================================================================
// P_3_3_1_Mine_PowerHouse
//=============================================================================
class P_3_3_1_Mine_PowerHouse extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('DropPattern');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('DropPattern');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('DropPattern');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('DropPattern');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('DropPattern');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('DropPattern');
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
        if(P.name == 'spetsnaz11')
            Characters[1] = P.controller;
        if(P.name == 'spetsnaz10')
            Characters[2] = P.controller;
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
PowerOutSearch:
    Log("PowerOutSearchPowerHouse_Ground");
    SendPatternEvent('PowerOut','Milestone');
    SendPatternEvent('BogusAIForPatternTwo','Milestone');
    ResetGroupGoals();
    ChangeGroupState('s_alert');
    SetFlashLight(1, TRUE);
    SetFlashLight(2, TRUE);
    Goal_Set(1,GOAL_MoveTo,9,,,,'InsideNearPowerTrans',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(2,GOAL_MoveTo,9,,,,'CoverRoof',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_MoveTo,8,,,,'DoorPowerrF',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_MoveTo,8,,,,'PowerOutSearchNode',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_MoveTo,7,,,,'ExitPowerHouse',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_MoveTo,7,,,,'AnteUpLadderA',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(1,GOAL_Guard,6,,'EFocusPointForestFocElecA','EFocusPointForestFocElecA','ExitPowerHouse',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
    Goal_Set(2,GOAL_MoveTo,6,,,,'AnteUpLadder',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_MoveTo,5,,,,'ERoof4',,FALSE,,MOVE_Search,,MOVE_Search);
    Goal_Set(2,GOAL_Guard,4,,'LastPowerFoc','LastPowerFoc','ERoof5',,FALSE,,MOVE_Search,,MOVE_Search);
    Sleep(65);
    ResetGroupGoals();
    Goal_Set(2,GOAL_MoveTo,9,,,,'NewFtransqq',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'DoorPowerrF','DoorPowerrF','NewFtransqq',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,,,'ERoof4',,FALSE,,MOVE_WalkAlert,,MOVE_WalkAlert);
    Goal_Default(1,GOAL_Patrol,8,,,,'ERoof4',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Stress:
    Log("StressPowerHouse_Pipeclimb");
    Sleep(1);
    ChangeState(2,'s_investigate');
    SetFlashLight(2, TRUE);
    Goal_Set(2,GOAL_MoveTo,9,,'StressTagged','StressTagged','ExitPowerHouse',,FALSE,,MOVE_WalkRelaxed,,MOVE_CrouchWalk);
    WaitForGoal(2,GOAL_MoveTo,);
    Goal_Set(2,GOAL_Guard,9,,'StressTagged','StressTagged','ExitPowerHouse',,FALSE,,MOVE_CrouchWalk,,MOVE_CrouchWalk);
addconversationsound:
    Talk(None, 1, , TRUE, 0);
    Talk(None, 2, , TRUE, 0);
    Talk(None, 1, , TRUE, 0);
    Sleep(1);
    Close();
    ResetGroupGoals();
    Goal_Set(2,GOAL_MoveTo,9,,,,'NewFtransqq',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,8,,'DoorPowerrF',,'NuevoConsolePowerA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    Goal_Default(2,GOAL_Guard,7,,'DoorPowerrF','DoorPowerrF','NuevoConsolePowerA',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    End();
ExitWhileHOH:
    Log("ExitWhileHOH");
    Speech(Localize("P_3_3_1_Mine_PowerHouse", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 1, 0, TR_NPCS, 0, false);
    Sleep(2);
    Close();
    ResetGroupGoals();
    Goal_Set(2,GOAL_MoveTo,9,,,,'NewFtransqq',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,8,,,,'GuardTheBuilding',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,7,,,,'GuardTheBuilding',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(1,GOAL_MoveTo,9,,,,'tagtag1',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Guard,8,,,,'tagtag1',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
TheEnd:
    Log("TheEndPowerHouse");
    End();
DropPattern:
    Log("DropPattern");
    SetExclusivity(FALSE);
    SetFlags(V3_3_1MiningTown(Level.VarObject).PowerHouseAlerted,TRUE);
    End();

}

defaultproperties
{
}
