//=============================================================================
// P_3_3_1_Mine_CivilFear
//=============================================================================
class P_3_3_1_Mine_CivilFear extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if(!bDisableMessages)
    {
        switch(Event.EventType)
        {
        case AI_DEAD:
            EventJump('KillDone');
            break;
        case AI_HEAR_RICOCHET:
            EventJump('ScaredHim');
            break;
        case AI_SEE_CHANGED_ACTOR:
            EventJump('ScaredHim');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('ScaredHim');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('ScaredHim');
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
        if(P.name == 'EAlison0')
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
Action1:
    Log("Action1CivilFear");
    ChangeState(1,'s_default');
    Goal_Set(1,GOAL_MoveTo,9,,,,'GrampsMoveA',,FALSE,,MOVE_DesignerWalk,,MOVE_DesignerWalk);
    Goal_Default(1,GOAL_Wait,8,,'GrampsFacesThere','GrampsFacesThere','GrampsMoveA',,FALSE,,MOVE_DesignerWalk,,MOVE_DesignerWalk);
addsoundconversation:
    Talk(None, 1, , TRUE, 0);
    Sleep(1);
    Close();
    End();
KillDone:
    Log("KillDone");
    SetFlags(V3_3_1MiningTown(Level.VarObject).OneNoKillDone,TRUE);
    Speech(Localize("P_3_3_1_Mine_CivilFear", "Speech_0001L", "Localization\\P_3_3_1MiningTown"), None, 2, 0, TR_HEADQUARTER, 0, false);
    Sleep(4);
    Close();
    End();
ScaredHim:
    Log("ScaredHim");
    Goal_Set(1,GOAL_Action,9,,'PLAYER','PLAYER',,'ReacStNmAA0',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_MoveTo,8,,,,'CivilWindow',,FALSE,,MOVE_DesignerWalk,,MOVE_DesignerWalk);
    WaitForGoal(1,GOAL_MoveTo,);
    Goal_Set(1,GOAL_Action,7,,,,,'3340Fart4',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
actionloop:
    Log("actionloop");
    ResetGoals(1);
    Goal_Set(1,GOAL_Action,9,,,,,'3340Fart5',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Goal_Set(1,GOAL_Action,8,,,,,'3340Fart6',FALSE,,,,);
    WaitForGoal(1,GOAL_Action,);
    Jump('actionloop');
    End();

}

defaultproperties
{
}
