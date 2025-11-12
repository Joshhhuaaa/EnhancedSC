//=============================================================================
// P_1_1_0_Tbilisi_BGAnton
//=============================================================================
class P_1_1_0_Tbilisi_BGAnton extends EPattern;

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_UNCONSCIOUS:
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
    Log("FIRST AREA .");
AAnton:
    Log("");
    ResetGroupGoals();
    ChangeGroupState('s_default');
JRAntLoop:
    JumpRandom('APath', 0.34, 'BPath', 0.67, 'CPath', 1.00, , , ,); 
APath:
    Log("");
    Teleport(1, 'Start1io');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Start2io',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('JRAntLoop');
BPath:
    Log("");
    Teleport(1, 'Start3io');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Start1io',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('JRAntLoop');
CPath:
    Log("");
    Teleport(1, 'Start4io');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Start5io',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('JRAntLoop');
    End();
ManDown:
    Log("Checking if Anoton is dead");
    CheckIfIsDead(1,'DeadAnton');
    End();
DeadAnton:
    Log("Sam has killed Anton");
    SendPatternEvent('LambertAI','BloodyMurder');
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

