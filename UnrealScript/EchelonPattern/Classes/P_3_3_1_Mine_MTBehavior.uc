//=============================================================================
// P_3_3_1_Mine_MTBehavior
//=============================================================================
class P_3_3_1_Mine_MTBehavior extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('Death');
            break;
        case AI_HEAR_SOMETHING:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_INVESTIGATE:
            EventJump('Alerted');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Alerted');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Alerted');
            break;
        case AI_UNCONSCIOUS:
            EventJump('ObjectiveFailed');
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
        if(P.name == 'EMercenaryTechnician0')
            Characters[1] = P.controller;
        if(P.name == 'ELambert1')
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
CutScene:
    Log("CutSceneMTBehavior");
    CinCamera(0, 'EFocusPointInCaveCut', 'FocusCutSceneCave',);
addconversationsound:
    Talk(None, 1, , TRUE, 0);
    Sleep(3);
    Close();
    Goal_Set(1,GOAL_MoveTo,9,,,,'TopMine5',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    CinCamera(1, 'EFocusPointInCaveCut', 'FocusCutSceneCave',);
    Goal_Set(1,GOAL_MoveTo,8,,,,'WoodNewHideA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_MoveTo,7,,,,'TopMine1',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Default(1,GOAL_Guard,6,,'SnowEvadeAAA','SnowEvadeAAA','TopMine1',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(2);
RandomStart:
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,6,,'SnowEvadeAAA','SnowEvadeAAA','TopMine1','CiggStNmBg0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_Action,);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,'SnowEvadeAAA','SnowEvadeAAA','TopMine1','CiggStNmNt0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_Action,);
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,'SnowEvadeAAA','SnowEvadeAAA','TopMine1','CiggStNmEd0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_Action,);
    JumpRandom('RandomStart', 0.50, 'RandomEnd', 1.00, , , , , , ); 
RandomEnd:
    Goal_Default(1,GOAL_Patrol,9,,,,'TopMine1',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
Death:
    Log("DeathMTBehavior");
    CheckFlags(V3_3_1MiningTown(Level.VarObject).LeadTechDone,FALSE,'ObjectiveFailed');
    CheckFlags(V3_3_1MiningTown(Level.VarObject).OneNoKillDone,TRUE,'TooMuchKill');
    SetFlags(V3_3_1MiningTown(Level.VarObject).OneNoKillDone,TRUE);
    Speech(Localize("P_3_3_1_Mine_MTBehavior", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    End();
ObjectiveFailed:
    Log("ObjectiveFailed");
    CheckFlags(V3_3_1MiningTown(Level.VarObject).LeadTechDone,TRUE,'End');
    SetProfileDeletion();
    Speech(Localize("P_3_3_1_Mine_MTBehavior", "Speech_0002L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(3);
    Close();
    GameOver(false, 0);
    End();
TooMuchKill:
    Log("TooMuchKill");
    SetProfileDeletion();
    Speech(Localize("P_3_3_1_Mine_MTBehavior", "Speech_0003L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    GameOver(false, 0);
End:
    End();
Alerted:
    Log("Alerted");
    SetFlags(V3_3_1MiningTown(Level.VarObject).InterroAlerted,TRUE);
    End();

}

defaultproperties
{
}
