//=============================================================================
// P_1_1_0_Tbilisi_BGLazar
//=============================================================================
class P_1_1_0_Tbilisi_BGLazar extends EPattern;

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
        if (P.name == 'ERussianCivilian0')
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
    Log("This is the pattern for Background NPC Lazar.");
    Log("FIRST AREA.");
ALazar:
    Log("");
    ResetGroupGoals();
    ChangeGroupState('s_default');
JRLazLoop:
    JumpRandom('ARoute', 0.34, 'BRoute', 0.67, 'CRoute', 1.00, , , ,); 
ARoute:
    Log("");
    Teleport(1, 'Start2io');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Start1io',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('JRLazLoop');
BRoute:
    Log("");
    Teleport(1, 'Start1io');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Start3io',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('JRLazLoop');
CRoute:
    Log("");
    Teleport(1, 'Start5io');
    Goal_Set(1,GOAL_MoveTo,9,,,,'Start4io',,FALSE,,MOVE_WalkRelaxed,,MOVE_WalkRelaxed);
    WaitForGoal(1,GOAL_MoveTo,);
    Jump('JRLazLoop');
    End();
ManDown:
    Log("Checking if Lazar is Dead");
    CheckIfIsDead(1,'DeadLazar');
    End();
DeadLazar:
    SendPatternEvent('LambertAI','BloodyMurder');
    End();
DoNothing:
    Log("Doing nothing");
    End();

}

