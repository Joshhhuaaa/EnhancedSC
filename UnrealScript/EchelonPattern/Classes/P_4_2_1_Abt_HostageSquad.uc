//=============================================================================
// P_4_2_1_Abt_HostageSquad
//=============================================================================
class P_4_2_1_Abt_HostageSquad extends EPattern;

#exec OBJ LOAD FILE=..\Sounds\S4_2_1Voice.uax

// FLAGS ///////////////////////////////////////////////////////////////////////



// EVENTS //////////////////////////////////////////////////////////////////////

function EventCallBack(EAIEvent Event,Actor TriggerActor)
{
    if (!bDisableMessages)
    {
        switch (Event.EventType)
        {
        case AI_DEAD:
            EventJump('CheckDead');
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
        if (P.name == 'EGeorgianSoldier20')
        {
            Characters[1] = P.controller;
            EAIController(Characters[1]).bAllowKnockout = true;
            EAIController(Characters[1]).bWasFound = true;
        }
        if (P.name == 'EGeorgianSoldier21')
        {
            Characters[2] = P.controller;
            EAIController(Characters[2]).bAllowKnockout = true;
            EAIController(Characters[2]).bWasFound = true;
        }
        if (P.name == 'EGeorgianSoldier30')
        {
            Characters[3] = P.controller;
            EAIController(Characters[3]).bAllowKnockout = true;
            EAIController(Characters[3]).bWasFound = true;
        }
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
HosSquad:
    Log("");
    ResetGroupGoals();
    Goal_Set(1,GOAL_MoveTo,9,,'PathNode348',,'PathNode357',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(1,GOAL_Wait,8,,'PathNode348',,'PathNode357','TalkStNmCC0',FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(2,GOAL_MoveTo,9,,'PathNode357',,'PathNode349',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(2,GOAL_Guard,8,,'PathNode357',,'PathNode349',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Set(3,GOAL_MoveTo,9,,'PathNode357',,'PathNode348',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Goal_Default(3,GOAL_Guard,8,,'PathNode357',,'PathNode348',,FALSE,,MOVE_WalkNormal,,MOVE_WalkNormal);
    Jump('CheckDead');
Speach2:
    Log("");
    Talk(Sound'S4_2_1Voice.Play_42_31_02', 2, , FALSE, 0);
    Talk(Sound'S4_2_1Voice.Play_42_31_03', 1, , FALSE, 0);
CheckDead:
    Log("");
GA:
    CheckIfIsDead(1,'GB');
    CheckIfIsUnconscious(1,'GB');
    Sleep(1.5);
    Jump('CheckDead');
GB:
    Log("");
    CheckIfIsDead(2,'GC');
    CheckIfIsUnconscious(2,'GC');
    Sleep(1.5);
    Jump('CheckDead');
GC:
    Log("");
    CheckIfIsDead(3,'JumpFin');
    CheckIfIsUnconscious(3,'JumpFin');
    Sleep(1.5);
    Jump('CheckDead');
JumpFin:
    Log("");
    GoalCompleted('StopSoldier');
    End();

}

