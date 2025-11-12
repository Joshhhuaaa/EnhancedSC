//=============================================================================
// P_1_3_3OilRig_PostHubOthers2
//=============================================================================
class P_1_3_3OilRig_PostHubOthers2 extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_HEAR_RICOCHET:
            EventJump('Exclu');
            break;
        case AI_SEE_PLAYER_ALERT:
            EventJump('Exclu');
            break;
        case AI_SEE_PLAYER_SURPRISED:
            EventJump('Exclu');
            break;
        case AI_TAKE_DAMAGE:
            EventJump('Exclu');
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
        if (P.name == 'EGeorgianSoldier14')
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
Tele:
    Log("Code 9 beam up.");
    SendUnrealEvent('MachiDestructZoneAI');
    SetExclusivity(TRUE);
    Teleport(1, 'destructo2');
    Goal_Set(1,GOAL_Wait,1,,'PiotrDeux','PiotrDeux',,,FALSE,,,,);
    ChangeGroupState('s_alert');
    End();
MachiDestructGuys:
    Log("What are you doing Dave?");
    ResetGoals(1);
    DisableMessages(TRUE, FALSE);
    Goal_Set(1,GOAL_Stop,9,,'PiotrDeux','PiotrDeux',,,FALSE,1.345,,,);
    Goal_Set(1,GOAL_Attack,8,,'RightComp','RightComp',,,TRUE,1,,,);
    Goal_Set(1,GOAL_Attack,7,,'MiddleComp','MiddleComp',,,TRUE,1,,,);
    Goal_Set(1,GOAL_Attack,6,,'LeftComp','LeftComp',,,TRUE,1,,,);
    Goal_Set(1,GOAL_MoveTo,5,,,,'otherdestructo',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    WaitForGoal(1,GOAL_MoveTo,);
    DisableMessages(FALSE, FALSE);
    Goal_Set(1,GOAL_Attack,9,,'ee','ee',,,TRUE,,,,);
    Goal_Set(1,GOAL_MoveTo,7,,,,'destructo1',,FALSE,,MOVE_JogAlert,,MOVE_JogAlert);
    Goal_Set(1,GOAL_Attack,8,,'eee','eee',,,TRUE,,,,);
    Goal_Set(1,GOAL_Attack,6,,'eeee','eeee',,,TRUE,,,,);
    Goal_Set(1,GOAL_Attack,5,,'eeeee','eeeee',,,TRUE,,,,);
    Goal_Set(1,GOAL_Attack,4,,'eeeeee','eeeeee',,,TRUE,4,,,);
    Goal_Set(1,GOAL_Attack,3,,'eeeeeee','eeeeeee',,,TRUE,,,,);
    Goal_Set(1,GOAL_Attack,2,,'BendOverTojo','BendOverTojo',,,TRUE,300,,,);
    Goal_Set(1,GOAL_Attack,1,,'BeforeExtinguisher','BeforeExtinguisher',,,TRUE,,,,);
    End();
Exclu:
    Log("Resets PostHubOthers2 to exclusivity false.");
    SetExclusivity(FALSE);
    End();
HubPatrol:
    Log("The stuff has been destroyed, now activating the Hub Patrol pattern.   Station.");
    SetExclusivity(FALSE);
    ResetGoals(1);
    ChangeState(1,'s_investigate');
    Goal_Default(1,GOAL_Patrol,1,,,,'GuardTheMojo',,FALSE,,,,);
    End();
Alert:
    Log("Alert focus mojo for Hub Patrol.");
    ChangeState(1,'s_alert');
    Sleep(3);
    ChangeState(1,'s_investigate');
    End();
JerkOff:
    Log("It doesn't matter what's right, it's only wrong if you get caught.");
    KillNPC(1, FALSE, FALSE);
    End();

}

