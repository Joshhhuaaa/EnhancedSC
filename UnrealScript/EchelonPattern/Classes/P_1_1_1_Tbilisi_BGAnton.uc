//=============================================================================
// P_1_1_1_Tbilisi_BGAnton
//=============================================================================
class P_1_1_1_Tbilisi_BGAnton extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('ManDown');
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
        if (P.name == 'ERussianCivilian6')
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
    Log("This is the pattern for Background NPC Anton.");
    Log("SECOND AREA");
BAnton:
    Log("");
    CheckIfIsDead(1,'DoNothing');
    ResetNPC(1,FALSE);
    ResetGroupGoals();
    ChangeGroupState('s_default');
    Teleport(1, 'Chillin');
    Goal_Set(1,GOAL_Guard,9,,'CivilianFocus',,'Chillin',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
    Log("THIRD AREA");
CAnton:
    Log("");
    CheckIfIsDead(1,'DoNothing');
    ResetNPC(1,FALSE);
    Teleport(1, 'Anton_100');
    ChangeGroupState('s_default');
    ResetGroupGoals();
    Goal_Default(1,GOAL_Guard,0,,'CopsFocus',,'Anton_0',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
PatrolC:
    Log("Anton stops watching the cops and starts patrolling");
    Goal_Default(1,GOAL_Patrol,0,,,,'Anton_100',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    End();
    Log("FOURTH AREA");
DAnton:
    Log("This is Antons pattern for Morevi square");
    CheckIfIsDead(1,'DoNothing');
    ResetNPC(1,FALSE);
    ChangeGroupState('s_default');
    ResetGroupGoals();
Randomizer:
    JumpRandom('Dapart', 0.60, 'Dalley', 1.00, , , , , ,);
Dapart:
    Log("");
    Teleport(1, 'Anton10Apt');
    Goal_Default(1,GOAL_Guard,0,,'AntonsWestWindow',,'Anton20Apt',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(12);
    Goal_Default(1,GOAL_Guard,0,,'AntonsSouthWindow',,'Anton30Apt',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(12);
    Goal_Set(1,GOAL_MoveTo,9,,,,'Anton10Apt',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('Randomizer');
Dalley:
    Log("");
    Teleport(1, 'AlleyB');
    Goal_Set(1,GOAL_MoveTo,9,,,,'AlleyA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('Dapart');
    End();
    Log("FIFTH AREA");
AntonEnder:
    Log("This is Antons final stuff.");
    CheckIfIsDead(1,'DoNothing');
    Teleport(1, 'AntonLastio');
    ResetNPC(1,FALSE);
    ChangeGroupState('s_default');
EnderLoopy:
    ResetGroupGoals();
    Goal_Default(1,GOAL_Guard,0,,'AntWinB',,'AntonWindowB',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Sleep(20);
    Goal_Set(1,GOAL_MoveTo,9,,'AntWinA',,'AntonWindowA',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    WaitForGoal(1,GOAL_MoveTo,);
    Sleep(15);
    Jump('EnderLoopy');
    End();
ManDown:
    Log("Checking if Anton has been killed");
    CheckIfIsDead(1,'DeadAnton');
    End();
DeadAnton:
    SendPatternEvent('LambertAI','BloodyMurder');
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

